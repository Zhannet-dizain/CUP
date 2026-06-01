// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VehicleImpl _$$VehicleImplFromJson(Map<String, dynamic> json) =>
    _$VehicleImpl(
      id: json['id'] as String,
      licensePlate: json['licensePlate'] as String,
      brandModel: json['brandModel'] as String,
      trailer: json['trailer'] as String?,
      driver: json['driver'] as String?,
      column: json['column'] as String,
      status: $enumDecode(_$VehicleStatusEnumMap, json['status']),
      statusDuration: Duration(
        microseconds: (json['statusDuration'] as num).toInt(),
      ),
      reason: $enumDecodeNullable(_$StatusReasonEnumMap, json['reason']),
      location: json['location'] as String,
      responsibleUser: json['responsibleUser'] as String,
      comment: json['comment'] as String?,
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
      hourlyCost: (json['hourlyCost'] as num?)?.toDouble() ?? 0.0,
      fuelLevel: (json['fuelLevel'] as num?)?.toDouble() ?? 100.0,
      engineTemp: (json['engineTemp'] as num?)?.toDouble() ?? 85.0,
      mileage: (json['mileage'] as num?)?.toDouble() ?? 0.0,
      revenue: (json['revenue'] as num?)?.toDouble() ?? 0.0,
      maintenanceCosts: (json['maintenanceCosts'] as num?)?.toDouble() ?? 0.0,
      fuelCosts: (json['fuelCosts'] as num?)?.toDouble() ?? 0.0,
      amortization: (json['amortization'] as num?)?.toDouble() ?? 0.0,
      lat: (json['lat'] as num?)?.toDouble() ?? 55.7558,
      lng: (json['lng'] as num?)?.toDouble() ?? 37.6173,
      speed: (json['speed'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$$VehicleImplToJson(_$VehicleImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'licensePlate': instance.licensePlate,
      'brandModel': instance.brandModel,
      'trailer': instance.trailer,
      'driver': instance.driver,
      'column': instance.column,
      'status': _$VehicleStatusEnumMap[instance.status]!,
      'statusDuration': instance.statusDuration.inMicroseconds,
      'reason': _$StatusReasonEnumMap[instance.reason],
      'location': instance.location,
      'responsibleUser': instance.responsibleUser,
      'comment': instance.comment,
      'lastUpdated': instance.lastUpdated.toIso8601String(),
      'hourlyCost': instance.hourlyCost,
      'fuelLevel': instance.fuelLevel,
      'engineTemp': instance.engineTemp,
      'mileage': instance.mileage,
      'revenue': instance.revenue,
      'maintenanceCosts': instance.maintenanceCosts,
      'fuelCosts': instance.fuelCosts,
      'amortization': instance.amortization,
      'lat': instance.lat,
      'lng': instance.lng,
      'speed': instance.speed,
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

const _$StatusReasonEnumMap = {
  StatusReason.noTrip: 'noTrip',
  StatusReason.noDriver: 'noDriver',
  StatusReason.breakdown: 'breakdown',
  StatusReason.waitingParts: 'waitingParts',
  StatusReason.waitingLoading: 'waitingLoading',
  StatusReason.waitingUnloading: 'waitingUnloading',
  StatusReason.accident: 'accident',
  StatusReason.selling: 'selling',
  StatusReason.driverVacation: 'driverVacation',
  StatusReason.driverDismissal: 'driverDismissal',
  StatusReason.inspection: 'inspection',
  StatusReason.washing: 'washing',
  StatusReason.managementDecision: 'managementDecision',
  StatusReason.other: 'other',
};
