// === ENTITIES (Core Business Objects) ===
abstract class PickerResult {
  const PickerResult();
}

class TextResult extends PickerResult {
  final String value;
  const TextResult(this.value);
  
  @override
  String toString() => value;
}

class ImageResult extends PickerResult {
  final String url;
  final String? caption;
  const ImageResult(this.url, {this.caption});
}

class LocalImageResult extends PickerResult {
  final String name;
  final String? caption;
  const LocalImageResult(this.name, {this.caption});
}

class QuoteResult extends PickerResult {
  final String quote;
  final String author;
  const QuoteResult({required this.quote, required this.author});
  
  @override
  String toString() => '"$quote"\n—$author';
}

class AyaResult extends PickerResult {
  final String text;
  final String surahName;
  final int verseNumber;
  const AyaResult({
    required this.text,
    required this.surahName,
    required this.verseNumber,
  });
  
  @override
  String toString() => '$text\n$surahName : $verseNumber';
}