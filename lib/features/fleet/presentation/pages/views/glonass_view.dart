import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../providers/vehicle_provider.dart';
import '../../../domain/entities/vehicle.dart';

class GlonassView extends ConsumerWidget {
  const GlonassView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vehicles = ref.watch(vehicleListProvider);
    final movingVehicles = vehicles.where((v) => v.lat != 0 && v.lng != 0).toList();

    return Stack(
      children: [
        FlutterMap(
          options: const MapOptions(
            initialCenter: LatLng(55.7558, 37.6173),
            initialZoom: 5.0,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.app',
            ),
            MarkerLayer(
              markers: movingVehicles.map((v) => Marker(
                point: LatLng(v.lat, v.lng),
                width: 40,
                height: 40,
                child: GestureDetector(
                  onTap: () => _showVehicleInfo(context, v),
                  child: Icon(
                    Icons.local_shipping,
                    color: v.status.color,
                    size: 30,
                  ),
                ),
              )).toList(),
            ),
          ],
        ),
        Positioned(
          top: 16,
          right: 16,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF334155)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('ТЕЛЕМАТИКА: СКАУТ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                const SizedBox(height: 8),
                Text('Активных ТС: ${movingVehicles.length}', style: const TextStyle(fontSize: 11)),
                Text('В движении: ${movingVehicles.where((v) => v.speed > 0).length}', style: const TextStyle(fontSize: 11)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showVehicleInfo(BuildContext context, Vehicle v) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: Text(v.licensePlate, style: const TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _infoRow('Водитель:', v.driver ?? '-'),
            _infoRow('Статус:', v.status.label),
            _infoRow('Скорость:', '${v.speed.toInt()} км/ч'),
            _infoRow('Топливо:', '${v.fuelLevel.toInt()}%'),
            _infoRow('Координаты:', '${v.lat.toStringAsFixed(4)}, ${v.lng.toStringAsFixed(4)}'),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Закрыть')),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(label, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13)),
          const SizedBox(width: 8),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
