class CustomResponse<T> {
  final T? data;
  final int? statusCode;
  final String? successMessage;
  final String? errorMessage;

  CustomResponse(
      {this.statusCode, this.successMessage, this.errorMessage, this.data});
}
