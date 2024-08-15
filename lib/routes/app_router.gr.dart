// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i17;
import 'package:firebase_demo/features/auth/models/user_model.dart' as _i19;
import 'package:firebase_demo/features/auth/pages/create_acoount_page.dart'
    as _i2;
import 'package:firebase_demo/features/auth/pages/forgot_password_page.dart'
    as _i3;
import 'package:firebase_demo/features/auth/pages/login_page.dart' as _i7;
import 'package:firebase_demo/features/auth/pages/set_name_page.dart' as _i11;
import 'package:firebase_demo/features/auth/pages/splash_page.dart' as _i13;
import 'package:firebase_demo/features/user/model/todo_model.dart' as _i20;
import 'package:firebase_demo/features/user/pages/app_settings_page.dart'
    as _i1;
import 'package:firebase_demo/features/user/pages/friend_profile_page.dart'
    as _i4;
import 'package:firebase_demo/features/user/pages/home_page.dart' as _i5;
import 'package:firebase_demo/features/user/pages/initial_page.dart' as _i6;
import 'package:firebase_demo/features/user/pages/messaging_pages/message_page.dart'
    as _i8;
import 'package:firebase_demo/features/user/pages/messaging_pages/messages_initial_page.dart'
    as _i9;
import 'package:firebase_demo/features/user/pages/profile_page.dart' as _i10;
import 'package:firebase_demo/features/user/pages/social_page.dart' as _i12;
import 'package:firebase_demo/features/user/pages/todo_pages/todo_details_page.dart'
    as _i14;
import 'package:firebase_demo/features/user/pages/todo_pages/todo_initial_page.dart'
    as _i15;
import 'package:firebase_demo/features/user/pages/todo_pages/todo_page.dart'
    as _i16;
import 'package:flutter/material.dart' as _i18;

abstract class $AppRouter extends _i17.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i17.PageFactory> pagesMap = {
    AppSettingsRoute.name: (routeData) {
      return _i17.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i1.AppSettingsPage(),
      );
    },
    CreateAccountRoute.name: (routeData) {
      return _i17.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i2.CreateAccountPage(),
      );
    },
    ForgotPasswordRoute.name: (routeData) {
      return _i17.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i3.ForgotPasswordPage(),
      );
    },
    FriendProfileRoute.name: (routeData) {
      final args = routeData.argsAs<FriendProfileRouteArgs>();
      return _i17.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i4.FriendProfilePage(
          key: args.key,
          friend: args.friend,
        ),
      );
    },
    HomeRoute.name: (routeData) {
      return _i17.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i5.HomePage(),
      );
    },
    InitialRoute.name: (routeData) {
      return _i17.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i6.InitialPage(),
      );
    },
    LoginRoute.name: (routeData) {
      return _i17.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i7.LoginPage(),
      );
    },
    MessageRoute.name: (routeData) {
      final args = routeData.argsAs<MessageRouteArgs>();
      return _i17.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i8.MessagePage(
          key: args.key,
          friend: args.friend,
        ),
      );
    },
    MessagesInitialRoute.name: (routeData) {
      return _i17.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i9.MessagesInitialPage(),
      );
    },
    ProfileRoute.name: (routeData) {
      return _i17.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i10.ProfilePage(),
      );
    },
    SetNameRoute.name: (routeData) {
      return _i17.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i11.SetNamePage(),
      );
    },
    SocialRoute.name: (routeData) {
      return _i17.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i12.SocialPage(),
      );
    },
    SplashRoute.name: (routeData) {
      return _i17.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i13.SplashPage(),
      );
    },
    TodoDetailsRoute.name: (routeData) {
      final args = routeData.argsAs<TodoDetailsRouteArgs>();
      return _i17.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i14.TodoDetailsPage(
          key: args.key,
          todo: args.todo,
        ),
      );
    },
    TodoInitialRoute.name: (routeData) {
      return _i17.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i15.TodoInitialPage(),
      );
    },
    TodoRoute.name: (routeData) {
      return _i17.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i16.TodoPage(),
      );
    },
  };
}

/// generated route for
/// [_i1.AppSettingsPage]
class AppSettingsRoute extends _i17.PageRouteInfo<void> {
  const AppSettingsRoute({List<_i17.PageRouteInfo>? children})
      : super(
          AppSettingsRoute.name,
          initialChildren: children,
        );

  static const String name = 'AppSettingsRoute';

  static const _i17.PageInfo<void> page = _i17.PageInfo<void>(name);
}

/// generated route for
/// [_i2.CreateAccountPage]
class CreateAccountRoute extends _i17.PageRouteInfo<void> {
  const CreateAccountRoute({List<_i17.PageRouteInfo>? children})
      : super(
          CreateAccountRoute.name,
          initialChildren: children,
        );

  static const String name = 'CreateAccountRoute';

  static const _i17.PageInfo<void> page = _i17.PageInfo<void>(name);
}

/// generated route for
/// [_i3.ForgotPasswordPage]
class ForgotPasswordRoute extends _i17.PageRouteInfo<void> {
  const ForgotPasswordRoute({List<_i17.PageRouteInfo>? children})
      : super(
          ForgotPasswordRoute.name,
          initialChildren: children,
        );

  static const String name = 'ForgotPasswordRoute';

  static const _i17.PageInfo<void> page = _i17.PageInfo<void>(name);
}

/// generated route for
/// [_i4.FriendProfilePage]
class FriendProfileRoute extends _i17.PageRouteInfo<FriendProfileRouteArgs> {
  FriendProfileRoute({
    _i18.Key? key,
    required _i19.UserModel friend,
    List<_i17.PageRouteInfo>? children,
  }) : super(
          FriendProfileRoute.name,
          args: FriendProfileRouteArgs(
            key: key,
            friend: friend,
          ),
          initialChildren: children,
        );

  static const String name = 'FriendProfileRoute';

  static const _i17.PageInfo<FriendProfileRouteArgs> page =
      _i17.PageInfo<FriendProfileRouteArgs>(name);
}

class FriendProfileRouteArgs {
  const FriendProfileRouteArgs({
    this.key,
    required this.friend,
  });

  final _i18.Key? key;

  final _i19.UserModel friend;

  @override
  String toString() {
    return 'FriendProfileRouteArgs{key: $key, friend: $friend}';
  }
}

/// generated route for
/// [_i5.HomePage]
class HomeRoute extends _i17.PageRouteInfo<void> {
  const HomeRoute({List<_i17.PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static const _i17.PageInfo<void> page = _i17.PageInfo<void>(name);
}

/// generated route for
/// [_i6.InitialPage]
class InitialRoute extends _i17.PageRouteInfo<void> {
  const InitialRoute({List<_i17.PageRouteInfo>? children})
      : super(
          InitialRoute.name,
          initialChildren: children,
        );

  static const String name = 'InitialRoute';

  static const _i17.PageInfo<void> page = _i17.PageInfo<void>(name);
}

/// generated route for
/// [_i7.LoginPage]
class LoginRoute extends _i17.PageRouteInfo<void> {
  const LoginRoute({List<_i17.PageRouteInfo>? children})
      : super(
          LoginRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static const _i17.PageInfo<void> page = _i17.PageInfo<void>(name);
}

/// generated route for
/// [_i8.MessagePage]
class MessageRoute extends _i17.PageRouteInfo<MessageRouteArgs> {
  MessageRoute({
    _i18.Key? key,
    required _i19.UserModel friend,
    List<_i17.PageRouteInfo>? children,
  }) : super(
          MessageRoute.name,
          args: MessageRouteArgs(
            key: key,
            friend: friend,
          ),
          initialChildren: children,
        );

  static const String name = 'MessageRoute';

  static const _i17.PageInfo<MessageRouteArgs> page =
      _i17.PageInfo<MessageRouteArgs>(name);
}

class MessageRouteArgs {
  const MessageRouteArgs({
    this.key,
    required this.friend,
  });

  final _i18.Key? key;

  final _i19.UserModel friend;

  @override
  String toString() {
    return 'MessageRouteArgs{key: $key, friend: $friend}';
  }
}

/// generated route for
/// [_i9.MessagesInitialPage]
class MessagesInitialRoute extends _i17.PageRouteInfo<void> {
  const MessagesInitialRoute({List<_i17.PageRouteInfo>? children})
      : super(
          MessagesInitialRoute.name,
          initialChildren: children,
        );

  static const String name = 'MessagesInitialRoute';

  static const _i17.PageInfo<void> page = _i17.PageInfo<void>(name);
}

/// generated route for
/// [_i10.ProfilePage]
class ProfileRoute extends _i17.PageRouteInfo<void> {
  const ProfileRoute({List<_i17.PageRouteInfo>? children})
      : super(
          ProfileRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProfileRoute';

  static const _i17.PageInfo<void> page = _i17.PageInfo<void>(name);
}

/// generated route for
/// [_i11.SetNamePage]
class SetNameRoute extends _i17.PageRouteInfo<void> {
  const SetNameRoute({List<_i17.PageRouteInfo>? children})
      : super(
          SetNameRoute.name,
          initialChildren: children,
        );

  static const String name = 'SetNameRoute';

  static const _i17.PageInfo<void> page = _i17.PageInfo<void>(name);
}

/// generated route for
/// [_i12.SocialPage]
class SocialRoute extends _i17.PageRouteInfo<void> {
  const SocialRoute({List<_i17.PageRouteInfo>? children})
      : super(
          SocialRoute.name,
          initialChildren: children,
        );

  static const String name = 'SocialRoute';

  static const _i17.PageInfo<void> page = _i17.PageInfo<void>(name);
}

/// generated route for
/// [_i13.SplashPage]
class SplashRoute extends _i17.PageRouteInfo<void> {
  const SplashRoute({List<_i17.PageRouteInfo>? children})
      : super(
          SplashRoute.name,
          initialChildren: children,
        );

  static const String name = 'SplashRoute';

  static const _i17.PageInfo<void> page = _i17.PageInfo<void>(name);
}

/// generated route for
/// [_i14.TodoDetailsPage]
class TodoDetailsRoute extends _i17.PageRouteInfo<TodoDetailsRouteArgs> {
  TodoDetailsRoute({
    _i18.Key? key,
    required _i20.TodoModel todo,
    List<_i17.PageRouteInfo>? children,
  }) : super(
          TodoDetailsRoute.name,
          args: TodoDetailsRouteArgs(
            key: key,
            todo: todo,
          ),
          initialChildren: children,
        );

  static const String name = 'TodoDetailsRoute';

  static const _i17.PageInfo<TodoDetailsRouteArgs> page =
      _i17.PageInfo<TodoDetailsRouteArgs>(name);
}

class TodoDetailsRouteArgs {
  const TodoDetailsRouteArgs({
    this.key,
    required this.todo,
  });

  final _i18.Key? key;

  final _i20.TodoModel todo;

  @override
  String toString() {
    return 'TodoDetailsRouteArgs{key: $key, todo: $todo}';
  }
}

/// generated route for
/// [_i15.TodoInitialPage]
class TodoInitialRoute extends _i17.PageRouteInfo<void> {
  const TodoInitialRoute({List<_i17.PageRouteInfo>? children})
      : super(
          TodoInitialRoute.name,
          initialChildren: children,
        );

  static const String name = 'TodoInitialRoute';

  static const _i17.PageInfo<void> page = _i17.PageInfo<void>(name);
}

/// generated route for
/// [_i16.TodoPage]
class TodoRoute extends _i17.PageRouteInfo<void> {
  const TodoRoute({List<_i17.PageRouteInfo>? children})
      : super(
          TodoRoute.name,
          initialChildren: children,
        );

  static const String name = 'TodoRoute';

  static const _i17.PageInfo<void> page = _i17.PageInfo<void>(name);
}
