import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:app/features/driver/domain/models/axle_calculator_models.dart';
import 'package:app/features/driver/domain/logic/axle_load_calculator_service.dart';

void main() {
  group('AxleLoadCalculator Tests', () {
    test('Basic calculation with no cargo', () {
      final config = VehicleLoadConfiguration(
        tractorType: '4x2',
        trailerType: 'тент',
        steeringAxlesCount: 1,
        driveAxlesCount: 1,
        trailerAxlesCount: 3,
        isOldVehicle: false,
        cargoScheme: [],
      );

      final result = AxleLoadCalculatorService.calculate(config);

      expect(result.totalMass, greaterThan(11.0)); // 4.8 + 2.75 + 7.1 = 14.65
      expect(result.totalMass, 14.65);
      expect(result.hasOverload, false);
      expect(result.axles.length, 3);

      // Steering axle unladen
      expect(result.axles[0].label, 'Рулевая ось');
      expect(result.axles[0].status, AxleStatus.ok);
    });

    test('Overload detection and recommendation', () {
      // 20 tons in the rear of the trailer
      final config = VehicleLoadConfiguration(
        tractorType: '4x2',
        trailerType: 'тент',
        steeringAxlesCount: 1,
        driveAxlesCount: 1,
        trailerAxlesCount: 3,
        isOldVehicle: false,
        cargoScheme: [
          Pallet(weightKg: 20000, positionMeters: 12.0),
        ],
      );

      final result = AxleLoadCalculatorService.calculate(config);

      // With cargo at the back, trailer bogie should be heavily loaded
      final trailerBogie = result.axles.firstWhere((a) => a.label.contains('Тележка полуприцепа'));

      expect(trailerBogie.currentLoad, greaterThan(21.0));
      expect(trailerBogie.status, AxleStatus.overload);
      expect(trailerBogie.recommendation, contains('Сдвиньте задние паллеты вперед'));
    });

    test('JSON serialization/deserialization', () {
      final config = VehicleLoadConfiguration(
        tractorType: '6x4',
        trailerType: 'реф',
        steeringAxlesCount: 1,
        driveAxlesCount: 2,
        trailerAxlesCount: 3,
        isOldVehicle: true,
        cargoScheme: [
          Pallet(weightKg: 1000, positionMeters: 5.0),
        ],
      );

      final json = config.toJson();
      final fromJson = VehicleLoadConfiguration.fromJson(json);

      expect(fromJson, config);
      expect(json['tractorType'], '6x4');
      expect(json['isOldVehicle'], true);
      expect(json['cargoScheme'][0]['weightKg'], 1000.0);
    });

    test('Stream compatibility test', () async {
      final config1 = VehicleLoadConfiguration(
        tractorType: '4x2',
        trailerType: 'тент',
        steeringAxlesCount: 1,
        driveAxlesCount: 1,
        trailerAxlesCount: 3,
        isOldVehicle: false,
        cargoScheme: [],
      );

      final config2 = config1.copyWith(
        cargoScheme: [Pallet(weightKg: 24000, positionMeters: 6.8)],
      );

      final inputStream = Stream.fromIterable([config1, config2]);
      final outputStream = inputStream.map((c) => AxleLoadCalculatorService.calculate(c));

      final results = await outputStream.toList();

      expect(results.length, 2);
      expect(results[0].totalMass, 14.65);
      expect(results[1].totalMass, 38.65);
    });
  });
}
