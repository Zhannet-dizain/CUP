import '../models/vehicle.dart';

/// Математическое ядро расчета осевых нагрузок
class AxleWeightEngine {
  /// Основная функция расчета развесовки
  static CalculationReport calculate({
    required TractorModel tractor,
    required TrailerModel trailer,
    required double cargoWeight,
  }) {
    // 1. Полный вес полуприцепа с грузом
    final double totalTrailerWeight = trailer.unladenWeight + cargoWeight;

    // 2. Распределение веса полуприцепа между ССУ и тележкой
    // Для стандартных сцепок (MVP):
    // Примерно 35% уходит на седло (ССУ), 65% на тележку полуприцепа.
    // Эти коэффициенты могут меняться от длины и центра масс, но для MVP используем статику.
    double fifthWheelLoad = totalTrailerWeight * 0.35;
    double trailerBogieLoad = totalTrailerWeight * 0.65;

    // 3. Распределение нагрузки на ССУ между осями тягача
    // По условию: 20% на перед, 80% на зад
    double tractorFrontAddition = fifthWheelLoad * 0.20;
    double tractorRearAddition = fifthWheelLoad * 0.80;

    double finalTractorFront = tractor.frontAxleEmptyWeight + tractorFrontAddition;
    double finalTractorRear = tractor.rearAxleEmptyWeight + tractorRearAddition;

    // 4. Распределение веса на тележке полуприцепа
    // Исключаем поднятую ось если есть
    int activeTrailerAxles = trailer.axleCount;
    if (trailer.isFirstAxleLifted) {
      activeTrailerAxles -= 1;
    }

    double perTrailerAxleLoad = trailerBogieLoad / activeTrailerAxles;

    // 5. Формирование отчета
    final List<AxleLoadResult> loads = [];

    // Рулевая ось тягача
    loads.add(AxleLoadResult(
      label: 'Рулевая ось тягача',
      currentLoad: finalTractorFront,
      limit: RuWeightLimits.singleAxleLimit,
    ));

    // Ведущая ось/группа тягача
    double tractorRearLimit = RuWeightLimits.singleAxleLimit;
    if (tractor.wheelFormula == '6x4' || tractor.wheelFormula == '6x2') {
      tractorRearLimit = RuWeightLimits.tandemAxleLimit;
    }

    loads.add(AxleLoadResult(
      label: tractor.wheelFormula == '4x2' ? 'Ведущая ось тягача' : 'Ведущая тележка тягача',
      currentLoad: finalTractorRear,
      limit: tractorRearLimit,
    ));

    // Оси полуприцепа
    double trailerBogieLimit = RuWeightLimits.tripleAxleLimit;
    if (trailer.axleCount == 4) {
      trailerBogieLimit = trailer.isFirstAxleLifted ? RuWeightLimits.tripleAxleLimit : RuWeightLimits.quadAxleLimit;
    }

    loads.add(AxleLoadResult(
      label: 'Тележка полуприцепа (${trailer.isFirstAxleLifted ? activeTrailerAxles : trailer.axleCount} оси)',
      currentLoad: trailerBogieLoad,
      limit: trailerBogieLimit,
    ));

    return CalculationReport(
      totalMass: tractor.curbWeight + totalTrailerWeight,
      axleLoads: loads,
    );
  }
}
