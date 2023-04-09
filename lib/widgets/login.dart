import 'package:client/main.dart';
import 'package:client/utils/validators.dart';
import 'package:client/vars/request_vars.dart';
import 'package:client/widgets/home.dart';
import 'package:client/widgets/registration.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../notifications/socket.dart';
import '../requests/keycloak_requests.dart';
import 'custom_text_field.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key});

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  var login = FieldState();
  var password = FieldState();
  final formKey = GlobalKey<FormState>();
  String errorMessage = "";

  _makeLoginRequest() async {
    final isValidForm = formKey.currentState!.validate();

    if (!isValidForm) {
      return;
    }

    String? err = await KeycloakAuth.logIn(
        login.controller.text, password.controller.text);

    if (err != null) {
      print(err);
      setState(() {
        errorMessage = err;
      });
      return;
    }

    var snackBar = const SnackBar(
      content: Text(
        'Вход выполнен успешно!',
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.greenAccent,
    );

    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    openSocketChannel();

    Navigator.pop(context);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const HomeWidget()));

    login.controller.clear();
    password.controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.only(top: 110),
            child: Center(
              child: Column(
                children: [
                  const Image(
                    image: AssetImage(mainIcon),
                    width: 120,
                    height: 120,
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: 300,
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          CustomTextField(
                            labelText: "Логин/email",
                            controller: login.controller,
                            validator: loginValidator,
                            inputFormatters: [
                              FilteringTextInputFormatter(
                                  RegExp(r'[^[A-Za-z\d_.@]'),
                                  allow: false),
                              LengthLimitingTextInputFormatter(35)
                            ],
                          ),
                          const SizedBox(height: 40),
                          CustomTextField(
                            labelText: "Пароль",
                            obscureText: true,
                            controller: password.controller,
                            validator: passwordValidator,
                          )
                        ],
                      ),
                    ),
                  ),
                  Text(
                    errorMessage,
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.error),
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                  SizedBox(
                    width: 200,
                    height: 60,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          // backgroundColor: MaterialStateProperty.all<Color>(
                          //     const Color(0xff08B0EC)),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Theme.of(context).colorScheme.primary),
                          foregroundColor: MaterialStateProperty.all<Color>(
                              Theme.of(context).colorScheme.onPrimary),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0),
                          ))),
                      onPressed: _makeLoginRequest,
                      child: const Text('Войти'),
                    ),
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: 200,
                    height: 60,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Theme.of(context).primaryColor),
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0),
                          ))),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const RegistrationWidget()));
                      },
                      child: const Text('Зарегистрироваться'),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
