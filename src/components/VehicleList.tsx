/**
 * @license
 * SPDX-License-Identifier: Apache-2.0
 */

import React, { useState } from 'react';
import { 
  Search, Info, User, Phone, MapPin, Fuel, Gauge, Navigation, 
  Wrench, ShieldAlert, Clock, Check, X, ClipboardList, Send, AlertTriangle
} from 'lucide-react';
import { Vehicle, VehicleStatus, StatusLogEntry, UserRole } from '../types';

interface VehicleListProps {
  vehicles: Vehicle[];
  currentRole: UserRole;
  onUpdateStatus: (vehicleId: string, newStatus: VehicleStatus, reason: string) => void;
  logs: StatusLogEntry[];
  selectedPlateFromDashboard: string | null;
  onClearSelectedPlate: () => void;
}

export default function VehicleList({ 
  vehicles, 
  currentRole, 
  onUpdateStatus, 
  logs,
  selectedPlateFromDashboard,
  onClearSelectedPlate
}: VehicleListProps) {
  const [search, setSearch] = useState('');
  const [statusFilter, setStatusFilter] = useState<'ALL' | VehicleStatus>('ALL');
  const [activeVehicleIdForStatusEdit, setActiveVehicleIdForStatusEdit] = useState<string | null>(null);
  
  // High efficiency click-to-select reasons mapping
  const quickReasons: Record<VehicleStatus, string[]> = {
    [VehicleStatus.IN_ROUTE]: [
      'Выезд по накладной в рейс',
      'Срочный догруз на маршруте',
      'Возврат машины на линию',
      'Рейс начат вовремя'
    ],
    [VehicleStatus.READY]: [
      'Осмотр пройден, ТС готово',
      'Ремонт официально окончен',
      'Выгрузка / Документы сданы',
      'Готов к новому рейсу'
    ],
    [VehicleStatus.MAINTENANCE]: [
      'Плановое ТО (замена масла)',
      'Ремонт тормозных колодок',
      'Диагностика электроники',
      'Сезонная замена резины'
    ],
    [VehicleStatus.DOWNTIME]: [
      'Ожидание загрузки склада',
      'Нет груза на обратное плечо',
      'Оформление ТТН и пропусков',
      'Сменный отдых / Сон водителя'
    ],
    [VehicleStatus.BREAKDOWN]: [
      'Критический перегрев ДВС',
      'Повреждение подвески на трассе',
      'ДТП / Столкновение с ТС',
      'Порез грузовой шины (колесо)'
    ],
  };

  // Status transitions state
  const [selectedNewStatus, setSelectedNewStatus] = useState<VehicleStatus | null>(null);
  const [enteredReason, setEnteredReason] = useState('');
  const [selectedLogsVehicleId, setSelectedLogsVehicleId] = useState<string | null>(null);

  // If redirected from dashboard, let's search/pre-filter
  React.useEffect(() => {
    if (selectedPlateFromDashboard) {
      setSearch(selectedPlateFromDashboard);
      setStatusFilter('ALL');
      onClearSelectedPlate();
    }
  }, [selectedPlateFromDashboard]);

  // Filters application
  const filteredVehicles = vehicles.filter((v) => {
    const matchesSearch = 
      v.plateNumber.toLowerCase().includes(search.toLowerCase()) ||
      v.driver.toLowerCase().includes(search.toLowerCase()) ||
      v.model.toLowerCase().includes(search.toLowerCase());
    
    const matchesStatus = statusFilter === 'ALL' ? true : v.status === statusFilter;
    
    return matchesSearch && matchesStatus;
  });

  // Handle high efficiency status update
  const submitStatusUpdate = (vehicleId: string, status: VehicleStatus, reasonStr: string) => {
    const finalReason = reasonStr.trim() || 'Оперативное изменение статуса без указания спец. деталей';
    onUpdateStatus(vehicleId, status, finalReason);
    // Reset edit overlay state
    setActiveVehicleIdForStatusEdit(null);
    setSelectedNewStatus(null);
    setEnteredReason('');
  };

  return (
    <div className="space-y-6" id="vehicle_control_view">
      
      {/* Upper Filter & Navigation Panel */}
      <div className="bg-white border border-slate-200 rounded-xl p-4 shadow-sm space-y-4">
        
        {/* Row 1: Search and Info info bar */}
        <div className="flex flex-col md:flex-row gap-3 items-center justify-between">
          <div className="relative w-full md:max-w-md">
            <span className="absolute inset-y-0 left-0 flex items-center pl-3 pointer-events-none text-slate-400">
              <Search size={16} />
            </span>
            <input
              type="text"
              placeholder="Поиск по госномеру ТС, водителю или марке (Volvo, Камаз...)"
              value={search}
              onChange={(e) => setSearch(e.target.value)}
              className="w-full pl-10 pr-4 py-2 border border-slate-200 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-emerald-500/20 focus:border-emerald-500 text-slate-800"
            />
            {search && (
              <button 
                onClick={() => setSearch('')}
                className="absolute inset-y-0 right-0 flex items-center pr-3 text-slate-400 hover:text-slate-600"
              >
                <X size={14} />
              </button>
            )}
          </div>

          <div className="flex items-center space-x-2 text-xs text-slate-500 bg-slate-50 border border-slate-100 rounded-lg px-3 py-1.5 self-stretch md:self-auto justify-center">
            <Info size={14} className="text-indigo-500" />
            <span>Ваша роль: <strong>{currentRole.role === 'manager' ? 'Руководитель' : currentRole.role === 'mechanic' ? 'Главный механик' : 'Диспетчер'}</strong>. Смена статусов доступна оперативно.</span>
          </div>
        </div>

        {/* Row 2: Status Quick Filters with Color Badges */}
        <div className="flex flex-wrap gap-2 pt-2 border-t border-slate-100">
          <button
            onClick={() => setStatusFilter('ALL')}
            className={`px-3 py-1.5 rounded-lg text-xs font-semibold font-sans transition cursor-pointer flex items-center space-x-2 border ${
              statusFilter === 'ALL'
                ? 'bg-slate-900 border-slate-900 text-white'
                : 'bg-white hover:bg-slate-50 border-slate-250 text-slate-600'
            }`}
          >
            <span>Все машины</span>
            <span className={`text-[10px] py-0.1 px-1.5 rounded-full ${statusFilter === 'ALL' ? 'bg-slate-700/80 text-white' : 'bg-slate-100 text-slate-600'}`}>
              {vehicles.length}
            </span>
          </button>

          <button
            onClick={() => setStatusFilter(VehicleStatus.IN_ROUTE)}
            className={`px-3 py-1.5 rounded-lg text-xs font-semibold font-sans transition cursor-pointer flex items-center space-x-2 border ${
              statusFilter === VehicleStatus.IN_ROUTE
                ? 'bg-emerald-650 border-emerald-650 text-white'
                : 'bg-white hover:bg-emerald-50/50 border-emerald-200 text-emerald-800'
            }`}
          >
            <span className="w-2 h-2 rounded-full bg-emerald-500 shrink-0" />
            <span>В рейсе</span>
            <span className={`text-[10px] py-0.1 px-1.5 rounded-full ${statusFilter === VehicleStatus.IN_ROUTE ? 'bg-emerald-800 text-white' : 'bg-emerald-50 text-emerald-800'}`}>
              {vehicles.filter(v => v.status === VehicleStatus.IN_ROUTE).length}
            </span>
          </button>

          <button
            onClick={() => setStatusFilter(VehicleStatus.READY)}
            className={`px-3 py-1.5 rounded-lg text-xs font-semibold font-sans transition cursor-pointer flex items-center space-x-2 border ${
              statusFilter === VehicleStatus.READY
                ? 'bg-cyan-650 border-cyan-650 text-white'
                : 'bg-white hover:bg-cyan-50 border-cyan-205 text-cyan-800'
            }`}
          >
            <span className="w-2 h-2 rounded-full bg-cyan-400 shrink-0" />
            <span>Свободны</span>
            <span className={`text-[10px] py-0.1 px-1.5 rounded-full ${statusFilter === VehicleStatus.READY ? 'bg-cyan-800 text-white' : 'bg-cyan-50 text-cyan-800'}`}>
              {vehicles.filter(v => v.status === VehicleStatus.READY).length}
            </span>
          </button>

          <button
            onClick={() => setStatusFilter(VehicleStatus.MAINTENANCE)}
            className={`px-3 py-1.5 rounded-lg text-xs font-semibold font-sans transition cursor-pointer flex items-center space-x-2 border ${
              statusFilter === VehicleStatus.MAINTENANCE
                ? 'bg-amber-500 border-amber-500 text-white'
                : 'bg-white hover:bg-amber-50 border-amber-200 text-amber-850'
            }`}
          >
            <span className="w-2 h-2 rounded-full bg-amber-500 shrink-0" />
            <span>ТО / Ремонт</span>
            <span className={`text-[10px] py-0.1 px-1.5 rounded-full ${statusFilter === VehicleStatus.MAINTENANCE ? 'bg-amber-800 text-white' : 'bg-amber-100 text-amber-850'}`}>
              {vehicles.filter(v => v.status === VehicleStatus.MAINTENANCE).length}
            </span>
          </button>

          <button
            onClick={() => setStatusFilter(VehicleStatus.DOWNTIME)}
            className={`px-3 py-1.5 rounded-lg text-xs font-semibold font-sans transition cursor-pointer flex items-center space-x-2 border ${
              statusFilter === VehicleStatus.DOWNTIME
                ? 'bg-indigo-600 border-indigo-600 text-white'
                : 'bg-white hover:bg-indigo-50 border-indigo-200 text-indigo-800'
            }`}
          >
            <span className="w-2 h-2 rounded-full bg-indigo-550 shrink-0" />
            <span>Простой</span>
            <span className={`text-[10px] py-0.1 px-1.5 rounded-full ${statusFilter === VehicleStatus.DOWNTIME ? 'bg-indigo-800 text-white' : 'bg-indigo-50 text-indigo-800'}`}>
              {vehicles.filter(v => v.status === VehicleStatus.DOWNTIME).length}
            </span>
          </button>

          <button
            onClick={() => setStatusFilter(VehicleStatus.BREAKDOWN)}
            className={`px-3 py-1.5 rounded-lg text-xs font-semibold font-sans transition cursor-pointer flex items-center space-x-2 border ${
              statusFilter === VehicleStatus.BREAKDOWN
                ? 'bg-red-600 border-red-600 text-white'
                : 'bg-white hover:bg-rose-50 border-red-200 text-red-800'
            }`}
          >
            <span className="w-2 h-2 rounded-full bg-red-650 shrink-0 animate-ping" />
            <span>Авария</span>
            <span className={`text-[10px] py-0.1 px-1.5 rounded-full ${statusFilter === VehicleStatus.BREAKDOWN ? 'bg-red-800 text-white' : 'bg-rose-100 text-red-800'}`}>
              {vehicles.filter(v => v.status === VehicleStatus.BREAKDOWN).length}
            </span>
          </button>
        </div>

      </div>

      {/* Main Vehicle Grid */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6" id="vehicles_dashboard_grid">
        {filteredVehicles.length === 0 ? (
          <div className="col-span-full bg-slate-50 text-center py-16 rounded-xl border border-dashed border-slate-300 text-slate-500">
            <p className="text-sm font-semibold">ТС по заданному фильтру не найдено</p>
            <p className="text-xs text-slate-400 mt-1">Попробуйте ввести другой госномер или изменить параметры фильтра статусов</p>
          </div>
        ) : (
          filteredVehicles.map((vehicle) => {
            const isEditingThisVehicle = activeVehicleIdForStatusEdit === vehicle.id;
            
            // Format status dates for age
            const minutesInStatus = Math.round((Date.now() - new Date(vehicle.lastStatusChange).getTime()) / 60000);
            let timeInStatusStr = '';
            if (minutesInStatus < 60) {
              timeInStatusStr = `${minutesInStatus} мин`;
            } else if (minutesInStatus < 1440) {
              timeInStatusStr = `${Math.floor(minutesInStatus / 60)}ч ${minutesInStatus % 60}м`;
            } else {
              timeInStatusStr = `${Math.floor(minutesInStatus / 1440)}д ${Math.floor((minutesInStatus % 1440) / 60)}ч`;
            }

            return (
              <div 
                key={vehicle.id} 
                className={`bg-white border rounded-xl overflow-hidden shadow-sm transition hover:shadow-md flex flex-col justify-between ${
                  vehicle.status === VehicleStatus.BREAKDOWN 
                    ? 'border-red-200 shadow-red-50/50 hover:border-red-300' 
                    : 'border-slate-200 hover:border-slate-300'
                }`}
                id={`vehicle_card_${vehicle.id}`}
              >
                
                {/* Card Header (Plate & Status Light) */}
                <div className={`px-4 py-3 border-b flex items-center justify-between ${
                  vehicle.status === VehicleStatus.BREAKDOWN ? 'bg-rose-50/50 border-rose-100' :
                  vehicle.status === VehicleStatus.MAINTENANCE ? 'bg-amber-50/20 border-amber-100/50' : 'bg-slate-50/50 border-slate-100'
                }`}>
                  <div className="flex items-center space-x-2">
                    <span className="font-mono text-xs font-bold tracking-tight bg-slate-800 text-white px-2 py-0.5 rounded border border-slate-700">
                      {vehicle.plateNumber}
                    </span>
                    <span className="text-[10px] text-slate-400 font-mono">
                      {vehicle.type === 'Truck' ? 'Тягач' : vehicle.type === 'LCV' ? 'Малый груз' : 'Спецтехника'}
                    </span>
                  </div>

                  {/* Status Indicator Pill */}
                  <span className={`px-2 py-0.5 rounded-full text-[10px] font-bold uppercase tracking-wider font-sans whitespace-nowrap inline-flex items-center gap-1 ${
                    vehicle.status === VehicleStatus.IN_ROUTE ? 'bg-emerald-100 text-emerald-800 shadow-[0_0_8px_rgba(16,185,129,0.15)]' :
                    vehicle.status === VehicleStatus.READY ? 'bg-cyan-100 text-cyan-800' :
                    vehicle.status === VehicleStatus.DOWNTIME ? 'bg-indigo-100 text-indigo-800' :
                    vehicle.status === VehicleStatus.MAINTENANCE ? 'bg-amber-100 text-amber-850' : 'bg-red-150 text-red-800 animate-pulse'
                  }`}>
                    <span className={`w-1.5 h-1.5 rounded-full ${
                      vehicle.status === VehicleStatus.IN_ROUTE ? 'bg-emerald-500' :
                      vehicle.status === VehicleStatus.READY ? 'bg-cyan-500' :
                      vehicle.status === VehicleStatus.DOWNTIME ? 'bg-indigo-500' :
                      vehicle.status === VehicleStatus.MAINTENANCE ? 'bg-amber-500' : 'bg-red-650'
                    }`} />
                    {vehicle.status === VehicleStatus.IN_ROUTE ? 'В рейсе' :
                     vehicle.status === VehicleStatus.READY ? 'Готов к работе' :
                     vehicle.status === VehicleStatus.DOWNTIME ? 'В простое' :
                     vehicle.status === VehicleStatus.MAINTENANCE ? 'На ТО / Сервисе' : 'Авария / Поломка'}
                  </span>
                </div>

                {/* Card Body - Vehicle Info */}
                <div className="p-4 space-y-3 flex-grow text-xs">
                  
                  <div>
                    <h4 className="font-bold text-slate-800 font-sans text-sm leading-tight">{vehicle.model}</h4>
                    <div className="flex items-center space-x-1 text-[11px] text-slate-600 mt-1 font-sans">
                      <User size={12} className="text-slate-400" />
                      <span>{vehicle.driver}</span>
                      <span className="text-slate-300">|</span>
                      <Phone size={11} className="text-slate-400" />
                      <span className="hover:underline">{vehicle.driverPhone}</span>
                    </div>
                  </div>

                  {/* Downtime reason display in emphasis area if exists */}
                  {(vehicle.status === VehicleStatus.BREAKDOWN || vehicle.status === VehicleStatus.DOWNTIME || vehicle.status === VehicleStatus.MAINTENANCE) && (
                    <div className={`p-2.5 rounded-lg border-l-4 text-[11px] ${
                      vehicle.status === VehicleStatus.BREAKDOWN ? 'bg-red-50 border-red-550 text-red-800' :
                      vehicle.status === VehicleStatus.DOWNTIME ? 'bg-indigo-50/50 border-indigo-500 text-indigo-900' :
                      'bg-amber-50/40 border-amber-500 text-amber-900'
                    }`}>
                      <p className="font-semibold block uppercase tracking-wide text-[9px] mb-0.5 text-slate-500">
                        {vehicle.status === VehicleStatus.BREAKDOWN ? 'Причина неисправности:' : 
                         vehicle.status === VehicleStatus.DOWNTIME ? 'Статус лога простоя:' : 'Сервисная задача:'}
                      </p>
                      <p className="italic leading-relaxed">
                        {vehicle.reason || 'Детали не указаны оператором.'}
                      </p>
                    </div>
                  )}

                  {/* Telematics values section */}
                  <div className="grid grid-cols-2 gap-x-2 gap-y-1.5 pt-2 border-t border-slate-105 text-[11px] font-mono">
                    <div className="flex items-center space-x-1.5 text-slate-600">
                      <Fuel size={12} className={vehicle.fuelLevel < 15 ? 'text-red-500 animate-bounce' : 'text-slate-400'} />
                      <span>Топливо: <strong className={vehicle.fuelLevel < 15 ? 'text-red-600 font-bold' : 'text-slate-700'}>{vehicle.fuelLevel}%</strong></span>
                    </div>
                    <div className="flex items-center space-x-1.5 text-slate-600">
                      <Gauge size={12} className="text-slate-400" />
                      <span>Одометр: <strong className="text-slate-700">{vehicle.odometer.toLocaleString('ru-RU')} км</strong></span>
                    </div>
                    <div className="flex items-center space-x-1.5 text-slate-600 col-span-2">
                      <MapPin size={12} className="text-slate-400 shrink-0" />
                      <span className="truncate" title={vehicle.locationName}>Локация: <strong className="text-slate-700">{vehicle.locationName}</strong></span>
                    </div>
                    <div className="flex items-center space-x-1.5 text-slate-600">
                      <span className="w-1.5 h-1.5 rounded-full bg-slate-400 shrink-0" />
                      <span>В статусе: <strong className="text-slate-700">{timeInStatusStr}</strong></span>
                    </div>
                    <div className="flex items-center space-x-1.5 text-slate-600">
                      <span className={`w-1.5 h-1.5 rounded-full shrink-0 ${vehicle.connectedGPS ? 'bg-emerald-500' : 'bg-red-500'}`} />
                      <span>ГЛОНАСС: <strong className={vehicle.connectedGPS ? 'text-emerald-700' : 'text-red-600'}>{vehicle.connectedGPS ? 'Активен' : 'Отказ'}</strong></span>
                    </div>
                  </div>

                </div>

                {/* Card Controls Overlay / Footer */}
                <div className="px-4 py-3 bg-slate-50 border-t border-slate-100 flex flex-col space-y-2">
                  {!isEditingThisVehicle ? (
                    <div className="flex items-center justify-between">
                      <button
                        onClick={() => setSelectedLogsVehicleId(selectedLogsVehicleId === vehicle.id ? null : vehicle.id)}
                        className="text-slate-500 hover:text-slate-800 text-[11px] font-sans flex items-center space-x-1 cursor-pointer"
                      >
                        <ClipboardList size={13} />
                        <span>{selectedLogsVehicleId === vehicle.id ? 'Скрыть историю' : 'История смен'}</span>
                      </button>

                      <button
                        onClick={() => {
                          setActiveVehicleIdForStatusEdit(vehicle.id);
                          // De-select pre-selected new status or sets it to direct next state recommendation
                          setSelectedNewStatus(null);
                          setEnteredReason('');
                        }}
                        className="px-3 py-1 bg-slate-900 text-white hover:bg-slate-800 text-[11px] font-bold rounded-lg transition shadow-sm hover:shadow active:scale-95 cursor-pointer"
                      >
                        Изменить статус
                      </button>
                    </div>
                  ) : (
                    <div className="bg-slate-100 p-3 rounded-lg border border-slate-200 text-xs text-slate-800 space-y-3">
                      <div className="flex items-center justify-between border-b border-slate-200 pb-1.5">
                        <span className="font-semibold font-sans text-slate-700">Смена статуса</span>
                        <button 
                          onClick={() => {
                            setActiveVehicleIdForStatusEdit(null);
                            setSelectedNewStatus(null);
                          }}
                          className="text-slate-400 hover:text-slate-600"
                        >
                          <X size={14} />
                        </button>
                      </div>

                      {/* MINIMUM CLICKS: 1-Click Status Selectors with visual indicators */}
                      <div>
                        <p className="text-[10px] text-slate-500 font-bold mb-1 uppercase">Выберите статус (1 клик):</p>
                        <div className="grid grid-cols-5 gap-1">
                          {Object.values(VehicleStatus).map((status) => {
                            const isSelected = selectedNewStatus === status || (selectedNewStatus === null && vehicle.status === status);
                            let bgClr = '';
                            let textClr = '';
                            let label = '';
                            
                            switch (status) {
                              case VehicleStatus.IN_ROUTE:
                                bgClr = 'border-emerald-500 hover:bg-emerald-50';
                                textClr = isSelected ? 'bg-emerald-500 text-white' : 'text-emerald-700';
                                label = 'Рейс';
                                break;
                              case VehicleStatus.READY:
                                bgClr = 'border-cyan-500 hover:bg-cyan-5';
                                textClr = isSelected ? 'bg-cyan-500 text-white' : 'text-cyan-700';
                                label = 'Готов';
                                break;
                              case VehicleStatus.MAINTENANCE:
                                bgClr = 'border-amber-500 hover:bg-amber-50';
                                textClr = isSelected ? 'bg-amber-500 text-white' : 'text-amber-800';
                                label = 'ТО/Р';
                                break;
                              case VehicleStatus.DOWNTIME:
                                bgClr = 'border-indigo-500 hover:bg-indigo-50';
                                textClr = isSelected ? 'bg-indigo-600 text-white' : 'text-indigo-800';
                                label = 'Прост';
                                break;
                              case VehicleStatus.BREAKDOWN:
                                bgClr = 'border-red-500 hover:bg-red-50';
                                textClr = isSelected ? 'bg-red-600 text-white' : 'text-red-700';
                                label = 'Авар';
                                break;
                            }

                            return (
                              <button
                                key={status}
                                type="button"
                                onClick={() => {
                                  setSelectedNewStatus(status);
                                  // Clear typed reason to let user choose quick reasons or keep it
                                  setEnteredReason('');
                                }}
                                className={`py-1.5 border rounded text-[10px] font-bold font-mono transition text-center cursor-pointer ${bgClr} ${textClr} ${
                                  isSelected ? 'ring-2 ring-indigo-500/30 font-extrabold' : 'border-slate-300'
                                }`}
                                title={status}
                              >
                                {label}
                              </button>
                            );
                          })}
                        </div>
                      </div>

                      {/* MINIMUM CLICKS: Quick Reason selectors depending on status selection */}
                      <div className="bg-white p-2 rounded border border-slate-250">
                        <p className="text-[10px] text-slate-500 font-semibold mb-1">
                          Причина смены статуса (1 клик):
                        </p>
                        <div className="flex flex-col gap-1">
                          {(quickReasons[selectedNewStatus || vehicle.status] || []).map((reason, idx) => (
                            <button
                              key={idx}
                              type="button"
                              onClick={() => {
                                setEnteredReason(reason);
                                // INSTANT UPDATE WITH HIGH COGNITIVE REDUCTION - Click and update immediately!
                                submitStatusUpdate(vehicle.id, selectedNewStatus || vehicle.status, reason);
                              }}
                              className={`text-left p-1 text-[10px] rounded hover:bg-slate-50 focus:outline-none truncate border cursor-pointer ${
                                enteredReason === reason ? 'bg-emerald-50 text-emerald-800 border-emerald-300 font-semibold' : 'border-transparent text-slate-600'
                              }`}
                            >
                              ✓ {reason}
                            </button>
                          ))}
                        </div>
                      </div>

                      {/* Custom write text reason in case */}
                      <div className="space-y-1">
                        <span className="text-[10px] text-indigo-700 block font-bold">Или введите свою причину вручную:</span>
                        <div className="flex gap-1.5">
                          <input
                            type="text"
                            placeholder="Например, ожидание на Клинском КПП..."
                            value={enteredReason}
                            onChange={(e) => setEnteredReason(e.target.value)}
                            className="flex-1 px-2 py-1 text-[10px] border border-slate-300 rounded focus:border-indigo-500 text-slate-800"
                          />
                          <button
                            type="button"
                            onClick={() => {
                              submitStatusUpdate(vehicle.id, selectedNewStatus || vehicle.status, enteredReason);
                            }}
                            className="p-1 px-2.5 bg-indigo-650 text-white rounded hover:bg-indigo-700 text-[10px] flex items-center justify-center font-bold"
                          >
                            <Send size={10} />
                          </button>
                        </div>
                      </div>

                      <div className="pt-2 border-t border-slate-200/80 flex justify-between">
                        <button
                          type="button"
                          onClick={() => {
                            setActiveVehicleIdForStatusEdit(null);
                            setSelectedNewStatus(null);
                          }}
                          className="px-2 py-1 border border-slate-300 text-slate-500 hover:bg-slate-50 rounded text-[10px]"
                        >
                          Отменить
                        </button>
                        
                        <span className="text-[9px] text-slate-400 self-center">Интеграция с 1С активна</span>
                      </div>
                    </div>
                  )}

                  {/* Specific status logs drawer collapse for single log history */}
                  {selectedLogsVehicleId === vehicle.id && (
                    <div className="mt-2 bg-slate-50 p-3 rounded-lg border border-slate-200 text-xs">
                      <div className="flex justify-between items-center mb-2 border-b border-slate-200 pb-1">
                        <p className="font-bold text-slate-600 font-sans tracking-tight">Лог переходов ({vehicle.plateNumber})</p>
                        <button onClick={() => setSelectedLogsVehicleId(null)} className="text-slate-400 hover:text-slate-600 text-xs font-bold font-sans">Скрыть</button>
                      </div>

                      <div className="space-y-2 max-h-40 overflow-y-auto">
                        {logs.filter(l => l.vehicleId === vehicle.id).length === 0 ? (
                          <p className="text-slate-400 text-center py-4 text-[10px]">История перемещений для данного ТС отсутствует</p>
                        ) : (
                          logs.filter(l => l.vehicleId === vehicle.id).map(log => (
                            <div key={log.id} className="p-1.5 bg-white border border-slate-100 rounded text-[10px] space-y-0.5">
                              <div className="flex justify-between text-slate-400 font-mono text-[9px]">
                                <span>{new Date(log.timestamp).toLocaleString('ru-RU', { day: 'numeric', month: 'short', hour: '2-digit', minute: '2-digit' })}</span>
                                <span className="font-semibold text-slate-500">{log.changedBy}</span>
                              </div>
                              <p className="text-slate-700">
                                <span className="font-bold text-slate-500 hover:underline">{log.oldStatus}</span> → <span className="font-bold text-slate-800">{log.newStatus}</span>
                              </p>
                              {log.reason && <p className="text-slate-500 italic">Причина: {log.reason}</p>}
                            </div>
                          ))
                        )}
                      </div>
                    </div>
                  )}

                </div>

              </div>
            );
          })
        )}
      </div>

    </div>
  );
}
