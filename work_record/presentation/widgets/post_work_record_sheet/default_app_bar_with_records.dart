import 'package:flutter/material.dart';
import 'package:fitple/common/constants/app_colors.dart';
import 'package:fitple/common/constants/image_paths.dart';
import 'package:fitple/common/theme/app_theme.dart';

class DefaultAppBarWithRecords extends StatelessWidget
    implements PreferredSizeWidget {
  ValueNotifier<bool> isScrolled;
  String title;

  DefaultAppBarWithRecords({
    super.key,
    required this.isScrolled,
    required this.title,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: isScrolled,
      builder: (context, _) {
        return AppBar(
          title: Text(
            title,
            style: AppTextTheme.lg.medium.copyWith(color: AppColors.grey600),
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Image.asset(
              ImagePaths.caretLeftIcon,
              width: 24.0,
            ),
            splashRadius: 40 / 2,
          ),
          scrolledUnderElevation: 0,
          backgroundColor:
              isScrolled.value ? AppColors.white : AppColors.grey25,
        );
      },
    );
  }
}
