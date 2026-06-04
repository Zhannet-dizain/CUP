import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

// 1. СТРАНИЦА-ОБЕРТКА
class DriverBalanceScreen extends StatelessWidget {
  const DriverBalanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
        title: const Text(
          'Личный кабинет водителя: Баланс',
          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        shape: const Border(bottom: BorderSide(color: Color(0xFF334155), width: 1)),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: EarningsSimulator(advanceFrom1C: 15000.0),
      ),
    );
  }
}

// 2. ВИДЖЕТ КАЛЬКУЛЯТОРА
class EarningsSimulator extends StatefulWidget {
  final double advanceFrom1C;

  const EarningsSimulator({
    super.key,
    required this.advanceFrom1C,
  });

  @override
  State<EarningsSimulator> createState() => _EarningsSimulatorState();
}

class _EarningsSimulatorState extends State<EarningsSimulator> {
  String _truckType = 'штора_13'; 

  double _mileage = 4500; 
  
  int _moscowTripsCount = 0;    
  int _localTripsCount = 0;     
  int _loadedExtraCount = 2;    
  int _uncurtainedCount = 3;    
  int _cargoSecuredCount = 2;   
  int _expressCount = 2;        
  int _extraPoints = 0;         

  late TextEditingController _mileageController;

  @override
  void initState() {
    super.initState();
    _mileageController = TextEditingController(text: _mileage.toInt().toString());
  }

  @override
  void dispose() {
    _mileageController.dispose();
    super.dispose();
  }

  double _getRatePerKm() {
    switch (_truckType) {
      case 'штора_13': return 12.0;
      case 'штора_16': return 13.0;
      case 'реф': return 13.0;
      case 'контейнер': return 13.5;
      default: return 12.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(locale: 'ru_RU', symbol: '₽', decimalDigits: 0);
    
    double ratePerKm = _getRatePerKm();
    double kmEarnings = _mileage * ratePerKm;
    
    double moscowEarnings = _moscowTripsCount * 5000.0;
    double localEarnings = _localTripsCount * 3100.0;
    
    double otherExtras = (_loadedExtraCount * 1000) + 
                         (_uncurtainedCount * 500) + 
                         (_cargoSecuredCount * 1000) + 
                         (_expressCount * 1000) + 
                         (_extraPoints * 500);
    
    double totalGross = kmEarnings + moscowEarnings + localEarnings + otherExtras;
    double ndfl = totalGross * 0.13;
    double finalPayout = totalGross - ndfl - widget.advanceFrom1C;

    return Card(
      color: const Color(0xFF1E293B),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFF334155)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Калькулятор-симулятор путевого листа',
                style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
            const SizedBox(height: 14),
            
            const Text('Тип полуприцепа и базовая ставка:', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
            const SizedBox(height: 6),
            Row(
              children: [
                _truckTypeButton('штора_13', '13м Кёгель (12₽)'),
                const SizedBox(width: 4),
                _truckTypeButton('штора_16', '16м ТОНАР (13₽)'),
                const SizedBox(width: 4),
                _truckTypeButton('реф', 'Реф 13м (13₽)'),
                const SizedBox(width: 4),
                _truckTypeButton('контейнер', 'Контейнер (13.5₽)'),
              ],
            ),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Общий пробег по ПЛ:', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
                Row(
                  children: [
                    SizedBox(
                      width: 80,
                      height: 30,
                      child: TextField(
                        controller: _mileageController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        style: const TextStyle(color: Color(0xFF38BDF8), fontWeight: FontWeight.bold, fontSize: 14),
                        textAlign: TextAlign.right,
                        decoration: const InputDecoration(contentPadding: EdgeInsets.zero, isDense: true),
                        onChanged: (val) {
                          double? parsed = double.tryParse(val);
                          if (parsed != null) setState(() => _mileage = parsed.clamp(0, 30000));
                        },
                      ),
                    ),
                    const Text(' км', style: TextStyle(color: Color(0xFF38BDF8), fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
            Slider(
              value: _mileage,
              min: 0, max: 30000,
              activeColor: const Color(0xFF38BDF8),
              inactiveColor: const Color(0xFF334155),
              onChanged: (val) {
                setState(() {
                  _mileage = val.roundToDouble();
                  _mileageController.text = _mileage.toInt().toString();
                });
              },
            ),
            
            const SizedBox(height: 8),
            const Text('Дополнительные доплаты за рейс:', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
            const Divider(color: Color(0xFF334155)),

            _buildCounterRow('Рейсы по Москве и МО (+5 000 ₽):', _moscowTripsCount, (val) => setState(() => _moscowTripsCount = val)),
            _buildCounterRow('Рейсы по месту в регионах (+3 100 ₽):', _localTripsCount, (val) => setState(() => _localTripsCount = val)),
            _buildCounterRow('Количество доп. погрузок (+1 000 ₽):', _loadedExtraCount, (val) => setState(() => _loadedExtraCount = val)),
            _buildCounterRow('Количество растентовок (+500 ₽):', _uncurtainedCount, (val) => setState(() => _uncurtainedCount = val)),
            _buildCounterRow('Крепление груза от 10 ремней (+1 000 ₽):', _cargoSecuredCount, (val) => setState(() => _cargoSecuredCount = val)),
            _buildCounterRow('Количество экспресс-плеч (+1 000 ₽):', _expressCount, (val) => setState(() => _expressCount = val)),
            _buildCounterRow('Дополнительные точки (+500 ₽/шт):', _extraPoints, (val) => setState(() => _extraPoints = val)),
            
            const Divider(color: Color(0xFF334155), height: 28),

            _resultRow('Заработано по километражу:', kmEarnings, formatter),
            
            if (_moscowTripsCount > 0)
              _resultRow('Доплата за рейсы по Москве и МО:', moscowEarnings, formatter, color: const Color(0xFF38BDF8)),
            
            if (_localTripsCount > 0)
              _resultRow('Доплата за работу по месту в рег.:', localEarnings, formatter, color: const Color(0xFF38BDF8)),
            
            if (otherExtras > 0)
              _resultRow('Прочие надбавки (растентовки/ремни/точки):', otherExtras, formatter),
              
            _resultRow('Удержан НДФЛ (13%):', -ndfl, formatter, color: const Color(0xFFEF4444)),
            _resultRow('Уже выплаченный аванс (30 числа):', -widget.advanceFrom1C, formatter, color: const Color(0xFFF59E0B)),

            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: const Color(0xFF0F172A), borderRadius: BorderRadius.circular(8)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Остаток к выплате в день ЗП:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
                  Text(formatter.format(finalPayout), 
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: finalPayout >= 0 ? const Color(0xFF22C55E) : const Color(0xFFEF4444))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _truckTypeButton(String type, String label) {
    bool isSelected = _truckType == type;
    return Expanded(
      child: SizedBox(
        height: 38,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: isSelected ? const Color(0xFF38BDF8) : const Color(0xFF0F172A),
            foregroundColor: isSelected ? Colors.black : Colors.white,
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
              side: BorderSide(color: isSelected ? const Color(0xFF38BDF8) : const Color(0xFF334155)),
            ),
            elevation: 0,
          ),
          onPressed: () => setState(() => _truckType = type),
          child: Text(
            label, 
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold), 
            textAlign: TextAlign.center, // ИСПРАВЛЕНО ТУТ
          ),
        ),
      ),
    );
  }

  Widget _buildCounterRow(String title, int value, Function(int) onChange) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 13)),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove, size: 18, color: Color(0xFF94A3B8)), 
                onPressed: value > 0 ? () => onChange(value - 1) : null
              ),
              SizedBox(
                width: 20,
                child: Text('$value', style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
              ),
              IconButton(
                icon: const Icon(Icons.add, size: 18, color: Color(0xFF94A3B8)), 
                onPressed: () => onChange(value + 1)
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _resultRow(String label, double val, NumberFormat f, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13)),
          Text(f.format(val), style: TextStyle(color: color ?? Colors.white, fontSize: 14, fontWeight: color != null ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }
}