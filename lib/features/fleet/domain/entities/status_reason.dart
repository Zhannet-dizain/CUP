enum StatusReason {
  noTrip('Нет рейса'),
  noDriver('Простой без водителя'),
  breakdown('Поломка в рейсе'),
  waitingParts('Ожидание запчастей'),
  waitingLoading('Ожидание погрузки'),
  waitingUnloading('Ожидание выгрузки'),
  accident('ДТП'),
  selling('Продажа ТС'),
  driverVacation('Водитель в отпуске'),
  driverDismissal('Увольнение водителя'),
  inspection('Плановое ТО / Техосмотр'),
  washing('На дезинфекции / Мойке'),
  managementDecision('Решение руководства'),
  other('Прочая причина');

  final String label;
  const StatusReason(this.label);
}