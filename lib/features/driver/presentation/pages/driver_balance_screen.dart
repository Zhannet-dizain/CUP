import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/driver_provider.dart';
import '../../domain/entities/driver_earnings.dart';
import '../widgets/axle_calc_dialog.dart';

class DriverBalanceScreen extends ConsumerWidget {
  const DriverBalanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final earnings = ref.watch(driverEarningsNotifierProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('ЗАРАБОТНАЯ ПЛАТА',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPaymentCalendar(context),
            const SizedBox(height: 20),
            _buildMileageKpi(earnings),
            const SizedBox(height: 20),
            _buildEarningsCalculator(earnings),
            const SizedBox(height: 32),
            _buildAdvancedTools(context),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentCalendar(BuildContext context) {
    final now = DateTime.now();

    String getPaymentText(int day, String label) {
      DateTime paymentDate = DateTime(now.year, now.month, day);
      if (paymentDate.isBefore(DateTime(now.year, now.month, now.day))) {
         paymentDate = DateTime(now.year, now.month + 1, day);
      }

      bool isWeekend = paymentDate.weekday == DateTime.saturday || paymentDate.weekday == DateTime.sunday;

      if (isWeekend) {
        int subtractDays = paymentDate.weekday == DateTime.saturday ? 1 : 2;
        DateTime adjustedDate = paymentDate.subtract(Duration(days: subtractDays));
        return '$label: перенесена на Пятницу (${DateFormat('dd.MM').format(adjustedDate)})';
      }

      return '$label: ${DateFormat('dd.MM').format(paymentDate)}';
    }

    return Card(
      color: const Color(0xFF1E293B),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Color(0xFF334155))),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Календарь выплат',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _calendarItem('Суточные', 'каждый Вторник'),
            _calendarItem('Аванс', getPaymentText(30, 'Выплата 30-го')),
            _calendarItem('Зарплата', getPaymentText(15, 'Выплата 15-го')),
          ],
        ),
      ),
    );
  }

  Widget _calendarItem(String title, String trailing) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Color(0xFF94A3B8))),
          Text(trailing,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildMileageKpi(DriverEarnings earnings) {
    double progress = earnings.currentMonthKmDriven / earnings.kmTarget;
    if (progress > 1.0) progress = 1.0;

    final months = [
      'Январе', 'Феврале', 'Марте', 'Апреле', 'Мае', 'Июне',
      'Июле', 'Августе', 'Сентябре', 'Октябре', 'Ноябре', 'Декабре'
    ];
    final String currentMonthName = months[DateTime.now().month - 1];

    return Card(
      color: const Color(0xFF1E293B),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Color(0xFF334155))),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Заработано в $currentMonthName (текущий месяц)',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: const Color(0xFF334155),
              color: const Color(0xFF38BDF8),
              minHeight: 12,
              borderRadius: BorderRadius.circular(6),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Выполнено: ${earnings.currentMonthKmDriven.toInt()} км',
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
                Text(
                  'Цель: ${earnings.kmTarget.toInt()} км',
                  style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEarningsCalculator(DriverEarnings earnings) {
    final kmEarnings = earnings.currentMonthKmDriven * earnings.perKmRate;
    final totalGross = kmEarnings + earnings.accumulatedDailyAllowances + earnings.currentBonuses - earnings.currentDeductions;
    final ndfl = totalGross * 0.13;
    final totalNet = totalGross - ndfl;

    final formatter = NumberFormat.currency(locale: 'ru_RU', symbol: '₽', decimalDigits: 0);

    return Card(
      color: const Color(0xFF1E293B),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Color(0xFF334155))),
      child: Theme(
        data: ThemeData.dark().copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: const Text('Детализация начислений',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
          childrenPadding: const EdgeInsets.all(16),
          children: [
            _calcRow('За пробег (${earnings.currentMonthKmDriven.toInt()} км × ${earnings.perKmRate} ₽)', kmEarnings),
            _calcRow('Суточные (к выплате)', earnings.accumulatedDailyAllowances),
            _calcRow('Бонусы СКАУТ/Документы', earnings.currentBonuses, color: Colors.greenAccent),
            _calcRow('Удержания (Штрафы)', -earnings.currentDeductions, color: Colors.redAccent),
            const Divider(color: Color(0xFF334155), height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('К выплате (чистыми)',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                    Text('за вычетом НДФЛ 13%',
                        style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
                  ],
                ),
                Text(formatter.format(totalNet),
                    style: const TextStyle(
                        color: Color(0xFF22C55E),
                        fontSize: 24,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _calcRow(String label, double value, {Color? color}) {
    final formatter = NumberFormat.currency(locale: 'ru_RU', symbol: '₽', decimalDigits: 0);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(label, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13))),
          Text(formatter.format(value),
              style: TextStyle(color: color ?? Colors.white, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildAdvancedTools(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'ПРОФЕССИОНАЛЬНЫЕ ИНСТРУМЕНТЫ',
          style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.2),
        ),
        const SizedBox(height: 16),
        InkWell(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => const AxleCalcDialog(),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF334155)),
              gradient: LinearGradient(
                colors: [const Color(0xFF1E293B), const Color(0xFF1E293B).withOpacity(0.8)],
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF38BDF8).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons. balance, color: Color(0xFF38BDF8), size: 32),
                ),
                const SizedBox(width: 20),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Калькулятор развесовки',
                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Расчет осевых нагрузок по закону РФ №2200',
                        style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: Color(0xFF64748B)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF334155).withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Icon(Icons.info_outline, color: Color(0xFF38BDF8), size: 20),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Финансовые вопросы решаются лично с начальником колонны.',
                  style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
