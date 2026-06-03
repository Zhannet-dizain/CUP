import 'package:freezed_annotation/freezed_annotation.dart';

part 'driver_earnings.freezed.dart';
part 'driver_earnings.g.dart';

@freezed
class DriverEarnings with _$DriverEarnings {
  const factory DriverEarnings({
    required double currentMonthKmDriven,
    required double kmTarget,
    required double perKmRate,
    required double accumulatedDailyAllowances,
    required double currentBonuses,
    required double currentDeductions,
  }) = _DriverEarnings;

  factory DriverEarnings.fromJson(Map<String, dynamic> json) => _$DriverEarningsFromJson(json);
}
