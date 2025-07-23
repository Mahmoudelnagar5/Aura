import 'dart:io';

import 'package:aura/core/networking/api_failure.dart';
import 'package:dartz/dartz.dart';

abstract class SummaryRepo {
  Future<Either<Failure, String>> summarizeDoc(File file);
}
