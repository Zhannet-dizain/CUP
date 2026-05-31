/**
 * @license
 * SPDX-License-Identifier: Apache-2.0
 */

import React from 'react';
import { Truck, AlertTriangle, Clock, Wrench, ShieldAlert, Sparkles, Navigation, Fuel, Gauge } from 'lucide-react';
import { Vehicle, VehicleStatus, StatusLogEntry } from '../types';

interface DashboardProps {
  vehicles: Vehicle[];
  logs: StatusLogEntry[];
  onSelectTab: (tab: string) => void;
  onSelectVehicle: (plate: string) => void;
}

export default function Dashboard({ vehicles, logs, onSelectTab, onSelectVehicle }: DashboardProps) {
  // Counts by status
  const total = vehicles.length;
  const inRoute = vehicles.filter(v => v.status === VehicleStatus.IN_ROUTE).length;
  const ready = vehicles.filter(v => v.status === VehicleStatus.READY).length;
  const maintenance = vehicles.filter(v => v.status === VehicleStatus.MAINTENANCE).length;
  const downtime = vehicles.filter(v => v.status === VehicleStatus.DOWNTIME).length;
  const breakdown = vehicles.filter(v => v.status === VehicleStatus.BREAKDOWN).length;

  // Calculatings
  const activeUptimeRate = total > 0 ? Math.round(((inRoute + ready) / total) * 100) : 0;
  const averageFuel = total > 0 ? Math.round(vehicles.reduce((acc, v) => acc + v.fuelLevel, 0) / total) : 0;
  const telemetryLossCount = vehicles.filter(v => !v.connectedGPS).length;

  // At risk vehicles
  const atRisk = vehicles.filter(v => 
    v.status === VehicleStatus.BREAKDOWN || 
    v.fuelLevel < 15 || 
    v.engineTemp > 98 || 
    !v.connectedGPS
  );

  return (
    <div className="space-y-6" id="dashboard_view">
      
      {/* 10-Second Manager Overview Banner */}
      <div className="bg-gradient-to-r from-slate-900 via-slate-800 to-indigo-950 text-white rounded-2xl p-5 sm:p-6 shadow-lg border border-slate-700/60" id="executive_overview_banner">
        <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
          <div>
            <div className="flex items-center space-x-2 text-indigo-300 font-mono text-xs tracking-wider mb-2">
              <Sparkles size={14} className="animate-pulse" />
              <span>ИНТЕЛЛЕКТУАЛЬНЫЙ СЪЕМ СТАТУСА ПАРКА</span>
            </div>
            <h2 className="text-xl sm:text-2xl font-bold tracking-tight text-slate-100 font-sans">
              Готовность флота: <span className="text-emerald-400">{activeUptimeRate}%</span>
            </h2>
            <p className="text-sm text-slate-300 mt-1 max-w-2xl font-sans">
              {breakdown > 0 
                ? `Внимание! Требуется вмешательство: обнаружено поломок (${breakdown}), машин не на связи ГЛОНАСС (${telemetryLossCount}).` 
                : 'Все системы работают штатно. Риски простоев сведены к минимуму. Выгрузка в 1С завершена.'}
            </p>
          </div>
          <div className="flex gap-3">
            <button
              onClick={() => onSelectTab('analytics')}
              className="px-4 py-2 bg-indigo-600 hover:bg-indigo-500 text-white font-medium text-xs rounded-lg shadow-sm transition hover:scale-[1.01] cursor-pointer"
            >
              Смотреть KPI отчеты
            </button>
            <button
              onClick={() => onSelectTab('vehicles')}
              className="px-4 py-2 bg-slate-850 hover:bg-slate-750 text-slate-200 border border-slate-700 font-medium text-xs rounded-lg transition cursor-pointer"
            >
              Сменить статусы
            </button>
          </div>
        </div>

        {/* Modern visual bar showing status ratios */}
        <div className="mt-5 pt-3 border-t border-slate-800">
          <div className="text-[11px] font-mono text-slate-400 flex justify-between mb-1.5 font-bold">
            <span>ЦВЕТОВОЙ БАЛАНС ПАРКА (ТЕКУЩЕЕ СОСТОЯНИЕ)</span>
            <span>{total} ТС АКТИВНО</span>
          </div>
          <div className="h-3.5 w-full rounded-full overflow-hidden flex bg-slate-800">
            {inRoute > 0 && (
              <div 
                className="bg-emerald-500 h-full transition-all duration-500" 
                style={{ width: `${(inRoute/total)*100}%` }} 
                title={`В рейсе: ${inRoute} ТС`}
              />
            )}
            {ready > 0 && (
              <div 
                className="bg-teal-500 h-full transition-all duration-500" 
                style={{ width: `${(ready/total)*100}%` }} 
                title={`Готовы: ${ready} ТС`}
              />
            )}
            {downtime > 0 && (
              <div 
                className="bg-indigo-500 h-full transition-all duration-500" 
                style={{ width: `${(downtime/total)*100}%` }} 
                title={`В простое: ${downtime} ТС`}
              />
            )}
            {maintenance > 0 && (
              <div 
                className="bg-amber-500 h-full transition-all duration-500" 
                style={{ width: `${(maintenance/total)*100}%` }} 
                title={`На ремонте: ${maintenance} ТС`}
              />
            )}
            {breakdown > 0 && (
              <div 
                className="bg-rose-500 h-full transition-all duration-500 relative before:absolute before:inset-0 before:bg-[linear-gradient(45deg,rgba(255,255,255,.15)_25%,transparent_25%,transparent_50%,rgba(255,255,255,.15)_50%,rgba(255,255,255,.15)_75%,transparent_75%,transparent)] before:bg-[length:8px_8px] animate-[pulse_1.5s_infinite]" 
                style={{ width: `${(breakdown/total)*100}%` }} 
                title={`Поломка: ${breakdown} ТС`}
              />
            )}
          </div>
          <div className="flex flex-wrap gap-x-4 gap-y-1 mt-2 text-[10px] font-mono text-slate-300">
            <span className="flex items-center"><span className="w-2.5 h-2.5 rounded bg-emerald-500 mr-1.5" />В рейсе ({inRoute})</span>
            <span className="flex items-center"><span className="w-2.5 h-2.5 rounded bg-teal-500 mr-1.5" />Готов / Свободен ({ready})</span>
            <span className="flex items-center"><span className="w-2.5 h-2.5 rounded bg-indigo-500 mr-1.5" />Простой / Логистика ({downtime})</span>
            <span className="flex items-center"><span className="w-2.5 h-2.5 rounded bg-amber-500 mr-1.5" />На ТО / Ремонте ({maintenance})</span>
            <span className="flex items-center"><span className="w-2.5 h-2.5 rounded bg-rose-500 mr-1.5" />Критическая авария ({breakdown})</span>
          </div>
        </div>
      </div>

      {/* Grid of KPI Stat Cards */}
      <div className="grid grid-cols-2 md:grid-cols-5 gap-4" id="kpi_metric_cards">
        
        {/* Card 1: В рейсе */}
        <div className="bg-slate-50 p-4 rounded-xl border border-slate-100 flex flex-col justify-between">
          <div className="flex items-center justify-between">
            <span className="text-xs font-semibold text-slate-500">В рейсе</span>
            <span className="p-1.5 bg-emerald-100 text-emerald-800 rounded-lg">
              <Truck size={14} className="stroke-[2.5]" />
            </span>
          </div>
          <div className="mt-3">
            <div className="text-2xl font-bold text-slate-800 font-mono">{inRoute}</div>
            <p className="text-[10px] text-emerald-600 font-semibold font-mono mt-0.5">
              {total > 0 ? Math.round((inRoute/total)*100) : 0}% от парка
            </p>
          </div>
        </div>

        {/* Card 2: Свободные / Готовы */}
        <div className="bg-slate-50 p-4 rounded-xl border border-slate-100 flex flex-col justify-between">
          <div className="flex items-center justify-between">
            <span className="text-xs font-semibold text-slate-500">Свободны</span>
            <span className="p-1.5 bg-teal-100 text-teal-800 rounded-lg">
              <Navigation size={14} />
            </span>
          </div>
          <div className="mt-3">
            <div className="text-2xl font-bold text-slate-800 font-mono">{ready}</div>
            <p className="text-[10px] text-teal-700 font-semibold font-mono mt-0.5">
              Готовы к назначению
            </p>
          </div>
        </div>

        {/* Card 3: На ТО / Ремонте */}
        <div className="bg-slate-50 p-4 rounded-xl border border-slate-100 flex flex-col justify-between">
          <div className="flex items-center justify-between">
            <span className="text-xs font-semibold text-slate-500">На ТО / Ремонте</span>
            <span className="p-1.5 bg-amber-100 text-amber-800 rounded-lg">
              <Wrench size={14} />
            </span>
          </div>
          <div className="mt-3">
            <div className="text-2xl font-bold text-slate-800 font-mono">{maintenance}</div>
            <p className="text-[10px] text-slate-500 font-semibold font-mono mt-0.5">
              Сервис и ТО-пробеги
            </p>
          </div>
        </div>

        {/* Card 4: Простой / Ожидание */}
        <div className="bg-slate-50 p-4 rounded-xl border border-slate-100 flex flex-col justify-between">
          <div className="flex items-center justify-between">
            <span className="text-xs font-semibold text-slate-500">В простое</span>
            <span className="p-1.5 bg-indigo-100 text-indigo-800 rounded-lg">
              <Clock size={14} />
            </span>
          </div>
          <div className="mt-3">
            <div className="text-2xl font-bold text-slate-800 font-mono">{downtime}</div>
            <p className="text-[10px] text-indigo-700 font-semibold font-mono mt-0.5">
              Потери логистики
            </p>
          </div>
        </div>

        {/* Card 5: Аварии / Поломки */}
        <div className="bg-slate-50 p-4 rounded-xl border border-slate-100 flex flex-col justify-between">
          <div className="flex items-center justify-between">
            <span className="text-xs font-semibold text-slate-500">Поломки</span>
            <span className={`p-1.5 rounded-lg flex items-center ${breakdown > 0 ? 'bg-red-100 text-red-800 animate-pulse' : 'bg-red-50 text-red-400'}`}>
              <ShieldAlert size={14} />
            </span>
          </div>
          <div className="mt-3">
            <div className={`text-2xl font-bold font-mono ${breakdown > 0 ? 'text-red-600' : 'text-slate-800'}`}>{breakdown}</div>
            <p className="text-[10px] text-red-500 font-semibold font-mono mt-0.5">
              {breakdown > 0 ? 'Критический простой!' : 'Нет происшествий'}
            </p>
          </div>
        </div>

      </div>

      {/* Main Grid: At Risk / Warnings vs. Latest Logs History */}
      <div className="grid grid-cols-1 lg:grid-cols-12 gap-6">
        
        {/* At Risk Vehicles (Left Area) */}
        <div className="lg:col-span-5 bg-white border border-slate-200 rounded-xl shadow-sm p-4" id="risk_control_panel">
          <div className="flex items-center justify-between pb-3 border-b border-slate-100 mb-4">
            <div className="flex items-center space-x-2">
              <AlertTriangle className="text-amber-500" size={18} />
              <h3 className="font-semibold text-sm text-slate-800">Контроль рисков простоев</h3>
            </div>
            <span className="bg-red-100 text-red-800 text-[10px] font-mono font-bold px-2 py-0.5 rounded-full">
              {atRisk.length} ТС под угрозой
            </span>
          </div>

          <div className="space-y-3 max-h-[350px] overflow-y-auto pr-1">
            {atRisk.length === 0 ? (
              <div className="text-center py-10 text-xs text-slate-400">
                Прекрасно! Все ТС находятся в штатном рабочем состоянии.
              </div>
            ) : (
              atRisk.map((item) => (
                <div 
                  key={item.id}
                  onClick={() => onSelectVehicle(item.plateNumber)}
                  className="p-3 bg-red-50/40 hover:bg-red-50 border border-red-100/80 rounded-xl transition cursor-pointer text-xs"
                >
                  <div className="flex items-center justify-between mb-1.5">
                    <span className="font-mono font-bold text-slate-850 bg-slate-100 px-1.5 py-0.5 rounded border border-slate-200">
                      {item.plateNumber}
                    </span>
                    <span className={`px-2 py-0.5 rounded-full text-[10px] font-semibold whitespace-nowrap ${
                      item.status === VehicleStatus.BREAKDOWN ? 'bg-red-100 text-red-800' :
                      item.status === VehicleStatus.DOWNTIME ? 'bg-indigo-100 text-indigo-850' : 'bg-amber-100 text-amber-850'
                    }`}>
                      {item.status === VehicleStatus.BREAKDOWN ? 'Авария/Ремонт' :
                       item.status === VehicleStatus.DOWNTIME ? 'Простой' : 'Внимание'}
                    </span>
                  </div>

                  <p className="font-semibold text-slate-700">{item.model}</p>
                  <p className="text-[11px] text-slate-500 font-sans mt-0.5">Водитель: {item.driver}</p>

                  {/* Context warnings */}
                  <div className="mt-2 flex flex-col gap-1 text-[11px] text-slate-600 font-mono bg-white p-2 rounded-lg border border-red-100">
                    {item.status === VehicleStatus.BREAKDOWN && (
                      <span className="text-red-700 font-medium">⚠️ Причина: {item.reason || 'Неисправность двигателя'}</span>
                    )}
                    {item.fuelLevel < 15 && (
                      <span className="text-amber-700 flex items-center gap-1"><Fuel size={11} /> Топливо критически мало: {item.fuelLevel}%</span>
                    )}
                    {item.engineTemp > 98 && (
                      <span className="text-red-700 flex items-center gap-1"><Gauge size={11} /> Температура ДВС критическая: {item.engineTemp}°C !</span>
                    )}
                    {!item.connectedGPS && (
                      <span className="text-indigo-700">📡 Потерян сигнал GPS/ГЛОНАСС в: {item.locationName}</span>
                    )}
                  </div>
                </div>
              ))
            )}
          </div>
        </div>

        {/* Latest Status Change Logs (Right Area) */}
        <div className="lg:col-span-7 bg-white border border-slate-200 rounded-xl shadow-sm p-4" id="status_history_timeline">
          <div className="flex items-center justify-between pb-3 border-b border-slate-100 mb-4">
            <div className="flex items-center space-x-2">
              <Clock className="text-slate-600" size={18} />
              <h3 className="font-semibold text-sm text-slate-800">Последние изменения статусов (Лента диспетчера)</h3>
            </div>
            <button
              onClick={() => onSelectTab('vehicles')}
              className="text-xs text-indigo-600 font-medium hover:underline cursor-pointer"
            >
              Вся история
            </button>
          </div>

          <div className="space-y-4 max-h-[350px] overflow-y-auto pr-1">
            {logs.length === 0 ? (
              <div className="text-center py-10 text-xs text-slate-400">
                История изменений пуста
              </div>
            ) : (
              logs.slice(0, 7).map((log) => (
                <div key={log.id} className="relative flex items-start space-x-3 text-xs">
                  {/* Circle indicating new status color */}
                  <span className={`w-3.5 h-3.5 rounded-full border-2 border-white mt-1 shrink-0 ${
                    log.newStatus === VehicleStatus.IN_ROUTE ? 'bg-emerald-500 shadow-[0_0_4px_#10b981]' :
                    log.newStatus === VehicleStatus.READY ? 'bg-teal-500' :
                    log.newStatus === VehicleStatus.DOWNTIME ? 'bg-indigo-500' :
                    log.newStatus === VehicleStatus.MAINTENANCE ? 'bg-amber-400' : 'bg-red-500 shadow-[0_0_4px_#ef4444]'
                  }`} />
                  
                  <div className="flex-1 bg-slate-50/50 hover:bg-slate-50 p-2.5 rounded-xl border border-slate-100 transition">
                    <div className="flex items-center justify-between mb-1">
                      <span className="font-mono font-bold text-slate-800">{log.vehiclePlate}</span>
                      <span className="text-[10px] text-slate-400 font-mono">
                        {new Date(log.timestamp).toLocaleTimeString('ru-RU', { hour: '2-digit', minute: '2-digit', second: '2-digit' })}
                      </span>
                    </div>

                    <p className="text-slate-700 font-sans">
                      Перевод ТС <span className="font-medium text-slate-600">{log.vehicleModel}</span> из{' '}
                      <span className="font-semibold text-slate-500">
                        {log.oldStatus === VehicleStatus.IN_ROUTE ? 'В рейсе' :
                         log.oldStatus === VehicleStatus.READY ? 'Готов' :
                         log.oldStatus === VehicleStatus.DOWNTIME ? 'Простой' :
                         log.oldStatus === VehicleStatus.MAINTENANCE ? 'ТО' : 'Поломка'}
                      </span>{' '}
                      в{' '}
                      <span className="font-bold text-slate-800">
                        {log.newStatus === VehicleStatus.IN_ROUTE ? 'В рейсе' :
                         log.newStatus === VehicleStatus.READY ? 'Готов' :
                         log.newStatus === VehicleStatus.DOWNTIME ? 'Простой' :
                         log.newStatus === VehicleStatus.MAINTENANCE ? 'ТО' : 'Поломка'}
                      </span>
                    </p>

                    {log.reason && (
                      <p className="mt-1 text-slate-600 italic bg-white py-1 px-2 rounded border border-slate-100 text-[11px] font-sans">
                        Причина: {log.reason}
                      </p>
                    )}

                    <div className="mt-1.5 text-[10px] text-slate-400 font-sans flex items-center justify-between">
                      <span>Инициатор: <strong className="text-slate-500">{log.changedBy}</strong></span>
                      <span className="text-[9px] bg-slate-200/60 text-slate-600 px-1.5 py-0.2 rounded uppercase tracking-wider font-semibold">
                        {log.changedByRole === 'dispatcher' ? 'Диспетчер' :
                         log.changedByRole === 'mechanic' ? 'Механик' : 'Директор'}
                      </span>
                    </div>
                  </div>
                </div>
              ))
            )}
          </div>
        </div>

      </div>
    </div>
  );
}
