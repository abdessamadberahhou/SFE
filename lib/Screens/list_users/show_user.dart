import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

import '../../Objects/user.dart';
import '../components/constatnts.dart';
import '../components/fixed_page.dart';
import '../components/rounded_button.dart';
import '../components/rounded_input_field.dart';
import '../profile_screen/profile_screen.dart';




class ShowUser extends StatelessWidget {
  final User? user;
  const ShowUser({Key? key, this.user}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FixedPage(
        canBack: true,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: testColor,
                    borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15))
                ),
                padding: const EdgeInsets.only(top: 25, bottom: 45),
                child: Center(
                    child: ProfileImage(user!.Avatar == '' ? defaultAvatar : user!.Avatar, false, (){

                    })
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 25, horizontal:  25),
                child: Column(
                  children: [
                    const SizedBox(height: 10,),
                    RoundedTextField(
                      initValue: user!.LastName,
                      enabled: false,
                      borderColor: welcomePrimaryColor,
                      iconColor: welcomePrimaryColor,
                      icon: IconlyLight.user,
                      hintText: 'Entrer votre nom',
                      labelText: 'Nom *',
                      labelColor: Colors.grey,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    RoundedTextField(
                      initValue: user!.FirstName,
                      enabled: false,
                      borderColor: welcomePrimaryColor,
                      iconColor: welcomePrimaryColor,
                      icon: IconlyLight.user,
                      labelText: 'Prénom *',
                      labelColor: Colors.grey,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    RoundedTextField(
                      initValue: user!.Cin,
                      enabled: false,
                      borderColor: welcomePrimaryColor,
                      iconColor: welcomePrimaryColor,
                      icon: IconlyLight.document,
                      labelText: 'CIN *',
                      labelColor: Colors.grey,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    RoundedTextField(
                      initValue: user!.Email,
                      enabled: false,
                      borderColor: welcomePrimaryColor,
                      iconColor: welcomePrimaryColor,
                      icon: IconlyLight.message,
                      labelText: 'E-mail *',
                      labelColor: Colors.grey,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    DateTimeFormField(
                      initialValue: DateTime.parse(user!.BirthDay.toString()+'T000000'),
                      enabled: false,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(left: 15),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Colors.grey)),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0), borderSide: BorderSide(color:welcomePrimaryColor, width: 0.75)),
                        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0), borderSide: const BorderSide(color: Colors.red)),
                        focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0), borderSide: const BorderSide(color: Colors.red)),
                        border: InputBorder.none,
                        prefixIcon: const Icon(IconlyLight.calendar, color: Colors.grey),
                        labelText: 'Date',
                      ),
                      dateTextStyle: const TextStyle(
                          color: Colors.black
                      ),
                      mode: DateTimeFieldPickerMode.date,
                      autovalidateMode: AutovalidateMode.always,
                      validator: (e) => (e?.day ?? 0) == 1 ? 'Please not the first day' : null,
                      onDateSelected: (DateTime value) {

                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    RoundedTextField(
                      initValue: user!.NumTele,
                      enabled: false,
                      borderColor: welcomePrimaryColor,
                      iconColor: welcomePrimaryColor,
                      icon: IconlyLight.call,
                      labelText: 'Téléphone *',
                      labelColor: Colors.grey,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    RoundedButton(
                        text: 'Retour',
                        color: welcomePrimaryColor,
                        press: ()  {
                          Navigator.of(context).pop(false);
                        }
                    )
                  ],
                ),
              )
            ],
          ),
        )
    );
  }
}

