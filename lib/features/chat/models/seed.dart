import 'package:equatable/equatable.dart';

class Seed extends Equatable {
  final int? write;
  final int? read;

  const Seed({required this.read, required this.write});

  @override
  String toString() => "Seed(read: $read, write: $write)";

  @override
  List<Object?> get props => [write, read];
}
