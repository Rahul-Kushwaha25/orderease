import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Store Profile'),
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
              padding: const EdgeInsets.all(16.0),
              children: [
                const Center(
                  child: CircleAvatar(
                    radius: 50,
                    child: Icon(Icons.store, size: 50),
                  ),
                ),
                const SizedBox(height: 24),
                ListTile(
                  leading: const Icon(Icons.shop),
                  title: const Text('Shop/Dukaan Name'),
                  subtitle: Text(profile.shopName),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => _editShopName(context, profile),
                  ),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.phone),
                  title: const Text('Supplier WhatsApp Number'),
                  subtitle: Text(profile.supplierPhone.isEmpty ? 'Not set' : profile.supplierPhone),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => _editSupplierPhone(context, profile),
                  ),
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Language / भाषा', style: TextStyle(fontWeight: FontWeight.bold)),
                      SegmentedButton<String>(
                        segments: const [
                          ButtonSegment(value: 'en', label: Text('EN')),
                          ButtonSegment(value: 'hi', label: Text('हिंदी')),
                        ],
                        selected: {profile.languageCode},
                        onSelectionChanged: (val) {
                          final code = val.first;
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
                      ),
                    ],
                  ),
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Theme Mode', style: TextStyle(fontWeight: FontWeight.bold)),
                      SegmentedButton<String>(
                        segments: const [
                          ButtonSegment(value: 'light', label: Text('Light')),
                          ButtonSegment(value: 'dark', label: Text('Dark')),
                        ],
                        selected: {profile.themeMode},
                        onSelectionChanged: (val) {
                          final themeVal = val.first;
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
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
          return const Center(child: Text('Press refresh.'));
        },
      ),
    );
  }

  void _editShopName(BuildContext context, ProfileEntity profile) {
    final controller = TextEditingController(text: profile.shopName);
    showDialog(
      context: context,
      builder: (dCtx) => AlertDialog(
        title: const Text('Edit Shop Name'),
        content: TextField(controller: controller, decoration: const InputDecoration(hintText: 'Enter Shop Name')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dCtx), child: const Text('Cancel')),
          ElevatedButton(
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
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _editSupplierPhone(BuildContext context, ProfileEntity profile) {
    final controller = TextEditingController(text: profile.supplierPhone);
    showDialog(
      context: context,
      builder: (dCtx) => AlertDialog(
        title: const Text('Edit Supplier WhatsApp'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(hintText: '+91xxxxxxxxxx'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dCtx), child: const Text('Cancel')),
          ElevatedButton(
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
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
