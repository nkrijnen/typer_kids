import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/sound_manager.dart';
import '../core/theme/app_colors.dart';
import '../providers/language_provider.dart';
import '../providers/profile_provider.dart';
import '../providers/progress_provider.dart';

/// Simple settings screen for resetting progress and toggling options
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _handleKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent) return;
    if (event.logicalKey == LogicalKeyboardKey.escape) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final progress = context.watch<ProgressProvider>();
    final profileProv = context.watch<ProfileProvider>();
    final activeProfile = profileProv.activeProfile;
    final language = context.watch<LanguageProvider>();
    final dutch = language.isDutch;

    return Scaffold(
      appBar: AppBar(title: Text(dutch ? 'Instellingen' : 'Settings')),
      body: KeyboardListener(
        focusNode: _focusNode,
        autofocus: true,
        onKeyEvent: _handleKeyEvent,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            _buildSectionHeader(dutch ? 'Taal' : 'Language'),
            const SizedBox(height: 12),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'en', label: Text('English')),
                ButtonSegment(value: 'nl', label: Text('Nederlands')),
              ],
              selected: {language.language},
              onSelectionChanged: (selection) {
                final selected = selection.first;
                language.select(selected);
                context.read<ProgressProvider>().switchLanguage(selected);
              },
            ),
            const SizedBox(height: 32),
            // Active profile
            if (activeProfile != null) ...[
              _buildSectionHeader(dutch ? 'Profiel' : 'Profile'),
              const SizedBox(height: 12),
              _buildInfoCard(
                context,
                children: [
                  _buildInfoRow(dutch ? 'Naam' : 'Name', activeProfile.name),
                  _buildInfoRow(
                    dutch ? 'Avatar' : 'Avatar',
                    activeProfile.emoji,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => context.push('/profiles'),
                  icon: const Icon(Icons.people_rounded),
                  label: Text(
                    dutch ? 'Ander profiel' : 'Switch Profile',
                    style: GoogleFonts.fredoka(fontSize: 16),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                    padding: const EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
            // Sound
            _buildSectionHeader(dutch ? 'Geluid' : 'Sound'),
            const SizedBox(height: 12),
            _buildInfoCard(
              context,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Text('🔊', style: TextStyle(fontSize: 22)),
                        const SizedBox(width: 10),
                        Text(
                          dutch ? 'Geluidseffecten' : 'Sound Effects',
                          style: GoogleFonts.nunito(
                            fontSize: 16,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    Switch(
                      value: SoundManager().enabled,
                      activeThumbColor: AppColors.primary,
                      onChanged: (value) async {
                        setState(() => SoundManager().enabled = value);
                        if (value) SoundManager().playPop();
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setBool(SoundManager.prefsKey, value);
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Stats overview
            _buildSectionHeader(dutch ? 'Je voortgang' : 'Your Progress'),
            const SizedBox(height: 12),
            _buildInfoCard(
              context,
              children: [
                _buildInfoRow(
                  dutch ? 'Lessen voltooid' : 'Lessons Completed',
                  '${progress.completedLessons}/${progress.totalLessons}',
                ),
                _buildInfoRow(
                  dutch ? 'Sterren' : 'Total Stars',
                  '${progress.totalStars}',
                ),
                _buildInfoRow(
                  dutch ? 'Gemiddelde nauwkeurigheid' : 'Average Accuracy',
                  progress.averageAccuracy > 0
                      ? '${progress.averageAccuracy.toStringAsFixed(1)}%'
                      : 'N/A',
                ),
                _buildInfoRow(
                  dutch ? 'Gemiddelde snelheid' : 'Average Speed',
                  progress.averageWpm > 0
                      ? '${progress.averageWpm.toStringAsFixed(0)} WPM'
                      : 'N/A',
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Danger zone
            _buildSectionHeader(dutch ? 'Voortgang wissen' : 'Danger Zone'),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _showResetDialog(context),
                icon: const Icon(Icons.delete_forever_rounded),
                label: Text(
                  dutch ? 'Wis alle voortgang' : 'Reset All Progress',
                  style: GoogleFonts.fredoka(fontSize: 16),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.incorrect,
                  side: const BorderSide(color: AppColors.incorrect),
                  padding: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),

            // About
            _buildSectionHeader(dutch ? 'Over' : 'About'),
            const SizedBox(height: 12),
            _buildInfoCard(
              context,
              children: [
                _buildInfoRow('App', 'Typer Kids'),
                _buildInfoRow(dutch ? 'Versie' : 'Version', '1.2.0'),
                _buildInfoRow(
                  dutch ? 'Gemaakt met' : 'Made with',
                  '❤️ and Flutter',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.fredoka(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.nunito(
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.fredoka(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  void _showResetDialog(BuildContext context) {
    final dutch = context.read<LanguageProvider>().isDutch;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Text('⚠️', style: TextStyle(fontSize: 28)),
            const SizedBox(width: 8),
            Text(
              dutch ? 'Voortgang wissen?' : 'Reset Progress?',
              style: GoogleFonts.fredoka(fontSize: 22),
            ),
          ],
        ),
        content: Text(
          dutch
              ? 'Dit wist je sterren, scores en lesvoortgang. Dit kun je niet ongedaan maken!'
              : 'This will erase all your stars, scores, and lesson progress. This cannot be undone!',
          style: GoogleFonts.nunito(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              dutch ? 'Annuleren' : 'Cancel',
              style: GoogleFonts.fredoka(color: AppColors.primary),
            ),
          ),
          TextButton(
            onPressed: () {
              context.read<ProgressProvider>().resetAll();
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    dutch
                        ? 'Voortgang gewist! Klaar voor een nieuwe start! 🌱'
                        : 'Progress reset! Ready for a fresh start! 🌱',
                    style: GoogleFonts.nunito(),
                  ),
                  backgroundColor: AppColors.primary,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            },
            child: Text(
              dutch ? 'Wissen' : 'Reset',
              style: GoogleFonts.fredoka(color: AppColors.incorrect),
            ),
          ),
        ],
      ),
    );
  }
}
