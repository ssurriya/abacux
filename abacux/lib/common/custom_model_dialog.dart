import 'package:flutter/material.dart';

class CustomModelDialog extends StatelessWidget {
  const CustomModelDialog(this.title, this.content,
      {this.buttonText1,
      this.buttonText2,
      this.onPressedButton1,
      this.onPressedButton2});
  final String title, content, buttonText1, buttonText2;
  final Function onPressedButton1, onPressedButton2;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Text(content),
      actions: [
        buttonText1 != null
            ? ElevatedButton(
                onPressed: onPressedButton1,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Color(0xFF393939)),
                ),
                child: Text(buttonText1),
              )
            : Container(),
        buttonText2 != null
            ? ElevatedButton(
                onPressed: onPressedButton2,
                //Navigator.of(context).pop(true),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Color(0xFF393939)),
                ),
                child: Text(buttonText2),
              )
            : Container(),
      ],
    );
  }
}
