class FailedToConnectToServerException implements Exception {
  final String description;

  FailedToConnectToServerException(this.description);

  @override
  String toString() => description;
}
