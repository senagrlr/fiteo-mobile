// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appName => 'Fiteo';

  @override
  String get continueText => 'Devam Et';

  @override
  String get back => 'Geri';

  @override
  String get cancel => 'İptal';

  @override
  String get save => 'Kaydet';

  @override
  String get done => 'Bitti';

  @override
  String get close => 'Kapat';

  @override
  String get email => 'E-posta';

  @override
  String get password => 'Şifre';

  @override
  String get login => 'Giriş Yap';

  @override
  String get welcomeBack => 'Tekrar Hoş Geldin';

  @override
  String get loginSubtitle => 'Yolculuğuna devam etmek için giriş yap.';

  @override
  String get emailAndPasswordEmpty => 'Lütfen e-posta adresini ve şifreni gir.';

  @override
  String get wrongEmailOrPassword => 'E-posta veya şifre hatalı.';

  @override
  String get or => 'veya';

  @override
  String get googleSignInFailed =>
      'Google ile giriş başarısız oldu. Lütfen tekrar dene.';

  @override
  String get dontHaveAccount => 'Hesabın yok mu?';

  @override
  String get signUp => 'Kayıt Ol';

  @override
  String get loading => 'Yükleniyor...';

  @override
  String get username => 'Kullanıcı Adı';

  @override
  String get dateOfBirth => 'Doğum Tarihi';

  @override
  String get alreadyHaveAccount => 'Zaten hesabın var mı?';

  @override
  String get fillAllFields => 'Lütfen tüm alanları doldur.';

  @override
  String get passwordTooShort => 'Şifre en az 8 karakter olmalıdır.';

  @override
  String get invalidBirthDate => 'Lütfen geçerli bir doğum tarihi gir.';

  @override
  String get emailAlreadyRegistered =>
      'Bu e-posta adresiyle zaten bir hesap mevcut.';

  @override
  String get signUpAgreement =>
      'Kayıt olarak Hizmet Şartlarımızı ve Gizlilik Politikamızı kabul etmiş olursun.';

  @override
  String get verifyEmailTitle => 'E-postanı Doğrula';

  @override
  String get verifyEmailDescription =>
      'E-posta adresine bir doğrulama bağlantısı gönderdik. Devam etmek için gelen kutunu kontrol et ve bağlantıya dokun.';

  @override
  String get resendEmail => 'E-postayı Tekrar Gönder';

  @override
  String resendEmailWithTime(String time) {
    return 'E-postayı Tekrar Gönder ($time)';
  }

  @override
  String get checking => 'Kontrol Ediliyor...';

  @override
  String get verify => 'Doğrula';

  @override
  String get emailVerifiedSuccessfully =>
      'E-posta adresin başarıyla doğrulandı.';

  @override
  String get emailNotVerifiedYet => 'E-posta adresin henüz doğrulanmadı.';

  @override
  String get verificationEmailSentAgain =>
      'Doğrulama e-postası tekrar gönderildi.';

  @override
  String get verificationEmailCouldNotSend =>
      'Doğrulama e-postası gönderilemedi. Lütfen tekrar dene.';

  @override
  String get forgotPassword => 'Şifremi unuttum';

  @override
  String get forgotPasswordTitle => 'Şifremi Unuttum';

  @override
  String get forgotPasswordDescription =>
      'E-posta adresini gir, şifreni sıfırlaman için link gönderelim.';

  @override
  String get enterEmail => 'Lütfen e-posta adresini gir.';

  @override
  String get emailRequired => 'E-posta adresi gerekli.';

  @override
  String get invalidEmail => 'Lütfen geçerli bir e-posta adresi gir.';

  @override
  String get onboardingPage1Title =>
      'Yeni bir sen için ilk adımı attın, ama motive kalmak her zaman kolay değil.';

  @override
  String get onboardingPage2Title =>
      'Daha sağlıklı yaşamak istiyorsun, ama her şeyi takip etmek bunaltıcı olabiliyor.';

  @override
  String get onboardingPage3Title =>
      'Peki ya bu yolculuğu senin için kolaylaştıran bir yapay zekâ koçun olsaydı.';

  @override
  String get onboardingMeetFiteo => 'Fiteo ile Tanış';

  @override
  String get onboardingPage4Title =>
      'Kişisel beslenme ve fitness yol arkadaşın.';

  @override
  String get skip => 'Atla';

  @override
  String get planSetupMainGoalTitle => 'Ana hedefin nedir?';

  @override
  String get goalLoseWeight => 'Kilo Vermek';

  @override
  String get goalBuildMuscle => 'Kas Kazanmak';

  @override
  String get goalMaintainFitness => 'Formunu Korumak';

  @override
  String get goalImproveHealth => 'Sağlığını İyileştirmek';

  @override
  String get planSetupAboutYourselfTitle => 'Bize kendinden bahset';

  @override
  String get age => 'Yaş';

  @override
  String get height => 'Boy';

  @override
  String get weight => 'Kilo';

  @override
  String get gender => 'Cinsiyet';

  @override
  String get female => 'Kadın';

  @override
  String get male => 'Erkek';

  @override
  String get activityLevelTitle => 'Ne kadar aktifsin?';

  @override
  String get activitySedentary => 'Hareketsiz';

  @override
  String get activityLightlyActive => 'Az Aktif';

  @override
  String get activityModeratelyActive => 'Orta Düzey Aktif';

  @override
  String get activityVeryActive => 'Çok Aktif';

  @override
  String get nutritionPreferenceTitle => 'Nasıl beslenmeyi tercih ediyorsun?';

  @override
  String get nutritionNoRestrictions => 'Kısıtlama Yok';

  @override
  String get nutritionHighProtein => 'Yüksek Proteinli';

  @override
  String get nutritionVegetarian => 'Vejetaryen';

  @override
  String get nutritionVegan => 'Vegan';

  @override
  String get nutritionBalancedDiet => 'Dengeli Beslenme';

  @override
  String get workoutPreferenceTitle =>
      'Nasıl egzersiz yapmayı tercih ediyorsun?';

  @override
  String get workoutHome => 'Evde Egzersiz';

  @override
  String get workoutGym => 'Spor Salonu';

  @override
  String get workoutWalkingCardio => 'Yürüyüş / Kardiyo';

  @override
  String get workoutStrengthTraining => 'Kuvvet Antrenmanı';

  @override
  String get goalWeightTitle => 'Hedef kilon nedir?';

  @override
  String get planPreviewTitle => 'Hedeflerin sana özel bir planı hak ediyor';

  @override
  String get planPreviewDescription =>
      'Genel planlarda motivasyon zamanla azalabilir. Fiteo, hedeflerine ve yaşam tarzına uyum sağlayarak hedefin doğrultusunda ilerlemene yardımcı olur.';

  @override
  String get createMyPlan => 'Planımı Oluştur';

  @override
  String get planProgressOverTime => 'Zaman içindeki ilerlemen';

  @override
  String get fiteoPlan => 'Fiteo planı';

  @override
  String get genericPlan => 'Genel plan';

  @override
  String get chartStart => 'Başlangıç';

  @override
  String get chartEarly => 'İlk Dönem';

  @override
  String get chartMid => 'Orta';

  @override
  String get chartGoal => 'Hedef';

  @override
  String get yourGoal => 'Hedefin';

  @override
  String get customizeYourPlan => 'Planın sana özel hazırlanıyor';

  @override
  String get analyzingGoals => 'Hedeflerin analiz ediliyor...';

  @override
  String get calculatingCalories => 'Kalori ihtiyacın hesaplanıyor...';

  @override
  String get buildingMealSuggestions => 'Öğün önerilerin hazırlanıyor...';

  @override
  String get designingWorkoutRoadmap => 'Egzersiz yol haritan hazırlanıyor...';

  @override
  String get yourPlanIsReady => 'Planın hazır!';

  @override
  String get savingPersonalizedPlan => 'Kişisel planın kaydediliyor...';

  @override
  String get thisMayTakeFewSeconds => 'Bu işlem birkaç saniye sürebilir.';

  @override
  String get planCouldNotBeSaved => 'Planın kaydedilemedi.';

  @override
  String get aiPlanReadyTitle => 'Yapay zekâ planın hazır!';

  @override
  String get aiPlanReadyDescription =>
      'Hedeflerine göre günlük değerlerini oluşturduk. Devam etmeden önce istersen bu değerleri düzenleyebilirsin.';

  @override
  String get dailyTargets => 'Günlük hedefler';

  @override
  String get carbohydrates => 'Karbonhidrat';

  @override
  String get fats => 'Yağ';

  @override
  String get water => 'Su';

  @override
  String get startMyJourney => 'Yolculuğuma Başla';

  @override
  String get planChartTitle => 'Zaman içindeki ilerlemen';

  @override
  String get planChartFiteoPlan => 'Fiteo planı';

  @override
  String get planChartGenericPlan => 'Genel plan';

  @override
  String get planChartStart => 'Başlangıç';

  @override
  String get planChartEarly => 'İlk dönem';

  @override
  String get planChartMid => 'Orta';

  @override
  String get planChartGoal => 'Hedef';

  @override
  String get planChartYourGoal => 'Hedefin';

  @override
  String get sendResetLink => 'Sıfırlama Bağlantısı Gönder';

  @override
  String get sendLink => 'Link Gönder';

  @override
  String get sending => 'Gönderiliyor...';

  @override
  String get resetLinkSent =>
      'Şifre sıfırlama bağlantısı gönderildi. E-postanı kontrol et.';

  @override
  String get resetLinkCouldNotSend =>
      'Şifre sıfırlama bağlantısı gönderilemedi. Lütfen tekrar dene.';

  @override
  String get passwordRequired => 'Şifre gerekli.';

  @override
  String get somethingWentWrong => 'Bir şeyler ters gitti. Lütfen tekrar dene.';

  @override
  String get dailySummary => 'Günlük Özet';

  @override
  String get calories => 'Kalori';

  @override
  String get protein => 'Protein';

  @override
  String get carbs => 'Karbonhidrat';

  @override
  String get fat => 'Yağ';

  @override
  String get addFood => 'Yemek Ekle';

  @override
  String get breakfast => 'Kahvaltı';

  @override
  String get lunch => 'Öğle Yemeği';

  @override
  String get dinner => 'Akşam Yemeği';

  @override
  String get snack => 'Ara Öğün';

  @override
  String get weeklyReport => 'Haftalık Rapor';

  @override
  String get monthlyReport => 'Aylık Rapor';

  @override
  String get progress => 'İlerleme';

  @override
  String get workout => 'Egzersiz';

  @override
  String get profile => 'Profil';

  @override
  String get recipeCouldNotBeCreated =>
      'Tarif oluşturulamadı. Lütfen tekrar dene.';

  @override
  String get couldNotAddRecipeToMeals => 'Tarif öğünlere eklenemedi.';

  @override
  String get dailyAiMessageLimitReached =>
      'Günlük yapay zekâ mesaj limitine ulaştın.';

  @override
  String recipeAddedToMeal(String recipeName, String mealType) {
    return '$recipeName, $mealType öğününe eklendi.';
  }
}
