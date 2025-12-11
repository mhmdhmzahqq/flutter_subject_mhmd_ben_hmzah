import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class ProfileFileStorage {
  static const String _fileName = 'profile_data.json';

  /// الحصول على ملف البيانات
  Future<File> _getProfileFile() async {
    final dir = await getApplicationDocumentsDirectory();
    final path = '${dir.path}/$_fileName';
    return File(path);
  }

  /// حفظ البيانات
  Future<void> saveProfile({
    required String fullName,
    required String city,
    required String jobTitle,
  }) async {
    try {
      final file = await _getProfileFile();
      final data = {'fullName': fullName, 'city': city, 'jobTitle': jobTitle};
      await file.writeAsString(jsonEncode(data));
    } catch (e) {
      print('Error saving profile: $e');
    }
  }

  /// قراءة البيانات
  Future<Map<String, String>?> loadProfile() async {
    try {
      final file = await _getProfileFile();
      if (!await file.exists()) return null;

      final content = await file.readAsString();
      if (content.isEmpty) return null;

      final Map<String, dynamic> jsonMap = jsonDecode(content);

      return {
        'fullName': jsonMap['fullName']?.toString() ?? '',
        'city': jsonMap['city']?.toString() ?? '',
        'jobTitle': jsonMap['jobTitle']?.toString() ?? '',
      };
    } catch (e) {
      print('Error loading profile: $e');
      return null;
    }
  }

  /// حذف الملف
  Future<void> clearProfile() async {
    try {
      final file = await _getProfileFile();
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      print('Error deleting profile: $e');
    }
  }
}
