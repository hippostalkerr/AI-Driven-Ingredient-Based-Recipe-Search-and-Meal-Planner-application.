import 'package:flutter/material.dart';

/// Represents one selectable logo option for the splash screen.
class LogoOption {
  final IconData icon;
  final List<Color> gradient;
  final String label;

  const LogoOption({
    required this.icon,
    required this.gradient,
    required this.label,
  });
}

/// Global splash-screen configuration.
/// Change [selectedIndex] to update the logo across the whole app instantly.
class SplashConfig {
  SplashConfig._(); // not instantiable

  /// The index of the currently selected logo. Widgets can listen to this.
  static final ValueNotifier<int> selectedIndex = ValueNotifier(0);

  /// All available logo choices.
  static const List<LogoOption> options = [
    LogoOption(
      icon: Icons.bolt_rounded,
      gradient: [Color(0xFF6C63FF), Color(0xFFB06AB3)],
      label: 'Bolt',
    ),
    LogoOption(
      icon: Icons.rocket_launch_rounded,
      gradient: [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
      label: 'Rocket',
    ),
    LogoOption(
      icon: Icons.auto_awesome_rounded,
      gradient: [Color(0xFF43CEA2), Color(0xFF185A9D)],
      label: 'Star',
    ),
    LogoOption(
      icon: Icons.diamond_outlined,
      gradient: [Color(0xFF00C6FF), Color(0xFF0072FF)],
      label: 'Diamond',
    ),
    LogoOption(
      icon: Icons.local_fire_department_rounded,
      gradient: [Color(0xFFf7971e), Color(0xFFffd200)],
      label: 'Fire',
    ),
    LogoOption(
      icon: Icons.flutter_dash_rounded,
      gradient: [Color(0xFF11998E), Color(0xFF38EF7D)],
      label: 'Dash',
    ),
    LogoOption(
      icon: Icons.psychology_rounded,
      gradient: [Color(0xFFDA22FF), Color(0xFF9733EE)],
      label: 'Brain',
    ),
    LogoOption(
      icon: Icons.shield_rounded,
      gradient: [Color(0xFF373B44), Color(0xFF4286F4)],
      label: 'Shield',
    ),
  ];

  /// Shortcut to get the currently active option.
  static LogoOption get current => options[selectedIndex.value];
}
