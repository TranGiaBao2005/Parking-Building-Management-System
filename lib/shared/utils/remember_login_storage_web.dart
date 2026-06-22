import 'dart:html' as html;

class RememberLoginStorage {
  static const _usernameKey = 'parksmart_remembered_username';

  static Future<String?> loadUsername() async =>
      html.window.localStorage[_usernameKey];

  static Future<void> saveUsername(String username) async {
    html.window.localStorage[_usernameKey] = username;
  }

  static Future<void> clearUsername() async {
    html.window.localStorage.remove(_usernameKey);
  }
}
