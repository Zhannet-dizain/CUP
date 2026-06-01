// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fleet_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FleetEventImpl _$$FleetEventImplFromJson(Map<String, dynamic> json) =>
    _$FleetEventImpl(
      id: json['id'] as String,
      vehicleId: json['vehicleId'] as String,
      licensePlate: json['licensePlate'] as String,
      oldStatus: $enumDecode(_$VehicleStatusEnumMap, json['oldStatus']),
      newStatus: $enumDecode(_$VehicleStatusEnumMap, json['newStatus']),
      reason: json['reason'] as String?,
      timestamp: DateTime.parse(json['timestamp'] as String),
      initiatorRole: json['initiatorRole'] as String,
    );

Map<String, dynamic> _$$FleetEventImplToJson(_$FleetEventImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'vehicleId': instance.vehicleId,
      'licensePlate': instance.licensePlate,
      'oldStatus': _$VehicleStatusEnumMap[instance.oldStatus]!,
      'newStatus': _$VehicleStatusEnumMap[instance.newStatus]!,
      'reason': instance.reason,
      'timestamp': instance.timestamp.toIso8601String(),
      'initiatorRole': instance.initiatorRole,
    };

const _$VehicleStatusEnumMap = {
  VehicleStatus.inTransit: 'inTransit',
  VehicleStatus.washing: 'washing',
  VehicleStatus.serviceable: 'serviceable',
  VehicleStatus.waitingLoading: 'waitingLoading',
  VehicleStatus.waitingUnloading: 'waitingUnloading',
  VehicleStatus.driverResting: 'driverResting',
  VehicleStatus.customsClearance: 'customsClearance',
  VehicleStatus.disinfection: 'disinfection',
  VehicleStatus.waitingRepair: 'waitingRepair',
  VehicleStatus.waitingParts: 'waitingParts',
  VehicleStatus.maintenance: 'maintenance',
  VehicleStatus.idleNoDriver: 'idleNoDriver',
  VehicleStatus.documentsBlocked: 'documentsBlocked',
  VehicleStatus.underRepair: 'underRepair',
  VehicleStatus.accident: 'accident',
  VehicleStatus.noDriver: 'noDriver',
  VehicleStatus.driverResigned: 'driverResigned',
  VehicleStatus.selling: 'selling',
  VehicleStatus.reserve: 'reserve',
};
