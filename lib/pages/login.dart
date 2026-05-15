import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_finance_web/pages/forgot_password.dart';
import 'package:flutter_finance_web/pages/home.dart';
import 'package:flutter_finance_web/pages/register.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import '../components/_commons/custom_input.dart';
import '../components/_commons/custom_button.dart';
import 'package:flutter_finance_web/providers/auth_write_provider.dart';

class LoginPage extends ConsumerWidget {
  final _formKey = GlobalKey<FormBuilderState>();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    final authController = ref.read(authControllerProvider.notifier);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: SingleChildScrollView(
            child: FormBuilder(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo ou Ícone do App
                  const Icon(
                    Icons.account_balance_wallet,
                    size: 80,
                    color: Colors.blueAccent,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Finanças App",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Gerencie seu dinheiro com inteligência",
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 40),

                  // Campos de Entrada
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

                  // Esqueci minha senha
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ForgotPasswordPage(),
                          ),
                        );
                      },
                      child: const Text("Esqueceu a senha?"),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Ações
                  CustomButton(
                    text: authState.isLoading ? "Entrando..." : "Entrar",
                    onPressed: authState.isLoading
                        ? null // Desabilita o botão enquanto a API responde
                        : () async {
                            if (_formKey.currentState?.saveAndValidate() ??
                                false) {
                              final formData = _formKey.currentState!.value;

                              try {
                                final result = await authController.login(
                                  formData['email'] as String,
                                  formData['password'] as String,
                                );
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const HomePage(),
                                  ),
                                );
                              } on DioException catch (e) {
                                String errorMessage =
                                    "Erro ao conectar ao servidor";
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
                                // Captura qualquer outro erro inesperado
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Ocorreu um erro inesperado"),
                                  ),
                                );
                              }
                            }
                          },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Não tem uma conta?"),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegisterPage(),
                            ),
                          );
                        },
                        child: const Text(
                          "Cadastre-se",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
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
