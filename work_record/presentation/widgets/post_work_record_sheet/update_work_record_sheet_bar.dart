import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fitple/common/constants/app_colors.dart';
import 'package:fitple/common/theme/app_theme.dart';
import 'package:fitple/features/work_record/presentation/state/work_info_state.dart';
import 'package:fitple/features/work_record/presentation/state/controller/work_info_controller.dart';
import 'package:fitple/features/work_record/util/weekday_extension.dart';

class UpdateWorkRecordSheetBar extends ConsumerWidget {
  const UpdateWorkRecordSheetBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    WorkInfoState workInfoState = ref.watch(workInfoControllerProvider);

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
            '근무 기록 변경',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          GestureDetector(
            onTap: () async {
              bool? result = await showDialog(
                context: context,
                barrierDismissible: true,
                builder: (context) {
                  return Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.817,
                      child: Dialog(
                        surfaceTintColor: Colors.white,
                        insetPadding: EdgeInsets.zero,
                        backgroundColor: AppColors.white,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(12.0),
                          ),
                        ),
                        child: getDeleteDialogWidget(
                          workInfoState,
                          context,
                          ref,
                        ),
                      ),
                    ),
                  );
                },
              );

              if (result == true) {
                Navigator.pop(context);
              }
            },
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: AppColors.grey100,
                borderRadius: BorderRadius.circular(8.0),
              ),
              height: 40,
              width: 40,
              child: Image.asset(
                'asset/images/trash_icon.png',
                height: 20.0,
                width: 20.0,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget getDeleteDialogWidget(
    WorkInfoState workInfoState,
    BuildContext context,
    WidgetRef ref,
  ) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        16,
        20,
        20,
        20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '근무 기록을 삭제하시겠습니까?',
                style: AppTextTheme.lg.semiBold.copyWith(
                  color: AppColors.grey900,
                ),
              ),
              const SizedBox(
                height: 16.0,
              ),
              Text(
                  '${workInfoState.employee!.name}의 ${workInfoState.date!.month}월 ${workInfoState.date!.day}일 ${workInfoState.date!.getKoreanWeekDay()}요일 근무 기록이 삭제됩니다'),
            ],
          ),
          const SizedBox(
            height: 24.0,
          ),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 18.0,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      border: Border.all(
                        color: AppColors.grey300,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      '취소',
                      style: AppTextTheme.md.semiBold.copyWith(
                        color: AppColors.grey700,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 12.0,
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    ref
                        .read(workInfoControllerProvider.notifier)
                        .deleteWorkInfo();

                    Navigator.pop(context, true);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 18,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.error600,
                      border: Border.all(
                        color: AppColors.error600,
                      ),
                      borderRadius: BorderRadius.circular(
                        8.0,
                      ),
                    ),
                    child: Text(
                      '삭제하기',
                      style: AppTextTheme.md.semiBold.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
