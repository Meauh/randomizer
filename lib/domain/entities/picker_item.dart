
enum ResultType { text, image, custom }

class PickerItem {
  final ResultType result;
  final String value;
  final String title;

  const PickerItem(this.result, this.value, this.title);
}