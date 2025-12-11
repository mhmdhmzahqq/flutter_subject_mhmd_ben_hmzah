import 'package:file/profile_file_storage.dart';
import 'package:file/profile_page.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController jobTitleController = TextEditingController();

  final ProfileFileStorage _storage = ProfileFileStorage();

  @override
  void dispose() {
    fullNameController.dispose();
    cityController.dispose();
    jobTitleController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    await _storage.saveProfile(
      fullName: fullNameController.text.trim(),
      city: cityController.text.trim(),
      jobTitle: jobTitleController.text.trim(),
    );

    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('تم حفظ البيانات في ملف 📁')));
  }

  void _goToPreview() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const ProfilePreviewPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('لوحة البيانات (File Handling)'),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: SingleChildScrollView(
            child: Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.folder,
                      size: 64,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'ادخل بيانات الملف الشخصي',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildTextField(
                      controller: fullNameController,
                      label: 'الاسم الكامل',
                      icon: Icons.person_outline,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: cityController,
                      label: 'المدينة',
                      icon: Icons.location_city_outlined,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: jobTitleController,
                      label: 'المسمى الوظيفي',
                      icon: Icons.work_outline,
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: _saveProfile,
                            icon: const Icon(Icons.save),
                            label: const Text('حفظ في الملف'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _goToPreview,
                            icon: const Icon(Icons.visibility),
                            label: const Text('عرض البيانات'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      textDirection: TextDirection.rtl,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
