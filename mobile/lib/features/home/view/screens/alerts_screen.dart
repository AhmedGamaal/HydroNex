import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydronex_app/core/theme/app_theme.dart';
import 'package:hydronex_app/features/alerts/cubit/alert/alert_cubit.dart';
import 'package:hydronex_app/features/home/view/widgets/alert_filter.dart';
import 'package:hydronex_app/features/home/view/widgets/alert_item.dart';

class AlertsScreen extends StatefulWidget {
  static const String routeName = '/AlertsScreen';

  final int cropId;

  const AlertsScreen({super.key, required this.cropId});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  String selectedFilter = 'All';

  @override
  void initState() {
    super.initState();

    context.read<AlertCubit>().getAlertsByCropId(widget.cropId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Alerts')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocBuilder<AlertCubit, AlertState>(
          builder: (context, state) {
            if (state.status == AlertStatus.loading) {
              return const Center(
                child: CircularProgressIndicator(color: AppTheme.primary),
              );
            }

            if (state.status == AlertStatus.failure) {
              return Center(
                child: Text(state.errorMessage ?? 'Failed to load alerts.'),
              );
            }

            final filteredAlerts = state.alerts.where((alert) {
              final severity = alert.severity.toLowerCase();
              final status = alert.status.toLowerCase();

              if (selectedFilter == 'All') {
                return true;
              }

              if (selectedFilter == 'Critical') {
                return severity == 'critical' && status == 'open';
              }

              if (selectedFilter == 'Warning') {
                return severity == 'warning' && status == 'open';
              }

              if (selectedFilter == 'Resolved') {
                return status == 'resolved';
              }

              return true;
            }).toList();
            return Column(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: IntrinsicWidth(
                    child: AlertFilter(
                      selectedFilter: selectedFilter,
                      onChanged: (value) {
                        setState(() {
                          selectedFilter = value;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: filteredAlerts.isEmpty
                      ? const Center(child: Text('No alerts'))
                      : ListView.separated(
                          padding: EdgeInsets.zero,
                          itemCount: filteredAlerts.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 8),
                          itemBuilder: (context, index) {
                            return AlertItem(alert: filteredAlerts[index]);
                          },
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
