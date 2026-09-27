import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/lesson_curriculum_selector.dart';

class LanguageProvider extends ChangeNotifier {
  static const prefsKey = 'app_language';

  String _language = 'en';
  String get language => _language;
  bool get isDutch => _language == 'nl';
  Locale get locale => Locale(_language);

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _language = prefs.getString(prefsKey) == 'nl' ? 'nl' : 'en';
    LessonCurriculum.isDutch = isDutch;
    notifyListeners();
  }

  Future<void> select(String language) async {
    final selected = language == 'nl' ? 'nl' : 'en';
    if (_language != selected) {
      _language = selected;
      LessonCurriculum.isDutch = isDutch;
      notifyListeners();
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(prefsKey, selected);
  }
}