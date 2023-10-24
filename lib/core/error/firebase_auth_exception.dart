

import 'package:dalily/core/error/failure.dart';

abstract class AppFirebaseAuthException extends Failure {
}

class InvalidPhoneNumber extends AppFirebaseAuthException {}

class PhoneAlreadyExist extends AppFirebaseAuthException{}

class InvalidOtpCode extends AppFirebaseAuthException{}

class TooManyRequests extends AppFirebaseAuthException {}

class OtherAuthException extends AppFirebaseAuthException {}



