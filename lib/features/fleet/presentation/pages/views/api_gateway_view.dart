import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/vehicle_provider.dart';

class ApiGatewayView extends ConsumerWidget {
  const ApiGatewayView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('REST API ШЛЮЗ & ДОКУМЕНТАЦИЯ', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ElevatedButton.icon(
                onPressed: () => _simulateWebhook(context, ref),
                icon: const Icon(Icons.bolt),
                label: const Text('Test Webhook (Имитировать ГЛОНАСС)'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, foregroundColor: Colors.black),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text('Интеграционная шина данных для 1С:ТЛЭ / 1С:ЭПД', style: TextStyle(color: Color(0xFF94A3B8))),
          const SizedBox(height: 24),
          Expanded(
            child: Row(
              children: [
                Expanded(child: _buildApiSection('GET /api/v1/vehicles', _jsonVehicles)),
                const SizedBox(width: 16),
                Expanded(child: _buildApiSection('POST /api/v1/webhook/telemetry', _jsonWebhook)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildApiSection(String title, String json) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF38BDF8), fontFamily: 'monospace')),
            const SizedBox(height: 12),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F172A),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: SingleChildScrollView(
                  child: Text(
                    json,
                    style: const TextStyle(fontFamily: 'monospace', fontSize: 12, color: Color(0xFF2DD4BF)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _simulateWebhook(BuildContext context, WidgetRef ref) {
    ref.read(vehicleListProvider.notifier).simulateTelemetryUpdate(
      vehicleId: '1',
      newLat: 56.4,
      newLng: 36.8,
      newSpeed: 95.0,
      newTemp: 105.0, // Critical temperature
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Webhook TEST: Машина А112АА 797 - Сбой датчика температуры (105°C)'),
        backgroundColor: Colors.red,
      ),
    );
  }

  final String _jsonVehicles = '''
{
  "status": "success",
  "data": [
    {
      "id": "1",
      "licensePlate": "А112АА 797",
      "status": "inTransit",
      "telemetry": {
        "lat": 56.3316,
        "lng": 36.7289,
        "speed": 78.0,
        "fuel": 45
      }
    },
    ...
  ]
}''';

  final String _jsonWebhook = '''
{
  "event": "telemetry_update",
  "vehicleId": "1",
  "payload": {
    "lat": 56.3316,
    "lng": 36.7289,
    "speed": 78.0,
    "fuel": 45,
    "temp": 82
  }
}''';
}
