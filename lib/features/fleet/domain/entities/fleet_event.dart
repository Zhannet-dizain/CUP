import 'package:freezed_annotation/freezed_annotation.dart';
import 'vehicle_status.dart';

part 'fleet_event.freezed.dart';
part 'fleet_event.g.dart';

@freezed
class FleetEvent with _$FleetEvent {
  const factory FleetEvent({
    required String id,
    required String vehicleId,
    required String licensePlate,
    required VehicleStatus oldStatus,
    required VehicleStatus newStatus,
    String? reason,
    required DateTime timestamp,
    required String initiatorRole,
  }) = _FleetEvent;

  factory FleetEvent.fromJson(Map<String, dynamic> json) => _$FleetEventFromJson(json);
}
