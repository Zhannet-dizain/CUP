import 'package:flutter/material.dart';
import '../../domain/models/vehicle.dart';
import '../../domain/logic/axle_weight_engine.dart';
import '../../data/reference/ru_vehicle_database.dart';

class AxleCalcDialog extends StatefulWidget {
  const AxleCalcDialog({super.key});

  @override
  State<AxleCalcDialog> createState() => _AxleCalcDialogState();
}

class _AxleCalcDialogState extends State<AxleCalcDialog> {
  TractorModel _selectedTractor = RuVehicleDatabase.tractorList.first;
  TrailerModel _selectedTrailer = RuVehicleDatabase.trailerList.first;
  double _cargoWeight = 20.0;
  double _cargoOffset = 0.5; // Смещение от передней стенки
  final double _cargoLength = 13.0; // Средняя длина груза

  CalculationReport? _report;

  @override
  void initState() {
    super.initState();
    _calculate();
  }

  void _calculate() {
    setState(() {
      _report = AxleWeightEngine.calculate(
        tractor: _selectedTractor,
        trailer: _selectedTrailer,
        cargoWeight: _cargoWeight,
        cargoOffset: _cargoOffset,
        cargoLength: _cargoLength,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: Scaffold(
        backgroundColor: const Color(0xFF0F172A),
        appBar: AppBar(
          backgroundColor: const Color(0xFF0F172A),
          title: const Text('КАЛЬКУЛЯТОР РАЗВЕСОВКИ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          leading: IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildVehicleSelectors(),
              const SizedBox(height: 24),
              _buildCargoInputs(),
              const SizedBox(height: 32),
              if (_report != null) _buildResultView(_report!),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVehicleSelectors() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('ТЯГАЧ', style: TextStyle(color: Color(0xFF38BDF8), fontWeight: FontWeight.bold, fontSize: 12)),
        const SizedBox(height: 8),
        _dropdown<TractorModel>(
          value: _selectedTractor,
          items: RuVehicleDatabase.tractorList.map((t) => DropdownMenuItem(value: t, child: Text(t.name))).toList(),
          onChanged: (val) {
            if (val != null) {
              setState(() => _selectedTractor = val);
              _calculate();
            }
          },
        ),
        const SizedBox(height: 20),
        const Text('ПОЛУПРИЦЕП', style: TextStyle(color: Color(0xFF38BDF8), fontWeight: FontWeight.bold, fontSize: 12)),
        const SizedBox(height: 8),
        _dropdown<TrailerModel>(
          value: _selectedTrailer,
          items: RuVehicleDatabase.trailerList.map((t) => DropdownMenuItem(value: t, child: Text(t.name))).toList(),
          onChanged: (val) {
            if (val != null) {
              setState(() => _selectedTrailer = val);
              _calculate();
            }
          },
        ),
        if (_selectedTrailer.axleCount == 4) ...[
          const SizedBox(height: 12),
          SwitchListTile(
            title: const Text('Первая ось поднята (ленивец)', style: TextStyle(color: Colors.white, fontSize: 14)),
            value: _selectedTrailer.isFirstAxleLifted,
            onChanged: (val) {
              setState(() => _selectedTrailer.isFirstAxleLifted = val);
              _calculate();
            },
            activeColor: const Color(0xFF38BDF8),
            contentPadding: EdgeInsets.zero,
          ),
        ],
      ],
    );
  }

  Widget _buildCargoInputs() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('МАССА ГРУЗА (Т)', style: TextStyle(color: Color(0xFF38BDF8), fontWeight: FontWeight.bold, fontSize: 12)),
            Text('${_cargoWeight.toStringAsFixed(1)} т', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
        Slider(
          value: _cargoWeight,
          min: 0,
          max: 30,
          divisions: 300,
          activeColor: const Color(0xFF38BDF8),
          onChanged: (val) {
            setState(() => _cargoWeight = val);
            _calculate();
          },
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('СМЕЩЕНИЕ ГРУЗА (М)', style: TextStyle(color: Color(0xFF38BDF8), fontWeight: FontWeight.bold, fontSize: 12)),
            Text('${_cargoOffset.toStringAsFixed(1)} м', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
        Slider(
          value: _cargoOffset,
          min: 0,
          max: 3.0,
          divisions: 30,
          activeColor: const Color(0xFF38BDF8),
          onChanged: (val) {
            setState(() => _cargoOffset = val);
            _calculate();
          },
        ),
      ],
    );
  }

  Widget _buildResultView(CalculationReport report) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('РАСЧЕТНЫЕ НАГРУЗКИ', style: TextStyle(color: Color(0xFF38BDF8), fontWeight: FontWeight.bold, fontSize: 12)),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF334155)),
          ),
          child: Column(
            children: report.axleLoads.map((load) => _axleRow(load)).toList(),
          ),
        ),
        const SizedBox(height: 20),
        Center(
          child: Text(
            'ПОЛНАЯ МАССА: ${report.totalMass.toStringAsFixed(1)} Т',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: report.totalMass > 40.0 ? Colors.red : Colors.greenAccent
            ),
          ),
        ),
      ],
    );
  }

  Widget _axleRow(AxleLoadResult load) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(load.label, style: const TextStyle(color: Colors.white, fontSize: 14)),
              Text(
                '${load.currentLoad.toStringAsFixed(2)} т',
                style: TextStyle(
                  color: load.isOverloaded ? Colors.red : Colors.greenAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 16
                )
              ),
            ],
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: load.currentLoad / load.limit,
            backgroundColor: const Color(0xFF0F172A),
            color: load.isOverloaded ? Colors.red : Colors.greenAccent,
            minHeight: 4,
          ),
          const SizedBox(height: 2),
          Align(
            alignment: Alignment.centerRight,
            child: Text('Лимит: ${load.limit} т', style: const TextStyle(color: Color(0xFF64748B), fontSize: 10)),
          ),
        ],
      ),
    );
  }

  Widget _dropdown<T>({required T value, required List<DropdownMenuItem<T>> items, required ValueChanged<T?> onChanged}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          dropdownColor: const Color(0xFF1E293B),
          items: items,
          onChanged: onChanged,
          style: const TextStyle(color: Colors.white, fontSize: 14),
        ),
      ),
    );
  }
}
