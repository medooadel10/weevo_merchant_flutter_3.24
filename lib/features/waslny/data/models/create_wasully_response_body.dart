class CreateWasullyResponseBody {
  final String message;

  CreateWasullyResponseBody(this.message);

  factory CreateWasullyResponseBody.fromJson(Map<String, dynamic> json) {
    return CreateWasullyResponseBody(json['message'] as String);
  }
}
