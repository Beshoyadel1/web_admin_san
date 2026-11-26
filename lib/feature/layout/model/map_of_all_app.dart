import 'package:web_admin_san/core/networking/local_services.dart';
import 'package:web_admin_san/feature/accounts_management_page/presentation/pages/view_all_providers_account_management/view_all_providers_account_management.dart';
import 'package:web_admin_san/feature/admins_page/presentation/pages/view_all_admins/view_all_admins.dart';
import 'package:web_admin_san/feature/approved_centers_page/presentation/pages/view_all_approved_centers/view_all_approved_centers.dart';
import 'package:web_admin_san/feature/advertisements_page/presentation/pages/first_screen_advertisements_admin_sun/first_screen_advertisements_admin_sun.dart';
import 'package:web_admin_san/feature/cars_haraj_page/presentation/ui/view_car_harag/view_car_harag.dart';
import 'package:web_admin_san/feature/companies_page/presentation/pages/view_all_companies/view_all_companies.dart';
import 'package:web_admin_san/feature/coupons_page/presentation/pages/view_all_coupons/view_all_coupons.dart';
import 'package:web_admin_san/feature/insurance_page/presentation/pages/view_all_companies_insurance/view_all_companies_insurance.dart';
import 'package:web_admin_san/feature/statistics_page/presentation/pages/statistics_page.dart';
import 'package:web_admin_san/feature/orders_page/presentation/pages/orders_page.dart';
import 'package:web_admin_san/feature/packages_page/presentation/pages/view_all_packages/view_all_packages.dart';
import 'package:web_admin_san/feature/providers_page/presentation/pages/view_all_providers/view_all_provider.dart';
import 'package:web_admin_san/feature/rates_page/presentation/pages/view_all_provider_rates/view_all_provider_rates.dart';
import 'package:web_admin_san/feature/users_page/presentation/pages/view_all_users/view_all_users.dart';
import 'package:web_admin_san/feature/warranty_page/presentation/pages/view_all_warranty/view_all_warranty.dart';
import '../../../core/helpers/models/pages_model.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import '../../../core/helpers/constants/assets.dart';
import 'package:web_admin_san/feature/communication_and_policies_page/presentation/pages/first_screen_communication_and_policies_pages/first_screen_communication_and_policies_pages.dart';
import 'package:web_admin_san/feature/logout_page/presentation/first_screen_logout_dashboard/logout_dashboard.dart';
import 'package:web_admin_san/feature/facility_account_page/presentation/pages/facility_account_page.dart';
import 'package:web_admin_san/feature/technical_support_page/presentation/pages/admin_chat_page.dart';
import 'package:web_admin_san/feature/cars_brands_page/presentation/page/brands_screen.dart';
import 'package:web_admin_san/feature/car_approval/presentation/pages/car_approval_page.dart';
import 'package:web_admin_san/feature/delivery_setting/presentation/pages/delivery_setting_page.dart';

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
  static const int carsBrandsNumber = 551;
  static const int carApprovalsNumber = 552;
  static const int deliverySettingsPageNumber = 553;
}

List<PageNodeModel> appPages = [];

Future<void> getPages() async {
  appPages.clear();

  final user = await AuthLocalStorage.getUser();
  final permissions = user?.adminDetails?.permissions;

  if (permissions == null) {
    appPages = _getAllPages();
    return;
  }

  // ============================================================
  // CHECK IF ALL PERMISSIONS ARE NULL
  // ============================================================

  final allPermissionsAreNull = permissions.statistic == null &&
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
      permissions.support == null &&
      permissions.carBrands == null &&
      permissions.carApprovals == null &&
      permissions.warranty == null &&
      permissions.policies == null &&
      permissions.deliverySetting == null;

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
        name: LocaleKeys.statistics,
        image: AppImageKeys.home,
        number: PagesOfAllApp.dashboardPageNumber,
        page: StatisticsPage(),
      ),

    // ==========================================================
    // ORDERS
    // ==========================================================

    if (hasPermission(permissions.orders))
      const PageNodeModel(
        name: LocaleKeys.orders,
        number: PagesOfAllApp.dashboardOrderPageNumber,
        image: AppImageKeys.order,
        page: OrdersPage(),
      ),

    // ==========================================================
    // PROFILE - NO PERMISSION
    // ==========================================================

    const PageNodeModel(
      name: LocaleKeys.myAccount,
      image: AppImageKeys.users,
      number: PagesOfAllApp.securityPageNumber,
      page: FacilityAccountPage(),
    ),

    // ==========================================================
    // ADMINS
    // ==========================================================

    if (hasPermission(permissions.admins))
      const PageNodeModel(
        name: LocaleKeys.admins,
        image: AppImageKeys.admin,
        number: PagesOfAllApp.viewAllAdminsNumber,
        page: AdminsPage(),
      ),

    // ==========================================================
    // PACKAGES
    // ==========================================================

    if (hasPermission(permissions.packages))
      const PageNodeModel(
        name: LocaleKeys.packages,
        image: AppImageKeys.packages,
        number: PagesOfAllApp.viewAllPackagesNumber,
        page: PackagesPage(),
      ),

    // ==========================================================
    // COUPONS
    // ==========================================================

    if (hasPermission(permissions.coupons))
      const PageNodeModel(
        name: LocaleKeys.coupon,
        image: AppImageKeys.coupon,
        number: PagesOfAllApp.viewAllCouponNumber,
        page: CouponsPage(),
      ),

    // ==========================================================
    // PROVIDERS
    // ==========================================================

    if (hasPermission(permissions.providers))
      const PageNodeModel(
        name: LocaleKeys.providers,
        number: PagesOfAllApp.viewAllProvidersNumber,
        image: AppImageKeys.provider,
        page: ProvidersPage(),
      ),

    // ==========================================================
    // APPROVED CENTERS
    // ==========================================================

    if (hasPermission(permissions.approvals))
      const PageNodeModel(
        name: LocaleKeys.approvedCenters,
        number: PagesOfAllApp.viewAllApprovedCentersNumber,
        image: AppImageKeys.approved,
        page: ApprovedCentersPage(),
      ),
    if (hasPermission(permissions.warranty))
      const PageNodeModel(
        name: LocaleKeys.warranty,
        number: PagesOfAllApp.viewAllWarrantyNumber,
        image: AppImageKeys.warranty,
        page: WarrantyPage(),
      ),

    // ==========================================================
    // COMPANIES
    // ==========================================================

    if (hasPermission(permissions.companies))
      const PageNodeModel(
        name: LocaleKeys.companies,
        number: PagesOfAllApp.viewAllCompaniesNumber,
        image: AppImageKeys.company,
        page: CompaniesPage(),
      ),

    // ==========================================================
    // INSURANCE
    // ==========================================================

    if (hasPermission(permissions.insurance))
      const PageNodeModel(
        name: LocaleKeys.insurances,
        number: PagesOfAllApp.viewAllCompaniesInsuranceNumber,
        image: AppImageKeys.insurance,
        page: InsurancePage(),
      ),

    // ==========================================================
    // CARS HARAJ
    // ==========================================================

    if (hasPermission(permissions.harage))
      const PageNodeModel(
        name: LocaleKeys.carsHaraj,
        number: PagesOfAllApp.viewAllCarsHarajNumber,
        image: AppImageKeys.car,
        page: CarsHarajPage(),
      ),

    // ==========================================================
    // USERS
    // ==========================================================

    if (hasPermission(permissions.users))
      const PageNodeModel(
        name: LocaleKeys.users,
        number: PagesOfAllApp.viewAllUsersNumber,
        image: AppImageKeys.users,
        page: UsersPage(),
      ),

    if (hasPermission(permissions.carBrands))
      const PageNodeModel(
        name: LocaleKeys.carsBrands,
        number: PagesOfAllApp.carsBrandsNumber,
        image: AppImageKeys.wallet,
        page: CarsBrandsPage(),
      ),

    if (hasPermission(permissions.carApprovals))
      const PageNodeModel(
        name: LocaleKeys.carApprovals,
        number: PagesOfAllApp.carApprovalsNumber,
        image: AppImageKeys.car,
        page: CarApprovalPage(),
      ),

    // ==========================================================
    // FINANCES
    // ==========================================================

    if (hasPermission(permissions.finances))
      const PageNodeModel(
        name: LocaleKeys.finances,
        number: PagesOfAllApp.viewAllAccountManagementNumber,
        image: AppImageKeys.wallet,
        page: AccountsManagementPage(),
      ),

    // ==========================================================
    // BANNERS
    // ==========================================================

    if (hasPermission(permissions.banners))
      const PageNodeModel(
        name: LocaleKeys.banners,
        image: AppImageKeys.banner,
        number: PagesOfAllApp.bannerViewPageNumber,
        page: AdvertisementsPage(),
      ),

    // ==========================================================
    // RANKS
    // ==========================================================

    if (hasPermission(permissions.ranks))
      const PageNodeModel(
        name: LocaleKeys.reviews,
        image: AppImageKeys.rank,
        number: PagesOfAllApp.ratePageNumber,
        page: RatesPage(),
      ),

    // ==========================================================
    // TECHNICAL SUPPORT
    // ==========================================================

    if (hasPermission(permissions.support))
      const PageNodeModel(
        name: LocaleKeys.technicalSupport,
        image: AppImageKeys.support,
        number: PagesOfAllApp.technicalSupportPageNumber,
        page: TechnicalSupportPage(),
      ),

    // ==========================================================
    // DELIVERY SETTINGS
    // ==========================================================

    if (hasPermission(permissions.deliverySetting))
      const PageNodeModel(
        name: LocaleKeys.deliverySettings,
        image: AppImageKeys.order,
        number: PagesOfAllApp.deliverySettingsPageNumber,
        page: DeliverySettingPage(),
      ),

    // ==========================================================
    // SOCIAL PAGES
    // ==========================================================

    if (hasPermission(permissions.policies))
      const PageNodeModel(
        name: LocaleKeys.socialPagesAndPoliciesKey,
        image: AppImageKeys.pages,
        number: PagesOfAllApp.pagesPageNumber,
        page: CommunicationAndPoliciesPage(),
      ),

    // ==========================================================
    // LOGOUT - NO PERMISSION
    // ==========================================================

    const PageNodeModel(
      name: LocaleKeys.logoutKey,
      image: AppImageKeys.logout,
      number: PagesOfAllApp.logoutPageNumber,
      page: LogoutPage(),
    ),
  ];
}

List<PageNodeModel> _getAllPages() {
  return const [
    PageNodeModel(
      name: LocaleKeys.statistics,
      image: AppImageKeys.home,
      number: PagesOfAllApp.dashboardPageNumber,
      page: StatisticsPage(),
    ),
    PageNodeModel(
      name: LocaleKeys.orders,
      number: PagesOfAllApp.dashboardOrderPageNumber,
      image: AppImageKeys.order,
      page: OrdersPage(),
    ),
    PageNodeModel(
      name: LocaleKeys.myAccount,
      image: AppImageKeys.users,
      number: PagesOfAllApp.securityPageNumber,
      page: FacilityAccountPage(),
    ),
    PageNodeModel(
      name: LocaleKeys.admins,
      image: AppImageKeys.admin,
      number: PagesOfAllApp.viewAllAdminsNumber,
      page: AdminsPage(),
    ),
    PageNodeModel(
      name: LocaleKeys.packages,
      image: AppImageKeys.packages,
      number: PagesOfAllApp.viewAllPackagesNumber,
      page: PackagesPage(),
    ),
    PageNodeModel(
      name: LocaleKeys.coupon,
      image: AppImageKeys.coupon,
      number: PagesOfAllApp.viewAllCouponNumber,
      page: CouponsPage(),
    ),
    PageNodeModel(
      name: LocaleKeys.providers,
      number: PagesOfAllApp.viewAllProvidersNumber,
      image: AppImageKeys.provider,
      page: ProvidersPage(),
    ),
    PageNodeModel(
      name: LocaleKeys.approvedCenters,
      number: PagesOfAllApp.viewAllApprovedCentersNumber,
      image: AppImageKeys.approved,
      page: ApprovedCentersPage(),
    ),
    PageNodeModel(
      name: LocaleKeys.warranty,
      number: PagesOfAllApp.viewAllWarrantyNumber,
      image: AppImageKeys.warranty,
      page: WarrantyPage(),
    ),
    PageNodeModel(
      name: LocaleKeys.companies,
      number: PagesOfAllApp.viewAllCompaniesNumber,
      image: AppImageKeys.company,
      page: CompaniesPage(),
    ),
    PageNodeModel(
      name: LocaleKeys.insurances,
      number: PagesOfAllApp.viewAllCompaniesInsuranceNumber,
      image: AppImageKeys.insurance,
      page: InsurancePage(),
    ),
    PageNodeModel(
      name: LocaleKeys.carsHaraj,
      number: PagesOfAllApp.viewAllCarsHarajNumber,
      image: AppImageKeys.car,
      page: CarsHarajPage(),
    ),
    PageNodeModel(
      name: LocaleKeys.users,
      number: PagesOfAllApp.viewAllUsersNumber,
      image: AppImageKeys.users,
      page: UsersPage(),
    ),
    PageNodeModel(
      name: LocaleKeys.carsBrands,
      number: PagesOfAllApp.carsBrandsNumber,
      image: AppImageKeys.wallet,
      page: CarsBrandsPage(),
    ),
    PageNodeModel(
      name: LocaleKeys.carApprovals,
      number: PagesOfAllApp.carApprovalsNumber,
      image: AppImageKeys.car,
      page: CarApprovalPage(),
    ),
    PageNodeModel(
      name: LocaleKeys.finances,
      number: PagesOfAllApp.viewAllAccountManagementNumber,
      image: AppImageKeys.wallet,
      page: AccountsManagementPage(),
    ),
    PageNodeModel(
      name: LocaleKeys.banners,
      image: AppImageKeys.banner,
      number: PagesOfAllApp.bannerViewPageNumber,
      page: AdvertisementsPage(),
    ),
    PageNodeModel(
      name: LocaleKeys.reviews,
      image: AppImageKeys.rank,
      number: PagesOfAllApp.ratePageNumber,
      page: RatesPage(),
    ),
    PageNodeModel(
      name: LocaleKeys.technicalSupport,
      image: AppImageKeys.support,
      number: PagesOfAllApp.technicalSupportPageNumber,
      page: TechnicalSupportPage(),
    ),
    PageNodeModel(
      name: LocaleKeys.deliverySettings,
      image: AppImageKeys.order,
      number: PagesOfAllApp.deliverySettingsPageNumber,
      page: DeliverySettingPage(),
    ),
    PageNodeModel(
      name: LocaleKeys.socialPagesAndPoliciesKey,
      image: AppImageKeys.pages,
      number: PagesOfAllApp.pagesPageNumber,
      page: CommunicationAndPoliciesPage(),
    ),
    PageNodeModel(
      name: LocaleKeys.logoutKey,
      image: AppImageKeys.logout,
      number: PagesOfAllApp.logoutPageNumber,
      page: LogoutPage(),
    ),
  ];
}