import 'dart:convert';

import 'package:Payrio/model/response/checkCustomerReponse.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/response/countryListResponse.dart';
import '../model/response/profileResponse.dart';
import '../model/response/setUpAccountResponse.dart';

class Helper {
  static String valueSharedPreferences = '';
  static String pref_token = 'token';
  static String pref_device_token = 'device_token';
  static String biometricPref = 'biometricPref';
  static String isAuthenticatedPref = 'isAuthenticatedPref';
  static String userBalancePref = 'UserBalance';
  static String userId = 'UserId';
  static String currencySymbolPref = 'CurrencySymbol';
  static String userDetailsPref = 'UserDetails';
  static String countryPref = 'Country';
  static String kycStatusPref = 'KycStatus';
  static String passwordPref = 'Password';
  static String recentP2PPref = 'RecentP2P';
  static String countryList = 'CountryList';
  static String profileDetailPref = 'ProfileDetail';
  static const String prefSelectedLanguageCode = "SelectedLanguageCode";
  static const String prefRecentDocument = "RecentDocument";

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
  static Future<bool> saveDeviceToken(token) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setString(pref_device_token, token);
  }

  // Read Data
  static Future<String?> getDeviceToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(pref_device_token);
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

  // Write DATA
  static Future<bool> saveUserAuthenticated(isAuthenticated) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setBool(isAuthenticatedPref, isAuthenticated);
  }

  // Read Data
  static Future<bool?> getUserAuthenticated() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool(isAuthenticatedPref);
  }

  static Future<bool> savePassword(token) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setString(passwordPref, token);
  }

  // Read Data
  static Future<String?> getPassword() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(passwordPref);
  }

  static Future<bool> saveUserBalance(token) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setString(userBalancePref, token);
  }

  // Read Data
  static Future<String?> getUserBalance() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(userBalancePref);
  }


  static Future<bool> saveUserId(token) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setString(userId, token);
  }

  // Read Data
  static Future<String?> getUserId() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(userId);
  }

  static Future<bool> saveCurrencySymbol(token) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setString(currencySymbolPref, token);
  }

  // Read Data
  static Future<String?> getCurrencySymbol() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(currencySymbolPref);
  }

  static Future<bool> saveProfileDetails(_ProfileDetail) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final String ProfileDetailJson = jsonEncode(_ProfileDetail.toJson());
    return await sharedPreferences.setString(
        profileDetailPref, ProfileDetailJson);
  }

// Read Data
  static Future<ProfileResponse?> getProfileDetails() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final String? ProfileDetailJson =
        sharedPreferences.getString(profileDetailPref);

    if (ProfileDetailJson == null) {
      return null;
    }
    final Map<String, dynamic> ProfileDetailMap = jsonDecode(ProfileDetailJson);
    return ProfileResponse.fromPref(ProfileDetailMap);
  }

  static Future<bool> saveRecentP2PDetails(_RecentP2P) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    List<String> RecentP2PJson = _RecentP2P.map<String>(
        (CheckCustomerResponse user) => user.toJsonString()).toList();
    print("helper save ${RecentP2PJson}");
    return await sharedPreferences.setStringList(recentP2PPref, RecentP2PJson);
  }

// Read Data
  static Future<List<CheckCustomerResponse>?> getRecentP2PDetails() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final List<String>? jsonList =
        sharedPreferences.getStringList(recentP2PPref);

    if (jsonList == null) {
      return null;
    }
    // final Map<String, dynamic> ProfileDetailMap = jsonDecode(jso);
    return jsonList.map<CheckCustomerResponse>((String jsonItem) {
      CheckCustomerResponse response;
      try {
        response = CheckCustomerResponse.fromJsonString(jsonItem);
        // Debugging: Print each CheckCustomerResponse object
        print('JSON to Response: ${response.imageUrl}');
      } catch (e) {
        print('Error parsing JSON item: $jsonItem');
        print('Error: $e');
        response = CheckCustomerResponse(username: 'Error');
      }
      return response;
    }).toList();
  }

  static Future<bool> saveCountryList(_RecentP2P) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    List<String> RecentP2PJson = _RecentP2P.map<String>(
        (CountryData user) => user.toJsonString()).toList();
    print("helper save ${RecentP2PJson}");
    return await sharedPreferences.setStringList(countryList, RecentP2PJson);
  }

// Read Data
  static Future<List<CountryData>?> getCountryList() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final List<String>? jsonList =
        sharedPreferences.getStringList(countryList);

    if (jsonList == null) {
      return null;
    }
    // final Map<String, dynamic> ProfileDetailMap = jsonDecode(jso);
    return jsonList.map<CountryData>((String jsonItem) {
      CountryData response;
      try {
        response = CountryData.fromJsonString(jsonItem);
        // Debugging: Print each CheckCustomerResponse object
        print('JSON to Response: ${response.flagImageUrl}');
      } catch (e) {
        print('Error parsing JSON item: $jsonItem');
        print('Error: $e');
        response = CountryData(name: 'Error');
      }
      return response;
    }).toList();
  }

  static Future<bool> saveUserDetails(_UserDetail) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final String UserDetailJson = jsonEncode(_UserDetail.toJson());
    return await sharedPreferences.setString(userDetailsPref, UserDetailJson);
  }

  // Read Data
  static Future<SetUpAccountResponse?> getUserDetails() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final String? UserDetailJson = sharedPreferences.getString(userDetailsPref);

    if (UserDetailJson == null) {
      return null;
    }
    final Map<String, dynamic> UserDetailMap = jsonDecode(UserDetailJson);
    return SetUpAccountResponse.fromPref(UserDetailMap);
  }

  static Future<Locale> setLocale(_languageCode) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    await _prefs.setString(prefSelectedLanguageCode, _languageCode);
    return _locale(_languageCode);
  }

  static Future<Locale> getLocale() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String languageCode = _prefs.getString(prefSelectedLanguageCode) ?? "en";
    return _locale(languageCode);
  }

  static Future<bool> saveCountry(token) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setString(countryPref, token);
  }

  // Read Data
  static Future<String?> getCountry() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(countryPref);
  }

  static Future<bool> saveKycStatus(token) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setString(kycStatusPref, token);
  }

  // Recent Document Read Data
  static Future<DocumentDetail?> getRecentDocument() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final String? recentDocumentJson = sharedPreferences.getString(prefRecentDocument);

    if (recentDocumentJson == null) {
      return null;
    }
    final Map<String, dynamic> recentDocumentMap = jsonDecode(recentDocumentJson);
    return DocumentDetail.fromJson(recentDocumentMap);
  }

  static Future<bool> saveRecentDocument(documentDetail) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final String documentDetailJson = jsonEncode(documentDetail.toJson());
    return await sharedPreferences.setString(prefRecentDocument, documentDetailJson);
  }

  // Read Data
  static Future<String?> getKycStatus() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(kycStatusPref);
  }

  static Locale _locale(String languageCode) {
    return languageCode != null && languageCode.isNotEmpty
        ? Locale(languageCode, '')
        : Locale('en', '');
  }

  static void changeLanguage(
      BuildContext context, String selectedLanguageCode) async {
    var _locale = await setLocale(selectedLanguageCode);
    //_MyAPp.setLocale(context, _locale);
  }

  static Future<void> clearAllSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    List<CheckCustomerResponse>? list = [];
    List<CountryData>? countryList = [];
    //await prefs.clear();
    await saveUserToken("");
    await saveBiometric(false);
    await saveUserAuthenticated(false);
    await saveUserBalance("");
    await saveCurrencySymbol("");
    await saveRecentP2PDetails(list);
    await saveCountryList(countryList);
    //await saveUserDetails(null);
    await saveCountry("");
    await saveKycStatus("");
    await setLocale("");
    print('All shared preferences cleared');
  }
}
