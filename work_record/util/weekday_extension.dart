extension WeekDay on DateTime {
  String getKoreanWeekDay() {
    List<String> koreanWeekDays = [
      '월',
      '화',
      '수',
      '목',
      '금',
      '토',
      '일',
    ];

    return koreanWeekDays[weekday - 1];
  }
}
