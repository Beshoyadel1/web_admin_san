import 'package:flutter_test/flutter_test.dart';
import 'package:web_admin_san/core/helpers/utils/chart_date_localizer.dart';
import 'package:web_admin_san/feature/orders_page/data/model/orders_filter_criteria.dart';
import 'package:web_admin_san/feature/orders_page/data/request/get_orders_request/get_orders_request.dart';
import 'package:web_admin_san/feature/admins_page/data/request/get_all_admins_request/get_all_admins_request.dart';
import 'package:web_admin_san/feature/cars_haraj_page/data/request/get_all_harages_request/get_all_harages_request.dart';
import 'package:web_admin_san/feature/statistics_page/data/model/get_admin_dashboard_statistics_model/get_admin_dashboard_statistics_model.dart';
import 'package:web_admin_san/feature/statistics_page/data/model/sales_commission_model.dart';
import 'package:web_admin_san/feature/statistics_page/data/model/most_requested_service_model.dart';
import 'package:web_admin_san/feature/companies_page/data/model/car_group_model/car_group_model.dart';
import 'package:web_admin_san/feature/cars_haraj_page/data/model/get_car_details_model/get_car_details_model.dart';
import 'package:web_admin_san/feature/users_page/data/model/users_filter_criteria.dart';
import 'package:web_admin_san/feature/users_page/data/request/get_all_user_request/get_all_user_request.dart';
import 'package:web_admin_san/feature/providers_page/data/model/providers_filter_criteria.dart';
import 'package:web_admin_san/feature/providers_page/data/request/get_all_providers_request/get_all_providers_request.dart';
import 'package:web_admin_san/feature/companies_page/data/model/companies_filter_criteria.dart';
import 'package:web_admin_san/feature/companies_page/data/request/get_all_companies_request/get_all_companies_request.dart';
import 'package:web_admin_san/feature/cars_haraj_page/data/model/haraj_filter_criteria.dart';
import 'package:web_admin_san/feature/coupons_page/data/model/coupons_filter_criteria.dart';
import 'package:web_admin_san/feature/packages_page/data/model/packages_filter_criteria.dart';
import 'package:web_admin_san/feature/admins_page/data/model/admins_filter_criteria.dart';
import 'package:web_admin_san/feature/approved_centers_page/data/model/approved_centers_filter_criteria.dart';
import 'package:web_admin_san/feature/approved_centers_page/data/request/get_approved_providers_request/get_approved_providers_request.dart';

void main() {
  group('Statistics Dashboard Models Tests', () {
    test(
        'DashboardData parses correctly with totalCarInsurances and recentOrders',
        () {
      final json = {
        'summary': {
          'totalOrders': 500,
          'totalCustomers': 1000,
          'totalCompanies': 50,
          'totalServiceProviders': 120,
          'totalOrderSales': 40000.0,
          'totalCarInsurances': 250,
        },
        'monthlySalesComparison': {
          'currentYearSales': [
            {'label': 'Mar', 'value': 2500},
            {'label': 'Apr', 'value': 3200},
          ],
          'lastYearSales': [
            {'label': 'Mar', 'value': 2000},
            {'label': 'Apr', 'value': 2800},
          ],
        },
        'maintenanceStats': {
          'userCarsCount': 300,
          'companyCarsCount': 100,
        },
        'recentOrders': [
          {
            'id': 1,
            'centerName': 'مركز صان الرياض',
            'centerImage': null,
            'serviceCategory': 'خدمات داخلية',
            'serviceName': 'صيانة وإصلاح',
            'customerName': 'أحمد محمود',
            'customerImage': null,
            'status': 3,
            'statusName': 'تحت الخدمة',
            'orderDate': '2025-01-01T10:00:00',
            'servicePrice': 250.0,
          }
        ],
      };

      final dashboard = DashboardData.fromJson(json);

      expect(dashboard.summary.totalOrders, equals(500));
      expect(dashboard.summary.totalCustomers, equals(1000));
      expect(dashboard.summary.totalCompanies, equals(50));
      expect(dashboard.summary.totalServiceProviders, equals(120));
      expect(dashboard.summary.totalOrderSales, equals(40000.0));
      expect(dashboard.summary.totalCarInsurances, equals(250));

      expect(
          dashboard.monthlySalesComparison.currentYearSales.length, equals(2));
      expect(dashboard.monthlySalesComparison.lastYearSales.length, equals(2));
      expect(dashboard.maintenanceStats.userCarsCount, equals(300));
      expect(dashboard.maintenanceStats.companyCarsCount, equals(100));

      expect(dashboard.recentOrders.length, equals(1));
      final recent = dashboard.recentOrders.first;
      expect(recent.id, equals(1));
      expect(recent.centerName, equals('مركز صان الرياض'));
      expect(recent.customerName, equals('أحمد محمود'));
      expect(recent.servicePrice, equals(250.0));
      expect(recent.statusName, equals('تحت الخدمة'));
    });

    test('AdminSalesAndCommissionModel parses correctly', () {
      final json = {
        'totalSales': 450.0,
        'totalCommission': 45.0,
        'chartPoints': [
          {'label': 'SEP', 'sales': 300.0, 'commission': 30.0},
          {'label': 'OCT', 'sales': 320.0, 'commission': 32.0},
          {'label': 'NOV', 'sales': 450.0, 'commission': 45.0},
        ],
      };

      final model = AdminSalesAndCommissionModel.fromJson(json);
      expect(model.totalSales, equals(450.0));
      expect(model.totalCommission, equals(45.0));
      expect(model.chartPoints.length, equals(3));
      expect(model.chartPoints[2].label, equals('NOV'));
      expect(model.chartPoints[2].sales, equals(450.0));
      expect(model.chartPoints[2].commission, equals(45.0));
    });

    test('MostRequestedServiceModel parses correctly', () {
      final json = {
        'serviceName': 'صيانة وإصلاح',
        'serviceLatinName': 'Maintenance',
        'value': 2500,
        'percentage': 20.0,
      };

      final model = MostRequestedServiceModel.fromJson(json);
      expect(model.serviceName, equals('صيانة وإصلاح'));
      expect(model.percentage, equals(20.0));
    });
  });

  group('Universal Search & Filter Requests Tests', () {
    test('GetOrdersRequest serializes search and dates properly', () {
      final date = DateTime(2025, 5, 1);
      final req = GetOrdersRequest(
        pageNumber: 2,
        orderType: 1,
        search: 'Ahmed',
        startDate: date,
        endDate: date,
      );

      final json = req.toJson();
      expect(json['pageNumber'], equals(2));
      expect(json['orderType'], equals(1));
      expect(json['search'], equals('Ahmed'));
      expect(json['startDate'], equals(date.toIso8601String()));
      expect(json['endDate'], equals(date.toIso8601String()));
    });

    test('GetAllAdminsRequest serializes searchTerm properly', () {
      const req = GetAllAdminsRequest(
        pageNumber: 1,
        searchTerm: 'superadmin',
      );

      final json = req.toJson();
      expect(json['pageNumber'], equals(1));
      expect(json['searchTerm'], equals('superadmin'));
    });

    test('GetAllHaragesRequest serializes search query properly', () {
      final req = GetAllHaragesRequest(
        pageNumber: 1,
        isNew: true,
        status: 1,
        search: 'Toyota',
      );

      final json = req.toJson();
      expect(json['pageNumber'], equals(1));
      expect(json['isNew'], equals(true));
      expect(json['status'], equals(1));
      expect(json['search'], equals('Toyota'));
    });
  });

  group('CarInfo and CarInfoModel Updates Tests', () {
    test(
        'CarInfo parses approvalStatus, rejectionReason, hasPendingUpdate, and driver',
        () {
      final json = {
        'id': 105,
        'releasedate': 2023,
        'plateno': '1234 ABC',
        'chassisno': 'CHS987654321',
        'insuranceno': 'INS-555',
        'name': 'كامري 2023',
        'approvalstatus': 3,
        'rejectionreason': 'صورة الاستمارة غير واضحة',
        'isactive': true,
        'haspendingupdate': true,
        'driver': {
          'id': 42,
          'name': 'محمد خالد',
        },
      };

      final car = CarInfo.fromJson(json);

      expect(car.id, equals(105));
      expect(car.plateNo, equals('1234 ABC'));
      expect(car.approvalStatus, equals(3));
      expect(car.rejectionReason, equals('صورة الاستمارة غير واضحة'));
      expect(car.isActive, equals(true));
      expect(car.hasPendingUpdate, equals(true));
      expect(car.isApproved, equals(false));
      expect(car.isPending, equals(false));
      expect(car.isRejected, equals(true));

      expect(car.driver, isNotNull);
      expect(car.driver!.id, equals(42));
      expect(car.driver!.name, equals('محمد خالد'));
    });

    test(
        'CarInfoModel parses approvalStatus and hasPendingUpdate in haraj/approval',
        () {
      final json = {
        'id': 202,
        'plateno': '5678 XYZ',
        'approvalstatus': 1,
        'isactive': true,
        'haspendingupdate': false,
      };

      final car = CarInfoModel.fromJson(json);

      expect(car.id, equals(202));
      expect(car.plateNo, equals('5678 XYZ'));
      expect(car.approvalStatus, equals(1));
      expect(car.isActive, equals(true));
      expect(car.hasPendingUpdate, equals(false));
      expect(car.isPending, equals(true));
      expect(car.isApproved, equals(false));
      expect(car.isRejected, equals(false));
    });

    test(
        'Models parse PascalCase backend responses and dynamic LinkedMap safely',
        () {
      final dynamic pascalJson = <dynamic, dynamic>{
        'TotalSales': 690.0,
        'TotalCommission': 69.0,
        'ChartPoints': [
          <dynamic, dynamic>{'Label': 'Oct', 'Sales': 690.0, 'Commission': 69.0}
        ],
      };

      final safeMap = Map<String, dynamic>.from(pascalJson as Map);
      final model = AdminSalesAndCommissionModel.fromJson(safeMap);

      expect(model.totalSales, equals(690.0));
      expect(model.totalCommission, equals(69.0));
      expect(model.chartPoints.length, equals(1));
      expect(model.chartPoints.first.label, equals('Oct'));

      final dynamic pascalService = <dynamic, dynamic>{
        'ServiceName': 'صيانة وإصلاح',
        'ServiceLatinName': 'Maintenance',
        'Value': 690.0,
        'Percentage': 100.0,
      };

      final serviceModel = MostRequestedServiceModel.fromJson(
          Map<String, dynamic>.from(pascalService as Map));
      expect(serviceModel.serviceName, equals('صيانة وإصلاح'));
      expect(serviceModel.percentage, equals(100.0));
    });
  });

  group('Chart Date Localization & Spline Calculations Tests', () {
    test('ChartDateLocalizer translates English month abbreviations to Arabic',
        () {
      expect(ChartDateLocalizer.localizeForLanguage('SEP', 'ar'),
          equals('سبتمبر'));
      expect(ChartDateLocalizer.localizeForLanguage('OCT', 'ar'),
          equals('أكتوبر'));
      expect(ChartDateLocalizer.localizeForLanguage('NOV', 'ar'),
          equals('نوفمبر'));
      expect(ChartDateLocalizer.localizeForLanguage('DEC', 'ar'),
          equals('ديسمبر'));
      expect(
          ChartDateLocalizer.localizeForLanguage('JAN', 'ar'), equals('يناير'));
      expect(ChartDateLocalizer.localizeForLanguage('FEB', 'ar'),
          equals('فبراير'));
    });

    test('ChartDateLocalizer translates composite date strings with days', () {
      expect(ChartDateLocalizer.localizeForLanguage('15 Oct', 'ar'),
          equals('15 أكتوبر'));
      expect(ChartDateLocalizer.localizeForLanguage('01 Jan', 'ar'),
          equals('01 يناير'));
    });

    test(
        'ChartDateLocalizer preserves original string when language is English',
        () {
      expect(
          ChartDateLocalizer.localizeForLanguage('OCT', 'en'), equals('OCT'));
      expect(ChartDateLocalizer.localizeForLanguage('15 Oct', 'en'),
          equals('15 Oct'));
    });

    test(
        'Dynamic calculation of totalSales and totalCommission matches points sum',
        () {
      final points = [
        SalesCommissionPoint(label: 'SEP', sales: 300, commission: 30),
        SalesCommissionPoint(label: 'OCT', sales: 320, commission: 20),
        SalesCommissionPoint(label: 'NOV', sales: 450, commission: 45),
        SalesCommissionPoint(label: 'DEC', sales: 250, commission: 25),
        SalesCommissionPoint(label: 'JAN', sales: 380, commission: 38),
        SalesCommissionPoint(label: 'FEB', sales: 350, commission: 35),
      ];

      final totalSales =
          points.fold<double>(0.0, (sum, pt) => sum + pt.sales.toDouble());
      final totalCommission =
          points.fold<double>(0.0, (sum, pt) => sum + pt.commission.toDouble());

      expect(totalSales, equals(2050.0));
      expect(totalCommission, equals(193.0));
    });
  });

  group('OrdersFilterCriteria & GetOrdersRequest Advanced Filter Tests', () {
    test('OrdersFilterCriteria empty defaults and counts', () {
      const criteria = OrdersFilterCriteria.empty;
      expect(criteria.isEmpty, isTrue);
      expect(criteria.isNotEmpty, isFalse);
      expect(criteria.activeFiltersCount, equals(0));
      expect(criteria.orderType, isNull);
      expect(criteria.userType, isNull);
      expect(criteria.startDate, isNull);
      expect(criteria.endDate, isNull);
      expect(criteria.datePreset, isNull);
    });

    test('OrdersFilterCriteria activeFiltersCount counts active facets', () {
      final now = DateTime.now();
      final c1 = OrdersFilterCriteria(orderType: 1);
      expect(c1.activeFiltersCount, equals(1));
      expect(c1.isNotEmpty, isTrue);

      final c2 = c1.copyWith(userType: 2);
      expect(c2.activeFiltersCount, equals(2));

      final c3 = c2.copyWith(startDate: now, endDate: now);
      expect(c3.activeFiltersCount, equals(3));
    });

    test('OrdersFilterCriteria copyWith and clearing individual filters', () {
      final now = DateTime.now();
      final initial = OrdersFilterCriteria(
        orderType: 2,
        userType: 1,
        startDate: now,
        endDate: now,
        datePreset: 'today',
      );
      expect(initial.activeFiltersCount, equals(3));

      // Clear orderType
      final clearedStatus = initial.copyWith(clearOrderType: true);
      expect(clearedStatus.orderType, isNull);
      expect(clearedStatus.userType, equals(1));
      expect(clearedStatus.activeFiltersCount, equals(2));

      // Clear userType
      final clearedUser = initial.copyWith(clearUserType: true);
      expect(clearedUser.userType, isNull);
      expect(clearedUser.orderType, equals(2));
      expect(clearedUser.activeFiltersCount, equals(2));

      // Clear dates
      final clearedDates = initial.copyWith(
        clearStartDate: true,
        clearEndDate: true,
        clearDatePreset: true,
      );
      expect(clearedDates.startDate, isNull);
      expect(clearedDates.endDate, isNull);
      expect(clearedDates.datePreset, isNull);
      expect(clearedDates.activeFiltersCount, equals(2));
    });

    test('GetOrdersRequest serializes userType correctly in toJson', () {
      final requestWithUserType = GetOrdersRequest(
        pageNumber: 1,
        orderType: 1,
        userType: 2,
        search: '1024',
      );
      final json = requestWithUserType.toJson();
      expect(json['pageNumber'], equals(1));
      expect(json['orderType'], equals(1));
      expect(json['userType'], equals(2));
      expect(json['search'], equals('1024'));

      final requestWithoutUserType = GetOrdersRequest(
        pageNumber: 1,
      );
      final jsonNull = requestWithoutUserType.toJson();
      expect(jsonNull.containsKey('userType'), isFalse);
    });
  });

  group('All 8 Entity Advanced Filter Criteria & Serialization Tests', () {
    test('UsersFilterCriteria & GetAllUserRequest test', () {
      final now = DateTime(2025, 6, 1);
      final criteria = UsersFilterCriteria(
        isActive: true,
        startDate: now,
        endDate: now,
        datePreset: 'today',
      );
      expect(criteria.activeFiltersCount, equals(2));
      expect(criteria.isNotEmpty, isTrue);

      final req = GetAllUserRequest(
        pageNumber: 2,
        searchTerm: 'Ali',
        isActive: criteria.isActive,
        startDate: criteria.startDate,
        endDate: criteria.endDate,
      );
      final json = req.toJson();
      expect(json['pageNumber'], equals(2));
      expect(json['searchTerm'], equals('Ali'));
      expect(json['isActive'], isTrue);
      expect(json['startDate'], equals(now.toIso8601String()));
      expect(json['endDate'], equals(now.toIso8601String()));
    });

    test('ProvidersFilterCriteria & GetAllProvidersRequest test', () {
      final now = DateTime(2025, 7, 1);
      final criteria = ProvidersFilterCriteria(
        isActive: false,
        startDate: now,
        endDate: now,
      );
      expect(criteria.activeFiltersCount, equals(2));

      final req = GetAllProvidersRequest(
        pageNumber: 1,
        searchTerm: 'Center A',
        isActive: criteria.isActive,
        startDate: criteria.startDate,
        endDate: criteria.endDate,
      );
      final json = req.toJson();
      expect(json['searchTerm'], equals('Center A'));
      expect(json['isActive'], isFalse);
      expect(json['startDate'], equals(now.toIso8601String()));
    });

    test('CompaniesFilterCriteria & GetAllCompaniesRequest test', () {
      final criteria = const CompaniesFilterCriteria(isActive: true);
      expect(criteria.activeFiltersCount, equals(1));

      final req = GetAllCompaniesRequest(
        pageNumber: 1,
        searchTerm: 'Aramco',
        isActive: true,
      );
      final json = req.toJson();
      expect(json['searchTerm'], equals('Aramco'));
      expect(json['isActive'], isTrue);
    });

    test('HarajFilterCriteria & GetAllHaragesRequest test', () {
      final criteria = const HarajFilterCriteria(
        isNew: true,
        status: 1,
        minPrice: 50000,
        maxPrice: 120000,
      );
      expect(criteria.activeFiltersCount, equals(3));

      final req = GetAllHaragesRequest(
        pageNumber: 1,
        isNew: criteria.isNew,
        status: criteria.status,
        minPrice: criteria.minPrice,
        maxPrice: criteria.maxPrice,
      );
      final json = req.toJson();
      expect(json['isNew'], isTrue);
      expect(json['status'], equals(1));
      expect(json['minPrice'], equals(50000.0));
      expect(json['maxPrice'], equals(120000.0));
    });

    test('CouponsFilterCriteria test', () {
      final now = DateTime(2025, 8, 1);
      final criteria = CouponsFilterCriteria(
        isActive: true,
        startDate: now,
        endDate: now,
        datePreset: 'thisMonth',
      );
      expect(criteria.activeFiltersCount, equals(2));
      expect(criteria.isNotEmpty, isTrue);

      final cleared = criteria.copyWith(clearIsActive: true);
      expect(cleared.isActive, isNull);
      expect(cleared.activeFiltersCount, equals(1));
    });

    test('PackagesFilterCriteria test', () {
      final criteria = const PackagesFilterCriteria(
        billingType: 'annual',
        minPrice: 100,
        maxPrice: 1000,
      );
      expect(criteria.activeFiltersCount, equals(2));
      expect(criteria.isNotEmpty, isTrue);

      final cleared = criteria.copyWith(clearBillingType: true);
      expect(cleared.billingType, isNull);
      expect(cleared.activeFiltersCount, equals(1));
    });

    test('AdminsFilterCriteria & GetAllAdminsRequest test', () {
      final now = DateTime(2025, 9, 1);
      final criteria = AdminsFilterCriteria(
        isActive: true,
        startDate: now,
      );
      expect(criteria.activeFiltersCount, equals(2));

      final req = GetAllAdminsRequest(
        pageNumber: 1,
        searchTerm: 'SuperAdmin',
        isActive: criteria.isActive,
        startDate: criteria.startDate,
      );
      final json = req.toJson();
      expect(json['searchTerm'], equals('SuperAdmin'));
      expect(json['isActive'], isTrue);
      expect(json['startDate'], equals(now.toIso8601String()));
    });

    test('ApprovedCentersFilterCriteria & GetApprovedProvidersRequest test',
        () {
      final criteria = const ApprovedCentersFilterCriteria(isActive: true);
      expect(criteria.activeFiltersCount, equals(1));

      final req = const GetApprovedProvidersRequest(
        pageNumber: 1,
        searchTerm: 'Approved Center 1',
        isActive: true,
      );
      final json = req.toJson();
      expect(json['searchTerm'], equals('Approved Center 1'));
      expect(json['isActive'], isTrue);
    });
  });
}
