// ignore_for_file: prefer_const_constructors, prefer_if_null_operators, unnecessary_new, non_constant_identifier_names, library_private_types_in_public_api

import 'package:barangay_repository_app/global/responsive_sizing.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:barangay_repository_app/constants/colors.dart';

class CoreTextfield extends StatefulWidget {
  final String labelText;
  final List<TextInputFormatter>? inputFormatters;
  final bool? enabled;
  final TextEditingController? controller;
  final int? maxLength;
  final double? fontSize;
  final String? prefix;
  final TextInputType? keyboardType;
  final bool? obscureText;
  const CoreTextfield(
      {Key? key,
      required this.labelText,
      this.inputFormatters,
      this.enabled = true,
      this.controller,
      this.maxLength,
      this.fontSize,
      this.prefix,
      this.keyboardType,
      this.obscureText = false})
      : super(key: key);
  @override
  _CoreTextfieldState createState() => _CoreTextfieldState();
}

class _CoreTextfieldState extends State<CoreTextfield> {
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveSizing responsiveSizing = new ResponsiveSizing(context);
    return SizedBox(
        width: responsiveSizing.calc_width(311),
        child: TextField(
          obscureText: widget.obscureText!,
          maxLength: widget.maxLength ?? 32,
          controller: widget.controller ?? new TextEditingController(),
          enabled: widget.enabled,
          inputFormatters: widget.inputFormatters ?? [],
          focusNode: _focusNode,
          decoration: InputDecoration(
            prefix: Text(
              widget.prefix == null ? '' : widget.prefix!,
              style: TextStyle(
                  fontSize: widget.fontSize == null
                      ? responsiveSizing.calc_height(18)
                      : widget.fontSize,
                  color: Colors.black),
            ),
            counterText: widget.maxLength == null ? '' : null,
            labelText: widget.labelText,
            labelStyle: TextStyle(
              fontSize: _focusNode.hasFocus
                  ? responsiveSizing.calc_height(20)
                  : widget.fontSize == null
                      ? responsiveSizing.calc_height(18)
                      : widget.fontSize,
              color: Color(0xFF3e3e3e),
            ),
            disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1.0),
              borderRadius: BorderRadius.circular(4.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1.0),
              borderRadius: BorderRadius.circular(4.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.primaryColor, width: 2.0),
              borderRadius: BorderRadius.circular(4.0),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(width: 1.0),
              borderRadius: BorderRadius.circular(4.0),
            ),
            contentPadding: EdgeInsets.fromLTRB(
                responsiveSizing.calc_width(10),
                responsiveSizing.calc_height(18),
                responsiveSizing.calc_width(10),
                responsiveSizing.calc_height(18)),
            isDense: true,
            floatingLabelBehavior: FloatingLabelBehavior.auto,
          ),
          style: TextStyle(
            fontSize: widget.fontSize == null
                ? responsiveSizing.calc_height(18)
                : widget.fontSize,
            color: Colors.black,
          ),
          keyboardType: widget.keyboardType != null
              ? widget.keyboardType
              : TextInputType.text,
          textInputAction: TextInputAction.done,
          maxLines: 1,
          cursorColor: AppColors.primaryColor,
          cursorWidth: 2.0,
          cursorHeight: 24.0,
          cursorRadius: Radius.circular(2.0),
          onChanged: (value) {},
          onTap: () {
            setState(() {
              _focusNode.requestFocus();
            });
          },
        ));
  }
}
