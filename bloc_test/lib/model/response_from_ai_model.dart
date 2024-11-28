class AiResponseModel {
  final String answer;
  final String userID;
  final List<String>? imageUrls;
  final String? base64Audio;

//<editor-fold desc="Data Methods">
  const AiResponseModel({
    required this.answer,
    required this.userID,
    this.imageUrls,
    this.base64Audio,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AiResponseModel &&
          runtimeType == other.runtimeType &&
          answer == other.answer &&
          userID == other.userID &&
          imageUrls == other.imageUrls &&
          base64Audio == other.base64Audio);

  @override
  int get hashCode =>
      answer.hashCode ^
      userID.hashCode ^
      imageUrls.hashCode ^
      base64Audio.hashCode;

  @override
  String toString() {
    return 'AiResponseModel{ answer: $answer, userID: $userID, imageUrls: $imageUrls, base64Audio: $base64Audio,}';
  }

  AiResponseModel copyWith({
    String? answer,
    String? userID,
    List<String>? imageUrls,
    String? base64Audio,
  }) {
    return AiResponseModel(
      answer: answer ?? this.answer,
      userID: userID ?? this.userID,
      imageUrls: imageUrls ?? this.imageUrls,
      base64Audio: base64Audio ?? this.base64Audio,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'answer': answer,
      'userID': userID,
      'imageUrls': imageUrls,
      'base64Audio': base64Audio,
    };
  }

  factory AiResponseModel.fromMap(Map<String, dynamic> map) {
    return AiResponseModel(
      answer: map['answer'] as String,
      userID: map['userId'] as String,
      imageUrls:
          map['images'] == null ? null : List<String>.from(map['images']),
      base64Audio: map['audio'] == null ? null : map['audio'] as String,
    );
  }

//</editor-fold>
}
// factory AiResponseModel.fromMap(Map<String, dynamic> map) {
//   return AiResponseModel(
//     answer: map['answer'].toString(),
//     userID: map['userID'].toString(),
//     imageUrls:
//         map['images'] == null ? null : List<String>.from(map['images']),
//   );
// }
