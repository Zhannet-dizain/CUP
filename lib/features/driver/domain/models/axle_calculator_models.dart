/// Статус безопасности оси
enum AxleStatus {
  /// В норме
  ok,
  /// Превышение близко (внимание)
  warning,
  /// Перегруз
  overload
}

/// Модель паллеты в схеме груза
class Pallet {
  /// Вес паллеты в кг
  final double weightKg;
  /// Координата размещения по длине полуприцепа (в метрах от передней стенки)
  final double positionMeters;

  const Pallet({
    required this.weightKg,
    required this.positionMeters,
  });

  factory Pallet.fromJson(Map<String, dynamic> json) {
    return Pallet(
      weightKg: (json['weightKg'] as num).toDouble(),
      positionMeters: (json['positionMeters'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'weightKg': weightKg,
      'positionMeters': positionMeters,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Pallet &&
          runtimeType == other.runtimeType &&
          weightKg == other.weightKg &&
          positionMeters == other.positionMeters;

  @override
  int get hashCode => weightKg.hashCode ^ positionMeters.hashCode;
}

/// Входная конфигурация для расчета нагрузок
class VehicleLoadConfiguration {
  /// Тип тягача (напр. "4x2", "6x4")
  final String tractorType;
  /// Тип полуприцепа (напр. "тент", "реф")
  final String trailerType;
  /// Количество рулевых осей
  final int steeringAxlesCount;
  /// Количество ведущих осей
  final int driveAxlesCount;
  /// Количество осей полуприцепа
  final int trailerAxlesCount;
  /// Флаг старого ТС (>1 млн км, МКПП)
  final bool isOldVehicle;
  /// Схема размещения паллет
  final List<Pallet> cargoScheme;

  const VehicleLoadConfiguration({
    required this.tractorType,
    required this.trailerType,
    required this.steeringAxlesCount,
    required this.driveAxlesCount,
    required this.trailerAxlesCount,
    required this.isOldVehicle,
    required this.cargoScheme,
  });

  factory VehicleLoadConfiguration.fromJson(Map<String, dynamic> json) {
    return VehicleLoadConfiguration(
      tractorType: json['tractorType'] as String,
      trailerType: json['trailerType'] as String,
      steeringAxlesCount: json['steeringAxlesCount'] as int,
      driveAxlesCount: json['driveAxlesCount'] as int,
      trailerAxlesCount: json['trailerAxlesCount'] as int,
      isOldVehicle: json['isOldVehicle'] as bool,
      cargoScheme: (json['cargoScheme'] as List<dynamic>)
          .map((e) => Pallet.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tractorType': tractorType,
      'trailerType': trailerType,
      'steeringAxlesCount': steeringAxlesCount,
      'driveAxlesCount': driveAxlesCount,
      'trailerAxlesCount': trailerAxlesCount,
      'isOldVehicle': isOldVehicle,
      'cargoScheme': cargoScheme.map((e) => e.toJson()).toList(),
    };
  }

  VehicleLoadConfiguration copyWith({
    String? tractorType,
    String? trailerType,
    int? steeringAxlesCount,
    int? driveAxlesCount,
    int? trailerAxlesCount,
    bool? isOldVehicle,
    List<Pallet>? cargoScheme,
  }) {
    return VehicleLoadConfiguration(
      tractorType: tractorType ?? this.tractorType,
      trailerType: trailerType ?? this.trailerType,
      steeringAxlesCount: steeringAxlesCount ?? this.steeringAxlesCount,
      driveAxlesCount: driveAxlesCount ?? this.driveAxlesCount,
      trailerAxlesCount: trailerAxlesCount ?? this.trailerAxlesCount,
      isOldVehicle: isOldVehicle ?? this.isOldVehicle,
      cargoScheme: cargoScheme ?? this.cargoScheme,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VehicleLoadConfiguration &&
          runtimeType == other.runtimeType &&
          tractorType == other.tractorType &&
          trailerType == other.trailerType &&
          steeringAxlesCount == other.steeringAxlesCount &&
          driveAxlesCount == other.driveAxlesCount &&
          trailerAxlesCount == other.trailerAxlesCount &&
          isOldVehicle == other.isOldVehicle &&
          _listEquals(cargoScheme, other.cargoScheme);

  @override
  int get hashCode =>
      tractorType.hashCode ^
      trailerType.hashCode ^
      steeringAxlesCount.hashCode ^
      driveAxlesCount.hashCode ^
      trailerAxlesCount.hashCode ^
      isOldVehicle.hashCode ^
      cargoScheme.hashCode;

  bool _listEquals(List a, List b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}

/// Информация по конкретной оси или группе осей
class SingleAxleInfo {
  /// Название оси/группы (напр. "Рулевая ось", "Тележка полуприцепа")
  final String label;
  /// Текущая нагрузка в тоннах
  final double currentLoad;
  /// Максимально допустимый лимит в тоннах
  final double limit;
  /// Статус безопасности
  final AxleStatus status;
  /// Рекомендация по оптимизации (генерируется при warning/overload)
  final String recommendation;

  const SingleAxleInfo({
    required this.label,
    required this.currentLoad,
    required this.limit,
    required this.status,
    required this.recommendation,
  });

  factory SingleAxleInfo.fromJson(Map<String, dynamic> json) {
    return SingleAxleInfo(
      label: json['label'] as String,
      currentLoad: (json['currentLoad'] as num).toDouble(),
      limit: (json['limit'] as num).toDouble(),
      status: AxleStatus.values.firstWhere((e) => e.name == json['status']),
      recommendation: json['recommendation'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'currentLoad': currentLoad,
      'limit': limit,
      'status': status.name,
      'recommendation': recommendation,
    };
  }
}

/// Результирующая модель расчета
class AxleLoadResult {
  /// Список данных по каждой оси
  final List<SingleAxleInfo> axles;
  /// Полная масса автопоезда (т)
  final double totalMass;
  /// Наличие любого перегруза
  final bool hasOverload;

  const AxleLoadResult({
    required this.axles,
    required this.totalMass,
    required this.hasOverload,
  });

  factory AxleLoadResult.fromJson(Map<String, dynamic> json) {
    return AxleLoadResult(
      axles: (json['axles'] as List<dynamic>)
          .map((e) => SingleAxleInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalMass: (json['totalMass'] as num).toDouble(),
      hasOverload: json['hasOverload'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'axles': axles.map((e) => e.toJson()).toList(),
      'totalMass': totalMass,
      'hasOverload': hasOverload,
    };
  }
}
