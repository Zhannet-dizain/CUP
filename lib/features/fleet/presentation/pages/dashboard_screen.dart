import '../../../driver/presentation/pages/driver_balance_screen.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/navigation_provider.dart';
import 'views/monitoring_view.dart';
import 'views/registry_view.dart';
import 'views/analytics_view.dart';
import 'views/glonass_view.dart';
import 'views/api_gateway_view.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  late Timer _timer;
  DateTime _currentTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _currentTime = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activeTab = ref.watch(navigationProvider);

    return Scaffold(
      appBar: _buildHeader(),
      body: Column(
        children: [
          _buildNavigationMenu(activeTab),
          Expanded(
            child: _buildActiveView(activeTab),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildHeader() {
    return AppBar(
      titleSpacing: 0,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          children: [
            const Icon(Icons.circle, color: Color(0xFF22C55E), size: 32),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ЦУП Автопарка v1.2 MVP+',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                Text(
                  'Система мониторинга статусов и контроля простоев',
                  style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
                ),
              ],
            ),
            const Spacer(),
            Column(
              children: [
                Text(
                  DateFormat('HH:mm:ss').format(_currentTime),
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'monospace'),
                ),
                const Text('UTC+3 МСК', style: TextStyle(fontSize: 10)),
              ],
            ),
            const SizedBox(width: 24),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.sync, size: 18),
              label: const Text('Синхронизировать с 1С'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E293B),
                foregroundColor: Colors.white,
                side: const BorderSide(color: Color(0xFF334155)),
              ),
            ),
            const Spacer(),
            
            // --- НАША КНОПКА ПЕРЕХОДА В КОШЕЛЕК ВОДИТЕЛЯ ---
            TextButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  DriverBalanceScreen()),
                );
              },
              icon: const Icon(Icons.account_balance_wallet, color: Color(0xFF38BDF8), size: 18),
              label: const Text('Кабинет водителя', style: TextStyle(color: Color(0xFF38BDF8))),
            ),
            const SizedBox(width: 24),
            
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text('Диспетчер парка', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    Text('Смирнова А.В.', style: TextStyle(fontSize: 12, color: Colors.grey[300])),
                  ],
                ),
                const SizedBox(width: 12),
                const CircleAvatar(
                  radius: 18,
                  backgroundColor: Color(0xFF334155),
                  child: Icon(Icons.person, color: Colors.white, size: 20),
                ),
              ],
            ),
            const SizedBox(width: 16),
            Stack(
              children: [
                const Icon(Icons.notifications_none, size: 28),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10)),
                    constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                    child: const Text('3', style: TextStyle(color: Colors.white, fontSize: 10), textAlign: TextAlign.center),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationMenu(FleetTab activeTab) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFF0F172A),
        border: Border(bottom: BorderSide(color: Color(0xFF334155))),
      ),
      child: Row(
        children: [
          _navItem('ДИСПЕТЧЕРСКАЯ (МОНИТОРИНГ)', FleetTab.monitoring, activeTab),
          _navItem('РЕЕСТР ТС (СТАТУСЫ)', FleetTab.registry, activeTab),
          _navItem('KPI & АНАЛИТИКА', FleetTab.analytics, activeTab),
          _navItem('ГЛОНАСС & АВТОМАТИЗАЦИЯ', FleetTab.glonass, activeTab),
          _navItem('REST API ШЛЮЗ', FleetTab.apiGateway, activeTab),
        ],
      ),
    );
  }

  Widget _navItem(String label, FleetTab tab, FleetTab activeTab) {
    final isActive = tab == activeTab;
    return InkWell(
      onTap: () => ref.read(navigationProvider.notifier).setTab(tab),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isActive ? const Color(0xFF38BDF8) : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? const Color(0xFF38BDF8) : const Color(0xFF94A3B8),
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildActiveView(FleetTab activeTab) {
    switch (activeTab) {
      case FleetTab.monitoring:
        return const MonitoringView();
      case FleetTab.registry:
        return const RegistryView();
      case FleetTab.analytics:
        return const AnalyticsView();
      case FleetTab.glonass:
        return const GlonassView();
      case FleetTab.apiGateway:
        return const ApiGatewayView();
    }
  }
}
