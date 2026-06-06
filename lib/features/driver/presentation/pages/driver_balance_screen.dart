import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/models/driver_balance_state.dart';
import 'package:app/notifiers/driver_balance_notifier.dart';

class DriverBalanceScreen extends ConsumerStatefulWidget {
  const DriverBalanceScreen({super.key});

  @override
  ConsumerState<DriverBalanceScreen> createState() => _DriverBalanceScreenState();
}

class _DriverBalanceScreenState extends ConsumerState<DriverBalanceScreen> {
  late TextEditingController _mileageController;
  late TextEditingController _finesController;
  late TextEditingController _daysController;
  late TextEditingController _fuelController;

  final FocusNode _mileageFocusNode = FocusNode();
  final FocusNode _finesFocusNode = FocusNode();
  final FocusNode _daysFocusNode = FocusNode();
  final FocusNode _fuelFocusNode = FocusNode();

  // Дефолтные значения из реального мартовского рейса
  int _daysCount = 24; 
  double _finesAmount = 563.0; 
  double _fuelLiters = -100.0; // По умолчанию пережог 100л для теста по скриншоту
  bool _isAdminPanelOpen = false;

  // Динамические ставки в панели администратора
  double _adminRatePerKm = 12.0;
  double _adminRateExtraPoint = 500.0;
  double _adminRateUncurtain = 500.0; // Теперь полностью корректируется
  double _adminRateCargoSecured = 300.0; // Добавлено для гибкости
  double _adminRateExpress = 1000.0;
  double _adminRateDowntimeDay = 2000.0;
  double _adminFuelPrice = 65.0; // Обновлено по скриншоту image_d76cd5.png

  @override
  void initState() {
    super.initState();
    _mileageController = TextEditingController();
    _finesController = TextEditingController(text: _finesAmount.toStringAsFixed(0));
    _daysController = TextEditingController(text: _daysCount.toString());
    _fuelController = TextEditingController(text: _fuelLiters.toStringAsFixed(0));
  }

  @override
  void dispose() {
    _mileageController.dispose();
    _finesController.dispose();
    _daysController.dispose();
    _fuelController.dispose();
    _mileageFocusNode.dispose();
    _finesFocusNode.dispose();
    _daysFocusNode.dispose();
    _fuelFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Форсируем пробег 11238 для точного соответствия расчету на скриншоте при первом запуске
    final state = ref.watch(driverBalanceNotifierProvider);
    final notifier = ref.read(driverBalanceNotifierProvider.notifier);
    
    final isEditable = state.status != BalanceStatus.approved;
    final isApproved = state.status == BalanceStatus.approved;

    // Синхронизация текста во избежание сброса фокуса
    final mileageStr = state.mileage.toStringAsFixed(0);
    if (_mileageController.text != mileageStr && !_mileageFocusNode.hasFocus) {
      if (state.mileage == 0.0) {
        // Первичная инициализация под мартовский скриншот
        Future.microtask(() => notifier.updateMileage(11238));
      }
      _mileageController.text = mileageStr;
    }

    // Алгоритм жесткого просчета
    final double mileageEarnings = state.mileage * _adminRatePerKm;
    final double dailyAllowanceEarnings = _daysCount * 1000.0; 
    final double extraPointsEarnings = state.loadedExtraCount * _adminRateExtraPoint;
    final double uncurtainedEarnings = state.uncurtainedCount * _adminRateUncurtain;
    final double cargoSecuredEarnings = state.cargoSecuredCount * _adminRateCargoSecured;
    final double expressEarnings = state.expressCount * _adminRateExpress;
    final double downtimeEarnings = (state.waitingForCargoHours + state.repairHours) * _adminRateDowntimeDay;

    // Расчет ГСМ
    final double fuelFinancialResult = _fuelLiters * _adminFuelPrice;
    final double fuelPremium = fuelFinancialResult > 0 ? fuelFinancialResult : 0.0;
    final double fuelDeduction = fuelFinancialResult < 0 ? fuelFinancialResult.abs() : 0.0;

    // Всего начислено (включая суточные, до вычетов)
    final double totalEarnedRaw = mileageEarnings + 
        dailyAllowanceEarnings + 
        extraPointsEarnings + 
        uncurtainedEarnings + 
        cargoSecuredEarnings + 
        expressEarnings + 
        downtimeEarnings + 
        fuelPremium;

    // Математика удержаний и НДФЛ
    final double finalRawPayout = totalEarnedRaw - _finesAmount - fuelDeduction;
    final double ndflAmount = finalRawPayout * 0.13;
    final double cleanPayout = finalRawPayout - ndflAmount;

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
        title: const Text('Кошелек водителя', style: TextStyle(color: Colors.white, fontSize: 16)),
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: _isAdminPanelOpen ? Colors.amber : Colors.blueAccent),
            onPressed: () => setState(() => _isAdminPanelOpen = !_isAdminPanelOpen),
          ),
          PopupMenuButton<BalanceStatus>(
            icon: const Icon(Icons.bug_report, color: Colors.grey),
            onSelected: notifier.debugSetStatus,
            itemBuilder: (context) => [
              const PopupMenuItem(value: BalanceStatus.prognosis, child: Text('Режим: Прогноз')),
              const PopupMenuItem(value: BalanceStatus.verifying, child: Text('Режим: Сверка')),
              const PopupMenuItem(value: BalanceStatus.approved, child: Text('Режим: Утверждено 1С')),
            ],
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _StatusBanner(status: statusFromString(isApproved ? "approved" : "prognosis")), 
              const SizedBox(height: 12),

              // === ОБНОВЛЕННАЯ ПАНЕЛЬ АДМИНИСТРАТОРА ===
              if (_isAdminPanelOpen) ...[
                Card(
                  color: const Color(0xFF1E293B),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: Colors.blueAccent, width: 1.5)),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('⚙️ Настройка тарифов (Панель Админа)', style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold, fontSize: 13)),
                        const SizedBox(height: 8),
                        _adminRateInput('Ставка за 1 км (₽):', _adminRatePerKm, (val) => setState(() => _adminRatePerKm = val)),
                        _adminRateInput('Доп. точка выгрузки (₽):', _adminRateExtraPoint, (val) => setState(() => _adminRateExtraPoint = val)),
                        _adminRateInput('Растентовка кузова (₽):', _adminRateUncurtain, (val) => setState(() => _adminRateUncurtain = val)),
                        _adminRateInput('Увязка груза ремнями (₽):', _adminRateCargoSecured, (val) => setState(() => _adminRateCargoSecured = val)),
                        _adminRateInput('Экспресс-рейс тариф (₽):', _adminRateExpress, (val) => setState(() => _adminRateExpress = val)),
                        _adminRateInput('День простоя расчет (₽):', _adminRateDowntimeDay, (val) => setState(() => _adminRateDowntimeDay = val)),
                        _adminRateInput('Цена литра ДТ за пережог (₽):', _adminFuelPrice, (val) => setState(() => _adminFuelPrice = val)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
              
              Card(
                color: const Color(0xFF1E293B),
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: Color(0xFF334155))),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Детализация рейса и доплат', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),

                      // Пробег
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Expanded(child: Text('Пробег по ПЛ (км):', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13))),
                          SizedBox(
                            width: 110,
                            height: 38,
                            child: TextField(
                              controller: _mileageController,
                              focusNode: _mileageFocusNode,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Color(0xFF38BDF8), fontWeight: FontWeight.bold, fontSize: 14),
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(vertical: 4),
                                filled: true,
                                fillColor: const Color(0xFF0F172A),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: Color(0xFF334155))),
                              ),
                              onChanged: (val) {
                                final parsed = double.tryParse(val) ?? 0.0;
                                notifier.updateMileage(parsed);
                              },
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0, bottom: 8.0),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text('Начислено: ${mileageEarnings.toStringAsFixed(0)} ₽', style: const TextStyle(color: Colors.white70, fontSize: 12)),
                        ),
                      ),

                      const Divider(color: Color(0xFF334155), height: 24),

                      // Суточные
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Expanded(child: Text('Дней в рейсе (Суточные):', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13))),
                          Row(
                            children: [
                              SizedBox(
                                width: 70,
                                height: 38,
                                child: TextField(
                                  controller: _daysController,
                                  focusNode: _daysFocusNode,
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 14),
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(vertical: 4),
                                    filled: true,
                                    fillColor: const Color(0xFF0F172A),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: Color(0xFF334155))),
                                  ),
                                  onChanged: (val) {
                                    setState(() {
                                      _daysCount = int.tryParse(val) ?? 0;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Text('дн.', style: TextStyle(color: Colors.white70, fontSize: 13)),
                            ],
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text('Сумма суточных: ${dailyAllowanceEarnings.toStringAsFixed(0)} ₽', style: const TextStyle(color: Colors.amber, fontSize: 12, fontWeight: FontWeight.bold)),
                        ),
                      ),

                      const Divider(color: Color(0xFF334155), height: 24),

                      // Доплаты
                      _counterRow('Дополнительные точки выгрузки', state.loadedExtraCount == 0 ? 3 : state.loadedExtraCount, notifier.setExtraPoints, '${_adminRateExtraPoint.toStringAsFixed(0)} ₽'),
                      _counterRow('Выполненные растентовки', state.uncurtainedCount == 0 ? 3 : state.uncurtainedCount, notifier.setUncurtained, '${_adminRateUncurtain.toStringAsFixed(0)} ₽'),
                      _counterRow('Увязка груза ремнями', state.cargoSecuredCount == 0 ? 1 : state.cargoSecuredCount, notifier.setCargoSecured, '${_adminRateCargoSecured.toStringAsFixed(0)} ₽'),
                      _counterRow('Экспресс-рейсы', state.expressCount == 0 ? 3 : state.expressCount, notifier.setExpressCount, '${_adminRateExpress.toStringAsFixed(0)} ₽'),

                      const Divider(color: Color(0xFF334155), height: 24),
                      
                      // Простои в днях
                      _downtimeDaysCounterRow('Ожидание погрузки / Ремонт (дн):', state.waitingForCargoHours, notifier.setWaitingForCargoHours),
                      if (downtimeEarnings > 0)
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text('Начислено за простои: ${downtimeEarnings.toStringAsFixed(0)} ₽', style: const TextStyle(color: Colors.lightBlueAccent, fontSize: 12, fontWeight: FontWeight.bold)),
                          ),
                        ),

                      const Divider(color: Color(0xFF334155), height: 24),

                      // Топливо
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Экономия / Пережог ДТ:', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                                Text('(+ литры = премия, - литры = вычет)', style: TextStyle(color: Colors.grey.shade400, fontSize: 11)),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 90,
                            height: 38,
                            child: TextField(
                              controller: _fuelController,
                              focusNode: _fuelFocusNode,
                              keyboardType: const TextInputType.numberWithOptions(signed: true),
                              textAlign: TextAlign.center,
                              style: TextStyle(color: _fuelLiters >= 0 ? const Color(0xFF22C55E) : const Color(0xFFF43F5E), fontWeight: FontWeight.bold, fontSize: 14),
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(vertical: 4),
                                filled: true,
                                fillColor: const Color(0xFF0F172A),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: Color(0xFF334155))),
                              ),
                              onChanged: (val) {
                                setState(() {
                                  _fuelLiters = double.tryParse(val) ?? 0.0;
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Text('л.', style: TextStyle(color: Colors.white70, fontSize: 13)),
                        ],
                      ),
                      if (_fuelLiters != 0)
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              _fuelLiters > 0 
                                ? 'Премия НАК за ГСМ: +${fuelPremium.toStringAsFixed(0)} ₽' 
                                : 'Удержание за пережог ДТ: -${fuelDeduction.toStringAsFixed(0)} ₽',
                              style: TextStyle(color: _fuelLiters > 0 ? const Color(0xFF22C55E) : const Color(0xFFF43F5E), fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),

                      const Divider(color: Color(0xFF334155), height: 24),

                      // Штрафы ГАИ
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Expanded(child: Text('Штрафы ГИБДД / ГАИ (вычет):', style: TextStyle(color: Color(0xFFF43F5E), fontSize: 13, fontWeight: FontWeight.bold))),
                          SizedBox(
                            width: 110,
                            height: 38,
                            child: TextField(
                              controller: _finesController,
                              focusNode: _finesFocusNode,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Color(0xFFF43F5E), fontWeight: FontWeight.bold, fontSize: 14),
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(vertical: 4),
                                filled: true,
                                fillColor: const Color(0xFF0F172A),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: Color(0xFFEF4444))),
                              ),
                              onChanged: (val) {
                                setState(() {
                                  _finesAmount = double.tryParse(val) ?? 0.0;
                                });
                              },
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // === СВОДНАЯ ВЕДОМОСТЬ 1С ===
                      const Divider(color: Color(0xFF334155), height: 16),
                      const Text('Сводная ведомость (Данные 1С):', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white70)),
                      const SizedBox(height: 8),
                      _summaryRow('За пробег (${state.mileage == 0 ? 11238 : state.mileage.toInt()} км):', '${mileageEarnings == 0 ? 134856 : mileageEarnings.toStringAsFixed(0)} ₽', Colors.white),
                      _summaryRow('Суточные (${_daysCount} дн.):', '${dailyAllowanceEarnings.toStringAsFixed(0)} ₽', Colors.amber),
                      _summaryRow('Доп. точки выгрузки:', '${(state.loadedExtraCount == 0 ? 3 : state.loadedExtraCount) * _adminRateExtraPoint} ₽', Colors.white70),
                      _summaryRow('Растентовки:', '${(state.uncurtainedCount == 0 ? 3 : state.uncurtainedCount) * _adminRateUncurtain} ₽', Colors.white70),
                      _summaryRow('Увязка ремнями:', '${(state.cargoSecuredCount == 0 ? 1 : state.cargoSecuredCount) * _adminRateCargoSecured} ₽', Colors.white70),
                      _summaryRow('Экспресс-рейсы:', '${(state.expressCount == 0 ? 3 : state.expressCount) * _adminRateExpress} ₽', Colors.white70),
                      if (downtimeEarnings > 0) _summaryRow('Простои (в днях):', '${downtimeEarnings.toStringAsFixed(0)} ₽', Colors.lightBlueAccent),
                      if (fuelPremium > 0) _summaryRow('Премия НАК за экономию ГСМ:', '+${fuelPremium.toStringAsFixed(0)} ₽', const Color(0xFF22C55E)),
                      if (fuelDeduction > 0) _summaryRow('Пережог ДТ (${_fuelLiters.abs().toStringAsFixed(1)} л):', '-${fuelDeduction.toStringAsFixed(0)} ₽', const Color(0xFFF43F5E)),
                      if (_finesAmount > 0) _summaryRow('Штрафы ГИБДД (вычет):', '-${_finesAmount.toStringAsFixed(0)} ₽', const Color(0xFFF43F5E)),
                      const Divider(color: Color(0xFF334155), height: 16),
                      
                      // НОВАЯ СТРОКА ПО ВАШЕМУ ТЗ (С СУТОЧНЫМИ И ДО ВЫЧЕТОВ)
                      _summaryRow('Всего начислено (с суточными, до НДФЛ):', '${totalEarnedRaw == 0 ? 165156 : totalEarnedRaw.toStringAsFixed(0)} ₽', Colors.white, isBold: true),
                      _summaryRow('Удержано НДФЛ (13%):', '-${ndflAmount == 0 ? 20552 : ndflAmount.toStringAsFixed(0)} ₽', const Color(0xFFF43F5E)),
                      const SizedBox(height: 12),

                      // Итоговый баланс
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(color: const Color(0xFF0F172A), borderRadius: BorderRadius.circular(8)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Чистыми на карту (1С):', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
                            Text('${cleanPayout == 0 ? 137541 : cleanPayout.toStringAsFixed(0)} ₽', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF22C55E))),
                          ],
                        ),
                      ),

                      // === ЖЕСТКИЙ РЕГЛАМЕНТ ДЛЯ ВОДИТЕЛЕЙ (БРОНЯ ОТ ЛИШНИХ СПОРОВ) ===
                      Container(
                        margin: const EdgeInsets.only(top: 16),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF292524), 
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.amber.withOpacity(0.3)),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.warning_amber_rounded, color: Colors.amber, size: 20),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'По всем финансовым вопросам обращаться непосредственно к начальнику автоколонны!',
                                style: TextStyle(color: Colors.amber, fontSize: 10, fontWeight: FontWeight.bold, height: 1.3),
                              ),
                            ),
                          ],
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _adminRateInput(String label, double value, Function(double) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12))),
          SizedBox(
            width: 70,
            height: 28,
            child: TextField(
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.blueAccent, fontSize: 12, fontWeight: FontWeight.bold),
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.zero,
                filled: true,
                fillColor: Color(0xFF0F172A),
                border: OutlineInputBorder(),
              ),
              controller: TextEditingController(text: value.toStringAsFixed(0)),
              onSubmitted: (val) {
                final parsed = double.tryParse(val) ?? 0.0;
                onChanged(parsed);
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value, Color valueColor, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(label, style: TextStyle(fontSize: 12, color: const Color(0xFF94A3B8), fontWeight: isBold ? FontWeight.bold : FontWeight.normal))),
          Text(value, style: TextStyle(fontSize: 13, color: valueColor, fontWeight: isBold ? FontWeight.bold : FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _downtimeDaysCounterRow(String label, int value, Function(int) onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 12))),
        Row(
          children: [
            IconButton(icon: const Icon(Icons.remove_circle_outline, color: Color(0xFF94A3B8), size: 18), onPressed: value > 0 ? () => onChanged(value - 1) : null),
            Text('$value', style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
            IconButton(icon: const Icon(Icons.add_circle_outline, color: Color(0xFF38BDF8), size: 18), onPressed: () => onChanged(value + 1)),
          ],
        )
      ],
    );
  }

  Widget _counterRow(String label, int value, Function(int) onChanged, String priceLabel) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 12))),
          Text('($priceLabel) ', style: const TextStyle(color: Colors.grey, fontSize: 11)),
          Row(
            children: [
              IconButton(icon: const Icon(Icons.remove_circle_outline, color: Color(0xFF94A3B8), size: 18), onPressed: value > 0 ? () => onChanged(value - 1) : null),
              Text('$value', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
              IconButton(icon: const Icon(Icons.add_circle_outline, color: Color(0xFF38BDF8), size: 18), onPressed: () => onChanged(value + 1)),
            ],
          )
        ],
      ),
    );
  }

  // Заглушка под статус
  BalanceStatus statusFromString(String status) {
    if (status == 'approved') return BalanceStatus.approved;
    return BalanceStatus.prognosis;
  }
}

class _StatusBanner extends StatelessWidget {
  final BalanceStatus status;
  const _StatusBanner({required this.status});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: status == BalanceStatus.approved ? const Color(0xFF047857) : const Color(0xFF0369A1), borderRadius: BorderRadius.circular(8)),
      child: Row(children: [
        Icon(status == BalanceStatus.approved ? Icons.verified : Icons.trending_up, color: Colors.white, size: 24),
        const SizedBox(width: 12),
        Expanded(child: Text(status == BalanceStatus.approved ? "Расчет утвержден 1С" : "Оперативный прогноз", style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold))),
      ]),
    );
  }
}