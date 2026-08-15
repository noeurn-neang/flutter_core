class ResponsiveUtils {
  ResponsiveUtils._();

  static double calWidth(double oldHeight, double newHeight, double oldWidth) {
    if (oldHeight == 0) return oldWidth;
    return newHeight * oldWidth / oldHeight;
  }

  static double calHeight(double oldWidth, double newWidth, double oldHeight) {
    if (oldWidth == 0) return oldHeight;
    return newWidth * oldHeight / oldWidth;
  }

  static double calX(double oldWidth, double newWidth, double oldX) {
    if (oldWidth == 0) return oldX;
    return newWidth * oldX / oldWidth;
  }

  static double calY(double oldHeight, double newHeight, double oldY) {
    if (oldHeight == 0) return oldY;
    return newHeight * oldY / oldHeight;
  }
}
