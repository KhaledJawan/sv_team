// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'SV Team Catering';

  @override
  String get commonToday => 'Today';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonSave => 'Save';

  @override
  String get commonDelete => 'Delete';

  @override
  String get commonEdit => 'Edit';

  @override
  String get commonBack => 'Back';

  @override
  String get commonNext => 'Next';

  @override
  String get commonDone => 'Done';

  @override
  String get commonPay => 'Pay';

  @override
  String get commonRoom => 'Room';

  @override
  String get commonCategory => 'Category';

  @override
  String get commonNote => 'Note';

  @override
  String get commonSummary => 'Summary';

  @override
  String get commonStatus => 'Status';

  @override
  String get commonItem => 'Item';

  @override
  String get commonStart => 'Start';

  @override
  String get commonSold => 'Sold';

  @override
  String get commonRemain => 'Remain';

  @override
  String get commonRemove => 'Remove';

  @override
  String get commonSaveClose => 'Save & close';

  @override
  String get commonSelectTime => 'Select time';

  @override
  String get commonSelectRoom => 'Select room';

  @override
  String get commonSelectDate => 'Select date';

  @override
  String get navManage => 'Manage';

  @override
  String get navTasks => 'Tasks';

  @override
  String get navProfile => 'Profile';

  @override
  String get manageReserve => 'Reserve';

  @override
  String get manageSnacky => 'Snacky';

  @override
  String get manageOthers => 'Others';

  @override
  String get manageNotificationsTooltip => 'Notifications';

  @override
  String get profileTitle => 'Profile';

  @override
  String get profilePlaceholder => 'Profile settings will be expanded in the next phase.';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsUseSystem => 'Use system language';

  @override
  String get settingsGerman => 'German';

  @override
  String get settingsEnglish => 'English';

  @override
  String get othersTitle => 'Others';

  @override
  String get othersSubtitle => 'Others will be added in the next phase.';

  @override
  String get reserveTitle => 'Reserve';

  @override
  String get reserveIntro => 'Choose request type first, then complete the form.';

  @override
  String get reserveSelectTypeHint => 'Select Drinks, Food Setup, or Note to continue.';

  @override
  String get reserveTypeDrinks => 'Drinks';

  @override
  String get reserveTypeFoodSetup => 'Food Setup';

  @override
  String get reserveTypeNote => 'Note';

  @override
  String get reserveDrinksRequestTitle => 'Drinks Request';

  @override
  String get reserveFoodSetupRequestTitle => 'Food Setup Request';

  @override
  String get reserveNoteRequestTitle => 'Note Request';

  @override
  String get reserveDrinksSectionTitle => 'Drinks';

  @override
  String get reserveFoodSetupItemsTitle => 'Service Setup Items';

  @override
  String get reserveReservationDate => 'Reservation Date';

  @override
  String get reservePrepareTime => 'Prepare Time';

  @override
  String get reserveCollectTime => 'Collect Time';

  @override
  String get reservePeopleCount => 'Number of People';

  @override
  String get reserveTitleOptional => 'Title (optional)';

  @override
  String get reserveNoteDescription => 'Note / Description';

  @override
  String get reserveCreateDrinksTask => 'Create Drinks Task';

  @override
  String get reserveCreateFoodSetupTask => 'Create Food Setup Task';

  @override
  String get reserveCreateNoteTask => 'Create Note Task';

  @override
  String get reserveSuccessDrinksAdded => 'Drinks reservation added to Tasks.';

  @override
  String get reserveSuccessFoodAdded => 'Food setup request added to Tasks.';

  @override
  String get reserveSuccessNoteAdded => 'Note request added to Tasks.';

  @override
  String get validationSelectRoom => 'Please select a room.';

  @override
  String get validationSelectPrepareTime => 'Please select prepare time.';

  @override
  String get validationSelectCollectTime => 'Please select collect time.';

  @override
  String get validationPersonsInvalid => 'Persons count must be a number greater than 0.';

  @override
  String get validationAddDrink => 'Please add at least one drink.';

  @override
  String get validationAddSetupItem => 'Please add at least one setup item.';

  @override
  String get validationCollectAfterPrepare => 'Collect time must be after prepare time.';

  @override
  String get validationNoteRequired => 'Note / description is required.';

  @override
  String get aufgabenTitle => 'Tasks';

  @override
  String get aufgabenEmptyTitle => 'No tasks yet';

  @override
  String get aufgabenEmptySubtitle => 'Create a reservation to generate your first task.';

  @override
  String get aufgabenTaskDeleted => 'Task deleted.';

  @override
  String get aufgabenDailySnackNoDelete => 'Daily snack-machine tasks cannot be deleted.';

  @override
  String get aufgabenChangeStatusTitle => 'Change status';

  @override
  String get aufgabenDeleteTaskTitle => 'Delete task?';

  @override
  String get aufgabenDeleteTaskBody => 'This action cannot be undone.';

  @override
  String get taskActionsTooltip => 'Task actions';

  @override
  String get taskActionsOpenEdit => 'Edit / Open';

  @override
  String get taskActionsChangeStatus => 'Change status';

  @override
  String get taskNoPersonsCount => 'No persons count';

  @override
  String taskPersons(int count) {
    return '$count persons';
  }

  @override
  String taskPrepAt(Object time) {
    return 'Prep $time';
  }

  @override
  String taskCollectAt(Object time) {
    return 'Collect $time';
  }

  @override
  String get taskDetailTitle => 'Task';

  @override
  String get taskNotFound => 'Task not found.';

  @override
  String get taskUpdated => 'Task updated.';

  @override
  String get taskStatusSection => 'Status';

  @override
  String get taskSummarySection => 'Summary';

  @override
  String get taskInfoSection => 'Task Info';

  @override
  String get taskRoomLabel => 'Room';

  @override
  String get taskPrepareTimeLabel => 'Prepare Time';

  @override
  String get taskCollectTimeLabel => 'Collect Time';

  @override
  String get taskPersonsLabel => 'Persons';

  @override
  String get taskItemsOrderedDrinks => 'Ordered Drinks';

  @override
  String get taskItemsSetup => 'Setup Items';

  @override
  String get taskItemsGeneric => 'Items';

  @override
  String get taskNoItems => 'No items listed.';

  @override
  String get taskAutoGeneratedSupportTitle => 'Auto-Generated Support Items';

  @override
  String get taskNoSupportItems => 'No support items generated.';

  @override
  String get taskNoteSection => 'Note';

  @override
  String get taskNoNote => 'No note added.';

  @override
  String get taskEditSection => 'Edit Task';

  @override
  String get taskPrepareDateLabel => 'Prepare Date';

  @override
  String get taskCollectDateLabel => 'Collect Date';

  @override
  String get taskNumberOfPeopleLabel => 'Number of People';

  @override
  String get taskShortDescriptionLabel => 'Short Description';

  @override
  String get taskDrinksItemsLabel => 'Drinks Items';

  @override
  String get taskFoodSetupItemsLabel => 'Food Setup Items';

  @override
  String get taskErrorRoomRequired => 'Room is required.';

  @override
  String get taskErrorAddItem => 'Add at least one item.';

  @override
  String get taskSaveStatusChangeTitle => 'Save status change?';

  @override
  String taskChangeStatusMessage(Object from, Object to) {
    return 'Change status from $from to $to?';
  }

  @override
  String get taskDescriptionNoteRequest => 'Note request';

  @override
  String get taskDescriptionDrinks => 'Drinks';

  @override
  String get taskDescriptionFoodSetup => 'Food setup';

  @override
  String taskMoreItems(int count) {
    return '+$count items';
  }

  @override
  String get taskStatusPending => 'Pending';

  @override
  String get taskStatusPrepared => 'Prepiered';

  @override
  String get taskStatusDone => 'Done';

  @override
  String get taskStatusProblem => 'Problem';

  @override
  String get taskCategoryDrinks => 'Drinks';

  @override
  String get taskCategoryFoodSetup => 'Food Setup';

  @override
  String get taskCategoryNote => 'Note';

  @override
  String get taskCategorySnacky => 'Snacky';

  @override
  String get taskCategoryOthers => 'Others';

  @override
  String get snackyTitle => 'Snacky';

  @override
  String get snackyChoosePrompt => 'Choose what you want to manage.';

  @override
  String get snackyOptionDirectSellTitle => 'Direct Sell';

  @override
  String get snackyOptionDirectSellSubtitle => 'Stock setup, cashier flow, payment, and end-of-day summary.';

  @override
  String get snackyOpenDirectSell => 'Open Direct Sell';

  @override
  String get snackyOptionOrdersTitle => 'Orders';

  @override
  String get snackyOptionOrdersSubtitle => 'Orders workflow and tracking.';

  @override
  String get snackyOpenOrders => 'Open Orders';

  @override
  String get snackyDirectSellPageTitle => 'Snacky · Direct Sell';

  @override
  String get snackyOrdersPageTitle => 'Snacky · Orders';

  @override
  String get snackyOrdersPlaceholderSubtitle => 'Orders will be added in the next phase.';

  @override
  String get directSellStepStockSetup => 'Stock Setup';

  @override
  String get directSellStepSelling => 'Selling';

  @override
  String get directSellStepSummary => 'Summary';

  @override
  String get directSellCategorySandwiches => 'Sandwiches / Brötchen';

  @override
  String get directSellCategoryBakery => 'Bakery / Sweet';

  @override
  String get directSellCategorySnacks => 'Snacks / Sweets';

  @override
  String get directSellCategoryDrinks => 'Drinks';

  @override
  String get directSellCategoryExtras => 'Extras / Other';

  @override
  String get directSellStockStepTitle => 'Step 1: Stock Setup';

  @override
  String get directSellStockStepSubtitle => 'Set start quantities and editable prices before opening the cashier.';

  @override
  String get directSellCashierStepTitle => 'Step 2: Selling / Cashier';

  @override
  String get directSellCashierStepSubtitle => 'Tap an item to add it to the current basket. You cannot sell more than available stock.';

  @override
  String get directSellSummaryStepTitle => 'Step 3: End Summary';

  @override
  String get directSellSummaryStepSubtitle => 'Final numbers for this direct-sell session.';

  @override
  String get directSellSpecialTag => 'Special';

  @override
  String directSellSoldCount(int count) {
    return 'Sold $count';
  }

  @override
  String get directSellAvailableItems => 'Available Items';

  @override
  String get directSellNoStock => 'No available stock. Go back to setup and add quantities.';

  @override
  String directSellRemainingCount(int count) {
    return 'Remaining $count';
  }

  @override
  String get directSellAdd => 'Add';

  @override
  String get directSellCurrentBasket => 'Current Basket';

  @override
  String get directSellNoBasket => 'No items in basket yet.';

  @override
  String get directSellEach => 'each';

  @override
  String get directSellSubtotal => 'Subtotal';

  @override
  String get directSellBackToStock => 'Back to Stock';

  @override
  String get directSellBackToSelling => 'Back to Selling';

  @override
  String get directSellNewSession => 'New Session';

  @override
  String get directSellPaymentTitle => 'Complete payment';

  @override
  String directSellTotalAmount(Object amount) {
    return 'Total: $amount';
  }

  @override
  String get directSellCustomerGave => 'Customer gave';

  @override
  String directSellChangeAmount(Object amount) {
    return 'Change: $amount';
  }

  @override
  String get directSellConfirmPayment => 'Confirm payment';

  @override
  String directSellSaleSavedChange(Object amount) {
    return 'Sale saved. Change: $amount';
  }

  @override
  String get directSellErrorValidAmount => 'Enter a valid amount.';

  @override
  String get directSellErrorPaidLess => 'Paid amount is less than total.';

  @override
  String get directSellMoveToCashierError => 'Add at least one item quantity before continuing.';

  @override
  String get directSellMoveToSummaryError => 'Finish payment or clear basket before closing the session.';

  @override
  String get directSellBasketEmptyError => 'Basket is empty.';

  @override
  String get directSellMetricTotalRevenue => 'Total Revenue';

  @override
  String get directSellMetricTotalTransactions => 'Total Transactions';

  @override
  String get directSellMetricTotalSoldItems => 'Total Sold Items';

  @override
  String get directSellMetricRemainingItems => 'Remaining Items';

  @override
  String get directSellMetricStartingQuantities => 'Starting Quantities';

  @override
  String get directSellPerItemSummary => 'Per-item Summary';

  @override
  String get directSellNoSessionData => 'No session data yet.';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get notificationsClearAll => 'Clear all';

  @override
  String get notificationsEmptyTitle => 'No notifications';

  @override
  String get notificationsEmptySubtitle => 'Task updates will appear here.';

  @override
  String notificationsByActor(Object name) {
    return 'By $name';
  }

  @override
  String get notificationsRemoveTooltip => 'Remove';
}
