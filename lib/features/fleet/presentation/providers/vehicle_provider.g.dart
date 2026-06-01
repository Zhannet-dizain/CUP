// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$vehicleListHash() => r'4d4c79e89900ea0cd72a6955bd919b91dbd982db';

/// See also [VehicleList].
@ProviderFor(VehicleList)
final vehicleListProvider =
    AutoDisposeNotifierProvider<VehicleList, List<Vehicle>>.internal(
      VehicleList.new,
      name: r'vehicleListProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$vehicleListHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$VehicleList = AutoDisposeNotifier<List<Vehicle>>;
String _$fleetEventsHash() => r'd7e35ec5c5e477c5f982b526f354726555a30733';

/// See also [FleetEvents].
@ProviderFor(FleetEvents)
final fleetEventsProvider =
    AutoDisposeNotifierProvider<FleetEvents, List<FleetEvent>>.internal(
      FleetEvents.new,
      name: r'fleetEventsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$fleetEventsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$FleetEvents = AutoDisposeNotifier<List<FleetEvent>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
