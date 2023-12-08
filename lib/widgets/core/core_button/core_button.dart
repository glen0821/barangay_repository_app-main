// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, unnecessary_new, sort_child_properties_last

import 'package:barangay_repository_app/constants/colors.dart';
import 'package:barangay_repository_app/global/responsive_sizing.dart';
import 'package:flutter/material.dart';

class CoreButton extends StatelessWidget {
  const CoreButton({super.key, required this.text, required this.onPressed});
  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    ResponsiveSizing responsiveSizing = new ResponsiveSizing(context);
    return Container(
        width: responsiveSizing.calc_width(311),
        height: responsiveSizing.calc_height(55),
        child: ElevatedButton(
          onPressed: onPressed,
          child: Text(
            text,
            style: TextStyle(color: Colors.black),
          ),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed)) {
                  return AppColors.primaryColor;
                }
                return AppColors.primaryColor;
              },
            ),
          ),
        ));
  }
}

// class CoreButton extends StatefulWidget {
//   const CoreButton({super.key, required this.text});
//   final String text;
//   @override
//   State<CoreButton> createState() => _CoreButtonState();
// }

// class _CoreButtonState extends State<CoreButton> {
//   @override
//   Widget build(BuildContext context) {
//     ResponsiveSizing responsiveSizing = new ResponsiveSizing(context);
//     return Container(
//         width: responsiveSizing.calc_width(311),
//         height: responsiveSizing.calc_height(55),
//         child: ElevatedButton(
//           onPressed: () {},
//           child: Text(
//             widget.text,
//             style: TextStyle(color: Colors.black),
//           ),
//           style: ButtonStyle(
//             backgroundColor: MaterialStateProperty.resolveWith<Color>(
//               (Set<MaterialState> states) {
//                 if (states.contains(MaterialState.pressed)) {
//                   return AppColors.primaryColor;
//                 }
//                 return AppColors.primaryColor;
//               },
//             ),
//           ),
//         ));
//   }
// }
