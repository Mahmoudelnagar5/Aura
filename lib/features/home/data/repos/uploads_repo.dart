import 'package:aura/core/networking/api_failure.dart';
import 'package:dartz/dartz.dart';
import 'dart:io'; // For File

import '../models/doc_model.dart';

abstract class UploadsRepo {
  Future<Either<Failure, (List<Data>, String?)>> getDocs({String? cursor});
  Future<Either<Failure, DocModel>> uploadDoc(File file);
}
