import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

class DropDown extends StatelessWidget {
  const DropDown(
      this.labelText, this.selectedValue, this.items, this.itemAsString,
      {this.errorText = "",
      this.onchanged,
      this.validator,
      this.isValidate = true});
  final String labelText, errorText;
  final dynamic selectedValue;
  final List<dynamic> items;
  final Function onchanged;
  final Function validator;
  final Function itemAsString;
  final bool isValidate;

  @override
  Widget build(BuildContext context) {
    return DropdownSearch(
      dropdownSearchDecoration: InputDecoration(
        errorStyle: TextStyle(fontSize: 15.0),
        labelText: labelText,
        labelStyle: TextStyle(
            fontSize: 16.0,
            color: Colors.black.withOpacity(0.8),
            fontWeight: FontWeight.w600),
        filled: true,
        fillColor: Color(0xFFFFFF),
        contentPadding: EdgeInsets.fromLTRB(7, 0, 0, 0),
        hintStyle: const TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 20,
        ),
      ),
      showSelectedItem: false,
      selectedItem: selectedValue,
      onChanged: (value) {
        onchanged(value);
      },
      mode: Mode.MENU,
      // itemAsString: itemAsString(dynamic value),
      itemAsString: (dynamic value) => itemAsString(value),
      items: items,
      // label: "Select Driver Name",
      showSearchBox: true,
      validator: (text) {
        if (isValidate) {
          if (text == null || text.isEmpty) {
            return errorText;
          }
        }
        return null;
      },
      searchBoxDecoration: InputDecoration(
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.fromLTRB(12, 12, 8, 0),
        // labelText: "Employee Name",
      ),
    );
  }
}
