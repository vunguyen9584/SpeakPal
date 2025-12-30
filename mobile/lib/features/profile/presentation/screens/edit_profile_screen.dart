import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/theme/dimensions.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/profile_provider.dart';

/// Edit Profile Screen
class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Initialize with current user data
    final currentUser = ref.read(currentUserProvider);
    if (currentUser != null) {
      _usernameController.text = currentUser.username ?? '';
      _emailController.text = currentUser.email;
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);
      try {
        final repository = ref.read(profileRepositoryProvider);
        final updatedUser = await repository.updateProfile(
          username: _usernameController.text.trim().isEmpty
              ? null
              : _usernameController.text.trim(),
          email: _emailController.text.trim(),
        );

        // Update auth state with new user data
        ref.read(authStateProvider.notifier).updateUser(updatedUser);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile updated successfully'),
              backgroundColor: Colors.green,
            ),
          );
          context.pop();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.toString()),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.paddingLg),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Avatar Section
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Icon(
                        Icons.person,
                        size: 50,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                          onPressed: () async {
                            // TODO: Implement image picker
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Avatar upload coming soon'),
                              ),
                            );
                          },
                          iconSize: 20,
                          padding: const EdgeInsets.all(8),
                          constraints: const BoxConstraints(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Username Field
              TextFormField(
                controller: _usernameController,
                enabled: !_isLoading,
                decoration: const InputDecoration(
                  labelText: 'Username (optional)',
                  hintText: 'Enter your username',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (value) {
                  if (value != null && value.isNotEmpty && value.length < 3) {
                    return 'Username must be at least 3 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Email Field (Read-only)
              TextFormField(
                controller: _emailController,
                enabled: false,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  hintText: 'Your email',
                  prefixIcon: Icon(Icons.email_outlined),
                  helperText: 'Email cannot be changed',
                ),
              ),
              const SizedBox(height: 32),

              // Save Button
              AppButton(
                text: 'Save Changes',
                onPressed: _handleSave,
                isLoading: _isLoading,
                isFullWidth: true,
                size: ButtonSize.large,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
