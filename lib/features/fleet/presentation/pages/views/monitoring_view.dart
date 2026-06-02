import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../providers/vehicle_provider.dart';
import '../../../domain/entities/vehicle_status.dart';
import '../../../domain/entities/vehicle.dart';
import '../../../domain/entities/fleet_event.dart';
import '../../widgets/status_update_modal.dart';

class MonitoringView extends ConsumerWidget {
  const MonitoringView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vehicles = ref.watch(vehicleListProvider);
    final events = ref.watch(fleetEventsProvider);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildFleetReadinessPanel(vehicles),
          const SizedBox(height: 16),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: _buildRiskControlSection(context, vehicles),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: _buildDispatcherFeedSection(events),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFleetReadinessPanel(List<Vehicle> vehicles) {
    final readyCount = vehicles.where((v) => v.status == VehicleStatus.serviceable || v.status == VehicleStatus.inTransit).length;
    final readinessPercent = vehicles.isEmpty ? "0.0" : (readyCount / vehicles.length * 100).toStringAsFixed(1);
    
    final riskCount = vehicles.where((v) => 
      v.status == VehicleStatus.accident || 
      v.status == VehicleStatus.underRepair ||
      v.status == VehicleStatus.waitingRepair ||
      v.status == VehicleStatus.waitingParts ||
      v.status == VehicleStatus.idleNoDriver ||
      v.status == VehicleStatus.documentsBlocked ||
      v.fuelLevel < 20 ||
      v.engineTemp > 100
    ).length;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Готовность флота', style: TextStyle(fontSize: 14, color: Color(0xFF94A3B8))),
                    Text('$readinessPercent%', style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Color(0xFF22C55E))),
                  ],
                ),
                const SizedBox(width: 40),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.warning_amber_rounded, color: Color(0xFFFBBF24), size: 20),
                          const SizedBox(width: 8),
                          Text('Требуется вмешательство: $riskCount ТС в критическом простое', style: const TextStyle(color: Color(0xFFFBBF24))),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text('Среднее время перевода в "Ремонт" сократилось на 12% за сегодня.', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildColorTimeline(vehicles),
          ],
        ),
      ),
    );
  }

  Widget _buildColorTimeline(List<Vehicle> vehicles) {
    // Simplified category grouping for visualization
    final categories = {
      const Color(0xFF22C55E): [VehicleStatus.inTransit, VehicleStatus.serviceable, VehicleStatus.washing],
      const Color(0xFF38BDF8): [VehicleStatus.waitingLoading, VehicleStatus.waitingUnloading, VehicleStatus.driverResting, VehicleStatus.customsClearance, VehicleStatus.disinfection],
      const Color(0xFFFBBF24): [VehicleStatus.waitingRepair, VehicleStatus.waitingParts, VehicleStatus.maintenance, VehicleStatus.idleNoDriver, VehicleStatus.documentsBlocked],
      const Color(0xFFEF4444): [VehicleStatus.underRepair, VehicleStatus.accident, VehicleStatus.noDriver, VehicleStatus.driverResigned],
    };

    return Container(
      height: 12,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: const Color(0xFF334155),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Row(
          children: categories.entries.map((entry) {
            final count = vehicles.where((v) => entry.value.contains(v.status)).length;
            if (count == 0) return const SizedBox.shrink();
            return Expanded(
              flex: count,
              child: Container(color: entry.key),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildRiskControlSection(BuildContext context, List<Vehicle> vehicles) {
    final riskVehicles = vehicles.where((v) => 
      v.status == VehicleStatus.accident || 
      v.status == VehicleStatus.underRepair ||
      v.status == VehicleStatus.waitingRepair ||
      v.status == VehicleStatus.waitingParts ||
      v.status == VehicleStatus.idleNoDriver ||
      v.status == VehicleStatus.documentsBlocked ||
      v.fuelLevel < 20 ||
      v.engineTemp > 100
    ).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 12.0),
          child: Text('КОНТРОЛЬ РИСКОВ ПРОСТОЕВ', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2)),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: riskVehicles.length,
            itemBuilder: (context, index) => _buildRiskCard(context, riskVehicles[index]),
          ),
        ),
      ],
    );
  }

  Widget _buildRiskCard(BuildContext context, Vehicle vehicle) {
    final isCritical = vehicle.status == VehicleStatus.accident || vehicle.engineTemp > 100;
    final loss = (vehicle.statusDuration.inMinutes / 60.0) * vehicle.hourlyCost;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () => _showUpdateModal(context, vehicle),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 60,
                color: isCritical ? Colors.red : Colors.orange,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(vehicle.licensePlate, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(width: 8),
                        Text(vehicle.brandModel, style: TextStyle(fontSize: 12, color: const Color(0xFF94A3B8))),
                        const Spacer(),
                        if (loss > 0)
                           Text(
                             'Убыток: ${NumberFormat.currency(locale: 'ru_RU', symbol: '₽', decimalDigits: 0).format(loss)}',
                             style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14),
                           ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.person, size: 14, color: Color(0xFF64748B)),
                        const SizedBox(width: 4),
                        Text(vehicle.driver ?? '-', style: const TextStyle(fontSize: 12)),
                        const SizedBox(width: 16),
                        _buildWarningBadge(vehicle),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWarningBadge(Vehicle vehicle) {
    if (vehicle.status == VehicleStatus.accident) {
      return const _Badge(text: 'ДТП', color: Colors.red, icon: Icons.report_problem);
    }
    if (vehicle.engineTemp > 100) {
      return _Badge(text: 'Температура ДВС: ${vehicle.engineTemp.toInt()}°C!', color: Colors.red, icon: Icons.thermostat);
    }
    if (vehicle.fuelLevel < 20) {
      return _Badge(text: 'Низкое топливо: ${vehicle.fuelLevel.toInt()}%', color: Colors.orange, icon: Icons.local_gas_station);
    }
    return _Badge(text: vehicle.status.label, color: vehicle.status.color, icon: vehicle.status.icon);
  }

  Widget _buildDispatcherFeedSection(List<FleetEvent> events) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 12.0),
          child: Text('ЛЕНТА ДИСПЕТЧЕРА', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2)),
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF334155)),
            ),
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: events.length,
              itemBuilder: (context, index) => _buildFeedItem(events[index]),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFeedItem(FleetEvent event) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Icon(Icons.circle, size: 10, color: event.newStatus.color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(event.licensePlate, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    const SizedBox(width: 8),
                    Text(
                      DateFormat('HH:mm').format(event.timestamp),
                      style: TextStyle(fontSize: 11, color: const Color(0xFF94A3B8)),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF334155),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        event.initiatorRole,
                        style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Перевод ТС из ${event.oldStatus.label} в ${event.newStatus.label}',
                  style: const TextStyle(fontSize: 12),
                ),
                if (event.reason != null)
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    padding: const EdgeInsets.all(6),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F172A),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Причина: ${event.reason}',
                      style: TextStyle(fontSize: 11, color: const Color(0xFFCBD5E1), fontStyle: FontStyle.italic),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showUpdateModal(BuildContext context, Vehicle vehicle) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1E293B),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (context) => StatusUpdateModal(vehicle: vehicle),
    );
  }
}

class _Badge extends StatelessWidget {
  final String text;
  final Color color;
  final IconData icon;

  const _Badge({required this.text, required this.color, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(text, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
