import 'package:flutter/material.dart';
import 'package:hushh_proto/widgets/colors.dart';

customTextField(
  context,
  String title,
  TextEditingController controller,
  TextInputType keyboardType,
) {
  return Container(
    width: double.infinity,
    alignment: Alignment.center,
    child: TextFormField(
      keyboardType: TextInputType.text,
      obscureText: keyboardType == TextInputType.visiblePassword,
      controller: controller,
      cursorColor: Pallet.white,
      style: TextStyle(
        color: Pallet.white,
        fontSize: 16,
        fontWeight: FontWeight.normal,
      ),
      decoration: InputDecoration(
        labelStyle: TextStyle(
          color: Pallet.white.withOpacity(0.7),
        ),
        label: Text(title),
        contentPadding: const EdgeInsets.all(15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Pallet.white, width: 2),
        ),
      ),
    ),
  );
}

customTextField2(
  context,
  TextEditingController controller,
  Color fontColor,
) {
  return Container(
    width: double.infinity,
    alignment: Alignment.center,
    child: TextFormField(
      keyboardType: TextInputType.text,
      controller: controller,
      cursorColor: fontColor,
      style: TextStyle(
        color: fontColor,
        fontSize: 16,
        fontWeight: FontWeight.normal,
      ),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: fontColor, width: 2),
        ),
      ),
    ),
  );
}
