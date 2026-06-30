import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../auth/providers/auth_provider.dart';
import '../providers/transaction_provider.dart';
import '../widgets/transaction_tile.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
  }

  Future<void> _loadData() async {
    final phone = context.read<AuthProvider>().phone;
    if (phone == null || phone.isEmpty) return;
    await context.read<TransactionProvider>().fetchTransactions(phone);
  }

  @override
  Widget build(BuildContext context) {
    final txProvider = context.watch<TransactionProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Historique des transactions')),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadData,
          child: Builder(
            builder: (_) {
              if (txProvider.state.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (txProvider.state.isError) {
                return Center(
                  child: Text(txProvider.state.errorMessage ?? 'Erreur de chargement'),
                );
              }

              final transactions = txProvider.state.data ?? [];
              if (transactions.isEmpty) {
                return const Center(child: Text('Aucune transaction enregistrée'));
              }

              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: transactions.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  return TransactionTile(transaction: transactions[index]);
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
