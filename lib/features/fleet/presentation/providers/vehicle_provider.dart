import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/vehicle.dart';
import '../../domain/entities/vehicle_status.dart';
import '../../domain/entities/status_reason.dart';
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
    state = [
      for (final vehicle in state)
        if (vehicle.id == vehicleId)
          vehicle.copyWith(
            status: newStatus,
            reason: reason,
            comment: comment,
            statusDuration: Duration.zero,
            lastUpdated: DateTime.now(),
          )
        else
          vehicle,
    ];
  }
}
