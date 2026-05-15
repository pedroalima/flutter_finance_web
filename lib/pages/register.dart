import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_finance_web/providers/api_provider.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import '../components/_commons/custom_button.dart';
import '../components/_commons/custom_input.dart';

class RegisterPage extends ConsumerWidget {
  final _formKey = GlobalKey<FormBuilderState>();

  RegisterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authService = ref.watch(authServiceProvider);

    return Scaffold(
      // Botão de voltar automático no AppBar
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: SingleChildScrollView(
            child: FormBuilder(
              key: _formKey,
              child: Column(
                children: [
                  const Text(
                    "Nova Conta",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Cadastre-se para começar a organizar suas finanças",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 40),

                  // Campos reutilizando seus componentes
                  CustomInput(
                    name: 'name',
                    label: "Nome Completo",
                    icon: Icons.person_outline,
                    validator: FormBuilderValidators.required(),
                  ),
                  const SizedBox(height: 16),

                  CustomInput(
                    name: 'email',
                    label: "E-mail",
                    icon: Icons.email_outlined,
                    validator: FormBuilderValidators.email(),
                  ),
                  const SizedBox(height: 16),

                  CustomInput(
                    name: 'password',
                    label: "Senha",
                    icon: Icons.lock_outline,
                    isPassword: true,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      FormBuilderValidators.minLength(8),
                    ]),
                  ),
                  const SizedBox(height: 32),

                  CustomButton(
                    text: "Criar Conta",
                    onPressed: () async {
                      if (_formKey.currentState!.saveAndValidate() ?? false) {
                        final formData = _formKey.currentState!.value;
                        try {
                          final result = await authService.register(
                            formData['name'] as String,
                            formData['email'] as String,
                            formData['password'] as String,
                          );

                          if (result != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Usuário cadastrado com sucesso!",
                                ),
                              ),
                            );
                            Navigator.pop(
                              context,
                            ); // Volta para a tela de Login
                          }
                        } on DioException catch (e) {
                          String errorMessage =
                              "Falha ao cadastrar. Verifique os dados.";

                          if (e.response?.data != null &&
                              e.response?.data['message'] != null) {
                            errorMessage = e.response?.data['message'];
                          }

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(errorMessage),
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                        } catch (e) {
                          // Erros genéricos (fora do Dio)
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Ocorreu um erro inesperado."),
                            ),
                          );
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
