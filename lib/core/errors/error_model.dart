class ErrorModel {
  final int? status;
  final String? errorMessage;

  ErrorModel({this.status, this.errorMessage});
  factory ErrorModel.fromJson(Map<String, dynamic> json) {
    return ErrorModel(
      status: json['status'] as int?,
      errorMessage: json['ErrorMessage'] as String?,
    );
  }
}
