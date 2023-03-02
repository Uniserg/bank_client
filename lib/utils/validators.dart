import 'package:client/utils/regexp.dart';

String? Function(String? name) nameValidator =
    (name) => (name!.length < 2) ? "Не менее 2 символов" : null;

String? Function(String? phone) phoneNumberValidator =
    (phone) => (phone!.length < 11) ? "Неверный номер телефона" : null;

String? Function(String? passport) passportValidator = (passport) =>
    (passport!.length != 11) ? "Неверные паспортные данные" : null;

String? Function(String? inn) innValidator =
    (inn) => (inn!.length != 10) ? "Неверный ИНН" : null;

String? Function(String? email) emailValidator = (email) =>
    (email!.length < 5 || !emailRegexp.hasMatch(email))
        ? "Неверный email"
        : null;

String? Function(String? login) loginValidator =
    (login) => (login!.length < 3) ? "Не менее 3 символов" : null;

String? Function(String? password) passwordValidator =
    (password) => (password!.length < 6) ? "Не менее 6 символов" : null;
