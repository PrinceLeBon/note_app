import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/presentation/widgets/gap.dart';
import '../../business_logic/cubit/users/user_cubit.dart';
import '../../utils/constants.dart';
import 'google_text.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocBuilder<UserCubit, UserState>(
              builder: (context, state) {
                return Column(
                  children: [
                    CircleAvatar(
                      backgroundColor: whiteColor,
                      child: (state is Logged && state.user.photo.isNotEmpty)
                          ? CachedNetworkImage(
                              imageUrl: state.user.photo,
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    const Gap(horizontalAlign: false, gap: 10),
                    GoogleText(
                        text: (state is Logged)
                            ? "${state.user.prenom} ${state.user.nom}"
                            : "")
                  ],
                );
              },
            ),
            const Gap(horizontalAlign: false, gap: 10),
            Container(
              height: 1,
              color: Colors.white,
            ),
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
