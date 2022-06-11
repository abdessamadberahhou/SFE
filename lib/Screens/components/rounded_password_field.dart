import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

class RoundedPasswordField extends StatefulWidget {
  final String? hintText;
  final String? labelText;
  final ValueChanged? onChanged;
  final IconData? icon;
  final Color? suffixIconColor;
  final Color? iconColor;
  final TextEditingController? textController;
  final FormFieldValidator<String>? validator;
  final Color? labelColor;
  final bool? enabled;
  final Color? borderColor ;
  const RoundedPasswordField({Key? key, this.hintText, this.labelText, this.onChanged, this.icon, this.suffixIconColor, this.iconColor, this.textController, this.validator, this.labelColor = Colors.black, this.enabled, this.borderColor = Colors.white,}) : super(key: key);
  @override
  State<RoundedPasswordField> createState() => _RoundedPasswordFieldState();

}

class _RoundedPasswordFieldState extends State<RoundedPasswordField> {
  bool _isObscure = true;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: widget.validator,
      controller: widget.textController,
      obscureText: _isObscure,
      onChanged: widget.onChanged ,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.only(left: 15),
        label: Text(
          '${widget.labelText}',
          style: TextStyle(
              color: widget.labelColor
          ),
        ),
        hintText: widget.hintText,
        prefixIcon: Icon(
          IconlyBroken.lock,
          color: widget.iconColor,
        ),
          disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Colors.grey)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: widget.borderColor!)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0), borderSide: BorderSide(color: widget.borderColor!)),
          errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0), borderSide: const BorderSide(color: Colors.red)),
          focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0), borderSide: const BorderSide(color: Colors.red)),
        border: InputBorder.none,
        suffixIcon: IconButton(
            icon: Icon(
                _isObscure ? IconlyBroken.show : IconlyBroken.hide),
            color: widget.suffixIconColor,
            onPressed: () {
              setState(() {
                _isObscure = !_isObscure;
              });
            })
      ),
    );
  }
}
