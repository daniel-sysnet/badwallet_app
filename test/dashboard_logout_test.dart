import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:badwallet_app/features/auth/providers/auth_provider.dart';
import 'package:badwallet_app/features/dashboard/providers/wallet_provider.dart';
import 'package:badwallet_app/features/dashboard/screens/dashboard_screen.dart';
import 'package:badwallet_app/features/history/providers/transaction_provider.dart';

void main() {
  testWidgets('dashboard shows logout action', (tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          ChangeNotifierProvider(create: (_) => WalletProvider()),
          ChangeNotifierProvider(create: (_) => TransactionProvider()),
        ],
        child: const MaterialApp(home: DashboardScreen()),
      ),
    );

    await tester.pump();

    expect(find.byTooltip('Se déconnecter'), findsOneWidget);
  });
}
