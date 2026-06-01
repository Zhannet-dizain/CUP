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
  }) = _Vehicle;

  factory Vehicle.fromJson(Map<String, dynamic> json) => _$VehicleFromJson(json);
}
