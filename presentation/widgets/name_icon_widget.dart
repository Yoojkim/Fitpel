import 'package:flutter/material.dart';
import 'package:fitple/features/work_record/util/random_color_util.dart';

class NameIconWidget extends StatelessWidget {
  String name;
  Size size;
  TextStyle textStyle;
  NameIconWidget({
    super.key,
    required this.name,
    required this.size,
    required this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    String splitedName = getSplitedName();

    return Container(
      width: size.width,
      height: size.height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(200.0),
        color: const Color(0xffECFDF3),
      ),
      child: Text(
        splitedName,
        style: textStyle.copyWith(
          color: const Color(0xff13AB62),
        ),
      ),
    );
  }

  String getSplitedName() {
    if (name.length == 1) {
      return name;
    }

    return name.substring(name.length - 2);
  }
}
