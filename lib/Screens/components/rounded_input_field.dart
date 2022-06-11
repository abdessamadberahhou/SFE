import 'dart:collection';

import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:textfield_tags/textfield_tags.dart';

import 'constatnts.dart';


class RoundedTextField extends StatelessWidget {
  final String? hintText;
  final String? labelText;
  final String? initValue;
  final ValueChanged? onChanged;
  final IconData? icon;
  final FormFieldValidator<String>? validator;
  final Color? iconColor;
  final TextEditingController? textController;
  final Color? labelColor;
  final Color borderColor;
  final bool enabled;
  final bool? isNumber;
  const RoundedTextField({
    Key? key,
    this.hintText,
    this.labelText,
    this.onChanged,
    this.icon,
    this.iconColor = Colors.black,
    this.textController,
    this.validator,
    this.labelColor = Colors.black, this.borderColor = Colors.white, this.initValue, this.enabled = true, this.isNumber = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(color: enabled ? Colors.black : Colors.grey[600]),
      initialValue: initValue,
      enabled: enabled,
      validator: validator,
      controller: textController,
      onChanged: onChanged ,
      keyboardType: isNumber! ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(left: 15),
          label: Text(
            '$labelText',
            style: TextStyle(
                color: labelColor
            ),
          ),
          hintText: hintText,
          fillColor: Colors.white,
          disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0), borderSide: const BorderSide(color: Colors.grey)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0), borderSide: BorderSide(color: borderColor)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0), borderSide: BorderSide(color: borderColor)),
          errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0), borderSide: const BorderSide(color: Colors.red)),
          focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0), borderSide: const BorderSide(color: Colors.red)),
          prefixIcon: Icon(
            icon,
            color: enabled ? iconColor : Colors.grey,
          ),
        border: InputBorder.none
      ),
    );
  }
}

class RoundedInputNormal extends StatefulWidget {
  final String? hintText;
  final String? labelText;
  final ValueChanged<String>? onChanged;
  final IconData? icon;
  final Color? suffixIconColor;
  final Color? iconColor;
  final TextEditingController? textController;
  final FormFieldValidator<String>? validator;
  final Color? labelColor;
  final Color borderColor;
  final IconData? suffixIcon;
  const RoundedInputNormal({Key? key, this.hintText, this.labelText, this.onChanged, this.icon, this.suffixIconColor, this.iconColor, this.textController, this.validator, this.labelColor = Colors.black, this.suffixIcon, this.borderColor=Colors.black,}) : super(key: key);
  @override
  State<RoundedInputNormal> createState() => _RoundedInputNormalState();

}

class _RoundedInputNormalState extends State<RoundedInputNormal> {
  final bool _isObscure = true;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: widget.validator,
      controller: widget.textController,
      onChanged: widget.onChanged ,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.only(left: 15),
          hintText: widget.hintText,
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: widget.borderColor, width: 0.75)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0), borderSide: BorderSide(color: widget.borderColor, width: 0.75)),
          errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0), borderSide: const BorderSide(color: Colors.red)),
          focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0), borderSide: const BorderSide(color: Colors.red)),
          border: InputBorder.none,
          suffixIcon: IconButton(
              icon: Icon(
                  widget.suffixIcon),
              color: widget.suffixIconColor,
              onPressed: () {
                setState(() {
                });
              })
      ),
    );
  }
}


class RoundedDateField extends StatelessWidget {
  final String? hintText;
  final String? labelText;
  final ValueChanged? onChanged;
  final IconData? icon;
  final Color? suffixIconColor;
  final Color? iconColor;
  final TextEditingController? textController;
  final FormFieldValidator<String>? validator;
  final Color? labelColor;
  final Color borderColor;
  final DateTime? dateValue;
  final bool? enabled;
  final void set;
  const RoundedDateField({
    Key? key, this.hintText, this.labelText, this.onChanged, this.icon, this.suffixIconColor, this.iconColor, this.textController, this.validator, this.labelColor, required this.borderColor, this.dateValue, this.set, this.enabled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DateTimeFormField(
      enabled: enabled!,
      initialValue: dateValue,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.only(left: 15),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0), borderSide: BorderSide(color: enabled! ? borderColor : Colors.grey)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0), borderSide: BorderSide(color: enabled! ? borderColor : Colors.grey)),
        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0), borderSide: const BorderSide(color: Colors.red)),
        focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0), borderSide: const BorderSide(color: Colors.red)),
        border: InputBorder.none,
        prefixIcon: Icon(IconlyLight.calendar, color:  enabled! ? iconColor : Colors.grey,),
        labelText: 'Date *',
      ),
      mode: DateTimeFieldPickerMode.date,
      autovalidateMode: AutovalidateMode.always,
      validator: (e) => (e?.day ?? 0) == 1 ? 'Please not the first day' : null,
      onDateSelected: (DateTime value) {
        set;
      },
    );
  }
}





class TagTextField extends StatefulWidget {
  List<String> tagArray = LinkedHashSet<String>().toList();
  List<String>? initTags = LinkedHashSet<String>().toList();
  final bool? enabled;
  TagTextField({Key? key, required this.tagArray, this.initTags, this.enabled = true}) : super(key: key);

  @override
  State<TagTextField> createState() => _TagTextFieldState();
}

class _TagTextFieldState extends State<TagTextField> {
  final TextfieldTagsController _controller = TextfieldTagsController();
  @override
  Widget build(BuildContext context) {
    return Column(
          children: [
            TextFieldTags(
              initialTags: widget.initTags,
              textfieldTagsController: _controller,
              textSeparators: const [' ', ','],
              letterCase: LetterCase.normal,
              validator: (String tag) {
                if (_controller.getTags!.contains(tag)) {
                  return 'Vous avez déja entrer ce tag';
                }
                return null;
              },
              inputfieldBuilder:
                  (context, tec, fn, error, onChanged, onSubmitted) {
                return ((context, sc, tags, onTagDelete) {
                  return TextField(
                    enabled: widget.enabled,
                    controller: tec,
                    focusNode: fn,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                          onPressed: (){
                            _controller.clearTags();
                            widget.tagArray.clear();
                          },
                          icon: Icon(IconlyLight.delete, size: 25, color: widget.enabled! ? welcomePrimaryColor : Colors.grey,)
                      ),
                      disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0), borderSide: const BorderSide(color: Colors.grey)),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: welcomePrimaryColor, width: 0.75)),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0), borderSide: BorderSide(color: welcomePrimaryColor, width: 0.75)),
                      errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0), borderSide: const BorderSide(color: Colors.red)),
                      focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0), borderSide: const BorderSide(color: Colors.red)),
                      border: InputBorder.none,
                      isDense: true,
                      helperStyle: const TextStyle(
                        color: Color.fromARGB(255, 74, 137, 92),
                      ),
                      hintText: _controller.hasTags ? '' : "Entrer vos tags",
                      errorText: error,
                      prefixIcon: tags.isNotEmpty
                          ? SingleChildScrollView(
                        controller: sc,
                        scrollDirection: Axis.horizontal,
                        child: Row(
                            children: tags.map((String tag) {
                              widget.tagArray.add(tag);
                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(20.0),
                                  ),
                                  color: widget.enabled! ? Colors.orange : Colors.grey,
                                ),
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 5.0),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 5.0),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      child: Text(
                                        tag,
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                      onTap: () {

                                      },
                                    ),
                                    const SizedBox(width: 4.0),
                                    InkWell(
                                      child: const Icon(
                                        Icons.cancel,
                                        size: 14.0,
                                        color: Color.fromARGB(
                                            255, 233, 233, 233),
                                      ),
                                      onTap: () {
                                          onTagDelete(tag);
                                          widget.tagArray.clear();
                                      },
                                    )
                                  ],
                                ),
                              );
                            }).toList()),
                      )
                          : Container(
                          child: Icon(IconlyLight.bookmark, size: 25, color: widget.enabled! ? welcomePrimaryColor : Colors.grey,)),
                    ),
                    onChanged: onChanged,
                    onSubmitted: onSubmitted,
                  );
                });
              },
            ),
          ],
        );
  }
}







