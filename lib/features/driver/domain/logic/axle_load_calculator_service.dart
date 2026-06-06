import '../models/axle_calculator_models.dart';

/// Сервис для расчета осевых нагрузок (Pure Logic)
class AxleLoadCalculatorService {
  /// Константы ограничений РФ согласно Постановлению №2200
  static const double _limitSteering = 10.0;
  static const double _limitDriveSingle = 10.0;
  static const double _limitDriveTandem = 16.0;
  static const double _limitTrailerTriple = 21.0;
  static const double _limitTrailerQuad = 26.0;

  /// Основная функция расчета (stateless)
  static AxleLoadResult calculate(VehicleLoadConfiguration config) {
    // 1. Определение характеристик ТС (MVP-база)
    // Веса пустых ТС в тоннах
    final double tractorUnladenFront = config.isOldVehicle ? 5.15 : 4.80;
    final double tractorUnladenRear = config.isOldVehicle ? 3.35 : 2.75;
    final double trailerUnladenWeight = config.trailerType.toLowerCase().contains('реф') ? 8.4 : 7.1;

    // Геометрия сцепки (стандарт 13.6м)
    const double trailerLength = 13.6;
    const double pinFromTrailerFront = 1.6; // Расстояние от передней стенки до шкворня (м)
    const double bogieFromTrailerFront = 10.6; // Расстояние от передней стенки до центра тележки (м)
    const double baseDist = bogieFromTrailerFront - pinFromTrailerFront; // Рычаг (9м)

    // 2. Расчет центра масс груза
    double cargoWeightTons = 0;
    double cargoMoment = 0; // Момент относительно передней стенки полуприцепа

    for (int i = 0; i < config.cargoScheme.length; i++) {
      final pallet = config.cargoScheme[i];
      final weightTons = pallet.weightKg / 1000.0;
      cargoWeightTons += weightTons;
      cargoMoment += weightTons * pallet.positionMeters;
    }

    final double cargoCog = cargoWeightTons > 0 ? cargoMoment / cargoWeightTons : trailerLength / 2;

    // 3. Распределение веса полуприцепа (Тара + Груз)
    final double totalTrailerWeight = trailerUnladenWeight + cargoWeightTons;

    // Центр масс пустого прицепа (примерно 7м от переда)
    const double trailerUnladenCog = 6.8;

    // Суммарный момент относительно шкворня (Pin)
    final double momentRelToPin = (trailerUnladenWeight * (trailerUnladenCog - pinFromTrailerFront)) +
                                  (cargoWeightTons * (cargoCog - pinFromTrailerFront));

    // Нагрузка на тележку полуприцепа (по правилу рычага)
    final double trailerBogieLoad = momentRelToPin / baseDist;
    // Нагрузка на ССУ (седло)
    final double pinLoad = totalTrailerWeight - trailerBogieLoad;

    // 4. Распределение нагрузки на оси тягача
    // Распределение нагрузки от седла: 20/80 для 4х2, 15/85 для 6х4
    double pinToFrontShare = 0.20;
    double pinToRearShare = 0.80;

    if (config.driveAxlesCount > 1) {
      pinToFrontShare = 0.15;
      pinToRearShare = 0.85;
    }

    final double tractorFrontLoad = tractorUnladenFront + (pinLoad * pinToFrontShare);
    final double tractorRearLoad = tractorUnladenRear + (pinLoad * pinToRearShare);

    // 5. Формирование объектов AxleInfo
    final List<SingleAxleInfo> axles = [];

    // Рулевая ось
    axles.add(_buildAxleInfo(
      label: 'Рулевая ось',
      currentLoad: tractorFrontLoad,
      limit: _limitSteering,
      cargoWeightTons: cargoWeightTons,
      baseDist: baseDist,
      isBogie: false,
      isSteering: true,
    ));

    // Ведущая ось/тележка
    final driveLimit = config.driveAxlesCount > 1 ? _limitDriveTandem : _limitDriveSingle;
    axles.add(_buildAxleInfo(
      label: config.driveAxlesCount > 1 ? 'Ведущая тележка' : 'Ведущая ось',
      currentLoad: tractorRearLoad,
      limit: driveLimit,
      cargoWeightTons: cargoWeightTons,
      baseDist: baseDist,
      isBogie: false,
    ));

    // Тележка полуприцепа
    final trailerLimit = config.trailerAxlesCount >= 4 ? _limitTrailerQuad : _limitTrailerTriple;
    axles.add(_buildAxleInfo(
      label: 'Тележка полуприцепа (${config.trailerAxlesCount} осей)',
      currentLoad: trailerBogieLoad,
      limit: trailerLimit,
      cargoWeightTons: cargoWeightTons,
      baseDist: baseDist,
      isBogie: true,
    ));

    final totalMass = tractorUnladenFront + tractorUnladenRear + totalTrailerWeight;

    return AxleLoadResult(
      axles: axles,
      totalMass: double.parse(totalMass.toStringAsFixed(2)),
      hasOverload: axles.any((a) => a.status == AxleStatus.overload),
    );
  }

  static SingleAxleInfo _buildAxleInfo({
    required String label,
    required double currentLoad,
    required double limit,
    required double cargoWeightTons,
    required double baseDist,
    required bool isBogie,
    bool isSteering = false,
  }) {
    AxleStatus status = AxleStatus.ok;
    if (currentLoad > limit) {
      status = AxleStatus.overload;
    } else if (currentLoad > limit * 0.95) {
      status = AxleStatus.warning;
    }

    String recommendation = '';
    if (status != AxleStatus.ok) {
      if (isBogie) {
        // Перегруз прицепа -> нужно двигать вперед
        final double excess = currentLoad - (limit * 0.92);
        final double shift = (excess * baseDist) / (cargoWeightTons > 0 ? cargoWeightTons : 1);
        recommendation = 'Сдвиньте задние паллеты вперед на ${shift.toStringAsFixed(1)}м';
      } else {
        // Перегруз тягача -> нужно двигать назад
        final double excess = currentLoad - (limit * 0.92);
        final double shift = (excess * baseDist) / (cargoWeightTons > 0 ? cargoWeightTons : 1);
        recommendation = 'Сдвиньте передние паллеты назад на ${shift.toStringAsFixed(1)}м';
      }
    }

    return SingleAxleInfo(
      label: label,
      currentLoad: double.parse(currentLoad.toStringAsFixed(2)),
      limit: limit,
      status: status,
      recommendation: recommendation,
    );
  }
}
