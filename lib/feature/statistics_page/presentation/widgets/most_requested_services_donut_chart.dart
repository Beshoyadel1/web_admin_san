import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/feature/statistics_page/data/model/most_requested_service_model.dart';
import 'package:web_admin_san/feature/statistics_page/presentation/widgets/statistics_date_picker_field.dart';
import 'package:web_admin_san/feature/statistics_page/view_model/most_requested_services_cubit/most_requested_services_cubit.dart';
import 'package:web_admin_san/feature/statistics_page/view_model/most_requested_services_cubit/most_requested_services_state.dart';

class MostRequestedServicesDonutChart extends StatelessWidget {
  const MostRequestedServicesDonutChart({super.key});

  static const List<Color> _palette = [
    AppColors.chartSlate,
    AppColors.chartLightBlue,
    AppColors.chartOrange,
    AppColors.chartGreen,
    AppColors.chartPeach,
    AppColors.chartYellow,
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MostRequestedServicesCubit, MostRequestedServicesState>(
      builder: (context, state) {
        final cubit = context.read<MostRequestedServicesCubit>();
        final startDate = state is MostRequestedServicesSuccess
            ? state.startDate
            : cubit.startDate;
        final endDate = state is MostRequestedServicesSuccess
            ? state.endDate
            : cubit.endDate;

        List<MostRequestedServiceModel> services = [];
        if (state is MostRequestedServicesSuccess &&
            state.services.isNotEmpty) {
          services = state.services;
        } else {
          // Mockup visual fallback if database has no service breakdown
          services = [
            MostRequestedServiceModel(
                serviceName: 'صيانة وإصلاح',
                serviceLatinName: 'Maintenance',
                value: 20,
                percentage: 20),
            MostRequestedServiceModel(
                serviceName: 'تغيير زيوت',
                serviceLatinName: 'Oil Change',
                value: 20,
                percentage: 20),
            MostRequestedServiceModel(
                serviceName: 'غسيل ونظافة',
                serviceLatinName: 'Wash & Clean',
                value: 20,
                percentage: 20),
            MostRequestedServiceModel(
                serviceName: 'بطاريات',
                serviceLatinName: 'Batteries',
                value: 20,
                percentage: 20),
            MostRequestedServiceModel(
                serviceName: 'تغيير إطارات',
                serviceLatinName: 'Tires Change',
                value: 20,
                percentage: 20),
          ];
        }

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
                color: AppColors.lightGreyColor.withValues(alpha: 0.5)),
            boxShadow: [
              BoxShadow(
                color: AppColors.darkColor.withValues(alpha: 0.03),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'إحصائية أكثر خدمات طلبات',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkColor,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  StatisticsDatePickerField(
                    label: 'بحث من',
                    selectedDate: startDate,
                    onDateSelected: (date) {
                      cubit.fetchMostRequestedServices(fromDate: date);
                    },
                  ),
                  const SizedBox(width: 8),
                  StatisticsDatePickerField(
                    label: 'الي',
                    selectedDate: endDate,
                    onDateSelected: (date) {
                      cubit.fetchMostRequestedServices(toDate: date);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Left Legends Column
                  Expanded(
                    flex: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(services.length, (index) {
                        final item = services[index];
                        final color = _palette[index % _palette.length];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.scaffoldColor,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                      color: AppColors.lightGreyColor),
                                ),
                                child: Text(
                                  '${item.percentage.toInt()}%',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.darkGreyColor,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: color,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  item.serviceName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.darkColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ),
                  // Donut Chart
                  Expanded(
                    flex: 6,
                    child: SizedBox(
                      height: 180,
                      child: SfCircularChart(
                        margin: EdgeInsets.zero,
                        series: <CircularSeries>[
                          DoughnutSeries<MostRequestedServiceModel, String>(
                            dataSource: services,
                            xValueMapper: (MostRequestedServiceModel data, _) =>
                                data.serviceName,
                            yValueMapper: (MostRequestedServiceModel data, _) =>
                                data.percentage,
                            pointColorMapper:
                                (MostRequestedServiceModel data, int index) =>
                                    _palette[index % _palette.length],
                            innerRadius: '60%',
                            radius: '90%',
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
