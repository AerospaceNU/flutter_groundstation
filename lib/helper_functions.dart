class DerivativeHelper {
  double lastValue = 0;
  double lastTime = 0;

  DerivativeHelper() {}

  double update(double newValue) {
    double currentTime = DateTime.now().millisecondsSinceEpoch / 1000.0;

    if (lastTime == 0) {
      lastTime = currentTime;
      return 0;
    }

    double velocity = (newValue - lastValue) / (currentTime - lastTime);

    lastTime = currentTime;
    lastValue = newValue;

    return velocity;
  }
}
