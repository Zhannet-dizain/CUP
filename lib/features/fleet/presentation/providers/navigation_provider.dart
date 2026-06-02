import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'navigation_provider.g.dart';

enum FleetTab {
  monitoring,
  registry,
  analytics,
  glonass,
  apiGateway,
}

@riverpod
class Navigation extends _$Navigation {
  @override
  FleetTab build() => FleetTab.monitoring;

  void setTab(FleetTab tab) => state = tab;
}
