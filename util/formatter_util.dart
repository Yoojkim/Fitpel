import 'package:intl/intl.dart';
import 'package:fitple/features/work_record/domain/time.dart';

class FormatterUtil {
  static String getFormattedWageWithWon(int salary) {
    return NumberFormat('₩#,###').format(salary);
  }

  static String getForamttedWage(int salary) {
    return NumberFormat('#,###').format(salary);
  }

  static String getFormattedTimeWithColon(Time time) {
    return '${getFormattedTimePart(time.hour)}:${getFormattedTimePart(time.min)}';
  }

  static String getFormattedTimePart(int time) {
    return time.toString().padLeft(2, '0');
  }

  static String getKoreanFormattedFullDate(DateTime date) {
    return '${date.year}년 ${date.month}월 ${date.day}일';
  }

  static String getKoreanFormattedTime(DateTime date) {
    String res = '';
    if (date.hour < 12) {
      res += '오전 ';
    } else {
      res += '오후 ';
    }

    if (date.hour > 12) {
      res += (date.hour - 12).toString();
    } else if (date.hour == 0) {
      res += 12.toString();
    } else {
      res += date.hour.toString();
    }

    res += ':${getFormattedTimePart(date.minute)}';

    return res;
  }
}
