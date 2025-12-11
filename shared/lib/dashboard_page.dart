import 'package:flutter/material.dart';
import 'package:shared/profile_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardPage extends StatefulWidget {
  final bool isDarkMode;
  final Future<void> Function(bool) onThemeChanged;

  const DashboardPage({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController jobTitleController = TextEditingController();

  @override
  void dispose() {
    fullNameController.dispose();
    cityController.dispose();
    jobTitleController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('full_name', fullNameController.text.trim());
    await prefs.setString('city', cityController.text.trim());
    await prefs.setString('job_title', jobTitleController.text.trim());

    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('تم حفظ البيانات 😎')));
  }

  void _goToPreview() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const ProfilePreviewPage()));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: const Text('لوحة الملف الشخصي'),
        centerTitle: true,
        actions: [
          Row(
            children: [
              const Icon(Icons.light_mode),
              Switch(
                value: isDark,
                onChanged: (value) => widget.onThemeChanged(value),
              ),
              const Icon(Icons.dark_mode),
              const SizedBox(width: 8),
            ],
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.1),
              Theme.of(context).colorScheme.secondary.withOpacity(0.05),
            ],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.account_circle,
                      size: 64,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'بيانات حسابك',
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
                            label: const Text('حفظ'),
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
