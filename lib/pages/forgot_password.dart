import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_finance_web/providers/auth_write_provider.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../components/_commons/custom_input.dart';
import '../components/_commons/custom_button.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class ForgotPasswordPage extends ConsumerWidget {
  final _formKey = GlobalKey<FormBuilderState>();

  ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);

    Future<void> handleForgotPassword(
      BuildContext context,
      WidgetRef ref,
    ) async {
      if (_formKey.currentState?.saveAndValidate() ?? false) {
        final formData = _formKey.currentState!.value;
        final email = formData['email'] as String;

        // Chamamos o controller (escrita)
        await ref.read(authControllerProvider.notifier).recoverPassword(email);

        // Verificamos o estado após a execução
        final state = ref.read(authControllerProvider);

        if (state.hasError) {
          // Se deu erro (ex: e-mail não encontrado)
          String errorMsg = state.error.toString();
          if (state.error is DioException) {
            errorMsg =
                (state.error as DioException).response?.data['message'] ??
                errorMsg;
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMsg), backgroundColor: Colors.red),
          );
        } else {
          // Se deu certo
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Instruções enviadas com sucesso!"),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: FormBuilder(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.lock_reset, size: 80, color: Colors.blueAccent),
              const SizedBox(height: 24),
              const Text(
                "Recuperar Senha",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                "Digite seu e-mail cadastrado para receber as instruções de recuperação.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 40),

              CustomInput(
                name: 'email',
                label: "E-mail",
                icon: Icons.email_outlined,
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(
                    errorText: "E-mail obrigatório",
                  ),
                  FormBuilderValidators.email(errorText: "E-mail inválido"),
                ]),
              ),

              const SizedBox(height: 32),

              CustomButton(
                text: authState.isLoading ? "Enviando..." : "Enviar Instruções",
                onPressed: authState.isLoading
                    ? null
                    : () {
                        handleForgotPassword(context, ref);
                      },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
