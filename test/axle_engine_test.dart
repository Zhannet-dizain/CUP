import 'package:flutter_test/flutter_test.dart';
import 'package:app/features/driver/domain/models/vehicle.dart';
import 'package:app/features/driver/domain/logic/axle_weight_engine.dart';
import 'package:app/features/driver/data/reference/ru_vehicle_database.dart';

void main() {
  group('AxleWeightEngine Tests', () {
    final tractor4x2 = RuVehicleDatabase.tractorList.firstWhere((t) => t.id == 'scania-r440');
    final trailer3axle = RuVehicleDatabase.trailerList.firstWhere((t) => t.id == 'schora-13-6');
    final trailer4axle = RuVehicleDatabase.trailerList.firstWhere((t) => t.id == 'tonar-16-5-4');

    test('Standard 40t combination (Tractor 4x2 + Trailer 3-axle)', () {
      // Tare: 7.9t + 6.8t = 14.7t. Cargo: 25.3t. Total: 40.0t
      final report = AxleWeightEngine.calculate(
        tractor: tractor4x2,
        trailer: trailer3axle,
        cargoWeight: 25.3,
      );

      expect(report.totalMass, closeTo(40.0, 0.01));
      
      // Total trailer weight: 6.8 + 25.3 = 32.1
      // Fifth wheel: 32.1 * 0.35 = 11.235
      // Bogie: 32.1 * 0.65 = 20.865
      
      // Tractor Front: 5.1 + (11.235 * 0.2) = 5.1 + 2.247 = 7.347 (Limit 10.0)
      // Tractor Rear: 2.8 + (11.235 * 0.8) = 2.8 + 8.988 = 11.788 (Limit 10.0 -> Overload)
      
      expect(report.axleLoads[0].currentLoad, closeTo(7.347, 0.001));
      expect(report.axleLoads[1].currentLoad, closeTo(11.788, 0.001));
      expect(report.axleLoads[1].isOverloaded, true);
      
      // Trailer bogie: 20.865 (Limit 21.0)
      expect(report.axleLoads[2].currentLoad, closeTo(20.865, 0.001));
      expect(report.axleLoads[2].isOverloaded, false);
    });

    test('4-axle Tonar: Limit shift when axle lifted', () {
      // Lowered
      trailer4axle.isFirstAxleLifted = false;
      final reportLowered = AxleWeightEngine.calculate(
        tractor: tractor4x2,
        trailer: trailer4axle,
        cargoWeight: 20.0,
      );
      // Quad limit: 26.0
      expect(reportLowered.axleLoads[2].limit, 26.0);

      // Lifted
      trailer4axle.isFirstAxleLifted = true;
      final reportLifted = AxleWeightEngine.calculate(
        tractor: tractor4x2,
        trailer: trailer4axle,
        cargoWeight: 20.0,
      );
      // Triple limit: 21.0
      expect(reportLifted.axleLoads[2].limit, 21.0);
    });
  });
}
