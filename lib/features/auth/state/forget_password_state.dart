part of '../cubit/forget_password_cubit.dart';

@immutable
sealed class ForgetPasswordState {}

final class ForgetPasswordInitial extends ForgetPasswordState {
  final GlobalKey<FormState> formKey;

  ForgetPasswordInitial({required this.formKey});

  ForgetPasswordInitial copyWith({GlobalKey<FormState>? formKey}) {
    return ForgetPasswordInitial(
      formKey: formKey ?? this.formKey,
    );
  }
}

final class ForgetPasswordSuccess extends ForgetPasswordState {
  final String message;

  ForgetPasswordSuccess({required this.message});
}
