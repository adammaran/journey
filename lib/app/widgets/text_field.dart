import 'package:flutter/material.dart';

class TextFieldWidget extends StatefulWidget {
  TextEditingController controller;
  String? hint;
  TextInputType? type;
  bool isPassword;

  bool isPasswordVisible = true;

  TextFieldWidget(
      {super.key,
      required this.controller,
      this.hint,
      this.type,
      this.isPassword = false});

  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.black54)),
      padding: EdgeInsets.all(8),
      child: TextFormField(
        keyboardType: widget.type,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter a value';
          } else if (widget.type == TextInputType.emailAddress) {
            if (!validateEmail(value)) {
              return 'Incorrect email format';
            }
          }
          return null;
        },
        obscureText: widget.isPassword ? widget.isPasswordVisible : false,
        controller: widget.controller,
        cursorColor: Colors.black,
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: widget.hint,
            icon: Icon(widget.type == TextInputType.emailAddress
                ? Icons.email
                : widget.isPassword
                    ? Icons.lock
                    : Icons.info),
            suffixIcon: widget.isPassword
                ? InkWell(
                    onTap: () {
                      setState(() {
                        widget.isPasswordVisible = !widget.isPasswordVisible;
                      });
                    },
                    child: Icon(widget.isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off),
                  )
                : null),
      ),
    );
  }

  bool validateEmail(String input) {
    const Pattern emailPattern =
        r"^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))$";
    return RegExp(emailPattern.toString()).hasMatch(input);
  }
}
