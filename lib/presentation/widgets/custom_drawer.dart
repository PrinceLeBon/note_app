import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/presentation/widgets/gap.dart';
import '../../business_logic/cubit/users/user_cubit.dart';
import '../../data/models/user.dart';
import '../../utils/constants.dart';
import 'google_text.dart';

class CustomDrawer extends StatelessWidget {
  final UserModel user;

  const CustomDrawer({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(horizontalAlign: false, gap: 10),
            Column(
              children: [
                CircleAvatar(
                  backgroundColor: whiteColor,
                  child: (user.photo.isNotEmpty)
                      ? CachedNetworkImage(
                          imageUrl: user.photo,
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                const Gap(horizontalAlign: false, gap: 10),
                GoogleText(text: "${user.prenom} ${user.nom}")
              ],
            ),
            const Gap(horizontalAlign: false, gap: 10),
            Container(
              height: 1,
              color: Colors.white,
            ),
            const Gap(horizontalAlign: false, gap: 10),
            InkWell(
              child: const GoogleText(
                text: "Déconnexion",
                fontWeight: true,
              ),
              onTap: () {
                context.read<UserCubit>().logout();
              },
            )
          ],
        ),
      )),
    );
  }
}
