import 'package:aura/core/networking/api_consumer.dart';
import 'package:aura/core/networking/api_failure.dart';
import 'package:aura/core/networking/endpoints.dart';
import 'package:aura/features/home/data/repos/uploads_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'dart:io'; // For File

import '../models/doc_model.dart';

class UploadRepoImpl implements UploadsRepo {
  final ApiConsumer apiConsumer;

  UploadRepoImpl({required this.apiConsumer});

  String? extractCursor(String? metaDataUrl) {
    if (metaDataUrl == null) return null;
    final uri = Uri.tryParse(metaDataUrl);
    return uri?.queryParameters['cursor'];
  }

  @override
  Future<Either<Failure, (List<Data>, String?)>> getDocs(
      {String? cursor}) async {
    try {
      final endpoint = cursor != null
          ? '${Endpoints.documents}?cursor=$cursor'
          : Endpoints.documents;
      final response = await apiConsumer.get(endpoint);
      final docModel = DocModel.fromJson(response);
      final nextCursor = extractCursor(docModel.metaData);
      return Right((docModel.data, nextCursor));
    } catch (e) {
      if (e is Failure) {
        return Left(e);
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, DocModel>> uploadDoc(File file) async {
    try {
      final formData = FormData.fromMap({
        'document': await MultipartFile.fromFile(
          file.path,
          filename: file.path.split('/').last,
        ),
      });

      final response = await apiConsumer.post(
        Endpoints.documents,
        data: formData,
        isFromData: true,
      );
      final data = DocModel.fromJson(response);
      return Right(data);
    } catch (e) {
      if (e is Failure) {
        return Left(e);
      }
      return Left(ServerFailure(e.toString()));
    }
  }
}
