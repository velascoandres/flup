bool isNumeric(String s) {
  if (s.isEmpty) return false;
  final numero = num.tryParse(s);
  return numero == null ? false : true;
}
