import 'package:flutter_test/flutter_test.dart';
import 'package:app/features/driver/domain/models/vehicle.dart';
import 'package:app/features/driver/domain/logic/axle_weight_engine.dart';
import 'package:app/features/driver/data/reference/ru_vehicle_database.dart';

void main() {
  group('AxleWeightEngine Physics Tests', () {
    final tractor4x2 = RuVehicleDatabase.tractorList.firstWhere((t) => t.id == 'scania-r440');
    final trailer3axle = RuVehicleDatabase.trailerList.firstWhere((t) => t.id == 'schora-13-6');

    test('Physics-based distribution (Lever Rule)', () {
      final report = AxleWeightEngine.calculate(
        tractor: tractor4x2,
        trailer: trailer3axle,
        cargoWeight: 20.0,
        cargoOffset: 4.0, // COG at 4 + 6.5 = 10.5 from front
        cargoLength: 13.0,
      );

      expect(report.totalMass, closeTo(7.9 + 6.8 + 20.0, 0.01));
      expect(report.axleLoads.length, 3);
    });
   group('AxleWeightEngine 4-Axle Tests', () {
    final tractor4x2 = RuVehicleDatabase.tractorList.firstWhere((t) => t.id == 'scania-r440');
    final trailer4axle = RuVehicleDatabase.trailerList.firstWhere((t) => t.id == 'tonar-16-5-4');

    test('Lifted axle logic', () {
      final reportLifted = AxleWeightEngine.calculate(
        tractor: tractor4x2,
        trailer: trailer4axle..isFirstAxleLifted = true,
        cargoWeight: 15.0,
        cargoOffset: 2.0,
        cargoLength: 16.5,
      );

      final trailerLoad = reportLifted.axleLoads.firstWhere((l) => l.label.contains('полуприцепа'));
      expect(trailerLoad.limit, 21.0); // tripleAxleLimit
    });
  });
  });
}
