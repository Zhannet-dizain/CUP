/// Тип транспортного средства
enum VehicleType {
  /// Седельный тягач
  tractor,
  /// Одиночка / Ригид
  rigid
}

/// Тип полуприцепа / кузова
enum TrailerType {
  /// Штора (Тент) 13.6м
  curtainSide,
  /// Рефрижератор
  reefer,
  /// Самосвал
  tipper,
  /// Контейнеровоз
  container,
  /// Трал (Низкорамный)
  lowboy,
  /// Цистерна
  tanker
}

/// Тип подвески
enum SuspensionType {
  /// Пневматическая (Воздушная)
  air,
  /// Рессорная (Пружинная)
  spring,
  /// Смешанная
  mixed
}

/// Модель полуприцепа с техническими характеристиками
class TrailerModel {
  final String id;
  final String name;
  final TrailerType type;
  final int axleCount;

  /// Масса тары (т)
  final double unladenWeight;

  /// Расстояния между осями (м)
  final List<double> axleDistances;

  /// Полная длина кузова (м)
  final double length;

  /// Расстояние от шкворня (Kingpin) до центра тележки (м)
  final double kingpinToBogieCenter;

  /// Флаг состояния первой подъемной оси
  bool isFirstAxleLifted;

  TrailerModel({
    required this.id,
    required this.name,
    required this.type,
    required this.axleCount,
    required this.unladenWeight,
    required this.axleDistances,
    required this.length,
    required this.kingpinToBogieCenter,
    this.isFirstAxleLifted = false,
  });
}

/// Модель тягача
class TractorModel {
  final String id;
  final String brand;
  final String model;
  final String wheelFormula; // Напр. "4x2", "6x2", "6x4"

  /// Полная снаряженная масса тягача (т)
  final double curbWeight;

  /// Вес на рулевую ось пустого тягача (т)
  final double frontAxleEmptyWeight;

  /// Вес на ведущую ось/тележку пустого тягача (т)
  final double rearAxleEmptyWeight;

  /// Макс. нагрузка на ССУ (т)
  final double maxFifthWheelLoad;

  /// Колесная база (расстояние от передней оси до центра задней тележки) (м)
  final double wheelbase;

  /// Смещение ССУ (седла) относительно центра задней оси/тележки (м, обычно вперед - положительное)
  final double fifthWheelOffset;

  final SuspensionType suspension;

  TractorModel({
    required this.id,
    required this.brand,
    required this.model,
    required this.wheelFormula,
    required this.curbWeight,
    required this.frontAxleEmptyWeight,
    required this.rearAxleEmptyWeight,
    required this.maxFifthWheelLoad,
    required this.wheelbase,
    required this.fifthWheelOffset,
    required this.suspension,
  });

  String get name => '$brand $model ($wheelFormula)';
}

/// Константы ограничений РФ (Постановление №2200)
class RuWeightLimits {
  static const double totalMass5Axles = 40.0;
  static const double totalMass6Axles = 44.0;
  static const double singleAxleLimit = 10.0;
  static const double tandemAxleLimit = 16.0;
  static const double tripleAxleLimit = 21.0;
  static const double quadAxleLimit = 26.0;
}

/// Результат расчета нагрузки на ось
class AxleLoadResult {
  final String label;
  final double currentLoad;
  final double limit;
  final bool isOverloaded;

  AxleLoadResult({
    required this.label,
    required this.currentLoad,
    required this.limit,
  }) : isOverloaded = currentLoad > limit;
}

/// Итоговый отчет по развесовке
class CalculationReport {
  final double totalMass;
  final List<AxleLoadResult> axleLoads;
  final bool hasOverload;

  CalculationReport({
    required this.totalMass,
    required this.axleLoads,
  }) : hasOverload = axleLoads.any((a) => a.isOverloaded);
}
