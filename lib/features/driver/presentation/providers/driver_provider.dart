import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/driver_earnings.dart';

part 'driver_provider.g.dart';

@riverpod
class DriverEarningsNotifier extends _$DriverEarningsNotifier {
  @override
  DriverEarnings build() {
    // Mock data for the driver
    return const DriverEarnings(
      currentMonthKmDriven: 8500.0,
      kmTarget: 12000.0,
      perKmRate: 8.5,
      accumulatedDailyAllowances: 14000.0,
      currentBonuses: 5000.0,
      currentDeductions: 1500.0,
    );
  }
}
