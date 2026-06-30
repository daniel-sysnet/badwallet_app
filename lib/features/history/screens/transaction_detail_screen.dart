import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/transaction.dart';

class TransactionDetailScreen extends StatelessWidget {
  final AppTransaction transaction;

  const TransactionDetailScreen({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final isOut = transaction.isOutgoing;
    final color = isOut ? AppColors.danger : AppColors.success;
    final currencyFmt = NumberFormat.decimalPattern('fr_FR');

    return Scaffold(
      appBar: AppBar(title: const Text('Détail de la transaction')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction.label ?? 'Transaction',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${isOut ? '-' : '+'}${currencyFmt.format(transaction.amount)} XOF',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: color,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _InfoRow(label: 'Type', value: transaction.type.name),
              _InfoRow(
                label: 'Partenaire',
                value: transaction.counterparty ?? 'N/A',
              ),
              _InfoRow(
                label: 'Date',
                value: DateFormat('dd/MM/yyyy HH:mm').format(transaction.date),
              ),
              _InfoRow(
                label: 'Montant',
                value: '${currencyFmt.format(transaction.amount)} XOF',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
