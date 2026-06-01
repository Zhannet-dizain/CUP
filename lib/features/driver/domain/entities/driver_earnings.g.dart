// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'driver_earnings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DriverEarningsImpl _$$DriverEarningsImplFromJson(Map<String, dynamic> json) =>
    _$DriverEarningsImpl(
      currentMonthKmDriven: (json['currentMonthKmDriven'] as num).toDouble(),
      kmTarget: (json['kmTarget'] as num).toDouble(),
      perKmRate: (json['perKmRate'] as num).toDouble(),
      accumulatedDailyAllowances: (json['accumulatedDailyAllowances'] as num)
          .toDouble(),
      currentBonuses: (json['currentBonuses'] as num).toDouble(),
      currentDeductions: (json['currentDeductions'] as num).toDouble(),
    );

Map<String, dynamic> _$$DriverEarningsImplToJson(
  _$DriverEarningsImpl instance,
) => <String, dynamic>{
  'currentMonthKmDriven': instance.currentMonthKmDriven,
  'kmTarget': instance.kmTarget,
  'perKmRate': instance.perKmRate,
  'accumulatedDailyAllowances': instance.accumulatedDailyAllowances,
  'currentBonuses': instance.currentBonuses,
  'currentDeductions': instance.currentDeductions,
};
