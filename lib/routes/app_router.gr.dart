// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i15;
import 'package:firebase_demo/features/auth/pages/create_acoount_page.dart'
    as _i1;
import 'package:firebase_demo/features/auth/pages/forgot_password_page.dart'
    as _i2;
import 'package:firebase_demo/features/auth/pages/login_page.dart' as _i6;
import 'package:firebase_demo/features/auth/pages/splash_page.dart' as _i11;
import 'package:firebase_demo/features/user/model/todo_model.dart' as _i18;
import 'package:firebase_demo/features/user/model/user_model.dart' as _i17;
import 'package:firebase_demo/features/user/pages/friend_profile_page.dart'
    as _i3;
import 'package:firebase_demo/features/user/pages/home_page.dart' as _i4;
import 'package:firebase_demo/features/user/pages/initial_page.dart' as _i5;
import 'package:firebase_demo/features/user/pages/message_page.dart' as _i7;
import 'package:firebase_demo/features/user/pages/messages_initial_page.dart'
    as _i8;
import 'package:firebase_demo/features/user/pages/profile_page.dart' as _i9;
import 'package:firebase_demo/features/user/pages/social_page.dart' as _i10;
import 'package:firebase_demo/features/user/pages/todo_details_page.dart'
    as _i12;
import 'package:firebase_demo/features/user/pages/todo_initial_page.dart'
    as _i13;
import 'package:firebase_demo/features/user/pages/todo_page.dart' as _i14;
import 'package:flutter/material.dart' as _i16;

abstract class $AppRouter extends _i15.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i15.PageFactory> pagesMap = {
    CreateAccountRoute.name: (routeData) {
      return _i15.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i1.CreateAccountPage(),
      );
    },
    ForgotPasswordRoute.name: (routeData) {
      return _i15.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i2.ForgotPasswordPage(),
      );
    },
    FriendProfileRoute.name: (routeData) {
      final args = routeData.argsAs<FriendProfileRouteArgs>();
      return _i15.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i3.FriendProfilePage(
          key: args.key,
          friend: args.friend,
        ),
      );
    },
    HomeRoute.name: (routeData) {
      return _i15.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i4.HomePage(),
      );
    },
    InitialRoute.name: (routeData) {
      return _i15.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i5.InitialPage(),
      );
    },
    LoginRoute.name: (routeData) {
      return _i15.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i6.LoginPage(),
      );
    },
    MessageRoute.name: (routeData) {
      final args = routeData.argsAs<MessageRouteArgs>();
      return _i15.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i7.MessagePage(
          key: args.key,
          friend: args.friend,
        ),
      );
    },
    MessagesInitialRoute.name: (routeData) {
      return _i15.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i8.MessagesInitialPage(),
      );
    },
    ProfileRoute.name: (routeData) {
      return _i15.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i9.ProfilePage(),
      );
    },
    SocialRoute.name: (routeData) {
      return _i15.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i10.SocialPage(),
      );
    },
    SplashRoute.name: (routeData) {
      return _i15.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i11.SplashPage(),
      );
    },
    TodoDetailsRoute.name: (routeData) {
      final args = routeData.argsAs<TodoDetailsRouteArgs>();
      return _i15.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i12.TodoDetailsPage(
          key: args.key,
          todo: args.todo,
        ),
      );
    },
    TodoInitialRoute.name: (routeData) {
      return _i15.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i13.TodoInitialPage(),
      );
    },
    TodoRoute.name: (routeData) {
      return _i15.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i14.TodoPage(),
      );
    },
  };
}

/// generated route for
/// [_i1.CreateAccountPage]
class CreateAccountRoute extends _i15.PageRouteInfo<void> {
  const CreateAccountRoute({List<_i15.PageRouteInfo>? children})
      : super(
          CreateAccountRoute.name,
          initialChildren: children,
        );

  static const String name = 'CreateAccountRoute';

  static const _i15.PageInfo<void> page = _i15.PageInfo<void>(name);
}

/// generated route for
/// [_i2.ForgotPasswordPage]
class ForgotPasswordRoute extends _i15.PageRouteInfo<void> {
  const ForgotPasswordRoute({List<_i15.PageRouteInfo>? children})
      : super(
          ForgotPasswordRoute.name,
          initialChildren: children,
        );

  static const String name = 'ForgotPasswordRoute';

  static const _i15.PageInfo<void> page = _i15.PageInfo<void>(name);
}

/// generated route for
/// [_i3.FriendProfilePage]
class FriendProfileRoute extends _i15.PageRouteInfo<FriendProfileRouteArgs> {
  FriendProfileRoute({
    _i16.Key? key,
    required _i17.UserModel friend,
    List<_i15.PageRouteInfo>? children,
  }) : super(
          FriendProfileRoute.name,
          args: FriendProfileRouteArgs(
            key: key,
            friend: friend,
          ),
          initialChildren: children,
        );

  static const String name = 'FriendProfileRoute';

  static const _i15.PageInfo<FriendProfileRouteArgs> page =
      _i15.PageInfo<FriendProfileRouteArgs>(name);
}

class FriendProfileRouteArgs {
  const FriendProfileRouteArgs({
    this.key,
    required this.friend,
  });

  final _i16.Key? key;

  final _i17.UserModel friend;

  @override
  String toString() {
    return 'FriendProfileRouteArgs{key: $key, friend: $friend}';
  }
}

/// generated route for
/// [_i4.HomePage]
class HomeRoute extends _i15.PageRouteInfo<void> {
  const HomeRoute({List<_i15.PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static const _i15.PageInfo<void> page = _i15.PageInfo<void>(name);
}

/// generated route for
/// [_i5.InitialPage]
class InitialRoute extends _i15.PageRouteInfo<void> {
  const InitialRoute({List<_i15.PageRouteInfo>? children})
      : super(
          InitialRoute.name,
          initialChildren: children,
        );

  static const String name = 'InitialRoute';

  static const _i15.PageInfo<void> page = _i15.PageInfo<void>(name);
}

/// generated route for
/// [_i6.LoginPage]
class LoginRoute extends _i15.PageRouteInfo<void> {
  const LoginRoute({List<_i15.PageRouteInfo>? children})
      : super(
          LoginRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static const _i15.PageInfo<void> page = _i15.PageInfo<void>(name);
}

/// generated route for
/// [_i7.MessagePage]
class MessageRoute extends _i15.PageRouteInfo<MessageRouteArgs> {
  MessageRoute({
    _i16.Key? key,
    required _i17.UserModel friend,
    List<_i15.PageRouteInfo>? children,
  }) : super(
          MessageRoute.name,
          args: MessageRouteArgs(
            key: key,
            friend: friend,
          ),
          initialChildren: children,
        );

  static const String name = 'MessageRoute';

  static const _i15.PageInfo<MessageRouteArgs> page =
      _i15.PageInfo<MessageRouteArgs>(name);
}

class MessageRouteArgs {
  const MessageRouteArgs({
    this.key,
    required this.friend,
  });

  final _i16.Key? key;

  final _i17.UserModel friend;

  @override
  String toString() {
    return 'MessageRouteArgs{key: $key, friend: $friend}';
  }
}

/// generated route for
/// [_i8.MessagesInitialPage]
class MessagesInitialRoute extends _i15.PageRouteInfo<void> {
  const MessagesInitialRoute({List<_i15.PageRouteInfo>? children})
      : super(
          MessagesInitialRoute.name,
          initialChildren: children,
        );

  static const String name = 'MessagesInitialRoute';

  static const _i15.PageInfo<void> page = _i15.PageInfo<void>(name);
}

/// generated route for
/// [_i9.ProfilePage]
class ProfileRoute extends _i15.PageRouteInfo<void> {
  const ProfileRoute({List<_i15.PageRouteInfo>? children})
      : super(
          ProfileRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProfileRoute';

  static const _i15.PageInfo<void> page = _i15.PageInfo<void>(name);
}

/// generated route for
/// [_i10.SocialPage]
class SocialRoute extends _i15.PageRouteInfo<void> {
  const SocialRoute({List<_i15.PageRouteInfo>? children})
      : super(
          SocialRoute.name,
          initialChildren: children,
        );

  static const String name = 'SocialRoute';

  static const _i15.PageInfo<void> page = _i15.PageInfo<void>(name);
}

/// generated route for
/// [_i11.SplashPage]
class SplashRoute extends _i15.PageRouteInfo<void> {
  const SplashRoute({List<_i15.PageRouteInfo>? children})
      : super(
          SplashRoute.name,
          initialChildren: children,
        );

  static const String name = 'SplashRoute';

  static const _i15.PageInfo<void> page = _i15.PageInfo<void>(name);
}

/// generated route for
/// [_i12.TodoDetailsPage]
class TodoDetailsRoute extends _i15.PageRouteInfo<TodoDetailsRouteArgs> {
  TodoDetailsRoute({
    _i16.Key? key,
    required _i18.TodoModel todo,
    List<_i15.PageRouteInfo>? children,
  }) : super(
          TodoDetailsRoute.name,
          args: TodoDetailsRouteArgs(
            key: key,
            todo: todo,
          ),
          initialChildren: children,
        );

  static const String name = 'TodoDetailsRoute';

  static const _i15.PageInfo<TodoDetailsRouteArgs> page =
      _i15.PageInfo<TodoDetailsRouteArgs>(name);
}

class TodoDetailsRouteArgs {
  const TodoDetailsRouteArgs({
    this.key,
    required this.todo,
  });

  final _i16.Key? key;

  final _i18.TodoModel todo;

  @override
  String toString() {
    return 'TodoDetailsRouteArgs{key: $key, todo: $todo}';
  }
}

/// generated route for
/// [_i13.TodoInitialPage]
class TodoInitialRoute extends _i15.PageRouteInfo<void> {
  const TodoInitialRoute({List<_i15.PageRouteInfo>? children})
      : super(
          TodoInitialRoute.name,
          initialChildren: children,
        );

  static const String name = 'TodoInitialRoute';

  static const _i15.PageInfo<void> page = _i15.PageInfo<void>(name);
}

/// generated route for
/// [_i14.TodoPage]
class TodoRoute extends _i15.PageRouteInfo<void> {
  const TodoRoute({List<_i15.PageRouteInfo>? children})
      : super(
          TodoRoute.name,
          initialChildren: children,
        );

  static const String name = 'TodoRoute';

  static const _i15.PageInfo<void> page = _i15.PageInfo<void>(name);
}
