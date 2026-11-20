import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

const _ink = Color(0xFF1D2939);
const _muted = Color(0xFF667085);
const _blue = Color(0xFF2457A7);
const _violet = Color(0xFF147D75);
const _demoUsername = 'amini';
const _demoPassword = 'ben2026';

void main() {
  runApp(const CvApp());
}

class CvApp extends StatelessWidget {
  const CvApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CV Regis MUNYAKATUNZI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _blue,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF4F6F9),
        textTheme: const TextTheme(
          headlineMedium: TextStyle(
            color: _ink,
            fontSize: 28,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.8,
          ),
          titleLarge: TextStyle(
            color: _ink,
            fontSize: 20,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.4,
          ),
          titleMedium: TextStyle(
            color: _ink,
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
          bodyMedium: TextStyle(color: _muted, fontSize: 14, height: 1.55),
        ),
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _hidePassword = true;
  String? _errorMessage;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _signIn() {
    if (!_formKey.currentState!.validate()) return;

    final username = _usernameController.text.trim().toLowerCase();
    final password = _passwordController.text;
    if (username == _demoUsername && password == _demoPassword) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (_) => const PortfolioShell()),
      );
      return;
    }

    setState(() {
      _errorMessage = 'Identifiant ou mot de passe incorrect.';
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBackdrop(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 430),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const _BrandMark(),
                    const SizedBox(height: 28),
                    GlassPanel(
                      padding: const EdgeInsets.fromLTRB(26, 30, 26, 25),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Bienvenue',
                              style: TextStyle(
                                color: _ink,
                                fontSize: 27,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.8,
                              ),
                            ),
                            const SizedBox(height: 7),
                            const Text(
                              'Connectez-vous pour découvrir mon univers.',
                              style: TextStyle(color: _muted, height: 1.5),
                            ),
                            const SizedBox(height: 28),
                            const _FieldLabel('Identifiant'),
                            const SizedBox(height: 9),
                            TextFormField(
                              controller: _usernameController,
                              textInputAction: TextInputAction.next,
                              autofillHints: const [AutofillHints.username],
                              decoration: _inputDecoration(
                                hint: 'Votre identifiant',
                                icon: Icons.person_outline_rounded,
                              ),
                              validator: (value) =>
                                  value == null || value.trim().isEmpty
                                  ? 'Veuillez saisir votre identifiant.'
                                  : null,
                            ),
                            const SizedBox(height: 19),
                            const _FieldLabel('Mot de passe'),
                            const SizedBox(height: 9),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: _hidePassword,
                              textInputAction: TextInputAction.done,
                              autofillHints: const [AutofillHints.password],
                              onFieldSubmitted: (_) => _signIn(),
                              decoration:
                                  _inputDecoration(
                                    hint: 'Votre mot de passe',
                                    icon: Icons.lock_outline_rounded,
                                  ).copyWith(
                                    suffixIcon: IconButton(
                                      tooltip: _hidePassword
                                          ? 'Afficher le mot de passe'
                                          : 'Masquer le mot de passe',
                                      onPressed: () => setState(
                                        () => _hidePassword = !_hidePassword,
                                      ),
                                      icon: Icon(
                                        _hidePassword
                                            ? Icons.visibility_outlined
                                            : Icons.visibility_off_outlined,
                                        color: _muted,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                              validator: (value) =>
                                  value == null || value.isEmpty
                                  ? 'Veuillez saisir votre mot de passe.'
                                  : null,
                            ),
                            if (_errorMessage != null) ...[
                              const SizedBox(height: 12),
                              Text(
                                _errorMessage!,
                                style: const TextStyle(
                                  color: Color(0xFFB34353),
                                  fontSize: 13,
                                ),
                              ),
                            ],
                            const SizedBox(height: 24),
                            SizedBox(
                              width: double.infinity,
                              height: 54,
                              child: FilledButton(
                                onPressed: _signIn,
                                style: FilledButton.styleFrom(
                                  backgroundColor: _blue,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(17),
                                  ),
                                  elevation: 0,
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Se connecter',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    SizedBox(width: 9),
                                    Icon(Icons.arrow_forward_rounded, size: 19),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 18),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Portfolio personnel · Goma, RDC',
                      style: TextStyle(
                        color: _ink.withValues(alpha: 0.56),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

InputDecoration _inputDecoration({
  required String hint,
  required IconData icon,
}) {
  return InputDecoration(
    hintText: hint,
    prefixIcon: Icon(icon, size: 20, color: _muted),
    filled: true,
    fillColor: Colors.white.withValues(alpha: 0.55),
    contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
    hintStyle: TextStyle(color: _muted.withValues(alpha: 0.72), fontSize: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Color(0xFFD0D5DD)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Color(0xFFD0D5DD)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: _blue, width: 1.5),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Color(0xFFCC7180)),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Color(0xFFCC7180), width: 1.4),
    ),
  );
}

class PortfolioShell extends StatefulWidget {
  const PortfolioShell({super.key});

  @override
  State<PortfolioShell> createState() => _PortfolioShellState();
}

class _PortfolioShellState extends State<PortfolioShell> {
  int _selectedIndex = 0;

  static const _pages = <Widget>[ResumePage(), FamilyPage(), ContactPage()];

  static const _titles = ['Mon CV', 'Ma famille', 'Contact'];

  void _selectPage(int index) {
    setState(() => _selectedIndex = index);
    Navigator.of(context).maybePop();
  }

  void _logout() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBackdrop(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        drawer: Drawer(
          backgroundColor: Colors.white,
          child: SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 28),
                const _ProfileAvatar(size: 76),
                const SizedBox(height: 13),
                const Text(
                  'Regis MUNYAKATUNZI',
                  style: TextStyle(
                    color: _ink,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                const Text('CV personnel', style: TextStyle(color: _muted)),
                const SizedBox(height: 24),
                const Divider(indent: 22, endIndent: 22),
                for (var index = 0; index < _titles.length; index++)
                  ListTile(
                    selected: _selectedIndex == index,
                    selectedColor: _blue,
                    selectedTileColor: _blue.withValues(alpha: 0.08),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                    leading: Icon(_navIcons[index]),
                    title: Text(_titles[index]),
                    onTap: () => _selectPage(index),
                  ),
                const Spacer(),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                  leading: const Icon(Icons.logout_rounded),
                  title: const Text('Se déconnecter'),
                  onTap: _logout,
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
        appBar: AppBar(
          backgroundColor: const Color(0xFFF4F6F9),
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          titleSpacing: 4,
          title: Text(
            _titles[_selectedIndex],
            style: const TextStyle(
              color: _ink,
              fontSize: 19,
              fontWeight: FontWeight.w800,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 17),
              child: GestureDetector(
                onTap: () => _selectPage(2),
                child: const _ProfileAvatar(size: 38),
              ),
            ),
          ],
        ),
        body: IndexedStack(index: _selectedIndex, children: _pages),
        bottomNavigationBar: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 0, 18, 10),
            child: GlassPanel(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              radius: 25,
              child: Row(
                children: List.generate(_titles.length, (index) {
                  final selected = _selectedIndex == index;
                  return Expanded(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(19),
                      onTap: () => _selectPage(index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        curve: Curves.easeOut,
                        margin: const EdgeInsets.symmetric(vertical: 2),
                        padding: const EdgeInsets.symmetric(vertical: 9),
                        decoration: BoxDecoration(
                          color: selected
                              ? _blue.withValues(alpha: 0.12)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(19),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _navIcons[index],
                              size: 20,
                              color: selected ? _blue : _muted,
                            ),
                            const SizedBox(height: 3),
                            Text(
                              _titles[index],
                              style: TextStyle(
                                color: selected ? _blue : _muted,
                                fontSize: 10,
                                fontWeight: selected
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

const _navIcons = [
  Icons.person_outline_rounded,
  Icons.groups_2_outlined,
  Icons.mail_outline_rounded,
];

class ResumePage extends StatelessWidget {
  const ResumePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 6, 20, 26),
      children: [
        GlassPanel(
          padding: const EdgeInsets.all(21),
          child: Column(
            children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  const _ProfileAvatar(size: 112),
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: const Color(0xFF63BD91),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              const Text(
                'Regis MUNYAKATUNZI',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _ink,
                  fontSize: 25,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.8,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'Étudiant en informatique · Développeur Flutter',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _blue,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 13),
              const Text(
                'Curieux et motivé, je m’intéresse à la création '
                'd’expériences numériques utiles et accessibles. '
                'J’aime apprendre, construire et relever de nouveaux défis.',
                textAlign: TextAlign.center,
                style: TextStyle(color: _muted, height: 1.55, fontSize: 13),
              ),
              const SizedBox(height: 16),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 8,
                runSpacing: 8,
                children: const [
                  _Tag(label: 'Disponible', color: Color(0xFF56A982)),
                  _Tag(label: 'Goma, Congo KINSHASA', color: _blue),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 17),
        const _SectionTitle(
          title: 'Formation',
          subtitle: 'Mon parcours académique',
          icon: Icons.school_outlined,
        ),
        const SizedBox(height: 10),
        const _TimelineCard(
          title: 'Études en informatique',
          organization: 'Établissement à compléter',
          period: 'En cours',
          description:
              'Formation orientée vers la programmation, les systèmes '
              'informatiques et la conception de solutions numériques.',
          icon: Icons.school_rounded,
        ),
        const SizedBox(height: 17),
        const _SectionTitle(
          title: 'Expériences & projets',
          subtitle: 'Ce que je construis',
          icon: Icons.work_outline_rounded,
        ),
        const SizedBox(height: 10),
        const _TimelineCard(
          title: 'Application mobile CV',
          organization: 'Projet personnel · Flutter',
          period: '2025 — 2026',
          description:
              'Conception d’une application responsive avec une navigation '
              'simple et des composants réutilisables.',
          icon: Icons.phone_iphone_rounded,
        ),
        const SizedBox(height: 10),
        const _TimelineCard(
          title: 'Projets académiques',
          organization: 'Travaux pratiques',
          period: 'En cours',
          description:
              'Réalisation de petits projets pour mettre en pratique '
              'les bases du développement et du travail en équipe.',
          icon: Icons.code_rounded,
        ),
        const SizedBox(height: 17),
        const _SectionTitle(
          title: 'Compétences',
          subtitle: 'Techniques & langues',
          icon: Icons.auto_awesome_outlined,
        ),
        const SizedBox(height: 10),
        GlassPanel(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Techniques',
                style: TextStyle(
                  color: _ink,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 11),
              const Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _SkillChip('Flutter'),
                  _SkillChip('Dart'),
                  _SkillChip('HTML & CSS'),
                  _SkillChip('Git'),
                  _SkillChip('UI / UX'),
                  _SkillChip('Esprit d’équipe'),
                ],
              ),
              const SizedBox(height: 18),
              const Text(
                'Langues',
                style: TextStyle(
                  color: _ink,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              const _LanguageBar(
                name: 'Français',
                level: 'Courant',
                value: 0.9,
              ),
              const SizedBox(height: 12),
              const _LanguageBar(
                name: 'Anglais',
                level: 'Intermédiaire',
                value: 0.70,
              ),
              const SizedBox(height: 12),
              const _LanguageBar(
                name: 'Swahili',
                level: 'Courant',
                value: 0.85,
              ),
              const SizedBox(height: 12),
              const _LanguageBar(
                name: 'Lingala',
                level: 'Intermédiaire',
                value: 0.65,
              ),
            ],
          ),
        ),
        const SizedBox(height: 17),
        const _SectionTitle(
          title: 'Centres d’intérêt',
          subtitle: 'En dehors du code',
          icon: Icons.favorite_border_rounded,
        ),
        const SizedBox(height: 10),
        GlassPanel(
          padding: const EdgeInsets.all(17),
          child: Wrap(
            spacing: 9,
            runSpacing: 9,
            children: const [
              _InterestChip(icon: Icons.menu_book_rounded, label: 'Lecture'),
              _InterestChip(
                icon: Icons.sports_basketball_rounded,
                label: 'Sport',
              ),
              _InterestChip(
                icon: Icons.lightbulb_outline_rounded,
                label: 'Innovation',
              ),
              _InterestChip(
                icon: Icons.travel_explore_rounded,
                label: 'Découverte',
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        const _EditableNote(),
      ],
    );
  }
}

class FamilyPage extends StatelessWidget {
  const FamilyPage({super.key});

  static const _members = [
    _FamilyMember(
      name: 'Alain MUNYAKATUNZI',
      relationship: 'Père',
      profession: 'Profession à compléter',
      initials: 'AM',
      tint: Color(0xFFE7EAFE),
    ),
    _FamilyMember(
      name: 'Grace MUNYAKATUNZI',
      relationship: 'Mère',
      profession: 'Profession à compléter',
      initials: 'GM',
      tint: Color(0xFFF8E8F0),
    ),
    _FamilyMember(
      name: 'Patrick MUNYAKATUNZI',
      relationship: 'Frère',
      profession: 'Profession à compléter',
      initials: 'PM',
      tint: Color.fromARGB(255, 109, 141, 168),
    ),
    _FamilyMember(
      name: 'Esther MUNYAKATUNZI',
      relationship: 'Sœur',
      profession: 'Profession à compléter',
      initials: 'EM',
      tint: Color.fromARGB(255, 137, 212, 186),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
      children: [
        const Text(
          'Les personnes qui comptent',
          style: TextStyle(
            color: _ink,
            fontSize: 23,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.6,
          ),
        ),
        const SizedBox(height: 7),
        const Text(
          'Ma famille est une source précieuse de soutien et d’inspiration.',
          style: TextStyle(color: _muted, height: 1.5),
        ),
        const SizedBox(height: 19),
        for (final member in _members) ...[
          _FamilyCard(member: member),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _FamilyMember {
  const _FamilyMember({
    required this.name,
    required this.relationship,
    required this.profession,
    required this.initials,
    required this.tint,
  });

  final String name;
  final String relationship;
  final String profession;
  final String initials;
  final Color tint;
}

class _FamilyCard extends StatelessWidget {
  const _FamilyCard({required this.member});

  final _FamilyMember member;

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      padding: const EdgeInsets.all(15),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            alignment: Alignment.center,
            color: member.tint,
            child: Text(
              member.initials,
              style: const TextStyle(
                color: _blue,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member.relationship.toUpperCase(),
                  style: const TextStyle(
                    color: _blue,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.1,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  member.name,
                  style: const TextStyle(
                    color: _ink,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  member.profession,
                  style: const TextStyle(color: _muted, fontSize: 12),
                ),
              ],
            ),
          ),
          Icon(
            Icons.favorite_rounded,
            size: 17,
            color: const Color(0xFFEA91A2).withValues(alpha: 0.8),
          ),
        ],
      ),
    );
  }
}

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  static const _email = 'regis.munyakatunzi@example.com';
  static const _phone = '+243 000 000 000';
  static const _address = 'Goma, Congo KINSHASA';
  static const _linkedin = 'https://www.linkedin.com/';
  static const _github = 'https://github.com/';

  Future<void> _open(BuildContext context, Uri uri) async {
    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Impossible d’ouvrir cette application.')),
      );
    }
  }

  Future<void> _copyAddress(BuildContext context) async {
    await Clipboard.setData(const ClipboardData(text: _address));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Adresse copiée dans le presse-papiers.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
      children: [
        const Text(
          'Restons en contact',
          style: TextStyle(
            color: _ink,
            fontSize: 24,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.6,
          ),
        ),
        const SizedBox(height: 7),
        const Text(
          'Une idée, une opportunité ou simplement envie d’échanger ?',
          style: TextStyle(color: _muted, height: 1.5),
        ),
        const SizedBox(height: 19),
        GlassPanel(
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              _ContactTile(
                icon: Icons.phone_rounded,
                label: 'Téléphone',
                value: _phone,
                tint: const Color(0xFFE6F4ED),
                onTap: () =>
                    _open(context, Uri(scheme: 'tel', path: '+243970529536')),
              ),
              const _ContactDivider(),
              _ContactTile(
                icon: Icons.mail_rounded,
                label: 'E-mail',
                value: _email,
                tint: const Color(0xFFE9ECFF),
                onTap: () =>
                    _open(context, Uri(scheme: 'mailto', path: _email)),
              ),
              const _ContactDivider(),
              _ContactTile(
                icon: Icons.location_on_rounded,
                label: 'Adresse',
                value: _address,
                tint: const Color(0xFFFFEFE7),
                onTap: () => _copyAddress(context),
              ),
            ],
          ),
        ),
        const SizedBox(height: 17),
        const _SectionTitle(
          title: 'Réseaux sociaux',
          subtitle: 'Retrouvez-moi en ligne',
          icon: Icons.alternate_email_rounded,
        ),
        const SizedBox(height: 10),
        GlassPanel(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              _SocialTile(
                icon: Icons.work_outline_rounded,
                label: 'LinkedIn',
                value: 'linkedin.com/in/regis-munyakatunzi',
                onTap: () => _open(context, Uri.parse(_linkedin)),
              ),
              const Divider(height: 20, color: Color(0x26737C91)),
              _SocialTile(
                icon: Icons.code_rounded,
                label: 'GitHub',
                value: 'github.com/regis-munyakatunzi',
                onTap: () => _open(context, Uri.parse(_github)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 17),
        GlassPanel(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Container(
                width: 43,
                height: 43,
                decoration: BoxDecoration(
                  color: const Color(0xFFEAEAFF),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(Icons.mark_email_read_outlined, color: _blue),
              ),
              const SizedBox(width: 13),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Disponible pour échanger',
                      style: TextStyle(
                        color: _ink,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Réponse sous 1 à 2 jours',
                      style: TextStyle(color: _muted, fontSize: 12),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.circle, size: 9, color: Color(0xFF63BD91)),
            ],
          ),
        ),
        const SizedBox(height: 11),
        const _EditableNote(),
      ],
    );
  }
}

class _ContactDivider extends StatelessWidget {
  const _ContactDivider();

  @override
  Widget build(BuildContext context) =>
      const Divider(height: 21, color: Color(0x26737C91));
}

class _ContactTile extends StatelessWidget {
  const _ContactTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.tint,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color tint;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          children: [
            Container(
              width: 43,
              height: 43,
              decoration: BoxDecoration(
                color: tint,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: _blue, size: 19),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(color: _muted, fontSize: 11),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    value,
                    style: const TextStyle(
                      color: _ink,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_outward_rounded, size: 16, color: _muted),
          ],
        ),
      ),
    );
  }
}

class _SocialTile extends StatelessWidget {
  const _SocialTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(13),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Container(
              width: 39,
              height: 39,
              decoration: BoxDecoration(
                color: _blue.withValues(alpha: 0.09),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(icon, size: 19, color: _blue),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      color: _ink,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    value,
                    style: const TextStyle(color: _muted, fontSize: 11),
                  ),
                ],
              ),
            ),
            const Icon(Icons.north_east_rounded, size: 17, color: _muted),
          ],
        ),
      ),
    );
  }
}

class GlassPanel extends StatelessWidget {
  const GlassPanel({
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.radius = 16,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: const Color(0xFFE4E7EC)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A101828),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

class AppBackdrop extends StatelessWidget {
  const AppBackdrop({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(color: const Color(0xFFF4F6F9), child: child);
  }
}

class _BrandMark extends StatelessWidget {
  const _BrandMark();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 66,
          height: 66,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: _blue,
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Text(
            'RM',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 13),
        const Text(
          'REGIS MUNYAKATUNZI',
          style: TextStyle(
            color: _ink,
            fontSize: 14,
            fontWeight: FontWeight.w800,
            letterSpacing: 3.2,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          'PORTFOLIO PERSONNEL',
          style: TextStyle(
            color: _muted.withValues(alpha: 0.9),
            fontSize: 9,
            fontWeight: FontWeight.w700,
            letterSpacing: 2,
          ),
        ),
      ],
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFFE8EEF7),
      ),
      child: Text(
        'RM',
        style: TextStyle(
          color: _blue,
          fontWeight: FontWeight.bold,
          fontSize: size * 0.3,
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) => Text(
    label,
    style: const TextStyle(
      color: _ink,
      fontSize: 13,
      fontWeight: FontWeight.w700,
    ),
  );
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.72),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.white),
          ),
          child: Icon(icon, color: _blue, size: 20),
        ),
        const SizedBox(width: 11),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: _ink,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(color: _muted, fontSize: 11),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TimelineCard extends StatelessWidget {
  const _TimelineCard({
    required this.title,
    required this.organization,
    required this.period,
    required this.description,
    required this.icon,
  });

  final String title;
  final String organization;
  final String period;
  final String description;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 43,
            height: 43,
            decoration: BoxDecoration(
              color: _blue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: _blue, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          color: _ink,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 7),
                    Text(
                      period,
                      style: const TextStyle(
                        color: _blue,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  organization,
                  style: const TextStyle(
                    color: _muted,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: const TextStyle(
                    color: _muted,
                    fontSize: 12,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.circle, color: color, size: 7),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _SkillChip extends StatelessWidget {
  const _SkillChip(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFEDEEFF).withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: _blue,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _LanguageBar extends StatelessWidget {
  const _LanguageBar({
    required this.name,
    required this.level,
    required this.value,
  });

  final String name;
  final String level;
  final double value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                name,
                style: const TextStyle(
                  color: _ink,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Text(level, style: const TextStyle(color: _muted, fontSize: 11)),
          ],
        ),
        const SizedBox(height: 7),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: value,
            minHeight: 6,
            backgroundColor: const Color(0xFFE8EAF3),
            valueColor: const AlwaysStoppedAnimation<Color>(_blue),
          ),
        ),
      ],
    );
  }
}

class _InterestChip extends StatelessWidget {
  const _InterestChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: _violet),
          const SizedBox(width: 7),
          Text(
            label,
            style: const TextStyle(
              color: _ink,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _EditableNote extends StatelessWidget {
  const _EditableNote();

  @override
  Widget build(BuildContext context) {
    return Text(
      'Pensez à remplacer les informations d’exemple par les vôtres.',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: _muted.withValues(alpha: 0.9),
        fontSize: 11,
        height: 1.4,
      ),
    );
  }
}
