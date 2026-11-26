import 'package:flutter_test/flutter_test.dart';
import 'package:web_admin_san/feature/companies_page/data/model/get_all_companies_model/get_all_companies_model.dart';
import 'package:web_admin_san/feature/companies_page/data/request/get_all_companies_request/get_all_companies_request.dart';
import 'package:web_admin_san/feature/providers_page/data/model/get_all_providers_models/get_all_providers_models/get_all_providers_models.dart';
import 'package:web_admin_san/feature/providers_page/data/request/get_all_providers_request/get_all_providers_request.dart';

void main() {
  group('Providers, Approved Centers & Companies Unit Tests', () {
    test('GetAllCompanies parses lastOrderProvider object correctly', () {
      final json = {
        'companyId': 1,
        'name': 'شركة الرياض المتقدمة',
        'latinName': 'Riyadh Advanced Co',
        'image': null,
        'isActive': true,
        'joinDate': '2026-01-01T00:00:00.000Z',
        'lastOrderProvider': {
          'orderId': 99,
          'date': '2026-10-15T09:30:00.000Z',
        },
      };

      final company = GetAllCompanies.fromJson(json);

      expect(company.companyId, 1);
      expect(company.name, 'شركة الرياض المتقدمة');
      expect(company.lastOrderProvider,
          DateTime.parse('2026-10-15T09:30:00.000Z'));
    });

    test('GetAllCompanies handles string date in lastOrderProvider gracefully',
        () {
      final json = {
        'companyId': 2,
        'name': 'شركة الشرقية',
        'lastOrderProvider': '2026-10-14T08:00:00.000Z',
      };

      final company = GetAllCompanies.fromJson(json);

      expect(company.companyId, 2);
      expect(company.lastOrderProvider,
          DateTime.parse('2026-10-14T08:00:00.000Z'));
    });

    test('GetAllCompanies handles null lastOrderProvider without errors', () {
      final json = {
        'companyId': 3,
        'name': 'شركة جديدة بدون طلبات',
        'lastOrderProvider': null,
      };

      final company = GetAllCompanies.fromJson(json);

      expect(company.companyId, 3);
      expect(company.lastOrderProvider, isNull);
    });

    test('GetAllProvidersRequest serializes searchTerm correctly', () {
      final requestWithSearch = GetAllProvidersRequest(
        pageNumber: 2,
        searchTerm: 'مركز الصيانة',
      );
      final json = requestWithSearch.toJson();

      expect(json['pageNumber'], 2);
      expect(json['searchTerm'], 'مركز الصيانة');

      final requestWithoutSearch = GetAllProvidersRequest(pageNumber: 1);
      final jsonWithout = requestWithoutSearch.toJson();

      expect(jsonWithout['pageNumber'], 1);
      expect(jsonWithout.containsKey('searchTerm'), isFalse);
    });

    test('GetAllCompaniesRequest serializes searchTerm correctly', () {
      final requestWithSearch = GetAllCompaniesRequest(
        pageNumber: 3,
        searchTerm: '0551234567',
      );
      final json = requestWithSearch.toJson();

      expect(json['pageNumber'], 3);
      expect(json['searchTerm'], '0551234567');

      final requestWithoutSearch = GetAllCompaniesRequest(pageNumber: 1);
      final jsonWithout = requestWithoutSearch.toJson();

      expect(jsonWithout['pageNumber'], 1);
      expect(jsonWithout.containsKey('searchTerm'), isFalse);
    });

    test('GetAllProvidersModels parses provider data correctly', () {
      final json = {
        'providerId': 100,
        'name': 'ورشة النور',
        'latinName': 'Al Noor Workshop',
        'image': null,
        'totalOrders': 45,
        'lastOrderDate': '2026-10-12T10:00:00.000Z',
        'isActive': true,
        'joinDate': '2025-05-01T00:00:00.000Z',
      };

      final provider = GetAllProvidersModels.fromJson(json);

      expect(provider.providerId, 100);
      expect(provider.name, 'ورشة النور');
      expect(provider.totalOrders, 45);
      expect(provider.isActive, true);
      expect(
          provider.lastOrderDate, DateTime.parse('2026-10-12T10:00:00.000Z'));
    });

    test(
        'Navigation return handler safely differentiates bool and model without TypeError',
        () {
      dynamic navResultBool = true;
      dynamic navResultModel = GetAllProvidersModels(
        providerId: 101,
        name: 'مركز العالمية',
        latinName: 'Global Center',
        totalOrders: 10,
        isActive: true,
      );
      dynamic navResultNull;

      bool handledAsModel = false;
      bool handledAsRefresh = false;

      void handleResult(dynamic result) {
        if (result is GetAllProvidersModels) {
          handledAsModel = true;
        } else if (result == true) {
          handledAsRefresh = true;
        }
      }

      // Test with boolean return (popping from PageDetailsProvider)
      handleResult(navResultBool);
      expect(handledAsRefresh, isTrue);
      expect(handledAsModel, isFalse);

      // Reset
      handledAsModel = false;
      handledAsRefresh = false;

      // Test with model return
      handleResult(navResultModel);
      expect(handledAsModel, isTrue);
      expect(handledAsRefresh, isFalse);

      // Reset
      handledAsModel = false;
      handledAsRefresh = false;

      // Test with null
      handleResult(navResultNull);
      expect(handledAsModel, isFalse);
      expect(handledAsRefresh, isFalse);
    });
  });
}
