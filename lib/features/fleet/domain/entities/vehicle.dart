import 'package:freezed_annotation/freezed_annotation.dart';
import 'vehicle_status.dart';
import 'status_reason.dart';

part 'vehicle.freezed.dart';
part 'vehicle.g.dart';

@freezed
class Vehicle with _$Vehicle {
  const factory Vehicle({
    required String id,
    required String licensePlate,
    required String brandModel,
    String? trailer,
    String? driver,
    required String column,
    required VehicleStatus status,
    required Duration statusDuration,
    StatusReason? reason,
    required String location,
    required String responsibleUser,
    String? comment,
    required DateTime lastUpdated,
    @Default(0.0) double hourlyCost,
    @Default(100.0) double fuelLevel,
    @Default(85.0) double engineTemp,
    @Default(0.0) double mileage,
    @Default(0.0) double revenue,
    @Default(0.0) double maintenanceCosts,
    @Default(0.0) double fuelCosts,
    @Default(0.0) double amortization,
    @Default(55.7558) double lat,
    @Default(37.6173) double lng,
    @Default(0.0) double speed,
  }) = _Vehicle;

  factory Vehicle.fromJson(Map<String, dynamic> json) => _$VehicleFromJson(json);
}
