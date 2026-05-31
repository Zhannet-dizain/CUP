/**
 * @license
 * SPDX-License-Identifier: Apache-2.0
 */

export enum VehicleStatus {
  IN_ROUTE = 'IN_ROUTE',         // В рейсе (Green)
  READY = 'READY',               // Готов к рейсу / Свободен (Cyan/Light-green)
  MAINTENANCE = 'MAINTENANCE',   // На ТО / Ремонт (Orange)
  DOWNTIME = 'DOWNTIME',         // Простой / Ожидание (Blue)
  BREAKDOWN = 'BREAKDOWN'        // Поломка / Авария (Red)
}

export interface Vehicle {
  id: string;
  plateNumber: string;
  model: string;
  type: 'Truck' | 'Trailer' | 'LCV' | 'Special';
  driver: string;
  driverPhone: string;
  status: VehicleStatus;
  reason?: string;
  lastStatusChange: string; // ISO date string
  fuelLevel: number;        // 0-100%
  speed: number;           // km/h
  odometer: number;        // km
  engineTemp: number;      // °C
  cargoTemp?: number;      // °C (only for reefers)
  connectedGPS: boolean;
  lat: number;
  lng: number;
  locationName: string;
  loadPercentage: number;   // 0-100%
  oneCSyncStatus: 'synced' | 'pending' | 'error';
  lastSyncTime: string;     // ISO date string
}

export interface StatusLogEntry {
  id: string;
  vehicleId: string;
  vehiclePlate: string;
  vehicleModel: string;
  oldStatus: VehicleStatus;
  newStatus: VehicleStatus;
  reason: string;
  changedBy: string; // e.g. "Диспетчер Смирнов", "Механик Петров", "Директор логистики"
  changedByRole: 'dispatcher' | 'mechanic' | 'manager';
  timestamp: string; // ISO date string
}

export interface Notification {
  id: string;
  vehicleId?: string;
  title: string;
  message: string;
  type: 'info' | 'warning' | 'error' | 'success';
  timestamp: string;
  read: boolean;
}

export interface AutomationRule {
  id: string;
  name: string;
  triggerType: 'downtime_duration' | 'low_fuel' | 'engine_temp' | 'gps_lost';
  threshold: number; // e.g., 4 (hours), 15 (% fuel), 102 (°C)
  actionType: 'notify_manager' | 'auto_change_status' | 'alert_mechanic';
  actionValue: string; // e.g. "BREAKDOWN", "Отправить SMS механику"
  active: boolean;
}

export interface UserRole {
  role: 'dispatcher' | 'mechanic' | 'manager';
  name: string;
}
