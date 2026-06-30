# BadWallet App

Application mobile Flutter Android pour la gestion d’un portefeuille numérique, conforme au sujet de projet.

## Fonctionnalités principales
- Écran de splash et onboarding simulé
- Saisie du numéro de téléphone
- Tableau de bord avec solde visible/masquable
- Transfert d’argent avec pavé numérique personnalisé
- Paiement de factures avec sélection multiple
- Historique des transactions avec détail
- Sécurisation locale via PIN à 4 chiffres
- Consommation des endpoints API BadWallet via HTTP

## Stack technique
- Flutter
- Dart
- Provider
- HTTP
- Flutter Secure Storage
- Intl
- Google Fonts

## Pré-requis
- Flutter SDK installé
- Android SDK configuré
- Backend BadWallet API disponible sur l’adresse configurée

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

## Notes importantes
- Pour un émulateur Android, l’URL du backend doit utiliser l’adresse adaptée à votre environnement.
- Pour un appareil physique, il est recommandé d’utiliser l’adresse IP de votre machine hôte au lieu de localhost.
