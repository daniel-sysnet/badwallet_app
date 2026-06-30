import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../auth/providers/auth_provider.dart';
import '../../dashboard/providers/wallet_provider.dart';
import '../../history/providers/transaction_provider.dart';
import '../providers/transfer_provider.dart';

class TransferScreen extends StatefulWidget {
  const TransferScreen({super.key});

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  final _formKey = GlobalKey<FormState>();
  final _recipientController = TextEditingController();
  final _amountController = TextEditingController();
  String _amountValue = '0';

  @override
  void dispose() {
    _recipientController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _appendDigit(String digit) {
    setState(() {
      if (_amountValue == '0') {
        _amountValue = digit;
      } else {
        _amountValue += digit;
      }
      _amountController.text = _amountValue;
    });
  }

  void _removeDigit() {
    setState(() {
      if (_amountValue.length <= 1) {
        _amountValue = '0';
      } else {
        _amountValue = _amountValue.substring(0, _amountValue.length - 1);
      }
      _amountController.text = _amountValue;
    });
  }

  Future<void> _confirmTransfer() async {
    if (!_formKey.currentState!.validate()) return;
    final amount =
        double.tryParse(_amountController.text.replaceAll(' ', '')) ?? 0;
    if (amount <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Montant invalide')));
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer le transfert'),
        content: Text(
          'Envoyer ${NumberFormat.decimalPattern('fr_FR').format(amount)} XOF au ${_recipientController.text.trim()} ?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Confirmer'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _submit();
    }
  }

  Future<void> _submit() async {
    final auth = context.read<AuthProvider>();
    final phone = auth.phone;
    if (phone == null || phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez renseigner votre numéro de téléphone'),
        ),
      );
      return;
    }

    final amount =
        double.tryParse(_amountController.text.replaceAll(' ', '')) ?? 0;
    final walletProvider = context.read<WalletProvider>();
    final transactionProvider = context.read<TransactionProvider>();
    final success = await context.read<TransferProvider>().sendTransfer(
      phone: phone,
      recipient: _recipientController.text.trim(),
      amount: amount,
    );

    if (!mounted) return;

    if (success) {
      if (phone.isNotEmpty) {
        await walletProvider.fetchBalance(phone);
        await transactionProvider.fetchTransactions(phone);
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Transfert envoyé avec succès')),
      );
      Navigator.of(context).pop();
    } else {
      final provider = context.read<TransferProvider>();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.state.errorMessage ?? 'Échec du transfert'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Transfert d’argent')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Envoyer de l’argent',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Saisissez le destinataire et utilisez le pavé numérique ci-dessous.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _recipientController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Numéro du destinataire',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().length < 8) {
                      return 'Veuillez saisir un numéro valide';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _amountController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Montant',
                    prefixText: 'XOF ',
                    hintText: '0',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty || value == '0') {
                      return 'Veuillez saisir un montant';
                    }
                    final amount = double.tryParse(value.replaceAll(' ', ''));
                    if (amount == null || amount <= 0) {
                      return 'Montant invalide';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 3,
                  childAspectRatio: 1.4,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  children: [
                    for (final digit in [
                      '1',
                      '2',
                      '3',
                      '4',
                      '5',
                      '6',
                      '7',
                      '8',
                      '9',
                    ])
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                        ),
                        onPressed: () => _appendDigit(digit),
                        child: Text(
                          digit,
                          style: const TextStyle(
                            fontSize: 18,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    OutlinedButton(
                      onPressed: _removeDigit,
                      child: const Icon(Icons.backspace_outlined),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                      onPressed: () => _appendDigit('0'),
                      child: const Text(
                        '0',
                        style: TextStyle(
                          fontSize: 18,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox.shrink(),
                  ],
                ),
                const SizedBox(height: 20),
                Consumer<TransferProvider>(
                  builder: (context, provider, _) {
                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: provider.state.isLoading
                            ? null
                            : _confirmTransfer,
                        icon: const Icon(Icons.send_rounded),
                        label: provider.state.isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text('Valider le transfert'),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                if (context.watch<TransferProvider>().state.isError)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.danger.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      context.watch<TransferProvider>().state.errorMessage ??
                          'Erreur',
                      style: const TextStyle(color: AppColors.danger),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
