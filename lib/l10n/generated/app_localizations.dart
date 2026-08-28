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
  /// **'Verify your email'**
  String get verifyEmailTitle;

  /// No description provided for @verifyEmailDescription.
  ///
  /// In en, this message translates to:
  /// **'We’ve sent a verification link to your email address. Please check your inbox and tap the link to continue.'**
  String get verifyEmailDescription;

  /// No description provided for @resendEmail.
  ///
  /// In en, this message translates to:
  /// **'Resend Email'**
  String get resendEmail;

  /// No description provided for @resendEmailWithTime.
  ///
  /// In en, this message translates to:
  /// **'Resend Email ({time})'**
  String resendEmailWithTime(String time);

  /// No description provided for @checking.
  ///
  /// In en, this message translates to:
  /// **'Checking...'**
  String get checking;

  /// No description provided for @verify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// No description provided for @emailVerifiedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Your email has been verified successfully.'**
  String get emailVerifiedSuccessfully;

  /// No description provided for @emailNotVerifiedYet.
  ///
  /// In en, this message translates to:
  /// **'Your email has not been verified yet.'**
  String get emailNotVerifiedYet;

  /// No description provided for @verificationEmailSentAgain.
  ///
  /// In en, this message translates to:
  /// **'Verification email sent again.'**
  String get verificationEmailSentAgain;

  /// No description provided for @verificationEmailCouldNotSend.
  ///
  /// In en, this message translates to:
  /// **'Verification email could not be sent. Please try again.'**
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

  /// No description provided for @foodIntake.
  ///
  /// In en, this message translates to:
  /// **'Food Intake'**
  String get foodIntake;

  /// No description provided for @exerciseBurn.
  ///
  /// In en, this message translates to:
  /// **'Exercise Burn'**
  String get exerciseBurn;

  /// No description provided for @netCalories.
  ///
  /// In en, this message translates to:
  /// **'Net Calories'**
  String get netCalories;

  /// No description provided for @hydration.
  ///
  /// In en, this message translates to:
  /// **'Hydration'**
  String get hydration;

  /// No description provided for @remaining.
  ///
  /// In en, this message translates to:
  /// **'Remaining'**
  String get remaining;

  /// No description provided for @calorieGoal.
  ///
  /// In en, this message translates to:
  /// **'Calorie Goal'**
  String get calorieGoal;

  /// No description provided for @caloriesOverGoal.
  ///
  /// In en, this message translates to:
  /// **'{calories} kcal over'**
  String caloriesOverGoal(int calories);

  /// No description provided for @caloriesPerDay.
  ///
  /// In en, this message translates to:
  /// **'{calories} kcal/day'**
  String caloriesPerDay(int calories);

  /// No description provided for @consumed.
  ///
  /// In en, this message translates to:
  /// **'Consumed'**
  String get consumed;

  /// No description provided for @burned.
  ///
  /// In en, this message translates to:
  /// **'Burned'**
  String get burned;

  /// No description provided for @net.
  ///
  /// In en, this message translates to:
  /// **'Net'**
  String get net;

  /// No description provided for @todaysMacros.
  ///
  /// In en, this message translates to:
  /// **'Today’s Macros'**
  String get todaysMacros;

  /// No description provided for @macroGoalTitle.
  ///
  /// In en, this message translates to:
  /// **'{macro} Goal'**
  String macroGoalTitle(String macro);

  /// No description provided for @viewCalendar.
  ///
  /// In en, this message translates to:
  /// **'View calendar'**
  String get viewCalendar;

  /// No description provided for @streakDays.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 day} other{{count} days}}'**
  String streakDays(int count);

  /// No description provided for @defaultAiFeedbackMessage.
  ///
  /// In en, this message translates to:
  /// **'You’re building your routine step by step.'**
  String get defaultAiFeedbackMessage;

  /// No description provided for @defaultAiFeedbackSuggestion.
  ///
  /// In en, this message translates to:
  /// **'Keep tracking your meals and movement today to stay aware of your progress.'**
  String get defaultAiFeedbackSuggestion;

  /// No description provided for @drink.
  ///
  /// In en, this message translates to:
  /// **'Drink'**
  String get drink;

  /// No description provided for @enterWaterAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter water amount'**
  String get enterWaterAmount;

  /// No description provided for @addFood.
  ///
  /// In en, this message translates to:
  /// **'Add Food'**
  String get addFood;

  /// No description provided for @foodName.
  ///
  /// In en, this message translates to:
  /// **'Food name'**
  String get foodName;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @grams.
  ///
  /// In en, this message translates to:
  /// **'Grams'**
  String get grams;

  /// No description provided for @pieces.
  ///
  /// In en, this message translates to:
  /// **'Pieces'**
  String get pieces;

  /// No description provided for @calorieEstimateDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'( Calories are estimated based on\naverage nutritional values. )'**
  String get calorieEstimateDisclaimer;

  /// No description provided for @couldNotAddFood.
  ///
  /// In en, this message translates to:
  /// **'Could not add food.'**
  String get couldNotAddFood;

  /// No description provided for @couldNotDeleteFood.
  ///
  /// In en, this message translates to:
  /// **'Could not delete food.'**
  String get couldNotDeleteFood;

  /// No description provided for @couldNotLoadMeals.
  ///
  /// In en, this message translates to:
  /// **'Could not load meals.'**
  String get couldNotLoadMeals;

  /// No description provided for @deleteFood.
  ///
  /// In en, this message translates to:
  /// **'Delete food'**
  String get deleteFood;

  /// No description provided for @todaysMeal.
  ///
  /// In en, this message translates to:
  /// **'Today’s {meal}'**
  String todaysMeal(String meal);

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

  /// No description provided for @monthlyCalendar.
  ///
  /// In en, this message translates to:
  /// **'Monthly Calendar'**
  String get monthlyCalendar;

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

  /// No description provided for @recipeCouldNotBeSaved.
  ///
  /// In en, this message translates to:
  /// **'Recipe could not be saved.'**
  String get recipeCouldNotBeSaved;

  /// No description provided for @removeFromSaved.
  ///
  /// In en, this message translates to:
  /// **'Remove from saved'**
  String get removeFromSaved;

  /// No description provided for @saveRecipe.
  ///
  /// In en, this message translates to:
  /// **'Save recipe'**
  String get saveRecipe;

  /// No description provided for @addToIntake.
  ///
  /// In en, this message translates to:
  /// **'Add to intake'**
  String get addToIntake;

  /// No description provided for @ingredients.
  ///
  /// In en, this message translates to:
  /// **'Ingredients'**
  String get ingredients;

  /// No description provided for @instructions.
  ///
  /// In en, this message translates to:
  /// **'Instructions'**
  String get instructions;

  /// No description provided for @nutrition.
  ///
  /// In en, this message translates to:
  /// **'Nutrition'**
  String get nutrition;

  /// No description provided for @servings.
  ///
  /// In en, this message translates to:
  /// **'Servings'**
  String get servings;

  /// No description provided for @totalCalories.
  ///
  /// In en, this message translates to:
  /// **'Total calories'**
  String get totalCalories;

  /// No description provided for @perServing.
  ///
  /// In en, this message translates to:
  /// **'Per serving'**
  String get perServing;

  /// No description provided for @dailyAiMessageLimitReached.
  ///
  /// In en, this message translates to:
  /// **'Daily AI message limit reached.'**
  String get dailyAiMessageLimitReached;

  /// No description provided for @aiWelcomeMessage.
  ///
  /// In en, this message translates to:
  /// **'Hi, I’m Fiteo. Let’s improve your journey together. You can switch to cook mode.'**
  String get aiWelcomeMessage;

  /// No description provided for @aiMessageInputHint.
  ///
  /// In en, this message translates to:
  /// **'Tell me your goal, I’ll guide you'**
  String get aiMessageInputHint;

  /// No description provided for @aiCouldNotRespond.
  ///
  /// In en, this message translates to:
  /// **'Sorry, I could not respond right now. Please try again later.'**
  String get aiCouldNotRespond;

  /// No description provided for @aiChatGreeting.
  ///
  /// In en, this message translates to:
  /// **'Hi, I’m Fiteo. Tell me your goal and I’ll guide you.'**
  String get aiChatGreeting;

  /// No description provided for @deleteMessage.
  ///
  /// In en, this message translates to:
  /// **'Delete message'**
  String get deleteMessage;

  /// No description provided for @aiMessagesLeftToday.
  ///
  /// In en, this message translates to:
  /// **'{count} AI messages left today'**
  String aiMessagesLeftToday(int count);

  /// No description provided for @creatingRecipe.
  ///
  /// In en, this message translates to:
  /// **'Creating your recipe...\nPlease wait.'**
  String get creatingRecipe;

  /// No description provided for @enterIngredients.
  ///
  /// In en, this message translates to:
  /// **'Enter ingredients'**
  String get enterIngredients;

  /// No description provided for @cookWelcomeMessage.
  ///
  /// In en, this message translates to:
  /// **'Type ingredients, I’ll cook up the best recipe for you.'**
  String get cookWelcomeMessage;

  /// No description provided for @dailyRecipeLimitReached.
  ///
  /// In en, this message translates to:
  /// **'Daily recipe limit reached.'**
  String get dailyRecipeLimitReached;

  /// No description provided for @recipeRequestsLeftToday.
  ///
  /// In en, this message translates to:
  /// **'{count} recipe requests left today'**
  String recipeRequestsLeftToday(int count);

  /// No description provided for @addExercise.
  ///
  /// In en, this message translates to:
  /// **'Add exercise'**
  String get addExercise;

  /// No description provided for @exerciseName.
  ///
  /// In en, this message translates to:
  /// **'Exercise name'**
  String get exerciseName;

  /// No description provided for @durationMinutes.
  ///
  /// In en, this message translates to:
  /// **'Duration (minutes)'**
  String get durationMinutes;

  /// No description provided for @intensity.
  ///
  /// In en, this message translates to:
  /// **'Intensity'**
  String get intensity;

  /// No description provided for @intensityLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get intensityLow;

  /// No description provided for @intensityMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get intensityMedium;

  /// No description provided for @intensityHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get intensityHigh;

  /// No description provided for @calculating.
  ///
  /// In en, this message translates to:
  /// **'Calculating...'**
  String get calculating;

  /// No description provided for @caloriesBurned.
  ///
  /// In en, this message translates to:
  /// **'Calories burned'**
  String get caloriesBurned;

  /// No description provided for @metEstimateDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'( Calories are estimated using average\nMET values. )'**
  String get metEstimateDisclaimer;

  /// No description provided for @duration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// No description provided for @minutesShort.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String minutesShort(int minutes);

  /// No description provided for @saveCalories.
  ///
  /// In en, this message translates to:
  /// **'Save calories'**
  String get saveCalories;

  /// No description provided for @deleteExercise.
  ///
  /// In en, this message translates to:
  /// **'Delete exercise'**
  String get deleteExercise;

  /// No description provided for @todaysExercises.
  ///
  /// In en, this message translates to:
  /// **'Today’s Exercises'**
  String get todaysExercises;

  /// No description provided for @couldNotAddExercise.
  ///
  /// In en, this message translates to:
  /// **'Could not add exercise.'**
  String get couldNotAddExercise;

  /// No description provided for @couldNotUpdateCalories.
  ///
  /// In en, this message translates to:
  /// **'Could not update calories.'**
  String get couldNotUpdateCalories;

  /// No description provided for @couldNotDeleteExercise.
  ///
  /// In en, this message translates to:
  /// **'Could not delete exercise.'**
  String get couldNotDeleteExercise;

  /// No description provided for @couldNotLoadExercises.
  ///
  /// In en, this message translates to:
  /// **'Could not load exercises.'**
  String get couldNotLoadExercises;

  /// No description provided for @allergens.
  ///
  /// In en, this message translates to:
  /// **'Allergens'**
  String get allergens;

  /// No description provided for @allergenDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'AI-generated allergen information. Always check ingredient labels before consuming.'**
  String get allergenDisclaimer;

  /// No description provided for @allergenGluten.
  ///
  /// In en, this message translates to:
  /// **'Gluten'**
  String get allergenGluten;

  /// No description provided for @allergenDairy.
  ///
  /// In en, this message translates to:
  /// **'Dairy'**
  String get allergenDairy;

  /// No description provided for @allergenEgg.
  ///
  /// In en, this message translates to:
  /// **'Egg'**
  String get allergenEgg;

  /// No description provided for @allergenPeanuts.
  ///
  /// In en, this message translates to:
  /// **'Peanuts'**
  String get allergenPeanuts;

  /// No description provided for @allergenTreeNuts.
  ///
  /// In en, this message translates to:
  /// **'Tree nuts'**
  String get allergenTreeNuts;

  /// No description provided for @allergenSoy.
  ///
  /// In en, this message translates to:
  /// **'Soy'**
  String get allergenSoy;

  /// No description provided for @allergenFish.
  ///
  /// In en, this message translates to:
  /// **'Fish'**
  String get allergenFish;

  /// No description provided for @allergenShellfish.
  ///
  /// In en, this message translates to:
  /// **'Shellfish'**
  String get allergenShellfish;

  /// No description provided for @allergenSesame.
  ///
  /// In en, this message translates to:
  /// **'Sesame'**
  String get allergenSesame;

  /// No description provided for @deleteMyAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete my account'**
  String get deleteMyAccount;

  /// No description provided for @sorryToSeeYouGo.
  ///
  /// In en, this message translates to:
  /// **'Sorry to see you go'**
  String get sorryToSeeYouGo;

  /// No description provided for @deleteAccountDescription.
  ///
  /// In en, this message translates to:
  /// **'Deleting your account will permanently remove your profile and personal data. This action cannot be undone.'**
  String get deleteAccountDescription;

  /// No description provided for @enterCurrentPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your current password'**
  String get enterCurrentPassword;

  /// No description provided for @deleting.
  ///
  /// In en, this message translates to:
  /// **'Deleting...'**
  String get deleting;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @currentPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Current password is required.'**
  String get currentPasswordRequired;

  /// No description provided for @currentPasswordIncorrect.
  ///
  /// In en, this message translates to:
  /// **'Current password is incorrect.'**
  String get currentPasswordIncorrect;

  /// No description provided for @recentLoginRequired.
  ///
  /// In en, this message translates to:
  /// **'Please log in again before deleting your account.'**
  String get recentLoginRequired;

  /// No description provided for @accountDeleteFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not delete your account. Please try again.'**
  String get accountDeleteFailed;

  /// No description provided for @accountDeleted.
  ///
  /// In en, this message translates to:
  /// **'Your account has been deleted.'**
  String get accountDeleted;

  /// No description provided for @weeklyCalories.
  ///
  /// In en, this message translates to:
  /// **'Weekly Calories'**
  String get weeklyCalories;

  /// No description provided for @mondayShort.
  ///
  /// In en, this message translates to:
  /// **'MON'**
  String get mondayShort;

  /// No description provided for @tuesdayShort.
  ///
  /// In en, this message translates to:
  /// **'TUE'**
  String get tuesdayShort;

  /// No description provided for @wednesdayShort.
  ///
  /// In en, this message translates to:
  /// **'WED'**
  String get wednesdayShort;

  /// No description provided for @thursdayShort.
  ///
  /// In en, this message translates to:
  /// **'THU'**
  String get thursdayShort;

  /// No description provided for @fridayShort.
  ///
  /// In en, this message translates to:
  /// **'FRI'**
  String get fridayShort;

  /// No description provided for @saturdayShort.
  ///
  /// In en, this message translates to:
  /// **'SAT'**
  String get saturdayShort;

  /// No description provided for @sundayShort.
  ///
  /// In en, this message translates to:
  /// **'SUN'**
  String get sundayShort;

  /// No description provided for @januaryShort.
  ///
  /// In en, this message translates to:
  /// **'J'**
  String get januaryShort;

  /// No description provided for @februaryShort.
  ///
  /// In en, this message translates to:
  /// **'F'**
  String get februaryShort;

  /// No description provided for @marchShort.
  ///
  /// In en, this message translates to:
  /// **'M'**
  String get marchShort;

  /// No description provided for @aprilShort.
  ///
  /// In en, this message translates to:
  /// **'A'**
  String get aprilShort;

  /// No description provided for @mayShort.
  ///
  /// In en, this message translates to:
  /// **'M'**
  String get mayShort;

  /// No description provided for @juneShort.
  ///
  /// In en, this message translates to:
  /// **'J'**
  String get juneShort;

  /// No description provided for @julyShort.
  ///
  /// In en, this message translates to:
  /// **'J'**
  String get julyShort;

  /// No description provided for @augustShort.
  ///
  /// In en, this message translates to:
  /// **'A'**
  String get augustShort;

  /// No description provided for @septemberShort.
  ///
  /// In en, this message translates to:
  /// **'S'**
  String get septemberShort;

  /// No description provided for @octoberShort.
  ///
  /// In en, this message translates to:
  /// **'O'**
  String get octoberShort;

  /// No description provided for @novemberShort.
  ///
  /// In en, this message translates to:
  /// **'N'**
  String get novemberShort;

  /// No description provided for @decemberShort.
  ///
  /// In en, this message translates to:
  /// **'D'**
  String get decemberShort;

  /// No description provided for @weekShort.
  ///
  /// In en, this message translates to:
  /// **'W'**
  String get weekShort;

  /// No description provided for @minuteUnitShort.
  ///
  /// In en, this message translates to:
  /// **'min'**
  String get minuteUnitShort;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @chooseYourMascot.
  ///
  /// In en, this message translates to:
  /// **'Choose your mascot'**
  String get chooseYourMascot;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @currentPassword.
  ///
  /// In en, this message translates to:
  /// **'Current password'**
  String get currentPassword;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get newPassword;

  /// No description provided for @confirmNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm new password'**
  String get confirmNewPassword;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveChanges;

  /// No description provided for @savedRecipes.
  ///
  /// In en, this message translates to:
  /// **'Saved Recipes'**
  String get savedRecipes;

  /// No description provided for @goalsPreferences.
  ///
  /// In en, this message translates to:
  /// **'Goals & Preferences'**
  String get goalsPreferences;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logOut;

  /// No description provided for @noSavedRecipesYet.
  ///
  /// In en, this message translates to:
  /// **'No saved recipes yet.'**
  String get noSavedRecipesYet;

  /// No description provided for @bodyGoals.
  ///
  /// In en, this message translates to:
  /// **'Body Goals'**
  String get bodyGoals;

  /// No description provided for @preferencesTitle.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferencesTitle;

  /// No description provided for @currentWeightKg.
  ///
  /// In en, this message translates to:
  /// **'Current weight (kg)'**
  String get currentWeightKg;

  /// No description provided for @targetWeightKg.
  ///
  /// In en, this message translates to:
  /// **'Target weight (kg)'**
  String get targetWeightKg;

  /// No description provided for @dailyCalorieGoal.
  ///
  /// In en, this message translates to:
  /// **'Daily calorie goal'**
  String get dailyCalorieGoal;

  /// No description provided for @preferencesUpdated.
  ///
  /// In en, this message translates to:
  /// **'Preferences updated successfully.'**
  String get preferencesUpdated;

  /// No description provided for @preferencesUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Preferences could not be updated. Please try again.'**
  String get preferencesUpdateFailed;

  /// No description provided for @usernameRequired.
  ///
  /// In en, this message translates to:
  /// **'Username is required.'**
  String get usernameRequired;

  /// No description provided for @passwordMinLength.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters.'**
  String get passwordMinLength;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match.'**
  String get passwordsDoNotMatch;

  /// No description provided for @passwordUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Password could not be updated.'**
  String get passwordUpdateFailed;

  /// No description provided for @profileUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Profile could not be updated. Please try again.'**
  String get profileUpdateFailed;

  /// No description provided for @profileUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully.'**
  String get profileUpdated;

  /// No description provided for @planTracking.
  ///
  /// In en, this message translates to:
  /// **'Plan Tracking'**
  String get planTracking;

  /// No description provided for @overview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get overview;

  /// No description provided for @plan.
  ///
  /// In en, this message translates to:
  /// **'Plan'**
  String get plan;

  /// No description provided for @fiteoScore.
  ///
  /// In en, this message translates to:
  /// **'Fiteo Score'**
  String get fiteoScore;

  /// No description provided for @currentStreak.
  ///
  /// In en, this message translates to:
  /// **'Current Streak'**
  String get currentStreak;

  /// No description provided for @trackingConsistency.
  ///
  /// In en, this message translates to:
  /// **'Tracking Consistency'**
  String get trackingConsistency;

  /// No description provided for @goalAchievement.
  ///
  /// In en, this message translates to:
  /// **'Goal Achievement'**
  String get goalAchievement;

  /// No description provided for @days.
  ///
  /// In en, this message translates to:
  /// **'Days'**
  String get days;

  /// No description provided for @yourUniqueFeatures.
  ///
  /// In en, this message translates to:
  /// **'Your Unique Features'**
  String get yourUniqueFeatures;

  /// No description provided for @longestStreak.
  ///
  /// In en, this message translates to:
  /// **'Longest Streak'**
  String get longestStreak;

  /// No description provided for @bestProtein.
  ///
  /// In en, this message translates to:
  /// **'Best Protein'**
  String get bestProtein;

  /// No description provided for @mostActiveDay.
  ///
  /// In en, this message translates to:
  /// **'Most Active Day'**
  String get mostActiveDay;

  /// No description provided for @achievementLongestStreak.
  ///
  /// In en, this message translates to:
  /// **'Longest Streak'**
  String get achievementLongestStreak;

  /// No description provided for @achievementLongestStreakDescription.
  ///
  /// In en, this message translates to:
  /// **'Your longest streak of consecutive days with meaningful tracking.'**
  String get achievementLongestStreakDescription;

  /// No description provided for @achievementBestProtein.
  ///
  /// In en, this message translates to:
  /// **'Best Protein'**
  String get achievementBestProtein;

  /// No description provided for @achievementBestProteinDescription.
  ///
  /// In en, this message translates to:
  /// **'The day your protein intake matched your protein goal most closely.'**
  String get achievementBestProteinDescription;

  /// No description provided for @achievementMostActiveDay.
  ///
  /// In en, this message translates to:
  /// **'Most Active Day'**
  String get achievementMostActiveDay;

  /// No description provided for @achievementMostActiveDayDescription.
  ///
  /// In en, this message translates to:
  /// **'The day of the week where you have accumulated the most workout time.'**
  String get achievementMostActiveDayDescription;

  /// No description provided for @achievementHydrationHero.
  ///
  /// In en, this message translates to:
  /// **'Hydration Hero'**
  String get achievementHydrationHero;

  /// No description provided for @achievementHydrationHeroDescription.
  ///
  /// In en, this message translates to:
  /// **'Your overall adherence to your daily hydration goal.'**
  String get achievementHydrationHeroDescription;

  /// No description provided for @achievementNutritionPro.
  ///
  /// In en, this message translates to:
  /// **'Nutrition Pro'**
  String get achievementNutritionPro;

  /// No description provided for @achievementNutritionProDescription.
  ///
  /// In en, this message translates to:
  /// **'Your overall adherence across calories, protein, carbs, and fat.'**
  String get achievementNutritionProDescription;

  /// No description provided for @achievementBalancedDays.
  ///
  /// In en, this message translates to:
  /// **'Balanced Days'**
  String get achievementBalancedDays;

  /// No description provided for @achievementBalancedDaysDescription.
  ///
  /// In en, this message translates to:
  /// **'Days where calories, protein, carbs, and fat were all close to their targets.'**
  String get achievementBalancedDaysDescription;

  /// No description provided for @achievementActiveChampion.
  ///
  /// In en, this message translates to:
  /// **'Active Champion'**
  String get achievementActiveChampion;

  /// No description provided for @achievementActiveChampionDescription.
  ///
  /// In en, this message translates to:
  /// **'Your overall performance based on days with at least 20 minutes of exercise.'**
  String get achievementActiveChampionDescription;

  /// No description provided for @achievementGoalKeeper.
  ///
  /// In en, this message translates to:
  /// **'Goal Keeper'**
  String get achievementGoalKeeper;

  /// No description provided for @achievementGoalKeeperDescription.
  ///
  /// In en, this message translates to:
  /// **'The goal you have successfully reached most often.'**
  String get achievementGoalKeeperDescription;

  /// No description provided for @achievementCalorieCompass.
  ///
  /// In en, this message translates to:
  /// **'Calorie Compass'**
  String get achievementCalorieCompass;

  /// No description provided for @achievementCalorieCompassDescription.
  ///
  /// In en, this message translates to:
  /// **'How consistently your net calories stay close to your calorie goal.'**
  String get achievementCalorieCompassDescription;

  /// No description provided for @achievementHydrationStreak.
  ///
  /// In en, this message translates to:
  /// **'Hydration Streak'**
  String get achievementHydrationStreak;

  /// No description provided for @achievementHydrationStreakDescription.
  ///
  /// In en, this message translates to:
  /// **'Your longest streak of consecutive days reaching your hydration goal.'**
  String get achievementHydrationStreakDescription;

  /// No description provided for @overviewNoAchievements.
  ///
  /// In en, this message translates to:
  /// **'Keep tracking to discover your strengths.'**
  String get overviewNoAchievements;

  /// No description provided for @monday.
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get monday;

  /// No description provided for @tuesday.
  ///
  /// In en, this message translates to:
  /// **'Tuesday'**
  String get tuesday;

  /// No description provided for @wednesday.
  ///
  /// In en, this message translates to:
  /// **'Wednesday'**
  String get wednesday;

  /// No description provided for @thursday.
  ///
  /// In en, this message translates to:
  /// **'Thursday'**
  String get thursday;

  /// No description provided for @friday.
  ///
  /// In en, this message translates to:
  /// **'Friday'**
  String get friday;

  /// No description provided for @saturday.
  ///
  /// In en, this message translates to:
  /// **'Saturday'**
  String get saturday;

  /// No description provided for @sunday.
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get sunday;

  /// No description provided for @onTrack.
  ///
  /// In en, this message translates to:
  /// **'On Track'**
  String get onTrack;

  /// No description provided for @reviewRecommended.
  ///
  /// In en, this message translates to:
  /// **'Review Recommended'**
  String get reviewRecommended;

  /// No description provided for @notEnoughData.
  ///
  /// In en, this message translates to:
  /// **'Not Enough Data'**
  String get notEnoughData;

  /// No description provided for @improveConsistencyFirst.
  ///
  /// In en, this message translates to:
  /// **'Improve Consistency First'**
  String get improveConsistencyFirst;

  /// No description provided for @startWeight.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get startWeight;

  /// No description provided for @goalReachDate.
  ///
  /// In en, this message translates to:
  /// **'Goal Date'**
  String get goalReachDate;

  /// No description provided for @goalWeight.
  ///
  /// In en, this message translates to:
  /// **'Goal'**
  String get goalWeight;

  /// No description provided for @weightProgress.
  ///
  /// In en, this message translates to:
  /// **'Weight Progress'**
  String get weightProgress;

  /// No description provided for @actualWeight.
  ///
  /// In en, this message translates to:
  /// **'Your Progress'**
  String get actualWeight;

  /// No description provided for @expectedWeight.
  ///
  /// In en, this message translates to:
  /// **'Planned Progress'**
  String get expectedWeight;

  /// No description provided for @april.
  ///
  /// In en, this message translates to:
  /// **'April'**
  String get april;

  /// No description provided for @may.
  ///
  /// In en, this message translates to:
  /// **'May'**
  String get may;

  /// No description provided for @june.
  ///
  /// In en, this message translates to:
  /// **'June'**
  String get june;

  /// No description provided for @july.
  ///
  /// In en, this message translates to:
  /// **'July'**
  String get july;

  /// No description provided for @onTrackPlanNoteWithDate.
  ///
  /// In en, this message translates to:
  /// **'You\'re following your plan consistently and your progress is moving as expected. If you keep going like this, you\'re estimated to reach your goal around {date}.'**
  String onTrackPlanNoteWithDate(String date);

  /// No description provided for @reviewRecommendedPlanNote.
  ///
  /// In en, this message translates to:
  /// **'Your recent progress suggests that your current plan may no longer be the best fit for you. We\'ve prepared an updated plan based on your latest progress.'**
  String get reviewRecommendedPlanNote;

  /// No description provided for @notEnoughDataPlanNote.
  ///
  /// In en, this message translates to:
  /// **'There isn\'t enough recent data to evaluate your progress reliably yet. Keep logging your weight, meals and activity so we can assess your plan more accurately.'**
  String get notEnoughDataPlanNote;

  /// No description provided for @improveConsistencyPlanNote.
  ///
  /// In en, this message translates to:
  /// **'Your recent plan adherence is too inconsistent for a reliable evaluation. Follow your current plan more consistently first, then we\'ll reassess whether it needs to change.'**
  String get improveConsistencyPlanNote;

  /// No description provided for @reviewNewPlan.
  ///
  /// In en, this message translates to:
  /// **'Review New Plan'**
  String get reviewNewPlan;

  /// No description provided for @fiteoOverviewNote.
  ///
  /// In en, this message translates to:
  /// **'When you\'re on track, you usually stay fully committed. What matters most is consistency, so keep an eye on that.'**
  String get fiteoOverviewNote;

  /// No description provided for @dailyAverage.
  ///
  /// In en, this message translates to:
  /// **'Daily Average'**
  String get dailyAverage;

  /// No description provided for @target.
  ///
  /// In en, this message translates to:
  /// **'Target'**
  String get target;

  /// No description provided for @onTargetDays.
  ///
  /// In en, this message translates to:
  /// **'On-Target Days'**
  String get onTargetDays;

  /// No description provided for @totalWorkout.
  ///
  /// In en, this message translates to:
  /// **'Total Workout'**
  String get totalWorkout;

  /// No description provided for @activeDays.
  ///
  /// In en, this message translates to:
  /// **'Active Days'**
  String get activeDays;

  /// No description provided for @averageDuration.
  ///
  /// In en, this message translates to:
  /// **'Average Duration'**
  String get averageDuration;

  /// No description provided for @totalChange.
  ///
  /// In en, this message translates to:
  /// **'Total Change'**
  String get totalChange;

  /// No description provided for @weeklyRate.
  ///
  /// In en, this message translates to:
  /// **'Weekly Rate'**
  String get weeklyRate;

  /// No description provided for @days7.
  ///
  /// In en, this message translates to:
  /// **'7 days'**
  String get days7;

  /// No description provided for @days30.
  ///
  /// In en, this message translates to:
  /// **'30 days'**
  String get days30;

  /// No description provided for @days90.
  ///
  /// In en, this message translates to:
  /// **'90 days'**
  String get days90;

  /// No description provided for @days365.
  ///
  /// In en, this message translates to:
  /// **'365 days'**
  String get days365;

  /// No description provided for @dailyAverageCalories.
  ///
  /// In en, this message translates to:
  /// **'Daily Average (calorie)'**
  String get dailyAverageCalories;

  /// No description provided for @dailyAverageWater.
  ///
  /// In en, this message translates to:
  /// **'Daily Average (liter)'**
  String get dailyAverageWater;

  /// No description provided for @addWithBarcode.
  ///
  /// In en, this message translates to:
  /// **'Add by Barcode'**
  String get addWithBarcode;

  /// No description provided for @enterBarcodeNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter Barcode'**
  String get enterBarcodeNumber;

  /// No description provided for @barcodeNumber.
  ///
  /// In en, this message translates to:
  /// **'Barcode Number'**
  String get barcodeNumber;

  /// No description provided for @barcodeNumberHint.
  ///
  /// In en, this message translates to:
  /// **'Enter barcode number'**
  String get barcodeNumberHint;

  /// No description provided for @barcodeSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get barcodeSearch;

  /// No description provided for @barcodeCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get barcodeCancel;

  /// No description provided for @barcodeScanHint.
  ///
  /// In en, this message translates to:
  /// **'Align the barcode inside the frame'**
  String get barcodeScanHint;

  /// No description provided for @barcodeLookingUp.
  ///
  /// In en, this message translates to:
  /// **'Looking up product...'**
  String get barcodeLookingUp;

  /// No description provided for @addScannedFood.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get addScannedFood;

  /// No description provided for @barcodeDemoProduct.
  ///
  /// In en, this message translates to:
  /// **'Sample Product'**
  String get barcodeDemoProduct;

  /// No description provided for @yourWeek.
  ///
  /// In en, this message translates to:
  /// **'Your Week'**
  String get yourWeek;

  /// No description provided for @activity.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get activity;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @bestDay.
  ///
  /// In en, this message translates to:
  /// **'Best Day'**
  String get bestDay;

  /// No description provided for @worstDay.
  ///
  /// In en, this message translates to:
  /// **'Worst Day'**
  String get worstDay;

  /// No description provided for @aligned.
  ///
  /// In en, this message translates to:
  /// **'aligned'**
  String get aligned;

  /// No description provided for @weightAndPlan.
  ///
  /// In en, this message translates to:
  /// **'Weight & Plan'**
  String get weightAndPlan;

  /// No description provided for @lastWeek.
  ///
  /// In en, this message translates to:
  /// **'Last Week'**
  String get lastWeek;

  /// No description provided for @now.
  ///
  /// In en, this message translates to:
  /// **'Now'**
  String get now;

  /// No description provided for @planStatus.
  ///
  /// In en, this message translates to:
  /// **'Plan Status'**
  String get planStatus;

  /// No description provided for @estimatedGoalDate.
  ///
  /// In en, this message translates to:
  /// **'Estimated Goal Date'**
  String get estimatedGoalDate;

  /// No description provided for @yourWeekInReview.
  ///
  /// In en, this message translates to:
  /// **'Your Week in Review'**
  String get yourWeekInReview;

  /// No description provided for @nextWeek.
  ///
  /// In en, this message translates to:
  /// **'Next Week'**
  String get nextWeek;

  /// No description provided for @nextWeekPlan.
  ///
  /// In en, this message translates to:
  /// **'Next Week Plan'**
  String get nextWeekPlan;

  /// No description provided for @yourMainFocus.
  ///
  /// In en, this message translates to:
  /// **'Your main focus'**
  String get yourMainFocus;

  /// No description provided for @tryThis.
  ///
  /// In en, this message translates to:
  /// **'Try This'**
  String get tryThis;

  /// No description provided for @weeklyScoreChange.
  ///
  /// In en, this message translates to:
  /// **'%{value} from last week'**
  String weeklyScoreChange(int value);

  /// No description provided for @reportStatusStrong.
  ///
  /// In en, this message translates to:
  /// **'Strong'**
  String get reportStatusStrong;

  /// No description provided for @reportStatusGood.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get reportStatusGood;

  /// No description provided for @reportStatusNeedsFocus.
  ///
  /// In en, this message translates to:
  /// **'Needs Focus'**
  String get reportStatusNeedsFocus;

  /// No description provided for @reportStatusNeedsImprovement.
  ///
  /// In en, this message translates to:
  /// **'Needs Improvement'**
  String get reportStatusNeedsImprovement;

  /// No description provided for @weeklyScoreStrong.
  ///
  /// In en, this message translates to:
  /// **'Strong Week'**
  String get weeklyScoreStrong;

  /// No description provided for @weeklyScoreGood.
  ///
  /// In en, this message translates to:
  /// **'Good Week'**
  String get weeklyScoreGood;

  /// No description provided for @weeklyScoreNeedsFocus.
  ///
  /// In en, this message translates to:
  /// **'Needs Focus'**
  String get weeklyScoreNeedsFocus;

  /// No description provided for @weeklyScoreNeedsImprovement.
  ///
  /// In en, this message translates to:
  /// **'Needs Improvement'**
  String get weeklyScoreNeedsImprovement;

  /// No description provided for @reportTargetDays.
  ///
  /// In en, this message translates to:
  /// **'{reached}/{total} on target'**
  String reportTargetDays(int reached, int total);

  /// No description provided for @reportWorkoutTime.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min total'**
  String reportWorkoutTime(int minutes);

  /// No description provided for @monthlyScoreStrong.
  ///
  /// In en, this message translates to:
  /// **'Strong Month'**
  String get monthlyScoreStrong;

  /// No description provided for @monthlyScoreGood.
  ///
  /// In en, this message translates to:
  /// **'Good Month'**
  String get monthlyScoreGood;

  /// No description provided for @monthlyScoreNeedsFocus.
  ///
  /// In en, this message translates to:
  /// **'Needs Focus'**
  String get monthlyScoreNeedsFocus;

  /// No description provided for @monthlyScoreNeedsImprovement.
  ///
  /// In en, this message translates to:
  /// **'Needs Improvement'**
  String get monthlyScoreNeedsImprovement;

  /// No description provided for @reportAreaCalories.
  ///
  /// In en, this message translates to:
  /// **'Calories'**
  String get reportAreaCalories;

  /// No description provided for @reportAreaProtein.
  ///
  /// In en, this message translates to:
  /// **'Protein'**
  String get reportAreaProtein;

  /// No description provided for @reportAreaCarbs.
  ///
  /// In en, this message translates to:
  /// **'Carbs'**
  String get reportAreaCarbs;

  /// No description provided for @reportAreaFat.
  ///
  /// In en, this message translates to:
  /// **'Fat'**
  String get reportAreaFat;

  /// No description provided for @reportAreaHydration.
  ///
  /// In en, this message translates to:
  /// **'Hydration'**
  String get reportAreaHydration;

  /// No description provided for @reportAreaActivity.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get reportAreaActivity;

  /// No description provided for @reportAreaTracking.
  ///
  /// In en, this message translates to:
  /// **'Tracking'**
  String get reportAreaTracking;

  /// No description provided for @reportAreaWeekends.
  ///
  /// In en, this message translates to:
  /// **'Weekends'**
  String get reportAreaWeekends;

  /// No description provided for @reportStrongAreaTargetDays.
  ///
  /// In en, this message translates to:
  /// **'{reached}/{total} days on target'**
  String reportStrongAreaTargetDays(int reached, int total);

  /// No description provided for @reportWeakAreaScore.
  ///
  /// In en, this message translates to:
  /// **'{score}% alignment'**
  String reportWeakAreaScore(int score);

  /// No description provided for @reportWeekendDifference.
  ///
  /// In en, this message translates to:
  /// **'{value}% lower than weekdays'**
  String reportWeekendDifference(int value);

  /// No description provided for @reportGoalConsistencyPeriod.
  ///
  /// In en, this message translates to:
  /// **'Goal consistency this month'**
  String get reportGoalConsistencyPeriod;

  /// No description provided for @monthlyChangeTrackingConsistency.
  ///
  /// In en, this message translates to:
  /// **'Tracking Consistency'**
  String get monthlyChangeTrackingConsistency;

  /// No description provided for @monthlyChangeGoalConsistency.
  ///
  /// In en, this message translates to:
  /// **'Goal Consistency'**
  String get monthlyChangeGoalConsistency;

  /// No description provided for @monthlyChangeCalories.
  ///
  /// In en, this message translates to:
  /// **'Calories'**
  String get monthlyChangeCalories;

  /// No description provided for @monthlyChangeProtein.
  ///
  /// In en, this message translates to:
  /// **'Protein'**
  String get monthlyChangeProtein;

  /// No description provided for @monthlyChangeHydration.
  ///
  /// In en, this message translates to:
  /// **'Hydration'**
  String get monthlyChangeHydration;

  /// No description provided for @monthlyChangeActivity.
  ///
  /// In en, this message translates to:
  /// **'Active Days'**
  String get monthlyChangeActivity;

  /// No description provided for @monthlyScoreChange.
  ///
  /// In en, this message translates to:
  /// **'%{value} from last month'**
  String monthlyScoreChange(int value);

  /// No description provided for @whatChangedThisMonth.
  ///
  /// In en, this message translates to:
  /// **'What Changed This Month'**
  String get whatChangedThisMonth;

  /// No description provided for @strongestArea.
  ///
  /// In en, this message translates to:
  /// **'Strongest Area'**
  String get strongestArea;

  /// No description provided for @weakestArea.
  ///
  /// In en, this message translates to:
  /// **'Weakest Area'**
  String get weakestArea;

  /// No description provided for @achievements.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get achievements;

  /// No description provided for @consistency.
  ///
  /// In en, this message translates to:
  /// **'Consistency'**
  String get consistency;

  /// No description provided for @goalConsistency.
  ///
  /// In en, this message translates to:
  /// **'Goal Consistency'**
  String get goalConsistency;

  /// No description provided for @daysTracked.
  ///
  /// In en, this message translates to:
  /// **'days tracked'**
  String get daysTracked;

  /// No description provided for @perfectDays.
  ///
  /// In en, this message translates to:
  /// **'Perfect Days'**
  String get perfectDays;

  /// No description provided for @perfectDayDefinition.
  ///
  /// In en, this message translates to:
  /// **'A day where all applicable core goals were reached.'**
  String get perfectDayDefinition;

  /// No description provided for @weightPlanProgress.
  ///
  /// In en, this message translates to:
  /// **'Weight & Plan Progress'**
  String get weightPlanProgress;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @thisMonth.
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get thisMonth;

  /// No description provided for @monthlyTarget.
  ///
  /// In en, this message translates to:
  /// **'Monthly Target'**
  String get monthlyTarget;

  /// No description provided for @progressAchieved.
  ///
  /// In en, this message translates to:
  /// **'Progress Achieved'**
  String get progressAchieved;

  /// No description provided for @goalPrediction.
  ///
  /// In en, this message translates to:
  /// **'Goal Prediction'**
  String get goalPrediction;

  /// No description provided for @daysEarlierThanLastMonth.
  ///
  /// In en, this message translates to:
  /// **'%{value} days earlier than last month\'s prediction'**
  String daysEarlierThanLastMonth(int value);

  /// No description provided for @daysLaterThanLastMonth.
  ///
  /// In en, this message translates to:
  /// **'%{value} days later than last month\'s prediction'**
  String daysLaterThanLastMonth(int value);

  /// No description provided for @patternsWeNoticed.
  ///
  /// In en, this message translates to:
  /// **'Patterns We Noticed'**
  String get patternsWeNoticed;

  /// No description provided for @yourMonthInReview.
  ///
  /// In en, this message translates to:
  /// **'Your Month in Review'**
  String get yourMonthInReview;

  /// No description provided for @mainFocus.
  ///
  /// In en, this message translates to:
  /// **'Main Focus'**
  String get mainFocus;

  /// No description provided for @keepDoing.
  ///
  /// In en, this message translates to:
  /// **'Keep Doing'**
  String get keepDoing;

  /// No description provided for @improve.
  ///
  /// In en, this message translates to:
  /// **'Improve'**
  String get improve;

  /// No description provided for @watch.
  ///
  /// In en, this message translates to:
  /// **'Watch'**
  String get watch;

  /// No description provided for @watchAdEarnOneUse.
  ///
  /// In en, this message translates to:
  /// **'Watch an ad to earn 1 more use'**
  String get watchAdEarnOneUse;

  /// No description provided for @upgradeToPro.
  ///
  /// In en, this message translates to:
  /// **'FREE'**
  String get upgradeToPro;

  /// No description provided for @unlockAllPremiumFeatures.
  ///
  /// In en, this message translates to:
  /// **'Unlock all features below'**
  String get unlockAllPremiumFeatures;

  /// No description provided for @premiumUnlimitedRecipes.
  ///
  /// In en, this message translates to:
  /// **'Create unlimited recipes'**
  String get premiumUnlimitedRecipes;

  /// No description provided for @premiumUnlimitedAi.
  ///
  /// In en, this message translates to:
  /// **'Ask Fiteo without limits'**
  String get premiumUnlimitedAi;

  /// No description provided for @premiumBarcodeScanning.
  ///
  /// In en, this message translates to:
  /// **'Add products instantly by barcode'**
  String get premiumBarcodeScanning;

  /// No description provided for @premiumSmartNotifications.
  ///
  /// In en, this message translates to:
  /// **'Stay on track with smart notifications'**
  String get premiumSmartNotifications;

  /// No description provided for @premiumGoalPrediction.
  ///
  /// In en, this message translates to:
  /// **'See your predicted goal date'**
  String get premiumGoalPrediction;

  /// No description provided for @premiumAdaptiveProgress.
  ///
  /// In en, this message translates to:
  /// **'Get an adaptive plan and detailed progress'**
  String get premiumAdaptiveProgress;

  /// No description provided for @premiumReports.
  ///
  /// In en, this message translates to:
  /// **'See weekly and monthly reports'**
  String get premiumReports;

  /// No description provided for @premiumRecipePersonalization.
  ///
  /// In en, this message translates to:
  /// **'Personalize recipes around your goals'**
  String get premiumRecipePersonalization;

  /// No description provided for @yearly.
  ///
  /// In en, this message translates to:
  /// **'Yearly'**
  String get yearly;

  /// No description provided for @monthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get monthly;

  /// No description provided for @popular.
  ///
  /// In en, this message translates to:
  /// **'Popular'**
  String get popular;

  /// No description provided for @premiumMembershipTitle.
  ///
  /// In en, this message translates to:
  /// **'Fiteo Premium'**
  String get premiumMembershipTitle;

  /// No description provided for @premiumMembershipActive.
  ///
  /// In en, this message translates to:
  /// **'Your Premium membership is active'**
  String get premiumMembershipActive;

  /// No description provided for @premiumYearlyPlan.
  ///
  /// In en, this message translates to:
  /// **'Yearly Plan'**
  String get premiumYearlyPlan;

  /// No description provided for @premiumActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get premiumActive;

  /// No description provided for @premiumRenewalDate.
  ///
  /// In en, this message translates to:
  /// **'Renewal date'**
  String get premiumRenewalDate;

  /// No description provided for @premiumBenefits.
  ///
  /// In en, this message translates to:
  /// **'Your Premium benefits'**
  String get premiumBenefits;

  /// No description provided for @manageSubscription.
  ///
  /// In en, this message translates to:
  /// **'Manage Subscription'**
  String get manageSubscription;

  /// No description provided for @newPlanTitle.
  ///
  /// In en, this message translates to:
  /// **'New Plan'**
  String get newPlanTitle;

  /// No description provided for @newPlanDescription.
  ///
  /// In en, this message translates to:
  /// **'Your daily targets have been updated based on your recent progress.'**
  String get newPlanDescription;

  /// No description provided for @oldPlanNewPlan.
  ///
  /// In en, this message translates to:
  /// **'Previous plan → New plan'**
  String get oldPlanNewPlan;

  /// No description provided for @saveNewPlan.
  ///
  /// In en, this message translates to:
  /// **'Save New Plan'**
  String get saveNewPlan;

  /// No description provided for @weeklyWeightUpdateTitle.
  ///
  /// In en, this message translates to:
  /// **'Weekly Weight Update'**
  String get weeklyWeightUpdateTitle;

  /// No description provided for @weeklyWeightUpdateDescription.
  ///
  /// In en, this message translates to:
  /// **'Measure and update your weekly weight so we can track your plan consistently.'**
  String get weeklyWeightUpdateDescription;

  /// No description provided for @updateWeight.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get updateWeight;

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
