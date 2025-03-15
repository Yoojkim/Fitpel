import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:fitple/common/constants/app_colors.dart';
import 'package:fitple/common/routes.dart';
import 'package:fitple/common/theme/app_theme.dart';
import 'package:fitple/features/schedule/presentation/state/role/role_list_controller.dart';
import 'package:fitple/features/work_record/presentation/state/controller/work_info_controller.dart';

class RoleSelectScreen extends ConsumerWidget {
  const RoleSelectScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roles = ref.watch(roleListProvider);

    if (roles.isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.grey25,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        backgroundColor: AppColors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Container(
            width: 40,
            height: 40,
            padding: const EdgeInsets.all(8),
            child: SvgPicture.asset(
              'asset/icons/x.svg',
              width: 24.0,
              height: 24.0,
            ),
          ),
        ),
        title: Text(
          '역할 선택',
          style: AppTextTheme.lg.medium.copyWith(
            color: AppColors.grey600,
          ),
        ),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () {
              context.push(AppRoute.roleManagement.path);
            },
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: AppColors.grey100,
                borderRadius: BorderRadius.circular(8.0),
              ),
              height: 40,
              width: 40,
              child: SvgPicture.asset('asset/images/pencil_simple.svg'),
            ),
          ),
          const SizedBox(
            width: 16,
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.only(
          top: 8,
          right: 16,
          bottom: 24,
          left: 16,
        ),
        child: ListView.separated(
            itemBuilder: (context, index) {
              return RoleWidget(
                role: roles.value![index],
              );
            },
            separatorBuilder: (context, index) => const SizedBox(
                  height: 12.0,
                ),
            itemCount: roles.value!.length),
      ),
    );
  }
}

class RoleWidget extends ConsumerStatefulWidget {
  String role;

  RoleWidget({
    super.key,
    required this.role,
  });

  @override
  ConsumerState<RoleWidget> createState() => _RoleWidgetState();
}

class _RoleWidgetState extends ConsumerState<RoleWidget> {
  @override
  Widget build(BuildContext context) {
    String? selectedRole = ref.watch(workInfoControllerProvider).role;
    bool isSelected = selectedRole != null && selectedRole == widget.role;

    return GestureDetector(
      onTap: () {
        if (!isSelected) {
          ref.read(workInfoControllerProvider.notifier).changeRole(widget.role);

          Future.delayed(
            const Duration(milliseconds: 3),
            () {
              context.pop(context);
            },
          );
        }
      },
      child: Container(
        color: Colors.white.withAlpha(0),
        padding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 8,
        ),
        child: Row(
          children: [
            isSelected ? const SelectedWidget() : const NonSelectedWidget(),
            const SizedBox(
              width: 12.0,
            ),
            Text(
              widget.role,
              style: AppTextTheme.lg.regular.copyWith(
                color: AppColors.grey700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NonSelectedWidget extends StatelessWidget {
  const NonSelectedWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(
          color: AppColors.grey200,
          width: 2.0,
        ),
      ),
    );
  }
}

class SelectedWidget extends StatelessWidget {
  const SelectedWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4.0),
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: AppColors.brand600,
        borderRadius: BorderRadius.circular(100),
      ),
      child: SvgPicture.asset(
        'asset/icons/check.svg',
        width: 16,
        height: 16,
        color: AppColors.white,
      ),
    );
  }
}
