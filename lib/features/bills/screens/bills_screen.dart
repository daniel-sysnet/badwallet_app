import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../auth/providers/auth_provider.dart';
import '../providers/bills_provider.dart';

class BillsScreen extends StatefulWidget {
  const BillsScreen({super.key});

  @override
  State<BillsScreen> createState() => _BillsScreenState();
}

class _BillsScreenState extends State<BillsScreen> {
  final List<String> _providers = ['ISM', 'WOYAFAL', 'RAPIDO', 'SENELEC'];
  String _selectedProvider = 'ISM';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Paiement de factures')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Choisissez un fournisseur',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                children: _providers.map((provider) {
                  final selected = provider == _selectedProvider;
                  return FilterChip(
                    label: Text(provider),
                    selected: selected,
                    onSelected: (_) {
                      setState(() => _selectedProvider = provider);
                      context.read<BillsProvider>().fetchFactures(provider);
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => context.read<BillsProvider>().fetchFactures(
                    _selectedProvider,
                  ),
                  child: const Text('Charger les factures'),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(child: _BillsList()),
            ],
          ),
        ),
      ),
    );
  }
}

class _BillsList extends StatefulWidget {
  @override
  State<_BillsList> createState() => _BillsListState();
}

class _BillsListState extends State<_BillsList> {
  final Set<String> _selectedIds = <String>{};

  Future<void> _paySelected() async {
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

    final provider = context.read<BillsProvider>();
    final selected = provider.factures
        .where((facture) => _selectedIds.contains(facture.id))
        .toList();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer le paiement'),
        content: Text(
          'Payer ${selected.length} facture(s) pour un montant total de ${selected.fold<double>(0, (sum, item) => sum + item.montant).toStringAsFixed(0)} XOF ?',
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

    if (confirmed != true) return;

    final success = await provider.payFactures(
      phone: phone,
      selected: selected,
    );

    if (!mounted) return;
    if (success) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Paiement effectué')));
      _selectedIds.clear();
      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.state.errorMessage ?? 'Le paiement a échoué'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BillsProvider>();

    if (provider.state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.state.isError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Text(
            provider.state.errorMessage ?? 'Erreur de chargement',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    if (provider.factures.isEmpty) {
      return const Center(
        child: Text(
          'Aucune facture à afficher pour le moment. Sélectionnez un fournisseur et rechargez les données.',
        ),
      );
    }

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: provider.factures.length,
            itemBuilder: (context, index) {
              final facture = provider.factures[index];
              final selected = _selectedIds.contains(facture.id);
              return Card(
                child: CheckboxListTile(
                  value: selected,
                  title: Text('${facture.fournisseur} - ${facture.reference}'),
                  subtitle: Text(
                    '${facture.montant.toStringAsFixed(0)} XOF • Échéance ${facture.echeance.day}/${facture.echeance.month}',
                  ),
                  onChanged: (_) {
                    setState(() {
                      if (selected) {
                        _selectedIds.remove(facture.id);
                      } else {
                        _selectedIds.add(facture.id);
                      }
                    });
                  },
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _selectedIds.isEmpty ? null : _paySelected,
            icon: const Icon(Icons.payment_rounded),
            label: const Text('Payer les factures sélectionnées'),
          ),
        ),
      ],
    );
  }
}
