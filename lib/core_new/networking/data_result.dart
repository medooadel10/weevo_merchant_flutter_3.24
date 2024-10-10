class DataResult<T> {
  T? data;
  bool success;
  String? error;
  DataResult({this.data, this.error, required this.success});

  factory DataResult.success(T data) => DataResult(data: data, success: true);
  factory DataResult.error(String error) =>
      DataResult(error: error, success: false);
}
