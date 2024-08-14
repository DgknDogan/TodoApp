part of '../cubit/register_cubit.dart';

@immutable
sealed class RegisterState {}

final class RegisterInitial extends RegisterState {
  final bool isChecked;
  final bool isObsecured;
  final bool isError;
  final GlobalKey<FormState> formkey;

  RegisterInitial({
    required this.isChecked,
    required this.isObsecured,
    required this.formkey,
    required this.isError,
  });

  RegisterInitial copyWith({
    bool? isChecked,
    bool? isObsecured,
    bool? isError,
    GlobalKey<FormState>? formkey,
  }) {
    return RegisterInitial(
      isChecked: isChecked ?? this.isChecked,
      isObsecured: isObsecured ?? this.isObsecured,
      isError: isError ?? this.isError,
      formkey: formkey ?? this.formkey,
    );
  }
}

final class RegisterSuccess extends RegisterState {
  final String message;

  RegisterSuccess({required this.message});

  RegisterSuccess copyWith({String? message}) {
    return RegisterSuccess(
      message: message ?? this.message,
    );
  }
}

final class RegisterError extends RegisterState {
  final String message;

  RegisterError({required this.message});

  RegisterError copyWith({String? message}) {
    return RegisterError(
      message: message ?? this.message,
    );
  }
}
