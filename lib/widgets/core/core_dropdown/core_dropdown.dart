import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:barangay_repository_app/constants/colors.dart';

class CoreDropdown extends StatefulWidget {
  final String labelText;
  final List<String> options;
  final String selectedOption;
  final Function(String) onChanged;
  final bool enabled;

  const CoreDropdown({
    Key? key,
    required this.labelText,
    required this.options,
    required this.selectedOption,
    required this.onChanged,
    this.enabled = true,
  }) : super(key: key);

  @override
  _CoreDropdownState createState() => _CoreDropdownState();
}

class _CoreDropdownState extends State<CoreDropdown> {
  String dropdownValue = '';

  @override
  void initState() {
    super.initState();
    dropdownValue = widget.selectedOption;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: dropdownValue,
      icon: Icon(Icons.arrow_drop_down),
      iconSize: 24,
      elevation: 16,
      onChanged: widget.enabled
          ? (String? newValue) {
              setState(() {
                dropdownValue = newValue!;
                widget.onChanged(newValue);
              });
            }
          : null,
      items: widget.options.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      decoration: InputDecoration(
        labelText: widget.labelText,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 1.0),
          borderRadius: BorderRadius.circular(4.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.primaryColor, width: 2.0),
          borderRadius: BorderRadius.circular(4.0),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        isDense: true,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
    );
  }
}
