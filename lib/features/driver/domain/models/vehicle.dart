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

  /// Флаг состояния первой подъемной оси
  bool isFirstAxleLifted;

  TrailerModel({
    required this.id,
    required this.name,
    required this.type,
    required this.axleCount,
    required this.unladenWeight,
    required this.axleDistances,
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
    required this.suspension,
  });

  String get name => '$brand $model ($wheelFormula)';
}

/// Константы ограничений РФ (Постановление №2200)
class RuWeightLimits {
  /// Лимит полной массы автопоезда (5 осей)
  static const double totalMass5Axles = 40.0;

  /// Лимит полной массы автопоезда (6 осей)
  static const double totalMass6Axles = 44.0;

  /// Лимит на одиночную ось (рулевую)
  static const double singleAxleLimit = 10.0;

  /// Лимит на двухосную тележку (ведущая группа или прицеп)
  /// При расстоянии 1.3 - 1.8 м
  static const double tandemAxleLimit = 16.0; // 8.0 на ось при пневмоподвеске

  /// Лимит на трехосную тележку прицепа (1.3 - 1.4 м)
  static const double tripleAxleLimit = 21.0; // 7.0 на ось

  /// Лимит на четырехосную тележку (5.5 - 6.5 на ось)
  static const double quadAxleLimit = 26.0; // Примерный усредненный лимит
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
