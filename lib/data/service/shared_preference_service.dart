import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static SharedPreferences? _preferences;

  Future<void> saveToken(String token) async {
    _preferences = await SharedPreferences.getInstance();
    await _preferences!.setString('token', token);
  }

  Future<String?> getToken() async {
    _preferences = await SharedPreferences.getInstance();
    return _preferences!.getString('token');
  }

  Future<void> clearToken() async {
    _preferences = await SharedPreferences.getInstance();
    await _preferences!.remove('token');
  }

  Future<void> saveUser(int user) async {
    _preferences = await SharedPreferences.getInstance();
    await _preferences!.setInt('user', user);
  }

  Future<int?> getUser() async {
    _preferences = await SharedPreferences.getInstance();
    return _preferences!.getInt('user');
  }

  Future<void> clearUser() async {
    _preferences = await SharedPreferences.getInstance();
    await _preferences!.remove('user');
  }

  Future<void> saveLogin(bool isLogin) async {
    _preferences = await SharedPreferences.getInstance();
    await _preferences!.setBool('isLogin', isLogin);
  }

  Future<bool?> getLogin() async {
    _preferences = await SharedPreferences.getInstance();
    return _preferences!.getBool('isLogin');
  }

  Future<void> clearLogin() async {
    _preferences = await SharedPreferences.getInstance();
    await _preferences!.remove('isLogin');
  }
}
