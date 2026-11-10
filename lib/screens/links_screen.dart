
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:campus_buddy_kict/services/link_opener.dart';
import 'package:share_plus/share_plus.dart';

const Color _turquoise = Color(0xFF009FA3);
const Color _darkTurquoise = Color(0xFF007C80);
const Color _paleAqua = Color(0xFFEAF9F8);

class LinkItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final String uri;

  const LinkItem(
    this.title,
    this.subtitle,
    this.icon,
    this.uri,
  );
}

const List<LinkItem> _links = [
  LinkItem(
    'IIUM Portal',
    'Student portal & registration',
    Icons.school_rounded,
    'https://my.iium.edu.my',
  ),
  LinkItem(
    'IIUM Website',
    'News & announcements',
    Icons.language_rounded,
    'https://www.iium.edu.my',
  ),
  LinkItem(
    'Library',
    'Books & e-resources',
    Icons.local_library_rounded,
    'https://division.iium.edu.my/lib',
  ),
  LinkItem(
    'KICT',
    'Kuliyyah of ICT',
    Icons.computer_rounded,
    'https://www.iium.edu.my/kict',
  ),
];

class LinksScreen extends StatefulWidget {
  const LinksScreen({super.key});

  @override
  State<LinksScreen> createState() => _LinksScreenState();
}

class _LinksScreenState extends State<LinksScreen> {
  bool _openInApp = false;

  Future<void> _open(String uri) async {
    final ok = await LinkOpener.open(
      uri,
      inApp: _openInApp,
    );

    if (!ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Cannot open $uri on this device'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _share() async {
    await SharePlus.instance.share(
      ShareParams(
        text: 'Campus Buddy KICT — built in CSCI 4311 at IIUM.',
      ),
    );
  }

  void _openMap() {
    final isAndroid = !kIsWeb &&
        defaultTargetPlatform == TargetPlatform.android;

    if (isAndroid) {
      _open('geo:3.0717,101.7182?q=IIUM+Gombak+Campus');
    } else {
      _open(
        'https://maps.apple.com/?q=IIUM+Gombak+Campus'
        '&ll=3.0717,101.7182',
      );
    }
  }

  void _callHotline() {
    _open('tel:+60361964000');
  }

  void _emailAdvisor() {
    _open(
      'mailto:advisor@iium.edu.my'
      '?subject=Advising%20session'
      '&body=Assalamualaikum%2C%20I%20would%20like%20to%20book%20a%20slot.',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _paleAqua,
      body: Stack(
        children: [
          // Soft gradient background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFE1F8F6),
                  Color(0xFFF4FAFA),
                  Color(0xFFDDF2F0),
                ],
              ),
            ),
          ),

          // Decorative background circles
          Positioned(
            top: -90,
            right: -70,
            child: _GlowCircle(
              size: 230,
              color: const Color(0xFF72DAD3).withValues(alpha:0.25),
            ),
          ),
          Positioned(
            top: 380,
            left: -100,
            child: _GlowCircle(
              size: 200,
              color: const Color(0xFF009FA3).withValues(alpha:0.12),
            ),
          ),

          SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha:0.7),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 1.5,
                                ),
                              ),
                              child: const Icon(
                                Icons.explore_rounded,
                                color: _darkTurquoise,
                                size: 26,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'CAMPUS BUDDY KICT',
                                    style: TextStyle(
                                      fontSize: 11,
                                      letterSpacing: 2,
                                      fontWeight: FontWeight.bold,
                                      color: _turquoise,
                                    ),
                                  ),
                                  SizedBox(height: 3),
                                  Text(
                                    'Campus Links',
                                    style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w800,
                                      color: _darkTurquoise,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            _GlassIconButton(
                              icon: Icons.share_rounded,
                              onTap: _share,
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Hero glass card
                        _GlassPanel(
                          padding: const EdgeInsets.all(22),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Everything you need,',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w800,
                                        color: _darkTurquoise,
                                      ),
                                    ),
                                    const Text(
                                      'just one tap away.',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w800,
                                        color: _turquoise,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      'Quick access to IIUM services and campus essentials.',
                                      style: TextStyle(
                                        fontSize: 12,
                                        height: 1.5,
                                        color: Colors.blueGrey.shade700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                width: 75,
                                height: 75,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _turquoise.withValues(alpha:0.12),
                                ),
                                child: const Icon(
                                  Icons.travel_explore_rounded,
                                  size: 43,
                                  color: _turquoise,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 25),

                        const _SectionHeading(
                          title: 'ONLINE RESOURCES',
                          subtitle: 'Explore IIUM websites and services',
                        ),

                        const SizedBox(height: 12),

                        // Website cards
                        ..._links.map(
                          (link) => Padding(
                            padding: const EdgeInsets.only(bottom: 11),
                            child: _GlassPanel(
                              padding: EdgeInsets.zero,
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 9,
                                ),
                                leading: Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: _turquoise.withValues(alpha:0.12),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Icon(
                                    link.icon,
                                    color: _darkTurquoise,
                                    size: 24,
                                  ),
                                ),
                                title: Text(
                                  link.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: _darkTurquoise,
                                    fontSize: 14,
                                  ),
                                ),
                                subtitle: Text(
                                  link.subtitle,
                                  style: TextStyle(
                                    color: Colors.blueGrey.shade600,
                                    fontSize: 11,
                                  ),
                                ),
                                trailing: const Icon(
                                  Icons.arrow_outward_rounded,
                                  color: _turquoise,
                                  size: 20,
                                ),
                                onTap: () => _open(link.uri),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 15),

                        const _SectionHeading(
                          title: 'CAMPUS ESSENTIALS',
                          subtitle: 'Useful services for your daily campus life',
                        ),

                        const SizedBox(height: 12),

                        _GlassPanel(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              _EssentialTile(
                                icon: Icons.map_rounded,
                                title: 'Campus Map',
                                subtitle: 'Find IIUM Gombak Campus',
                                onTap: _openMap,
                              ),
                              const _GlassDivider(),
                              _EssentialTile(
                                icon: Icons.phone_rounded,
                                title: 'University Hotline',
                                subtitle: '+60 3-6196 4000',
                                onTap: _callHotline,
                              ),
                              const _GlassDivider(),
                              _EssentialTile(
                                icon: Icons.mail_rounded,
                                title: 'Academic Advisor',
                                subtitle: 'Send an advising email',
                                onTap: _emailAdvisor,
                              ),
                              const _GlassDivider(),
                              _EssentialTile(
                                icon: Icons.share_rounded,
                                title: 'Share Campus Buddy',
                                subtitle: 'Share with your friends',
                                onTap: _share,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 15),

                        // Browser setting
                        _GlassPanel(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: SwitchListTile(
                            contentPadding: EdgeInsets.zero,
                            secondary: Container(
                              width: 43,
                              height: 43,
                              decoration: BoxDecoration(
                                color: _turquoise.withValues(alpha:0.12),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: const Icon(
                                Icons.web_rounded,
                                color: _turquoise,
                              ),
                            ),
                            title: const Text(
                              'Open websites in-app',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: _darkTurquoise,
                                fontSize: 13,
                              ),
                            ),
                            subtitle: Text(
                              _openInApp
                                  ? 'Using the in-app browser'
                                  : 'Using your external browser',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.blueGrey.shade600,
                              ),
                            ),
                            value: _openInApp,
                            activeThumbColor: _turquoise,
                            onChanged: (value) {
                              setState(() {
                                _openInApp = value;
                              });
                            },
                          ),
                        ),

                        const SizedBox(height: 25),

                        Center(
                          child: Text(
                            'Made for IIUM students 💚',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.blueGrey.shade500,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),

                        const SizedBox(height: 18),
                      ],
                    ),
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

// ============================================================
// GLASS COMPONENTS
// ============================================================

class _GlassPanel extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const _GlassPanel({
    required this.child,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(23),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 14,
          sigmaY: 14,
        ),
        child: Container(
          width: double.infinity,
          padding: padding,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha:0.58),
            borderRadius: BorderRadius.circular(23),
            border: Border.all(
              color: Colors.white.withValues(alpha:0.85),
              width: 1.4,
            ),
            boxShadow: [
              BoxShadow(
                color: _darkTurquoise.withValues(alpha:0.06),
                blurRadius: 18,
                offset: const Offset(0, 7),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

class _GlassIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _GlassIconButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha:0.65),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white),
          ),
          child: const Icon(
            Icons.share_rounded,
            color: _darkTurquoise,
            size: 21,
          ),
        ),
      ),
    );
  }
}

class _GlowCircle extends StatelessWidget {
  final double size;
  final Color color;

  const _GlowCircle({
    required this.size,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}

class _SectionHeading extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SectionHeading({
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 11,
            letterSpacing: 1.5,
            fontWeight: FontWeight.w800,
            color: _darkTurquoise,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 11,
            color: Colors.blueGrey.shade600,
          ),
        ),
      ],
    );
  }
}

class _EssentialTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _EssentialTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 3),
      leading: Container(
        width: 43,
        height: 43,
        decoration: BoxDecoration(
          color: _turquoise.withValues(alpha:0.12),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(
          icon,
          color: _darkTurquoise,
          size: 21,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: _darkTurquoise,
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: Colors.blueGrey.shade600,
          fontSize: 11,
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right_rounded,
        color: _turquoise,
      ),
      onTap: onTap,
    );
  }
}

class _GlassDivider extends StatelessWidget {
  const _GlassDivider();

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 12,
      color: _turquoise.withValues(alpha:0.12),
    );
  }
}
