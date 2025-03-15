class SelectedDate {
  DateTime startDate;
  DateTime endDate;

  SelectedDate({required this.startDate, required this.endDate});

  void changeSelectedDate(SelectedDate newDate) {
    startDate = newDate.startDate;
    endDate = newDate.endDate;
  }

  bool isDateBetweenSelectedDate(DateTime date) {
    return ((startDate.isBefore(date) || startDate.isAtSameMomentAs(date))) &&
        ((endDate.isAfter(date)) || endDate.isAtSameMomentAs(date));
  }

  static SelectedDate initSelectedDate() {
    DateTime now = DateTime.now();
    DateTime start = DateTime(now.year, now.month);
    DateTime end = DateTime(now.year, now.month, now.day);

    return SelectedDate(startDate: start, endDate: end);
  }

  @override
  bool operator ==(Object other) {
    return other is SelectedDate &&
        startDate == other.startDate &&
        endDate == other.endDate;
  }

  @override
  int get hashCode => Object.hash(startDate, endDate);
}
