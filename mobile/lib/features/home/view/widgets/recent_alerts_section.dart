import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydronex_app/core/routes/app_routes.dart';
import 'package:hydronex_app/core/routes/route_context_extention.dart';
import 'package:hydronex_app/features/alerts/cubit/alert/alert_cubit.dart';
import 'package:hydronex_app/features/home/view/widgets/alert_item.dart';

class RecentAlertsSection extends StatelessWidget {
  final int cropId;

  const RecentAlertsSection({super.key, required this.cropId});

  @override
  Widget build(BuildContext context) {
    final textTheme = TextTheme.of(context);

    return BlocBuilder<AlertCubit, AlertState>(
      builder: (context, state) {
        if (state.status == AlertStatus.loading ||
            state.status == AlertStatus.failure ||
            state.alerts.isEmpty) {
          return const SizedBox.shrink();
        }

        final alerts = [...state.alerts]
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

        final recentAlerts = alerts.take(3).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Recent Alerts', style: textTheme.titleMedium),
                GestureDetector(
                  onTap: () {
                    context.pushNamed(
                      AppRoutes.alerts,
                      arguments: {'cropId': cropId},
                    );
                  },
                  child: Text('View all >', style: textTheme.labelLarge),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...recentAlerts.map(
              (alert) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: AlertItem(alert: alert),
              ),
            ),
          ],
        );
      },
    );
  }
}
