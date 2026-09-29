import 'dart:developer' as developer;

import 'package:absensi_dede/absensi/models/login/login_request_model.dart';
import 'package:absensi_dede/absensi/models/register/register_request_model.dart';
import 'package:absensi_dede/absensi/router/routes.dart';
import 'package:absensi_dede/absensi/services/login_preferences.dart';
import 'package:absensi_dede/absensi/controllers/history_absen.dart';
import 'package:absensi_dede/absensi/controllers/login_user.dart';
import 'package:absensi_dede/absensi/controllers/register_user.dart';
import 'package:absensi_dede/absensi/riverpod/user_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:forui/forui.dart';

class FormAuth extends ConsumerStatefulWidget {
  final bool isRegister;
  final VoidCallback? onSwitchToLogin;

  const FormAuth({super.key, this.isRegister = false, this.onSwitchToLogin});

  @override
  ConsumerState<FormAuth> createState() => _FormAuthState();
}

class _FormAuthState extends ConsumerState<FormAuth> {
  final _key = GlobalKey<FormBuilderState>();

  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant FormAuth oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isRegister != widget.isRegister) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _key.currentState?.patchValue({
          'email': _emailController.text,
          'password': _passwordController.text,
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(registerUserProvider, (previous, next) {
      next.whenOrNull(
        data: (response) {
          if (response == null) return;

          showFToast(
            context: context,
            duration: const Duration(seconds: 4),
            title: const Text('Registrasi Berhasil!'),
            description: Text(
              response.message ?? 'Akun berhasil dibuat, silakan masuk.',
            ),
            icon: const Icon(Icons.check_circle_outline, color: Colors.green),
          );

          // Otomatis beralih ke form login dan pertahankan nilai email serta password
          widget.onSwitchToLogin?.call();
        },
        error: (error, _) {
          showFToast(
            context: context,
            duration: const Duration(seconds: 4),
            title: const Text('Registrasi Gagal'),
            description: Text(error.toString()),
            icon: const Icon(Icons.error_outline, color: Colors.red),
          );
        },
      );
    });

    ref.listen(loginUserProvider, (previous, next) {
      next.whenOrNull(
        data: (response) async {
          if (response == null) return;
          showFToast(
            context: context,
            duration: const Duration(seconds: 4),
            title: const Text('Login Berhasil!'),
            description: Text(response.message ?? 'Langsung terbang ke home'),
            icon: const Icon(Icons.check_circle_outline, color: Colors.green),
          );

          await LoginPreferences.saveLoginResponse(response);

          ref.invalidate(userNameRiverpod);
          ref.invalidate(historyAbsenProvider);

          if (context.mounted) {
            HomeRoute().go(context);
          }
        },
        error: (error, _) {
          showFToast(
            context: context,
            duration: const Duration(seconds: 4),
            title: const Text('Login Gagal'),
            description: Text(error.toString()),
            icon: const Icon(Icons.error_outline, color: Colors.red),
          );
        },
      );
    });

    final registerState = ref.watch(registerUserProvider);
    final loginState = ref.watch(loginUserProvider);
    final isLoading = widget.isRegister
        ? registerState.isLoading
        : loginState.isLoading;

    return FormBuilder(
      key: _key,
      child: Column(
        children: [
          Column(
            spacing: 10,
            children: [
              if (widget.isRegister)
                FormBuilderField<String>(
                  key: const ValueKey('field_nama'),
                  name: 'nama',
                  initialValue: _nameController.text,
                  valueTransformer: (text) =>
                      text?.trim().replaceAll(RegExp(r'\s+'), ' '),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(
                      errorText: 'Nama wajib diisi',
                    ),
                    FormBuilderValidators.minLength(
                      3,
                      errorText: 'Minimal 3 karakter',
                    ),
                    FormBuilderValidators.alphabetical(
                      regex: RegExp(r'^[a-zA-Z ]+$'),
                      errorText: 'Hanya boleh huruf alfabet',
                    ),
                  ]),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  builder: (FormFieldState<String> field) {
                    return FTextFormField(
                      label: const Text('Nama'),
                      hint: 'misal : Gibrun',
                      control: FTextFieldControl.managed(
                        controller: _nameController,
                        onChange: (value) => field.didChange(value.text),
                      ),
                      forceErrorText: field.errorText,
                    );
                  },
                ),
              FormBuilderField<String>(
                key: const ValueKey('field_email'),
                name: 'email',
                initialValue: _emailController.text,
                valueTransformer: (text) =>
                    text?.trim().replaceAll(RegExp(r'\s+'), ' '),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(
                    errorText: 'Email wajib diisi',
                  ),
                  FormBuilderValidators.email(
                    errorText: 'Yang bener donk ngisi emailnya 🤬',
                  ),
                ]),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                builder: (FormFieldState<String> field) {
                  return FTextFormField.email(
                    label: const Text('Email'),
                    hint: 'misal : manager@kopdes.go.id',
                    control: FTextFieldControl.managed(
                      controller: _emailController,
                      onChange: (value) => field.didChange(value.text),
                    ),
                    forceErrorText: field.errorText,
                  );
                },
              ),
              FormBuilderField<String>(
                key: const ValueKey('field_password'),
                name: 'password',
                initialValue: _passwordController.text,
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(
                    errorText: "Isi donk passwordnya 😡",
                  ),
                  FormBuilderValidators.minLength(
                    8,
                    errorText: 'minimal 8 karakter 😤',
                  ),
                  FormBuilderValidators.hasLowercaseChars(
                    atLeast: 1,
                    errorText: 'minimal ada 1 huruf kecil 😤',
                  ),
                  FormBuilderValidators.hasNumericChars(
                    atLeast: 1,
                    errorText: 'minimal ada 1 angka 😤',
                  ),
                  FormBuilderValidators.hasSpecialChars(
                    atLeast: 1,
                    errorText: 'minimal ada 1 simbol 😤',
                  ),
                  FormBuilderValidators.hasUppercaseChars(
                    atLeast: 1,
                    errorText: 'minimal ada 1 huruf besar 😤',
                  ),
                ]),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                builder: (FormFieldState<String> field) {
                  return FTextFormField.password(
                    label: const Text('Password'),
                    hint: 'isi password',
                    control: FTextFieldControl.managed(
                      controller: _passwordController,
                      onChange: (value) => field.didChange(value.text),
                    ),
                    forceErrorText: field.errorText,
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: FButton(
              size: .sm,
              mainAxisSize: .min,
              onPress: isLoading
                  ? null
                  : () {
                      if (_key.currentState?.saveAndValidate() ?? false) {
                        final email = _emailController.text.trim();
                        final password = _passwordController.text.trim();

                        if (widget.isRegister) {
                          final name = _nameController.text.trim();
                          final signUpRequest = RegisterRequestModel(
                            name: name,
                            email: email,
                            password: password,
                          );

                          ref
                              .read(registerUserProvider.notifier)
                              .register(signUpRequest);
                        } else {
                          final loginRequest = LoginRequestModel(
                            email: email,
                            password: password,
                          );

                          developer.log(
                            'Submitting login: ${loginRequest.email}',
                          );

                          ref
                              .read(loginUserProvider.notifier)
                              .login(loginRequest);
                        }
                      }
                    },
              child: Text(widget.isRegister ? 'Daftar' : 'Masuk'),
            ),
          ),
        ],
      ),
    );
  }
}
