import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:note_app/data/models/hashtag.dart';
import 'package:note_app/utils/constants.dart';
import '../../business_logic/cubit/hashtags/hashtag_cubit.dart';

class CustomDropDown extends StatelessWidget {
  final List<HashTag> list;
  final List<HashTag> listFiltered;

  const CustomDropDown(
      {super.key, required this.list, required this.listFiltered});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.only(
            left: 16.0,
          )),
      style: GoogleFonts.poppins(
        fontWeight: FontWeight.w400,
        fontSize: 15,
      ),
      validator: null,
      hint: Text(
        (list.isEmpty)
            ? "Liste vide, ajoutez un hashatg"
            : "Selectionnez le hashtag",
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w400,
          color: const Color(0xff848181),
        ),
      ),
      onChanged: (e) {
        context.read<HashtagCubit>().addFilteredChoice(list, listFiltered, e!);
      },
      isExpanded: true,
      borderRadius: BorderRadius.circular(6.0),
      items: list
          .map(
            (e) => DropdownMenuItem<String>(
              value: e.label,
              child: Text(
                e.label,
                style: TextStyle(color: whiteColor),
              ),
            ),
          )
          .toList(),
      iconSize: 16.0,
      icon: const Icon(
        Icons.arrow_drop_down_sharp,
      ),
    );
  }
}
