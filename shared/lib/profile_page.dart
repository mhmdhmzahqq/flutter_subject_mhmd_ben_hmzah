import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePreviewPage extends StatefulWidget {
  const ProfilePreviewPage({super.key});

  @override
  State<ProfilePreviewPage> createState() => _ProfilePreviewPageState();
}

class _ProfilePreviewPageState extends State<ProfilePreviewPage> {
  String fullName = 'لم يتم الحفظ';
  String city = 'لم يتم الحفظ';
  String jobTitle = 'لم يتم الحفظ';

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      fullName = prefs.getString('full_name') ?? 'لم يتم الحفظ';
      city = prefs.getString('city') ?? 'لم يتم الحفظ';
      jobTitle = prefs.getString('job_title') ?? 'لم يتم الحفظ';
    });
  }

  Future<void> _clearProfile() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('full_name');
    await prefs.remove('city');
    await prefs.remove('job_title');

    setState(() {
      fullName = 'لم يتم الحفظ';
      city = 'لم يتم الحفظ';
      jobTitle = 'لم يتم الحفظ';
    });

    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('تم مسح البيانات ✨')));
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
      appBar: AppBar(title: const Text('البيانات المحفوظة'), centerTitle: true),
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
              label: const Text('مسح كل البيانات'),
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
