import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_finance_web/providers/auth_provider.dart';
import 'package:flutter_finance_web/providers/transaction_provider.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  bool _showBalance = true;

  @override
  Widget build(BuildContext context) {
    final userData = ref.watch(fetchUserProvider);
    final transactionsData = ref.watch(getTransactionsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // Fundo acinzentado suave
      body: Column(
        children: [
          // 1. Cabeçalho com Saldo
          _buildHeader(userData),

          // 2. Título da Listagem
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Transações recentes",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(onPressed: () {}, child: const Text("Ver todas")),
              ],
            ),
          ),

          Expanded(
            child: transactionsData.when(
              data: (transactions) {
                if (transactions.isEmpty) {
                  return const Center(
                    child: Text("Nenhuma transação encontrada."),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    final transaction = transactions[index];
                    return _buildTransactionItem(transaction);
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) =>
                  Center(child: Text("Erro ao carregar transações: $err")),
            ),
          ),
        ],
      ),

      // Botão Flutuante para Nova Transação
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  // Widget do Cabeçalho
  Widget _buildHeader(AsyncValue<Map<String, dynamic>> userData) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 60, bottom: 30, left: 24, right: 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blueAccent, Color(0xFF1A237E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    // pegar apenas o primeiro nome
                    "Olá, ${userData.value?['name']?.split(' ').first ?? "Usuário"}!",
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  Text(
                    "Bem-vindo de volta",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.logout, color: Colors.white),
                onPressed: () => Navigator.pushReplacementNamed(context, '/'),
              ),
            ],
          ),
          const SizedBox(height: 32),

          const Text(
            "Saldo disponível",
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),

          Row(
            children: [
              userData.when(
                data: (user) {
                  final balance = user['balance'] ?? 0.0;
                  return Text(
                    _showBalance
                        ? "R\$ ${balance.toStringAsFixed(2)}"
                        : "R\$ ••••••",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
                loading: () => const Text(
                  "...",
                  style: TextStyle(color: Colors.white, fontSize: 32),
                ),
                error: (err, _) =>
                    const Text("Erro", style: TextStyle(color: Colors.white)),
              ),
              IconButton(
                icon: Icon(
                  _showBalance ? Icons.visibility_off : Icons.visibility,
                  color: Colors.white54,
                ),
                onPressed: () => setState(() => _showBalance = !_showBalance),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Widget de cada item da lista
  Widget _buildTransactionItem(Map<String, dynamic> transaction) {
    // 1. Identifica se é entrada ou saída baseado no type_id (do seu banco)
    final bool isIncome = transaction['type_id'] == 1;
    final color = isIncome ? Colors.green : Colors.red;
    final icon = isIncome ? Icons.arrow_upward : Icons.shopping_bag_outlined;

    // 2. Formata o valor
    final double amount =
        double.tryParse(transaction['amount'].toString()) ?? 0.0;
    final String prefix = isIncome ? "+ R\$ " : "- R\$ ";

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction['description'] ?? "Sem descrição",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  // Ideal usar o pacote 'intl' para formatar a data transaction['date']
                  transaction['date'] ?? "",
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          Text(
            "$prefix${amount.toStringAsFixed(2)}",
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
