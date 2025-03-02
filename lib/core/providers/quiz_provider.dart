import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:island_social_development/controllers/firestore_controller.dart';
import 'package:island_social_development/core/utils/shared_prefrence.dart';
import 'package:island_social_development/models/competition_model.dart';
import 'package:island_social_development/models/fam_answer.dart';
import 'package:island_social_development/models/question_model.dart';
import 'package:island_social_development/models/quiz_model.dart';
import 'package:island_social_development/models/user_model.dart';

class QuizProvider with ChangeNotifier {
  QuizProvider() {
    focusNode = FocusNode();
    focusNode.addListener(_onFocusChange);
    getCurrentuser();
    loadResults();
    getAllFamily();
    getAllQuizes();
  }

  QuestionModel? dailyQuestion;
  late Timer timer;
  int remainingTime = 0;
  UserModel? currentUser;
  SharedPreferencesHelper prefsHelper = SharedPreferencesHelper();

  void startTimer(int time) {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingTime > 0) {
        remainingTime--;
      } else {
        timer.cancel();
      }
    });
  }

  Future<UserModel?>? getCurrentuser() async {
    currentUser = await prefsHelper.getUserModel();
    if (currentUser != null) {
      checkCategory();
      return currentUser;
    }
    return null;
  }

  String checkCategory() {
    if (currentUser!.age! > 12) {
      return "youth";
    } else {
      return "kids";
    }
  }

  ///متغيرات المسابقة
  GlobalKey<FormState> competitioKey = GlobalKey();
  TextEditingController contestName = TextEditingController();
  TextEditingController conestlenght = TextEditingController();
  TextEditingController timerController = TextEditingController();
  TextEditingController ramdandate = TextEditingController();
  TextEditingController ramdanName = TextEditingController();
  int timercount = 0;

  ///متغيرات الاسئلة
  GlobalKey<FormState> questionKey = GlobalKey();
  TextEditingController questionController = TextEditingController();
  TextEditingController quizoptionA = TextEditingController();
  TextEditingController quizoptionB = TextEditingController();
  TextEditingController quizoptionC = TextEditingController();
  TextEditingController quizoptionD = TextEditingController();
  late FocusNode focusNode;
  bool isFocused = false;
  void _onFocusChange() {
    isFocused = focusNode.hasFocus;
    notifyListeners();
  }

  cleartextfeilds() {
    questionController.clear();
    quizoptionA.clear();
    quizoptionB.clear();
    quizoptionC.clear();
    quizoptionD.clear();
  }

  String dropdownvalue2 = 'A';
  String dropdownvalue = 'A';
  int category = 0;

  void chaneCategory(int newcategory) {
    category = newcategory;
    notifyListeners();
  }

//////////////////////////////////////////////////////////////////أنواع المسابقات
  int type = 1;

  void changetype(int newtype) {
    type = newtype;
    notifyListeners();
  }

  String getCategory(int categoryNumber) {
    return categoryNumber == 1 ? "youth" : "kids";
  }

  String getType(int typeNumber) {
    switch (typeNumber) {
      case 1:
        return "islamic";
      case 2:
        return "scientific";
      case 3:
        return "general";
      default:
        throw Exception("النوع غير صحيح");
    }
  }

  CompetitionModel? competitionModel;

  CompetitionModel addComptition() {
    competitionModel = CompetitionModel(
        id: "",
        title: contestName.text,
        questionCount: int.parse(conestlenght.text),
        questions: [],
        timer: int.parse(timerController.text));
    FireStoreController.fireStoreHelper.addCompetition(
        category: getCategory(category),
        type: getType(type),
        competition: competitionModel!);

    notifyListeners();
    return competitionModel!;
  }

  String? validateCompetitionName(String value) {
    if (value.isEmpty) {
      return 'يرجى ادخال اسم المسابقة ';
    }
    return null;
  }

  String? validateRamdanName(String value) {
    if (value.isEmpty) {
      return 'يرجى ادخال اسم المسابقة ';
    }
    return null;
  }

  String? validateRamdan(String value) {
    if (value.isEmpty) {
      return 'يرجى ادخال تاريخ البدء ';
    }
    return null;
  }

  String? validateCompetitonLeth(String value) {
    if (value.isEmpty) {
      return ' يرجى تحديد عدد الاسئلة ';
    }
    return null;
  }

  String? validateOpetion(p0) {
    if (p0!.isEmpty) {
      return 'لا يمكن تر هذا الحقل فارغا';
    }
    return null;
  }
///////////////////////////////////////////////////////////////اسئلة مسابقات العائلة

  /////////////////////////////////////////الاسئلة
  int addedQuestion = 0;
  Future<bool> addNewQuestion(
      {required String competitionId,
      required int maxQuestions,
      required BuildContext context // 🔥 الحد الأقصى للأسئلة
      }) async {
    // إنشاء نموذج السؤال
    QuestionModel newQuestion = QuestionModel(
      id: "", // سيتم تعيينه تلقائيًا
      question: questionController.text,
      options: [
        quizoptionA.text,
        quizoptionB.text,
        quizoptionC.text,
        quizoptionD.text
      ],
      correctAnswer: dropdownvalue,
    );
    // 🔥 التحقق من إمكانية الإضافة
    bool success =
        await FireStoreController.fireStoreHelper.addQuestionToCompetition(
      context: context,
      category: getCategory(category),
      type: getType(type),
      competitionId: competitionId,
      maxQuestions: maxQuestions,
      question: newQuestion,
    );

    if (success) {
      addedQuestion++;
      questionController.clear();
      quizoptionA.clear();
      quizoptionB.clear();
      quizoptionC.clear();
      quizoptionD.clear();
      notifyListeners(); // تحديث الواجهة إذا تم الإضافة بنجاح
    }
    return success; // 🔥 إرجاع النتيجة (نجاح أو فشل)
  }

  List<CompetitionModel> competitions = [];
  CompetitionModel? youthGenral;
  CompetitionModel? youthscientific;
  CompetitionModel? youthislamic;
  CompetitionModel? kidsGenral;
  CompetitionModel? kidscientific;
  CompetitionModel? kidsislamic;
  CompetitionModel? SendyouthGenral(
    CompetitionModel competition,
  ) {
    competition = youthGenral!;
    notifyListeners();
    return youthGenral;
  }

  // Future<List<CompetitionModel>>? getCompetitions(
  //     BuildContext context, String type) async {
  //   competitions = await FireStoreController.fireStoreHelper
  //       .getCompetitions(category: checkCategory(), type: type);
  //   notifyListeners();
  //   return competitions;
  // }

  List<CompetitionModel> competitions2 = [];

  Future<List<CompetitionModel>>? getCompetitions2(
      String category, BuildContext context, String type) async {
    competitions2 = await FireStoreController.fireStoreHelper
        .getCompetitions(category: category, type: type);
    //print(competitions2.length);
    return competitions2;
  }

//////////////////////////////////////////////////////
  List<QuestionModel> FamQuestion = [];
  int addedFamQuestions = 0;
  int maxQuestions = 30;

  /// ✅ الحصول على عدد الأسئلة من `SharedPreferences` عند بدء التطبيق
  Future<void> loadFamQuestionsCount() async {
    addedFamQuestions = await prefsHelper.getFamQuestionsCount();
    notifyListeners();
  }

  Future<int> getLastQuestionNumber() async {
    var querySnapshot = await FirebaseFirestore.instance
        .collection('fam_questions')
        .orderBy('id', descending: true) // ✅ جلب آخر سؤال بناءً على الرقم
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return int.parse(querySnapshot.docs.first['id']); // ✅ استرجاع آخر رقم
    } else {
      return 0; // ✅ إذا لم يكن هناك أسئلة، نبدأ من 0
    }
  }

  Future<void> addNewQuestiontoFam1(String questionText, List<String> options,
      String correctAnswer, String name) async {
    if (addedFamQuestions < maxQuestions) {
      // ✅ اجلب آخر رقم تسلسلي من Firestore
      int lastQuestionNumber = await getLastQuestionNumber();

      // ✅ احسب الرقم الجديد
      int newQuestionNumber = lastQuestionNumber + 1;

      final question = QuestionModel(
        id: newQuestionNumber.toString(), // ✅ حفظ الرقم التسلسلي كـ ID
        question: questionText,
        options: options,
        correctAnswer: correctAnswer,
      );

      // ✅ حفظ السؤال في Firestore
      await FireStoreController.fireStoreHelper
          .addFamQuestionsToFirestore(name, question);

      // ✅ تحديث عدد الأسئلة المضافة
      addedFamQuestions++;
      await prefsHelper.saveFamQuestionsCount(addedFamQuestions);
      addedFamQuestions = await prefsHelper.getFamQuestionsCount();

      // ✅ إضافة السؤال للقائمة المحلية
      FamQuestion.add(question);
      questionController.clear();
      quizoptionA.clear();
      quizoptionB.clear();
      quizoptionC.clear();
      quizoptionD.clear();
      notifyListeners();
    } else {
      print("تم الوصول إلى الحد الأقصى للأسئلة");
    }
  }

  void cleartextfeilds2() {
    questionController.clear();
    quizoptionA.clear();
    quizoptionB.clear();
    quizoptionC.clear();
    quizoptionD.clear();
    dropdownvalue2 = 'A';
  }

  List<QuestionModel> questions2 = [];
  bool _isLoadingQuestions = false;
  bool get isLoadingQuestions => _isLoadingQuestions;
  Future<void> fetchQuestions(String type, String competitionId) async {
    _isLoadingQuestions = true;
    notifyListeners();

    questions2 = await FireStoreController.fireStoreHelper
        .getQuestions(checkCategory(), type, competitionId);
    _isLoadingQuestions = false;
    print(questions2.length);
    notifyListeners();
  }

  int score = 0;
  //النتيييجة
  Map<int, String> selectedAnswers = {}; // الإجابات المحددة
// قائمة الأسئلة
  void selectAnswer(int questionIndex, String option) {
    selectedAnswers[questionIndex] = option;
    notifyListeners();
  }

  String selectedFam = ';';

  String? getSelectedAnswer(int questionIndex) {
    return selectedAnswers[questionIndex];
  }

  void selectFamAnswer(String option) {
    selectedFam = option;
    notifyListeners();
  }

  String? getSelectedFamAnswer() {
    return selectedFam;
  }

  // دالة لحساب النتيجة
  int calculateScore() {
    score = 0;
    for (int i = 0; i < questions2.length; i++) {
      if (selectedAnswers[i] == questions2[i].correctAnswer) {
        score++;
      }
    }
    return score;
  }

  // دالة لتخزين النتيجة باستخدام FirestoreHelper
  Future<void> saveResult(
    String cometitonName,
    int count,
  ) async {
    UserModel? user = await prefsHelper.getUserModel();
    // استدعاء دالة التخزين من الـ Helper
    await FireStoreController.fireStoreHelper
        .saveResult(user!.id!, user.name!, score, cometitonName, count);
    notifyListeners();
    score = 0;
  }

  void reset() {
    selectedAnswers.clear(); // مسح جميع الإجابات المحددة
    notifyListeners();
  }

  List<Map<String, dynamic>> results = []; // قائمة لتخزين النتائج

  // دالة لتحميل النتائج من Firestore
  Future<void> loadResults() async {
    // استرجاع البيانات من Firestore
    results = await FireStoreController.fireStoreHelper.getResults();
    notifyListeners(); // إشعار المتابعين بتحديث الحالة
  }

  ///////////////////////////
  bool userAnswer = false;
  bool isQuizCompleted(
    String competitionId,
  ) {
    userAnswer = results.any((quiz) =>
        quiz['cometitionName'] == competitionId &&
        quiz['userName'] == currentUser?.name);

    return userAnswer;
  }

////////////////////////
  List<QuizModel> quizes = [];
  AddQuiz(DateTime date) async {
    QuizModel quiz = QuizModel(quizName: ramdanName.text, startDate: date);
    quizes =
        await FireStoreController.fireStoreHelper.addFamQuizWithStartDate(quiz);

    getAllQuizes();

    notifyListeners();
  }

  getAllQuizes() async {
    quizes = await FireStoreController.fireStoreHelper.fetchFamQuizzes();
    notifyListeners();
  }

  // مسابقة الاسرة
  QuestionModel? todeyQuestion;
  Future<QuestionModel?> getTodayQuestion(String name) async {
    try {
      // ✅ جلب السؤال المناسب برقم اليوم
      todeyQuestion =
          await FireStoreController.fireStoreHelper.getTodayQuestion(name);

      return todeyQuestion;
    } catch (e) {
      print("❌ خطأ أثناء جلب السؤال: $e");
      return null;
    }
  }

  //

  List<FamilyStatsModel> family = [];
  getAllFamily() async {
    family = await FireStoreController.fireStoreHelper.getAllFamilys();
    notifyListeners();
  }

  ////////////////////////////////////////
  ///دالة لعرض جميع الاسئلة بناءا على اسم المسابقة
  // جلب الأسئلة من Firestore
  List<QuestionModel> quizesQuestion = [];

  getAllQuestionQuizes(String name) async {
    quizesQuestion =
        await FireStoreController.fireStoreHelper.getQuizesQuestions(name);
    notifyListeners();
  }

  Future<void> updateQuestion(
      String quizId, String questionId, QuestionModel questionModel) async {
    try {
      await FireStoreController.fireStoreHelper
          .updateQuestion(quizId, questionId, questionModel);
      print('تم تحديث السؤال بنجاح!');
      getAllQuestionQuizes(quizId);
      notifyListeners(); // قم بإعلام المستمعين بتحديث البيانات
    } catch (e) {
      print('حدث خطأ أثناء التحديث: $e');
    }
  }

  removeQuiz(String qiuzid) async {
    FireStoreController.fireStoreHelper.RemoveQuiz(qiuzid);
    quizes.remove(qiuzid);
    notifyListeners();
    getAllQuizes();
  }

  List<QuestionModel> questions3 = [];
  fetchCompetionQuestions(
    String category,
    String type,
    String competitionId,
  ) async {
    questions3 = await FireStoreController.fireStoreHelper
        .getQuestions(category, type, competitionId);

    notifyListeners();
  }
}
