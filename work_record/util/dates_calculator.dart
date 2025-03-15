import 'dart:collection';

class DatesCalculator {
  static List<DateTime> getCalendarDates(DateTime date) {
    DateTime standardDate = getStartDate(date);

    return getDatesForMonth(standardDate);
  }

  static List<DateTime> getDatesForMonth(DateTime standardDate) {
    Queue<DateTime> dates = Queue();

    for (int i = 0; i < 31; i++) {
      dates.add(standardDate.add(Duration(days: i)));
    }

    while (true) {
      DateTime lastDate = dates.last;

      if (lastDate.month == standardDate.month) {
        break;
      }

      dates.removeLast();
    }

    addFrontDates(dates);
    addBackDates(dates);

    return dates.toList();
  }

  static void addFrontDates(Queue<DateTime> dates) {
    const Duration oneDay = Duration(days: 1);

    while (true) {
      DateTime frontDate = dates.first;

      if (frontDate.weekday == DateTime.monday) {
        break;
      }

      dates.addFirst(frontDate.subtract(oneDay));
    }
  }

  static void addBackDates(Queue<DateTime> dates) {
    const Duration oneDay = Duration(days: 1);

    while (true) {
      DateTime backDate = dates.last;

      if (backDate.weekday == DateTime.sunday) {
        break;
      }

      dates.add(backDate.add(oneDay));
    }
  }

  static DateTime getStartDate(DateTime date) {
    return DateTime(date.year, date.month);
  }
}
