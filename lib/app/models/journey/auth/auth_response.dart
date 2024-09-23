import '../response/confirmation_response.dart';

class AuthResponse extends ConfirmationResponse {
  String id;
  String username;
  String email;

  AuthResponse(String code, String errorMessage, this.id, this.username, this.email)
      : super(code, errorMessage);
}
