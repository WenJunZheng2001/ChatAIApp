import 'dart:convert';
import 'dart:io';

class UploadFileModel {
  File file;

  UploadFileIconModel fileIconDetails;

  UploadFileModel({required this.fileIconDetails, required this.file});
}

class UploadFileIconModel {
  String iconToDisplay;
  bool isImage;
  String fileName;
  String? localFilePath;

  UploadFileIconModel(
      {required this.iconToDisplay,
      required this.isImage,
      required this.fileName,
      this.localFilePath});

  Map<String, dynamic> toJson() {
    return {
      'iconToDisplay': iconToDisplay,
      'isImage': isImage,
      'fileName': fileName,
      'localFilePath': localFilePath,
    };
  }

  factory UploadFileIconModel.fromJson(Map<String, dynamic> json) {
    return UploadFileIconModel(
      iconToDisplay: json['iconToDisplay'],
      isImage: json['isImage'],
      fileName: json['fileName'],
      localFilePath: json['localFilePath'],
    );
  }

  static String uploadFileIconModelListToString(
      List<UploadFileIconModel> list) {
    List<Map<String, dynamic>> jsonList =
        list.map((model) => model.toJson()).toList();
    return json.encode(jsonList);
  }

  static List<UploadFileIconModel> stringToUploadFileIconModelList(
      String jsonString) {
    List<dynamic> jsonList = json.decode(jsonString);
    return jsonList
        .map((jsonObject) => UploadFileIconModel.fromJson(jsonObject))
        .toList();
  }
}
