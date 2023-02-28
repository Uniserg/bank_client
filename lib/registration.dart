import 'package:client/custom_text_field.dart';
import 'package:flutter/material.dart';

class RegistrationWidget extends StatelessWidget {
  const RegistrationWidget({super.key});

  static const fields = [
    "Фамилия",
    "Имя",
    "Отчество",
    "Номер телефона",
    "Серия и номер паспорта",
    "ИНН",
    "email",
    "Логин"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset : false,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 40),
              Wrap(
                direction: Axis.vertical,
                spacing: 12,
                children: fields.map((e) => SizedBox(width: 300,child: CustomTextField(labelText: e))).toList()
              ),
              const SizedBox(height: 12),
              const SizedBox(width: 300, child: CustomTextField(labelText: "Пароль", obscureText: true)),
              const SizedBox(height: 40),
              SizedBox(
                width: 200,
                height: 60,
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(const Color(0xff08B0EC)),
                      foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0),
                          )
                      )
                  ),
                  onPressed: () { },
                  child: const Text('Далее'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}