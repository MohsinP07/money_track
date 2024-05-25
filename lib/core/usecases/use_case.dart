import 'package:fpdart/fpdart.dart';
import 'package:money_track/core/error/failures.dart';

abstract class UseCase<SuccessType, Params> {
  Future<Either<Failure, SuccessType>> call(Params params);
}

class NoParams {}
