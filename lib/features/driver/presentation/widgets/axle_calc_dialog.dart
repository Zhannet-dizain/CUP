import 'package:flutter/material.dart';

class AxleCalcDialog extends StatefulWidget {
  const AxleCalcDialog({super.key});

  @override
  State<AxleCalcDialog> createState() => _AxleCalcDialogState();
}

enum TrailerType {
  standardSchora('Стандартный 3-осный штора 13,6м'),
  tonar16_5_4axle('Тонар четырехосный 16,5м'),
  tonar16_5_3axle('Тонар трехосный 16,5м'),
  tonarContainer('Тонар-контейнеровоз'),
  refrigerator('Полуприцеп рефрижератор');

  final String label;
  const TrailerType(this.label);
}

class _AxleCalcDialogState extends State<AxleCalcDialog> {
  final TextEditingController _massController = TextEditingController();
  TrailerType _selectedType = TrailerType.standardSchora;
  String? _warningMessage;

  void _calculate() {
    final double? mass = double.tryParse(_massController.text);
    if (mass == null) {
      setState(() => _warningMessage = null);
      return;
    }

    bool isOverload = false;
    switch (_selectedType) {
      case TrailerType.standardSchora:
      case TrailerType.tonar16_5_3axle:
      case TrailerType.refrigerator:
        if (mass > 23.0) isOverload = true;
        break;
      case TrailerType.tonar16_5_4axle:
        if (mass > 29.0) isOverload = true;
        break;
      case TrailerType.tonarContainer:
        if (mass > 22.5) isOverload = true;
        break;
    }

    setState(() {
      _warningMessage = isOverload ? 'Внимание! Риск перегруза на оси полуприцепа!' : null;
    });
  }

  @override
  void dispose() {
    _massController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF1E293B),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFF334155)),
      ),
      title: const Text(
        'Калькулятор развесовки груза',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Общая масса груза (тонн)',
              style: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _massController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: '0.0',
                hintStyle: const TextStyle(color: Color(0xFF64748B)),
                filled: true,
                fillColor: const Color(0xFF0F172A),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFF334155)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFF334155)),
                ),
              ),
              onChanged: (_) => _calculate(),
            ),
            const SizedBox(height: 20),
            const Text(
              'Тип полуприцепа',
              style: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFF334155)),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<TrailerType>(
                  value: _selectedType,
                  isExpanded: true,
                  dropdownColor: const Color(0xFF0F172A),
                  style: const TextStyle(color: Colors.white),
                  items: TrailerType.values.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(type.label),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() => _selectedType = val);
                      _calculate();
                    }
                  },
                ),
              ),
            ),
            if (_warningMessage != null) ...[
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.withOpacity(0.5)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _warningMessage!,
                        style: const TextStyle(color: Colors.red, fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Закрыть', style: TextStyle(color: Color(0xFF94A3B8))),
        ),
      ],
    );
  }
}
