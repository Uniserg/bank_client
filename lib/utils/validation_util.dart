bool isEmailValid(String email) {
  return false;
}

bool isPhoneNumberValid(String phoneNumber) {
  final emailRegexp =
      RegExp(r'^([a-zA-Z\d_\-.]+)@([a-zA-Z\d_\-.]+)\.([a-zA-Z]{2,5})$');
  return emailRegexp.hasMatch(phoneNumber);
}

bool isPassportValid(String passport) {
  return false;
}

bool isInnValid(String inn) {
  return false;
}

bool isLoginValid(String login) {
  return false;
}

bool isPasswordValid(String password) {
  return false;
}
