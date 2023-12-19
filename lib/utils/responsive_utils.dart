class ResponsiveUtils {
  ResponsiveUtils._();

  static double calWidth(double oldHeight, double newHeight, double oldWidth) {
    return newHeight * oldWidth / oldHeight;
  }

  static double calHeight(double oldWidth, double newWidth, double oldHeight) {
    return newWidth * oldHeight / oldWidth;
  }

  static double calX(double oldWidth, double newWidth, double oldX) {
    return newWidth * oldX / oldWidth;
  }

  static double calY(double oldHeight, double newHeight, double oldWidth) {
    return newHeight * oldWidth / oldHeight;
  }
}
