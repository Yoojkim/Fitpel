import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitple/common/constants/app_colors.dart';
import 'package:fitple/features/work_record/presentation/state/controller/work_info_controller.dart';

class UpdateButtonWidget extends ConsumerWidget {
  UpdateButtonWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    WorkInfoController workInfoStateNotifier = ref.read(
      workInfoControllerProvider.notifier,
    );

    return Container(
      padding: const EdgeInsets.only(
        top: 0,
        right: 16,
        bottom: 24,
        left: 16,
      ),
      child: GestureDetector(
        onTap: () {
          if (workInfoStateNotifier.canTriggeredButton()) {
            workInfoStateNotifier.updateWorkInfo();

            Navigator.pop(context);
          }
        },
        child: Container(
          decoration: BoxDecoration(
            color: (!workInfoStateNotifier.canTriggeredButton())
                ? AppColors.brand600.withOpacity(0.5)
                : AppColors.brand600,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                color: Color(0xFF101828).withOpacity(0.05),
                offset: Offset(0, 1),
                blurRadius: 2,
              )
            ],
          ),
          width: double.infinity,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(
            vertical: 12.0,
            horizontal: 20.0,
          ),
          child: const Text(
            '저장하기',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
              color: AppColors.white,
            ),
          ),
        ),
      ),
    );
  }
}
