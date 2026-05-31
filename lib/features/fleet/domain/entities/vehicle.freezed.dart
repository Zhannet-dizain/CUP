// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vehicle.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Vehicle _$VehicleFromJson(Map<String, dynamic> json) {
  return _Vehicle.fromJson(json);
}

/// @nodoc
mixin _$Vehicle {
  String get id => throw _privateConstructorUsedError;
  String get licensePlate => throw _privateConstructorUsedError;
  String get brandModel => throw _privateConstructorUsedError;
  String? get trailer => throw _privateConstructorUsedError;
  String? get driver => throw _privateConstructorUsedError;
  String get column => throw _privateConstructorUsedError;
  VehicleStatus get status => throw _privateConstructorUsedError;
  Duration get statusDuration => throw _privateConstructorUsedError;
  StatusReason? get reason => throw _privateConstructorUsedError;
  String get location => throw _privateConstructorUsedError;
  String get responsibleUser => throw _privateConstructorUsedError;
  String? get comment => throw _privateConstructorUsedError;
  DateTime get lastUpdated => throw _privateConstructorUsedError;

  /// Serializes this Vehicle to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Vehicle
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VehicleCopyWith<Vehicle> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VehicleCopyWith<$Res> {
  factory $VehicleCopyWith(Vehicle value, $Res Function(Vehicle) then) =
      _$VehicleCopyWithImpl<$Res, Vehicle>;
  @useResult
  $Res call({
    String id,
    String licensePlate,
    String brandModel,
    String? trailer,
    String? driver,
    String column,
    VehicleStatus status,
    Duration statusDuration,
    StatusReason? reason,
    String location,
    String responsibleUser,
    String? comment,
    DateTime lastUpdated,
  });
}

/// @nodoc
class _$VehicleCopyWithImpl<$Res, $Val extends Vehicle>
    implements $VehicleCopyWith<$Res> {
  _$VehicleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Vehicle
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? licensePlate = null,
    Object? brandModel = null,
    Object? trailer = freezed,
    Object? driver = freezed,
    Object? column = null,
    Object? status = null,
    Object? statusDuration = null,
    Object? reason = freezed,
    Object? location = null,
    Object? responsibleUser = null,
    Object? comment = freezed,
    Object? lastUpdated = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            licensePlate: null == licensePlate
                ? _value.licensePlate
                : licensePlate // ignore: cast_nullable_to_non_nullable
                      as String,
            brandModel: null == brandModel
                ? _value.brandModel
                : brandModel // ignore: cast_nullable_to_non_nullable
                      as String,
            trailer: freezed == trailer
                ? _value.trailer
                : trailer // ignore: cast_nullable_to_non_nullable
                      as String?,
            driver: freezed == driver
                ? _value.driver
                : driver // ignore: cast_nullable_to_non_nullable
                      as String?,
            column: null == column
                ? _value.column
                : column // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as VehicleStatus,
            statusDuration: null == statusDuration
                ? _value.statusDuration
                : statusDuration // ignore: cast_nullable_to_non_nullable
                      as Duration,
            reason: freezed == reason
                ? _value.reason
                : reason // ignore: cast_nullable_to_non_nullable
                      as StatusReason?,
            location: null == location
                ? _value.location
                : location // ignore: cast_nullable_to_non_nullable
                      as String,
            responsibleUser: null == responsibleUser
                ? _value.responsibleUser
                : responsibleUser // ignore: cast_nullable_to_non_nullable
                      as String,
            comment: freezed == comment
                ? _value.comment
                : comment // ignore: cast_nullable_to_non_nullable
                      as String?,
            lastUpdated: null == lastUpdated
                ? _value.lastUpdated
                : lastUpdated // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$VehicleImplCopyWith<$Res> implements $VehicleCopyWith<$Res> {
  factory _$$VehicleImplCopyWith(
    _$VehicleImpl value,
    $Res Function(_$VehicleImpl) then,
  ) = __$$VehicleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String licensePlate,
    String brandModel,
    String? trailer,
    String? driver,
    String column,
    VehicleStatus status,
    Duration statusDuration,
    StatusReason? reason,
    String location,
    String responsibleUser,
    String? comment,
    DateTime lastUpdated,
  });
}

/// @nodoc
class __$$VehicleImplCopyWithImpl<$Res>
    extends _$VehicleCopyWithImpl<$Res, _$VehicleImpl>
    implements _$$VehicleImplCopyWith<$Res> {
  __$$VehicleImplCopyWithImpl(
    _$VehicleImpl _value,
    $Res Function(_$VehicleImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Vehicle
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? licensePlate = null,
    Object? brandModel = null,
    Object? trailer = freezed,
    Object? driver = freezed,
    Object? column = null,
    Object? status = null,
    Object? statusDuration = null,
    Object? reason = freezed,
    Object? location = null,
    Object? responsibleUser = null,
    Object? comment = freezed,
    Object? lastUpdated = null,
  }) {
    return _then(
      _$VehicleImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        licensePlate: null == licensePlate
            ? _value.licensePlate
            : licensePlate // ignore: cast_nullable_to_non_nullable
                  as String,
        brandModel: null == brandModel
            ? _value.brandModel
            : brandModel // ignore: cast_nullable_to_non_nullable
                  as String,
        trailer: freezed == trailer
            ? _value.trailer
            : trailer // ignore: cast_nullable_to_non_nullable
                  as String?,
        driver: freezed == driver
            ? _value.driver
            : driver // ignore: cast_nullable_to_non_nullable
                  as String?,
        column: null == column
            ? _value.column
            : column // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as VehicleStatus,
        statusDuration: null == statusDuration
            ? _value.statusDuration
            : statusDuration // ignore: cast_nullable_to_non_nullable
                  as Duration,
        reason: freezed == reason
            ? _value.reason
            : reason // ignore: cast_nullable_to_non_nullable
                  as StatusReason?,
        location: null == location
            ? _value.location
            : location // ignore: cast_nullable_to_non_nullable
                  as String,
        responsibleUser: null == responsibleUser
            ? _value.responsibleUser
            : responsibleUser // ignore: cast_nullable_to_non_nullable
                  as String,
        comment: freezed == comment
            ? _value.comment
            : comment // ignore: cast_nullable_to_non_nullable
                  as String?,
        lastUpdated: null == lastUpdated
            ? _value.lastUpdated
            : lastUpdated // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$VehicleImpl implements _Vehicle {
  const _$VehicleImpl({
    required this.id,
    required this.licensePlate,
    required this.brandModel,
    this.trailer,
    this.driver,
    required this.column,
    required this.status,
    required this.statusDuration,
    this.reason,
    required this.location,
    required this.responsibleUser,
    this.comment,
    required this.lastUpdated,
  });

  factory _$VehicleImpl.fromJson(Map<String, dynamic> json) =>
      _$$VehicleImplFromJson(json);

  @override
  final String id;
  @override
  final String licensePlate;
  @override
  final String brandModel;
  @override
  final String? trailer;
  @override
  final String? driver;
  @override
  final String column;
  @override
  final VehicleStatus status;
  @override
  final Duration statusDuration;
  @override
  final StatusReason? reason;
  @override
  final String location;
  @override
  final String responsibleUser;
  @override
  final String? comment;
  @override
  final DateTime lastUpdated;

  @override
  String toString() {
    return 'Vehicle(id: $id, licensePlate: $licensePlate, brandModel: $brandModel, trailer: $trailer, driver: $driver, column: $column, status: $status, statusDuration: $statusDuration, reason: $reason, location: $location, responsibleUser: $responsibleUser, comment: $comment, lastUpdated: $lastUpdated)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VehicleImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.licensePlate, licensePlate) ||
                other.licensePlate == licensePlate) &&
            (identical(other.brandModel, brandModel) ||
                other.brandModel == brandModel) &&
            (identical(other.trailer, trailer) || other.trailer == trailer) &&
            (identical(other.driver, driver) || other.driver == driver) &&
            (identical(other.column, column) || other.column == column) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.statusDuration, statusDuration) ||
                other.statusDuration == statusDuration) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.responsibleUser, responsibleUser) ||
                other.responsibleUser == responsibleUser) &&
            (identical(other.comment, comment) || other.comment == comment) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    licensePlate,
    brandModel,
    trailer,
    driver,
    column,
    status,
    statusDuration,
    reason,
    location,
    responsibleUser,
    comment,
    lastUpdated,
  );

  /// Create a copy of Vehicle
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VehicleImplCopyWith<_$VehicleImpl> get copyWith =>
      __$$VehicleImplCopyWithImpl<_$VehicleImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VehicleImplToJson(this);
  }
}

abstract class _Vehicle implements Vehicle {
  const factory _Vehicle({
    required final String id,
    required final String licensePlate,
    required final String brandModel,
    final String? trailer,
    final String? driver,
    required final String column,
    required final VehicleStatus status,
    required final Duration statusDuration,
    final StatusReason? reason,
    required final String location,
    required final String responsibleUser,
    final String? comment,
    required final DateTime lastUpdated,
  }) = _$VehicleImpl;

  factory _Vehicle.fromJson(Map<String, dynamic> json) = _$VehicleImpl.fromJson;

  @override
  String get id;
  @override
  String get licensePlate;
  @override
  String get brandModel;
  @override
  String? get trailer;
  @override
  String? get driver;
  @override
  String get column;
  @override
  VehicleStatus get status;
  @override
  Duration get statusDuration;
  @override
  StatusReason? get reason;
  @override
  String get location;
  @override
  String get responsibleUser;
  @override
  String? get comment;
  @override
  DateTime get lastUpdated;

  /// Create a copy of Vehicle
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VehicleImplCopyWith<_$VehicleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
