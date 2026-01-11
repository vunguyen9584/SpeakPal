import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/profile_provider.dart';
import '../widgets/settings_section.dart';
import '../widgets/settings_tile.dart';
import '../../../../core/providers/providers.dart';
import '../../../../config/env/app_config.dart';

/// Settings Screen
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  double _aiSpeed = 1.0;
  bool _confirmationMode = false;
  bool _darkMode = false;
  bool _pushNotifications = true;
  TimeOfDay? _dailyReminderTime;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = ref.read(sharedPreferencesProvider);
    final hour = prefs.getInt('daily_reminder_hour');
    final minute = prefs.getInt('daily_reminder_minute');
    if (hour != null && minute != null) {
      setState(() {
         _dailyReminderTime = TimeOfDay(hour: hour, minute: minute);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // final currentUser = ref.watch(currentUserProvider);

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
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Language selection locked to English')),
                    );
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
                  subtitle: _dailyReminderTime?.format(context) ?? 'Not set',
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () async {
                    final selectedTime = await showTimePicker(
                      context: context,
                      initialTime: _dailyReminderTime ?? TimeOfDay.now(),
                    );
                    if (selectedTime != null) {
                      final prefs = ref.read(sharedPreferencesProvider);
                      await prefs.setInt('daily_reminder_hour', selectedTime.hour);
                      await prefs.setInt('daily_reminder_minute', selectedTime.minute);
                      
                      setState(() {
                        _dailyReminderTime = selectedTime;
                      });
                      
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Reminder set for ${selectedTime.format(context)}')),
                        );
                      }
                    }
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
                    _showChangePasswordDialog(context);
                  },
                ),
                SettingsTile(
                  icon: Icons.delete_forever,
                  title: 'Delete Account',
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () async {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Delete Account'),
                        content: const Text(
                          'Are you sure? This action cannot be undone and will permanently delete your data.',
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
                    if (confirmed == true && context.mounted) {
                       final repository = ref.read(profileRepositoryProvider);
                       final result = await repository.deleteAccount();

                       if (context.mounted) {
                           result.fold(
                             (error) => ScaffoldMessenger.of(context).showSnackBar(
                               SnackBar(content: Text(error.message)),
                             ),
                             (_) {
                               // Logout and navigate to login
                               ref.read(authStateProvider.notifier).logout();
                               context.go('/login');
                             },
                           );
                       }
                    }
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
                    context.push('/terms-of-service');
                  },
                ),
                SettingsTile(
                  icon: Icons.privacy_tip,
                  title: 'Privacy Policy',
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    context.push('/privacy-policy');
                  },
                ),
                SettingsTile(
                  icon: Icons.support,
                  title: 'Contact Support',
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () async {
                    final Uri emailLaunchUri = Uri(
                      scheme: 'mailto',
                      path: AppConfig.supportEmail,
                      queryParameters: {
                        'subject': 'Support Request from ${AppConfig.appName}',
                        'body': 'App Version: ${AppConfig.appVersion}\n\nProblem description:',
                      },
                    );
                    
                    if (await canLaunchUrl(emailLaunchUri)) {
                       await launchUrl(emailLaunchUri);
                    } else {
                       if (context.mounted) {
                         ScaffoldMessenger.of(context).showSnackBar(
                           const SnackBar(content: Text('Could not launch email client')),
                         );
                       }
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  void _showChangePasswordDialog(BuildContext context) {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    bool isLoading = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Change Password'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: currentPasswordController,
                  decoration: const InputDecoration(labelText: 'Current Password'),
                  obscureText: true,
                  validator: (v) => v?.isEmpty == true ? 'Required' : null,
                ),
                TextFormField(
                  controller: newPasswordController,
                  decoration: const InputDecoration(labelText: 'New Password'),
                  obscureText: true,
                  validator: (v) => (v?.length ?? 0) < 6 ? 'Min 6 characters' : null,
                ),
              ],
            ),
          ),
          actions: [
             TextButton(
               onPressed: isLoading ? null : () => Navigator.pop(context),
               child: const Text('Cancel'),
             ),
             AppButton(
               text: 'Update',
               isLoading: isLoading,
               onPressed: () async {
                 if (formKey.currentState?.validate() == true) {
                   setState(() => isLoading = true);
                   final repository = ref.read(profileRepositoryProvider);
                   final result = await repository.changePassword(
                     currentPassword: currentPasswordController.text,
                     newPassword: newPasswordController.text,
                   );
                   
                   if (context.mounted) {
                     setState(() => isLoading = false);
                     result.fold(
                       (error) {
                         ScaffoldMessenger.of(context).showSnackBar(
                           SnackBar(content: Text(error.message)),
                         );
                       },
                       (_) {
                         Navigator.pop(context);
                         ScaffoldMessenger.of(context).showSnackBar(
                           const SnackBar(
                             content: Text('Password updated successfully'),
                             backgroundColor: Colors.green,
                           ),
                         );
                       },
                     );
                   }
                 }
               },
             ),
          ],
        ),
      ),
    );
  }
}

