import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/vehicle_provider.dart';
import '../../domain/entities/vehicle_status.dart';
import '../../domain/entities/vehicle.dart';
import '../widgets/status_update_modal.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  bool isGridView = true;
  String searchQuery = '';
  VehicleStatus? statusFilter;
  String? columnFilter;

  @override
  Widget build(BuildContext context) {
    final vehicles = ref.watch(vehicleListProvider);
    final filteredVehicles = vehicles.where((v) {
      final matchesSearch = v.licensePlate.toLowerCase().contains(searchQuery.toLowerCase()) ||
          v.brandModel.toLowerCase().contains(searchQuery.toLowerCase()) ||
          (v.driver?.toLowerCase().contains(searchQuery.toLowerCase()) ?? false);
      final matchesStatus = statusFilter == null || v.status == statusFilter;
      final matchesColumn = columnFilter == null || v.column == columnFilter;
      return matchesSearch && matchesStatus && matchesColumn;
    }).toList();

    final columns = vehicles.map((v) => v.column).toSet().toList()..sort();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fleet Management Dashboard', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),
      body: Column(
        children: [
          _buildKPIOverview(vehicles),
          _buildFilters(columns),
          Expanded(
            child: isGridView
                ? _buildGridView(filteredVehicles)
                : _buildTableView(filteredVehicles),
          ),
        ],
      ),
    );
  }

  Widget _buildKPIOverview(List<Vehicle> vehicles) {
    final total = vehicles.length;
    final inTransit = vehicles.where((v) => v.status == VehicleStatus.inTransit).length;
    final underRepair = vehicles.where((v) =>
        v.status == VehicleStatus.underRepair ||
        v.status == VehicleStatus.waitingRepair ||
        v.status == VehicleStatus.waitingParts ||
        v.status == VehicleStatus.maintenance).length;
    final idle = vehicles.where((v) =>
        v.status == VehicleStatus.idleNoDriver ||
        v.status == VehicleStatus.noDriver ||
        v.status == VehicleStatus.driverResigned ||
        v.status == VehicleStatus.reserve).length;
    final criticalRisks = vehicles.where((v) =>
        v.status == VehicleStatus.accident ||
        (v.status == VehicleStatus.idleNoDriver && v.statusDuration.inHours > 4)).length;

    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Colors.grey[50],
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _kpiCard('Всего ТС', total.toString(), Icons.directions_car, Colors.blue),
            _kpiCard('В пути', inTransit.toString(), Icons.local_shipping, Colors.green),
            _kpiCard('В ремонте/ТО', underRepair.toString(), Icons.build, Colors.orange),
            _kpiCard('В простое', idle.toString(), Icons.timer, Colors.blueGrey),
            _kpiCard('КРИТ. РИСКИ', criticalRisks.toString(), Icons.warning, Colors.red, isCritical: criticalRisks > 0),
          ],
        ),
      ),
    );
  }

  Widget _kpiCard(String label, String value, IconData icon, Color color, {bool isCritical = false}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: 160,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: color, size: 24),
                if (isCritical)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10)),
                    child: const Text('!', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10)),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }

  Widget _buildFilters(List<String> columns) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search license plate, driver, brand...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
              onChanged: (value) => setState(() => searchQuery = value),
            ),
          ),
          const SizedBox(width: 12),
          _buildStatusFilter(),
          const SizedBox(width: 12),
          _buildColumnFilter(columns),
          const SizedBox(width: 12),
          IconButton(
            icon: Icon(isGridView ? Icons.view_list : Icons.grid_view),
            onPressed: () => setState(() => isGridView = !isGridView),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusFilter() {
     return DropdownButton<VehicleStatus>(
       hint: const Text('Status'),
       value: statusFilter,
       underline: Container(),
       items: [
         const DropdownMenuItem(value: null, child: Text('All Statuses')),
         ...VehicleStatus.values.map((s) => DropdownMenuItem(value: s, child: Text(s.label))),
       ],
       onChanged: (val) => setState(() => statusFilter = val),
     );
  }

  Widget _buildColumnFilter(List<String> columns) {
    return DropdownButton<String>(
      hint: const Text('Column'),
      value: columnFilter,
      underline: Container(),
      items: [
        const DropdownMenuItem(value: null, child: Text('All Columns')),
        ...columns.map((c) => DropdownMenuItem(value: c, child: Text(c))),
      ],
      onChanged: (val) => setState(() => columnFilter = val),
    );
  }

  Widget _buildGridView(List<Vehicle> vehicles) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 400,
        mainAxisExtent: 220,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: vehicles.length,
      itemBuilder: (context, index) => _vehicleCard(vehicles[index]),
    );
  }

  Widget _vehicleCard(Vehicle vehicle) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () => _showUpdateModal(vehicle),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: vehicle.status.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: vehicle.status.color),
                    ),
                    child: Text(
                      vehicle.status.label,
                      style: TextStyle(color: vehicle.status.color, fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ),
                  Text(
                    _formatDuration(vehicle.statusDuration),
                    style: TextStyle(fontSize: 12, color: Colors.grey[600], fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(vehicle.licensePlate, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text(vehicle.brandModel, style: TextStyle(fontSize: 14, color: Colors.grey[700])),
              const Spacer(),
              Row(
                children: [
                  const Icon(Icons.person, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(vehicle.driver ?? 'No driver', style: const TextStyle(fontSize: 13)),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.location_on, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      vehicle.location,
                      style: const TextStyle(fontSize: 13),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTableView(List<Vehicle> vehicles) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          showCheckboxColumn: false,
          columns: const [
            DataColumn(label: Text('License Plate')),
            DataColumn(label: Text('Status')),
            DataColumn(label: Text('Duration')),
            DataColumn(label: Text('Driver')),
            DataColumn(label: Text('Column')),
            DataColumn(label: Text('Location')),
          ],
          rows: vehicles.map((v) => DataRow(
            onSelectChanged: (_) => _showUpdateModal(v),
            cells: [
              DataCell(Text(v.licensePlate, style: const TextStyle(fontWeight: FontWeight.bold))),
              DataCell(_statusChip(v.status)),
              DataCell(Text(_formatDuration(v.statusDuration))),
              DataCell(Text(v.driver ?? '-')),
              DataCell(Text(v.column)),
              DataCell(Text(v.location)),
            ],
          )).toList(),
        ),
      ),
    );
  }

  Widget _statusChip(VehicleStatus status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: status.color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.label,
        style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    return '${hours}h ${minutes}m';
  }

  void _showUpdateModal(Vehicle vehicle) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => StatusUpdateModal(vehicle: vehicle),
    );
  }
}
