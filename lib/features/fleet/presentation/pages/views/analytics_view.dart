import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../providers/vehicle_provider.dart';
import '../../../domain/entities/vehicle.dart';

class AnalyticsView extends ConsumerStatefulWidget {
  const AnalyticsView({super.key});

  @override
  ConsumerState<AnalyticsView> createState() => _AnalyticsViewState();
}

class _AnalyticsViewState extends ConsumerState<AnalyticsView> {
  String sliceType = 'По автоколоннам';

  @override
  Widget build(BuildContext context) {
    final vehicles = ref.watch(vehicleListProvider);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSliceSelector(),
          const SizedBox(height: 24),
          Expanded(
            child: Row(
              children: [
                Expanded(flex: 2, child: _buildGeneralStats(vehicles)),
                const SizedBox(width: 16),
                Expanded(flex: 3, child: _buildEfficiencyTable(vehicles)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliceSelector() {
    return Row(
      children: [
        const Text('Срез данных:', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(width: 16),
        ...['По автоколоннам', 'По машинам', 'По логистам', 'По механикам'].map((type) => Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: ChoiceChip(
            label: Text(type),
            selected: sliceType == type,
            onSelected: (val) => setState(() => sliceType = type),
          ),
        )),
      ],
    );
  }

  Widget _buildGeneralStats(List<Vehicle> vehicles) {
    final totalRevenue = vehicles.fold(0.0, (sum, v) => sum + v.revenue);
    final totalCosts = vehicles.fold(0.0, (sum, v) => sum + v.fuelCosts + v.maintenanceCosts + v.amortization);
    final totalLoss = vehicles.fold(0.0, (sum, v) => sum + (v.statusDuration.inMinutes / 60.0) * v.hourlyCost);
    final margin = ((totalRevenue - totalCosts) / totalRevenue * 100).toStringAsFixed(1);

    return Column(
      children: [
        _statCard('Общая выручка', totalRevenue, Colors.green),
        const SizedBox(height: 12),
        _statCard('Затраты (ТО, Топливо, Амрт)', totalCosts, Colors.orange),
        const SizedBox(height: 12),
        _statCard('Убытки от простоев', totalLoss, Colors.red),
        const SizedBox(height: 12),
        _statCard('Маржинальность %', double.parse(margin), Colors.blue, isPercent: true),
      ],
    );
  }

  Widget _statCard(String label, double value, Color color, {bool isPercent = false}) {
    final formatter = NumberFormat.currency(locale: 'ru_RU', symbol: '₽', decimalDigits: 0);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(color: Color(0xFF94A3B8))),
            Text(
              isPercent ? '$value%' : formatter.format(value),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEfficiencyTable(List<Vehicle> vehicles) {
    // Logic for grouping by column as example
    final groups = <String, List<Vehicle>>{};
    for (var v in vehicles) {
      groups.putIfAbsent(v.column, () => []).add(v);
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('РЕЙТИНГ ЭФФЕКТИВНОСТИ', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: groups.entries.map((e) {
                  final rev = e.value.fold(0.0, (sum, v) => sum + v.revenue);
                  final km = e.value.fold(0.0, (sum, v) => sum + v.mileage);
                  final rubKm = (rev / km).toStringAsFixed(2);
                  return ListTile(
                    title: Text(e.key, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('Пробег: ${km.toInt()} км | Выручка: ${rev.toInt()} ₽'),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('$rubKm ₽/км', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                        const Text('Эффективность', style: TextStyle(fontSize: 10)),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
