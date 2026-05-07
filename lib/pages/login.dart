import 'package:flutter/material.dart';
import 'package:flutter_finance_web/components/CustomInput.dart';
import 'package:flutter_finance_web/components/CustomButton.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: SingleChildScrollView(
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
                const CustomInput(label: "E-mail", icon: Icons.email_outlined),
                const SizedBox(height: 16),
                const CustomInput(
                  label: "Senha",
                  icon: Icons.lock_outline,
                  isPassword: true,
                ),

                // Esqueci minha senha
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text("Esqueceu a senha?"),
                  ),
                ),
                const SizedBox(height: 24),

                // Ações
                CustomButton(
                  text: "Entrar",
                  onPressed: () {
                    // Lógica de autenticação
                    print('Entrei');
                  },
                ),
                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Não tem uma conta?"),
                    TextButton(
                      onPressed: () {
                        print('Criar conta');
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
    );
  }
}
