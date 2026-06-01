// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'fleet_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

FleetEvent _$FleetEventFromJson(Map<String, dynamic> json) {
  return _FleetEvent.fromJson(json);
}

/// @nodoc
mixin _$FleetEvent {
  String get id => throw _privateConstructorUsedError;
  String get vehicleId => throw _privateConstructorUsedError;
  String get licensePlate => throw _privateConstructorUsedError;
  VehicleStatus get oldStatus => throw _privateConstructorUsedError;
  VehicleStatus get newStatus => throw _privateConstructorUsedError;
  String? get reason => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;
  String get initiatorRole => throw _privateConstructorUsedError;

  /// Serializes this FleetEvent to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FleetEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FleetEventCopyWith<FleetEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FleetEventCopyWith<$Res> {
  factory $FleetEventCopyWith(
    FleetEvent value,
    $Res Function(FleetEvent) then,
  ) = _$FleetEventCopyWithImpl<$Res, FleetEvent>;
  @useResult
  $Res call({
    String id,
    String vehicleId,
    String licensePlate,
    VehicleStatus oldStatus,
    VehicleStatus newStatus,
    String? reason,
    DateTime timestamp,
    String initiatorRole,
  });
}

/// @nodoc
class _$FleetEventCopyWithImpl<$Res, $Val extends FleetEvent>
    implements $FleetEventCopyWith<$Res> {
  _$FleetEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FleetEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? vehicleId = null,
    Object? licensePlate = null,
    Object? oldStatus = null,
    Object? newStatus = null,
    Object? reason = freezed,
    Object? timestamp = null,
    Object? initiatorRole = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            vehicleId: null == vehicleId
                ? _value.vehicleId
                : vehicleId // ignore: cast_nullable_to_non_nullable
                      as String,
            licensePlate: null == licensePlate
                ? _value.licensePlate
                : licensePlate // ignore: cast_nullable_to_non_nullable
                      as String,
            oldStatus: null == oldStatus
                ? _value.oldStatus
                : oldStatus // ignore: cast_nullable_to_non_nullable
                      as VehicleStatus,
            newStatus: null == newStatus
                ? _value.newStatus
                : newStatus // ignore: cast_nullable_to_non_nullable
                      as VehicleStatus,
            reason: freezed == reason
                ? _value.reason
                : reason // ignore: cast_nullable_to_non_nullable
                      as String?,
            timestamp: null == timestamp
                ? _value.timestamp
                : timestamp // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            initiatorRole: null == initiatorRole
                ? _value.initiatorRole
                : initiatorRole // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FleetEventImplCopyWith<$Res>
    implements $FleetEventCopyWith<$Res> {
  factory _$$FleetEventImplCopyWith(
    _$FleetEventImpl value,
    $Res Function(_$FleetEventImpl) then,
  ) = __$$FleetEventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String vehicleId,
    String licensePlate,
    VehicleStatus oldStatus,
    VehicleStatus newStatus,
    String? reason,
    DateTime timestamp,
    String initiatorRole,
  });
}

/// @nodoc
class __$$FleetEventImplCopyWithImpl<$Res>
    extends _$FleetEventCopyWithImpl<$Res, _$FleetEventImpl>
    implements _$$FleetEventImplCopyWith<$Res> {
  __$$FleetEventImplCopyWithImpl(
    _$FleetEventImpl _value,
    $Res Function(_$FleetEventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FleetEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? vehicleId = null,
    Object? licensePlate = null,
    Object? oldStatus = null,
    Object? newStatus = null,
    Object? reason = freezed,
    Object? timestamp = null,
    Object? initiatorRole = null,
  }) {
    return _then(
      _$FleetEventImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        vehicleId: null == vehicleId
            ? _value.vehicleId
            : vehicleId // ignore: cast_nullable_to_non_nullable
                  as String,
        licensePlate: null == licensePlate
            ? _value.licensePlate
            : licensePlate // ignore: cast_nullable_to_non_nullable
                  as String,
        oldStatus: null == oldStatus
            ? _value.oldStatus
            : oldStatus // ignore: cast_nullable_to_non_nullable
                  as VehicleStatus,
        newStatus: null == newStatus
            ? _value.newStatus
            : newStatus // ignore: cast_nullable_to_non_nullable
                  as VehicleStatus,
        reason: freezed == reason
            ? _value.reason
            : reason // ignore: cast_nullable_to_non_nullable
                  as String?,
        timestamp: null == timestamp
            ? _value.timestamp
            : timestamp // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        initiatorRole: null == initiatorRole
            ? _value.initiatorRole
            : initiatorRole // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FleetEventImpl implements _FleetEvent {
  const _$FleetEventImpl({
    required this.id,
    required this.vehicleId,
    required this.licensePlate,
    required this.oldStatus,
    required this.newStatus,
    this.reason,
    required this.timestamp,
    required this.initiatorRole,
  });

  factory _$FleetEventImpl.fromJson(Map<String, dynamic> json) =>
      _$$FleetEventImplFromJson(json);

  @override
  final String id;
  @override
  final String vehicleId;
  @override
  final String licensePlate;
  @override
  final VehicleStatus oldStatus;
  @override
  final VehicleStatus newStatus;
  @override
  final String? reason;
  @override
  final DateTime timestamp;
  @override
  final String initiatorRole;

  @override
  String toString() {
    return 'FleetEvent(id: $id, vehicleId: $vehicleId, licensePlate: $licensePlate, oldStatus: $oldStatus, newStatus: $newStatus, reason: $reason, timestamp: $timestamp, initiatorRole: $initiatorRole)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FleetEventImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.vehicleId, vehicleId) ||
                other.vehicleId == vehicleId) &&
            (identical(other.licensePlate, licensePlate) ||
                other.licensePlate == licensePlate) &&
            (identical(other.oldStatus, oldStatus) ||
                other.oldStatus == oldStatus) &&
            (identical(other.newStatus, newStatus) ||
                other.newStatus == newStatus) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.initiatorRole, initiatorRole) ||
                other.initiatorRole == initiatorRole));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    vehicleId,
    licensePlate,
    oldStatus,
    newStatus,
    reason,
    timestamp,
    initiatorRole,
  );

  /// Create a copy of FleetEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FleetEventImplCopyWith<_$FleetEventImpl> get copyWith =>
      __$$FleetEventImplCopyWithImpl<_$FleetEventImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FleetEventImplToJson(this);
  }
}

abstract class _FleetEvent implements FleetEvent {
  const factory _FleetEvent({
    required final String id,
    required final String vehicleId,
    required final String licensePlate,
    required final VehicleStatus oldStatus,
    required final VehicleStatus newStatus,
    final String? reason,
    required final DateTime timestamp,
    required final String initiatorRole,
  }) = _$FleetEventImpl;

  factory _FleetEvent.fromJson(Map<String, dynamic> json) =
      _$FleetEventImpl.fromJson;

  @override
  String get id;
  @override
  String get vehicleId;
  @override
  String get licensePlate;
  @override
  VehicleStatus get oldStatus;
  @override
  VehicleStatus get newStatus;
  @override
  String? get reason;
  @override
  DateTime get timestamp;
  @override
  String get initiatorRole;

  /// Create a copy of FleetEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FleetEventImplCopyWith<_$FleetEventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
