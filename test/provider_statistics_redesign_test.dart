import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:web_admin_san/feature/auth_page/view_model/get_user_info_cubit/get_user_info_cubit.dart';
import 'package:web_admin_san/feature/providers_page/presentation/pages/page_details_provider/screens/provider_details_header.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import 'package:web_admin_san/feature/providers_page/presentation/pages/page_details_provider/screens/statistics_providers/widgets/provider_top_row_cards_grid.dart';
import 'package:web_admin_san/feature/statistics_page/data/model/get_provider_service_statistics_model/provider_statistics_model.dart';
import 'package:web_admin_san/feature/statistics_page/data/model/get_provider_service_statistics_model/summary_card.dart';
import 'package:web_admin_san/feature/statistics_page/data/model/get_provider_orders_sales_model/get_provider_orders_sales_model.dart';
import 'package:web_admin_san/feature/statistics_page/data/model/get_provider_total_rate_and_employee_and_balance_model/get_provider_total_rate_and_employee_and_balance_model.dart';
import 'package:web_admin_san/feature/statistics_page/data/request/get_provider_orders_sales_request/get_provider_orders_sales_request.dart';
import 'package:web_admin_san/feature/statistics_page/data/request/get_provider_service_statistics_request/get_provider_service_statistics_request.dart';

void main() {
  group('Provider Statistics Requests Tests', () {
    test('GetProviderOrdersSalesRequest serializes startDate and endDate', () {
      final start = DateTime(2026, 1, 15);
      final end = DateTime(2026, 2, 20);
      final request = GetProviderOrdersSalesRequest(
        providerId: 655466,
        startDate: start,
        endDate: end,
      );

      final json = request.toJson();
      expect(json['providerId'], 655466);
      expect(json['startDate'], start.toIso8601String());
      expect(json['endDate'], end.toIso8601String());
    });

    test('GetProviderServiceStatisticsRequest serializes dates correctly', () {
      final start = DateTime(2026, 3, 1);
      final request = GetProviderServiceStatisticsRequest(
        providerId: 101,
        startDate: start,
      );

      final json = request.toJson();
      expect(json['providerId'], 101);
      expect(json['startDate'], start.toIso8601String());
      expect(json.containsKey('endDate'), isFalse);
    });
  });

  group('Provider Statistics Models Tests', () {
    test(
        'ProviderStatisticsModel parses summary cards and chart items properly',
        () {
      final raw = {
        'data': {
          'summaryCards': [
            {
              'serviceName': 'صيانات وخدمات داخلية',
              'serviceLatinName': 'Internal Services',
              'orderCount': 120,
              'totalAmount': 450.0,
              'percentageChange': 3.0,
              'isIncrease': true,
            },
            {
              'serviceName': 'الخدمات المتنقلة والنقل',
              'orderCount': 80,
              'totalAmount': 320.0,
              'percentageChange': 5.0,
              'isIncrease': false,
            },
            {
              'serviceName': 'قطع غيار',
              'orderCount': 45,
              'totalAmount': 600.0,
              'percentageChange': 2.5,
              'isIncrease': true,
            },
            {
              'serviceName': 'غسيل وتلميع',
              'orderCount': 15,
              'totalAmount': 150.0,
              'percentageChange': 1.0,
              'isIncrease': true,
            },
          ],
          'chart': [
            {'serviceName': 'صيانات وخدمات داخلية', 'percentage': 46.15},
            {'serviceName': 'الخدمات المتنقلة والنقل', 'percentage': 30.77},
            {'serviceName': 'قطع غيار', 'percentage': 17.31},
            {'serviceName': 'غسيل وتلميع', 'percentage': 5.77},
          ]
        }
      };

      final model = ProviderStatisticsModel.fromJson(raw);
      expect(model.summaryCards.length, 4);
      expect(model.summaryCards[0].serviceName, 'صيانات وخدمات داخلية');
      expect(model.summaryCards[3].serviceName, 'غسيل وتلميع');
      expect(model.chart.length, 4);
      expect(model.chart[0].percentage, 46.15);
      expect(model.chart[3].serviceName, 'غسيل وتلميع');
    });

    test('GetProviderOrdersSalesModel parses data points properly', () {
      final raw = {
        'data': {
          'dataPoints': [
            {'label': '22 سبتمبر', 'value': 2000.0},
            {'label': '23 سبتمبر', 'value': 3500.0},
          ]
        }
      };

      final model = GetProviderOrdersSalesModel.fromJson(raw);
      expect(model.dataPoints.length, 2);
      expect(model.dataPoints.first.label, '22 سبتمبر');
      expect(model.dataPoints.first.value, 2000.0);
    });

    test(
        'GetProviderTotalRateAndEmployeeAndBalanceModel parses complete payload',
        () {
      final raw = {
        'data': {
          'averageRate': 5.0,
          'totalBalance': 450.0,
          'topEmployees': [
            {
              'employeeName': 'محمد عبد الله',
              'orderCount': 120,
              'jobName': 'فني صيانة',
            }
          ],
          'accountsBalance': [
            {
              'serviceName': 'الصيانة والاصلاح',
              'amount': 450.0,
              'recentOrderId': 10054,
            }
          ]
        }
      };

      final model =
          GetProviderTotalRateAndEmployeeAndBalanceModel.fromJson(raw);
      expect(model.averageRate, 5.0);
      expect(model.totalBalance, 450.0);
      expect(model.topEmployees.length, 1);
      expect(model.topEmployees.first.employeeName, 'محمد عبد الله');
      expect(model.topEmployees.first.orderCount, 120);
      expect(model.accountsBalance.length, 1);
      expect(model.accountsBalance.first.serviceName, 'الصيانة والاصلاح');
      expect(model.accountsBalance.first.recentOrderId, 10054);
    });
  });

  group('Provider Header and AppBar UI Tests', () {
    testWidgets(
        'ProviderDetailsHeader renders #providerId and default name initially',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BlocProvider<GetUserInfoCubit>(
              create: (_) => GetUserInfoCubit(),
              child: const ProviderDetailsHeader(
                providerID: 655466,
              ),
            ),
          ),
        ),
      );

      expect(find.text('#655466'), findsOneWidget);
      expect(find.text(LocaleKeys.serviceProviderName.tr()), findsOneWidget);
    });

    testWidgets('ProviderTopRowCardsGrid renders all 5 main services cards',
        (tester) async {
      final summaryCards = [
        SummaryCard(
          serviceName: 'صيانات وخدمات داخلية',
          orderCount: 2,
          totalAmount: 1207.5,
          percentageChange: 0.0,
          isIncrease: true,
        ),
        SummaryCard(
          serviceName: 'الخدمات المتنقلة والنقل',
          orderCount: 0,
          totalAmount: 0.0,
          percentageChange: 0.0,
          isIncrease: true,
        ),
        SummaryCard(
          serviceName: 'قطع غيار سيارات',
          orderCount: 0,
          totalAmount: 0.0,
          percentageChange: 0.0,
          isIncrease: true,
        ),
        SummaryCard(
          serviceName: 'باقات مشتركة',
          orderCount: 0,
          totalAmount: 0.0,
          percentageChange: 0.0,
          isIncrease: true,
        ),
        SummaryCard(
          serviceName: 'بترول',
          orderCount: 0,
          totalAmount: 0.0,
          percentageChange: 0.0,
          isIncrease: true,
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: ProviderTopRowCardsGrid(
                summaryCards: summaryCards,
              ),
            ),
          ),
        ),
      );

      expect(find.text('صيانات وخدمات داخلية'), findsOneWidget);
      expect(find.text('الخدمات المتنقلة والنقل'), findsOneWidget);
      expect(find.text('قطع غيار سيارات'), findsOneWidget);
      expect(find.text('باقات مشتركة'), findsOneWidget);
      expect(find.text('بترول'), findsOneWidget);
    });
  });
}
