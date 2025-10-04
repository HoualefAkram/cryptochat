import 'package:equatable/equatable.dart';

class CryptoSeed extends Equatable {
  final int? write;
  final int? read;

  const CryptoSeed({required this.read, required this.write});

  @override
  String toString() => "Seed(read: $read, write: $write)";

  @override
  List<Object?> get props => [write, read];
}
