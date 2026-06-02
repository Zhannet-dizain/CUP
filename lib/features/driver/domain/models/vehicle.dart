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
  final String name;
  final TrailerType type;
  final int axleCount;

  /// Масса тары (кг)
  final double unladenWeight;

  /// Расстояния между осями (м)
  final List<double> axleDistances;

  /// Флаг состояния первой подъемной оси
  bool isFirstAxleLifted;

  TrailerModel({
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
  final String name;
  final String axleConfiguration; // Напр. "4x2", "6x2"
  final double unladenWeight;
  final SuspensionType suspension;

  TractorModel({
    required this.name,
    required this.axleConfiguration,
    required this.unladenWeight,
    required this.suspension,
  });
}
