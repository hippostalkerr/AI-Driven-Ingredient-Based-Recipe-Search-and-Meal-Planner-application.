import 'package:flutter/material.dart';
import 'splash_config.dart';
import 'main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // ── Animation controllers ────────────────────────────────────────────────
  late final AnimationController _logoCtrl;
  late final AnimationController _textCtrl;
  late final AnimationController _pulseCtrl;

  late final Animation<double> _logoScale;
  late final Animation<double> _logoFade;
  late final Animation<double> _textFade;
  late final Animation<Offset> _textSlide;
  late final Animation<double> _pulse;

  @override
  void initState() {
    super.initState();

    // Logo pop-in
    _logoCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _logoScale = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _logoCtrl, curve: Curves.elasticOut),
    );
    _logoFade = CurvedAnimation(parent: _logoCtrl, curve: Curves.easeOut);

    // Text slide-up
    _textCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _textFade = CurvedAnimation(parent: _textCtrl, curve: Curves.easeOut);
    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _textCtrl, curve: Curves.easeOut));

    // Infinite glow pulse
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);
    _pulse = Tween<double>(begin: 0.4, end: 0.85).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );

    // Sequence: logo → text → navigate
    _logoCtrl.forward().then((_) {
      _textCtrl.forward();
    });

    Future.delayed(const Duration(milliseconds: 3000), _goToLogin);
  }

  @override
  void dispose() {
    _logoCtrl.dispose();
    _textCtrl.dispose();
    _pulseCtrl.dispose();
    super.dispose();
  }

  void _goToLogin() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 700),
        pageBuilder: (_, __, ___) => const LoginPage(),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  // ── Logo picker bottom sheet ─────────────────────────────────────────────
  void _showLogoPickerSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _LogoPickerSheet(
        onSelected: (index) {
          setState(() {}); // trigger rebuild so logo updates immediately
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder<int>(
        valueListenable: SplashConfig.selectedIndex,
        builder: (context, selectedIdx, _) {
          final logo = SplashConfig.current;

          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF0F0C29),
                  Color(0xFF302B63),
                  Color(0xFF24243E),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              child: Stack(
                children: [
                  // ── Change logo button (top-right) ─────────────────────
                  Positioned(
                    top: 16,
                    right: 16,
                    child: Tooltip(
                      message: 'Change Logo',
                      child: GestureDetector(
                        onTap: _showLogoPickerSheet,
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.12),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.palette_outlined,
                                color: Colors.white70,
                                size: 18,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Change Logo',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // ── Center content ─────────────────────────────────────
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Pulsing glow ring
                        AnimatedBuilder(
                          animation: _pulse,
                          builder: (_, child) => Container(
                            width: 160,
                            height: 160,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: logo.gradient.first
                                      .withOpacity(_pulse.value * 0.6),
                                  blurRadius: 60,
                                  spreadRadius: 20,
                                ),
                              ],
                            ),
                            child: child,
                          ),
                          child: ScaleTransition(
                            scale: _logoScale,
                            child: FadeTransition(
                              opacity: _logoFade,
                              child: Container(
                                width: 140,
                                height: 140,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    colors: logo.gradient,
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          logo.gradient.first.withOpacity(0.5),
                                      blurRadius: 30,
                                      spreadRadius: 5,
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  logo.icon,
                                  size: 72,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 40),

                        // App name + tagline
                        SlideTransition(
                          position: _textSlide,
                          child: FadeTransition(
                            opacity: _textFade,
                            child: Column(
                              children: [
                                const Text(
                                  'TestApp',
                                  style: TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Your journey starts here',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white.withOpacity(0.5),
                                    letterSpacing: 0.5,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ── Bottom loading dots ────────────────────────────────
                  Positioned(
                    bottom: 48,
                    left: 0,
                    right: 0,
                    child: FadeTransition(
                      opacity: _textFade,
                      child: const _PulsingDots(),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ── Logo Picker Bottom Sheet ─────────────────────────────────────────────────
class _LogoPickerSheet extends StatefulWidget {
  final ValueChanged<int> onSelected;
  const _LogoPickerSheet({required this.onSelected});

  @override
  State<_LogoPickerSheet> createState() => _LogoPickerSheetState();
}

class _LogoPickerSheetState extends State<_LogoPickerSheet> {
  late int _current;

  @override
  void initState() {
    super.initState();
    _current = SplashConfig.selectedIndex.value;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1830),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          const Text(
            'Choose Splash Logo',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Pick a logo to display on the splash screen',
            style: TextStyle(
              fontSize: 13,
              color: Colors.white.withOpacity(0.45),
            ),
          ),
          const SizedBox(height: 24),

          // Grid of logo options
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
              childAspectRatio: 0.8,
            ),
            itemCount: SplashConfig.options.length,
            itemBuilder: (_, i) {
              final opt = SplashConfig.options[i];
              final isSelected = _current == i;
              return GestureDetector(
                onTap: () {
                  setState(() => _current = i);
                  SplashConfig.selectedIndex.value = i;
                  widget.onSelected(i);
                  Future.delayed(
                    const Duration(milliseconds: 250),
                    () => Navigator.pop(context),
                  );
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOut,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    gradient: isSelected
                        ? LinearGradient(colors: opt.gradient)
                        : null,
                    color: isSelected
                        ? null
                        : Colors.white.withOpacity(0.06),
                    border: Border.all(
                      color: isSelected
                          ? opt.gradient.last
                          : Colors.white.withOpacity(0.1),
                      width: isSelected ? 2 : 1,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: opt.gradient.first.withOpacity(0.45),
                              blurRadius: 16,
                              spreadRadius: 2,
                            )
                          ]
                        : [],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        opt.icon,
                        color: Colors.white,
                        size: 30,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        opt.label,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.white.withOpacity(0.8),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ── Pulsing dots loading indicator ──────────────────────────────────────────
class _PulsingDots extends StatefulWidget {
  const _PulsingDots();

  @override
  State<_PulsingDots> createState() => _PulsingDotsState();
}

class _PulsingDotsState extends State<_PulsingDots>
    with TickerProviderStateMixin {
  final List<AnimationController> _controllers = [];
  final List<Animation<double>> _anims = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 3; i++) {
      final ctrl = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 600),
      );
      final anim = Tween<double>(begin: 0.3, end: 1.0).animate(
        CurvedAnimation(parent: ctrl, curve: Curves.easeInOut),
      );
      _controllers.add(ctrl);
      _anims.add(anim);

      Future.delayed(Duration(milliseconds: i * 180), () {
        if (mounted) ctrl.repeat(reverse: true);
      });
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (i) {
        return AnimatedBuilder(
          animation: _anims[i],
          builder: (_, __) => Container(
            margin: const EdgeInsets.symmetric(horizontal: 5),
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(_anims[i].value),
            ),
          ),
        );
      }),
    );
  }
}
