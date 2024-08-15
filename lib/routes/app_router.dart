import 'package:auto_route/auto_route.dart';

import 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends $AppRouter {
  @override
  RouteType get defaultRouteType => const RouteType.custom(
      transitionsBuilder: TransitionsBuilders.fadeIn,
      durationInMilliseconds: 350);
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: SplashRoute.page, initial: true),
        AutoRoute(page: CreateAccountRoute.page),
        AutoRoute(page: LoginRoute.page),
        AutoRoute(page: ForgotPasswordRoute.page),
        AutoRoute(page: SetNameRoute.page),
        AutoRoute(page: MessagesInitialRoute.page),
        AutoRoute(page: FriendProfileRoute.page),
        AutoRoute(page: MessageRoute.page),
        AutoRoute(page: SocialRoute.page),
        AutoRoute(page: AppSettingsRoute.page),
        AutoRoute(page: TodoInitialRoute.page, children: [
          AutoRoute(page: TodoDetailsRoute.page),
          AutoRoute(
            page: TodoRoute.page,
            initial: true,
          ),
        ]),
        AutoRoute(
          page: InitialRoute.page,
          children: [
            AutoRoute(
              page: HomeRoute.page,
              initial: true,
            ),
            AutoRoute(page: ProfileRoute.page),
          ],
        )
      ];
}
