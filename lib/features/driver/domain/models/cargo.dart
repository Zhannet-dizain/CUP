/// Тип груза
enum CargoType { 
  /// Делимый (паллеты, мешки)
  divisible, 
  /// Неделимый (крупногабаритный блок)
  indivisible, 
  /// Наливной (жидкости в цистерне)
  liquid 
}

/// Тип поддона (паллета)
enum PalletType { 
  /// Евро-паллет (800x1200)
  euro, 
  /// Финский паллет (1000x1200)
  fin, 
  /// Американский паллет (1200x1200)
  usa 
}

/// Класс описания груза
class Cargo {
  final CargoType type;
  final double totalWeight;
  final double? volume;

  Cargo({
    required this.type,
    required this.totalWeight,
    this.volume,
  });
}
