/**
 * @license
 * SPDX-License-Identifier: Apache-2.0
 */

import React, { useState, useEffect } from 'react';
import Header from './components/Header';
import Dashboard from './components/Dashboard';
import VehicleList from './components/VehicleList';
import Analytics from './components/Analytics';
import Integrations from './components/Integrations';
import ExternalApi from './components/ExternalApi';

import { Vehicle, VehicleStatus, StatusLogEntry, Notification, AutomationRule, UserRole } from './types';
import { INITIAL_VEHICLES, INITIAL_HISTORY, INITIAL_NOTIFICATIONS, INITIAL_RULES } from './mockData';

// Icons for navigation
import { LayoutDashboard, Truck, AreaChart, Cpu, Globe } from 'lucide-react';

export default function App() {
  const [activeTab, setActiveTab] = useState<string>('dashboard');
  
  // Real active states
  const [vehicles, setVehicles] = useState<Vehicle[]>([]);
  const [logs, setLogs] = useState<StatusLogEntry[]>([]);
  const [notifications, setNotifications] = useState<Notification[]>([]);
  const [rules, setRules] = useState<AutomationRule[]>([]);
  const [currentRole, setCurrentRole] = useState<UserRole>({ role: 'dispatcher', name: 'Диспетчер Смирнов' });
  const [syncing1C, setSyncing1C] = useState(false);

  // Deep linking redirect parameter
  const [selectedPlateFromDashboard, setSelectedPlateFromDashboard] = useState<string | null>(null);

  // Initialize state from localStorage or mocks
  useEffect(() => {
    const savedVehicles = localStorage.getItem('fleet_vehicles');
    const savedLogs = localStorage.getItem('fleet_logs');
    const savedNotifications = localStorage.getItem('fleet_notifications');
    const savedRules = localStorage.getItem('fleet_rules');
    const savedRole = localStorage.getItem('fleet_role');

    if (savedVehicles) {
      setVehicles(JSON.parse(savedVehicles));
    } else {
      setVehicles(INITIAL_VEHICLES);
      localStorage.setItem('fleet_vehicles', JSON.stringify(INITIAL_VEHICLES));
    }

    if (savedLogs) {
      setLogs(JSON.parse(savedLogs));
    } else {
      setLogs(INITIAL_HISTORY);
      localStorage.setItem('fleet_logs', JSON.stringify(INITIAL_HISTORY));
    }

    if (savedNotifications) {
      setNotifications(JSON.parse(savedNotifications));
    } else {
      setNotifications(INITIAL_NOTIFICATIONS);
      localStorage.setItem('fleet_notifications', JSON.stringify(INITIAL_NOTIFICATIONS));
    }

    if (savedRules) {
      setRules(JSON.parse(savedRules));
    } else {
      setRules(INITIAL_RULES);
      localStorage.setItem('fleet_rules', JSON.stringify(INITIAL_RULES));
    }

    if (savedRole) {
      setCurrentRole(JSON.parse(savedRole));
    }
  }, []);

  // Sync to database simulated triggers
  const handleUpdateStatus = (vehicleId: string, newStatus: VehicleStatus, reason: string) => {
    setVehicles((prevVehicles) => {
      const updated = prevVehicles.map((vehicle) => {
        if (vehicle.id === vehicleId) {
          const oldStatus = vehicle.status;
          
          // Only log and notify if there's an actual state changes!
          if (oldStatus !== newStatus) {
            // Append log entry
            const newLog: StatusLogEntry = {
              id: 'L_' + Date.now().toString(36),
              vehicleId: vehicle.id,
              vehiclePlate: vehicle.plateNumber,
              vehicleModel: vehicle.model,
              oldStatus,
              newStatus,
              reason: reason || 'Изменение статуса',
              changedBy: currentRole.role === 'dispatcher' ? 'Диспетчер Смирнов' : currentRole.role === 'mechanic' ? 'Главный механик' : 'Директор по логистике',
              changedByRole: currentRole.role,
              timestamp: new Date().toISOString()
            };

            setLogs((prevLogs) => {
              const uLogs = [newLog, ...prevLogs];
              localStorage.setItem('fleet_logs', JSON.stringify(uLogs));
              return uLogs;
            });

            // If entering an anomaly state (BREAKDOWN), trigger custom high alert notification
            if (newStatus === VehicleStatus.BREAKDOWN) {
              const newAlert: Notification = {
                id: 'N_' + Date.now().toString(36),
                vehicleId: vehicle.id,
                title: 'Критическая поломка ТС',
                message: `ТС ${vehicle.plateNumber} (${vehicle.model}) переведено в статус АВАРИЯ. Причина: ${reason}`,
                type: 'error',
                timestamp: new Date().toISOString(),
                read: false
              };
              setNotifications(prev => {
                const uNotif = [newAlert, ...prev];
                localStorage.setItem('fleet_notifications', JSON.stringify(uNotif));
                return uNotif;
              });
            } else {
              const newNotif: Notification = {
                id: 'N_' + Date.now().toString(36),
                vehicleId: vehicle.id,
                title: 'Статус изменён',
                message: `ТС ${vehicle.plateNumber} успешно переведено в статус ${newStatus}.`,
                type: 'success',
                timestamp: new Date().toISOString(),
                read: false
              };
              setNotifications(prev => {
                const uNotif = [newNotif, ...prev];
                localStorage.setItem('fleet_notifications', JSON.stringify(uNotif));
                return uNotif;
              });
            }
          }

          // Return new vehicle model with status transitions
          return {
            ...vehicle,
            status: newStatus,
            reason: reason || '',
            lastStatusChange: new Date().toISOString(),
            oneCSyncStatus: 'pending' as const, // Set pending sync to trigger visual flag
            lastSyncTime: new Date().toISOString()
          };
        }
        return vehicle;
      });

      localStorage.setItem('fleet_vehicles', JSON.stringify(updated));
      return updated;
    });
  };

  // Switch role action
  const handleRoleChange = (role: 'dispatcher' | 'mechanic' | 'manager') => {
    let name = 'Диспетчер Смирнов';
    if (role === 'mechanic') name = 'Главный механик Сергеев';
    if (role === 'manager') name = 'Директор логистики';

    const newRole: UserRole = { role, name };
    setCurrentRole(newRole);
    localStorage.setItem('fleet_role', JSON.stringify(newRole));
  };

  // Mark notifications read
  const handleMarkAllRead = () => {
    setNotifications((prev) => {
      const updated = prev.map(n => ({ ...n, read: true }));
      localStorage.setItem('fleet_notifications', JSON.stringify(updated));
      return updated;
    });
  };

  // Clear all notifications
  const handleClearNotifications = () => {
    setNotifications([]);
    localStorage.setItem('fleet_notifications', JSON.stringify([]));
  };

  // Toggle autopolicy rule
  const handleToggleRule = (ruleId: string) => {
    setRules((prev) => {
      const updated = prev.map(r => r.id === ruleId ? { ...r, active: !r.active } : r);
      localStorage.setItem('fleet_rules', JSON.stringify(updated));
      return updated;
    });
  };

  // Add autopolicy rule
  const handleAddRule = (newRule: AutomationRule) => {
    setRules((prev) => {
      const updated = [newRule, ...prev];
      localStorage.setItem('fleet_rules', JSON.stringify(updated));
      return updated;
    });
  };

  // Delete autopolicy rule
  const handleDeleteRule = (ruleId: string) => {
    setRules((prev) => {
      const updated = prev.filter(r => r.id !== ruleId);
      localStorage.setItem('fleet_rules', JSON.stringify(updated));
      return updated;
    });
  };

  // Sync everything visually with 1C:Enterprise ERP system
  const handleSyncAll = () => {
    setSyncing1C(true);
    setTimeout(() => {
      setSyncing1C(false);
      setVehicles(prev => {
        const updated = prev.map(v => v.oneCSyncStatus === 'pending' ? { ...v, oneCSyncStatus: 'synced' as const, lastSyncTime: new Date().toISOString() } : v);
        localStorage.setItem('fleet_vehicles', JSON.stringify(updated));
        return updated;
      });

      // Notification
      const newNotif: Notification = {
        id: 'Sync_' + Date.now().toString(36),
        title: 'Успешный обмен с 1С:УАТ',
        message: 'Все оперативные изменения статусов и простои транспортных средств выгружены во внешние учетные регистры ERP 1С.',
        type: 'success',
        timestamp: new Date().toISOString(),
        read: false
      };
      setNotifications(prev => {
        const uNotif = [newNotif, ...prev];
        localStorage.setItem('fleet_notifications', JSON.stringify(uNotif));
        return uNotif;
      });
    }, 1500);
  };

  // Inter-tab redirection for looking specific vehicle
  const handleSelectVehicleFromDashboard = (plate: string) => {
    setSelectedPlateFromDashboard(plate);
    setActiveTab('vehicles');
  };

  return (
    <div className="min-h-screen bg-slate-50 font-sans flex flex-col justify-between" id="app_root">
      
      {/* Dynamic Header Component */}
      <Header
        notifications={notifications}
        onMarkAllRead={handleMarkAllRead}
        onClearNotifications={handleClearNotifications}
        currentRole={currentRole}
        onRoleChange={handleRoleChange}
        onSyncAll={handleSyncAll}
        syncing={syncing1C}
      />

      {/* Main Content Area */}
      <main className="flex-grow max-w-7xl w-full mx-auto px-4 sm:px-6 lg:px-8 py-6">
        
        {/* Navigation Tabs bar */}
        <div className="flex border-b border-slate-200 mb-6 overflow-x-auto pb-1" id="main_navigation_tabs">
          <button
            onClick={() => setActiveTab('dashboard')}
            className={`flex items-center space-x-2 py-2.5 px-4 font-bold text-xs uppercase tracking-wider border-b-2 whitespace-nowrap transition cursor-pointer ${
              activeTab === 'dashboard'
                ? 'border-indigo-600 text-indigo-700'
                : 'border-transparent text-slate-500 hover:text-slate-700 hover:border-slate-300'
            }`}
          >
            <LayoutDashboard size={14} className="stroke-[2.5]" />
            <span>Диспетчерская (Мониторинг)</span>
          </button>

          <button
            onClick={() => setActiveTab('vehicles')}
            className={`flex items-center space-x-2 py-2.5 px-4 font-bold text-xs uppercase tracking-wider border-b-2 whitespace-nowrap transition cursor-pointer ${
              activeTab === 'vehicles'
                ? 'border-indigo-600 text-indigo-700'
                : 'border-transparent text-slate-500 hover:text-slate-700 hover:border-slate-300'
            }`}
          >
            <Truck size={14} />
            <span>Реестр ТС (Статусы)</span>
          </button>

          <button
            onClick={() => setActiveTab('analytics')}
            className={`flex items-center space-x-2 py-2.5 px-4 font-bold text-xs uppercase tracking-wider border-b-2 whitespace-nowrap transition cursor-pointer ${
              activeTab === 'analytics'
                ? 'border-indigo-600 text-indigo-700'
                : 'border-transparent text-slate-500 hover:text-slate-700 hover:border-slate-300'
            }`}
          >
            <AreaChart size={14} />
            <span>KPI & Аналитика</span>
          </button>

          <button
            onClick={() => setActiveTab('integrations')}
            className={`flex items-center space-x-2 py-2.5 px-4 font-bold text-xs uppercase tracking-wider border-b-2 whitespace-nowrap transition cursor-pointer ${
              activeTab === 'integrations'
                ? 'border-indigo-600 text-indigo-700'
                : 'border-transparent text-slate-500 hover:text-slate-700 hover:border-slate-300'
            }`}
          >
            <Cpu size={14} />
            <span>ГЛОНАСС & Автоматизация</span>
          </button>

          <button
            onClick={() => setActiveTab('api')}
            className={`flex items-center space-x-2 py-2.5 px-4 font-bold text-xs uppercase tracking-wider border-b-2 whitespace-nowrap transition cursor-pointer ${
              activeTab === 'api'
                ? 'border-indigo-600 text-indigo-700'
                : 'border-transparent text-slate-500 hover:text-slate-700 hover:border-slate-300'
            }`}
          >
            <Globe size={14} />
            <span>REST API Шлюз</span>
          </button>
        </div>

        {/* Tab views conditional controller */}
        <div className="animate-in fade-in duration-300" id="tabs_view_container">
          {activeTab === 'dashboard' && (
            <Dashboard 
              vehicles={vehicles} 
              logs={logs} 
              onSelectTab={setActiveTab}
              onSelectVehicle={handleSelectVehicleFromDashboard}
            />
          )}

          {activeTab === 'vehicles' && (
            <VehicleList
              vehicles={vehicles}
              currentRole={currentRole}
              onUpdateStatus={handleUpdateStatus}
              logs={logs}
              selectedPlateFromDashboard={selectedPlateFromDashboard}
              onClearSelectedPlate={() => setSelectedPlateFromDashboard(null)}
            />
          )}

          {activeTab === 'analytics' && (
            <Analytics
              vehicles={vehicles}
              logs={logs}
            />
          )}

          {activeTab === 'integrations' && (
            <Integrations
              vehicles={vehicles}
              rules={rules}
              onToggleRule={handleToggleRule}
              onAddRule={handleAddRule}
              onDeleteRule={handleDeleteRule}
            />
          )}

          {activeTab === 'api' && (
            <ExternalApi
              vehicles={vehicles}
            />
          )}
        </div>

      </main>

      {/* Styled humbler Footer line */}
      <footer className="bg-white border-t border-slate-205 py-4 mt-12" id="app_footer">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-center text-slate-400 text-xs font-sans">
          <span>© 2026 ЦУП Автопарка Fleet Control Panel. Разработано для оперативного реагирования и снижения простоев КТГ. Спецификация 1С:УАТ REST OData API.</span>
        </div>
      </footer>

    </div>
  );
}
