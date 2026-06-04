enum StatusReason {
  noTrip,
  noDriver,
  breakdown,
  waitingParts,
  waitingLoading,
  waitingUnloading,
  accident,
  selling,
  driverVacation,
  driverDismissal,
  inspection,
  washing,
  managementDecision,
  other,
}

extension StatusReasonExtension on StatusReason {
  String get label {
    switch (this) {
      case StatusReason.noTrip: return 'Нет рейса';
      case StatusReason.noDriver: return 'Нет водителя';
      case StatusReason.breakdown: return 'Поломка';
      case StatusReason.waitingParts: return 'Ожидание запчастей';
      case StatusReason.waitingLoading: return 'Ожидание погрузки';
      case StatusReason.waitingUnloading: return 'Ожидание выгрузки';
      case StatusReason.accident: return 'ДТП';
      case StatusReason.selling: return 'Продажа';
      case StatusReason.driverVacation: return 'Водитель в отпуске';
      case StatusReason.driverDismissal: return 'Увольнение водителя';
      case StatusReason.inspection: return 'ТО / Осмотр';
      case StatusReason.washing: return 'Мойка';
      case StatusReason.managementDecision: return 'Решение руководства';
      case StatusReason.other: return 'Другое';
    }
  }
}