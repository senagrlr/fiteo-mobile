// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Fiteo';

  @override
  String get continueText => 'Continue';

  @override
  String get back => 'Back';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get done => 'Done';

  @override
  String get close => 'Close';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get login => 'Log In';

  @override
  String get welcomeBack => 'Welcome Back';

  @override
  String get loginSubtitle => 'Log in to continue your journey.';

  @override
  String get emailAndPasswordEmpty => 'Please enter your email and password.';

  @override
  String get wrongEmailOrPassword => 'Incorrect email or password.';

  @override
  String get or => 'or';

  @override
  String get googleSignInFailed => 'Google sign-in failed. Please try again.';

  @override
  String get dontHaveAccount => 'Don’t have an account?';

  @override
  String get signUp => 'Sign up';

  @override
  String get loading => 'Loading...';

  @override
  String get username => 'Username';

  @override
  String get dateOfBirth => 'Date of Birth';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get fillAllFields => 'Please fill in all fields.';

  @override
  String get passwordTooShort => 'Password must be at least 8 characters.';

  @override
  String get invalidBirthDate => 'Please enter a valid date of birth.';

  @override
  String get emailAlreadyRegistered =>
      'An account with this email already exists.';

  @override
  String get signUpAgreement =>
      'By signing up, you agree to our Terms of Service and Privacy Policy.';

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
  String get forgotPassword => 'Forgot Password?';

  @override
  String get forgotPasswordTitle => 'Forgot Password';

  @override
  String get forgotPasswordDescription =>
      'Enter your email address and we\'ll send you instructions to reset your password.';

  @override
  String get enterEmail => 'Please enter your email address.';

  @override
  String get emailRequired => 'Email is required.';

  @override
  String get invalidEmail => 'Please enter a valid email address.';

  @override
  String get onboardingPage1Title =>
      'A new you begins here but staying motivated isn\'t always easy.';

  @override
  String get onboardingPage2Title =>
      'You want to live healthier but tracking can be overwhelming.';

  @override
  String get onboardingPage3Title =>
      'What if you had an AI coach that makes this journey easier for you?';

  @override
  String get onboardingMeetFiteo => 'Meet Fiteo';

  @override
  String get onboardingPage4Title =>
      'Your personal nutrition and fitness companion.';

  @override
  String get skip => 'Skip';

  @override
  String get planSetupMainGoalTitle => 'What is your main goal?';

  @override
  String get goalLoseWeight => 'Lose Weight';

  @override
  String get goalBuildMuscle => 'Build Muscle';

  @override
  String get goalMaintainFitness => 'Maintain Fitness';

  @override
  String get goalImproveHealth => 'Improve Health';

  @override
  String get planSetupAboutYourselfTitle => 'Tell us about yourself';

  @override
  String get age => 'Age';

  @override
  String get height => 'Height';

  @override
  String get weight => 'Weight';

  @override
  String get gender => 'Gender';

  @override
  String get female => 'Female';

  @override
  String get male => 'Male';

  @override
  String get activityLevelTitle => 'How active are you?';

  @override
  String get activitySedentary => 'Sedentary';

  @override
  String get activityLightlyActive => 'Lightly Active';

  @override
  String get activityModeratelyActive => 'Moderately Active';

  @override
  String get activityVeryActive => 'Very Active';

  @override
  String get nutritionPreferenceTitle => 'What do you prefer to eat?';

  @override
  String get nutritionNoRestrictions => 'No Restrictions';

  @override
  String get nutritionHighProtein => 'High Protein';

  @override
  String get nutritionVegetarian => 'Vegetarian';

  @override
  String get nutritionVegan => 'Vegan';

  @override
  String get nutritionBalancedDiet => 'Balanced Diet';

  @override
  String get workoutPreferenceTitle => 'How do you like to work out?';

  @override
  String get workoutHome => 'Home Workouts';

  @override
  String get workoutGym => 'Gym';

  @override
  String get workoutWalkingCardio => 'Walking / Cardio';

  @override
  String get workoutStrengthTraining => 'Strength Training';

  @override
  String get goalWeightTitle => 'What is your goal weight?';

  @override
  String get planPreviewTitle => 'Your goals deserve a plan made for you';

  @override
  String get planPreviewDescription =>
      'Generic plans often lose momentum over time. Fiteo adapts to your goals and lifestyle to help you keep progressing toward your goal.';

  @override
  String get createMyPlan => 'Create my plan';

  @override
  String get planProgressOverTime => 'Your progress over time';

  @override
  String get fiteoPlan => 'Fiteo plan';

  @override
  String get genericPlan => 'Generic plan';

  @override
  String get chartStart => 'Start';

  @override
  String get chartEarly => 'Early';

  @override
  String get chartMid => 'Mid';

  @override
  String get chartGoal => 'Goal';

  @override
  String get yourGoal => 'Your goal';

  @override
  String get customizeYourPlan => 'Customize your plan';

  @override
  String get analyzingGoals => 'Analyzing goals...';

  @override
  String get calculatingCalories => 'Calculating calories...';

  @override
  String get buildingMealSuggestions => 'Building meal suggestions...';

  @override
  String get designingWorkoutRoadmap => 'Designing workout roadmap...';

  @override
  String get yourPlanIsReady => 'Your plan is ready!';

  @override
  String get savingPersonalizedPlan => 'Saving your personalized plan...';

  @override
  String get thisMayTakeFewSeconds => 'This may take a few seconds.';

  @override
  String get planCouldNotBeSaved => 'Your plan could not be saved.';

  @override
  String get aiPlanReadyTitle => 'Your AI plan is ready!';

  @override
  String get aiPlanReadyDescription =>
      'We created daily targets based on your goals. You can adjust the values before continuing.';

  @override
  String get dailyTargets => 'Daily targets';

  @override
  String get carbohydrates => 'Carbohydrates';

  @override
  String get fats => 'Fats';

  @override
  String get water => 'Water';

  @override
  String get startMyJourney => 'Start my journey';

  @override
  String get planChartTitle => 'Your progress over time';

  @override
  String get planChartFiteoPlan => 'Fiteo plan';

  @override
  String get planChartGenericPlan => 'Generic plan';

  @override
  String get planChartStart => 'Start';

  @override
  String get planChartEarly => 'Early';

  @override
  String get planChartMid => 'Mid';

  @override
  String get planChartGoal => 'Goal';

  @override
  String get planChartYourGoal => 'Your goal';

  @override
  String get sendResetLink => 'Send Reset Link';

  @override
  String get sendLink => 'Send Link';

  @override
  String get sending => 'Sending...';

  @override
  String get resetLinkSent => 'Password reset link sent. Check your email.';

  @override
  String get resetLinkCouldNotSend =>
      'Password reset link could not be sent. Please try again.';

  @override
  String get passwordRequired => 'Password is required.';

  @override
  String get somethingWentWrong => 'Something went wrong. Please try again.';

  @override
  String get dailySummary => 'Daily Summary';

  @override
  String get calories => 'Calories';

  @override
  String get protein => 'Protein';

  @override
  String get carbs => 'Carbs';

  @override
  String get fat => 'Fat';

  @override
  String get addFood => 'Add Food';

  @override
  String get breakfast => 'Breakfast';

  @override
  String get lunch => 'Lunch';

  @override
  String get dinner => 'Dinner';

  @override
  String get snack => 'Snack';

  @override
  String get weeklyReport => 'Weekly Report';

  @override
  String get monthlyReport => 'Monthly Report';

  @override
  String get progress => 'Progress';

  @override
  String get workout => 'Workout';

  @override
  String get profile => 'Profile';

  @override
  String get recipeCouldNotBeCreated =>
      'Recipe could not be created. Please try again.';

  @override
  String get couldNotAddRecipeToMeals => 'Could not add recipe to meals.';

  @override
  String get dailyAiMessageLimitReached => 'Daily AI message limit reached.';

  @override
  String recipeAddedToMeal(String recipeName, String mealType) {
    return '$recipeName added to $mealType.';
  }
}
