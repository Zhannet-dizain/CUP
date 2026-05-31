/**
 * @license
 * SPDX-License-Identifier: Apache-2.0
 */

import React, { useState, useEffect } from 'react';
import { Bell, Shield, Clock, Terminal, CheckCircle2, UserCheck, RefreshCw } from 'lucide-react';
import { Notification, UserRole } from '../types';

interface HeaderProps {
  notifications: Notification[];
  onMarkAllRead: () => void;
  onClearNotifications: () => void;
  currentRole: UserRole;
  onRoleChange: (role: 'dispatcher' | 'mechanic' | 'manager') => void;
  onSyncAll: () => void;
  syncing: boolean;
}

export default function Header({
  notifications,
  onMarkAllRead,
  onClearNotifications,
  currentRole,
  onRoleChange,
  onSyncAll,
  syncing
}: HeaderProps) {
  const [showNotifications, setShowNotifications] = useState(false);
  const [timeStr, setTimeStr] = useState('');
  const [showRoleMenu, setShowRoleMenu] = useState(false);

  useEffect(() => {
    const updateTime = () => {
      const now = new Date();
      setTimeStr(now.toLocaleTimeString('ru-RU', { hour: '2-digit', minute: '2-digit', second: '2-digit' }) + ' (UTC+3)');
    };
    updateTime();
    const interval = setInterval(updateTime, 1000);
    return () => clearInterval(interval);
  }, []);

  const unreadCount = notifications.filter(n => !n.read).length;

  const rolesList: { id: 'dispatcher' | 'mechanic' | 'manager'; label: string; desc: string; badgeColor: string }[] = [
    {
      id: 'dispatcher',
      label: 'Диспетчер парка',
      desc: 'Быстрая смена статусов, контроль простоев, ГЛОНАСС-трекинг',
      badgeColor: 'bg-emerald-100 text-emerald-800'
    },
    {
      id: 'mechanic',
      label: 'Главный механик',
      desc: 'Вывод на ТО, фиксация неисправностей, сервис-логи',
      badgeColor: 'bg-amber-100 text-amber-800'
    },
    {
      id: 'manager',
      label: 'Руководитель (CEO)',
      desc: 'KPI-аналитика, расчет эффективности, экспорт отчетов 1С',
      badgeColor: 'bg-indigo-100 text-indigo-800'
    }
  ];

  return (
    <header className="sticky top-0 z-40 bg-slate-900 text-white shadow-md border-b border-slate-800" id="main_header">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-3">
        <div className="flex items-center justify-between">
          
          {/* Logo & Platform Name */}
          <div className="flex items-center space-x-3" id="header_logo_container">
            <div className="bg-emerald-500 text-slate-950 p-2 rounded-lg flex items-center justify-center font-bold tracking-wider">
              <Terminal size={22} className="stroke-[2.5]" />
            </div>
            <div>
              <h1 className="text-lg font-semibold tracking-tight leading-none text-slate-100 flex items-center gap-2">
                ЦУП Автопарка <span className="text-xs bg-slate-800 text-emerald-400 font-mono py-0.5 px-2 rounded border border-slate-700">v1.2 MVP+</span>
              </h1>
              <p className="text-[11px] text-slate-400 font-medium">Система мониторинга статусов и контроля простоев</p>
            </div>
          </div>

          {/* Center Actions - Role / Sim Details */}
          <div className="hidden md:flex items-center space-x-4 text-xs font-mono text-slate-400">
            <div className="flex items-center space-x-1.5 bg-slate-800/80 px-2 py-1 rounded border border-slate-700">
              <Clock size={13} className="text-slate-400" />
              <span>{timeStr}</span>
            </div>
            
            <button
              onClick={onSyncAll}
              disabled={syncing}
              className={`flex items-center space-x-1.5 px-2.5 py-1 rounded border transition ${
                syncing
                  ? 'border-emerald-600 bg-emerald-950/40 text-emerald-300'
                  : 'border-slate-700 bg-slate-800 text-slate-300 hover:bg-slate-700 hover:text-white'
              }`}
            >
              <RefreshCw size={13} className={syncing ? 'animate-spin text-emerald-400' : 'text-slate-400'} />
              <span>{syncing ? 'Синхронизация 1С...' : 'Синхронизировать с 1С'}</span>
            </button>
          </div>

          {/* Right Navigation Actions */}
          <div className="flex items-center space-x-3">
            
            {/* Active User Role Badge */}
            <div className="relative">
              <button
                onClick={() => setShowRoleMenu(!showRoleMenu)}
                className="flex items-center space-x-2 bg-slate-800 hover:bg-slate-700 border border-slate-700 rounded-lg px-3 py-1.5 transition text-left cursor-pointer"
                id="role_selector_button"
              >
                <UserCheck size={14} className="text-emerald-400" />
                <div className="text-xs">
                  <div className="text-[10px] text-slate-400 leading-none">Режим работы:</div>
                  <div className="font-semibold text-slate-200">{rolesList.find(r => r.id === currentRole.role)?.label}</div>
                </div>
              </button>

              {showRoleMenu && (
                <>
                  <div className="fixed inset-0 z-40" onClick={() => setShowRoleMenu(false)} />
                  <div className="absolute right-0 mt-2 w-72 bg-slate-800 border border-slate-700 rounded-xl shadow-2xl p-2 z-50 animate-in fade-in slide-in-from-top-2 duration-100">
                    <div className="px-3 py-2 border-b border-slate-700/60 mb-1">
                      <p className="text-xs font-semibold text-slate-300">Выберите роль оператора</p>
                      <p className="text-[10px] text-slate-400">Роль меняет доступные функции и ограничения</p>
                    </div>
                    <div className="space-y-1">
                      {rolesList.map((item) => (
                        <button
                          key={item.id}
                          onClick={() => {
                            onRoleChange(item.id);
                            setShowRoleMenu(false);
                          }}
                          className={`w-full text-left p-2 rounded-lg transition text-xs flex flex-col ${
                            currentRole.role === item.id
                              ? 'bg-slate-700 border border-emerald-500/30'
                              : 'hover:bg-slate-700/50'
                          }`}
                        >
                          <span className="font-semibold text-slate-100 flex items-center gap-1.5">
                            {item.label}
                            {currentRole.role === item.id && (
                              <span className="w-1.5 h-1.5 rounded-full bg-emerald-400 block" />
                            )}
                          </span>
                          <span className="text-[10px] text-slate-400 font-sans mt-0.5">{item.desc}</span>
                        </button>
                      ))}
                    </div>
                  </div>
                </>
              )}
            </div>

            {/* Notification Bell */}
            <div className="relative" id="notifications_bell_container">
              <button
                onClick={() => setShowNotifications(!showNotifications)}
                className="p-2 bg-slate-800 hover:bg-slate-700 rounded-lg text-slate-300 relative transition cursor-pointer"
                aria-label="Оповещения"
              >
                <Bell size={18} />
                {unreadCount > 0 && (
                  <span className="absolute -top-1 -right-1 bg-red-500 text-white text-[10px] font-bold font-mono h-5 w-5 rounded-full flex items-center justify-center border-2 border-slate-900 animate-pulse">
                    {unreadCount}
                  </span>
                )}
              </button>

              {showNotifications && (
                <>
                  <div className="fixed inset-0 z-40" onClick={() => setShowNotifications(false)} />
                  <div className="absolute right-0 mt-2 w-80 sm:w-96 bg-white text-slate-900 border border-slate-200 rounded-xl shadow-2xl z-50 p-1" id="notifications_dropdown">
                    <div className="flex items-center justify-between p-3 border-b border-slate-100">
                      <div>
                        <h3 className="text-sm font-semibold text-slate-900">Оповещения и события</h3>
                        <p className="text-[11px] text-slate-500">{unreadCount} непрочитанных сообщений</p>
                      </div>
                      <div className="flex space-x-1">
                        <button
                          onClick={onMarkAllRead}
                          className="text-[11px] font-medium text-emerald-600 hover:text-emerald-700 px-2 py-1 rounded hover:bg-emerald-50 cursor-pointer"
                        >
                          Прочесть все
                        </button>
                        <button
                          onClick={onClearNotifications}
                          className="text-[11px] font-medium text-slate-400 hover:text-slate-600 px-1.5 py-1 rounded hover:bg-slate-50 cursor-pointer"
                        >
                          Очистить
                        </button>
                      </div>
                    </div>

                    <div className="max-h-80 overflow-y-auto divide-y divide-slate-100">
                      {notifications.length === 0 ? (
                        <div className="p-8 text-center text-xs text-slate-400">
                          Нет активных уведомлений датчиков и систем
                        </div>
                      ) : (
                        notifications.map((item) => (
                          <div
                            key={item.id}
                            className={`p-3 text-xs transition relative ${!item.read ? 'bg-amber-50/50' : 'hover:bg-slate-50'}`}
                          >
                            <div className="flex items-start justify-between">
                              <span className={`inline-block px-1.5 py-0.5 rounded text-[10px] font-semibold mb-1 ${
                                item.type === 'error' ? 'bg-red-100 text-red-800' :
                                item.type === 'warning' ? 'bg-amber-100 text-amber-800' :
                                item.type === 'success' ? 'bg-emerald-100 text-emerald-800' :
                                'bg-slate-100 text-slate-800'
                              }`}>
                                {item.title}
                              </span>
                              <span className="text-[10px] text-slate-400 font-mono">
                                {new Date(item.timestamp).toLocaleTimeString('ru-RU', { hour: '2-digit', minute: '2-digit' })}
                              </span>
                            </div>
                            <p className="text-slate-700 pr-4 leading-relaxed">{item.message}</p>
                          </div>
                        ))
                      )}
                    </div>
                  </div>
                </>
              )}
            </div>

          </div>
        </div>
      </div>
    </header>
  );
}
