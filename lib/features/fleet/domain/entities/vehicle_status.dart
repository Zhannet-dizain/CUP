import 'package:flutter/material.dart';

enum VehicleStatus {
  waitingLoading(0xFF38BDF8, 'Ожидание погрузки'),
  inTransit(0xFF10B981, 'В пути'),
  waitingUnloading(0xFF60A5FA, 'Ожидание выгрузки'),
  underRepair(0xFFF87171, 'На ремонте'),
  waitingRepair(0xFFFBBF24, 'Ожидает ремонта'),
  waitingParts(0xFFF59E0B, 'Ожидает запчасть'),
  idleNoDriver(0xFF94A3B8, 'В простое без водителя'),
  noDriver(0xFFCBD5E1, 'Нет водителя'),
  driverResigned(0xFFEF4444, 'Водитель уволился'),
  driverResting(0xFF818CF8, 'Водитель на отдыхе'),
  maintenance(0xFFA855F7, 'На ТО'),
  washing(0xFF22C55E, 'На мойке'),
  reserve(0xFF64748B, 'В резерве'),
  notReleased(0xFF475569, 'Не выпущена на линию'),
  serviceable(0xFF34D399, 'Исправна'),
  accident(0xFFB91C1C, 'ДТП'),
  selling(0xFFEC4899, 'Продажа');

  final int colorValue;
  final String label;

  const VehicleStatus(this.colorValue, this.label);

  Color get color => Color(colorValue);
}
