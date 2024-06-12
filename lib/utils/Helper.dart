import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:mvvm_flutter_app/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/response/profileResponse.dart';

class Helper {
  static String valueSharedPreferences = '';
  static String pref_token = 'token';
  static const String prefSelectedLanguageCode = "SelectedLanguageCode";

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


  static Future<Locale> setLocale(String languageCode) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    await _prefs.setString(prefSelectedLanguageCode, languageCode);
    return _locale(languageCode);
  }

  static Future<Locale> getLocale() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String languageCode = _prefs.getString(prefSelectedLanguageCode) ?? "en";
    return _locale(languageCode);
  }

  static Locale _locale(String languageCode) {
    return languageCode != null && languageCode.isNotEmpty
        ? Locale(languageCode, '')
        : Locale('en', '');
  }

  static void changeLanguage(BuildContext context, String selectedLanguageCode) async {
    var _locale = await setLocale(selectedLanguageCode);
    //_MyAPp.setLocale(context, _locale);
  }
}