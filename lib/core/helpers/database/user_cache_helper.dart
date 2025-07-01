import 'package:hive_flutter/hive_flutter.dart';
import '../../../features/profile/data/models/user_profile_model.dart';

class UserCacheHelper {
  static const String _userBoxName = 'user_box';
  static const String _tokenKey = 'user_token';
  static const String _isLoggedInKey = 'is_logged_in';

  late Box<UserProfileModel> _userBox;
  late Box _settingsBox;

  // Initialize Hive and open boxes
  Future<void> init() async {
    await Hive.initFlutter();

    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(UserProfileModelAdapter());
    }

    _userBox = await Hive.openBox<UserProfileModel>(_userBoxName);
    _settingsBox = await Hive.openBox('settings_box');
  }

  // Save user profile to cache
  Future<void> saveUserProfile(UserProfileModel userProfile) async {
    await _userBox.put('current_user', userProfile);
  }

  // Get user profile from cache
  UserProfileModel? getUserProfile() {
    return _userBox.get('current_user');
  }

  // Get current user profile (alias for getUserProfile)
  UserProfileModel? getCurrentUser() {
    return getUserProfile();
  }

  // Check if user profile exists and is valid
  bool hasValidUserProfile() {
    final userProfile = getUserProfile();
    return userProfile != null &&
        userProfile.firstName != null &&
        userProfile.firstName!.isNotEmpty;
  }

  // Save user token
  Future<void> saveUserToken(String token) async {
    await _settingsBox.put(_tokenKey, token);
  }

  // Get user token
  String? getUserToken() {
    return _settingsBox.get(_tokenKey);
  }

  // Save login status
  Future<void> setLoggedIn(bool isLoggedIn) async {
    await _settingsBox.put(_isLoggedInKey, isLoggedIn);
  }

  // Check if user is logged in
  bool isLoggedIn() {
    return _settingsBox.get(_isLoggedInKey, defaultValue: false);
  }

  // Clear all user data
  Future<void> clearUserData() async {
    await _userBox.clear();
    await _settingsBox.clear();
  }

  // Check if user profile exists in cache
  bool hasUserProfile() {
    return _userBox.containsKey('current_user');
  }

  // Get user name from cache
  String? getUserName() {
    final userProfile = getUserProfile();
    if (userProfile != null) {
      return '${userProfile.firstName} ${userProfile.lastName}';
    }
    return null;
  }

  // Get user email from cache
  String? getUserEmail() {
    final userProfile = getUserProfile();
    return userProfile?.email;
  }

  // Get user profile image from cache
  String? getUserProfileImage() {
    final userProfile = getUserProfile();
    return userProfile?.userProfileImageUrl;
  }

  // Close Hive boxes
  Future<void> close() async {
    await _userBox.close();
    await _settingsBox.close();
  }
}
