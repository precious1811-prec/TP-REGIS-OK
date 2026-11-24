# CV Flutter — Regis MUNYAKATUNZI

Application Flutter de présentation du CV et de gestion des membres de la
famille. L’authentification et les opérations sur les membres communiquent avec
l’API REST PHP/MySQL du TP : les membres ne sont pas conservés uniquement dans
l’application.

## Fonctionnalités

- Création de compte et connexion avec vérification par l’API.
- Accès au portfolio après authentification.
- Consultation, ajout, modification et suppression des membres via l’API.
- Actualisation de la liste des membres depuis la base de données.
- Présentation du CV et des coordonnées, avec navigation responsive.

Les routes de comptes et de membres utilisées par l’application sont décrites
dans le [README de l’API](https://github.com/espoirbaraka/api-test). Selon ce
README, les routes de membres ne vérifient pas de jeton : l’écran de connexion
de l’application contrôle l’accès à l’interface, mais l’API doit être protégée
séparément si elle est exposée au-delà d’un environnement de TP.

## Démonstration vidéo

<video controls width="100%" src="https://raw.githubusercontent.com/precious1811-prec/TP-REGIS-OK/main/demo/TP2-demonstration.mp4">
  Votre navigateur ne prend pas en charge la lecture vidéo.
</video>

[Ouvrir ou télécharger la vidéo de démonstration](demo/TP2-demonstration.mp4)

## API et configuration

L’API fournie utilise PHP, Apache et MySQL. Suivez son [guide d’installation](https://github.com/espoirbaraka/api-test#installation)
pour importer `api.sql`, configurer `.env` et démarrer les services. L’URL
requise inclut le segment `/public`.

Par défaut, l’application utilise `http://10.0.2.2/api-test/public`, adresse
permettant à un émulateur Android d’atteindre le `localhost` de l’ordinateur.
Pour une autre cible, passez l’adresse de votre serveur avec `API_BASE_URL` :

```bash
# Android Emulator
flutter run --dart-define=API_BASE_URL=http://10.0.2.2/api-test/public

# Navigateur ou Windows
flutter run --dart-define=API_BASE_URL=http://localhost/api-test/public
```

Sur un téléphone physique, remplacez `localhost` par l’adresse IP locale de
l’ordinateur hébergeant XAMPP, par exemple
`http://192.168.1.20/api-test/public`. Vérifiez que le téléphone et l’ordinateur
sont sur le même réseau et que le pare-feu autorise Apache. Sur iOS, utilisez
une URL HTTPS accessible à l’appareil : iOS peut refuser les connexions HTTP
non chiffrées.

L’application ne contient pas de compte de démonstration précréé : créez un
compte depuis l’écran d’accueil, puis connectez-vous avec les mêmes identifiants.
L’API stocke les comptes dans sa base de données et chiffre les mots de passe
côté serveur.

## Installation et lancement

Prérequis : Flutter/Dart compatibles avec `pubspec.yaml`, ainsi que l’API
démarrée pour tester la connexion et les données de famille.

```bash
flutter pub get
flutter run --dart-define=API_BASE_URL=http://10.0.2.2/api-test/public
```

Pour le Web, ajoutez l’URL de l’API appropriée. L’API fournie autorise CORS pour
ses endpoints.

## Vérification

```bash
flutter analyze
flutter test
```

Les tests couvrent les appels HTTP d’authentification et du CRUD famille, ainsi
que le parcours d’inscription/connexion et l’accès à la page famille.

## Technologies

- Flutter et Dart
- API REST PHP/MySQL : [`espoirbaraka/api-test`](https://github.com/espoirbaraka/api-test)
- [`http`](https://pub.dev/packages/http) pour les appels REST
- [`url_launcher`](https://pub.dev/packages/url_launcher) pour les coordonnées
- `flutter_test`

## Structure

```text
.
├── lib/
│   ├── api_client.dart   # Modèles et client REST
│   └── main.dart         # Écrans Flutter et gestion famille
├── test/                 # Tests widget et API
├── android/              # Cible Android
├── ios/                  # Cible iOS
├── web/                  # Cible Web
├── windows/               # Cible Windows
├── pubspec.yaml          # Dépendances Flutter
└── pubspec.lock          # Versions résolues des dépendances
```
