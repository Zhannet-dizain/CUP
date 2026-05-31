import 'package:flutter_test/flutter_test.dart';
import 'package:app/features/fleet/domain/entities/vehicle_status.dart';
import 'package:app/features/fleet/presentation/providers/vehicle_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  test('Vehicle status update should reset duration and update lastUpdated', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final initialVehicles = container.read(vehicleListProvider);
    final targetVehicle = initialVehicles.first;

    final newStatus = VehicleStatus.underRepair;

    container.read(vehicleListProvider.notifier).updateVehicleStatus(
      vehicleId: targetVehicle.id,
      newStatus: newStatus,
    );

    final updatedVehicles = container.read(vehicleListProvider);
    final updatedVehicle = updatedVehicles.firstWhere((v) => v.id == targetVehicle.id);

    expect(updatedVehicle.status, newStatus);
    expect(updatedVehicle.statusDuration, Duration.zero);
    expect(updatedVehicle.lastUpdated.isAfter(targetVehicle.lastUpdated), true);
  });
}
