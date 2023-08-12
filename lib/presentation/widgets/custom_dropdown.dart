import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomDropDown extends StatelessWidget {
  final List<String> list;

  const CustomDropDown({super.key, required this.list});

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
        "Selectionnez le hashtag",
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w300,
          color: const Color(0xff848181),
        ),
      ),
      onChanged: (e) {
        /*setState(() {
          widget.controller?.text = e!;
        });
        widget.getSelectedValue!(e!);*/
      },
      isExpanded: true,
      borderRadius: BorderRadius.circular(6.0),
      items: list
          .map(
            (e) => DropdownMenuItem<String>(
              value: e,
              child: Text(e),
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
