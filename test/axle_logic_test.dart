import 'package:flutter_test/flutter_test.dart';
import 'package:app/features/driver/data/reference/ru_vehicle_database.dart';
import 'package:app/features/driver/domain/models/vehicle.dart';

void main() {
  group('Axle Load Logic Tests', () {
    test('4-axle Tonar: limit should be 32t when axle is lowered', () {
      final tonar = RuVehicleDatabase.trailers.firstWhere((t) => t.name == 'Тонар 16.5м (4 оси)');
      tonar.isFirstAxleLifted = false;
      
      expect(RuVehicleDatabase.getBogieLimit(tonar), 32000);
      expect(RuVehicleDatabase.checkOverloadRisk(tonar, 25.0), false);
      expect(RuVehicleDatabase.checkOverloadRisk(tonar, 30.0), true);
    });

    test('4-axle Tonar: limit should be 22.5t when axle is lifted', () {
      final tonar = RuVehicleDatabase.trailers.firstWhere((t) => t.name == 'Тонар 16.5м (4 оси)');
      tonar.isFirstAxleLifted = true;
      
      expect(RuVehicleDatabase.getBogieLimit(tonar), 22500);
      // Logic from prompt: Standard 3-axle logic for lifted Tonar
      // Warn if cargo > 23t
      expect(RuVehicleDatabase.checkOverloadRisk(tonar, 22.0), false);
      expect(RuVehicleDatabase.checkOverloadRisk(tonar, 24.0), true);
    });

    test('Standard 3-axle trailer: limit should be 22.5t', () {
      final schora = RuVehicleDatabase.trailers.firstWhere((t) => t.name == 'Стандартная штора 13.6м');
      
      expect(RuVehicleDatabase.getBogieLimit(schora), 22500);
      expect(RuVehicleDatabase.checkOverloadRisk(schora, 20.0), false);
      expect(RuVehicleDatabase.checkOverloadRisk(schora, 24.0), true);
    });
  });
}
