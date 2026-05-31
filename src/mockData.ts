/**
 * @license
 * SPDX-License-Identifier: Apache-2.0
 */

import { Vehicle, VehicleStatus, StatusLogEntry, Notification, AutomationRule } from './types';

export const INITIAL_VEHICLES: Vehicle[] = [
  {
    id: 'V1',
    plateNumber: 'А112АА 797',
    model: 'Volvo FH16 (Тягач)',
    type: 'Truck',
    driver: 'Иванов Семён Петрович',
    driverPhone: '+7 (903) 123-4567',
    status: VehicleStatus.IN_ROUTE,
    lastStatusChange: new Date(Date.now() - 4.5 * 3600000).toISOString(), // 4.5 hours ago
    fuelLevel: 78,
    speed: 76,
    odometer: 245300,
    engineTemp: 84,
    connectedGPS: true,
    lat: 56.45,
    lng: 37.38,
    locationName: 'Трасса М-10, Клинский р-н',
    loadPercentage: 90,
    oneCSyncStatus: 'synced',
    lastSyncTime: new Date().toISOString()
  },
  {
    id: 'V2',
    plateNumber: 'Т882ОК 777',
    model: 'KAMAZ-54901 (Седельный тягач)',
    type: 'Truck',
    driver: 'Смирнов Илья Валерьевич',
    driverPhone: '+7 (911) 987-6543',
    status: VehicleStatus.MAINTENANCE,
    reason: 'Замена тормозных колодок и дисков',
    lastStatusChange: new Date(Date.now() - 3 * 3600000).toISOString(), // 3 hours ago
    fuelLevel: 42,
    speed: 0,
    odometer: 112400,
    engineTemp: 22,
    connectedGPS: true,
    lat: 55.82,
    lng: 37.62,
    locationName: 'СТО Восток-Сервис, Москва',
    loadPercentage: 0,
    oneCSyncStatus: 'synced',
    lastSyncTime: new Date().toISOString()
  },
  {
    id: 'V3',
    plateNumber: 'Е456РК 198',
    model: 'Scania R450 (Рефрижератор)',
    type: 'Truck',
    driver: 'Васильев Олег Игоревич',
    driverPhone: '+7 (921) 333-2211',
    status: VehicleStatus.DOWNTIME,
    reason: 'Ожидание погрузки (Задержка отгрузки склада)',
    lastStatusChange: new Date(Date.now() - 5.5 * 3600000).toISOString(), // 5.5 hours ago
    fuelLevel: 65,
    speed: 0,
    odometer: 318210,
    engineTemp: 18,
    cargoTemp: -18,
    connectedGPS: true,
    lat: 59.81,
    lng: 30.34,
    locationName: 'РЦ Пятерочка, Шушары',
    loadPercentage: 0,
    oneCSyncStatus: 'pending',
    lastSyncTime: new Date(Date.now() - 1 * 3600000).toISOString()
  },
  {
    id: 'V4',
    plateNumber: 'К529ЕН 799',
    model: 'Mercedes-Benz Actros',
    type: 'Truck',
    driver: 'Попов Роман Николаевич',
    driverPhone: '+7 (916) 555-4433',
    status: VehicleStatus.IN_ROUTE,
    lastStatusChange: new Date(Date.now() - 8 * 3600000).toISOString(),
    fuelLevel: 12, // Low fuel alert trigg
    speed: 82,
    odometer: 189400,
    engineTemp: 86,
    connectedGPS: true,
    lat: 53.20,
    lng: 44.95,
    locationName: 'Трасса М-5, Самарская обл.',
    loadPercentage: 100,
    oneCSyncStatus: 'synced',
    lastSyncTime: new Date().toISOString()
  },
  {
    id: 'V5',
    plateNumber: 'Н777МА 77',
    model: 'Gazelle NEXT (Изотерма)',
    type: 'LCV',
    driver: 'Петров Андрей Дмитриевич',
    driverPhone: '+7 (999) 777-6655',
    status: VehicleStatus.BREAKDOWN,
    reason: 'Критический перегрев двигателя (Утечка антифриза)',
    lastStatusChange: new Date(Date.now() - 1.2 * 3600000).toISOString(),
    fuelLevel: 35,
    speed: 0,
    odometer: 54900,
    engineTemp: 104, // High temperature!
    connectedGPS: true,
    lat: 55.15,
    lng: 37.45,
    locationName: 'Симферопольское шоссе, Подольск',
    loadPercentage: 45,
    oneCSyncStatus: 'error',
    lastSyncTime: new Date(Date.now() - 1.2 * 3600000).toISOString()
  },
  {
    id: 'V6',
    plateNumber: 'М312ХТ 197',
    model: 'MAN TGX',
    type: 'Truck',
    driver: 'Белов Артур Сергеевич',
    driverPhone: '+7 (905) 444-3322',
    status: VehicleStatus.READY,
    lastStatusChange: new Date(Date.now() - 10 * 3600000).toISOString(),
    fuelLevel: 95,
    speed: 0,
    odometer: 421000,
    engineTemp: 20,
    connectedGPS: true,
    lat: 55.56,
    lng: 37.81,
    locationName: 'База «Котельники», стоянка А',
    loadPercentage: 0,
    oneCSyncStatus: 'synced',
    lastSyncTime: new Date().toISOString()
  },
  {
    id: 'V7',
    plateNumber: 'У619ОО 750',
    model: 'Shacman X6000 (Самосвал)',
    type: 'Special',
    driver: 'Фёдоров Игорь Борисович',
    driverPhone: '+7 (985) 121-1221',
    status: VehicleStatus.IN_ROUTE,
    lastStatusChange: new Date(Date.now() - 2.1 * 3600000).toISOString(),
    fuelLevel: 60,
    speed: 45,
    odometer: 34100,
    engineTemp: 82,
    connectedGPS: true,
    lat: 55.45,
    lng: 38.12,
    locationName: 'Строящаяся ЦКАД, сектор 4',
    loadPercentage: 100,
    oneCSyncStatus: 'synced',
    lastSyncTime: new Date().toISOString()
  },
  {
    id: 'V8',
    plateNumber: 'Х505ТМ 799',
    model: 'MAZ-6430 (Бортовой)',
    type: 'Truck',
    driver: 'Егоров Вадим Леонидович',
    driverPhone: '+7 (910) 999-8800',
    status: VehicleStatus.DOWNTIME,
    reason: 'Ожидание назначения водителя / Сменный отдых',
    lastStatusChange: new Date(Date.now() - 14 * 3600000).toISOString(),
    fuelLevel: 48,
    speed: 0,
    odometer: 512300,
    engineTemp: 15,
    connectedGPS: false, // GPS lost
    lat: 56.12,
    lng: 40.40,
    locationName: 'Терминал ГК Делко, Владимир',
    loadPercentage: 0,
    oneCSyncStatus: 'synced',
    lastSyncTime: new Date(Date.now() - 6 * 3600000).toISOString()
  }
];

export const INITIAL_HISTORY: StatusLogEntry[] = [
  {
    id: 'L1',
    vehicleId: 'V1',
    vehiclePlate: 'А112АА 797',
    vehicleModel: 'Volvo FH16 (Тягач)',
    oldStatus: VehicleStatus.READY,
    newStatus: VehicleStatus.IN_ROUTE,
    reason: 'Выезд в рейс по накладной №45100 (Москва - Санкт-Петербург)',
    changedBy: 'Диспетчер Семёнова',
    changedByRole: 'dispatcher',
    timestamp: new Date(Date.now() - 4.5 * 3600000).toISOString()
  },
  {
    id: 'L2',
    vehicleId: 'V2',
    vehiclePlate: 'Т882ОК 777',
    vehicleModel: 'KAMAZ-54901 (Седельный тягач)',
    oldStatus: VehicleStatus.DOWNTIME,
    newStatus: VehicleStatus.MAINTENANCE,
    reason: 'Пробег подошёл к ТО-3. Плановая замена тормозной системы.',
    changedBy: 'Механик Сергеев А.',
    changedByRole: 'mechanic',
    timestamp: new Date(Date.now() - 3 * 3600000).toISOString()
  },
  {
    id: 'L3',
    vehicleId: 'V3',
    vehiclePlate: 'Е456РК 198',
    vehicleModel: 'Scania R450 (Рефрижератор)',
    oldStatus: VehicleStatus.IN_ROUTE,
    newStatus: VehicleStatus.DOWNTIME,
    reason: 'Доставлен к РЦ Пятерочка. Задержка выгрузки из-за аварии на пандусе склада.',
    changedBy: 'Диспетчер Семёнова',
    changedByRole: 'dispatcher',
    timestamp: new Date(Date.now() - 5.5 * 3600000).toISOString()
  },
  {
    id: 'L4',
    vehicleId: 'V5',
    vehiclePlate: 'Н777МА 77',
    vehicleModel: 'Gazelle NEXT (Изотерма)',
    oldStatus: VehicleStatus.READY,
    newStatus: VehicleStatus.BREAKDOWN,
    reason: 'Водитель сообщил о паре из-под капота. Температура мотора 104°C. Вызван эвакуатор.',
    changedBy: 'Механик Сергеев А.',
    changedByRole: 'mechanic',
    timestamp: new Date(Date.now() - 1.2 * 3600000).toISOString()
  }
];

export const INITIAL_NOTIFICATIONS: Notification[] = [
  {
    id: 'N1',
    vehicleId: 'V5',
    title: 'Аварийная ситуация',
    message: 'Автомобиль Газель NEXT (Н777МА 77) сообщил о критическом нагреве ДВС: 104°C! Статус изменён на АВАРИЯ.',
    type: 'error',
    timestamp: new Date(Date.now() - 1.2 * 3600000).toISOString(),
    read: false
  },
  {
    id: 'N2',
    vehicleId: 'V4',
    title: 'Низкий уровень топлива',
    message: 'Внимание: Тягач Mercedes-Benz Actros (К529ЕН 799) имеет остаток топлива 12%! Рекомендуется заправка на АЗС Газпромнефть М-5.',
    type: 'warning',
    timestamp: new Date(Date.now() - 50 * 60000).toISOString(),
    read: false
  },
  {
    id: 'N3',
    vehicleId: 'V8',
    title: 'Потеря связи GPS ГЛОНАСС',
    message: 'Транспортное средство MAZ-6430 (Х505ТМ 799) не передаёт телематику более 2 часов. Возможен выезд из зоны покрытия.',
    type: 'warning',
    timestamp: new Date(Date.now() - 2 * 3600000).toISOString(),
    read: true
  },
  {
    id: 'N4',
    vehicleId: 'V3',
    title: 'Ошибка синхронизации 1С:УАТ',
    message: 'Документ заезда для Scania R450 (Е456РК 198) не синхронизирован из-за блокировки сессии базы.',
    type: 'info',
    timestamp: new Date(Date.now() - 1 * 3600000).toISOString(),
    read: false
  }
];

export const INITIAL_RULES: AutomationRule[] = [
  {
    id: 'R1',
    name: 'Контроль перегрева ДВС',
    triggerType: 'engine_temp',
    threshold: 100,
    actionType: 'alert_mechanic',
    actionValue: 'Пожизненный статус Авария + SMS дежурному инженеру',
    active: true
  },
  {
    id: 'R2',
    name: 'Остаток бака < 15%',
    triggerType: 'low_fuel',
    threshold: 15,
    actionType: 'notify_manager',
    actionValue: 'Экстренная рекомендация АЗС по пути следования',
    active: true
  },
  {
    id: 'R3',
    name: 'Простой на погрузке > 4 часов',
    triggerType: 'downtime_duration',
    threshold: 4,
    actionType: 'notify_manager',
    actionValue: 'Автоотправка жалобы директору логистики РЦ/Склада',
    active: true
  },
  {
    id: 'R4',
    name: 'Отключение трекера ГЛОНАСС',
    triggerType: 'gps_lost',
    threshold: 1, // hour
    actionType: 'auto_change_status',
    actionValue: 'Проверить состояние по сотовой связи',
    active: false
  }
];
