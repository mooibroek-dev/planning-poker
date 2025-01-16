import 'package:app/core/exceptions.dart';
import 'package:dartz/dartz.dart';

typedef Maybe<T> = Either<DomainException, T>;
