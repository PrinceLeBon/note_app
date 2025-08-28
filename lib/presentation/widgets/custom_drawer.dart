import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/presentation/widgets/gap.dart';
import '../../business_logic/cubit/users/user_cubit.dart';
import '../../data/models/user.dart';
import '../../utils/constants.dart';
import 'google_text.dart';
import '../screens/profile.dart';
import '../screens/settings.dart';

class CustomDrawer extends StatelessWidget {
  final UserModel user;

  const CustomDrawer({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            // Header section with user info
            Container(
              padding: const EdgeInsets.all(16),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              ),
              child: Column(
                children: [
                  ClipOval(
                    child: (user.photo.isNotEmpty)
                        ? CachedNetworkImage(
                            imageUrl: user.photo,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                            errorWidget: (context, url, error) => _buildDefaultAvatar(context),
                          )
                        : _buildDefaultAvatar(context),
                  ),
                  const Gap(horizontalAlign: false, gap: 10),
                  GoogleText(
                    text: "${user.prenom} ${user.nom}",
                    fontSize: 18,
                    fontWeight: true,
                  ),
                  GoogleText(
                    text: user.email,
                    fontSize: 14,
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                ],
              ),
            ),
            
            // Menu items
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  _buildDrawerItem(
                    context: context,
                    icon: Icons.person_outline,
                    title: "Mon Profil",
                    onTap: () async {
                      Navigator.pop(context); // Close drawer
                      final updatedUser = await Navigator.push<UserModel>(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfilePage(user: user),
                        ),
                      );
                      // The homepage will be rebuilt if user is updated
                    },
                  ),
                  _buildDrawerItem(
                    context: context,
                    icon: Icons.settings_outlined,
                    title: "Paramètres",
                    onTap: () {
                      Navigator.pop(context); // Close drawer
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SettingsPage(),
                        ),
                      );
                    },
                  ),
                  const Divider(),
                  _buildDrawerItem(
                    context: context,
                    icon: Icons.logout,
                    title: "Déconnexion",
                    onTap: () {
                      Navigator.pop(context); // Close drawer
                      context.read<UserCubit>().logout();
                    },
                    color: Colors.red,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultAvatar(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.person,
        size: 40,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Widget _buildDrawerItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? color,
  }) {
    final itemColor = color ?? Theme.of(context).iconTheme.color;
    
    return ListTile(
      leading: Icon(
        icon,
        color: itemColor,
      ),
      title: GoogleText(
        text: title,
        fontSize: 16,
        color: itemColor,
      ),
      onTap: onTap,
    );
  }
}
