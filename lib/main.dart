import 'package:flutter/material.dart';
import 'dart:ui';
import 'splash_screen.dart';
import 'splash_config.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6C63FF),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const SplashScreen(), // ← Start at Splash
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// Login Page
// ════════════════════════════════════════════════════════════════════════════
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    ));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> login() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _isLoading = false);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF6C63FF),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: const Row(
          children: [
            Icon(Icons.check_circle_outline, color: Colors.white),
            SizedBox(width: 10),
            Text(
              "Welcome back! 🎉",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  /// Opens the logo picker — user can change splash logo from the login page too.
  void _showLogoPickerSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _LogoPickerBottomSheet(
        onSelected: (_) {},
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
              // ── Change Logo button (top-right corner) ──────────────────
              Positioned(
                top: 12,
                right: 16,
                child: GestureDetector(
                  onTap: _showLogoPickerSheet,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.07),
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
                          size: 16,
                        ),
                        const SizedBox(width: 5),
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

              // ── Main scrollable content ────────────────────────────────
              Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: FadeTransition(
                    opacity: _fadeAnim,
                    child: SlideTransition(
                      position: _slideAnim,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // ── Logo (reactive to SplashConfig) ────────────
                          ValueListenableBuilder<int>(
                            valueListenable: SplashConfig.selectedIndex,
                            builder: (_, __, ___) {
                              final logo = SplashConfig.current;
                              return Container(
                                width: 90,
                                height: 90,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    colors: logo.gradient,
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: logo.gradient.first
                                          .withOpacity(0.5),
                                      blurRadius: 30,
                                      spreadRadius: 5,
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  logo.icon,
                                  size: 50,
                                  color: Colors.white,
                                ),
                              );
                            },
                          ),

                          const SizedBox(height: 28),

                          // ── Title ───────────────────────────────────────
                          const Text(
                            "Welcome Back",
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "Sign in to continue",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white.withOpacity(0.55),
                              letterSpacing: 0.3,
                            ),
                          ),

                          const SizedBox(height: 36),

                          // ── Glass Card ──────────────────────────────────
                          ClipRRect(
                            borderRadius: BorderRadius.circular(28),
                            child: BackdropFilter(
                              filter:
                                  ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                              child: Container(
                                padding: const EdgeInsets.all(28),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.07),
                                  borderRadius: BorderRadius.circular(28),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.15),
                                    width: 1.2,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    _buildTextField(
                                      controller: emailController,
                                      label: "Email",
                                      icon: Icons.email_outlined,
                                      keyboardType: TextInputType.emailAddress,
                                    ),
                                    const SizedBox(height: 18),
                                    _buildTextField(
                                      controller: passwordController,
                                      label: "Password",
                                      icon: Icons.lock_outline_rounded,
                                      obscureText: _obscurePassword,
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _obscurePassword
                                              ? Icons.visibility_off_outlined
                                              : Icons.visibility_outlined,
                                          color: Colors.white54,
                                          size: 20,
                                        ),
                                        onPressed: () => setState(() =>
                                            _obscurePassword =
                                                !_obscurePassword),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: TextButton(
                                        onPressed: () {},
                                        style: TextButton.styleFrom(
                                          padding: EdgeInsets.zero,
                                          minimumSize: Size.zero,
                                          tapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                        ),
                                        child: const Text(
                                          "Forgot password?",
                                          style: TextStyle(
                                            color: Color(0xFFB06AB3),
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 24),

                                    // Login button
                                    SizedBox(
                                      width: double.infinity,
                                      height: 54,
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          gradient: const LinearGradient(
                                            colors: [
                                              Color(0xFF6C63FF),
                                              Color(0xFFB06AB3),
                                            ],
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: const Color(0xFF6C63FF)
                                                  .withOpacity(0.45),
                                              blurRadius: 20,
                                              offset: const Offset(0, 8),
                                            ),
                                          ],
                                        ),
                                        child: ElevatedButton(
                                          onPressed: _isLoading ? null : login,
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.transparent,
                                            shadowColor: Colors.transparent,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                          ),
                                          child: _isLoading
                                              ? const SizedBox(
                                                  width: 22,
                                                  height: 22,
                                                  child:
                                                      CircularProgressIndicator(
                                                    color: Colors.white,
                                                    strokeWidth: 2.5,
                                                  ),
                                                )
                                              : const Text(
                                                  "Sign In",
                                                  style: TextStyle(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w700,
                                                    color: Colors.white,
                                                    letterSpacing: 0.5,
                                                  ),
                                                ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 28),

                          // Sign up row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don't have an account? ",
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.5),
                                  fontSize: 14,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {},
                                child: const Text(
                                  "Sign Up",
                                  style: TextStyle(
                                    color: Color(0xFF6C63FF),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white, fontSize: 15),
      cursorColor: const Color(0xFF6C63FF),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
            color: Colors.white.withOpacity(0.55), fontSize: 14),
        prefixIcon: Icon(icon, color: const Color(0xFF6C63FF), size: 20),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Colors.white.withOpacity(0.06),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.15)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide:
              const BorderSide(color: Color(0xFF6C63FF), width: 1.8),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// Shared Logo Picker Bottom Sheet (reused in LoginPage)
// ════════════════════════════════════════════════════════════════════════════
class _LogoPickerBottomSheet extends StatefulWidget {
  final ValueChanged<int> onSelected;
  const _LogoPickerBottomSheet({required this.onSelected});

  @override
  State<_LogoPickerBottomSheet> createState() => _LogoPickerBottomSheetState();
}

class _LogoPickerBottomSheetState extends State<_LogoPickerBottomSheet> {
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
          // Drag handle
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
            'Pick a logo for the splash screen',
            style: TextStyle(
              fontSize: 13,
              color: Colors.white.withOpacity(0.45),
            ),
          ),
          const SizedBox(height: 24),

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
                    gradient:
                        isSelected ? LinearGradient(colors: opt.gradient) : null,
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
                      Icon(opt.icon, color: Colors.white, size: 30),
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