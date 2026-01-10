import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../widgets/settings_section.dart';
import '../widgets/settings_tile.dart';

/// Settings Screen
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  double _aiSpeed = 1.0;
  bool _confirmationMode = false;
  bool _darkMode = false;
  bool _pushNotifications = true;

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Conversation Settings
            SettingsSection(
              title: 'Conversation',
              children: [
                SettingsTile(
                  icon: Icons.speed,
                  title: 'AI Speed',
                  subtitle: '${_aiSpeed.toStringAsFixed(1)}x',
                  trailing: SizedBox(
                    width: 200,
                    child: Slider(
                      value: _aiSpeed,
                      min: 0.5,
                      max: 2.0,
                      divisions: 15,
                      label: '${_aiSpeed.toStringAsFixed(1)}x',
                      onChanged: (value) {
                        setState(() {
                          _aiSpeed = value;
                        });
                      },
                    ),
                  ),
                ),
                SettingsTile(
                  icon: Icons.check_circle_outline,
                  title: 'Confirmation Mode',
                  subtitle: 'Confirm before sending messages',
                  trailing: Switch(
                    value: _confirmationMode,
                    onChanged: (value) {
                      setState(() {
                        _confirmationMode = value;
                      });
                    },
                  ),
                ),
              ],
            ),

            // Appearance Settings
            SettingsSection(
              title: 'Appearance',
              children: [
                SettingsTile(
                  icon: Icons.dark_mode,
                  title: 'Dark Mode',
                  subtitle: 'Use dark theme',
                  trailing: Switch(
                    value: _darkMode,
                    onChanged: (value) {
                      setState(() {
                        _darkMode = value;
                      });
                    },
                  ),
                ),
                SettingsTile(
                  icon: Icons.language,
                  title: 'Language',
                  subtitle: 'English',
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // TODO: Navigate to language selection
                  },
                ),
              ],
            ),

            // Notification Settings
            SettingsSection(
              title: 'Notifications',
              children: [
                SettingsTile(
                  icon: Icons.notifications,
                  title: 'Push Notifications',
                  subtitle: 'Receive daily reminders',
                  trailing: Switch(
                    value: _pushNotifications,
                    onChanged: (value) {
                      setState(() {
                        _pushNotifications = value;
                      });
                    },
                  ),
                ),
                SettingsTile(
                  icon: Icons.schedule,
                  title: 'Daily Reminder',
                  subtitle: '9:00 AM',
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () async {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    // TODO: Save selected time
                  },
                ),
              ],
            ),

            // Account Settings
            SettingsSection(
              title: 'Account',
              children: [
                SettingsTile(
                  icon: Icons.lock,
                  title: 'Change Password',
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // TODO: Navigate to change password
                  },
                ),
                SettingsTile(
                  icon: Icons.delete_forever,
                  title: 'Delete Account',
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Delete Account'),
                        content: const Text(
                          'Are you sure? This action cannot be undone.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.red,
                            ),
                            child: const Text('Delete'),
                          ),
                        ],
                      ),
                    );
                    // TODO: Handle account deletion
                  },
                ),
              ],
            ),

            // About Settings
            SettingsSection(
              title: 'About',
              children: [
                SettingsTile(
                  icon: Icons.info,
                  title: 'Version',
                  subtitle: '1.0.0',
                ),
                SettingsTile(
                  icon: Icons.description,
                  title: 'Terms of Service',
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // TODO: Open Terms of Service
                  },
                ),
                SettingsTile(
                  icon: Icons.privacy_tip,
                  title: 'Privacy Policy',
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // TODO: Open Privacy Policy
                  },
                ),
                SettingsTile(
                  icon: Icons.support,
                  title: 'Contact Support',
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // TODO: Open support contact
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

