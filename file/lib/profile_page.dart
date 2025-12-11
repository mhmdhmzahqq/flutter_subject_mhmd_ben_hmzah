import 'package:flutter/material.dart';
import 'profile_file_storage.dart';

class ProfilePreviewPage extends StatefulWidget {
  const ProfilePreviewPage({super.key});

  @override
  State<ProfilePreviewPage> createState() => _ProfilePreviewPageState();
}

class _ProfilePreviewPageState extends State<ProfilePreviewPage> {
  final ProfileFileStorage _storage = ProfileFileStorage();

  String fullName = 'لا توجد بيانات';
  String city = 'لا توجد بيانات';
  String jobTitle = 'لا توجد بيانات';

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final data = await _storage.loadProfile();

    if (!mounted) return;

    setState(() {
      if (data == null) {
        fullName = 'لا توجد بيانات محفوظة';
        city = '-';
        jobTitle = '-';
      } else {
        fullName = (data['fullName'] ?? '').isEmpty
            ? 'غير محدد'
            : data['fullName']!;
        city = (data['city'] ?? '').isEmpty ? 'غير محددة' : data['city']!;
        jobTitle = (data['jobTitle'] ?? '').isEmpty
            ? 'غير محدد'
            : data['jobTitle']!;
      }
    });
  }

  Future<void> _clearProfile() async {
    await _storage.clearProfile();

    if (!mounted) return;

    setState(() {
      fullName = 'لا توجد بيانات محفوظة';
      city = '-';
      jobTitle = '-';
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('تم مسح بيانات الملف 🗑️')));
  }

  Widget _infoTile(String title, String value, IconData icon) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(value),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('البيانات المحفوظة في الملف'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _infoTile('الاسم الكامل', fullName, Icons.person),
            _infoTile('المدينة', city, Icons.location_on),
            _infoTile('المسمى الوظيفي', jobTitle, Icons.work),
            const Spacer(),
            FilledButton.icon(
              onPressed: _clearProfile,
              icon: const Icon(Icons.delete_forever),
              label: const Text('مسح البيانات من الملف'),
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
