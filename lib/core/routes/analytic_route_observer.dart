import 'package:flutter/widgets.dart';
import 'package:anilist/services/analytic_service.dart';

class AnalyticsRouteObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _logScreen(route);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    _logScreen(previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    _logScreen(newRoute);
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    _logScreen(previousRoute);
  }

  void _logScreen(Route<dynamic>? route) {
    if (route == null) return;

    final screenName = route.settings.name ?? route.runtimeType.toString();

    AnalyticsService.instance.logScreenView(screenName: screenName);
  }
}
