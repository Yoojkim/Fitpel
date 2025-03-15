class Time {
  int hour;
  int min;

  Time({
    required this.hour,
    required this.min,
  });

  int getAllMin() {
    return hour * 60 + min;
  }

  static getTimeByTotalMinute(int minute) {
    return Time(hour: minute ~/ 60, min: minute % 60);
  }
}
