import '../models/vehicle.dart';

/// Математическое ядро расчета осевых нагрузок на основе метода моментов сил (правило рычага)
class AxleWeightEngine {
  /// Основная функция расчета развесовки
  static CalculationReport calculate({
    required TractorModel tractor,
    required TrailerModel trailer,
    required double cargoWeight,
    required double cargoOffset, // Смещение центра тяжести груза от передней стенки (м)
    required double cargoLength, // Длина груза (м)
  }) {
    // 1. Расчет центра тяжести груза (COG)
    // По условию COG - это середина длины груза + смещение от передней стенки
    final double cargoCOGFromFront = cargoOffset + (cargoLength / 2.0);

    // 2. Распределение веса груза в полуприцепе ( Lever Rule )
    // Точки опоры: Шкворень (Kingpin) и Центр тележки прицепа (Bogie Center)
    // L_trailer = kingpinToBogieCenter
    // Вес на тележку = Вес_груза * (Дистанция_от_шкворня / L_trailer)
    // Вес на шкворень = Вес_груза - Вес_на_тележку

    // Предполагаем, что передняя стенка находится на уровне шкворня (упрощение для MVP)
    double cargoOnBogie = cargoWeight * (cargoCOGFromFront / trailer.kingpinToBogieCenter);
    double cargoOnKingpin = cargoWeight - cargoOnBogie;

    // 3. Распределение веса тары полуприцепа (Lever Rule)
    // Упрощение: вес тары распределен 35/65 для пустого
    double tareOnKingpin = trailer.unladenWeight * 0.35;
    double tareOnBogie = trailer.unladenWeight * 0.65;

    double totalOnKingpin = cargoOnKingpin + tareOnKingpin;
    double totalOnBogie = cargoOnBogie + tareOnBogie;

    // 4. Распределение нагрузки с седла (Kingpin) на оси тягача
    // Колесная база = wheelbase
    // Седло смещено от задней оси на fifthWheelOffset (вперед)
    // Дистанция от передней оси до седла = wheelbase - fifthWheelOffset
    // Нагрузка на заднюю тележку тягача = totalOnKingpin * (Dist_Front_to_KP / wheelbase)
    // Нагрузка на переднюю ось тягача = totalOnKingpin - Нагрузка_на_заднюю

    double distFrontToKP = tractor.wheelbase - tractor.fifthWheelOffset;
    double kingpinOnRear = totalOnKingpin * (distFrontToKP / tractor.wheelbase);
    double kingpinOnFront = totalOnKingpin - kingpinOnRear;

    // 5. Итоговые веса по осям
    double finalFront = tractor.frontAxleEmptyWeight + kingpinOnFront;
    double finalRear = tractor.rearAxleEmptyWeight + kingpinOnRear;

    // 6. Формирование отчета
    final List<AxleLoadResult> loads = [];

    // Рулевая ось
    loads.add(AxleLoadResult(
      label: 'Передняя ось тягача',
      currentLoad: finalFront,
      limit: RuWeightLimits.singleAxleLimit,
    ));

    // Ведущая группа
    double rearLimit = (tractor.wheelFormula == '6x4') ? RuWeightLimits.tandemAxleLimit : RuWeightLimits.singleAxleLimit;
    loads.add(AxleLoadResult(
      label: tractor.wheelFormula == '6x4' ? 'Ведущая тележка тягача' : 'Ведущая ось тягача',
      currentLoad: finalRear,
      limit: rearLimit,
    ));

    // Группа прицепа
    int activeAxles = trailer.axleCount;
    double bogieLimit = RuWeightLimits.tripleAxleLimit;
    if (trailer.axleCount == 4) {
      if (trailer.isFirstAxleLifted) {
        activeAxles = 3;
        bogieLimit = RuWeightLimits.tripleAxleLimit;
      } else {
        bogieLimit = RuWeightLimits.quadAxleLimit;
      }
    }

    loads.add(AxleLoadResult(
      label: 'Осевая группа полуприцепа ($activeAxles оси)',
      currentLoad: totalOnBogie,
      limit: bogieLimit,
    ));

    return CalculationReport(
      totalMass: tractor.curbWeight + trailer.unladenWeight + cargoWeight,
      axleLoads: loads,
    );
  }
}
