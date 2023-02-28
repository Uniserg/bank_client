import 'package:client/registration.dart';
import 'package:flutter/material.dart';

import 'custom_text_field.dart';

class LoginWidget extends StatelessWidget {
  const LoginWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset : false,
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(top: 110),
          child: Center(
            child: Column(
              children: [
                const Image(
                    image:AssetImage('assets/images/icon.png'),
                    width: 120,
                    height: 120,
                  ),
                const SizedBox(height: 40),
                SizedBox(
                  width: 300,
                  child: Column(
                    children: const [
                      CustomTextField(labelText: "Логин/email"),
                      SizedBox(height: 40),
                      CustomTextField(labelText: "Пароль", obscureText: true,)
                    ],
                  ),
                ),
                const SizedBox(height: 60,),
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
                    child: const Text('Войти'),
                  ),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: 200,
                  height: 60,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(const Color(0xffD8AC42)),
                        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0),
                            )
                        )
                    ),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const RegistrationWidget()));
                    },
                    child: const Text('Зарегистрироваться'),
                  ),
                )
              ],
            ),
          ),
        ),
      )
    );
  }

}