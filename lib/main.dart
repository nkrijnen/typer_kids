import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/diagnostics.dart';
import 'core/router/app_router.dart';
import 'core/sound_manager.dart';
import 'core/theme/app_theme.dart';
import 'providers/language_provider.dart';
import 'providers/profile_provider.dart';
import 'providers/progress_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  InputDiagnostics.install();
  GoogleFonts.config.allowRuntimeFetching = false;
  LicenseRegistry.addLicense(() async* {
    for (final (family, file) in [
      ('Fredoka', 'fredoka'),
      ('Nunito', 'nunito'),
      ('JetBrains Mono', 'jetbrainsmono'),
      ('Roboto Mono', 'robotomono'),
      ('Noto Color Emoji', 'notoemoji'),
      ('Noto Sans Symbols 2', 'notoemoji'),
    ]) {
      yield LicenseEntryWithLineBreaks([
        family,
      ], await rootBundle.loadString('assets/fonts/sources/$file-OFL.txt'));
    }
  });

  // Ensure imperative API calls (push, pushReplacement) update the browser URL
  GoRouter.optionURLReflectsImperativeAPIs = true;

  // Initialize providers before app starts
  final profileProvider = ProfileProvider();
  await profileProvider.init();

  final languageProvider = LanguageProvider();
  await languageProvider.init();

  final progressProvider = ProgressProvider();
  // Load SharedPreferences instance, then load data for the active profile
  await progressProvider.init(
    profileId: profileProvider.activeProfileId ?? '',
    language: languageProvider.language,
  );

  // Restore the saved sound preference (defaults to on)
  final prefs = await SharedPreferences.getInstance();
  SoundManager().enabled = prefs.getBool(SoundManager.prefsKey) ?? true;

  runApp(
    TyperKidsApp(
      profileProvider: profileProvider,
      progressProvider: progressProvider,
      languageProvider: languageProvider,
    ),
  );
}

class TyperKidsApp extends StatefulWidget {
  final ProfileProvider profileProvider;
  final ProgressProvider progressProvider;
  final LanguageProvider languageProvider;

  const TyperKidsApp({
    super.key,
    required this.profileProvider,
    required this.progressProvider,
    required this.languageProvider,
  });

  @override
  State<TyperKidsApp> createState() => _TyperKidsAppState();
}

class _TyperKidsAppState extends State<TyperKidsApp> {
  late final GoRouter _router = AppRouter.router(widget.profileProvider);

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: widget.profileProvider),
        ChangeNotifierProvider.value(value: widget.progressProvider),
        ChangeNotifierProvider.value(value: widget.languageProvider),
      ],
      child: Builder(
        builder: (context) => InputDiagnostics.wrap(
          MaterialApp.router(
            title: 'Typer Kids',
            locale: context.watch<LanguageProvider>().locale,
            supportedLocales: const [Locale('en'), Locale('nl')],
            localizationsDelegates: GlobalMaterialLocalizations.delegates,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.theme,
            routerConfig: _router,
          ),
        ),
      ),
    );
  }
}
