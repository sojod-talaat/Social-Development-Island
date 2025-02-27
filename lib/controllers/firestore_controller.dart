import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:island_social_development/models/competition_model.dart';
import 'package:island_social_development/models/doura_tahfiz.dart';
import 'package:island_social_development/models/fam_answer.dart';
import 'package:island_social_development/models/question_model.dart';
import 'package:island_social_development/models/quiz_model.dart';
import 'package:island_social_development/models/user_model.dart';
import 'package:island_social_development/views/auth/widgets/snak_bar.dart';

class FireStoreController {
  ////////////////////////////////////////////////////////////AddUsertofirestore
  FireStoreController._();
  static FireStoreController fireStoreHelper = FireStoreController._();
  static FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  static CollectionReference<Map<String, dynamic>> fireStoreUsersInstance =
      FirebaseFirestore.instance.collection('users');
  CollectionReference<Map<String, dynamic>> fireStoreDouratInstance =
      FirebaseFirestore.instance.collection('dourat');
  CollectionReference<Map<String, dynamic>> fireStoreFamInstance =
      FirebaseFirestore.instance.collection('families');

/////////////////////////////////////////////////////////////اضافة مستخدم جديد
  Future<void> saveUserToFirestore(UserModel user) async {
    final userDoc = FirebaseFirestore.instance.collection('users').doc(user.id);

    await userDoc.set(user.toJson(), SetOptions(merge: true));
  }

  //////////////////////////////////////////////////////////اضافة دورة تحفيظ
  addDouraToFireStor(DouraTahfizModel tahfizModel) async {
    await firebaseFirestore
        .collection('dourat')
        .doc()
        .set(tahfizModel.toJson());
  }

  ///////////////////////////////////////////ارجاع  كل دورات التحفيظ
  Future<List<DouraTahfizModel>> getAllDouratFromFireStore() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await fireStoreDouratInstance.get();
    List<QueryDocumentSnapshot<Map<String, dynamic>>> documents =
        querySnapshot.docs;
    List<DouraTahfizModel> dourats = documents.map((e) {
      DouraTahfizModel doura = DouraTahfizModel.fromJson(e.data());
      doura.id = e.id;
      return doura;
    }).toList();
    return dourats;
  }

//////////////////////////////////////////////////////////////////المسابقات

  ////////////////////////////////////////////////// دالة لإضافة مسابقة جديدة
  Future<void> addCompetition(
      {required String category, // 1 = شباب، 2 = أطفال
      required String type, // 1 = عامة، 2 = علمية، 3 = شرعية
      required CompetitionModel competition,
      BuildContext? context}) async {
    try {
      // الحصول على المرجع
      DocumentReference categoryRef =
          firebaseFirestore.collection("competitions").doc(category);
      CollectionReference typeRef = categoryRef.collection(type);
      // إنشاء ID تلقائي للمسابقة
      DocumentReference newCompetitionRef = typeRef.doc();
      competition.id = newCompetitionRef.id;
      // إضافة المسابقة إلى Firestore
      await newCompetitionRef.set(competition.toJson());
      SnakBarWidget.show(context!, "تم اضافةالمسابقة بنجاح");
    } catch (e) {
      print("حدث خطأ أثناء الإضافة: $e");
    }
  }

  ///////////////////////////////////الاسئلة
  Future<bool> addQuestionToCompetition(
      {required String category, // 1 = شباب، 2 = أطفال
      required String type, // نوع المسابقة (عامة، علمية، شرعية)
      required String competitionId, // معرف المسابقة
      required QuestionModel question, // بيانات السؤال
      required int maxQuestions,
      required BuildContext context // الحد الأقصى للأسئلة
      }) async {
    try {
      // 🔥 تحديد مرجع الأسئلة داخل المسابقة
      CollectionReference questionsRef = firebaseFirestore
          .collection('competitions') // كوليكشن المسابقات
          .doc(category) // وثيقة الفئة (شباب أو أطفال)
          .collection(type) // كوليكشن النوع (عامة، علمية، شرعية)
          .doc(competitionId) // وثيقة المسابقة
          .collection('questions'); // كوليكشن الأسئلة داخل المسابقة

      // 🔥 التحقق من عدد الأسئلة الحالية
      QuerySnapshot currentQuestions = await questionsRef.get();
      int currentCount = currentQuestions.size;
      if (currentCount >= maxQuestions) {
        // ignore: use_build_context_synchronously
        SnakBarWidget.show(context,
            "❌ لا يمكن إضافة المزيد من الأسئلة، الحد الأقصى هو $maxQuestions.");
        return false; // ❌ رفض الإضافة
      }
      // 🔥 إضافة السؤال داخل Collection `questions`
      DocumentReference newQuestionRef =
          questionsRef.doc(); // إنشاء معرف تلقائي للسؤال
      question.id = newQuestionRef.id; // تعيين ID تلقائي للسؤال
      await newQuestionRef.set(question.toJson()); // ✅ تخزين السؤال
      // ignore: use_build_context_synchronously
      SnakBarWidget.show(context, "✅ تم إضافة السؤال بنجاح!");
      return true; // ✅ نجاح الإضافة
    } catch (e) {
      // ignore: use_build_context_synchronously
      SnakBarWidget.show(context, "❌ خطأ أثناء إضافة السؤال: $e");
      return false;
    }
  }

////////////////////////////////////////////////////////////////عرض المسابقات
  Future<List<CompetitionModel>> getCompetitions({
    required String category, // 1 = شباب، 2 = أطفال
    required String type, // نوع المسابقة (عامة، علمية، شرعية)
  }) async {
    try {
      // 🔥 تحديد مرجع المسابقات
      CollectionReference competitionsRef = firebaseFirestore
          .collection('competitions') // كوليكشن المسابقات
          .doc(category) // وثيقة الفئة (شباب أو أطفال)
          .collection(type); // كوليكشن النوع (عامة، علمية، شرعية)
      // 🔥 جلب البيانات
      QuerySnapshot querySnapshot = await competitionsRef.get();
      // 🔥 تحويل البيانات إلى قائمة `CompetitionModel`
      List<CompetitionModel> competitions = querySnapshot.docs
          .map((doc) => CompetitionModel.fromJson(
                doc.data() as Map<String, dynamic>,
              ))
          .toList();

      return competitions;
    } catch (e) {
      return [];
    }
  }

////////////////////////////////////////////////////////// جلب الاسئلة
  Future<List<QuestionModel>> getQuestions(
      String category, String type, String competitionId) async {
    final snapshot = await firebaseFirestore
        .collection('competitions') // 🔥 الوصول إلى الكوليكشن الرئيسي
        .doc(category) // 🔥 تصفية حسب التايب
        .collection(type) // 🔥 تصفية حسب الكاتيجوري
        .doc(competitionId) // 🔥 الوصول إلى المسابقة عبر ID
        .collection('questions') // 🔥 جلب كوليكشن الأسئلة
        .get();
    return snapshot.docs
        .map((doc) => QuestionModel.fromJson(doc.data()))
        .toList();
  }

  ///////////////////////////////////////////////////اضافة الناتج
  Future<void> saveResult(String userId, String userName, int score,
      String cometitionName, int count) async {
    try {
      // إضافة البيانات إلى Firestore في مجموعة "results"
      await FirebaseFirestore.instance.collection('results').add({
        'userId': userId,
        'userName': userName,
        'score': score,
        'cometitionName': cometitionName,
        'timestamp': FieldValue.serverTimestamp(),
        'totalQuestions': count,
      });
    } catch (e) {
      print("Error saving result: $e");
    }
  }

  Future<List<Map<String, dynamic>>> getResults() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('results') // استرجاع النتائج الخاصة بالمسابقة
          .get();

      // تحويل البيانات المسترجعة إلى قائمة
      List<Map<String, dynamic>> results = [];
      for (var doc in snapshot.docs) {
        results.add(doc.data() as Map<String, dynamic>);
      }
      return results;
    } catch (e) {
      print("Error retrieving results: $e");
      return [];
    }
  }

  /////////////////////////مسابقات العائلة

  //
  addFamQuizWithStartDate(QuizModel quizModel) async {
    try {
      // إضافة/تحديث المسابقة مع تاريخ البدء
      await FirebaseFirestore.instance
          .collection('fam_questions') // مجموعة المسابقات
          .doc(quizModel.quizName) // استخدام `quizId` كـ ID للمسابقة
          .set(quizModel.toJson());

      print("✅ تم إضافة/تحديث تاريخ البدء للمسابقة بنجاح!");
    } catch (e) {
      print("❌ خطأ أثناء إضافة/تحديث تاريخ البدء للمسابقة: $e");
    }
  }

  Future<void> addFamQuestionsToFirestore(
      String name, QuestionModel question) async {
    final CollectionReference questionsCollection = FirebaseFirestore.instance
        .collection('fam_questions')
        .doc(name)
        .collection('questions');

    // ✅ جلب آخر رقم تسلسلي
    final QuerySnapshot snapshot = await questionsCollection
        .orderBy('number', descending: true)
        .limit(1)
        .get();

    int lastNumber = 0;
    if (snapshot.docs.isNotEmpty) {
      lastNumber = snapshot.docs.first['number']; // الحصول على آخر رقم مسجل
    }

    // ✅ تعيين رقم جديد وزيادته
    int newNumber = lastNumber + 1;
    question.id = newNumber.toString(); // تحديث الـ ID برقم التسلسل الجديد

    // ✅ إضافة السؤال مع الرقم الجديد
    await questionsCollection.doc(question.id).set({
      ...question.toJson(),
      'number': newNumber, // تخزين الرقم التسلسلي
    });
  }

  Future<QuestionModel?> getTodayQuestion(String name) async {
    try {
      final DocumentSnapshot competitionDoc = await FirebaseFirestore.instance
          .collection('fam_questions')
          .doc(name)
          .get();

      if (!competitionDoc.exists) {
        print("⚠️ لا توجد مسابقة بهذا الاسم!");
        return null;
      }

      // ✅ التحقق من نوع `start_date`
      dynamic startDateData = competitionDoc['startDate'];

      DateTime startDate;
      if (startDateData is Timestamp) {
        startDate = startDateData.toDate(); // ✅ تحويل Timestamp إلى DateTime
      } else if (startDateData is String) {
        startDate =
            DateTime.parse(startDateData); // ✅ تحويل String إلى DateTime
      } else {
        print("⚠️ نوع `start_date` غير مدعوم!");
        return null;
      }

      DateTime today = DateTime.now();

      // ✅ حساب اليوم المناسب للمسابقة
      int dayNumber = today.difference(startDate).inDays + 1;
      print("🔹 اليوم الحالي من المسابقة: $dayNumber");

      // ✅ جلب السؤال المناسب لهذا اليوم
      final DocumentSnapshot questionDoc = await firebaseFirestore
          .collection('fam_questions')
          .doc(name)
          .collection('questions')
          .doc(dayNumber.toString())
          .get();

      if (!questionDoc.exists) {
        print("⚠️ لم يتم العثور على سؤال لهذا اليوم!");
        return null;
      }

      return QuestionModel.fromJson(questionDoc.data() as Map<String, dynamic>);
    } catch (e) {
      print("❌ خطأ أثناء جلب السؤال: $e");
      return null;
    }
  }

  Future<List<QuizModel>> fetchFamQuizzes() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('fam_questions').get();

      List<QuizModel> quizzes = querySnapshot.docs
          .map((doc) {
            final data = doc.data() as Map<String, dynamic>?;

            if (data == null) {
              print("⚠️ المستند ${doc.id} لا يحتوي على بيانات صالحة!");
              return null;
            }

            return QuizModel.fromJson(doc.id, data);
          })
          .whereType<QuizModel>()
          .toList();

      print("✅ تم جلب ${quizzes.length} مسابقة بنجاح.");
      return quizzes;
    } catch (e) {
      print("❌ خطأ أثناء جلب المسابقات: $e");
      return [];
    }
  }

  /// ✅ دالة لاسترجاع السؤال المناسب بناءً على اليوم الحالي
  Future<QuestionModel?> getQuestionById(String questionId) async {
    var doc = await FirebaseFirestore.instance
        .collection('fam_questions')
        .doc(questionId)
        .get();

    if (doc.exists) {
      return QuestionModel.fromJson(doc.data()!);
    }
    return null;
  }

  ///SAVA FAM RESULT
  savaFamResult(
    String famName,
  ) async {
    await FirebaseFirestore.instance.collection('Famresults').add({
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  ///////////////////////////////////////
  Future<List<FamilyStatsModel>> getAllFamilys() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await fireStoreFamInstance.get();
    List<QueryDocumentSnapshot<Map<String, dynamic>>> documents =
        querySnapshot.docs;
    List<FamilyStatsModel> dourats = documents.map((e) {
      FamilyStatsModel family = FamilyStatsModel.fromJson(e.data());

      return family;
    }).toList();
    return dourats;
  }

  ///////////////////////////////
  Future<List<QuestionModel>> getQuizesQuestions(String quizId) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('fam_questions')
          .doc(quizId)
          .collection('questions')
          .get();

      List<QuestionModel> questions = querySnapshot.docs.map((doc) {
        return QuestionModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();

      return questions;
    } catch (e) {
      print("Error getting questions: $e");
      return [];
    }
  }

  Future<void> updateQuestion(
      String quizId, String questionId, QuestionModel questionModel) async {
    try {
      await FirebaseFirestore.instance
          .collection('fam_questions')
          .doc(quizId)
          .collection('questions')
          .doc(questionId)
          .update(questionModel.toJson());
      print('تم تحديث السؤال بنجاح!');
    } catch (e) {
      print('حدث خطأ أثناء التحديث: $e');
    }
  }

  RemoveQuiz(String quizId) async {
    await FirebaseFirestore.instance
        .collection('fam_questions')
        .doc(quizId)
        .delete();
  }

  Future<List<QuestionModel>> getCompetitionQuestions(String quizId) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('competitions')
          .doc(quizId)
          .collection('questions')
          .get();

      List<QuestionModel> questions = querySnapshot.docs.map((doc) {
        return QuestionModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();

      return questions;
    } catch (e) {
      print("Error getting questions: $e");
      return [];
    }
  }
}
