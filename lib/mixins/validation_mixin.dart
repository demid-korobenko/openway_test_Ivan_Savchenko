mixin ValidationMixin {
  bool validateOtpCode(String otp) {
    if (otp == "1111")
      return true;
    else
      return false;
  }
}
