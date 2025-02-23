import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:island_social_development/controllers/firestore_controller.dart';
import 'package:island_social_development/core/utils/hive_box.dart';
import 'package:island_social_development/models/competition_model.dart';
import 'package:island_social_development/models/fam_answer.dart';
import 'package:island_social_development/models/question_model.dart';
import 'package:island_social_development/models/user_model.dart';

class QuizProvider with ChangeNotifier {
  QuizProvider() {
    focusNode = FocusNode();
    focusNode.addListener(_onFocusChange);
    getUserAge();
    loadResults();
    getTodayQuestion();
    getAllFamily();
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

  Future<UserModel?>? getUserAge() async {
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
        return "general";
      case 2:
        return "scientific";
      case 3:
        return "islamic";
      default:
        throw Exception("النوع غير صحيح");
    }
  }

  CompetitionModel? competitionModel;

  CompetitionModel addQuiz() {
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

  String? validateCompetitonLength(String value) {
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
  Future<List<CompetitionModel>>? getCompetitions(
      BuildContext context, String type) async {
    competitions = await FireStoreController.fireStoreHelper
        .getCompetitions(category: checkCategory(), type: type);
    notifyListeners();
    return competitions;
  }

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

  Future<void> addNewQuestiontoFam1(
      String questionText, List<String> options, String correctAnswer) async {
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
          .addFamQuestionsToFirestore(question);

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
  check(BuildContext context, String option, int index) {
    if (option == questions2[index].correctAnswer) {
      score++;
      notifyListeners();
    }

    if (index + 1 == questions2.length) {
      if (score < 5) {
      } else if (score == 5) {
      } else {}
    }
    score == 0;

    notifyListeners();
  }

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

  // دالة التخزين
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
  bool userAnser = false;
  bool isQuizCompleted(
    String competitionId,
  ) {
    userAnser = results.any((quiz) =>
        quiz['cometitionName'] == competitionId &&
        quiz['userName'] == currentUser?.name);

    return userAnser;
  }

  // مسابقة الاسرة
  QuestionModel? todeyQuestion;
  Future<QuestionModel?> getTodayQuestion() async {
    try {
      // ✅ تحديد تاريخ البدء
      DateTime startDate = DateTime(2025, 2, 22);
      DateTime today = DateTime.now();

      // ✅ حساب الفرق بين التاريخ الحالي وتاريخ البدء
      int dayNumber = today.difference(startDate).inDays + 1;
      print("🔹 Day Number: $dayNumber");

      // ✅ جلب السؤال المناسب برقم اليوم
      todeyQuestion =
          await FireStoreController.fireStoreHelper.getQuestionById("2");

      if (todeyQuestion != null) {
        print("✅ Question Retrieved: ${todeyQuestion!.question}");
        print("✅ Correct Answer: ${todeyQuestion!.correctAnswer}");
      } else {
        print("⚠️ لم يتم العثور على السؤال في Firestore!");
      }

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
}
