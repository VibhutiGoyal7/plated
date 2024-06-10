import 'dart:convert';

import 'package:mvvm_flutter_app/model/profileResponse.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Helper {
  static String valueSharedPreferences = '';
  static String pref_token = 'token';

// Write DATA
  static Future<bool> saveUserToken(token) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setString(pref_token, token);
  }

// Read Data
  static Future<String?> getUserToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(pref_token);
  }

  static Future<bool> saveProfileDetails(_ProfileDetail) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final String ProfileDetailJson = jsonEncode(_ProfileDetail.toJson());
    return await sharedPreferences.setString("ProfileDetail", ProfileDetailJson);
  }

// Read Data
  static Future<ProfileResponse?> getProfileDetails() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final String? ProfileDetailJson = sharedPreferences.getString("ProfileDetail");

    if (ProfileDetailJson == null) {
      return null;
    }

    final Map<String, dynamic> ProfileDetailMap = jsonDecode(ProfileDetailJson);
    return ProfileResponse.fromJson(ProfileDetailMap);  }
}