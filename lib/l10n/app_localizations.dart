import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
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

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
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
    Locale('es'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'B Health'**
  String get appTitle;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @errorLabel.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String errorLabel(String error);

  /// No description provided for @saveError.
  ///
  /// In en, this message translates to:
  /// **'Error saving: {error}'**
  String saveError(String error);

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @elapsedTime.
  ///
  /// In en, this message translates to:
  /// **'{duration} ago'**
  String elapsedTime(String duration);

  /// No description provided for @notesLabel.
  ///
  /// In en, this message translates to:
  /// **'Notes (optional)'**
  String get notesLabel;

  /// No description provided for @notesHint.
  ///
  /// In en, this message translates to:
  /// **'Observations...'**
  String get notesHint;

  /// No description provided for @startTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'Start time'**
  String get startTimeLabel;

  /// No description provided for @selectBabyFirst.
  ///
  /// In en, this message translates to:
  /// **'Select a baby before saving'**
  String get selectBabyFirst;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @languageLabel.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageLabel;

  /// No description provided for @themeLabel.
  ///
  /// In en, this message translates to:
  /// **'App color'**
  String get themeLabel;

  /// No description provided for @themePink.
  ///
  /// In en, this message translates to:
  /// **'Pink'**
  String get themePink;

  /// No description provided for @themeBlue.
  ///
  /// In en, this message translates to:
  /// **'Blue'**
  String get themeBlue;

  /// No description provided for @themeGreen.
  ///
  /// In en, this message translates to:
  /// **'Green'**
  String get themeGreen;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @legalLabel.
  ///
  /// In en, this message translates to:
  /// **'Legal'**
  String get legalLabel;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get privacyPolicy;

  /// No description provided for @termsAndConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms and conditions'**
  String get termsAndConditions;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navFeedings.
  ///
  /// In en, this message translates to:
  /// **'Feeding'**
  String get navFeedings;

  /// No description provided for @navSleep.
  ///
  /// In en, this message translates to:
  /// **'Sleep'**
  String get navSleep;

  /// No description provided for @navWeight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get navWeight;

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeTitle;

  /// No description provided for @myBabies.
  ///
  /// In en, this message translates to:
  /// **'My babies'**
  String get myBabies;

  /// No description provided for @helloIAm.
  ///
  /// In en, this message translates to:
  /// **'Hi, I\'m'**
  String get helloIAm;

  /// No description provided for @switchBaby.
  ///
  /// In en, this message translates to:
  /// **'Switch baby'**
  String get switchBaby;

  /// No description provided for @todaySummary.
  ///
  /// In en, this message translates to:
  /// **'Today\'s summary'**
  String get todaySummary;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick actions'**
  String get quickActions;

  /// No description provided for @sleepingNow.
  ///
  /// In en, this message translates to:
  /// **'Sleeping now'**
  String get sleepingNow;

  /// No description provided for @stopButton.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get stopButton;

  /// No description provided for @feedingsLabel.
  ///
  /// In en, this message translates to:
  /// **'Feedings'**
  String get feedingsLabel;

  /// No description provided for @sleepLabel.
  ///
  /// In en, this message translates to:
  /// **'Sleep'**
  String get sleepLabel;

  /// No description provided for @weightLabel.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get weightLabel;

  /// No description provided for @noRecordsToday.
  ///
  /// In en, this message translates to:
  /// **'No records today'**
  String get noRecordsToday;

  /// No description provided for @noRecords.
  ///
  /// In en, this message translates to:
  /// **'No records'**
  String get noRecords;

  /// No description provided for @lastFeedingElapsed.
  ///
  /// In en, this message translates to:
  /// **'Last: {elapsed}'**
  String lastFeedingElapsed(String elapsed);

  /// No description provided for @todayWord.
  ///
  /// In en, this message translates to:
  /// **'today'**
  String get todayWord;

  /// No description provided for @breastMinutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min breast'**
  String breastMinutes(int minutes);

  /// No description provided for @quickFeeding.
  ///
  /// In en, this message translates to:
  /// **'Feeding'**
  String get quickFeeding;

  /// No description provided for @feedingScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Feeding'**
  String get feedingScreenTitle;

  /// No description provided for @feedingEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No feeding records'**
  String get feedingEmptyTitle;

  /// No description provided for @feedingEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tap the + button to add the first feeding.'**
  String get feedingEmptySubtitle;

  /// No description provided for @addFeedingAction.
  ///
  /// In en, this message translates to:
  /// **'Add feeding'**
  String get addFeedingAction;

  /// No description provided for @feedingsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 feeding} other{{count} feedings}}'**
  String feedingsCount(num count);

  /// No description provided for @deleteFeedingTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete feeding'**
  String get deleteFeedingTitle;

  /// No description provided for @deleteFeedingMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this record?'**
  String get deleteFeedingMessage;

  /// No description provided for @addFeedingTitle.
  ///
  /// In en, this message translates to:
  /// **'Add feeding'**
  String get addFeedingTitle;

  /// No description provided for @feedingTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Feeding type'**
  String get feedingTypeLabel;

  /// No description provided for @amountLabel.
  ///
  /// In en, this message translates to:
  /// **'Amount (ml)'**
  String get amountLabel;

  /// No description provided for @amountHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 120'**
  String get amountHint;

  /// No description provided for @durationLabel.
  ///
  /// In en, this message translates to:
  /// **'Duration (minutes)'**
  String get durationLabel;

  /// No description provided for @durationHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 15'**
  String get durationHint;

  /// No description provided for @saveFeeding.
  ///
  /// In en, this message translates to:
  /// **'Save feeding'**
  String get saveFeeding;

  /// No description provided for @invalidAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid amount in ml'**
  String get invalidAmount;

  /// No description provided for @invalidDuration.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid duration in minutes'**
  String get invalidDuration;

  /// No description provided for @feedingBreastLeft.
  ///
  /// In en, this message translates to:
  /// **'Left breast'**
  String get feedingBreastLeft;

  /// No description provided for @feedingBreastRight.
  ///
  /// In en, this message translates to:
  /// **'Right breast'**
  String get feedingBreastRight;

  /// No description provided for @feedingBottleFormula.
  ///
  /// In en, this message translates to:
  /// **'Bottle – formula'**
  String get feedingBottleFormula;

  /// No description provided for @feedingBottleBreastMilk.
  ///
  /// In en, this message translates to:
  /// **'Bottle – breast milk'**
  String get feedingBottleBreastMilk;

  /// No description provided for @feedingBreastLeftShort.
  ///
  /// In en, this message translates to:
  /// **'Left breast'**
  String get feedingBreastLeftShort;

  /// No description provided for @feedingBreastRightShort.
  ///
  /// In en, this message translates to:
  /// **'Right breast'**
  String get feedingBreastRightShort;

  /// No description provided for @feedingFormulaShort.
  ///
  /// In en, this message translates to:
  /// **'Formula'**
  String get feedingFormulaShort;

  /// No description provided for @feedingBreastMilkShort.
  ///
  /// In en, this message translates to:
  /// **'Breast milk'**
  String get feedingBreastMilkShort;

  /// No description provided for @sleepScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Sleep'**
  String get sleepScreenTitle;

  /// No description provided for @sleepEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No sleep records'**
  String get sleepEmptyTitle;

  /// No description provided for @sleepEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tap the + button to log the first sleep.'**
  String get sleepEmptySubtitle;

  /// No description provided for @addSleepAction.
  ///
  /// In en, this message translates to:
  /// **'Log sleep'**
  String get addSleepAction;

  /// No description provided for @ongoingSleepNotice.
  ///
  /// In en, this message translates to:
  /// **'There is a sleep session in progress. Stop it from the banner above.'**
  String get ongoingSleepNotice;

  /// No description provided for @napsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 nap} other{{count} naps}}'**
  String napsCount(num count);

  /// No description provided for @deleteSleepTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete record'**
  String get deleteSleepTitle;

  /// No description provided for @deleteSleepMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this sleep record?'**
  String get deleteSleepMessage;

  /// No description provided for @addSleepTitle.
  ///
  /// In en, this message translates to:
  /// **'Log sleep'**
  String get addSleepTitle;

  /// No description provided for @ongoingSleepLabel.
  ///
  /// In en, this message translates to:
  /// **'Sleep in progress'**
  String get ongoingSleepLabel;

  /// No description provided for @ongoingSleepSubtitle.
  ///
  /// In en, this message translates to:
  /// **'The baby is sleeping right now'**
  String get ongoingSleepSubtitle;

  /// No description provided for @endTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'End time'**
  String get endTimeLabel;

  /// No description provided for @selectEndTime.
  ///
  /// In en, this message translates to:
  /// **'Select end time'**
  String get selectEndTime;

  /// No description provided for @ongoingDurationLabel.
  ///
  /// In en, this message translates to:
  /// **'Ongoing duration: {duration}'**
  String ongoingDurationLabel(String duration);

  /// No description provided for @durationValue.
  ///
  /// In en, this message translates to:
  /// **'Duration: {duration}'**
  String durationValue(String duration);

  /// No description provided for @startRecording.
  ///
  /// In en, this message translates to:
  /// **'Start session'**
  String get startRecording;

  /// No description provided for @saveSleep.
  ///
  /// In en, this message translates to:
  /// **'Save sleep'**
  String get saveSleep;

  /// No description provided for @endTimeRequired.
  ///
  /// In en, this message translates to:
  /// **'Set the end time or enable \"sleep in progress\"'**
  String get endTimeRequired;

  /// No description provided for @endAfterStart.
  ///
  /// In en, this message translates to:
  /// **'End time must be after start time'**
  String get endAfterStart;

  /// No description provided for @activeSleepExists.
  ///
  /// In en, this message translates to:
  /// **'There is already a sleep in progress. Stop it before starting another.'**
  String get activeSleepExists;

  /// No description provided for @sleepingBadge.
  ///
  /// In en, this message translates to:
  /// **'Sleeping'**
  String get sleepingBadge;

  /// No description provided for @endPrefix.
  ///
  /// In en, this message translates to:
  /// **'End: {time}'**
  String endPrefix(String time);

  /// No description provided for @weightScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get weightScreenTitle;

  /// No description provided for @weightEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No weight records'**
  String get weightEmptyTitle;

  /// No description provided for @weightEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add an entry to start tracking growth.'**
  String get weightEmptySubtitle;

  /// No description provided for @addWeightAction.
  ///
  /// In en, this message translates to:
  /// **'Add weight'**
  String get addWeightAction;

  /// No description provided for @currentWeight.
  ///
  /// In en, this message translates to:
  /// **'Current weight'**
  String get currentWeight;

  /// No description provided for @deleteWeightTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete record'**
  String get deleteWeightTitle;

  /// No description provided for @deleteWeightMessage.
  ///
  /// In en, this message translates to:
  /// **'Do you want to delete this weight record?'**
  String get deleteWeightMessage;

  /// No description provided for @weightDeleted.
  ///
  /// In en, this message translates to:
  /// **'Weight record deleted'**
  String get weightDeleted;

  /// No description provided for @gainSincePrevious.
  ///
  /// In en, this message translates to:
  /// **'+{grams} g since previous'**
  String gainSincePrevious(String grams);

  /// No description provided for @lossSincePrevious.
  ///
  /// In en, this message translates to:
  /// **'−{grams} g since previous'**
  String lossSincePrevious(String grams);

  /// No description provided for @addWeightTitle.
  ///
  /// In en, this message translates to:
  /// **'Add weight'**
  String get addWeightTitle;

  /// No description provided for @weightKgLabel.
  ///
  /// In en, this message translates to:
  /// **'Weight (kg)'**
  String get weightKgLabel;

  /// No description provided for @weightHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 4.25'**
  String get weightHint;

  /// No description provided for @measurementDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Measurement date'**
  String get measurementDateLabel;

  /// No description provided for @enterWeight.
  ///
  /// In en, this message translates to:
  /// **'Enter a weight'**
  String get enterWeight;

  /// No description provided for @invalidWeight.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid weight in kg'**
  String get invalidWeight;

  /// No description provided for @weightTooHigh.
  ///
  /// In en, this message translates to:
  /// **'Weight seems too high'**
  String get weightTooHigh;

  /// No description provided for @saveWeight.
  ///
  /// In en, this message translates to:
  /// **'Save weight'**
  String get saveWeight;

  /// No description provided for @babiesEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No babies yet'**
  String get babiesEmptyTitle;

  /// No description provided for @babiesEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add your first baby to start tracking their information.'**
  String get babiesEmptySubtitle;

  /// No description provided for @addBabyAction.
  ///
  /// In en, this message translates to:
  /// **'Add baby'**
  String get addBabyAction;

  /// No description provided for @deleteBabyTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete baby'**
  String get deleteBabyTitle;

  /// No description provided for @deleteBabyMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete {name}? All their records will be deleted.'**
  String deleteBabyMessage(String name);

  /// No description provided for @newBabyTitle.
  ///
  /// In en, this message translates to:
  /// **'New baby'**
  String get newBabyTitle;

  /// No description provided for @nameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get nameLabel;

  /// No description provided for @nameHint.
  ///
  /// In en, this message translates to:
  /// **'Baby\'s name'**
  String get nameHint;

  /// No description provided for @nameRequired.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get nameRequired;

  /// No description provided for @birthDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Date of birth'**
  String get birthDateLabel;

  /// No description provided for @selectDate.
  ///
  /// In en, this message translates to:
  /// **'Select date'**
  String get selectDate;

  /// No description provided for @selectBirthDate.
  ///
  /// In en, this message translates to:
  /// **'Select the date of birth'**
  String get selectBirthDate;

  /// No description provided for @genderLabel.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get genderLabel;

  /// No description provided for @genderBoy.
  ///
  /// In en, this message translates to:
  /// **'Boy'**
  String get genderBoy;

  /// No description provided for @genderGirl.
  ///
  /// In en, this message translates to:
  /// **'Girl'**
  String get genderGirl;

  /// No description provided for @saveBaby.
  ///
  /// In en, this message translates to:
  /// **'Save baby'**
  String get saveBaby;

  /// No description provided for @newborn.
  ///
  /// In en, this message translates to:
  /// **'Newborn'**
  String get newborn;

  /// No description provided for @ageDays.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 day} other{{count} days}}'**
  String ageDays(num count);

  /// No description provided for @ageWeeks.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 week} other{{count} weeks}}'**
  String ageWeeks(num count);

  /// No description provided for @ageMonths.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 month} other{{count} months}}'**
  String ageMonths(num count);

  /// No description provided for @ageYears.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 year} other{{count} years}}'**
  String ageYears(num count);

  /// No description provided for @ageYearsMonths.
  ///
  /// In en, this message translates to:
  /// **'{years} and {months}'**
  String ageYearsMonths(String years, String months);

  /// No description provided for @quickLogTitle.
  ///
  /// In en, this message translates to:
  /// **'One-tap log'**
  String get quickLogTitle;

  /// No description provided for @quickLogFeeding.
  ///
  /// In en, this message translates to:
  /// **'Quick feeding'**
  String get quickLogFeeding;

  /// No description provided for @quickLogNap.
  ///
  /// In en, this message translates to:
  /// **'Quick nap'**
  String get quickLogNap;

  /// No description provided for @feedingLogged.
  ///
  /// In en, this message translates to:
  /// **'Feeding logged'**
  String get feedingLogged;

  /// No description provided for @napLogged.
  ///
  /// In en, this message translates to:
  /// **'Nap logged'**
  String get napLogged;

  /// No description provided for @undoLabel.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undoLabel;

  /// No description provided for @quickDefaultsTitle.
  ///
  /// In en, this message translates to:
  /// **'One-tap defaults'**
  String get quickDefaultsTitle;

  /// No description provided for @quickDefaultsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Values used by the one-tap buttons on the home screen.'**
  String get quickDefaultsSubtitle;

  /// No description provided for @defaultFeedingTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Default feeding type'**
  String get defaultFeedingTypeLabel;

  /// No description provided for @defaultNapDurationLabel.
  ///
  /// In en, this message translates to:
  /// **'Default nap duration'**
  String get defaultNapDurationLabel;

  /// No description provided for @minutesUnit.
  ///
  /// In en, this message translates to:
  /// **'min'**
  String get minutesUnit;
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
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
