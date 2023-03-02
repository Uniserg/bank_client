import 'dart:convert';

import 'package:client/dto/registration_form.dart';
import 'package:client/requests/registration_request.dart';
import 'package:client/utils/validators.dart';
import 'package:client/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class RegistrationWidget extends StatefulWidget {
  const RegistrationWidget({super.key});

  @override
  State<RegistrationWidget> createState() => _RegistrationWidgetState();
}

class FieldState {
  String? error;
  TextEditingController controller = TextEditingController();
}

class _RegistrationWidgetState extends State<RegistrationWidget> {
  final formKey = GlobalKey<FormState>();

  var lastName = FieldState();
  var firstName = FieldState();
  var middleName = FieldState();
  var email = FieldState();
  var phoneNumber = FieldState();
  var passport = FieldState();
  var inn = FieldState();
  var login = FieldState();
  var password = FieldState();

  _makeRegisterRequest() async {
    var fields = {
      'lastName': lastName,
      'firstName': firstName,
      'middleName': middleName,
      ' email': email,
      'phoneNumber': phoneNumber,
      'passport': passport,
      'inn': inn,
      'username': login,
      'password': password
    };

    fields.forEach((key, value) {
      value.error = null;
    });

    RegistrationForm rf = RegistrationForm(
        lastName: lastName.controller.text,
        firstName: firstName.controller.text,
        middleName: middleName.controller.text,
        phoneNumber: phoneNumber.controller.text,
        passport: passport.controller.text,
        inn: inn.controller.text,
        email: email.controller.text,
        login: login.controller.text,
        password: password.controller.text);

    final isValidForm = formKey.currentState!.validate();

    if (!isValidForm) {
      return;
    }

    final response = await register(rf);
    if (!context.mounted) return;

    switch (response.statusCode) {
      case 201:
        final userId = json.decode(response.body);

        Navigator.pop(context);
        var snackBar = const SnackBar(
          content: Text(
            'Регистрация прошла успешно!',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.greenAccent,
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        break;
      case 409:
        const pattern = "Пользователь с таким значением уже существует";

        print(pattern);

        var conflictFields = response.body;

        conflictFields.split(" ,").forEach((field) {
          print(field);
          setState(() {
            fields[field]!.error = pattern;
          });
        });
        break;

      default:
        return Exception(response.reasonPhrase);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(Icons.arrow_back_ios),
        //replace with our own icon data.
      )),
      body: SingleChildScrollView(
        child: Center(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                const SizedBox(height: 40),
                Wrap(
                  direction: Axis.vertical,
                  spacing: 12,
                  children: [
                    CustomTextField(
                      labelText: "Фамилия",
                      controller: lastName.controller,
                      keyboardType: TextInputType.name,
                      inputFormatters: [
                        FilteringTextInputFormatter(RegExp(r'[^А-Яа-я]'),
                            allow: false),
                        LengthLimitingTextInputFormatter(35)
                      ],
                      validator: nameValidator,
                      errorText: lastName.error,
                    ),
                    CustomTextField(
                      labelText: "Имя",
                      controller: firstName.controller,
                      keyboardType: TextInputType.name,
                      inputFormatters: [
                        FilteringTextInputFormatter(RegExp(r'[^А-Яа-я]'),
                            allow: false),
                        LengthLimitingTextInputFormatter(35)
                      ],
                      validator: nameValidator,
                      errorText: firstName.error,
                    ),
                    CustomTextField(
                      labelText: "Отчество",
                      controller: middleName.controller,
                      keyboardType: TextInputType.name,
                      inputFormatters: [
                        FilteringTextInputFormatter(RegExp(r'[^А-Яа-я]'),
                            allow: false),
                        LengthLimitingTextInputFormatter(35)
                      ],
                      validator: nameValidator,
                      errorText: middleName.error,
                    ),
                    CustomTextField(
                      labelText: "email",
                      controller: email.controller,
                      validator: emailValidator,
                      errorText: email.error,
                      inputFormatters: [
                        FilteringTextInputFormatter(RegExp(r'[^[A-Za-z\d_.@]'),
                            allow: false),
                        LengthLimitingTextInputFormatter(35)
                      ],
                    ),
                    CustomTextField(
                        labelText: "Номер телефона",
                        controller: phoneNumber.controller,
                        validator: phoneNumberValidator,
                        errorText: phoneNumber.error,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          MaskTextInputFormatter(
                              mask: '+# (###) ###-##-##',
                              filter: {"#": RegExp(r'\d')},
                              type: MaskAutoCompletionType.lazy),
                        ]),
                    CustomTextField(
                      labelText: "Серия и номер паспорта",
                      controller: passport.controller,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        MaskTextInputFormatter(
                            mask: '#### ######',
                            filter: {"#": RegExp(r'\d')},
                            type: MaskAutoCompletionType.lazy),
                      ],
                      validator: passportValidator,
                      errorText: passport.error,
                    ),
                    CustomTextField(
                      labelText: "ИНН",
                      controller: inn.controller,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter(RegExp(r'\D'),
                            allow: false),
                        LengthLimitingTextInputFormatter(10)
                      ],
                      validator: innValidator,
                      errorText: inn.error,
                    ),
                    CustomTextField(
                      labelText: "Логин",
                      controller: login.controller,
                      inputFormatters: [LengthLimitingTextInputFormatter(35)],
                      validator: loginValidator,
                      errorText: login.error,
                    ),
                    CustomTextField(
                      labelText: "Пароль",
                      controller: password.controller,
                      obscureText: true,
                      validator: passwordValidator,
                      errorText: password.error,
                    )
                  ],
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: 200,
                  height: 60,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color(0xff08B0EC)),
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0),
                        ))),
                    onPressed: () => _makeRegisterRequest(),
                    child: const Text('Далее'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
