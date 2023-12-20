  // core_datefield.dart
  import 'package:barangay_repository_app/global/responsive_sizing.dart';
  import 'package:flutter/material.dart';
  import 'package:flutter/services.dart';
  import 'package:barangay_repository_app/constants/colors.dart';

  class CoreDateField extends StatefulWidget {
    final String labelText;
    final TextEditingController? controller;
    final bool? enabled;
    final double? fontSize;
    final TextInputType? keyboardType;
    final DateTime? initialDate;
    final void Function(DateTime newDate)? onDateChanged;

    const CoreDateField({
      Key? key,
      required this.labelText,
      this.enabled = true,
      this.controller,
      this.fontSize,
      this.keyboardType,
      this.initialDate,
      this.onDateChanged,
    }) : super(key: key);

    @override
    _CoreDateFieldState createState() => _CoreDateFieldState();
  }

  class _CoreDateFieldState extends State<CoreDateField> {
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
        width: responsiveSizing.calc_width(365),
        child: TextField(
          controller: widget.controller ?? TextEditingController(),
          enabled: widget.enabled,
          keyboardType: TextInputType.datetime,
          decoration: InputDecoration(
            labelText: widget.labelText,
            labelStyle: TextStyle(
              fontSize: _focusNode.hasFocus
                  ? responsiveSizing.calc_height(20)
                  : widget.fontSize ?? responsiveSizing.calc_height(18),
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
              borderSide: const BorderSide(
                color: AppColors.primaryColor,
                width: 2.0,
              ),
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
              responsiveSizing.calc_height(18),
            ),
            isDense: true,
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            suffixIcon: IconButton(
              icon: Icon(Icons.calendar_today),
              onPressed: () {
                showDatePicker(
                  context: context,
                  initialDate: widget.initialDate ?? DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                ).then((pickedDate) {
                  if (pickedDate != null && widget.onDateChanged != null) {
                    widget.controller?.text =
                    "${pickedDate.month}/${pickedDate.day}/${pickedDate.year}";
                    widget.onDateChanged!(pickedDate);
                  }
                });
              },
            ),
          ),
          style: TextStyle(
            fontSize: widget.fontSize ?? responsiveSizing.calc_height(18),
            color: Colors.black,
          ),
          onTap: () {
            showDatePicker(
              context: context,
              initialDate: widget.initialDate ?? DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
            ).then((pickedDate) {
              if (pickedDate != null && widget.onDateChanged != null) {
                widget.controller?.text =
                "${pickedDate.month}/${pickedDate.day}/${pickedDate.year}";
                widget.onDateChanged!(pickedDate);
              }
            });
          },
          readOnly: true,
        ),
      );
    }
  }
