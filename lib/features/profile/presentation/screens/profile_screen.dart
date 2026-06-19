import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orderease/core/localization/l10n/app_localizations.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';
import '../../domain/entities/profile_entity.dart';
import '../../../../core/theme/theme_cubit.dart';
import '../../../../core/localization/locale_cubit.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(const LoadProfileEvent());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final authState = context.watch<AuthBloc>().state;
    String userName = '';
    String userEmail = '';
    String? photoUrl;
    if (authState is AuthAuthenticated) {
      userName = authState.user.displayName;
      userEmail = authState.user.email;
      photoUrl = authState.user.photoUrl;
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F9F7),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Color(0xFF1E6F5C)),
          onPressed: () {},
        ),
        title: Text(
          l10n.profileTitle,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Color(0xFF1E6F5C),
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined, color: Color(0xFF1E6F5C)),
            onPressed: () {},
          ),
        ],
      ),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProfileLoadedState) {
            final profile = state.profile;
            return ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              children: [
                // Profile Header Card
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 36,
                            backgroundColor: const Color(0xFFEFF1EE),
                            backgroundImage: photoUrl != null && photoUrl.isNotEmpty ? NetworkImage(photoUrl) : null,
                            child: photoUrl == null || photoUrl.isEmpty
                                ? const Icon(Icons.person, size: 36, color: Color(0xFF757575))
                                : null,
                          ),
                          Positioned(
                            bottom: 2,
                            right: 2,
                            child: Container(
                              width: 14,
                              height: 14,
                              decoration: BoxDecoration(
                                color: const Color(0xFF2E7D32),
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userName.isEmpty ? 'Ramesh Sharma' : userName,
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1A302B)),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(Icons.email_outlined, size: 16, color: Colors.grey),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    userEmail.isEmpty ? 'ramesh@gmail.com' : userEmail,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Shop Name Card
                _buildInfoCard(
                  icon: Icons.storefront_outlined,
                  title: l10n.shopNameLabel,
                  value: profile.shopName,
                  onEdit: () => _editShopName(context, profile),
                ),
                const SizedBox(height: 12),

                // Primary Supplier Card
                _buildInfoCard(
                  icon: Icons.local_shipping_outlined,
                  title: l10n.supplierPhoneLabel,
                  value: profile.supplierPhone.isEmpty ? 'Not set' : profile.supplierPhone,
                  onEdit: () => _editSupplierPhone(context, profile),
                ),
                const SizedBox(height: 20),

                // Preferences Title
                Text(
                  l10n.localeName == 'hi' ? 'प्राथमिकताएं' : 'Preferences',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A302B),
                  ),
                ),
                const SizedBox(height: 10),

                // Language Card
                _buildPreferenceCard(
                  icon: Icons.language,
                  title: l10n.localeName == 'hi' ? 'भाषा' : 'Language',
                  trailing: CustomSegmentedToggle<String>(
                    options: const ['en', 'hi'],
                    selectedOption: profile.languageCode,
                    onChanged: (code) {
                      context.read<LocaleCubit>().setLocale(code);
                      context.read<ProfileBloc>().add(UpdateProfileEvent(
                            profile: ProfileEntity(
                              shopName: profile.shopName,
                              supplierPhone: profile.supplierPhone,
                              languageCode: code,
                              themeMode: profile.themeMode,
                            ),
                          ));
                    },
                    builder: (code, isSelected) {
                      return Text(
                        code == 'en' ? 'EN' : 'हि',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? const Color(0xFF1E6F5C) : const Color(0xFF757575),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),

                // Theme Card
                _buildPreferenceCard(
                  icon: Icons.palette_outlined,
                  title: l10n.localeName == 'hi' ? 'थीम' : 'Theme',
                  trailing: CustomSegmentedToggle<String>(
                    options: const ['light', 'dark'],
                    selectedOption: profile.themeMode,
                    onChanged: (themeVal) {
                      context.read<ThemeCubit>().toggleTheme();
                      context.read<ProfileBloc>().add(UpdateProfileEvent(
                            profile: ProfileEntity(
                              shopName: profile.shopName,
                              supplierPhone: profile.supplierPhone,
                              languageCode: profile.languageCode,
                              themeMode: themeVal,
                            ),
                          ));
                    },
                    builder: (themeVal, isSelected) {
                      final isLight = themeVal == 'light';
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isLight ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                            size: 15,
                            color: isSelected ? const Color(0xFF1E6F5C) : const Color(0xFF757575),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            isLight ? 'Light' : 'Dark',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? const Color(0xFF1E6F5C) : const Color(0xFF757575),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(height: 28),

                // Sign Out Button
                GestureDetector(
                  onTap: () {
                    context.read<AuthBloc>().add(const SignOutRequested());
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFEBEE),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFFEBEE).withOpacity(0.4),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.logout, color: Color(0xFFD32F2F)),
                        const SizedBox(width: 8),
                        Text(
                          l10n.signOutButton,
                          style: const TextStyle(
                            color: Color(0xFFD32F2F),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            );
          }
          return const Center(child: Text('Press refresh.'));
        },
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback onEdit,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F3F0),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFF757575), size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A302B),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: Colors.grey),
            onPressed: onEdit,
          ),
        ],
      ),
    );
  }

  Widget _buildPreferenceCard({
    required IconData icon,
    required String title,
    required Widget trailing,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF757575), size: 22),
              const SizedBox(width: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A302B),
                ),
              ),
            ],
          ),
          trailing,
        ],
      ),
    );
  }

  void _editShopName(BuildContext context, ProfileEntity profile) {
    final l10n = AppLocalizations.of(context)!;
    final controller = TextEditingController(text: profile.shopName);
    showDialog(
      context: context,
      builder: (dCtx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(l10n.localeName == 'hi' ? 'दुकान का नाम संपादित करें' : 'Edit Shop Name', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A302B))),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: l10n.localeName == 'hi' ? 'दुकान का नाम दर्ज करें' : 'Enter Shop Name',
            fillColor: const Color(0xFFF1F3F0),
            filled: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dCtx),
            child: Text(l10n.cancelButton, style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1E6F5C),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              context.read<ProfileBloc>().add(UpdateProfileEvent(
                    profile: ProfileEntity(
                      shopName: controller.text,
                      supplierPhone: profile.supplierPhone,
                      languageCode: profile.languageCode,
                      themeMode: profile.themeMode,
                    ),
                  ));
              Navigator.pop(dCtx);
            },
            child: Text(l10n.localeName == 'hi' ? 'सहेजें' : 'Save', style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _editSupplierPhone(BuildContext context, ProfileEntity profile) {
    final l10n = AppLocalizations.of(context)!;
    final controller = TextEditingController(text: profile.supplierPhone);
    showDialog(
      context: context,
      builder: (dCtx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(l10n.localeName == 'hi' ? 'सप्लायर का व्हाट्सएप नंबर संपादित करें' : 'Edit Supplier WhatsApp', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A302B))),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            hintText: '+91xxxxxxxxxx',
            fillColor: const Color(0xFFF1F3F0),
            filled: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dCtx),
            child: Text(l10n.cancelButton, style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1E6F5C),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              context.read<ProfileBloc>().add(UpdateProfileEvent(
                    profile: ProfileEntity(
                      shopName: profile.shopName,
                      supplierPhone: controller.text,
                      languageCode: profile.languageCode,
                      themeMode: profile.themeMode,
                    ),
                  ));
              Navigator.pop(dCtx);
            },
            child: Text(l10n.localeName == 'hi' ? 'सहेजें' : 'Save', style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

class CustomSegmentedToggle<T> extends StatelessWidget {
  const CustomSegmentedToggle({
    super.key,
    required this.options,
    required this.selectedOption,
    required this.onChanged,
    required this.builder,
  });

  final List<T> options;
  final T selectedOption;
  final ValueChanged<T> onChanged;
  final Widget Function(T option, bool isSelected) builder;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF1EE),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: options.map((opt) {
          final isSelected = opt == selectedOption;
          return GestureDetector(
            onTap: () => onChanged(opt),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        )
                      ]
                    : null,
              ),
              child: builder(opt, isSelected),
            ),
          );
        }).toList(),
      ),
    );
  }
}
