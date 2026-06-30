import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../auth/providers/auth_provider.dart';
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

  @override
  void dispose() {
    _recipientController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final auth = context.read<AuthProvider>();
    final phone = auth.phone;
    if (phone == null || phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez renseigner votre numéro de téléphone')),
      );
      return;
    }

    final amount = double.tryParse(_amountController.text.replaceAll(' ', '')) ?? 0;
    final success = await context.read<TransferProvider>().sendTransfer(
      phone: phone,
      recipient: _recipientController.text.trim(),
      amount: amount,
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Transfert envoyé avec succès')),
      );
      Navigator.of(context).pop();
    } else {
      final provider = context.read<TransferProvider>();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(provider.state.errorMessage ?? 'Échec du transfert')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Transfert d’argent')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Envoyer de l’argent', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                Text(
                  'Saisissez le numéro du destinataire et le montant.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _recipientController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(labelText: 'Numéro du destinataire'),
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
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Montant'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Veuillez saisir un montant';
                    }
                    final amount = double.tryParse(value.replaceAll(' ', ''));
                    if (amount == null || amount <= 0) {
                      return 'Montant invalide';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                Consumer<TransferProvider>(
                  builder: (context, provider, _) {
                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: provider.state.isLoading ? null : _submit,
                        child: provider.state.isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
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
                      context.watch<TransferProvider>().state.errorMessage ?? 'Erreur',
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
