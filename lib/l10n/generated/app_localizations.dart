import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('tr'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Fiteo'**
  String get appName;

  /// No description provided for @continueText.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueText;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get login;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcomeBack;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Log in to continue your journey.'**
  String get loginSubtitle;

  /// No description provided for @emailAndPasswordEmpty.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email and password.'**
  String get emailAndPasswordEmpty;

  /// No description provided for @wrongEmailOrPassword.
  ///
  /// In en, this message translates to:
  /// **'Incorrect email or password.'**
  String get wrongEmailOrPassword;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get or;

  /// No description provided for @googleSignInFailed.
  ///
  /// In en, this message translates to:
  /// **'Google sign-in failed. Please try again.'**
  String get googleSignInFailed;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don’t have an account?'**
  String get dontHaveAccount;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get signUp;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @dateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get dateOfBirth;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @fillAllFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill in all fields.'**
  String get fillAllFields;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters.'**
  String get passwordTooShort;

  /// No description provided for @invalidBirthDate.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid date of birth.'**
  String get invalidBirthDate;

  /// No description provided for @emailAlreadyRegistered.
  ///
  /// In en, this message translates to:
  /// **'An account with this email already exists.'**
  String get emailAlreadyRegistered;

  /// No description provided for @signUpAgreement.
  ///
  /// In en, this message translates to:
  /// **'By signing up, you agree to our Terms of Service and Privacy Policy.'**
  String get signUpAgreement;

  /// No description provided for @verifyEmailTitle.
  ///
  /// In en, this message translates to:
  /// **'E-postanı Doğrula'**
  String get verifyEmailTitle;

  /// No description provided for @verifyEmailDescription.
  ///
  /// In en, this message translates to:
  /// **'E-posta adresine bir doğrulama bağlantısı gönderdik. Devam etmek için gelen kutunu kontrol et ve bağlantıya dokun.'**
  String get verifyEmailDescription;

  /// No description provided for @resendEmail.
  ///
  /// In en, this message translates to:
  /// **'E-postayı Tekrar Gönder'**
  String get resendEmail;

  /// No description provided for @resendEmailWithTime.
  ///
  /// In en, this message translates to:
  /// **'E-postayı Tekrar Gönder ({time})'**
  String resendEmailWithTime(String time);

  /// No description provided for @checking.
  ///
  /// In en, this message translates to:
  /// **'Kontrol Ediliyor...'**
  String get checking;

  /// No description provided for @verify.
  ///
  /// In en, this message translates to:
  /// **'Doğrula'**
  String get verify;

  /// No description provided for @emailVerifiedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'E-posta adresin başarıyla doğrulandı.'**
  String get emailVerifiedSuccessfully;

  /// No description provided for @emailNotVerifiedYet.
  ///
  /// In en, this message translates to:
  /// **'E-posta adresin henüz doğrulanmadı.'**
  String get emailNotVerifiedYet;

  /// No description provided for @verificationEmailSentAgain.
  ///
  /// In en, this message translates to:
  /// **'Doğrulama e-postası tekrar gönderildi.'**
  String get verificationEmailSentAgain;

  /// No description provided for @verificationEmailCouldNotSend.
  ///
  /// In en, this message translates to:
  /// **'Doğrulama e-postası gönderilemedi. Lütfen tekrar dene.'**
  String get verificationEmailCouldNotSend;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get forgotPasswordTitle;

  /// No description provided for @forgotPasswordDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address and we\'ll send you instructions to reset your password.'**
  String get forgotPasswordDescription;

  /// No description provided for @enterEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email address.'**
  String get enterEmail;

  /// No description provided for @emailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required.'**
  String get emailRequired;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address.'**
  String get invalidEmail;

  /// No description provided for @onboardingPage1Title.
  ///
  /// In en, this message translates to:
  /// **'A new you begins here but staying motivated isn\'t always easy.'**
  String get onboardingPage1Title;

  /// No description provided for @onboardingPage2Title.
  ///
  /// In en, this message translates to:
  /// **'You want to live healthier but tracking can be overwhelming.'**
  String get onboardingPage2Title;

  /// No description provided for @onboardingPage3Title.
  ///
  /// In en, this message translates to:
  /// **'What if you had an AI coach that makes this journey easier for you?'**
  String get onboardingPage3Title;

  /// No description provided for @onboardingMeetFiteo.
  ///
  /// In en, this message translates to:
  /// **'Meet Fiteo'**
  String get onboardingMeetFiteo;

  /// No description provided for @onboardingPage4Title.
  ///
  /// In en, this message translates to:
  /// **'Your personal nutrition and fitness companion.'**
  String get onboardingPage4Title;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @planSetupMainGoalTitle.
  ///
  /// In en, this message translates to:
  /// **'What is your main goal?'**
  String get planSetupMainGoalTitle;

  /// No description provided for @goalLoseWeight.
  ///
  /// In en, this message translates to:
  /// **'Lose Weight'**
  String get goalLoseWeight;

  /// No description provided for @goalBuildMuscle.
  ///
  /// In en, this message translates to:
  /// **'Build Muscle'**
  String get goalBuildMuscle;

  /// No description provided for @goalMaintainFitness.
  ///
  /// In en, this message translates to:
  /// **'Maintain Fitness'**
  String get goalMaintainFitness;

  /// No description provided for @goalImproveHealth.
  ///
  /// In en, this message translates to:
  /// **'Improve Health'**
  String get goalImproveHealth;

  /// No description provided for @planSetupAboutYourselfTitle.
  ///
  /// In en, this message translates to:
  /// **'Tell us about yourself'**
  String get planSetupAboutYourselfTitle;

  /// No description provided for @age.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get age;

  /// No description provided for @height.
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get height;

  /// No description provided for @weight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get weight;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @activityLevelTitle.
  ///
  /// In en, this message translates to:
  /// **'How active are you?'**
  String get activityLevelTitle;

  /// No description provided for @activitySedentary.
  ///
  /// In en, this message translates to:
  /// **'Sedentary'**
  String get activitySedentary;

  /// No description provided for @activityLightlyActive.
  ///
  /// In en, this message translates to:
  /// **'Lightly Active'**
  String get activityLightlyActive;

  /// No description provided for @activityModeratelyActive.
  ///
  /// In en, this message translates to:
  /// **'Moderately Active'**
  String get activityModeratelyActive;

  /// No description provided for @activityVeryActive.
  ///
  /// In en, this message translates to:
  /// **'Very Active'**
  String get activityVeryActive;

  /// No description provided for @nutritionPreferenceTitle.
  ///
  /// In en, this message translates to:
  /// **'What do you prefer to eat?'**
  String get nutritionPreferenceTitle;

  /// No description provided for @nutritionNoRestrictions.
  ///
  /// In en, this message translates to:
  /// **'No Restrictions'**
  String get nutritionNoRestrictions;

  /// No description provided for @nutritionHighProtein.
  ///
  /// In en, this message translates to:
  /// **'High Protein'**
  String get nutritionHighProtein;

  /// No description provided for @nutritionVegetarian.
  ///
  /// In en, this message translates to:
  /// **'Vegetarian'**
  String get nutritionVegetarian;

  /// No description provided for @nutritionVegan.
  ///
  /// In en, this message translates to:
  /// **'Vegan'**
  String get nutritionVegan;

  /// No description provided for @nutritionBalancedDiet.
  ///
  /// In en, this message translates to:
  /// **'Balanced Diet'**
  String get nutritionBalancedDiet;

  /// No description provided for @workoutPreferenceTitle.
  ///
  /// In en, this message translates to:
  /// **'How do you like to work out?'**
  String get workoutPreferenceTitle;

  /// No description provided for @workoutHome.
  ///
  /// In en, this message translates to:
  /// **'Home Workouts'**
  String get workoutHome;

  /// No description provided for @workoutGym.
  ///
  /// In en, this message translates to:
  /// **'Gym'**
  String get workoutGym;

  /// No description provided for @workoutWalkingCardio.
  ///
  /// In en, this message translates to:
  /// **'Walking / Cardio'**
  String get workoutWalkingCardio;

  /// No description provided for @workoutStrengthTraining.
  ///
  /// In en, this message translates to:
  /// **'Strength Training'**
  String get workoutStrengthTraining;

  /// No description provided for @goalWeightTitle.
  ///
  /// In en, this message translates to:
  /// **'What is your goal weight?'**
  String get goalWeightTitle;

  /// No description provided for @planPreviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Your goals deserve a plan made for you'**
  String get planPreviewTitle;

  /// No description provided for @planPreviewDescription.
  ///
  /// In en, this message translates to:
  /// **'Generic plans often lose momentum over time. Fiteo adapts to your goals and lifestyle to help you keep progressing toward your goal.'**
  String get planPreviewDescription;

  /// No description provided for @createMyPlan.
  ///
  /// In en, this message translates to:
  /// **'Create my plan'**
  String get createMyPlan;

  /// No description provided for @planProgressOverTime.
  ///
  /// In en, this message translates to:
  /// **'Your progress over time'**
  String get planProgressOverTime;

  /// No description provided for @fiteoPlan.
  ///
  /// In en, this message translates to:
  /// **'Fiteo plan'**
  String get fiteoPlan;

  /// No description provided for @genericPlan.
  ///
  /// In en, this message translates to:
  /// **'Generic plan'**
  String get genericPlan;

  /// No description provided for @chartStart.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get chartStart;

  /// No description provided for @chartEarly.
  ///
  /// In en, this message translates to:
  /// **'Early'**
  String get chartEarly;

  /// No description provided for @chartMid.
  ///
  /// In en, this message translates to:
  /// **'Mid'**
  String get chartMid;

  /// No description provided for @chartGoal.
  ///
  /// In en, this message translates to:
  /// **'Goal'**
  String get chartGoal;

  /// No description provided for @yourGoal.
  ///
  /// In en, this message translates to:
  /// **'Your goal'**
  String get yourGoal;

  /// No description provided for @customizeYourPlan.
  ///
  /// In en, this message translates to:
  /// **'Customize your plan'**
  String get customizeYourPlan;

  /// No description provided for @analyzingGoals.
  ///
  /// In en, this message translates to:
  /// **'Analyzing goals...'**
  String get analyzingGoals;

  /// No description provided for @calculatingCalories.
  ///
  /// In en, this message translates to:
  /// **'Calculating calories...'**
  String get calculatingCalories;

  /// No description provided for @buildingMealSuggestions.
  ///
  /// In en, this message translates to:
  /// **'Building meal suggestions...'**
  String get buildingMealSuggestions;

  /// No description provided for @designingWorkoutRoadmap.
  ///
  /// In en, this message translates to:
  /// **'Designing workout roadmap...'**
  String get designingWorkoutRoadmap;

  /// No description provided for @yourPlanIsReady.
  ///
  /// In en, this message translates to:
  /// **'Your plan is ready!'**
  String get yourPlanIsReady;

  /// No description provided for @savingPersonalizedPlan.
  ///
  /// In en, this message translates to:
  /// **'Saving your personalized plan...'**
  String get savingPersonalizedPlan;

  /// No description provided for @thisMayTakeFewSeconds.
  ///
  /// In en, this message translates to:
  /// **'This may take a few seconds.'**
  String get thisMayTakeFewSeconds;

  /// No description provided for @planCouldNotBeSaved.
  ///
  /// In en, this message translates to:
  /// **'Your plan could not be saved.'**
  String get planCouldNotBeSaved;

  /// No description provided for @aiPlanReadyTitle.
  ///
  /// In en, this message translates to:
  /// **'Your AI plan is ready!'**
  String get aiPlanReadyTitle;

  /// No description provided for @aiPlanReadyDescription.
  ///
  /// In en, this message translates to:
  /// **'We created daily targets based on your goals. You can adjust the values before continuing.'**
  String get aiPlanReadyDescription;

  /// No description provided for @dailyTargets.
  ///
  /// In en, this message translates to:
  /// **'Daily targets'**
  String get dailyTargets;

  /// No description provided for @carbohydrates.
  ///
  /// In en, this message translates to:
  /// **'Carbohydrates'**
  String get carbohydrates;

  /// No description provided for @fats.
  ///
  /// In en, this message translates to:
  /// **'Fats'**
  String get fats;

  /// No description provided for @water.
  ///
  /// In en, this message translates to:
  /// **'Water'**
  String get water;

  /// No description provided for @startMyJourney.
  ///
  /// In en, this message translates to:
  /// **'Start my journey'**
  String get startMyJourney;

  /// No description provided for @planChartTitle.
  ///
  /// In en, this message translates to:
  /// **'Your progress over time'**
  String get planChartTitle;

  /// No description provided for @planChartFiteoPlan.
  ///
  /// In en, this message translates to:
  /// **'Fiteo plan'**
  String get planChartFiteoPlan;

  /// No description provided for @planChartGenericPlan.
  ///
  /// In en, this message translates to:
  /// **'Generic plan'**
  String get planChartGenericPlan;

  /// No description provided for @planChartStart.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get planChartStart;

  /// No description provided for @planChartEarly.
  ///
  /// In en, this message translates to:
  /// **'Early'**
  String get planChartEarly;

  /// No description provided for @planChartMid.
  ///
  /// In en, this message translates to:
  /// **'Mid'**
  String get planChartMid;

  /// No description provided for @planChartGoal.
  ///
  /// In en, this message translates to:
  /// **'Goal'**
  String get planChartGoal;

  /// No description provided for @planChartYourGoal.
  ///
  /// In en, this message translates to:
  /// **'Your goal'**
  String get planChartYourGoal;

  /// No description provided for @sendResetLink.
  ///
  /// In en, this message translates to:
  /// **'Send Reset Link'**
  String get sendResetLink;

  /// No description provided for @sendLink.
  ///
  /// In en, this message translates to:
  /// **'Send Link'**
  String get sendLink;

  /// No description provided for @sending.
  ///
  /// In en, this message translates to:
  /// **'Sending...'**
  String get sending;

  /// No description provided for @resetLinkSent.
  ///
  /// In en, this message translates to:
  /// **'Password reset link sent. Check your email.'**
  String get resetLinkSent;

  /// No description provided for @resetLinkCouldNotSend.
  ///
  /// In en, this message translates to:
  /// **'Password reset link could not be sent. Please try again.'**
  String get resetLinkCouldNotSend;

  /// No description provided for @passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required.'**
  String get passwordRequired;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get somethingWentWrong;

  /// No description provided for @dailySummary.
  ///
  /// In en, this message translates to:
  /// **'Daily Summary'**
  String get dailySummary;

  /// No description provided for @calories.
  ///
  /// In en, this message translates to:
  /// **'Calories'**
  String get calories;

  /// No description provided for @protein.
  ///
  /// In en, this message translates to:
  /// **'Protein'**
  String get protein;

  /// No description provided for @carbs.
  ///
  /// In en, this message translates to:
  /// **'Carbs'**
  String get carbs;

  /// No description provided for @fat.
  ///
  /// In en, this message translates to:
  /// **'Fat'**
  String get fat;

  /// No description provided for @addFood.
  ///
  /// In en, this message translates to:
  /// **'Add Food'**
  String get addFood;

  /// No description provided for @breakfast.
  ///
  /// In en, this message translates to:
  /// **'Breakfast'**
  String get breakfast;

  /// No description provided for @lunch.
  ///
  /// In en, this message translates to:
  /// **'Lunch'**
  String get lunch;

  /// No description provided for @dinner.
  ///
  /// In en, this message translates to:
  /// **'Dinner'**
  String get dinner;

  /// No description provided for @snack.
  ///
  /// In en, this message translates to:
  /// **'Snack'**
  String get snack;

  /// No description provided for @weeklyReport.
  ///
  /// In en, this message translates to:
  /// **'Weekly Report'**
  String get weeklyReport;

  /// No description provided for @monthlyReport.
  ///
  /// In en, this message translates to:
  /// **'Monthly Report'**
  String get monthlyReport;

  /// No description provided for @progress.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get progress;

  /// No description provided for @workout.
  ///
  /// In en, this message translates to:
  /// **'Workout'**
  String get workout;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @recipeCouldNotBeCreated.
  ///
  /// In en, this message translates to:
  /// **'Recipe could not be created. Please try again.'**
  String get recipeCouldNotBeCreated;

  /// No description provided for @couldNotAddRecipeToMeals.
  ///
  /// In en, this message translates to:
  /// **'Could not add recipe to meals.'**
  String get couldNotAddRecipeToMeals;

  /// No description provided for @dailyAiMessageLimitReached.
  ///
  /// In en, this message translates to:
  /// **'Daily AI message limit reached.'**
  String get dailyAiMessageLimitReached;

  /// No description provided for @recipeAddedToMeal.
  ///
  /// In en, this message translates to:
  /// **'{recipeName} added to {mealType}.'**
  String recipeAddedToMeal(String recipeName, String mealType);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
