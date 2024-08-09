import 'package:auto_route/auto_route.dart';

import 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends $AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: SplashRoute.page, initial: true),
        AutoRoute(page: CreateAccountRoute.page),
        AutoRoute(page: LoginRoute.page),
        AutoRoute(page: ForgotPasswordRoute.page),
        CustomRoute(
          page: SetNameRoute.page,
          transitionsBuilder: TransitionsBuilders.fadeIn,
        ),
        CustomRoute(
          page: MessagesInitialRoute.page,
          transitionsBuilder: TransitionsBuilders.fadeIn,
        ),
        CustomRoute(
          page: FriendProfileRoute.page,
          transitionsBuilder: TransitionsBuilders.fadeIn,
        ),
        CustomRoute(
          page: MessageRoute.page,
          transitionsBuilder: TransitionsBuilders.fadeIn,
        ),
        CustomRoute(
          page: SocialRoute.page,
          transitionsBuilder: TransitionsBuilders.fadeIn,
        ),
        CustomRoute(
            page: TodoInitialRoute.page,
            transitionsBuilder: TransitionsBuilders.fadeIn,
            children: [
              CustomRoute(
                page: TodoDetailsRoute.page,
                transitionsBuilder: TransitionsBuilders.fadeIn,
              ),
              CustomRoute(
                page: TodoRoute.page,
                transitionsBuilder: TransitionsBuilders.fadeIn,
                initial: true,
              ),
            ]),
        CustomRoute(
          page: InitialRoute.page,
          transitionsBuilder: TransitionsBuilders.fadeIn,
          children: [
            CustomRoute(
              page: HomeRoute.page,
              transitionsBuilder: TransitionsBuilders.fadeIn,
              initial: true,
            ),
            CustomRoute(
              page: ProfileRoute.page,
              transitionsBuilder: TransitionsBuilders.fadeIn,
            ),
          ],
        )
      ];
}
