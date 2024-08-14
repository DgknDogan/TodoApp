part of '../cubit/login_cubit.dart';

@immutable
sealed class LoginState {}

final class LoginInitial extends LoginState {
  final GlobalKey<FormState> formKey;
  final bool isObsecured;
  final bool isRemembered;

  LoginInitial({
    required this.formKey,
    required this.isObsecured,
    required this.isRemembered,
  });

  LoginInitial copyWith({
    GlobalKey<FormState>? formKey,
    bool? isObsecured,
    bool? isRemembered,
  }) {
    return LoginInitial(
      formKey: formKey ?? this.formKey,
      isObsecured: isObsecured ?? this.isObsecured,
      isRemembered: isRemembered ?? this.isRemembered,
    );
  }
}

final class LoginSuccess extends LoginState {
  final String message;

  LoginSuccess({required this.message});
}

final class LoginFailed extends LoginState {
  final String message;

  LoginFailed({required this.message});
}
