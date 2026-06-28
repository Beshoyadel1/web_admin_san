import 'package:web_admin_san/features/company/data/model/get_company_general_statistics_model/get_company_general_statistics_model.dart';

abstract class GetCompanyGeneralStatisticsState {}

class GetCompanyGeneralStatisticsInitial
    extends GetCompanyGeneralStatisticsState {}

class GetCompanyGeneralStatisticsLoading
    extends GetCompanyGeneralStatisticsState {}

class GetCompanyGeneralStatisticsSuccess
    extends GetCompanyGeneralStatisticsState {
  final GetCompanyGeneralStatisticsModel data;

  GetCompanyGeneralStatisticsSuccess({
    required this.data,
  });
}

class GetCompanyGeneralStatisticsError
    extends GetCompanyGeneralStatisticsState {
  final String message;

  GetCompanyGeneralStatisticsError(this.message);
}