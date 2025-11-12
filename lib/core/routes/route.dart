import 'package:anilist/core/routes/analytic_route_observer.dart';
import 'package:anilist/core/routes/navigator_key.dart';
import 'package:anilist/global/screen/not_found_screen.dart';
import 'package:anilist/global/model/user_data.dart';
import 'package:anilist/modules/account/screen/account_deletion_guide_screen.dart';
import 'package:anilist/modules/account/screen/privacy_policy_screen.dart';
import 'package:anilist/modules/detail_anime/screen/detail_anime_screen.dart';
import 'package:anilist/modules/my_list/screen/shared_my_list_screen.dart';
import 'package:anilist/modules/search/screen/search_screen.dart';

import 'package:anilist/modules/dashboard/screen/dashboard_screen.dart';
import 'package:anilist/modules/auth/screen/login_screen.dart';
import 'package:go_router/go_router.dart';

GoRouter routeConfig({UserData? userData}) => GoRouter(
  debugLogDiagnostics: true,
  navigatorKey: navigatorKey,
  initialLocation: DashboardScreen.path,
  errorBuilder: (context, state) => const NotFoundScreen(),
  observers: [AnalyticsRouteObserver()],
  routes: [
    GoRoute(
      name: DashboardScreen.name,
      path: DashboardScreen.path,
      builder: (context, state) => const DashboardScreen(),
    ),

    GoRoute(
      name: LoginScreen.name,
      path: LoginScreen.path,
      builder: (context, state) => const LoginScreen(),
    ),

    GoRoute(
      name: SearchScreen.name,
      path: SearchScreen.path,
      builder: (context, state) {
        final argument = SearchArgument.fromQueryParams(
          state.uri.queryParameters,
        );
        return SearchScreen(argument: argument);
      },
    ),

    GoRoute(
      name: DetailAnimeScreen.name,
      path: '${DetailAnimeScreen.path}/:id',
      builder: (context, state) {
        final argument = DetailAnimeArgument.fromPathParams(
          state.pathParameters,
        );
        return DetailAnimeScreen(argument: argument);
      },
    ),

    GoRoute(
      name: SharedMyListScreen.name,
      path: '${SharedMyListScreen.path}/:id',
      builder: (context, state) {
        final argument = SharedMyListArgument.fromPathParams(
          state.pathParameters,
        );
        return SharedMyListScreen(argument: argument);
      },
    ),

    GoRoute(
      name: PrivacyPolicyScreen.name,
      path: PrivacyPolicyScreen.path,
      builder: (context, state) => const PrivacyPolicyScreen(),
    ),

    GoRoute(
      name: AccountDeletionGuideScreen.name,
      path: AccountDeletionGuideScreen.path,
      builder: (context, state) => const AccountDeletionGuideScreen(),
    ),
  ],
);
