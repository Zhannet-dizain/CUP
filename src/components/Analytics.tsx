/**
 * @license
 * SPDX-License-Identifier: Apache-2.0
 */

import React, { useState } from 'react';
import { AreaChart, TrendingUp, AlertCircle, Award, Hourglass, ShieldAlert, FileOutput, Printer, Lightbulb } from 'lucide-react';
import { Vehicle, VehicleStatus, StatusLogEntry } from '../types';

interface AnalyticsProps {
  vehicles: Vehicle[];
  logs: StatusLogEntry[];
}

export default function Analytics({ vehicles, logs }: AnalyticsProps) {
  // Analytical values
  const total = vehicles.length;
  const inRoute = vehicles.filter(v => v.status === VehicleStatus.IN_ROUTE).length;
  const ready = vehicles.filter(v => v.status === VehicleStatus.READY).length;
  const maintenance = vehicles.filter(v => v.status === VehicleStatus.MAINTENANCE).length;
  const downtime = vehicles.filter(v => v.status === VehicleStatus.DOWNTIME).length;
  const breakdown = vehicles.filter(v => v.status === VehicleStatus.BREAKDOWN).length;

  const kpiUptime = total > 0 ? Math.round(((inRoute + ready) / total) * 100) : 0;
  const fuelEfficiencyAverage = total > 0 ? Math.round(vehicles.reduce((acc, v) => acc + v.fuelLevel, 0) / total) : 0;
  
  // Simulated stats for fleet
  const totalDowntimeHoursThisMonth = 142;
  const costSavingsRub = '452,000 ₽';
  
  // Calculate average downtime duration from histories or mock
  const downtimeCount = logs.filter(l => l.newStatus === VehicleStatus.DOWNTIME).length;
  const meanTimeToRepairHrs = 3.6;

  // Let's create static arrays for our beautiful SVG diagrams
  const dailyDowntimeData = [
    { day: 'Пн', hours: 14 },
    { day: 'Вт', hours: 26 },
    { day: 'Ср', hours: 18 },
    { day: 'Чт', hours: 32 },
    { day: 'Пт', hours: 12 },
    { day: 'Сб', hours: 8 },
    { day: 'Вс', hours: 5 },
  ];

  const maxHours = Math.max(...dailyDowntimeData.map(d => d.hours));

  const reasonsDistribution = [
    { name: 'Ожидание загрузки (РЦ / Склады)', count: 42, color: 'bg-indigo-500' },
    { name: 'Внеплановые ремонты ДВС / Ходовой', count: 28, color: 'bg-amber-500' },
    { name: 'Оформление документов и пропусков', count: 18, color: 'bg-teal-500' },
    { name: 'Сменный отдых / Режим труда', count: 12, color: 'bg-emerald-500' },
    { name: 'Опоздания / Ожидание водителей', count: 5, color: 'bg-rose-500' },
  ];

  // Printable Report Generation Mock State
  const [exportComplete, setExportComplete] = useState<string | null>(null);
  const [exporting, setExporting] = useState(false);

  const handlePrint = () => {
    setExporting(true);
    setExportComplete(null);
    setTimeout(() => {
      setExporting(false);
      setExportComplete('Отчет по простоям и КРI успешно сгенерирован в PDF-формат! Файл отправлен на печать.');
    }, 1500);
  };

  const handleExcelExport = () => {
    setExporting(true);
    setExportComplete(null);
    setTimeout(() => {
      setExporting(false);
      setExportComplete('Таблица оперативной аналитики успешно экспортирована в Excel (.XLSX) и синхронизирована с 1С.');
    }, 1400);
  };

  return (
    <div className="space-y-6" id="analytics_view">
      
      {/* Upper bar with reports print / exports triggers */}
      <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-3 bg-white p-4 rounded-xl border border-slate-200 shadow-sm">
        <div>
          <h3 className="font-bold text-slate-800 text-sm">Панель бизнес-аналитики и КPI простоев</h3>
          <p className="text-xs text-slate-500 mt-0.5">Данные актуализированы в режиме реального времени и согласованы с ERP 1С:УАТ</p>
        </div>
        
        <div className="flex gap-2 self-stretch sm:self-auto">
          <button
            onClick={handleExcelExport}
            disabled={exporting}
            className="flex-1 sm:flex-initial py-1.5 px-3 bg-emerald-50/80 text-emerald-800 hover:bg-emerald-100 border border-emerald-200 hover:border-emerald-300 rounded-lg text-xs font-semibold flex items-center justify-center space-x-1.5 transition cursor-pointer"
          >
            <FileOutput size={14} />
            <span>Экспорт в Excel</span>
          </button>
          <button
            onClick={handlePrint}
            disabled={exporting}
            className="flex-1 sm:flex-initial py-1.5 px-3 bg-indigo-50/80 text-indigo-800 hover:bg-indigo-100 border border-indigo-200 hover:border-indigo-300 rounded-lg text-xs font-semibold flex items-center justify-center space-x-1.5 transition cursor-pointer"
          >
            <Printer size={14} />
            <span>Печать PDF отчета</span>
          </button>
        </div>
      </div>

      {/* Export notification popup banner */}
      {exportComplete && (
        <div className="bg-emerald-50 border border-emerald-200 p-3.5 rounded-xl text-xs text-emerald-850 flex items-start space-x-2 animate-in fade-in slide-in-from-top-1">
          <Award size={16} className="text-emerald-600 shrink-0 mt-0.5" />
          <div className="flex-1">
            <p className="font-bold">Успешный экспорт данных</p>
            <p className="mt-0.5 text-[11px] text-emerald-700">{exportComplete}</p>
          </div>
          <button onClick={() => setExportComplete(null)} className="text-emerald-500 hover:text-emerald-800 font-bold">×</button>
        </div>
      )}

      {/* Dashboard Top KPI Cards */}
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4" id="kpi_analytics_grid">
        
        {/* KPI 1 */}
        <div className="bg-white p-4 rounded-xl border border-slate-200 shadow-sm flex items-start space-x-3">
          <span className="p-2.5 bg-emerald-100 text-emerald-800 rounded-xl">
            <TrendingUp size={18} />
          </span>
          <div>
            <span className="text-[10px] text-slate-400 font-bold uppercase block tracking-wider">Доступность флота</span>
            <span className="text-2xl font-bold text-slate-800 font-mono">{kpiUptime}%</span>
            <p className="text-[10px] text-emerald-600 font-sans mt-0.5 font-semibold">Целевой показатель: &gt;90%</p>
          </div>
        </div>

        {/* KPI 2 */}
        <div className="bg-white p-4 rounded-xl border border-slate-200 shadow-sm flex items-start space-x-3">
          <span className="p-2.5 bg-indigo-100 text-indigo-800 rounded-xl">
            <Hourglass size={18} />
          </span>
          <div>
            <span className="text-[10px] text-slate-400 font-bold uppercase block tracking-wider">Часы простоя в сут.</span>
            <span className="text-2xl font-bold text-slate-800 font-mono">1.8 ч</span>
            <p className="text-[10px] text-emerald-600 font-sans mt-0.5 font-semibold">↓ снижено на 14% с прошлого месяца</p>
          </div>
        </div>

        {/* KPI 3 */}
        <div className="bg-white p-4 rounded-xl border border-slate-200 shadow-sm flex items-start space-x-3">
          <span className="p-2.5 bg-amber-100 text-amber-800 rounded-xl">
            <AlertCircle size={18} />
          </span>
          <div>
            <span className="text-[10px] text-slate-400 font-bold uppercase block tracking-wider">Среднее КТГ ремонта</span>
            <span className="text-2xl font-bold text-slate-800 font-mono">{meanTimeToRepairHrs} ч</span>
            <p className="text-[10px] text-amber-600 font-sans mt-0.5 font-semibold">Время решения неисправностей</p>
          </div>
        </div>

        {/* KPI 4 */}
        <div className="bg-white p-4 rounded-xl border border-slate-200 shadow-sm flex items-start space-x-3">
          <span className="p-2.5 bg-rose-100 text-rose-800 rounded-xl">
            <ShieldAlert size={18} />
          </span>
          <div>
            <span className="text-[10px] text-slate-400 font-bold uppercase block tracking-wider">Сокращено простоев на</span>
            <span className="text-2xl font-bold text-slate-800 font-mono">{costSavingsRub}</span>
            <p className="text-[10px] text-rose-600 font-sans mt-0.5 font-semibold">Сэкономлено за счет быстрого вывода</p>
          </div>
        </div>

      </div>

      {/* Main Charts area */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6" id="analytics_trend_charts">
        
        {/* Chart A: Downtime hours per day (SVG Bar Chart) */}
        <div className="bg-white border border-slate-200 rounded-xl shadow-sm p-4">
          <h3 className="font-bold text-sm text-slate-800 mb-4 flex items-center justify-between">
            <span>Общие часы операционных простоев по дням недели</span>
            <span className="text-[11px] text-indigo-600 font-semibold font-mono">Последние 7 дней</span>
          </h3>

          {/* SVG Diagram Canvas */}
          <div className="relative h-60 w-full flex items-end justify-between px-2 pt-6">
            {dailyDowntimeData.map((data, idx) => {
              const heightPercent = maxHours > 0 ? (data.hours / maxHours) * 75 : 0;
              return (
                <div key={idx} className="flex flex-col items-center flex-1 group">
                  {/* Tooltip on hover */}
                  <div className="absolute opacity-0 group-hover:opacity-100 transition-opacity duration-200 bg-slate-900 text-white font-mono text-[10px] py-1 px-2 rounded -translate-y-8 pointer-events-none z-10 shadow-md">
                    {data.hours} ч. простоя
                  </div>

                  {/* Active Bar */}
                  <div 
                    className="w-8 sm:w-12 bg-gradient-to-t from-indigo-600 to-indigo-400 hover:from-indigo-500 hover:to-cyan-400 rounded-t transition-all duration-500 cursor-pointer shadow-sm relative"
                    style={{ height: `${heightPercent}%`, minHeight: '4px' }}
                  >
                    {/* Tiny stats number on bar top */}
                    <span className="absolute -top-5 left-1/2 -translate-x-1/2 text-[10px] text-slate-500 font-mono font-bold">
                      {data.hours}ч
                    </span>
                  </div>

                  {/* Label X */}
                  <span className="text-xs text-slate-500 mt-2 font-semibold font-mono">
                    {data.day}
                  </span>
                </div>
              );
            })}
          </div>

          <div className="flex justify-between items-center text-[10px] text-slate-400 font-mono mt-4 pt-2 border-t border-slate-100">
            <span>Максимальное значение: {maxHours} часов</span>
            <span>Минимум: 5 часов (Вс)</span>
          </div>
        </div>

        {/* Chart B: Distribution of downtime reasons (Dynamic progress list) */}
        <div className="bg-white border border-slate-200 rounded-xl shadow-sm p-4">
          <h3 className="font-bold text-sm text-slate-800 mb-4">Структура и ключевые причины простоев ТС (%)</h3>

          <div className="space-y-4">
            {reasonsDistribution.map((item, idx) => {
              const totalItems = reasonsDistribution.reduce((acc, r) => acc + r.count, 0);
              const percentage = Math.round((item.count / totalItems) * 100);

              return (
                <div key={idx} className="space-y-1">
                  <div className="flex justify-between text-xs font-sans">
                    <span className="text-slate-700 font-medium">{item.name}</span>
                    <span className="font-mono text-slate-500 font-bold">{percentage}% ({item.count} случ)</span>
                  </div>
                  <div className="h-2 w-full bg-slate-150 rounded-full overflow-hidden">
                    <div 
                      className={`h-full ${item.color} rounded-full transition-all duration-500`}
                      style={{ width: `${percentage}%` }}
                    />
                  </div>
                </div>
              );
            })}
          </div>

          <p className="text-[11px] text-slate-500 leading-relaxed font-sans mt-5 bg-slate-50 p-2.5 rounded-lg border border-slate-150/50 flex gap-1.5 items-start">
            <Lightbulb className="text-indigo-600 shrink-0" size={14} />
            <span>Диспетчерам рекомендуется заблаговременно отсылать товарно-транспортные документы (ТТН) в Личные Кабинеты водителей, чтобы сократить время простоя на въезде в РЦ Пятерочка/Магнит еще до прибытия.</span>
          </p>
        </div>

      </div>

      {/* Grid of Downtime Discipline Vehicle Leaderboard */}
      <div className="bg-white border border-slate-200 rounded-xl shadow-sm overflow-hidden" id="analytics_discipline_leaderboard">
        <div className="px-5 py-4 border-b border-slate-105 flex items-center justify-between">
          <h3 className="font-bold text-sm text-slate-800">Анализ дисциплины движения флота / Задержки и нарушения простоев</h3>
          <span className="text-xs bg-slate-100 text-slate-600 py-0.5 px-2 rounded-full font-mono">Контроль логистических простоев</span>
        </div>

        <table className="w-full text-left border-collapse text-xs">
          <thead>
            <tr className="bg-slate-50 border-b border-slate-100 text-slate-400 font-mono">
              <th className="py-3 px-4 font-semibold uppercase tracking-wider">Госномер / Спецификация ТС</th>
              <th className="py-3 px-4 font-semibold uppercase tracking-wider">Водитель ТС</th>
              <th className="py-3 px-4 font-semibold uppercase tracking-wider">Текущий / Последний статус</th>
              <th className="py-3 px-4 font-semibold uppercase tracking-wider">Остаток бака</th>
              <th className="py-3 px-4 font-semibold uppercase tracking-wider">Потеря связи GPS</th>
              <th className="py-3 px-4 font-semibold uppercase tracking-wider text-right">Потери за сутки (руб.)</th>
            </tr>
          </thead>
          <tbody className="divide-y divide-slate-100 text-slate-700">
            {vehicles.map((v) => {
              // Simulated calculate day losses
              let dailyLossStr = '0 ₽';
              if (v.status === VehicleStatus.BREAKDOWN) dailyLossStr = '45,000 ₽';
              else if (v.status === VehicleStatus.DOWNTIME) dailyLossStr = '22,400 ₽';
              else if (v.status === VehicleStatus.MAINTENANCE) dailyLossStr = '12,000 ₽';
              
              return (
                <tr key={v.id} className="hover:bg-slate-50 transition">
                  <td className="py-3 px-4">
                    <div className="flex items-center space-x-2">
                      <span className="font-mono font-bold bg-slate-900 text-white py-0.5 px-1.5 rounded">{v.plateNumber}</span>
                      <span className="text-slate-500 font-sans truncate max-w-[120px]">{v.model}</span>
                    </div>
                  </td>
                  <td className="py-3 px-4 font-medium">{v.driver}</td>
                  <td className="py-3 px-4">
                    <span className={`inline-flex items-center space-x-1 font-bold ${
                      v.status === VehicleStatus.IN_ROUTE ? 'text-emerald-600' :
                      v.status === VehicleStatus.READY ? 'text-cyan-600' :
                      v.status === VehicleStatus.DOWNTIME ? 'text-indigo-600' :
                      v.status === VehicleStatus.MAINTENANCE ? 'text-amber-650' : 'text-red-650'
                    }`}>
                      <span className={`w-1.5 h-1.5 rounded-full ${
                        v.status === VehicleStatus.IN_ROUTE ? 'bg-emerald-500' :
                        v.status === VehicleStatus.READY ? 'bg-cyan-500' :
                        v.status === VehicleStatus.DOWNTIME ? 'bg-indigo-500' :
                        v.status === VehicleStatus.MAINTENANCE ? 'bg-amber-500' : 'bg-red-500'
                      }`} />
                      <span>
                        {v.status === VehicleStatus.IN_ROUTE ? 'В рейсе' :
                         v.status === VehicleStatus.READY ? 'Свободен' :
                         v.status === VehicleStatus.DOWNTIME ? 'Простой' :
                         v.status === VehicleStatus.MAINTENANCE ? 'Сервис' : 'Поломка'}
                      </span>
                    </span>
                  </td>
                  <td className="py-3 px-4 font-mono font-bold text-slate-800">{v.fuelLevel}%</td>
                  <td className="py-3 px-4 font-semibold text-slate-600">
                    {v.connectedGPS ? (
                      <span className="text-emerald-600">Сигнал ОК</span>
                    ) : (
                      <span className="text-red-500 flex items-center gap-1">📡 Нет связи ({v.locationName})</span>
                    )}
                  </td>
                  <td className="py-3 px-4 text-right font-mono font-bold text-slate-800">{dailyLossStr}</td>
                </tr>
              );
            })}
          </tbody>
        </table>
      </div>

    </div>
  );
}
