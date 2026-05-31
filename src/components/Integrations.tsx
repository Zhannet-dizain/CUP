/**
 * @license
 * SPDX-License-Identifier: Apache-2.0
 */

import React, { useState, useEffect } from 'react';
import { 
  Database, MapPin, Cpu, ToggleLeft, ToggleRight, Radio, RefreshCcw, 
  Settings, CheckCircle, AlertTriangle, Play, HelpCircle, Save, Plus, Trash2 
} from 'lucide-react';
import { Vehicle, VehicleStatus, AutomationRule } from '../types';

interface IntegrationsProps {
  vehicles: Vehicle[];
  rules: AutomationRule[];
  onToggleRule: (ruleId: string) => void;
  onAddRule: (rule: AutomationRule) => void;
  onDeleteRule: (ruleId: string) => void;
}

export default function Integrations({ 
  vehicles, 
  rules, 
  onToggleRule, 
  onAddRule, 
  onDeleteRule 
}: IntegrationsProps) {
  // 1C Integration status
  const [syncStatus, setSyncStatus] = useState<'idle' | 'syncing' | 'success' | 'error'>('idle');
  const [syncLogs, setSyncLogs] = useState<string[]>([
    `[${new Date(Date.now() - 3600000).toLocaleTimeString()}] Подключение к 1С:УХ... Успешно.`,
    `[${new Date(Date.now() - 3550000).toLocaleTimeString()}] Получены лимиты ГСМ для 8 ТС.`,
    `[${new Date(Date.now() - 3500000).toLocaleTimeString()}] Документы простоев №119-П отправлены.`
  ]);

  // GPS Map state
  const [selectedMapVehicle, setSelectedMapVehicle] = useState<Vehicle | null>(vehicles[0] || null);

  // New Rule Creation Form
  const [showAddRule, setShowAddRule] = useState(false);
  const [newRuleName, setNewRuleName] = useState('');
  const [newRuleTrigger, setNewRuleTrigger] = useState<'downtime_duration' | 'low_fuel' | 'engine_temp' | 'gps_lost'>('low_fuel');
  const [newRuleThreshold, setNewRuleThreshold] = useState<number>(15);
  const [newRuleAction, setNewRuleAction] = useState<'notify_manager' | 'auto_change_status' | 'alert_mechanic'>('notify_manager');
  const [newRuleActionVal, setNewRuleActionVal] = useState('Отправить Email');

  // Trigger manual 1C sync
  const start1CSync = () => {
    setSyncStatus('syncing');
    const newLogEntry1 = `[${new Date().toLocaleTimeString()}] Запущена внеплановая сверка путевых листов...`;
    setSyncLogs(prev => [newLogEntry1, ...prev]);

    setTimeout(() => {
      setSyncStatus('success');
      const newLogEntry2 = `[${new Date().toLocaleTimeString()}] Синхронизация завершена. Обработано записей: ${vehicles.length}. Статусы путевых листов обновлены в 1С:Предприятие.`;
      setSyncLogs(prev => [newLogEntry2, ...prev]);
    }, 1800);
  };

  // Rule additions
  const handleCreateRule = (e: React.FormEvent) => {
    e.preventDefault();
    if (!newRuleName) return;
    
    const newRule: AutomationRule = {
      id: 'R_' + Math.random().toString(36).substr(2, 5),
      name: newRuleName,
      triggerType: newRuleTrigger,
      threshold: Number(newRuleThreshold),
      actionType: newRuleAction,
      actionValue: newRuleActionVal,
      active: true
    };

    onAddRule(newRule);
    setShowAddRule(false);
    // Reset fields
    setNewRuleName('');
    setNewRuleThreshold(15);
    setNewRuleActionVal('Смена статуса ТС');
  };

  return (
    <div className="space-y-6" id="integrations_view">
      
      {/* 2 columns layout: GPS/GLONASS Telematics map on left, 1C Sync & Automations on right */}
      <div className="grid grid-cols-1 lg:grid-cols-12 gap-6">
        
        {/* Left Column: Interactive GPS GLONASS and Live Telemetry Map Tracker */}
        <div className="lg:col-span-7 bg-white border border-slate-200 rounded-xl shadow-sm p-4 flex flex-col justify-between" id="gps_glonass_tracker">
          <div>
            <div className="flex items-center justify-between pb-3 border-b border-slate-100 mb-4">
              <div className="flex items-center space-x-2">
                <Radio className="text-emerald-500 animate-pulse" size={18} />
                <div>
                  <h3 className="font-bold text-sm text-slate-805">Спутниковый GPS / ГЛОНАСС трекинг парка</h3>
                  <p className="text-[10px] text-slate-400">Интеграция датчиков расхода горючего (ДУТ) и гео-кординат</p>
                </div>
              </div>

              <span className="text-[10px] bg-emerald-50 text-emerald-800 py-0.5 px-2 rounded-full border border-emerald-100 font-mono">
                8 ТС на связи со спутником
              </span>
            </div>

            {/* Stylized Simulated Route Vector Map (SVG Interactive Canvas) */}
            <div className="relative h-72 bg-gradient-to-br from-slate-950 via-slate-900 to-indigo-980 rounded-xl overflow-hidden border border-slate-800 shadow-inner flex items-center justify-center">
              
              {/* Map background grids and simple simulated routes */}
              <svg className="absolute inset-0 w-full h-full opacity-35" xmlns="http://www.w3.org/2000/svg">
                {/* Lat/Lng Grids */}
                <line x1="0" y1="50" x2="100%" y2="50" stroke="#1e293b" strokeDasharray="5,5" />
                <line x1="0" y1="120" x2="100%" y2="120" stroke="#1e293b" strokeDasharray="5,5" />
                <line x1="0" y1="200" x2="100%" y2="200" stroke="#1e293b" strokeDasharray="5,5" />
                
                <line x1="80" y1="0" x2="80" y2="100%" stroke="#1e293b" strokeDasharray="5,5" />
                <line x1="180" y1="0" x2="180" y2="100%" stroke="#1e293b" strokeDasharray="5,5" />
                <line x1="320" y1="0" x2="320" y2="100%" stroke="#1e293b" strokeDasharray="5,5" />

                {/* Major Highway simulation path (M-10 / M-4 routes) */}
                <path d="M 50 250 Q 150 140 280 180 T 450 60" fill="none" stroke="#334155" strokeWidth="4" />
                <path d="M 50 250 Q 150 140 280 180 T 450 60" fill="none" stroke="#10b981" strokeWidth="2" strokeDasharray="6,4" className="animate-[dash_10s_linear_infinite]" />
                
                <path d="M 50 20 L 220 110 L 410 240" fill="none" stroke="#334155" strokeWidth="3" />
              </svg>

              {/* Coordinates scale overlay */}
              <div className="absolute bottom-2 left-2 text-[9px] text-slate-500 font-mono">
                Масштаб: 1 : 550 000 | Проекция: WGS-84 ГЛОНАСС
              </div>

              {/* Active Vehicles Markers Map node */}
              <div className="absolute inset-0 p-6 flex flex-wrap justify-around items-center">
                {vehicles.map((vh, index) => {
                  // Coordinate to SVG position mapping offsets
                  const offsets = [
                    { top: '20%', left: '35%' },
                    { top: '65%', left: '15%' },
                    { top: '55%', left: '45%' },
                    { top: '35%', left: '80%' },
                    { top: '75%', left: '70%' },
                    { top: '15%', left: '60%' },
                    { top: '45%', left: '25%' },
                    { top: '80%', left: '90%' },
                  ];

                  const position = offsets[index] || { top: '50%', left: '50%' };
                  const isSelected = selectedMapVehicle?.id === vh.id;
                  
                  return (
                    <button
                      key={vh.id}
                      onClick={() => setSelectedMapVehicle(vh)}
                      className="absolute p-1 group focus:outline-none cursor-pointer"
                      style={{ top: position.top, left: position.left }}
                    >
                      {/* Pulse circle status based */}
                      <span className="relative flex h-5 w-5 items-center justify-center">
                        <span className={`animate-ping absolute inline-flex h-full w-full rounded-full opacity-75 ${
                          vh.status === VehicleStatus.IN_ROUTE ? 'bg-emerald-400' :
                          vh.status === VehicleStatus.READY ? 'bg-cyan-400' :
                          vh.status === VehicleStatus.DOWNTIME ? 'bg-indigo-400' :
                          vh.status === VehicleStatus.MAINTENANCE ? 'bg-amber-400' : 'bg-red-500'
                        }`} />
                        <span className={`relative inline-flex rounded-full h-3 w-3 ${
                          vh.status === VehicleStatus.IN_ROUTE ? 'bg-emerald-500' :
                          vh.status === VehicleStatus.READY ? 'bg-cyan-400' :
                          vh.status === VehicleStatus.DOWNTIME ? 'bg-indigo-500' :
                          vh.status === VehicleStatus.MAINTENANCE ? 'bg-amber-500' : 'bg-red-650'
                        } ${isSelected ? 'ring-4 ring-white shadow-lg scale-125' : 'scale-100'}`} />
                      </span>

                      {/* Tooltip on marker */}
                      <span className="absolute hidden group-hover:block bg-slate-900 border border-slate-700 text-white font-mono text-[9px] rounded p-1 -translate-y-9 -translate-x-4 whitespace-nowrap z-20">
                        {vh.plateNumber} ({vh.speed} км/ч)
                      </span>
                    </button>
                  );
                })}
              </div>

            </div>
          </div>

          {/* Active vehicle telemetry detail view */}
          {selectedMapVehicle && (
            <div className="bg-slate-50 border border-slate-200 rounded-xl p-3 mt-4 text-xs">
              <div className="flex items-center justify-between mb-2">
                <span className="font-bold text-slate-800">{selectedMapVehicle.model}</span>
                <span className="font-mono text-slate-500 font-bold bg-slate-200/50 px-1.5 py-0.2 rounded">
                  {selectedMapVehicle.plateNumber}
                </span>
              </div>

              <div className="grid grid-cols-2 sm:grid-cols-4 gap-2 text-[11px] font-mono text-slate-600">
                <div className="p-1.5 bg-white border border-slate-100 rounded">
                  <span className="block text-[9px] text-slate-400">Скорость GPS:</span>
                  <strong className="text-slate-800 text-xs font-bold">{selectedMapVehicle.speed} км/ч</strong>
                </div>
                <div className="p-1.5 bg-white border border-slate-100 rounded">
                  <span className="block text-[9px] text-slate-400">Топливный бак:</span>
                  <strong className="text-slate-800 text-xs font-bold">{selectedMapVehicle.fuelLevel}% (ДУТ)</strong>
                </div>
                <div className="p-1.5 bg-white border border-slate-100 rounded">
                  <span className="block text-[9px] text-slate-400">Темп. двигателя:</span>
                  <strong className={`text-xs font-bold ${selectedMapVehicle.engineTemp > 98 ? 'text-red-650' : 'text-slate-800'}`}>{selectedMapVehicle.engineTemp}°C</strong>
                </div>
                <div className="p-1.5 bg-white border border-slate-100 rounded">
                  <span className="block text-[9px] text-slate-400">На ГЛОНАСС связи:</span>
                  <strong className={selectedMapVehicle.connectedGPS ? 'text-emerald-700 font-bold' : 'text-red-500 font-bold'}>
                    {selectedMapVehicle.connectedGPS ? 'Да' : 'Потерян'}
                  </strong>
                </div>
              </div>

              <div className="mt-2 text-[11px] font-sans text-slate-500 flex items-center space-x-1">
                <MapPin size={12} className="text-indigo-500 shrink-0" />
                <span>Текущая локация (по ГЛОНАСС): <strong>{selectedMapVehicle.locationName}</strong></span>
              </div>
            </div>
          )}

        </div>

        {/* Right Column: 1C Sync Logistics + Automatic Rules Builder */}
        <div className="lg:col-span-5 space-y-6" id="right_integrations_column">
          
          {/* Card A: 1C Sync Terminal */}
          <div className="bg-white border border-slate-200 rounded-xl shadow-sm p-4">
            <div className="flex items-center justify-between pb-2 border-b border-slate-100 mb-3">
              <div className="flex items-center space-x-2">
                <Database className="text-indigo-600 animate-pulse" size={17} />
                <h3 className="font-bold text-sm text-slate-800">Интеграция с 1С:УАТ / ERP Логистика</h3>
              </div>
              <span className="text-[10px] text-slate-400 font-semibold font-mono">1С v8.3 Проф</span>
            </div>

            <div className="space-y-4">
              <div className="flex items-center justify-between">
                <div>
                  <span className="text-[11px] font-bold text-slate-500 block uppercase tracking-wide">Последняя выгрузка съема</span>
                  <span className="text-xs text-slate-700">Передано путевых листов и накладных</span>
                </div>
                
                <button
                  onClick={start1CSync}
                  disabled={syncStatus === 'syncing'}
                  className={`py-1.5 px-3 rounded-lg text-xs font-semibold flex items-center space-x-1 text-white cursor-pointer transition ${
                    syncStatus === 'syncing' 
                      ? 'bg-indigo-300' 
                      : 'bg-indigo-650 hover:bg-indigo-700 shadow-sm active:scale-95'
                  }`}
                >
                  <RefreshCcw size={12} className={syncStatus === 'syncing' ? 'animate-spin' : ''} />
                  <span>{syncStatus === 'syncing' ? 'Выгрузка...' : 'Синхронизировать'}</span>
                </button>
              </div>

              {/* Status messages indicator */}
              {syncStatus === 'success' && (
                <div className="bg-emerald-50 border border-emerald-100 text-emerald-800 p-2.5 rounded-lg text-[11px] font-sans flex items-center space-x-1.5">
                  <CheckCircle size={14} className="text-emerald-600" />
                  <span>Проводка статусов успешно отправлена в REST-сервер 1С. Путевки актуальны.</span>
                </div>
              )}

              {/* Console log of SOAP/OData API queries */}
              <div className="bg-slate-900 rounded-lg p-2.5 border border-slate-800">
                <p className="text-[10px] font-mono text-slate-550 mb-1 border-b border-slate-800 pb-1 font-bold">Очередь REST-OData сообщений:</p>
                <div className="space-y-1 max-h-24 overflow-y-auto pr-1 font-mono text-[10px] text-emerald-450 leading-relaxed">
                  {syncLogs.map((log, index) => (
                    <div key={index}>{log}</div>
                  ))}
                </div>
              </div>
            </div>
          </div>

          {/* Card B: Automation Rules (Правила реагирования) */}
          <div className="bg-white border border-slate-200 rounded-xl shadow-sm p-4">
            <div className="flex items-center justify-between pb-2 border-b border-slate-105 mb-3">
              <div className="flex items-center space-x-2">
                <Settings className="text-slate-600" size={17} />
                <h3 className="font-bold text-sm text-slate-805">Автоматические правила простоев</h3>
              </div>
              <button
                onClick={() => setShowAddRule(!showAddRule)}
                className="text-xs text-indigo-600 font-semibold hover:underline flex items-center gap-0.5 cursor-pointer"
              >
                <Plus size={13} strokeWidth={2.5} /> Добавить
              </button>
            </div>

            {/* Form to add rule */}
            {showAddRule && (
              <form onSubmit={handleCreateRule} className="bg-slate-50 border border-slate-250 rounded-xl p-3 text-xs mb-3 space-y-2.5 animate-in slide-in-from-top-1">
                <div>
                  <label className="block text-[10px] text-slate-500 font-bold uppercase mb-0.5">Класс / Название автоправила</label>
                  <input
                    type="text"
                    placeholder="Например, Запрет стоянки вне заправок"
                    value={newRuleName}
                    onChange={(e) => setNewRuleName(e.target.value)}
                    className="w-full text-xs px-2.5 py-1 border border-slate-300 rounded focus:border-indigo-500 text-slate-850"
                    required
                  />
                </div>

                <div className="grid grid-cols-2 gap-2">
                  <div>
                    <label className="block text-[10px] text-slate-500 font-bold uppercase mb-0.5">Триггер</label>
                    <select
                      value={newRuleTrigger}
                      onChange={(e: any) => setNewRuleTrigger(e.target.value)}
                      className="w-full text-[11px] p-1 border border-slate-300 rounded text-slate-700 bg-white"
                    >
                      <option value="low_fuel">Объем бака &lt; %</option>
                      <option value="engine_temp">Нагрев мотора &gt; °C</option>
                      <option value="downtime_duration">Простой склада &gt; (ч)</option>
                      <option value="gps_lost">Радиомолчание &gt; (ч)</option>
                    </select>
                  </div>
                  <div>
                    <label className="block text-[10px] text-slate-500 font-bold uppercase mb-0.5">Порог</label>
                    <input
                      type="number"
                      value={newRuleThreshold}
                      onChange={(e) => setNewRuleThreshold(Number(e.target.value))}
                      className="w-full text-[11px] p-1 border border-slate-300 rounded text-slate-700"
                      min={0}
                    />
                  </div>
                </div>

                <div>
                  <label className="block text-[10px] text-slate-500 font-bold uppercase mb-0.5">Действие</label>
                  <input
                    type="text"
                    placeholder="Например, перевести в Поломку + СМС"
                    value={newRuleActionVal}
                    onChange={(e) => setNewRuleActionVal(e.target.value)}
                    className="w-full text-xs px-2.5 py-1 border border-slate-300 rounded focus:border-indigo-500 text-slate-850"
                  />
                </div>

                <div className="flex justify-end space-x-1.5 pt-1">
                  <button
                    type="button"
                    onClick={() => setShowAddRule(false)}
                    className="px-2.5 py-1 border border-slate-200 text-slate-500 rounded hover:bg-slate-100"
                  >
                    Отмена
                  </button>
                  <button
                    type="submit"
                    className="px-3 py-1 bg-indigo-650 text-white rounded hover:bg-indigo-700 font-bold"
                  >
                    Создать правило
                  </button>
                </div>
              </form>
            )}

            {/* List of active automation rules */}
            <div className="space-y-2 max-h-60 overflow-y-auto pr-1">
              {rules.map((rule) => (
                <div key={rule.id} className="p-3 bg-slate-50 border border-slate-150 rounded-xl text-xs flex items-center justify-between">
                  <div className="space-y-0.5">
                    <p className="font-bold text-slate-800">{rule.name}</p>
                    <p className="text-[10px] text-slate-500">
                      Если парам.{' '} 
                      <strong className="text-slate-600 font-mono">
                        {rule.triggerType === 'low_fuel' ? 'Топливо <' : 
                         rule.triggerType === 'engine_temp' ? 'Перегрев мотора >' :
                         rule.triggerType === 'downtime_duration' ? 'Простой >' : 'Потеря ГЛОНАСС >'}
                      </strong>{' '} 
                      {rule.threshold}{rule.triggerType === 'low_fuel' ? '%' : rule.triggerType === 'engine_temp' ? '°C' : ' ч.'} 
                      → <strong className="text-indigo-700 font-semibold">{rule.actionValue}</strong>
                    </p>
                  </div>

                  <div className="flex items-center space-x-2">
                    <button
                      onClick={() => onToggleRule(rule.id)}
                      className="p-1 hover:bg-slate-250 rounded text-slate-500"
                    >
                      {rule.active ? (
                        <ToggleRight className="text-emerald-500 stroke-[2.2]" size={26} />
                      ) : (
                        <ToggleLeft className="text-slate-400 stroke-[2.2]" size={26} />
                      )}
                    </button>
                    <button
                      onClick={() => onDeleteRule(rule.id)}
                      className="p-1 text-slate-400 hover:text-red-500 rounded hover:bg-red-50 transition"
                      title="Удалить автоправило"
                    >
                      <Trash2 size={13} />
                    </button>
                  </div>
                </div>
              ))}
            </div>
            
          </div>

        </div>

      </div>

    </div>
  );
}
