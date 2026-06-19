import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> saveUser(UserModel user);
  Future<UserModel?> getUser();
  Future<void> clearUser();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences _sharedPreferences;

  AuthLocalDataSourceImpl(this._sharedPreferences);

  static const String _userKey = 'cached_user';

  @override
  Future<void> saveUser(UserModel user) async {
    await _sharedPreferences.setString(_userKey, userToJson(user));
  }

  @override
  Future<UserModel?> getUser() async {
    final jsonString = _sharedPreferences.getString(_userKey);
    if (jsonString == null) return null;
    return userFromJson(jsonString);
  }

  @override
  Future<void> clearUser() async {
    await _sharedPreferences.remove(_userKey);
  }
}

String userToJson(UserModel user) {
  return '${user.uid}|${user.displayName}|${user.email}|${user.photoUrl ?? ''}';
}

UserModel userFromJson(String json) {
  final parts = json.split('|');
  return UserModel(
    uid: parts[0],
    displayName: parts[1],
    email: parts[2],
    photoUrl: parts[3].isEmpty ? null : parts[3],
  );
}
