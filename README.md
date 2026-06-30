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
- Déconnexion rapide pour basculer entre comptes de test
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

## Comptes de test
Le backend de démonstration est prérempli avec deux portefeuilles de test :
- Compte 1 : +221770000001 / PIN 1234 / solde initial 100000 XOF
- Compte 2 : +221770000002 / PIN 1234 / solde initial 100000 XOF

Ces comptes peuvent servir à tester :
- un paiement de facture depuis le compte 1
- un transfert du compte 1 vers le compte 2
- la déconnexion et la reconnexion avec un autre numéro

## Démonstration rapide
1. Lancer le backend BadWallet et l’application Flutter.
2. Se connecter avec le numéro +221770000001.
3. Saisir le PIN 1234.
4. Effectuer un paiement de facture ou un transfert vers +221770000002.
5. Utiliser le bouton de déconnexion pour revenir à l’écran de connexion et vérifier qu’un autre compte peut être utilisé.

## Notes importantes
- Pour un émulateur Android, l’URL du backend doit utiliser l’adresse adaptée à votre environnement.
- Pour un appareil physique, il est recommandé d’utiliser l’adresse IP de votre machine hôte au lieu de localhost.
- Si le backend a été relancé, les données de test peuvent être rechargées via les endpoints de seed du projet backend.
