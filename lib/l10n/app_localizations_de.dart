// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'SV Team Catering';

  @override
  String get commonToday => 'Heute';

  @override
  String get commonCancel => 'Abbrechen';

  @override
  String get commonSave => 'Speichern';

  @override
  String get commonDelete => 'Löschen';

  @override
  String get commonEdit => 'Bearbeiten';

  @override
  String get commonBack => 'Zurück';

  @override
  String get commonNext => 'Weiter';

  @override
  String get commonDone => 'Fertig';

  @override
  String get commonPay => 'Bezahlen';

  @override
  String get commonRoom => 'Raum';

  @override
  String get commonCategory => 'Kategorie';

  @override
  String get commonNote => 'Notiz';

  @override
  String get commonSummary => 'Zusammenfassung';

  @override
  String get commonStatus => 'Status';

  @override
  String get commonItem => 'Artikel';

  @override
  String get commonStart => 'Start';

  @override
  String get commonSold => 'Verkauft';

  @override
  String get commonRemain => 'Rest';

  @override
  String get commonRemove => 'Entfernen';

  @override
  String get commonSaveClose => 'Speichern & schließen';

  @override
  String get commonSelectTime => 'Zeit auswählen';

  @override
  String get commonSelectRoom => 'Raum auswählen';

  @override
  String get commonSelectDate => 'Datum auswählen';

  @override
  String get navManage => 'Verwalten';

  @override
  String get navTasks => 'Aufgaben';

  @override
  String get navProfile => 'Profil';

  @override
  String get manageReserve => 'Reserve';

  @override
  String get manageSnacky => 'Snacky';

  @override
  String get manageOthers => 'Weitere';

  @override
  String get manageNotificationsTooltip => 'Benachrichtigungen';

  @override
  String get profileTitle => 'Profil';

  @override
  String get profilePlaceholder => 'Profileinstellungen werden in der nächsten Phase erweitert.';

  @override
  String get settingsLanguage => 'Sprache';

  @override
  String get settingsUseSystem => 'Systemsprache verwenden';

  @override
  String get settingsGerman => 'Deutsch';

  @override
  String get settingsEnglish => 'Englisch';

  @override
  String get othersTitle => 'Weitere';

  @override
  String get othersSubtitle => 'Weitere Funktionen kommen in der nächsten Phase.';

  @override
  String get reserveTitle => 'Reserve';

  @override
  String get reserveIntro => 'Wähle zuerst die Anfrageart und fülle dann das Formular aus.';

  @override
  String get reserveSelectTypeHint => 'Wähle Getränke, Food Setup oder Notiz, um fortzufahren.';

  @override
  String get reserveTypeDrinks => 'Getränke';

  @override
  String get reserveTypeFoodSetup => 'Essens-Setup';

  @override
  String get reserveTypeNote => 'Notiz';

  @override
  String get reserveDrinksRequestTitle => 'Getränke-Anfrage';

  @override
  String get reserveFoodSetupRequestTitle => 'Essens-Setup-Anfrage';

  @override
  String get reserveNoteRequestTitle => 'Notiz-Anfrage';

  @override
  String get reserveDrinksSectionTitle => 'Getränke';

  @override
  String get reserveFoodSetupItemsTitle => 'Service-Setup-Artikel';

  @override
  String get reserveReservationDate => 'Reservierungsdatum';

  @override
  String get reservePrepareTime => 'Vorbereitungszeit';

  @override
  String get reserveCollectTime => 'Abholzeit';

  @override
  String get reservePeopleCount => 'Personenzahl';

  @override
  String get reserveTitleOptional => 'Titel (optional)';

  @override
  String get reserveNoteDescription => 'Notiz / Beschreibung';

  @override
  String get reserveCreateDrinksTask => 'Getränke-Aufgabe erstellen';

  @override
  String get reserveCreateFoodSetupTask => 'Essens-Setup-Aufgabe erstellen';

  @override
  String get reserveCreateNoteTask => 'Notiz-Aufgabe erstellen';

  @override
  String get reserveSuccessDrinksAdded => 'Getränke-Reservierung zu Aufgaben hinzugefügt.';

  @override
  String get reserveSuccessFoodAdded => 'Essens-Setup-Anfrage zu Aufgaben hinzugefügt.';

  @override
  String get reserveSuccessNoteAdded => 'Notiz-Anfrage zu Aufgaben hinzugefügt.';

  @override
  String get validationSelectRoom => 'Bitte einen Raum auswählen.';

  @override
  String get validationSelectPrepareTime => 'Bitte Vorbereitungszeit auswählen.';

  @override
  String get validationSelectCollectTime => 'Bitte Abholzeit auswählen.';

  @override
  String get validationPersonsInvalid => 'Die Personenzahl muss eine Zahl größer als 0 sein.';

  @override
  String get validationAddDrink => 'Bitte mindestens ein Getränk hinzufügen.';

  @override
  String get validationAddSetupItem => 'Bitte mindestens einen Setup-Artikel hinzufügen.';

  @override
  String get validationCollectAfterPrepare => 'Die Abholzeit muss nach der Vorbereitungszeit liegen.';

  @override
  String get validationNoteRequired => 'Notiz / Beschreibung ist erforderlich.';

  @override
  String get aufgabenTitle => 'Aufgaben';

  @override
  String get aufgabenEmptyTitle => 'Noch keine Aufgaben';

  @override
  String get aufgabenEmptySubtitle => 'Erstelle eine Reservierung, um die erste Aufgabe zu erzeugen.';

  @override
  String get aufgabenTaskDeleted => 'Aufgabe gelöscht.';

  @override
  String get aufgabenDailySnackNoDelete => 'Tägliche Snackautomaten-Aufgaben können nicht gelöscht werden.';

  @override
  String get aufgabenChangeStatusTitle => 'Status ändern';

  @override
  String get aufgabenDeleteTaskTitle => 'Aufgabe löschen?';

  @override
  String get aufgabenDeleteTaskBody => 'Diese Aktion kann nicht rückgängig gemacht werden.';

  @override
  String get taskActionsTooltip => 'Aufgabenaktionen';

  @override
  String get taskActionsOpenEdit => 'Bearbeiten / Öffnen';

  @override
  String get taskActionsChangeStatus => 'Status ändern';

  @override
  String get taskNoPersonsCount => 'Keine Personenzahl';

  @override
  String taskPersons(int count) {
    return '$count Personen';
  }

  @override
  String taskPrepAt(Object time) {
    return 'Vorb. $time';
  }

  @override
  String taskCollectAt(Object time) {
    return 'Abh. $time';
  }

  @override
  String get taskDetailTitle => 'Aufgabe';

  @override
  String get taskNotFound => 'Aufgabe nicht gefunden.';

  @override
  String get taskUpdated => 'Aufgabe aktualisiert.';

  @override
  String get taskStatusSection => 'Status';

  @override
  String get taskSummarySection => 'Zusammenfassung';

  @override
  String get taskInfoSection => 'Aufgabeninfo';

  @override
  String get taskRoomLabel => 'Raum';

  @override
  String get taskPrepareTimeLabel => 'Vorbereitungszeit';

  @override
  String get taskCollectTimeLabel => 'Abholzeit';

  @override
  String get taskPersonsLabel => 'Personen';

  @override
  String get taskItemsOrderedDrinks => 'Bestellte Getränke';

  @override
  String get taskItemsSetup => 'Setup-Artikel';

  @override
  String get taskItemsGeneric => 'Artikel';

  @override
  String get taskNoItems => 'Keine Artikel vorhanden.';

  @override
  String get taskAutoGeneratedSupportTitle => 'Automatisch erzeugte Support-Artikel';

  @override
  String get taskNoSupportItems => 'Keine Support-Artikel erzeugt.';

  @override
  String get taskNoteSection => 'Notiz';

  @override
  String get taskNoNote => 'Keine Notiz hinzugefügt.';

  @override
  String get taskEditSection => 'Aufgabe bearbeiten';

  @override
  String get taskPrepareDateLabel => 'Vorbereitungsdatum';

  @override
  String get taskCollectDateLabel => 'Abholdatum';

  @override
  String get taskNumberOfPeopleLabel => 'Personenzahl';

  @override
  String get taskShortDescriptionLabel => 'Kurzbeschreibung';

  @override
  String get taskDrinksItemsLabel => 'Getränke-Artikel';

  @override
  String get taskFoodSetupItemsLabel => 'Essens-Setup-Artikel';

  @override
  String get taskErrorRoomRequired => 'Raum ist erforderlich.';

  @override
  String get taskErrorAddItem => 'Mindestens einen Artikel hinzufügen.';

  @override
  String get taskSaveStatusChangeTitle => 'Statusänderung speichern?';

  @override
  String taskChangeStatusMessage(Object from, Object to) {
    return 'Status von $from zu $to ändern?';
  }

  @override
  String get taskDescriptionNoteRequest => 'Notiz-Anfrage';

  @override
  String get taskDescriptionDrinks => 'Getränke';

  @override
  String get taskDescriptionFoodSetup => 'Essens-Setup';

  @override
  String taskMoreItems(int count) {
    return '+$count Artikel';
  }

  @override
  String get taskStatusPending => 'Offen';

  @override
  String get taskStatusPrepared => 'Vorbereitet';

  @override
  String get taskStatusDone => 'Erledigt';

  @override
  String get taskStatusProblem => 'Problem';

  @override
  String get taskCategoryDrinks => 'Getränke';

  @override
  String get taskCategoryFoodSetup => 'Essens-Setup';

  @override
  String get taskCategoryNote => 'Notiz';

  @override
  String get taskCategorySnacky => 'Snacky';

  @override
  String get taskCategoryOthers => 'Weitere';

  @override
  String get snackyTitle => 'Snacky';

  @override
  String get snackyChoosePrompt => 'Wähle, was du verwalten möchtest.';

  @override
  String get snackyOptionDirectSellTitle => 'Direktverkauf';

  @override
  String get snackyOptionDirectSellSubtitle => 'Bestandsaufbau, Kassenablauf, Zahlung und Tagesabschluss.';

  @override
  String get snackyOpenDirectSell => 'Direktverkauf öffnen';

  @override
  String get snackyOptionOrdersTitle => 'Bestellungen';

  @override
  String get snackyOptionOrdersSubtitle => 'Bestellablauf und Nachverfolgung.';

  @override
  String get snackyOpenOrders => 'Bestellungen öffnen';

  @override
  String get snackyDirectSellPageTitle => 'Snacky · Direktverkauf';

  @override
  String get snackyOrdersPageTitle => 'Snacky · Bestellungen';

  @override
  String get snackyOrdersPlaceholderSubtitle => 'Bestellungen werden in der nächsten Phase ergänzt.';

  @override
  String get directSellStepStockSetup => 'Bestand';

  @override
  String get directSellStepSelling => 'Verkauf';

  @override
  String get directSellStepSummary => 'Übersicht';

  @override
  String get directSellCategorySandwiches => 'Sandwiches / Brötchen';

  @override
  String get directSellCategoryBakery => 'Bäckerei / Süßes';

  @override
  String get directSellCategorySnacks => 'Snacks / Süßigkeiten';

  @override
  String get directSellCategoryDrinks => 'Getränke';

  @override
  String get directSellCategoryExtras => 'Extras / Sonstiges';

  @override
  String get directSellStockStepTitle => 'Schritt 1: Bestand';

  @override
  String get directSellStockStepSubtitle => 'Startmengen und editierbare Preise vor dem Start der Kasse festlegen.';

  @override
  String get directSellCashierStepTitle => 'Schritt 2: Verkauf / Kasse';

  @override
  String get directSellCashierStepSubtitle => 'Tippe auf einen Artikel, um ihn dem aktuellen Warenkorb hinzuzufügen. Du kannst nicht mehr als den verfügbaren Bestand verkaufen.';

  @override
  String get directSellSummaryStepTitle => 'Schritt 3: Abschlussübersicht';

  @override
  String get directSellSummaryStepSubtitle => 'Endzahlen für diese Direktverkauf-Session.';

  @override
  String get directSellSpecialTag => 'Spezial';

  @override
  String directSellSoldCount(int count) {
    return 'Verkauft $count';
  }

  @override
  String get directSellAvailableItems => 'Verfügbare Artikel';

  @override
  String get directSellNoStock => 'Kein verfügbarer Bestand. Gehe zurück und füge Mengen hinzu.';

  @override
  String directSellRemainingCount(int count) {
    return 'Rest $count';
  }

  @override
  String get directSellAdd => 'Hinzufügen';

  @override
  String get directSellCurrentBasket => 'Aktueller Warenkorb';

  @override
  String get directSellNoBasket => 'Noch keine Artikel im Warenkorb.';

  @override
  String get directSellEach => 'pro Stück';

  @override
  String get directSellSubtotal => 'Zwischensumme';

  @override
  String get directSellBackToStock => 'Zurück zum Bestand';

  @override
  String get directSellBackToSelling => 'Zurück zum Verkauf';

  @override
  String get directSellNewSession => 'Neue Session';

  @override
  String get directSellPaymentTitle => 'Zahlung abschließen';

  @override
  String directSellTotalAmount(Object amount) {
    return 'Gesamt: $amount';
  }

  @override
  String get directSellCustomerGave => 'Kunde gab';

  @override
  String directSellChangeAmount(Object amount) {
    return 'Rückgeld: $amount';
  }

  @override
  String get directSellConfirmPayment => 'Zahlung bestätigen';

  @override
  String directSellSaleSavedChange(Object amount) {
    return 'Verkauf gespeichert. Rückgeld: $amount';
  }

  @override
  String get directSellErrorValidAmount => 'Gib einen gültigen Betrag ein.';

  @override
  String get directSellErrorPaidLess => 'Gegebener Betrag ist kleiner als die Summe.';

  @override
  String get directSellMoveToCashierError => 'Füge mindestens eine Artikelmenge hinzu, bevor du fortfährst.';

  @override
  String get directSellMoveToSummaryError => 'Beende die Zahlung oder leere den Warenkorb, bevor du die Session schließt.';

  @override
  String get directSellBasketEmptyError => 'Der Warenkorb ist leer.';

  @override
  String get directSellMetricTotalRevenue => 'Gesamtumsatz';

  @override
  String get directSellMetricTotalTransactions => 'Gesamttransaktionen';

  @override
  String get directSellMetricTotalSoldItems => 'Gesamt verkaufte Artikel';

  @override
  String get directSellMetricRemainingItems => 'Verbleibende Artikel';

  @override
  String get directSellMetricStartingQuantities => 'Startmengen';

  @override
  String get directSellPerItemSummary => 'Artikelübersicht';

  @override
  String get directSellNoSessionData => 'Noch keine Session-Daten.';

  @override
  String get notificationsTitle => 'Benachrichtigungen';

  @override
  String get notificationsClearAll => 'Alle löschen';

  @override
  String get notificationsEmptyTitle => 'Keine Benachrichtigungen';

  @override
  String get notificationsEmptySubtitle => 'Aufgaben-Updates erscheinen hier.';

  @override
  String notificationsByActor(Object name) {
    return 'Von $name';
  }

  @override
  String get notificationsRemoveTooltip => 'Entfernen';
}
