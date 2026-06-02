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
      final matchesColumn = columnFilter == null || v.column == columnFilter;
      return matchesSearch && matchesColumn;
    }).toList();

    final columns = vehicles.map((v) => v.column).toSet().toList()..sort();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildFilters(columns),
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
                      DataColumn(label: Text('Пробег (км)')),
                    ],
                    rows: filteredVehicles.map((v) => DataRow(
                      onSelectChanged: (_) => _showUpdateModal(v),
                      cells: [
                        DataCell(Text(v.licensePlate, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
                        DataCell(Text(v.brandModel)),
                        DataCell(_statusChip(v)),
                        DataCell(Text(v.driver ?? '-')),
                        DataCell(Text(v.column)),
                        DataCell(Text(v.location)),
                        DataCell(Text(v.mileage.toInt().toString())),
                      ],
                    )).toList(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters(List<String> columns) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            onChanged: (val) => setState(() => searchQuery = val),
            decoration: InputDecoration(
              hintText: 'Поиск по госномеру, модели или водителю...',
              prefixIcon: const Icon(Icons.search, color: Color(0xFF94A3B8)),
              filled: true,
              fillColor: const Color(0xFF1E293B),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFF334155)),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFF334155)),
          ),
          child: DropdownButton<String>(
            value: columnFilter,
            hint: const Text('Все колонны', style: TextStyle(color: Color(0xFF94A3B8))),
            underline: const SizedBox(),
            dropdownColor: const Color(0xFF1E293B),
            items: [
              const DropdownMenuItem(value: null, child: Text('Все колонны')),
              ...columns.map((c) => DropdownMenuItem(value: c, child: Text(c))),
            ],
            onChanged: (val) => setState(() => columnFilter = val),
          ),
        ),
      ],
    );
  }

  Widget _statusChip(Vehicle v) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: v.status.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: v.status.color.withOpacity(0.5)),
      ),
      child: Text(
        v.status.label,
        style: TextStyle(color: v.status.color, fontSize: 11, fontWeight: FontWeight.bold),
      ),
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
