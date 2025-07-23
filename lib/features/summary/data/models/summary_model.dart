class Summary {
  final String docName;
  final String uploadDate;
  final String summaryText;

  Summary(
      {required this.docName,
      required this.uploadDate,
      required this.summaryText});

  Map<String, dynamic> toJson() => {
        'docName': docName,
        'uploadDate': uploadDate,
        'summaryText': summaryText,
      };

  factory Summary.fromJson(Map<String, dynamic> json) => Summary(
        docName: json['docName'],
        uploadDate: json['uploadDate'],
        summaryText: json['summaryText'],
      );
}
