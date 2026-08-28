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
  String get customizeYourPlan => 'Planın hazırlanıyor';

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
  String get dailySummary => 'Günlük Özet';

  @override
  String get calories => 'Kalori';

  @override
  String get protein => 'Protein';

  @override
  String get carbs => 'Karb.';

  @override
  String get fat => 'Yağ';

  @override
  String get foodIntake => 'Alınan';

  @override
  String get exerciseBurn => 'Yakılan';

  @override
  String get netCalories => 'Net Kalori';

  @override
  String get hydration => 'Su Tüketimi';

  @override
  String get remaining => 'Kalan';

  @override
  String get calorieGoal => 'Kalori Hedefi';

  @override
  String caloriesOverGoal(int calories) {
    return '$calories kcal fazla';
  }

  @override
  String caloriesPerDay(int calories) {
    return '$calories kcal/gün';
  }

  @override
  String get consumed => 'Alınan';

  @override
  String get burned => 'Yakılan';

  @override
  String get net => 'Net';

  @override
  String get todaysMacros => 'Makrolar';

  @override
  String macroGoalTitle(String macro) {
    return '$macro Hedefi';
  }

  @override
  String get viewCalendar => 'Takvimi Gör';

  @override
  String streakDays(int count) {
    return '$count gün';
  }

  @override
  String get defaultAiFeedbackMessage => 'Rutinini adım adım oluşturuyorsun.';

  @override
  String get defaultAiFeedbackSuggestion =>
      'Bugünkü ilerlemeni takip etmek için öğünlerini ve hareketlerini kaydetmeye devam et.';

  @override
  String get drink => 'İç';

  @override
  String get enterWaterAmount => 'Su miktarını gir';

  @override
  String get addFood => 'Yemek Ekle';

  @override
  String get foodName => 'Yemek adı';

  @override
  String get amount => 'Miktar';

  @override
  String get grams => 'Gram';

  @override
  String get pieces => 'Adet';

  @override
  String get calorieEstimateDisclaimer =>
      '( Kaloriler ortalama besin değerlerine\ngöre tahmini olarak hesaplanır. )';

  @override
  String get couldNotAddFood => 'Yemek eklenemedi.';

  @override
  String get couldNotDeleteFood => 'Yemek silinemedi.';

  @override
  String get couldNotLoadMeals => 'Öğünler yüklenemedi.';

  @override
  String get deleteFood => 'Yemeği Sil';

  @override
  String todaysMeal(String meal) {
    return 'Bugünkü $meal';
  }

  @override
  String get breakfast => 'Kahvaltı';

  @override
  String get lunch => 'Öğle Yemeği';

  @override
  String get dinner => 'Akşam Yemeği';

  @override
  String get snack => 'Ara Öğün';

  @override
  String get monthlyCalendar => 'Aylık Takvim';

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
  String get recipeCouldNotBeSaved => 'Tarif kaydedilemedi.';

  @override
  String get removeFromSaved => 'Kaydedilenlerden kaldır';

  @override
  String get saveRecipe => 'Tarifi kaydet';

  @override
  String get addToIntake => 'Günlük Tüketime Ekle';

  @override
  String get ingredients => 'Malzemeler';

  @override
  String get instructions => 'Hazırlanışı';

  @override
  String get nutrition => 'Beslenme';

  @override
  String get servings => 'Porsiyon';

  @override
  String get totalCalories => 'Toplam Kalori';

  @override
  String get perServing => 'Porsiyon Başına';

  @override
  String get dailyAiMessageLimitReached =>
      'Günlük yapay zekâ mesaj limitine ulaştın.';

  @override
  String get aiWelcomeMessage =>
      'Selam, ben Fiteo. Yolculuğunu daha iyi hale getirelim. Aşçı moduna geçebilirsin.';

  @override
  String get aiMessageInputHint => 'Hedefini anlat, sana yol göstereyim';

  @override
  String get aiCouldNotRespond =>
      'Üzgünüm, şu anda yanıt veremiyorum. Lütfen daha sonra tekrar dene.';

  @override
  String get aiChatGreeting =>
      'Merhaba, ben Fiteo. Hedefini söyle, sana yol göstereyim.';

  @override
  String get deleteMessage => 'Mesajı Sil';

  @override
  String aiMessagesLeftToday(int count) {
    return 'Bugün $count yapay zekâ mesaj hakkın kaldı';
  }

  @override
  String get creatingRecipe => 'Tarifin hazırlanıyor...\nLütfen bekle.';

  @override
  String get enterIngredients => 'Malzemeleri gir';

  @override
  String get cookWelcomeMessage =>
      'Malzemeleri yaz, sana en uygun tarifi hazırlayayım.';

  @override
  String get dailyRecipeLimitReached =>
      'Günlük tarif oluşturma limitine ulaştın.';

  @override
  String recipeRequestsLeftToday(int count) {
    return 'Bugün $count tarif oluşturma hakkın kaldı';
  }

  @override
  String get addExercise => 'Egzersiz Ekle';

  @override
  String get exerciseName => 'Egzersiz adı';

  @override
  String get durationMinutes => 'Süre (dakika)';

  @override
  String get intensity => 'Yoğunluk';

  @override
  String get intensityLow => 'Düşük';

  @override
  String get intensityMedium => 'Orta';

  @override
  String get intensityHigh => 'Yüksek';

  @override
  String get calculating => 'Hesaplanıyor...';

  @override
  String get caloriesBurned => 'Yakılan Kalori';

  @override
  String get metEstimateDisclaimer =>
      '( Kaloriler ortalama MET değerleri\nkullanılarak tahmini hesaplanır. )';

  @override
  String get duration => 'Süre';

  @override
  String minutesShort(int minutes) {
    return '$minutes dk';
  }

  @override
  String get saveCalories => 'Kaloriyi Kaydet';

  @override
  String get deleteExercise => 'Egzersizi Sil';

  @override
  String get todaysExercises => 'Bugünkü Egzersizler';

  @override
  String get couldNotAddExercise => 'Egzersiz eklenemedi.';

  @override
  String get couldNotUpdateCalories => 'Kalori bilgisi güncellenemedi.';

  @override
  String get couldNotDeleteExercise => 'Egzersiz silinemedi.';

  @override
  String get couldNotLoadExercises => 'Egzersizler yüklenemedi.';

  @override
  String get allergens => 'Alerjenler';

  @override
  String get allergenDisclaimer =>
      'Alerjen bilgileri yapay zekâ tarafından oluşturulmuştur. Tüketmeden önce her zaman ürün içeriklerini kontrol et.';

  @override
  String get allergenGluten => 'Gluten';

  @override
  String get allergenDairy => 'Süt Ürünleri';

  @override
  String get allergenEgg => 'Yumurta';

  @override
  String get allergenPeanuts => 'Yer Fıstığı';

  @override
  String get allergenTreeNuts => 'Sert Kabuklu Yemişler';

  @override
  String get allergenSoy => 'Soya';

  @override
  String get allergenFish => 'Balık';

  @override
  String get allergenShellfish => 'Kabuklu Deniz Ürünleri';

  @override
  String get allergenSesame => 'Susam';

  @override
  String get deleteMyAccount => 'Hesabımı Sil';

  @override
  String get sorryToSeeYouGo => 'Gitmene üzüldüm';

  @override
  String get deleteAccountDescription =>
      'Hesabını silmek profilini ve kişisel verilerini kalıcı olarak kaldırır. Bu işlem geri alınamaz.';

  @override
  String get enterCurrentPassword => 'Mevcut şifreni gir';

  @override
  String get deleting => 'Siliniyor...';

  @override
  String get confirm => 'Onayla';

  @override
  String get currentPasswordRequired => 'Mevcut şifre gerekli.';

  @override
  String get currentPasswordIncorrect => 'Mevcut şifre hatalı.';

  @override
  String get recentLoginRequired =>
      'Hesabını silmeden önce lütfen tekrar giriş yap.';

  @override
  String get accountDeleteFailed => 'Hesabın silinemedi. Lütfen tekrar dene.';

  @override
  String get accountDeleted => 'Hesabın silindi.';

  @override
  String get weeklyCalories => 'Haftalık Kalori';

  @override
  String get mondayShort => 'PZT';

  @override
  String get tuesdayShort => 'SAL';

  @override
  String get wednesdayShort => 'ÇAR';

  @override
  String get thursdayShort => 'PER';

  @override
  String get fridayShort => 'CUM';

  @override
  String get saturdayShort => 'CMT';

  @override
  String get sundayShort => 'PAZ';

  @override
  String get januaryShort => 'O';

  @override
  String get februaryShort => 'Ş';

  @override
  String get marchShort => 'M';

  @override
  String get aprilShort => 'N';

  @override
  String get mayShort => 'M';

  @override
  String get juneShort => 'H';

  @override
  String get julyShort => 'T';

  @override
  String get augustShort => 'A';

  @override
  String get septemberShort => 'E';

  @override
  String get octoberShort => 'E';

  @override
  String get novemberShort => 'K';

  @override
  String get decemberShort => 'A';

  @override
  String get weekShort => 'H';

  @override
  String get minuteUnitShort => 'dk';

  @override
  String get editProfile => 'Profili Düzenle';

  @override
  String get chooseYourMascot => 'Maskotunu seç';

  @override
  String get changePassword => 'Şifreyi Değiştir';

  @override
  String get currentPassword => 'Mevcut şifre';

  @override
  String get newPassword => 'Yeni şifre';

  @override
  String get confirmNewPassword => 'Yeni şifreyi doğrula';

  @override
  String get saveChanges => 'Kaydet';

  @override
  String get savedRecipes => 'Kaydedilen Tarifler';

  @override
  String get goalsPreferences => 'Hedefler ve Tercihler';

  @override
  String get logOut => 'Çıkış Yap';

  @override
  String get noSavedRecipesYet => 'Henüz kaydedilmiş tarif yok.';

  @override
  String get bodyGoals => 'Vücut Hedefleri';

  @override
  String get preferencesTitle => 'Tercihler';

  @override
  String get currentWeightKg => 'Mevcut kilo (kg)';

  @override
  String get targetWeightKg => 'Hedef kilo (kg)';

  @override
  String get dailyCalorieGoal => 'Günlük kalori hedefi';

  @override
  String get preferencesUpdated => 'Tercihler başarıyla güncellendi.';

  @override
  String get preferencesUpdateFailed =>
      'Tercihler güncellenemedi. Lütfen tekrar dene.';

  @override
  String get usernameRequired => 'Kullanıcı adı gerekli.';

  @override
  String get passwordMinLength => 'Şifre en az 8 karakter olmalıdır.';

  @override
  String get passwordsDoNotMatch => 'Şifreler eşleşmiyor.';

  @override
  String get passwordUpdateFailed => 'Şifre güncellenemedi.';

  @override
  String get profileUpdateFailed =>
      'Profil güncellenemedi. Lütfen tekrar dene.';

  @override
  String get profileUpdated => 'Profil başarıyla güncellendi.';

  @override
  String get planTracking => 'Plan Takibi';

  @override
  String get overview => 'Genel Bakış';

  @override
  String get plan => 'Plan';

  @override
  String get fiteoScore => 'Fiteo Puanı';

  @override
  String get currentStreak => 'Mevcut Seri';

  @override
  String get trackingConsistency => 'Takip Tutarlılığı';

  @override
  String get goalAchievement => 'Hedef Başarısı';

  @override
  String get days => 'Gün';

  @override
  String get yourUniqueFeatures => 'Sana Özel Özellikler';

  @override
  String get longestStreak => 'En Uzun Seri';

  @override
  String get bestProtein => 'En İyi Protein';

  @override
  String get mostActiveDay => 'En Aktif Gün';

  @override
  String get achievementLongestStreak => 'En Uzun Seri';

  @override
  String get achievementLongestStreakDescription =>
      'Anlamlı takip yaptığın aralıksız en uzun gün serisi.';

  @override
  String get achievementBestProtein => 'En İyi Protein';

  @override
  String get achievementBestProteinDescription =>
      'Protein tüketiminin protein hedefine en yakın olduğu gün.';

  @override
  String get achievementMostActiveDay => 'En Aktif Gün';

  @override
  String get achievementMostActiveDayDescription =>
      'Toplam egzersiz sürenin en yüksek olduğu haftanın günü.';

  @override
  String get achievementHydrationHero => 'Su Kahramanı';

  @override
  String get achievementHydrationHeroDescription =>
      'Günlük su hedefine genel uyum seviyen.';

  @override
  String get achievementNutritionPro => 'Beslenme Profesyoneli';

  @override
  String get achievementNutritionProDescription =>
      'Kalori, protein, karbonhidrat ve yağ hedeflerine genel uyum seviyen.';

  @override
  String get achievementBalancedDays => 'Dengeli Günler';

  @override
  String get achievementBalancedDaysDescription =>
      'Kalori, protein, karbonhidrat ve yağ değerlerinin aynı gün hedeflerine yakın olduğu günler.';

  @override
  String get achievementActiveChampion => 'Aktivite Şampiyonu';

  @override
  String get achievementActiveChampionDescription =>
      'En az 20 dakika egzersiz yaptığın aktif günlerdeki genel performansın.';

  @override
  String get achievementGoalKeeper => 'Hedef Koruyucu';

  @override
  String get achievementGoalKeeperDescription =>
      'En sık başarıyla ulaştığın hedef türü.';

  @override
  String get achievementCalorieCompass => 'Kalori Pusulası';

  @override
  String get achievementCalorieCompassDescription =>
      'Net kalorinin kalori hedefinin çevresinde ne kadar tutarlı kaldığı.';

  @override
  String get achievementHydrationStreak => 'Su Serisi';

  @override
  String get achievementHydrationStreakDescription =>
      'Su hedefine arka arkaya ulaştığın en uzun gün serisi.';

  @override
  String get overviewNoAchievements =>
      'Güçlü yönlerini keşfetmek için takibe devam et.';

  @override
  String get monday => 'Pazartesi';

  @override
  String get tuesday => 'Salı';

  @override
  String get wednesday => 'Çarşamba';

  @override
  String get thursday => 'Perşembe';

  @override
  String get friday => 'Cuma';

  @override
  String get saturday => 'Cumartesi';

  @override
  String get sunday => 'Pazar';

  @override
  String get onTrack => 'Yolunda';

  @override
  String get reviewRecommended => 'Planı Gözden Geçir';

  @override
  String get notEnoughData => 'Yeterli Veri Yok';

  @override
  String get improveConsistencyFirst => 'Önce İstikrarı Artır';

  @override
  String get startWeight => 'Başlangıç';

  @override
  String get goalReachDate => 'Hedef Tarih';

  @override
  String get goalWeight => 'Hedef';

  @override
  String get weightProgress => 'Kilo İlerlemesi';

  @override
  String get actualWeight => 'Senin İlerlemen';

  @override
  String get expectedWeight => 'Planlanan İlerleme';

  @override
  String get april => 'Nisan';

  @override
  String get may => 'Mayıs';

  @override
  String get june => 'Haziran';

  @override
  String get july => 'Temmuz';

  @override
  String onTrackPlanNoteWithDate(String date) {
    return 'Planına düzenli şekilde uyuyorsun ve ilerlemen beklediğimiz şekilde devam ediyor. Böyle devam edersen yaklaşık $date tarihinde hedefine ulaşman bekleniyor.';
  }

  @override
  String get reviewRecommendedPlanNote =>
      'Son ilerlemen mevcut planının artık sana en uygun seçenek olmayabileceğini gösteriyor. Güncel ilerlemene göre senin için yeni bir plan hazırladık.';

  @override
  String get notEnoughDataPlanNote =>
      'İlerlemeni güvenilir şekilde değerlendirebilmek için henüz yeterli güncel veri yok. Planını daha doğru değerlendirebilmemiz için kilo, öğün ve aktivitelerini kaydetmeye devam et.';

  @override
  String get improveConsistencyPlanNote =>
      'Son dönemde plana uyumun güvenilir bir değerlendirme yapmak için fazla düzensiz. Önce mevcut planına daha istikrarlı şekilde uymaya çalış, ardından planının değişmesi gerekip gerekmediğini tekrar değerlendirelim.';

  @override
  String get reviewNewPlan => 'Yeni Planı Görüntüle';

  @override
  String get fiteoOverviewNote =>
      'Planına uyduğunda genellikle oldukça istikrarlı ilerliyorsun. En önemli şey süreklilik, buna dikkat etmeye devam et.';

  @override
  String get dailyAverage => 'Günlük Ortalama';

  @override
  String get target => 'Hedef';

  @override
  String get onTargetDays => 'Hedefteki Günler';

  @override
  String get totalWorkout => 'Toplam Egzersiz';

  @override
  String get activeDays => 'Aktif Günler';

  @override
  String get averageDuration => 'Ortalama Süre';

  @override
  String get totalChange => 'Toplam Değişim';

  @override
  String get weeklyRate => 'Haftalık Hız';

  @override
  String get days7 => '7 gün';

  @override
  String get days30 => '30 gün';

  @override
  String get days90 => '90 gün';

  @override
  String get days365 => '365 gün';

  @override
  String get dailyAverageCalories => 'Günlük Ortalama (kalori)';

  @override
  String get dailyAverageWater => 'Günlük Ortalama (litre)';

  @override
  String get addWithBarcode => 'Barkodla Ekle';

  @override
  String get enterBarcodeNumber => 'Barkod Numarası Yaz';

  @override
  String get barcodeNumber => 'Barkod Numarası';

  @override
  String get barcodeNumberHint => 'Barkod numarasını gir';

  @override
  String get barcodeSearch => 'Ara';

  @override
  String get barcodeCancel => 'Vazgeç';

  @override
  String get barcodeScanHint => 'Barkodu çerçevenin içine hizala';

  @override
  String get barcodeLookingUp => 'Ürün bilgileri aranıyor...';

  @override
  String get addScannedFood => 'Ekle';

  @override
  String get barcodeDemoProduct => 'Örnek Ürün';

  @override
  String get yourWeek => 'Haftan';

  @override
  String get activity => 'Aktivite';

  @override
  String get active => 'Aktif';

  @override
  String get bestDay => 'En İyi Gün';

  @override
  String get worstDay => 'En Zayıf Gün';

  @override
  String get aligned => 'uyumlu';

  @override
  String get weightAndPlan => 'Kilo & Plan';

  @override
  String get lastWeek => 'Geçen Hafta';

  @override
  String get now => 'Şimdi';

  @override
  String get planStatus => 'Plan Durumu';

  @override
  String get estimatedGoalDate => 'Tahmini Hedef Tarihi';

  @override
  String get yourWeekInReview => 'Haftanın Değerlendirmesi';

  @override
  String get nextWeek => 'Gelecek Hafta';

  @override
  String get nextWeekPlan => 'Gelecek Hafta Planı';

  @override
  String get yourMainFocus => 'Ana odağın';

  @override
  String get tryThis => 'Bunu Dene';

  @override
  String weeklyScoreChange(int value) {
    return 'Geçen haftaya göre %$value arttı';
  }

  @override
  String get reportStatusStrong => 'Güçlü';

  @override
  String get reportStatusGood => 'İyi';

  @override
  String get reportStatusNeedsFocus => 'Odak Gerekiyor';

  @override
  String get reportStatusNeedsImprovement => 'Gelişim Gerekiyor';

  @override
  String get weeklyScoreStrong => 'Güçlü Hafta';

  @override
  String get weeklyScoreGood => 'İyi Hafta';

  @override
  String get weeklyScoreNeedsFocus => 'Odak Gerekiyor';

  @override
  String get weeklyScoreNeedsImprovement => 'Gelişim Gerekiyor';

  @override
  String reportTargetDays(int reached, int total) {
    return '$reached/$total hedefte';
  }

  @override
  String reportWorkoutTime(int minutes) {
    return 'Toplam $minutes dk';
  }

  @override
  String get monthlyScoreStrong => 'Güçlü Ay';

  @override
  String get monthlyScoreGood => 'İyi Ay';

  @override
  String get monthlyScoreNeedsFocus => 'Odak Gerekiyor';

  @override
  String get monthlyScoreNeedsImprovement => 'Gelişim Gerekiyor';

  @override
  String get reportAreaCalories => 'Kalori';

  @override
  String get reportAreaProtein => 'Protein';

  @override
  String get reportAreaCarbs => 'Karbonhidrat';

  @override
  String get reportAreaFat => 'Yağ';

  @override
  String get reportAreaHydration => 'Su';

  @override
  String get reportAreaActivity => 'Aktivite';

  @override
  String get reportAreaTracking => 'Takip';

  @override
  String get reportAreaWeekends => 'Hafta Sonları';

  @override
  String reportStrongAreaTargetDays(int reached, int total) {
    return '$reached/$total gün hedefte';
  }

  @override
  String reportWeakAreaScore(int score) {
    return '%$score uyum';
  }

  @override
  String reportWeekendDifference(int value) {
    return 'Hafta içine göre %$value daha düşük';
  }

  @override
  String get reportGoalConsistencyPeriod => 'Bu ayki hedef tutarlılığın';

  @override
  String get monthlyChangeTrackingConsistency => 'Takip Tutarlılığı';

  @override
  String get monthlyChangeGoalConsistency => 'Hedef Tutarlılığı';

  @override
  String get monthlyChangeCalories => 'Kalori';

  @override
  String get monthlyChangeProtein => 'Protein';

  @override
  String get monthlyChangeHydration => 'Su';

  @override
  String get monthlyChangeActivity => 'Aktif Günler';

  @override
  String monthlyScoreChange(int value) {
    return 'Geçen aya göre %$value arttı';
  }

  @override
  String get whatChangedThisMonth => 'Bu Ay Neler Değişti?';

  @override
  String get strongestArea => 'En Güçlü Alan';

  @override
  String get weakestArea => 'En Zayıf Alan';

  @override
  String get achievements => 'Başarılar';

  @override
  String get consistency => 'Tutarlılık';

  @override
  String get goalConsistency => 'Hedef Tutarlılığı';

  @override
  String get daysTracked => 'gün takip edildi';

  @override
  String get perfectDays => 'Mükemmel Gün';

  @override
  String get perfectDayDefinition =>
      'Uygulanabilir tüm temel hedeflerin karşılandığı gün.';

  @override
  String get weightPlanProgress => 'Kilo & Plan İlerlemesi';

  @override
  String get start => 'Başlangıç';

  @override
  String get thisMonth => 'Bu Ay';

  @override
  String get monthlyTarget => 'Aylık Hedef';

  @override
  String get progressAchieved => 'Hedef Gerçekleşmesi';

  @override
  String get goalPrediction => 'Hedef Tahmini';

  @override
  String daysEarlierThanLastMonth(int value) {
    return 'Geçen ayki tahmine göre %$value gün daha erken';
  }

  @override
  String daysLaterThanLastMonth(int value) {
    return 'Geçen ayki tahmine göre %$value gün daha geç';
  }

  @override
  String get patternsWeNoticed => 'Fark Ettiğimiz Örüntüler';

  @override
  String get yourMonthInReview => 'Ayının Değerlendirmesi';

  @override
  String get mainFocus => 'Ana Odak';

  @override
  String get keepDoing => 'Böyle Devam Et';

  @override
  String get improve => 'Geliştir';

  @override
  String get watch => 'Dikkat Et';

  @override
  String get watchAdEarnOneUse => 'Reklam izleyerek 1 hak kazanın';

  @override
  String get upgradeToPro => 'FREE';

  @override
  String get unlockAllPremiumFeatures =>
      'Aşağıdaki tüm özelliklerin kilidini aç';

  @override
  String get premiumUnlimitedRecipes => 'Sınırsız tarif oluştur';

  @override
  String get premiumUnlimitedAi => 'Fiteo’ya sınırsız soru sor';

  @override
  String get premiumBarcodeScanning => 'Barkodla ürünü anında ekle';

  @override
  String get premiumSmartNotifications => 'Akıllı bildirimlerle ritmini koru';

  @override
  String get premiumGoalPrediction => 'Hedef tarihini önceden gör';

  @override
  String get premiumAdaptiveProgress => 'Planını ve gelişimini detaylı izle';

  @override
  String get premiumReports => 'Haftalık ve aylık raporlarını gör';

  @override
  String get premiumRecipePersonalization => 'Tariflerini kişiselleştir';

  @override
  String get yearly => 'Yıllık';

  @override
  String get monthly => 'Aylık';

  @override
  String get popular => 'Popüler';

  @override
  String get premiumMembershipTitle => 'Fiteo Premium';

  @override
  String get premiumMembershipActive => 'Premium üyeliğin aktif';

  @override
  String get premiumYearlyPlan => 'Yıllık Plan';

  @override
  String get premiumActive => 'Aktif';

  @override
  String get premiumRenewalDate => 'Yenileme tarihi';

  @override
  String get premiumBenefits => 'Premium avantajların';

  @override
  String get manageSubscription => 'Aboneliği Yönet';

  @override
  String get newPlanTitle => 'Yeni Plan';

  @override
  String get newPlanDescription =>
      'Son ilerlemene göre günlük hedeflerin güncellendi.';

  @override
  String get oldPlanNewPlan => 'Eski plan → Yeni plan';

  @override
  String get saveNewPlan => 'Yeni Planı Kaydet';

  @override
  String get weeklyWeightUpdateTitle => 'Haftalık Kilo Güncellemesi';

  @override
  String get weeklyWeightUpdateDescription =>
      'Planını düzenli takip edebilmemiz için haftalık kilonu ölç ve güncelle.';

  @override
  String get updateWeight => 'Güncelle';

  @override
  String recipeAddedToMeal(String recipeName, String mealType) {
    return '$recipeName, $mealType öğününe eklendi.';
  }
}
