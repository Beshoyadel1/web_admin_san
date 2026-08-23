import 'package:web_admin_san/core/theming/auth_local_storage.dart';
import 'package:web_admin_san/features/accounts_management/presentation/pages/view_all_providers_account_management/view_all_providers_account_management.dart';
import 'package:web_admin_san/features/admins/presentation/pages/view_all_admins/view_all_admins.dart';
import 'package:web_admin_san/features/approved_centers/presentation/pages/view_all_approved_centers/view_all_approved_centers.dart';
import 'package:web_admin_san/features/banner/presentation/pages/first_screen_advertisements_admin_sun/first_screen_advertisements_admin_sun.dart';
import 'package:web_admin_san/features/cars_haraj_page/presentation/ui/view_car_harag/view_car_harag.dart';
import 'package:web_admin_san/features/company/presentation/pages/view_all_companies/view_all_companies.dart';
import 'package:web_admin_san/features/coupon/presentation/pages/view_all_coupons/view_all_coupons.dart';
import 'package:web_admin_san/features/insurance/presentation/pages/view_all_companies_insurance/view_all_companies_insurance.dart';
import 'package:web_admin_san/features/order_services/presentation/pages/order_services_statistics/order_services_statistics.dart';
import 'package:web_admin_san/features/order_services/presentation/pages/order_services_type/ui/order_services_type_page.dart';
import 'package:web_admin_san/features/packages/presentation/pages/view_all_packages/view_all_packages.dart';
import 'package:web_admin_san/features/providers/presentation/pages/view_all_providers/view_all_provider.dart';
import 'package:web_admin_san/features/rates/presentation/pages/view_all_provider_rates/view_all_provider_rates.dart';
import 'package:web_admin_san/features/users/presentation/pages/view_all_users/view_all_users.dart';
import 'package:web_admin_san/features/warranty/presentation/pages/view_all_warranty/view_all_warranty.dart';
import '../../../core/general_models/pages_model.dart';
import '../../../core/language/language_constant.dart';
import '../../../core/theming/assets.dart';
import '../../../features/communication_and_policies_pages/presentation/pages/first_screen_communication_and_policies_pages/first_screen_communication_and_policies_pages.dart';
import '../../../features/logout_dashboard/presentation/first_screen_logout_dashboard/logout_dashboard.dart';
import '../../../features/store_page/presentation/pages/store_widgets/facility_account/facility_account.dart';
import '../../../features/technical_support/presentation/pages/technical_support_emp/technical_support_admin_sun.dart';

class AppStatesApi {
  static const String phoneExist = 'PhoneExist';
  static const String emailExist = 'EmailExist';
  static const String done = 'Done';
  static const String noUser = 'No User';
  static const String notActive = 'not active';
  static const String wrongPassword = 'Wrong Password';
  static const String reservedUser = 'Reserved';
  static const String haveOperationForDelete = 'HaveOperation';
  static const String notFound = 'not found';
  static const String sameUser = 'same user';
  static const String notEnoughSMAT = 'not enough SMAT';
}

class ValuesOfAllApp {
  static const int mobileWidth = 900;
  static const int tabWidth = 1250;
  static const int customTabWidth = 1050;
  static const int balanceRadioIndex = 1;
  static const int smatRadioIndex = 2;
  static const int subscriptionEliteButtonIndex = 1;
  static const String version = '2.0.0';
}

class PagesOfAllApp {
  static const String dashboardPage = 'Dashboard_Page';
  static const int dashboardPageNumber = 1;

  static const String securityPage = 'Security_Page';
  static const int securityPageNumber = 2;

  static const String permissionsGroupPage = 'Permissions_Group_Page';
  static const int permissionsGroupPageNumber = 201;

  static const String usersPermissionsPage = 'Users_Permissions_Page';
  static const int usersPermissionsPageNumber = 202;

  static const String userStatisticsPage = 'User_Statistics_Page';
  static const int userStatisticsPageNumber = 203;

  static const String settingsPage = 'Settings_Page';
  static const int settingsPageNumber = 3;

  static const String companiesPage = 'Companies_Page';
  static const int companiesPageNumber = 301;

  static const String generalSettingsPage = 'General_Settings_Page';
  static const int generalSettingsPageNumber = 302;

  static const String branchesPage = 'Branches_Page';
  static const int branchesPageNumber = 303;

  static const String inventoriesPage = 'Inventories_Page';
  static const int inventoriesPageNumber = 304;

  static const String banksPage = 'Banks_Page';
  static const int banksPageNumber = 305;

  static const String areasPage = 'Areas_Page';
  static const int areasPageNumber = 306;

  static const String taxesPage = 'Taxes_Page';
  static const int taxesPageNumber = 307;

  static const String financialPeriodPage = 'Financial_Period_Page';
  static const int financialPeriodPageNumber = 308;

  static const String costCenterPage = 'Cost_Center_Page';
  static const int costCenterPageNumber = 309;

  static const String currenciesPage = 'Currencies_Page';
  static const int currenciesPageNumber = 310;

  static const String categoriesPage = 'Categories_Page';
  static const int categoriesPageNumber = 311;

  static const String facilityManagementPage = 'Facility_Management_Page';
  static const int facilityManagementPageNumber = 312;

  static const String facilityAccountPage = 'Facility_Account_Page';
  static const int facilityAccountPageNumber = 313;

  static const String carModelsPage = 'Car_Models_Page';
  static const int carModelsPageNumber = 314;

  static const int internalServicesPageNumber = 315;

  static const String sparePage = 'Spare_Page';
  static const int sparePageNumber = 316;

  static const String walletPage = 'Security_Page';
  static const int walletPageNumber = 317;

  static const String usersPage = 'Security_Page';
  static const int usersPageNumber = 318;

  static const String notificationPage = 'Security_Page';
  static const int notificationPageNumber = 319;

  static const String bannerPage = 'Security_Page';
  static const int bannerPageNumber = 320;

  static const String starPage = 'Security_Page';
  static const int starPageNumber = 321;

  static const String pagesPage = 'Security_Page';
  static const int pagesPageNumber = 322;

  static const String logoutPage = 'Security_Page';
  static const int logoutPageNumber = 323;

  static const String carPage = 'Security_Page';
  static const int carPageNumber = 324;

  static const String internalServicesStatisticsPage = 'Security_Page';
  static const int internalServicesStatisticsPageNumber = 4;

  static const String carsHarajStatisticsPage = 'Security_Page';
  static const int carsHarajStatisticsPageNumber = 6;

  static const String internalOrdersPage = 'Security_Page';
  static const int internalOrdersPageNumber = 5;

  static const String carHarajOrdersPage = 'Security_Page';
  static const int carHarajOrdersPageNumber = 7;

  //-----------------------------------------------------------------
  static const String permissionsPage = 'Permissions_Page';
  static const int permissionsPageNumber = 500;

  static const String advertisementsPage = 'Advertisements_Page';
  static const int advertisementsPageNumber = 501;

  static const String petroleumPage = 'Petroleum_Page';
  static const int petroleumPageNumber = 502;
  static const String ordersPetroleumPage = 'Orders_Petroleum_Page';
  static const int ordersPetroleumPageNumber = 503;
  static const String oilProductsPetroleumPage = 'Oil_Products_Petroleum_Page';
  static const int oilProductsPetroleumPageNumber = 504;
  static const String facilityManagementPetroleumPage =
      'Facility_Management_Petroleum_Page';
  static const int facilityManagementPetroleumPageNumber = 505;
  static const String statisticsPetroleumPage = 'Statistics_Petroleum_Page';
  static const int statisticsPetroleumPageNumber = 506;

  static const String serviceSettingsPage = 'Service_Settings_Page';
  static const int serviceSettingsPageNumber = 507;
  static const String maintenanceAndInteriorServicesPage =
      'Maintenance_And_Interior_Services_Page';
  static const int maintenanceAndInteriorServicesPageNumber = 508;
  static const String carPartsPage = 'Car_Parts_Page';
  static const int carPartsPageNumber = 509;
  static const String sharedPackagesPage = 'Shared_Packages_Page';
  static const int sharedPackagesPageNumber = 510;
  static const String mobileServicesAndTransportationPage =
      'Mobile_Services_and_Transportation_Page';
  static const int mobileServicesAndTransportationPageNumber = 511;

  static const String sparePartsPage = 'spare_Parts_Page_Number_Page';
  static const int sparePartsPageNumber = 512;
  static const String sparePartsOrdersPage =
      'spare_Parts_orders_Page_Number_Page';
  static const int sparePartsOrdersPageNumber = 513;

  static const String sparePartsStaticsPage =
      'spare_parts_statics_page_number_page';
  static const int sparePartsStaticsPageNumber = 514;

  static const int mobileServicePageNumber = 515;
  static const int mobileServiceOrdersPageNumber = 516;
  static const int mobileServiceStaticsPageNumber = 517;

  static const int orderDetailsOnTheWayEmpPageNumber = 518;
  static const int orderDetailsOrderReceivedEmpPageNumber = 519;
  static const int orderDetailsNewOrderEmpPageNumber = 520;
  static const int orderDetailsUnderServiceEmpPageNumber = 521;
  static const String petrolInServiceSettingPage =
      'Petrol_In_Service_Setting_Page';
  static const int petrolInServiceSettingPageNumber = 522;

  static const int usersPermissionsPageNumber1 = 523;
  static const int firstScreenCarModelSettings = 524;
  static const int serviceSettingsCarModel = 525;
  static const int carAddScreenInCarModelSettings = 526;
  static const int walletPageNumber2 = 527;
  static const int amountPageNumber = 528;
  static const int technicalSupportPageNumber = 529;
  static const int amountPageNumber2 = 530;

  static const int oilChangeServicePageNumber = 531;
  static const int oilChangeServiceOrdersPageNumber = 532;
  static const int oilChangeServiceStaticsPageNumber = 533;

  static const int dashboardStaticsPageNumber = 534;
  static const int dashboardOrderPageNumber = 535;

  static const int addBannerPageNumber = 536;
  static const int bannerViewPageNumber = 537;
  static const int bannerMainPageNumber = 538;
  static const int ratePageNumber = 539;
  static const int viewAllProvidersNumber = 540;
  static const int viewAllUsersNumber = 541;
  static const int viewAllCarsHarajNumber = 542;
  static const int viewAllCompaniesNumber = 543;
  static const int viewAllCompaniesInsuranceNumber = 544;
  static const int viewAllAccountManagementNumber = 545;
  static const int viewAllApprovedCentersNumber = 546;
  static const int viewAllPackagesNumber = 547;
  static const int viewAllCouponNumber = 548;
  static const int viewAllAdminsNumber = 549;
  static const int viewAllWarrantyNumber = 550;

}

List<PageNodeModel> appPages = [];

Future<void> getPages() async {
  appPages.clear();

  final user = await AuthLocalStorage.getUser();
  final permissions = user?.adminDetails?.permissions;

  // ============================================================
  // NO PERMISSIONS OBJECT
  // ============================================================
  //
  // لو الـ permissions object نفسه غير موجود
  // اعتبره Full Access.
  //
  if (permissions == null) {
    appPages = _getAllPages();
    return;
  }

  // ============================================================
  // CHECK IF ALL PERMISSIONS ARE NULL
  // ============================================================

  final allPermissionsAreNull =
      permissions.statistic == null &&
          permissions.orders == null &&
          permissions.admins == null &&
          permissions.packages == null &&
          permissions.coupons == null &&
          permissions.providers == null &&
          permissions.approvals == null &&
          permissions.companies == null &&
          permissions.insurance == null &&
          permissions.harage == null &&
          permissions.users == null &&
          permissions.finances == null &&
          permissions.banners == null &&
          permissions.ranks == null &&
          permissions.support == null;

  // ============================================================
  // ALL NULL = FULL ACCESS
  // ============================================================

  if (allPermissionsAreNull) {
    appPages = _getAllPages();
    return;
  }

  // ============================================================
  // NORMAL ADMIN = USE PERMISSIONS
  // ============================================================

  bool hasPermission(bool? permission) {
    return permission == true;
  }

  appPages = [
    // ==========================================================
    // STATISTICS
    // ==========================================================

    if (hasPermission(permissions.statistic))
      const PageNodeModel(
        name: AppLanguageKeys.statistics,
        image: AppImageKeys.home,
        number: PagesOfAllApp.dashboardPageNumber,
        page: OrderServicesStatistics(),
      ),

    // ==========================================================
    // ORDERS
    // ==========================================================

    if (hasPermission(permissions.orders))
      const PageNodeModel(
        name: AppLanguageKeys.orders,
        number: PagesOfAllApp.dashboardOrderPageNumber,
        image: AppImageKeys.order,
        page: OrderServicesTypePage(),
      ),

    // ==========================================================
    // PROFILE - NO PERMISSION
    // ==========================================================

    const PageNodeModel(
      name: AppLanguageKeys.myAccount,
      image: AppImageKeys.users,
      number: PagesOfAllApp.securityPageNumber,
      page: FacilityAccount(),
    ),

    // ==========================================================
    // ADMINS
    // ==========================================================

    if (hasPermission(permissions.admins))
      const PageNodeModel(
        name: AppLanguageKeys.admins,
        image: AppImageKeys.admin,
        number: PagesOfAllApp.viewAllAdminsNumber,
        page: ViewAllAdmins(),
      ),

    // ==========================================================
    // PACKAGES
    // ==========================================================

    if (hasPermission(permissions.packages))
      const PageNodeModel(
        name: AppLanguageKeys.packages,
        image: AppImageKeys.packages,
        number: PagesOfAllApp.viewAllPackagesNumber,
        page: ViewAllPackages(),
      ),

    // ==========================================================
    // COUPONS
    // ==========================================================

    if (hasPermission(permissions.coupons))
      const PageNodeModel(
        name: AppLanguageKeys.coupon,
        image: AppImageKeys.coupon,
        number: PagesOfAllApp.viewAllCouponNumber,
        page: ViewAllCoupons(),
      ),

    // ==========================================================
    // PROVIDERS
    // ==========================================================

    if (hasPermission(permissions.providers))
      const PageNodeModel(
        name: AppLanguageKeys.providers,
        number: PagesOfAllApp.viewAllProvidersNumber,
        image: AppImageKeys.provider,
        page: ViewAllProvider(),
      ),

    // ==========================================================
    // APPROVED CENTERS
    // ==========================================================

    if (hasPermission(permissions.approvals))
      const PageNodeModel(
        name: AppLanguageKeys.approvedCenters,
        number: PagesOfAllApp.viewAllApprovedCentersNumber,
        image: AppImageKeys.approved,
        page: ViewAllApprovedCenters(),
      ),
    if (hasPermission(permissions.approvals))
      const PageNodeModel(
        name: AppLanguageKeys.warranty,
        number: PagesOfAllApp.viewAllWarrantyNumber,
        image: AppImageKeys.warranty,
        page: ViewAllWarranty(),
      ),

    // ==========================================================
    // COMPANIES
    // ==========================================================

    if (hasPermission(permissions.companies))
      const PageNodeModel(
        name: AppLanguageKeys.companies,
        number: PagesOfAllApp.viewAllCompaniesNumber,
        image: AppImageKeys.company,
        page: ViewAllCompanies(),
      ),

    // ==========================================================
    // INSURANCE
    // ==========================================================

    if (hasPermission(permissions.insurance))
      const PageNodeModel(
        name: AppLanguageKeys.insurances,
        number: PagesOfAllApp.viewAllCompaniesInsuranceNumber,
        image: AppImageKeys.insurance,
        page: ViewAllCompaniesInsurance(),
      ),

    // ==========================================================
    // CARS HARAJ
    // ==========================================================

    if (hasPermission(permissions.harage))
      const PageNodeModel(
        name: AppLanguageKeys.carsHaraj,
        number: PagesOfAllApp.viewAllCarsHarajNumber,
        image: AppImageKeys.car,
        page: ViewCarHarag(),
      ),

    // ==========================================================
    // USERS
    // ==========================================================

    if (hasPermission(permissions.users))
      const PageNodeModel(
        name: AppLanguageKeys.users,
        number: PagesOfAllApp.viewAllUsersNumber,
        image: AppImageKeys.users,
        page: ViewAllUsers(),
      ),

    // ==========================================================
    // FINANCES
    // ==========================================================

    if (hasPermission(permissions.finances))
      const PageNodeModel(
        name: AppLanguageKeys.finances,
        number: PagesOfAllApp.viewAllAccountManagementNumber,
        image: AppImageKeys.wallet,
        page: ViewAllProvidersAccountManagement(),
      ),

    // ==========================================================
    // BANNERS
    // ==========================================================

    if (hasPermission(permissions.banners))
      const PageNodeModel(
        name: AppLanguageKeys.banners,
        image: AppImageKeys.banner,
        number: PagesOfAllApp.bannerViewPageNumber,
        page: FirstScreenAdvertisementsAdminSun(),
      ),

    // ==========================================================
    // RANKS
    // ==========================================================

    if (hasPermission(permissions.ranks))
      const PageNodeModel(
        name: AppLanguageKeys.reviews,
        image: AppImageKeys.rank,
        number: PagesOfAllApp.ratePageNumber,
        page: ViewAllProviderRates(),
      ),

    // ==========================================================
    // TECHNICAL SUPPORT
    // ==========================================================

    if (hasPermission(permissions.support))
      const PageNodeModel(
        name: AppLanguageKeys.technicalSupport,
        image: AppImageKeys.support,
        number: PagesOfAllApp.technicalSupportPageNumber,
        page: TechnicalSupportAdminSun(),
      ),

    // ==========================================================
    // SOCIAL PAGES - NO PERMISSION
    // ==========================================================

    const PageNodeModel(
      name: AppLanguageKeys.socialPagesAndPoliciesKey,
      image: AppImageKeys.pages,
      number: PagesOfAllApp.pagesPageNumber,
      page: FirstScreenCommunicationAndPoliciesPages(),
    ),

    // ==========================================================
    // LOGOUT - NO PERMISSION
    // ==========================================================

    const PageNodeModel(
      name: AppLanguageKeys.logoutKey,
      image: AppImageKeys.logout,
      number: PagesOfAllApp.logoutPageNumber,
      page: LogoutDashboard(),
    ),
  ];
}
List<PageNodeModel> _getAllPages() {
  return [
    // ================= My Profile =================
    const PageNodeModel(
      name: AppLanguageKeys.myAccount,
      image: AppImageKeys.users,
      number: PagesOfAllApp.securityPageNumber,
      page: FacilityAccount(),
    ),

    // ================= SOCIAL PAGES =================

    const PageNodeModel(
      name: AppLanguageKeys.socialPagesAndPoliciesKey,
      image: AppImageKeys.pages,
      number: PagesOfAllApp.pagesPageNumber,
      page: FirstScreenCommunicationAndPoliciesPages(),
    ),

    // ================= LOGOUT =================

    const PageNodeModel(
      name: AppLanguageKeys.logoutKey,
      image: AppImageKeys.logout,
      number: PagesOfAllApp.logoutPageNumber,
      page: LogoutDashboard(),
    ),
  ];
}
