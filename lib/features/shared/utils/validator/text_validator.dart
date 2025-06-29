class TextValidator {
  static bool anyEmpty(List<String?> texts) =>
      texts.any((t) => t?.trim().isEmpty ?? true);
}
