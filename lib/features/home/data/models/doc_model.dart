class DocModel {
  int statusCode;
  String message;
  List<Data> data;
  String? metaData;

  DocModel({
    required this.statusCode,
    required this.message,
    required this.data,
    this.metaData,
  });

  factory DocModel.fromJson(Map<String, dynamic> json) {
    final dataField = json['data'];
    List<Data> dataList = [];
    if (dataField is List) {
      dataList = dataField.map((e) => Data.fromJson(e)).toList();
    }
    final metaData = json['metaData'];
    return DocModel(
      statusCode: json['statusCode'],
      message: json['message'],
      data: dataList,
      metaData: metaData is String ? metaData : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'message': message,
      'data': data.map((e) => e.toJson()).toList(),
      'metaData': metaData,
    };
  }
}

class Data {
  String documentName;
  String document;

  Data({
    required this.documentName,
    required this.document,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      documentName: json['documentName'],
      document: json['document'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'documentName': documentName,
      'document': document,
    };
  }
}
