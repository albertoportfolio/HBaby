// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'B Health';

  @override
  String get cancel => 'Cancelar';

  @override
  String get delete => 'Eliminar';

  @override
  String errorLabel(String error) {
    return 'Error: $error';
  }

  @override
  String saveError(String error) {
    return 'Error al guardar: $error';
  }

  @override
  String get today => 'Hoy';

  @override
  String get yesterday => 'Ayer';

  @override
  String elapsedTime(String duration) {
    return 'Hace $duration';
  }

  @override
  String get notesLabel => 'Notas (opcional)';

  @override
  String get notesHint => 'Observaciones...';

  @override
  String get startTimeLabel => 'Hora de inicio';

  @override
  String get selectBabyFirst => 'Selecciona un bebé antes de guardar';

  @override
  String get settingsTitle => 'Ajustes';

  @override
  String get languageLabel => 'Idioma';

  @override
  String get themeLabel => 'Color de la app';

  @override
  String get themePink => 'Rosa';

  @override
  String get themeBlue => 'Azul';

  @override
  String get themeGreen => 'Verde';

  @override
  String get themeDark => 'Oscuro';

  @override
  String get legalLabel => 'Legal';

  @override
  String get privacyPolicy => 'Política de privacidad';

  @override
  String get termsAndConditions => 'Términos y condiciones';

  @override
  String get navHome => 'Inicio';

  @override
  String get navFeedings => 'Alimentación';

  @override
  String get navSleep => 'Sueño';

  @override
  String get navWeight => 'Peso';

  @override
  String get homeTitle => 'Inicio';

  @override
  String get myBabies => 'Mis bebés';

  @override
  String get helloIAm => 'Hola, soy';

  @override
  String get switchBaby => 'Cambiar de bebé';

  @override
  String get todaySummary => 'Resumen de hoy';

  @override
  String get quickActions => 'Acciones rápidas';

  @override
  String get sleepingNow => 'Durmiendo ahora';

  @override
  String get stopButton => 'Detener';

  @override
  String get feedingsLabel => 'Tomas';

  @override
  String get sleepLabel => 'Sueño';

  @override
  String get weightLabel => 'Peso';

  @override
  String get noRecordsToday => 'Sin registros hoy';

  @override
  String get noRecords => 'Sin registros';

  @override
  String lastFeedingElapsed(String elapsed) {
    return 'Última: $elapsed';
  }

  @override
  String get todayWord => 'hoy';

  @override
  String breastMinutes(int minutes) {
    return '$minutes min pecho';
  }

  @override
  String get quickFeeding => 'Toma';

  @override
  String get feedingScreenTitle => 'Alimentación';

  @override
  String get feedingEmptyTitle => 'Sin registros de alimentación';

  @override
  String get feedingEmptySubtitle =>
      'Pulsa el botón + para añadir la primera toma.';

  @override
  String get addFeedingAction => 'Añadir toma';

  @override
  String feedingsCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tomas',
      one: '1 toma',
    );
    return '$_temp0';
  }

  @override
  String get deleteFeedingTitle => 'Eliminar toma';

  @override
  String get deleteFeedingMessage =>
      '¿Seguro que quieres eliminar este registro?';

  @override
  String get addFeedingTitle => 'Añadir toma';

  @override
  String get feedingTypeLabel => 'Tipo de toma';

  @override
  String get amountLabel => 'Cantidad (ml)';

  @override
  String get amountHint => 'ej. 120';

  @override
  String get durationLabel => 'Duración (minutos)';

  @override
  String get durationHint => 'ej. 15';

  @override
  String get saveFeeding => 'Guardar toma';

  @override
  String get invalidAmount => 'Introduce una cantidad válida en ml';

  @override
  String get invalidDuration => 'Introduce una duración válida en minutos';

  @override
  String get feedingBreastLeft => 'Pecho izquierdo';

  @override
  String get feedingBreastRight => 'Pecho derecho';

  @override
  String get feedingBottleFormula => 'Biberón – fórmula';

  @override
  String get feedingBottleBreastMilk => 'Biberón – leche materna';

  @override
  String get feedingBreastLeftShort => 'Pecho izq.';

  @override
  String get feedingBreastRightShort => 'Pecho der.';

  @override
  String get feedingFormulaShort => 'Fórmula';

  @override
  String get feedingBreastMilkShort => 'L. materna';

  @override
  String get sleepScreenTitle => 'Sueño';

  @override
  String get sleepEmptyTitle => 'Sin registros de sueño';

  @override
  String get sleepEmptySubtitle =>
      'Pulsa el botón + para registrar el primer sueño.';

  @override
  String get addSleepAction => 'Registrar sueño';

  @override
  String get ongoingSleepNotice =>
      'Hay un sueño en curso. Termina la sesión desde el banner superior.';

  @override
  String napsCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count siestas',
      one: '1 siesta',
    );
    return '$_temp0';
  }

  @override
  String get deleteSleepTitle => 'Eliminar registro';

  @override
  String get deleteSleepMessage =>
      '¿Seguro que quieres eliminar este registro de sueño?';

  @override
  String get addSleepTitle => 'Registrar sueño';

  @override
  String get ongoingSleepLabel => 'Sueño en curso';

  @override
  String get ongoingSleepSubtitle => 'El bebé está durmiendo ahora mismo';

  @override
  String get endTimeLabel => 'Hora de fin';

  @override
  String get selectEndTime => 'Seleccionar hora de fin';

  @override
  String ongoingDurationLabel(String duration) {
    return 'Duración en curso: $duration';
  }

  @override
  String durationValue(String duration) {
    return 'Duración: $duration';
  }

  @override
  String get startRecording => 'Iniciar registro';

  @override
  String get saveSleep => 'Guardar sueño';

  @override
  String get endTimeRequired =>
      'Indica la hora de fin o activa \"sueño en curso\"';

  @override
  String get endAfterStart =>
      'La hora de fin debe ser posterior a la hora de inicio';

  @override
  String get activeSleepExists =>
      'Ya hay un sueño en curso. Detenlo antes de iniciar otro.';

  @override
  String get sleepingBadge => 'Durmiendo';

  @override
  String endPrefix(String time) {
    return 'Fin: $time';
  }

  @override
  String get weightScreenTitle => 'Peso';

  @override
  String get weightEmptyTitle => 'Sin registros de peso';

  @override
  String get weightEmptySubtitle =>
      'Añade una entrada para empezar a registrar el crecimiento.';

  @override
  String get addWeightAction => 'Añadir peso';

  @override
  String get currentWeight => 'Peso actual';

  @override
  String get deleteWeightTitle => 'Borrar registro';

  @override
  String get deleteWeightMessage => '¿Deseas eliminar este registro de peso?';

  @override
  String get weightDeleted => 'Registro de peso eliminado';

  @override
  String gainSincePrevious(String grams) {
    return '+$grams g desde la anterior';
  }

  @override
  String lossSincePrevious(String grams) {
    return '−$grams g desde la anterior';
  }

  @override
  String get addWeightTitle => 'Añadir peso';

  @override
  String get weightKgLabel => 'Peso (kg)';

  @override
  String get weightHint => 'ej. 4,250';

  @override
  String get measurementDateLabel => 'Fecha de la medición';

  @override
  String get enterWeight => 'Introduce un peso';

  @override
  String get invalidWeight => 'Introduce un peso válido en kg';

  @override
  String get weightTooHigh => 'El peso parece demasiado alto';

  @override
  String get saveWeight => 'Guardar peso';

  @override
  String get babiesEmptyTitle => 'Sin bebés registrados';

  @override
  String get babiesEmptySubtitle =>
      'Añade tu primer bebé para empezar a registrar su información.';

  @override
  String get addBabyAction => 'Añadir bebé';

  @override
  String get deleteBabyTitle => 'Eliminar bebé';

  @override
  String deleteBabyMessage(String name) {
    return '¿Estás seguro de que quieres eliminar a $name? Se borrarán todos sus registros.';
  }

  @override
  String get newBabyTitle => 'Nuevo bebé';

  @override
  String get nameLabel => 'Nombre';

  @override
  String get nameHint => 'Nombre del bebé';

  @override
  String get nameRequired => 'El nombre es obligatorio';

  @override
  String get birthDateLabel => 'Fecha de nacimiento';

  @override
  String get selectDate => 'Seleccionar fecha';

  @override
  String get selectBirthDate => 'Selecciona la fecha de nacimiento';

  @override
  String get genderLabel => 'Género';

  @override
  String get genderBoy => 'Niño';

  @override
  String get genderGirl => 'Niña';

  @override
  String get saveBaby => 'Guardar bebé';

  @override
  String get newborn => 'Recién nacido';

  @override
  String ageDays(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count días',
      one: '1 día',
    );
    return '$_temp0';
  }

  @override
  String ageWeeks(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count semanas',
      one: '1 semana',
    );
    return '$_temp0';
  }

  @override
  String ageMonths(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count meses',
      one: '1 mes',
    );
    return '$_temp0';
  }

  @override
  String ageYears(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count años',
      one: '1 año',
    );
    return '$_temp0';
  }

  @override
  String ageYearsMonths(String years, String months) {
    return '$years y $months';
  }

  @override
  String get quickLogTitle => 'Registro en 1 toque';

  @override
  String get quickLogFeeding => 'Toma rápida';

  @override
  String get quickLogNap => 'Siesta rápida';

  @override
  String get feedingLogged => 'Toma registrada';

  @override
  String get napLogged => 'Siesta registrada';

  @override
  String get undoLabel => 'Deshacer';

  @override
  String get quickDefaultsTitle => 'Valores por defecto (1 toque)';

  @override
  String get quickDefaultsSubtitle =>
      'Valores que usan los botones de 1 toque de la pantalla de inicio.';

  @override
  String get defaultFeedingTypeLabel => 'Tipo de toma por defecto';

  @override
  String get defaultNapDurationLabel => 'Duración de siesta por defecto';

  @override
  String get minutesUnit => 'min';

  @override
  String get navStats => 'Gráficas';

  @override
  String get statsTitle => 'Evolución';

  @override
  String get statsEmptyTitle => 'Aún no hay datos que mostrar';

  @override
  String get statsEmptySubtitle =>
      'Empieza a registrar sueño, tomas y peso para ver aquí la evolución.';

  @override
  String get statsNoData => 'Aún no hay datos suficientes';

  @override
  String get statsSleepCardTitle => 'Sueño';

  @override
  String get statsSleepCardSubtitle => 'Horas por día · últimos 14 días';

  @override
  String get statsFeedingCardTitle => 'Tomas';

  @override
  String get statsFeedingCardSubtitle => 'Tomas por día · últimos 14 días';

  @override
  String get statsWeightCardTitle => 'Peso';

  @override
  String get statsWeightCardSubtitle => 'Kilogramos en el tiempo';
}
