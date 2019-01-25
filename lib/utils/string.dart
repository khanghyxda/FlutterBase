class Str {
  static String capitalize(String s) {
    s = s.toLowerCase();
    return s[0].toUpperCase() + s.substring(1);
  }

  static List<String> toListString(List<dynamic> input) {
    var output = new List<String>();
    input.forEach((value) {
      output.add(value.toString());
    });
    return output;
  }
}
