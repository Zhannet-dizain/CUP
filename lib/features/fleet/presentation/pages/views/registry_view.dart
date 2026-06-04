import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/vehicle_provider.dart';
import '../../../domain/entities/vehicle.dart';
import '../../widgets/status_update_modal.dart';

class RegistryView extends ConsumerStatefulWidget {
  const RegistryView({super.key});

  @override
  ConsumerState<RegistryView> createState() => _RegistryViewState();
}

class _RegistryViewState extends ConsumerState<RegistryView> {
  String searchQuery = '';
  String? columnFilter;

  @override
  Widget build(BuildContext context) {
    final vehicles = ref.watch(vehicleListProvider);
    final filteredVehicles = vehicles.where((v) {
      final matchesSearch = v.licensePlate.toLowerCase().contains(searchQuery.toLowerCase()) ||
          v.brandModel.toLowerCase().contains(searchQuery.toLowerCase()) ||
          (v.driver?.toLowerCase().contains(searchQuery.toLowerCase()) ?? false);
      
      // Фильтруем по статусу (в рейсе / на базе)
      final matchesStatus = columnFilter == null || v.status.label == columnFilter;
      return matchesSearch && matchesStatus;
    }).toList();

    // Сортировка: машины с большим пробегом вверху
    final sortedVehicles = List.from(filteredVehicles)..sort((a, b) => b.mileage.compareTo(a.mileage));

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildFilters(),
          const SizedBox(height: 16),
          Expanded(
            child: Card(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    showCheckboxColumn: false,
                    headingTextStyle: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF94A3B8)),
                    columns: const [
                      DataColumn(label: Text('Госномер')),
                      DataColumn(label: Text('Модель')),
                      DataColumn(label: Text('Статус')),
                      DataColumn(label: Text('Водитель')),
                      DataColumn(label: Text('Колонна')),
                      DataColumn(label: Text('Местоположение')),
                      DataColumn(label: Text('Пробег (км)'), numeric: true),
                    ],
                    rows: sortedVehicles.map((v) {
                      final isCriticalMileage = v.mileage > 100000;
                      
                      return DataRow(
                        onSelectChanged: (_) => _showUpdateModal(v),
                        cells: [
                          DataCell(Text(v.licensePlate, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
                          DataCell(Text(v.brandModel)),
                          DataCell(_buildStatusCell(v)),
                          DataCell(Text(v.driver ?? '-')),
                          DataCell(Text(v.column)),
                          DataCell(Text(v.location)),
                          DataCell(
                            Text(
                              v.mileage.toInt().toString(),
                              style: TextStyle(
                                fontWeight: isCriticalMileage ? FontWeight.bold : FontWeight.normal,
                                color: isCriticalMileage ? Colors.redAccent : Colors.white70,
                              ),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    final filters = ['Все ТС', 'В рейсе', 'На базе'];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: filters.map((label) {
              final isActive = (label == 'Все ТС' && columnFilter == null) || (columnFilter == label);
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: FilterChip(
                  label: Text(label),
                  selected: isActive,
                  onSelected: (bool selected) {
                    setState(() {
                      columnFilter = (label == 'Все ТС') ? null : label;
                    });
                  },
                  selectedColor: const Color(0xFF38BDF8),
                  backgroundColor: const Color(0xFF1E293B),
                  labelStyle: TextStyle(color: isActive ? Colors.white : const Color(0xFF94A3B8)),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          onChanged: (val) => setState(() => searchQuery = val),
          decoration: InputDecoration(
            hintText: 'Поиск по госномеру, модели или водителю...',
            prefixIcon: const Icon(Icons.search, color: Color(0xFF94A3B8)),
            filled: true,
            fillColor: const Color(0xFF1E293B),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 0),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusCell(Vehicle v) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.circle, size: 8, color: v.status.color),
        const SizedBox(width: 6),
        Text(v.status.label, style: TextStyle(color: v.status.color, fontSize: 13)),
      ],
    );
  }

  void _showUpdateModal(Vehicle vehicle) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1E293B),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (context) => StatusUpdateModal(vehicle: vehicle),
    );
  }
}