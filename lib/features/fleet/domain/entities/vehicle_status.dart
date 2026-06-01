import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

enum VehicleStatus {
  // Working statuses (Greenish)
  inTransit(0xFF10B981, 'В пути', LucideIcons.truck),
  washing(0xFF22C55E, 'На мойке', LucideIcons.droplets),
  serviceable(0xFF34D399, 'Исправна', LucideIcons.checkCircle),

  // Waiting/Intermediate statuses (Blueish/Cyan)
  waitingLoading(0xFF38BDF8, 'Ожидание погрузки', LucideIcons.package),
  waitingUnloading(0xFF60A5FA, 'Ожидание выгрузки', LucideIcons.packageCheck),
  driverResting(0xFF818CF8, 'Водитель на отдыхе', LucideIcons.coffee),
  customsClearance(0xFF0EA5E9, 'Таможенное оформление', LucideIcons.fileSearch),
  disinfection(0xFF2DD4BF, 'На дезинфекции', LucideIcons.shieldCheck),

  // Delay/Problem statuses (Yellow/Orange/Purple)
  waitingRepair(0xFFFBBF24, 'Ожидает ремонта', LucideIcons.clock),
  waitingParts(0xFFF59E0B, 'Ожидает запчасть', LucideIcons.settings),
  maintenance(0xFFA855F7, 'Плановое ТО', LucideIcons.wrench),
  idleNoDriver(0xFF94A3B8, 'Простой без водителя', LucideIcons.userMinus),
  documentsBlocked(0xFF6366F1, 'Документы (Блокировка)', LucideIcons.fileLock),

  // Critical statuses (Reddish)
  underRepair(0xFFF87171, 'На ремонте', LucideIcons.hammer),
  accident(0xFFB91C1C, 'ДТП', LucideIcons.alertTriangle),
  noDriver(0xFFEF4444, 'Нет водителя', LucideIcons.userX),
  driverResigned(0xFFDC2626, 'Водитель уволился', LucideIcons.userMinus),

  // Terminal/Other
  selling(0xFFEC4899, 'Продажа', LucideIcons.tag),
  reserve(0xFF64748B, 'В резерве', LucideIcons.archive);

  final int colorValue;
  final String label;
  final IconData icon;

  const VehicleStatus(this.colorValue, this.label, this.icon);

  Color get color => Color(colorValue);
}
