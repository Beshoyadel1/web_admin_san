import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:web_admin_san/feature/companies_page/presentation/pages/page_details_companies/page_details_companies.dart';
import 'package:web_admin_san/feature/companies_page/presentation/pages/page_details_companies/screens/content_companies/content_companies.dart';
import 'package:web_admin_san/feature/companies_page/presentation/pages/page_details_companies/screens/tabs_widget_details_companies.dart';
import 'package:web_admin_san/feature/providers_page/data/model/facility_provider_model/facility_model_provider/facility_model_provider.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';

void main() {
  group('Company Details Architecture & LazyIndexedStack Verification', () {
    test('companyTabTitles contains exact 5 required tabs', () {
      expect(companyTabTitles.length, 5);
      expect(companyTabTitles[0], LocaleKeys.statistics);
      expect(companyTabTitles[1], LocaleKeys.facilityDataKey);
      expect(companyTabTitles[2], LocaleKeys.allOrders);
      expect(companyTabTitles[3], LocaleKeys.cars);
      expect(companyTabTitles[4], LocaleKeys.drivers);
    });

    testWidgets(
        'buildCompanyTabContent builds correct widget types for all indices',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final tab0 = buildCompanyTabContent(context, 0, 100);
              final tab1 = buildCompanyTabContent(context, 1, 100);
              final tab2 = buildCompanyTabContent(context, 2, 100);
              final tab3 = buildCompanyTabContent(context, 3, 100);
              final tab4 = buildCompanyTabContent(context, 4, 100);
              final tabInvalid = buildCompanyTabContent(context, 99, 100);

              expect(tab0.runtimeType.toString(), 'CompanyStatistics');
              expect(tab1.runtimeType.toString(), 'ContentCompanies');
              expect(tab2.runtimeType.toString(), 'OrderCompanies');
              expect(tab3.runtimeType.toString(), contains('BlocProvider'));
              expect(tab4.runtimeType.toString(), contains('BlocProvider'));
              expect(tabInvalid.runtimeType.toString(), 'SizedBox');

              return const SizedBox();
            },
          ),
        ),
      );
    });

    test(
        'PageDetailsCompanies, TabsWidgetDetailsCompanies, and ContentCompanies are pure StatelessWidgets',
        () {
      const page = PageDetailsCompanies(companyId: 100);
      const tabs = TabsWidgetDetailsCompanies(companyId: 100);
      const content = ContentCompanies(company: 100);

      expect(page, isA<StatelessWidget>());
      expect(tabs, isA<StatelessWidget>());
      expect(content, isA<StatelessWidget>());
    });
  });
}
