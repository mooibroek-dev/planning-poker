enum MessageType {
  snackBar,
  silent,
}

abstract class DomainException {
  String? message;
  MessageType get type;
}

class GeneralApiException extends DomainException {
  GeneralApiException([String? message]) : _message = message;

  final String? _message;

  @override
  String? get message => _message;

  @override
  MessageType get type => MessageType.snackBar;
}

class ServerConnectionException extends DomainException {
  ServerConnectionException();

  @override
  MessageType get type => MessageType.snackBar;
}

class ApiTimeoutException extends DomainException {
  ApiTimeoutException();

  @override
  MessageType get type => MessageType.silent;
}
