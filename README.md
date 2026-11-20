# CV Flutter — Regis MUNYAKATUNZI

Portfolio et CV personnel réalisés avec Flutter. L’interface adopte une
présentation professionnelle et épurée, avec une palette bleu marine, des
accents bleu-vert, une typographie lisible et des cartes à la mise en page
soignée. Aucune photo personnelle n’est utilisée.

## Présentation

Regis MUNYAKATUNZI est présenté comme étudiant en informatique et développeur
Flutter en devenir à Goma, en République démocratique du Congo. Le portfolio
regroupe son profil, sa formation, ses projets, ses compétences, ses langues,
ses centres d’intérêt, une présentation de sa famille et ses coordonnées.

Les détails de parcours, les membres de la famille et les coordonnées de
démonstration sont à vérifier et à personnaliser avant diffusion.

## Fonctionnalités

- Connexion de démonstration avec validation des champs.
- Page **Mon CV** : profil, formation, projets, compétences, langues et intérêts.
- Page **Ma famille** : cartes sans photos, avec initiales et noms d’exemple
  portant le nom **MUNYAKATUNZI**.
- Page **Contact** : actions pour téléphoner, envoyer un e-mail, copier
  l’adresse et consulter les réseaux sociaux.
- Menu latéral et barre de navigation.
- Mise en page responsive pour les différentes tailles d’écran.

### Identifiants de démonstration

| Champ | Valeur |
|---|---|
| Identifiant | `amini` |
| Mot de passe | `ben2026` |

Ces identifiants sont codés dans l’application à des fins de démonstration.
Cette connexion ne constitue pas un système d’authentification sécurisé.

## Technologies

- Flutter et Dart
- Material 3
- [`url_launcher`](https://pub.dev/packages/url_launcher)
- `flutter_test`

Le projet inclut des configurations pour Android, iOS, le Web, Windows, macOS
et Linux. La compilation de chaque cible nécessite les outils correspondants.

## Prérequis et lancement

Installez Flutter, puis vérifiez l’environnement avec `flutter doctor`. Depuis
la racine du projet :

```bash
flutter pub get
flutter run
```

Pour lancer la version Web dans Chrome :

```bash
flutter devices
flutter run -d chrome
```

## Tests

```bash
flutter test
flutter analyze
```

Le test d’interface couvre la connexion de démonstration et la navigation entre
les pages principales.

## Structure

```text
.
├── lib/main.dart       # Écrans et composants Flutter
├── test/               # Tests d’interface
├── assets/             # Ressources de l’application
├── android/            # Cible Android
├── ios/                # Cible iOS
├── linux/              # Cible Linux
├── macos/              # Cible macOS
├── web/                # Cible Web
├── windows/            # Cible Windows
├── pubspec.yaml        # Dépendances et métadonnées
└── pubspec.lock        # Versions résolues des dépendances
```
