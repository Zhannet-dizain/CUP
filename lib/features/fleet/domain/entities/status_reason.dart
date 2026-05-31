enum StatusReason {
  noTrip('Нет рейса'),
  noDriver('Нет водителя'),
  breakdown('Поломка'),
  waitingParts('Ожидание запчастей'),
  waitingLoading('Ожидание загрузки'),
  waitingUnloading('Ожидание выгрузки'),
  accident('ДТП'),
  selling('В продаже'),
  driverVacation('Отпуск водителя'),
  driverDismissal('Увольнение водителя'),
  inspection('Техосмотр'),
  washing('Мойка'),
  managementDecision('Простой по решению руководства'),
  other('Прочее');

  final String label;
  const StatusReason(this.label);
}
