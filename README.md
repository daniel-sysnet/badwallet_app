# BadWallet App

Application mobile Flutter compatible Android pour la gestion de portefeuille, conforme au sujet de projet.

## Fonctionnalités implémentées
- Écran de splash avec onboarding simulé
- Saisie du numéro de téléphone
- Tableau de bord avec solde et visibilité du solde
- Transfert d’argent
- Paiement de factures
- Historique des transactions
- Consommation des endpoints API via HTTP

## Stack technique
- Flutter
- Dart
- Provider
- HTTP
- Flutter Secure Storage
- Intl

## Lancer l’application
```bash
flutter pub get
flutter run
```

## Générer l’APK de release
```bash
flutter build apk --release
```

Le fichier sera généré dans :
```bash
build/app/outputs/flutter-apk/app-release.apk
```
