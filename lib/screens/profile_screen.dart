// lib/screens/profile_screen.dart

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/theme_provider.dart';
import 'login_screen.dart';
import 'reading_list_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _username = 'Reader...';
  DateTime? _lastUsernameChangeDate;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    String? storedUsername = prefs.getString('username');

    if (storedUsername == null || storedUsername.isEmpty) {
      storedUsername = 'Reader${Random().nextInt(9000) + 1000}';
      await prefs.setString('username', storedUsername);
    }

    final int? lastChangeTimestamp = prefs.getInt('lastUsernameChange');
    if (lastChangeTimestamp != null) {
      _lastUsernameChangeDate =
          DateTime.fromMillisecondsSinceEpoch(lastChangeTimestamp);
    }

    if (mounted) {
      setState(() {
        _username = storedUsername!;
        _isLoading = false;
      });
    }
  }

  Future<void> _showChangeUsernameDialog() async {
    if (_lastUsernameChangeDate != null) {
      final difference = DateTime.now().difference(_lastUsernameChangeDate!);
      if (difference.inDays < 60) {
        final daysLeft = 60 - difference.inDays;
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'You can change your username again in $daysLeft days.')),
        );
        return;
      }
    }

    final newUsernameController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    final theme = Theme.of(context);

    final bool? wasUsernameChanged = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: theme.colorScheme.surface,
        title: Text('Change Username',
            style: GoogleFonts.exo2(fontWeight: FontWeight.bold)),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: newUsernameController,
            decoration: const InputDecoration(hintText: "Enter new username"),
            validator: (value) {
              if (value == null || value.trim().isEmpty)
                return 'Username cannot be empty.';
              if (value.length < 3)
                return 'Username must be at least 3 characters.';
              return null;
            },
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                final newUsername = newUsernameController.text.trim();
                final prefs = await SharedPreferences.getInstance();
                await prefs.setString('username', newUsername);
                await prefs.setInt('lastUsernameChange',
                    DateTime.now().millisecondsSinceEpoch);

                if (!mounted) return;
                Navigator.pop(dialogContext, true);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (wasUsernameChanged == true) {
      await _loadProfileData();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Username updated successfully!')),
      );
    }
  }

  Future<void> _showLogoutDialog() async {
    if (!mounted) return;
    final theme = Theme.of(context);
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: theme.colorScheme.surface,
        title: Text('Log Out',
            style: GoogleFonts.exo2(fontWeight: FontWeight.bold)),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
            ),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Log Out'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _logout();
    }
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);

    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (Route<dynamic> route) => false,
    );
  }

  Future<void> _showDeleteAccountDialog() async {
    if (!mounted) return;
    final theme = Theme.of(context);
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: theme.colorScheme.surface,
        title: Text('Delete Account',
            style: GoogleFonts.exo2(fontWeight: FontWeight.bold)),
        content: const Text(
            'Are you sure you want to delete your account? This action is irreversible.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.error),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _logout();
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile',
            style: GoogleFonts.orbitron(
                fontSize: 22, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 100.0),
              children: [
                _buildHeader(context),
                const SizedBox(height: 24),
                _buildSectionTitle('Settings'),
                _buildThemeToggle(isDarkMode, themeProvider),
                _buildListTile(
                  icon: Icons.bookmark_border_outlined,
                  title: 'My Reading List',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ReadingListScreen()),
                    );
                  },
                ),
                const Divider(),
                _buildSectionTitle('Information'),
                _buildListTile(
                    icon: Icons.notifications_none_outlined,
                    title: 'Notices',
                    onTap: () {}),
                _buildListTile(
                    icon: Icons.shield_outlined,
                    title: 'Privacy Policy',
                    onTap: () {}),
                _buildListTile(
                    icon: Icons.description_outlined,
                    title: 'Disclaimer',
                    onTap: () {}),
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: Text('Version', style: GoogleFonts.exo2()),
                  trailing: const Text('1.0.0'),
                ),
                const Divider(),
                _buildListTile(
                  icon: Icons.logout,
                  title: 'Log Out',
                  color: Theme.of(context).colorScheme.primary,
                  onTap: _showLogoutDialog,
                ),
                _buildListTile(
                  icon: Icons.delete_forever_outlined,
                  title: 'Delete Account',
                  color: Theme.of(context).colorScheme.error,
                  onTap: _showDeleteAccountDialog,
                ),
              ],
            ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      color: theme.cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: _showChangeUsernameDialog,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: theme.colorScheme.primary.withAlpha(50),
                child: Text(
                  _username.isNotEmpty ? _username[0].toUpperCase() : 'R',
                  style: GoogleFonts.orbitron(
                      fontSize: 24, color: theme.colorScheme.primary),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hi, $_username 👋',
                      style: GoogleFonts.orbitron(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'Tap to change your username',
                      style: GoogleFonts.exo2(
                          color: theme.textTheme.bodySmall?.color),
                    ),
                  ],
                ),
              ),
              Icon(Icons.edit_outlined,
                  color: theme.textTheme.bodySmall?.color),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 16.0, bottom: 8.0),
      child: Text(
        title.toUpperCase(),
        style: GoogleFonts.exo2(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).textTheme.bodySmall?.color,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _buildThemeToggle(bool isDarkMode, ThemeProvider themeProvider) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      color: theme.cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Theme',
                style: GoogleFonts.exo2(
                    fontSize: 16, fontWeight: FontWeight.w500)),
            ToggleButtons(
              isSelected: [!isDarkMode, isDarkMode],
              onPressed: (index) {
                themeProvider.toggleTheme(index == 1);
              },
              borderRadius: BorderRadius.circular(8),
              selectedColor: theme.colorScheme.onPrimary,
              color: theme.colorScheme.onSurface,
              fillColor: theme.colorScheme.primary,
              borderColor: theme.dividerColor,
              selectedBorderColor: theme.colorScheme.primary,
              children: const [
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Icon(Icons.wb_sunny_outlined)),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Icon(Icons.nightlight_round)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? color,
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title,
          style: GoogleFonts.exo2(
              color: color, fontSize: 16, fontWeight: FontWeight.w500)),
      trailing: Icon(Icons.chevron_right,
          color: Theme.of(context).unselectedWidgetColor),
      onTap: onTap,
    );
  }
}
