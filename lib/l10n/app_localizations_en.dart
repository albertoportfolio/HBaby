// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'B Health';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String errorLabel(String error) {
    return 'Error: $error';
  }

  @override
  String saveError(String error) {
    return 'Error saving: $error';
  }

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String elapsedTime(String duration) {
    return '$duration ago';
  }

  @override
  String get notesLabel => 'Notes (optional)';

  @override
  String get notesHint => 'Observations...';

  @override
  String get startTimeLabel => 'Start time';

  @override
  String get selectBabyFirst => 'Select a baby before saving';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get languageLabel => 'Language';

  @override
  String get languageSystem => 'Device language';

  @override
  String get themeLabel => 'App color';

  @override
  String get themePink => 'Pink';

  @override
  String get themeBlue => 'Blue';

  @override
  String get themeGreen => 'Green';

  @override
  String get themeDark => 'Dark';

  @override
  String get navHome => 'Home';

  @override
  String get navFeedings => 'Feeding';

  @override
  String get navSleep => 'Sleep';

  @override
  String get navWeight => 'Weight';

  @override
  String get homeTitle => 'Home';

  @override
  String get myBabies => 'My babies';

  @override
  String get helloIAm => 'Hi, I\'m';

  @override
  String get switchBaby => 'Switch baby';

  @override
  String get todaySummary => 'Today\'s summary';

  @override
  String get quickActions => 'Quick actions';

  @override
  String get sleepingNow => 'Sleeping now';

  @override
  String get stopButton => 'Stop';

  @override
  String get feedingsLabel => 'Feedings';

  @override
  String get sleepLabel => 'Sleep';

  @override
  String get weightLabel => 'Weight';

  @override
  String get noRecordsToday => 'No records today';

  @override
  String get noRecords => 'No records';

  @override
  String lastFeedingElapsed(String elapsed) {
    return 'Last: $elapsed';
  }

  @override
  String get todayWord => 'today';

  @override
  String breastMinutes(int minutes) {
    return '$minutes min breast';
  }

  @override
  String get quickFeeding => 'Feeding';

  @override
  String get feedingScreenTitle => 'Feeding';

  @override
  String get feedingEmptyTitle => 'No feeding records';

  @override
  String get feedingEmptySubtitle =>
      'Tap the + button to add the first feeding.';

  @override
  String get addFeedingAction => 'Add feeding';

  @override
  String feedingsCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count feedings',
      one: '1 feeding',
    );
    return '$_temp0';
  }

  @override
  String get deleteFeedingTitle => 'Delete feeding';

  @override
  String get deleteFeedingMessage =>
      'Are you sure you want to delete this record?';

  @override
  String get addFeedingTitle => 'Add feeding';

  @override
  String get feedingTypeLabel => 'Feeding type';

  @override
  String get amountLabel => 'Amount (ml)';

  @override
  String get amountHint => 'e.g. 120';

  @override
  String get durationLabel => 'Duration (minutes)';

  @override
  String get durationHint => 'e.g. 15';

  @override
  String get saveFeeding => 'Save feeding';

  @override
  String get invalidAmount => 'Enter a valid amount in ml';

  @override
  String get invalidDuration => 'Enter a valid duration in minutes';

  @override
  String get feedingBreastLeft => 'Left breast';

  @override
  String get feedingBreastRight => 'Right breast';

  @override
  String get feedingBottleFormula => 'Bottle – formula';

  @override
  String get feedingBottleBreastMilk => 'Bottle – breast milk';

  @override
  String get feedingBreastLeftShort => 'Left breast';

  @override
  String get feedingBreastRightShort => 'Right breast';

  @override
  String get feedingFormulaShort => 'Formula';

  @override
  String get feedingBreastMilkShort => 'Breast milk';

  @override
  String get sleepScreenTitle => 'Sleep';

  @override
  String get sleepEmptyTitle => 'No sleep records';

  @override
  String get sleepEmptySubtitle => 'Tap the + button to log the first sleep.';

  @override
  String get addSleepAction => 'Log sleep';

  @override
  String get ongoingSleepNotice =>
      'There is a sleep session in progress. Stop it from the banner above.';

  @override
  String napsCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count naps',
      one: '1 nap',
    );
    return '$_temp0';
  }

  @override
  String get deleteSleepTitle => 'Delete record';

  @override
  String get deleteSleepMessage =>
      'Are you sure you want to delete this sleep record?';

  @override
  String get addSleepTitle => 'Log sleep';

  @override
  String get ongoingSleepLabel => 'Sleep in progress';

  @override
  String get ongoingSleepSubtitle => 'The baby is sleeping right now';

  @override
  String get endTimeLabel => 'End time';

  @override
  String get selectEndTime => 'Select end time';

  @override
  String ongoingDurationLabel(String duration) {
    return 'Ongoing duration: $duration';
  }

  @override
  String durationValue(String duration) {
    return 'Duration: $duration';
  }

  @override
  String get startRecording => 'Start session';

  @override
  String get saveSleep => 'Save sleep';

  @override
  String get endTimeRequired =>
      'Set the end time or enable \"sleep in progress\"';

  @override
  String get endAfterStart => 'End time must be after start time';

  @override
  String get activeSleepExists =>
      'There is already a sleep in progress. Stop it before starting another.';

  @override
  String get sleepingBadge => 'Sleeping';

  @override
  String endPrefix(String time) {
    return 'End: $time';
  }

  @override
  String get weightScreenTitle => 'Weight';

  @override
  String get weightEmptyTitle => 'No weight records';

  @override
  String get weightEmptySubtitle => 'Add an entry to start tracking growth.';

  @override
  String get addWeightAction => 'Add weight';

  @override
  String get currentWeight => 'Current weight';

  @override
  String get deleteWeightTitle => 'Delete record';

  @override
  String get deleteWeightMessage => 'Do you want to delete this weight record?';

  @override
  String get weightDeleted => 'Weight record deleted';

  @override
  String gainSincePrevious(String grams) {
    return '+$grams g since previous';
  }

  @override
  String lossSincePrevious(String grams) {
    return '−$grams g since previous';
  }

  @override
  String get addWeightTitle => 'Add weight';

  @override
  String get weightKgLabel => 'Weight (kg)';

  @override
  String get weightHint => 'e.g. 4.25';

  @override
  String get measurementDateLabel => 'Measurement date';

  @override
  String get enterWeight => 'Enter a weight';

  @override
  String get invalidWeight => 'Enter a valid weight in kg';

  @override
  String get weightTooHigh => 'Weight seems too high';

  @override
  String get saveWeight => 'Save weight';

  @override
  String get babiesEmptyTitle => 'No babies yet';

  @override
  String get babiesEmptySubtitle =>
      'Add your first baby to start tracking their information.';

  @override
  String get addBabyAction => 'Add baby';

  @override
  String get deleteBabyTitle => 'Delete baby';

  @override
  String deleteBabyMessage(String name) {
    return 'Are you sure you want to delete $name? All their records will be deleted.';
  }

  @override
  String get newBabyTitle => 'New baby';

  @override
  String get nameLabel => 'Name';

  @override
  String get nameHint => 'Baby\'s name';

  @override
  String get nameRequired => 'Name is required';

  @override
  String get birthDateLabel => 'Date of birth';

  @override
  String get selectDate => 'Select date';

  @override
  String get selectBirthDate => 'Select the date of birth';

  @override
  String get genderLabel => 'Gender';

  @override
  String get genderBoy => 'Boy';

  @override
  String get genderGirl => 'Girl';

  @override
  String get genderOther => 'Other';

  @override
  String get saveBaby => 'Save baby';

  @override
  String get newborn => 'Newborn';

  @override
  String ageDays(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days',
      one: '1 day',
    );
    return '$_temp0';
  }

  @override
  String ageWeeks(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count weeks',
      one: '1 week',
    );
    return '$_temp0';
  }

  @override
  String ageMonths(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count months',
      one: '1 month',
    );
    return '$_temp0';
  }

  @override
  String ageYears(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count years',
      one: '1 year',
    );
    return '$_temp0';
  }

  @override
  String ageYearsMonths(String years, String months) {
    return '$years and $months';
  }
}
