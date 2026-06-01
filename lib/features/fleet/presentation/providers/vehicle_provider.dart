import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/vehicle.dart';
import '../../domain/entities/vehicle_status.dart';
import '../../domain/entities/status_reason.dart';
import '../../domain/entities/fleet_event.dart';
import '../../data/mock_fleet_data.dart';

part 'vehicle_provider.g.dart';

@riverpod
class VehicleList extends _$VehicleList {
  @override
  List<Vehicle> build() {
    return mockVehicles;
  }

  void updateVehicleStatus({
    required String vehicleId,
    required VehicleStatus newStatus,
    StatusReason? reason,
    String? comment,
  }) {
    final oldVehicle = state.firstWhere((v) => v.id == vehicleId);

    final updatedVehicle = oldVehicle.copyWith(
      status: newStatus,
      reason: reason,
      comment: comment,
      statusDuration: Duration.zero,
      lastUpdated: DateTime.now(),
    );

    state = [
      for (final vehicle in state)
        if (vehicle.id == vehicleId) updatedVehicle else vehicle,
    ];

    // Add event to the feed
    ref.read(fleetEventsProvider.notifier).addEvent(
      FleetEvent(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        vehicleId: vehicleId,
        licensePlate: oldVehicle.licensePlate,
        oldStatus: oldVehicle.status,
        newStatus: newStatus,
        reason: comment ?? reason?.label ?? 'Изменение статуса',
        timestamp: DateTime.now(),
        initiatorRole: 'ДИСПЕТЧЕР', // Default role for now
      ),
    );
  }
}

@riverpod
class FleetEvents extends _$FleetEvents {
  @override
  List<FleetEvent> build() {
    return mockEvents;
  }

  void addEvent(FleetEvent event) {
    state = [event, ...state];
  }
}
