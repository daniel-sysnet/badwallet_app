import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../auth/providers/auth_provider.dart';
import '../providers/wallet_provider.dart';
import '../../history/providers/transaction_provider.dart';
import '../../history/widgets/transaction_tile.dart';
import '../../transfers/screens/transfer_screen.dart';
import '../../bills/screens/bills_screen.dart';
import '../../history/screens/history_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
  }

  void _loadData() {
    final phone = context.read<AuthProvider>().phone;
    if (phone == null) return;
    context.read<WalletProvider>().fetchBalance(phone);
    context.read<TransactionProvider>().fetchTransactions(phone);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async => _loadData(),
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text('Bonjour 👋', style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 4),
              Text('Mon Portefeuille', style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 24),
              _BalanceCard(),
              const SizedBox(height: 24),
              _QuickActions(),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Transactions récentes', style: Theme.of(context).textTheme.titleLarge),
                  TextButton(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const HistoryScreen()),
                    ),
                    child: const Text('Tout voir'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _RecentTransactions(),
            ],
          ),
        ),
      ),
    );
  }
}

class _BalanceCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final wallet = context.watch<WalletProvider>();
    final currencyFmt = NumberFormat.decimalPattern('fr_FR');

    return Card(
      color: AppColors.primary,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Solde disponible', style: TextStyle(color: Colors.white70)),
                IconButton(
                  onPressed: wallet.toggleBalanceVisibility,
                  icon: Icon(
                    wallet.balanceVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Builder(builder: (context) {
              if (wallet.state.isLoading) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                  ),
                );
              }
              if (wallet.state.isError) {
                return Text(
                  wallet.state.errorMessage ?? 'Erreur de chargement',
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                );
              }
              final balance = wallet.state.data?.balance ?? 0;
              return Text(
                wallet.balanceVisible ? '${currencyFmt.format(balance)} XOF' : '••••••',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _ActionButton(
          icon: Icons.send_rounded,
          label: 'Transférer',
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const TransferScreen()),
          ),
        ),
        const SizedBox(width: 12),
        _ActionButton(
          icon: Icons.receipt_long_rounded,
          label: 'Payer',
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const BillsScreen()),
          ),
        ),
        const SizedBox(width: 12),
        _ActionButton(
          icon: Icons.history_rounded,
          label: 'Historique',
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const HistoryScreen()),
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _ActionButton({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: [
              Icon(icon, color: AppColors.primary),
              const SizedBox(height: 6),
              Text(label, style: const TextStyle(fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecentTransactions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final txProvider = context.watch<TransactionProvider>();

    if (txProvider.state.isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (txProvider.state.isError) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: Text(
            txProvider.state.errorMessage ?? 'Erreur de chargement',
            style: const TextStyle(color: AppColors.textSecondary),
          ),
        ),
      );
    }
    final items = txProvider.last5;
    if (items.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(child: Text('Aucune transaction pour le moment')),
      );
    }
    return Column(
      children: items.map((t) => TransactionTile(transaction: t)).toList(),
    );
  }
}