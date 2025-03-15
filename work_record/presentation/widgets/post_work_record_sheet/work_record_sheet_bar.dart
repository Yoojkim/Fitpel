import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class WorkRecordSheetBar extends StatelessWidget {
  const WorkRecordSheetBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 12,
        horizontal: 16,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: SvgPicture.asset('asset/icons/x.svg'),
          ),
          const Text(
            '근무 기록 추가',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(
            width: 40,
            height: 40,
          ),
        ],
      ),
    );
  }
}
