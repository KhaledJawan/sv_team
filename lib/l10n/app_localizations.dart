import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';

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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'SV Team Catering'**
  String get appTitle;

  /// No description provided for @commonToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get commonToday;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get commonSave;

  /// No description provided for @commonDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get commonDelete;

  /// No description provided for @commonEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get commonEdit;

  /// No description provided for @commonBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get commonBack;

  /// No description provided for @commonNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get commonNext;

  /// No description provided for @commonDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get commonDone;

  /// No description provided for @commonPay.
  ///
  /// In en, this message translates to:
  /// **'Pay'**
  String get commonPay;

  /// No description provided for @commonRoom.
  ///
  /// In en, this message translates to:
  /// **'Room'**
  String get commonRoom;

  /// No description provided for @commonCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get commonCategory;

  /// No description provided for @commonNote.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get commonNote;

  /// No description provided for @commonSummary.
  ///
  /// In en, this message translates to:
  /// **'Summary'**
  String get commonSummary;

  /// No description provided for @commonStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get commonStatus;

  /// No description provided for @commonItem.
  ///
  /// In en, this message translates to:
  /// **'Item'**
  String get commonItem;

  /// No description provided for @commonStart.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get commonStart;

  /// No description provided for @commonSold.
  ///
  /// In en, this message translates to:
  /// **'Sold'**
  String get commonSold;

  /// No description provided for @commonRemain.
  ///
  /// In en, this message translates to:
  /// **'Remain'**
  String get commonRemain;

  /// No description provided for @commonRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get commonRemove;

  /// No description provided for @commonSaveClose.
  ///
  /// In en, this message translates to:
  /// **'Save & close'**
  String get commonSaveClose;

  /// No description provided for @commonSelectTime.
  ///
  /// In en, this message translates to:
  /// **'Select time'**
  String get commonSelectTime;

  /// No description provided for @commonSelectRoom.
  ///
  /// In en, this message translates to:
  /// **'Select room'**
  String get commonSelectRoom;

  /// No description provided for @commonSelectDate.
  ///
  /// In en, this message translates to:
  /// **'Select date'**
  String get commonSelectDate;

  /// No description provided for @navManage.
  ///
  /// In en, this message translates to:
  /// **'Manage'**
  String get navManage;

  /// No description provided for @navTasks.
  ///
  /// In en, this message translates to:
  /// **'Tasks'**
  String get navTasks;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @manageReserve.
  ///
  /// In en, this message translates to:
  /// **'Reserve'**
  String get manageReserve;

  /// No description provided for @manageSnacky.
  ///
  /// In en, this message translates to:
  /// **'Snacky'**
  String get manageSnacky;

  /// No description provided for @manageOthers.
  ///
  /// In en, this message translates to:
  /// **'Others'**
  String get manageOthers;

  /// No description provided for @manageNotificationsTooltip.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get manageNotificationsTooltip;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @profilePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Profile settings will be expanded in the next phase.'**
  String get profilePlaceholder;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsUseSystem.
  ///
  /// In en, this message translates to:
  /// **'Use system language'**
  String get settingsUseSystem;

  /// No description provided for @settingsGerman.
  ///
  /// In en, this message translates to:
  /// **'German'**
  String get settingsGerman;

  /// No description provided for @settingsEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get settingsEnglish;

  /// No description provided for @othersTitle.
  ///
  /// In en, this message translates to:
  /// **'Others'**
  String get othersTitle;

  /// No description provided for @othersSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Others will be added in the next phase.'**
  String get othersSubtitle;

  /// No description provided for @reserveTitle.
  ///
  /// In en, this message translates to:
  /// **'Reserve'**
  String get reserveTitle;

  /// No description provided for @reserveIntro.
  ///
  /// In en, this message translates to:
  /// **'Choose request type first, then complete the form.'**
  String get reserveIntro;

  /// No description provided for @reserveSelectTypeHint.
  ///
  /// In en, this message translates to:
  /// **'Select Drinks, Food Setup, or Note to continue.'**
  String get reserveSelectTypeHint;

  /// No description provided for @reserveTypeDrinks.
  ///
  /// In en, this message translates to:
  /// **'Drinks'**
  String get reserveTypeDrinks;

  /// No description provided for @reserveTypeFoodSetup.
  ///
  /// In en, this message translates to:
  /// **'Food Setup'**
  String get reserveTypeFoodSetup;

  /// No description provided for @reserveTypeNote.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get reserveTypeNote;

  /// No description provided for @reserveDrinksRequestTitle.
  ///
  /// In en, this message translates to:
  /// **'Drinks Request'**
  String get reserveDrinksRequestTitle;

  /// No description provided for @reserveFoodSetupRequestTitle.
  ///
  /// In en, this message translates to:
  /// **'Food Setup Request'**
  String get reserveFoodSetupRequestTitle;

  /// No description provided for @reserveNoteRequestTitle.
  ///
  /// In en, this message translates to:
  /// **'Note Request'**
  String get reserveNoteRequestTitle;

  /// No description provided for @reserveDrinksSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Drinks'**
  String get reserveDrinksSectionTitle;

  /// No description provided for @reserveFoodSetupItemsTitle.
  ///
  /// In en, this message translates to:
  /// **'Service Setup Items'**
  String get reserveFoodSetupItemsTitle;

  /// No description provided for @reserveReservationDate.
  ///
  /// In en, this message translates to:
  /// **'Reservation Date'**
  String get reserveReservationDate;

  /// No description provided for @reservePrepareTime.
  ///
  /// In en, this message translates to:
  /// **'Prepare Time'**
  String get reservePrepareTime;

  /// No description provided for @reserveCollectTime.
  ///
  /// In en, this message translates to:
  /// **'Collect Time'**
  String get reserveCollectTime;

  /// No description provided for @reservePeopleCount.
  ///
  /// In en, this message translates to:
  /// **'Number of People'**
  String get reservePeopleCount;

  /// No description provided for @reserveTitleOptional.
  ///
  /// In en, this message translates to:
  /// **'Title (optional)'**
  String get reserveTitleOptional;

  /// No description provided for @reserveNoteDescription.
  ///
  /// In en, this message translates to:
  /// **'Note / Description'**
  String get reserveNoteDescription;

  /// No description provided for @reserveCreateDrinksTask.
  ///
  /// In en, this message translates to:
  /// **'Create Drinks Task'**
  String get reserveCreateDrinksTask;

  /// No description provided for @reserveCreateFoodSetupTask.
  ///
  /// In en, this message translates to:
  /// **'Create Food Setup Task'**
  String get reserveCreateFoodSetupTask;

  /// No description provided for @reserveCreateNoteTask.
  ///
  /// In en, this message translates to:
  /// **'Create Note Task'**
  String get reserveCreateNoteTask;

  /// No description provided for @reserveSuccessDrinksAdded.
  ///
  /// In en, this message translates to:
  /// **'Drinks reservation added to Tasks.'**
  String get reserveSuccessDrinksAdded;

  /// No description provided for @reserveSuccessFoodAdded.
  ///
  /// In en, this message translates to:
  /// **'Food setup request added to Tasks.'**
  String get reserveSuccessFoodAdded;

  /// No description provided for @reserveSuccessNoteAdded.
  ///
  /// In en, this message translates to:
  /// **'Note request added to Tasks.'**
  String get reserveSuccessNoteAdded;

  /// No description provided for @validationSelectRoom.
  ///
  /// In en, this message translates to:
  /// **'Please select a room.'**
  String get validationSelectRoom;

  /// No description provided for @validationSelectPrepareTime.
  ///
  /// In en, this message translates to:
  /// **'Please select prepare time.'**
  String get validationSelectPrepareTime;

  /// No description provided for @validationSelectCollectTime.
  ///
  /// In en, this message translates to:
  /// **'Please select collect time.'**
  String get validationSelectCollectTime;

  /// No description provided for @validationPersonsInvalid.
  ///
  /// In en, this message translates to:
  /// **'Persons count must be a number greater than 0.'**
  String get validationPersonsInvalid;

  /// No description provided for @validationAddDrink.
  ///
  /// In en, this message translates to:
  /// **'Please add at least one drink.'**
  String get validationAddDrink;

  /// No description provided for @validationAddSetupItem.
  ///
  /// In en, this message translates to:
  /// **'Please add at least one setup item.'**
  String get validationAddSetupItem;

  /// No description provided for @validationCollectAfterPrepare.
  ///
  /// In en, this message translates to:
  /// **'Collect time must be after prepare time.'**
  String get validationCollectAfterPrepare;

  /// No description provided for @validationNoteRequired.
  ///
  /// In en, this message translates to:
  /// **'Note / description is required.'**
  String get validationNoteRequired;

  /// No description provided for @aufgabenTitle.
  ///
  /// In en, this message translates to:
  /// **'Tasks'**
  String get aufgabenTitle;

  /// No description provided for @aufgabenEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No tasks yet'**
  String get aufgabenEmptyTitle;

  /// No description provided for @aufgabenEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create a reservation to generate your first task.'**
  String get aufgabenEmptySubtitle;

  /// No description provided for @aufgabenTaskDeleted.
  ///
  /// In en, this message translates to:
  /// **'Task deleted.'**
  String get aufgabenTaskDeleted;

  /// No description provided for @aufgabenDailySnackNoDelete.
  ///
  /// In en, this message translates to:
  /// **'Daily snack-machine tasks cannot be deleted.'**
  String get aufgabenDailySnackNoDelete;

  /// No description provided for @aufgabenChangeStatusTitle.
  ///
  /// In en, this message translates to:
  /// **'Change status'**
  String get aufgabenChangeStatusTitle;

  /// No description provided for @aufgabenDeleteTaskTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete task?'**
  String get aufgabenDeleteTaskTitle;

  /// No description provided for @aufgabenDeleteTaskBody.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone.'**
  String get aufgabenDeleteTaskBody;

  /// No description provided for @taskActionsTooltip.
  ///
  /// In en, this message translates to:
  /// **'Task actions'**
  String get taskActionsTooltip;

  /// No description provided for @taskActionsOpenEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit / Open'**
  String get taskActionsOpenEdit;

  /// No description provided for @taskActionsChangeStatus.
  ///
  /// In en, this message translates to:
  /// **'Change status'**
  String get taskActionsChangeStatus;

  /// No description provided for @taskNoPersonsCount.
  ///
  /// In en, this message translates to:
  /// **'No persons count'**
  String get taskNoPersonsCount;

  /// No description provided for @taskPersons.
  ///
  /// In en, this message translates to:
  /// **'{count} persons'**
  String taskPersons(int count);

  /// No description provided for @taskPrepAt.
  ///
  /// In en, this message translates to:
  /// **'Prep {time}'**
  String taskPrepAt(Object time);

  /// No description provided for @taskCollectAt.
  ///
  /// In en, this message translates to:
  /// **'Collect {time}'**
  String taskCollectAt(Object time);

  /// No description provided for @taskDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Task'**
  String get taskDetailTitle;

  /// No description provided for @taskNotFound.
  ///
  /// In en, this message translates to:
  /// **'Task not found.'**
  String get taskNotFound;

  /// No description provided for @taskUpdated.
  ///
  /// In en, this message translates to:
  /// **'Task updated.'**
  String get taskUpdated;

  /// No description provided for @taskStatusSection.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get taskStatusSection;

  /// No description provided for @taskSummarySection.
  ///
  /// In en, this message translates to:
  /// **'Summary'**
  String get taskSummarySection;

  /// No description provided for @taskInfoSection.
  ///
  /// In en, this message translates to:
  /// **'Task Info'**
  String get taskInfoSection;

  /// No description provided for @taskRoomLabel.
  ///
  /// In en, this message translates to:
  /// **'Room'**
  String get taskRoomLabel;

  /// No description provided for @taskPrepareTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'Prepare Time'**
  String get taskPrepareTimeLabel;

  /// No description provided for @taskCollectTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'Collect Time'**
  String get taskCollectTimeLabel;

  /// No description provided for @taskPersonsLabel.
  ///
  /// In en, this message translates to:
  /// **'Persons'**
  String get taskPersonsLabel;

  /// No description provided for @taskItemsOrderedDrinks.
  ///
  /// In en, this message translates to:
  /// **'Ordered Drinks'**
  String get taskItemsOrderedDrinks;

  /// No description provided for @taskItemsSetup.
  ///
  /// In en, this message translates to:
  /// **'Setup Items'**
  String get taskItemsSetup;

  /// No description provided for @taskItemsGeneric.
  ///
  /// In en, this message translates to:
  /// **'Items'**
  String get taskItemsGeneric;

  /// No description provided for @taskNoItems.
  ///
  /// In en, this message translates to:
  /// **'No items listed.'**
  String get taskNoItems;

  /// No description provided for @taskAutoGeneratedSupportTitle.
  ///
  /// In en, this message translates to:
  /// **'Auto-Generated Support Items'**
  String get taskAutoGeneratedSupportTitle;

  /// No description provided for @taskNoSupportItems.
  ///
  /// In en, this message translates to:
  /// **'No support items generated.'**
  String get taskNoSupportItems;

  /// No description provided for @taskNoteSection.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get taskNoteSection;

  /// No description provided for @taskNoNote.
  ///
  /// In en, this message translates to:
  /// **'No note added.'**
  String get taskNoNote;

  /// No description provided for @taskEditSection.
  ///
  /// In en, this message translates to:
  /// **'Edit Task'**
  String get taskEditSection;

  /// No description provided for @taskPrepareDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Prepare Date'**
  String get taskPrepareDateLabel;

  /// No description provided for @taskCollectDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Collect Date'**
  String get taskCollectDateLabel;

  /// No description provided for @taskNumberOfPeopleLabel.
  ///
  /// In en, this message translates to:
  /// **'Number of People'**
  String get taskNumberOfPeopleLabel;

  /// No description provided for @taskShortDescriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Short Description'**
  String get taskShortDescriptionLabel;

  /// No description provided for @taskDrinksItemsLabel.
  ///
  /// In en, this message translates to:
  /// **'Drinks Items'**
  String get taskDrinksItemsLabel;

  /// No description provided for @taskFoodSetupItemsLabel.
  ///
  /// In en, this message translates to:
  /// **'Food Setup Items'**
  String get taskFoodSetupItemsLabel;

  /// No description provided for @taskErrorRoomRequired.
  ///
  /// In en, this message translates to:
  /// **'Room is required.'**
  String get taskErrorRoomRequired;

  /// No description provided for @taskErrorAddItem.
  ///
  /// In en, this message translates to:
  /// **'Add at least one item.'**
  String get taskErrorAddItem;

  /// No description provided for @taskSaveStatusChangeTitle.
  ///
  /// In en, this message translates to:
  /// **'Save status change?'**
  String get taskSaveStatusChangeTitle;

  /// No description provided for @taskChangeStatusMessage.
  ///
  /// In en, this message translates to:
  /// **'Change status from {from} to {to}?'**
  String taskChangeStatusMessage(Object from, Object to);

  /// No description provided for @taskDescriptionNoteRequest.
  ///
  /// In en, this message translates to:
  /// **'Note request'**
  String get taskDescriptionNoteRequest;

  /// No description provided for @taskDescriptionDrinks.
  ///
  /// In en, this message translates to:
  /// **'Drinks'**
  String get taskDescriptionDrinks;

  /// No description provided for @taskDescriptionFoodSetup.
  ///
  /// In en, this message translates to:
  /// **'Food setup'**
  String get taskDescriptionFoodSetup;

  /// No description provided for @taskMoreItems.
  ///
  /// In en, this message translates to:
  /// **'+{count} items'**
  String taskMoreItems(int count);

  /// No description provided for @taskStatusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get taskStatusPending;

  /// No description provided for @taskStatusPrepared.
  ///
  /// In en, this message translates to:
  /// **'Prepiered'**
  String get taskStatusPrepared;

  /// No description provided for @taskStatusDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get taskStatusDone;

  /// No description provided for @taskStatusProblem.
  ///
  /// In en, this message translates to:
  /// **'Problem'**
  String get taskStatusProblem;

  /// No description provided for @taskCategoryDrinks.
  ///
  /// In en, this message translates to:
  /// **'Drinks'**
  String get taskCategoryDrinks;

  /// No description provided for @taskCategoryFoodSetup.
  ///
  /// In en, this message translates to:
  /// **'Food Setup'**
  String get taskCategoryFoodSetup;

  /// No description provided for @taskCategoryNote.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get taskCategoryNote;

  /// No description provided for @taskCategorySnacky.
  ///
  /// In en, this message translates to:
  /// **'Snacky'**
  String get taskCategorySnacky;

  /// No description provided for @taskCategoryOthers.
  ///
  /// In en, this message translates to:
  /// **'Others'**
  String get taskCategoryOthers;

  /// No description provided for @snackyTitle.
  ///
  /// In en, this message translates to:
  /// **'Snacky'**
  String get snackyTitle;

  /// No description provided for @snackyChoosePrompt.
  ///
  /// In en, this message translates to:
  /// **'Choose what you want to manage.'**
  String get snackyChoosePrompt;

  /// No description provided for @snackyOptionDirectSellTitle.
  ///
  /// In en, this message translates to:
  /// **'Direct Sell'**
  String get snackyOptionDirectSellTitle;

  /// No description provided for @snackyOptionDirectSellSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Stock setup, cashier flow, payment, and end-of-day summary.'**
  String get snackyOptionDirectSellSubtitle;

  /// No description provided for @snackyOpenDirectSell.
  ///
  /// In en, this message translates to:
  /// **'Open Direct Sell'**
  String get snackyOpenDirectSell;

  /// No description provided for @snackyOptionOrdersTitle.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get snackyOptionOrdersTitle;

  /// No description provided for @snackyOptionOrdersSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Orders workflow and tracking.'**
  String get snackyOptionOrdersSubtitle;

  /// No description provided for @snackyOpenOrders.
  ///
  /// In en, this message translates to:
  /// **'Open Orders'**
  String get snackyOpenOrders;

  /// No description provided for @snackyDirectSellPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Snacky · Direct Sell'**
  String get snackyDirectSellPageTitle;

  /// No description provided for @snackyOrdersPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Snacky · Orders'**
  String get snackyOrdersPageTitle;

  /// No description provided for @snackyOrdersPlaceholderSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Orders will be added in the next phase.'**
  String get snackyOrdersPlaceholderSubtitle;

  /// No description provided for @directSellStepStockSetup.
  ///
  /// In en, this message translates to:
  /// **'Stock Setup'**
  String get directSellStepStockSetup;

  /// No description provided for @directSellStepSelling.
  ///
  /// In en, this message translates to:
  /// **'Selling'**
  String get directSellStepSelling;

  /// No description provided for @directSellStepSummary.
  ///
  /// In en, this message translates to:
  /// **'Summary'**
  String get directSellStepSummary;

  /// No description provided for @directSellCategorySandwiches.
  ///
  /// In en, this message translates to:
  /// **'Sandwiches / Brötchen'**
  String get directSellCategorySandwiches;

  /// No description provided for @directSellCategoryBakery.
  ///
  /// In en, this message translates to:
  /// **'Bakery / Sweet'**
  String get directSellCategoryBakery;

  /// No description provided for @directSellCategorySnacks.
  ///
  /// In en, this message translates to:
  /// **'Snacks / Sweets'**
  String get directSellCategorySnacks;

  /// No description provided for @directSellCategoryDrinks.
  ///
  /// In en, this message translates to:
  /// **'Drinks'**
  String get directSellCategoryDrinks;

  /// No description provided for @directSellCategoryExtras.
  ///
  /// In en, this message translates to:
  /// **'Extras / Other'**
  String get directSellCategoryExtras;

  /// No description provided for @directSellStockStepTitle.
  ///
  /// In en, this message translates to:
  /// **'Step 1: Stock Setup'**
  String get directSellStockStepTitle;

  /// No description provided for @directSellStockStepSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Set start quantities and editable prices before opening the cashier.'**
  String get directSellStockStepSubtitle;

  /// No description provided for @directSellCashierStepTitle.
  ///
  /// In en, this message translates to:
  /// **'Step 2: Selling / Cashier'**
  String get directSellCashierStepTitle;

  /// No description provided for @directSellCashierStepSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tap an item to add it to the current basket. You cannot sell more than available stock.'**
  String get directSellCashierStepSubtitle;

  /// No description provided for @directSellSummaryStepTitle.
  ///
  /// In en, this message translates to:
  /// **'Step 3: End Summary'**
  String get directSellSummaryStepTitle;

  /// No description provided for @directSellSummaryStepSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Final numbers for this direct-sell session.'**
  String get directSellSummaryStepSubtitle;

  /// No description provided for @directSellSpecialTag.
  ///
  /// In en, this message translates to:
  /// **'Special'**
  String get directSellSpecialTag;

  /// No description provided for @directSellSoldCount.
  ///
  /// In en, this message translates to:
  /// **'Sold {count}'**
  String directSellSoldCount(int count);

  /// No description provided for @directSellAvailableItems.
  ///
  /// In en, this message translates to:
  /// **'Available Items'**
  String get directSellAvailableItems;

  /// No description provided for @directSellNoStock.
  ///
  /// In en, this message translates to:
  /// **'No available stock. Go back to setup and add quantities.'**
  String get directSellNoStock;

  /// No description provided for @directSellRemainingCount.
  ///
  /// In en, this message translates to:
  /// **'Remaining {count}'**
  String directSellRemainingCount(int count);

  /// No description provided for @directSellAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get directSellAdd;

  /// No description provided for @directSellCurrentBasket.
  ///
  /// In en, this message translates to:
  /// **'Current Basket'**
  String get directSellCurrentBasket;

  /// No description provided for @directSellNoBasket.
  ///
  /// In en, this message translates to:
  /// **'No items in basket yet.'**
  String get directSellNoBasket;

  /// No description provided for @directSellEach.
  ///
  /// In en, this message translates to:
  /// **'each'**
  String get directSellEach;

  /// No description provided for @directSellSubtotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get directSellSubtotal;

  /// No description provided for @directSellBackToStock.
  ///
  /// In en, this message translates to:
  /// **'Back to Stock'**
  String get directSellBackToStock;

  /// No description provided for @directSellBackToSelling.
  ///
  /// In en, this message translates to:
  /// **'Back to Selling'**
  String get directSellBackToSelling;

  /// No description provided for @directSellNewSession.
  ///
  /// In en, this message translates to:
  /// **'New Session'**
  String get directSellNewSession;

  /// No description provided for @directSellPaymentTitle.
  ///
  /// In en, this message translates to:
  /// **'Complete payment'**
  String get directSellPaymentTitle;

  /// No description provided for @directSellTotalAmount.
  ///
  /// In en, this message translates to:
  /// **'Total: {amount}'**
  String directSellTotalAmount(Object amount);

  /// No description provided for @directSellCustomerGave.
  ///
  /// In en, this message translates to:
  /// **'Customer gave'**
  String get directSellCustomerGave;

  /// No description provided for @directSellChangeAmount.
  ///
  /// In en, this message translates to:
  /// **'Change: {amount}'**
  String directSellChangeAmount(Object amount);

  /// No description provided for @directSellConfirmPayment.
  ///
  /// In en, this message translates to:
  /// **'Confirm payment'**
  String get directSellConfirmPayment;

  /// No description provided for @directSellSaleSavedChange.
  ///
  /// In en, this message translates to:
  /// **'Sale saved. Change: {amount}'**
  String directSellSaleSavedChange(Object amount);

  /// No description provided for @directSellErrorValidAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid amount.'**
  String get directSellErrorValidAmount;

  /// No description provided for @directSellErrorPaidLess.
  ///
  /// In en, this message translates to:
  /// **'Paid amount is less than total.'**
  String get directSellErrorPaidLess;

  /// No description provided for @directSellMoveToCashierError.
  ///
  /// In en, this message translates to:
  /// **'Add at least one item quantity before continuing.'**
  String get directSellMoveToCashierError;

  /// No description provided for @directSellMoveToSummaryError.
  ///
  /// In en, this message translates to:
  /// **'Finish payment or clear basket before closing the session.'**
  String get directSellMoveToSummaryError;

  /// No description provided for @directSellBasketEmptyError.
  ///
  /// In en, this message translates to:
  /// **'Basket is empty.'**
  String get directSellBasketEmptyError;

  /// No description provided for @directSellMetricTotalRevenue.
  ///
  /// In en, this message translates to:
  /// **'Total Revenue'**
  String get directSellMetricTotalRevenue;

  /// No description provided for @directSellMetricTotalTransactions.
  ///
  /// In en, this message translates to:
  /// **'Total Transactions'**
  String get directSellMetricTotalTransactions;

  /// No description provided for @directSellMetricTotalSoldItems.
  ///
  /// In en, this message translates to:
  /// **'Total Sold Items'**
  String get directSellMetricTotalSoldItems;

  /// No description provided for @directSellMetricRemainingItems.
  ///
  /// In en, this message translates to:
  /// **'Remaining Items'**
  String get directSellMetricRemainingItems;

  /// No description provided for @directSellMetricStartingQuantities.
  ///
  /// In en, this message translates to:
  /// **'Starting Quantities'**
  String get directSellMetricStartingQuantities;

  /// No description provided for @directSellPerItemSummary.
  ///
  /// In en, this message translates to:
  /// **'Per-item Summary'**
  String get directSellPerItemSummary;

  /// No description provided for @directSellNoSessionData.
  ///
  /// In en, this message translates to:
  /// **'No session data yet.'**
  String get directSellNoSessionData;

  /// No description provided for @notificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsTitle;

  /// No description provided for @notificationsClearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear all'**
  String get notificationsClearAll;

  /// No description provided for @notificationsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No notifications'**
  String get notificationsEmptyTitle;

  /// No description provided for @notificationsEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Task updates will appear here.'**
  String get notificationsEmptySubtitle;

  /// No description provided for @notificationsByActor.
  ///
  /// In en, this message translates to:
  /// **'By {name}'**
  String notificationsByActor(Object name);

  /// No description provided for @notificationsRemoveTooltip.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get notificationsRemoveTooltip;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['de', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de': return AppLocalizationsDe();
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
