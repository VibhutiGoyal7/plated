import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:Payrio/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/response/profileResponse.dart';
import '../model/response/setUpAccountResponse.dart';

class Helper {
  static String valueSharedPreferences = '';
  static String pref_token = 'token';
  static String biometricPref = 'biometricPref';
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

// Write DATA
  static Future<bool> saveBiometric(isEnable) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setBool(biometricPref, isEnable);
  }

// Read Data
  static Future<bool?> getBiometric() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool(biometricPref);
  }

  static Future<bool> savePassword(token) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setString("Password", token);
  }

  // Read Data
  static Future<String?> getPassword() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString("Password");
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
    return ProfileResponse.fromPref(ProfileDetailMap);  }


  static Future<bool> saveUserDetails(_UserDetail) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final String UserDetailJson = jsonEncode(_UserDetail.toJson());
    return await sharedPreferences.setString("UserDetails", UserDetailJson);
  }

  // Read Data
  static Future<SetUpAccountResponse?> getUserDetails() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final String? UserDetailJson = sharedPreferences.getString("UserDetails");

    if (UserDetailJson == null) {
      return null;
    }
    final Map<String, dynamic> UserDetailMap = jsonDecode(UserDetailJson);
    return SetUpAccountResponse.fromPref(UserDetailMap);  }



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

  static Future<bool> saveCountry(token) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setString("Country", token);
  }

  // Read Data
  static Future<String?> getCountry() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString("Country");
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

  static Future<void> clearAllSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    print('All shared preferences cleared');
  }

}