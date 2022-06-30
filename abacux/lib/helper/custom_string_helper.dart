class CustomStringHelper {
  String formattDoubleToString(double num) {
    return num.toStringAsFixed(num.truncateToDouble() == num ? 0 : 3);
  }
}