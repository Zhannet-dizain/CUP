import '../../domain/models/vehicle.dart';

/// Справочник российской техники
class RuVehicleDatabase {
  /// Список доступных тягачей
  static final List<TractorModel> tractors = [
    TractorModel(
      name: 'КАМАЗ 54901 (K5)',
      axleConfiguration: '4x2',
      unladenWeight: 7900,
      suspension: SuspensionType.mixed,
    ),
    TractorModel(
      name: 'Scania S500 Next Gen',
      axleConfiguration: '4x2',
      unladenWeight: 8200,
      suspension: SuspensionType.air,
    ),
    TractorModel(
      name: 'КАМАЗ 65209',
      axleConfiguration: '6x2',
      unladenWeight: 9200,
      suspension: SuspensionType.air,
    ),
  ];

  /// Список доступных полуприцепов
  static final List<TrailerModel> trailers = [
    TrailerModel(
      name: 'Стандартная штора 13.6м',
      type: TrailerType.curtainSide,
      axleCount: 3,
      unladenWeight: 6800,
      axleDistances: [1.31, 1.31],
    ),
    TrailerModel(
      name: 'Тонар 16.5м (4 оси)',
      type: TrailerType.curtainSide,
      axleCount: 4,
      unladenWeight: 8500,
      axleDistances: [2.51, 1.31, 1.31], // Первая ось вынесена
      isFirstAxleLifted: false,
    ),
    TrailerModel(
      name: 'Полуприцеп-цистерна (Нефаз)',
      type: TrailerType.tanker,
      axleCount: 3,
      unladenWeight: 7200,
      axleDistances: [1.31, 1.31],
    ),
    TrailerModel(
      name: 'Тонар-контейнеровоз',
      type: TrailerType.container,
      axleCount: 3,
      unladenWeight: 5500,
      axleDistances: [1.31, 1.31],
    ),
    TrailerModel(
      name: 'Полуприцеп рефрижератор',
      type: TrailerType.reefer,
      axleCount: 3,
      unladenWeight: 8900,
      axleDistances: [1.31, 1.31],
    ),
  ];

  /// Метод расчета лимита нагрузки на тележку полуприцепа (кг)
  /// Логика согласно нормативам РФ
  static double getBogieLimit(TrailerModel trailer) {
    if (trailer.name.contains('Тонар 16.5м (4 оси)')) {
      if (trailer.isFirstAxleLifted) {
        // Если 1-я ось поднята, лимит как у стандартной 3-оски
        return 22500;
      } else {
        // Лимит 4-осной тележки
        return 32000;
      }
    }

    // Стандарт для 3-х осей
    if (trailer.axleCount == 3) {
      return 22500;
    }

    return 22500;
  }

  /// Метод проверки риска перегруза
  /// Возвращает true, если риск критический
  static bool checkOverloadRisk(TrailerModel trailer, double cargoMassTons) {
    double limit = getBogieLimit(trailer);

    if (trailer.name.contains('Тонар 16.5м (4 оси)')) {
      if (!trailer.isFirstAxleLifted) {
        // Лимит 32т, предупреждение при > 29т
        return cargoMassTons > 29.0;
      } else {
        // Лимит 22.5т, предупреждение при > 23т
        return cargoMassTons > 23.0;
      }
    }

    // Для остальных 3-осных полуприцепов (Штора, Реф и др.)
    return cargoMassTons > 23.0;
  }
}
