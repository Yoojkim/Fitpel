import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:fitple/common/constants/app_colors.dart';
import 'package:fitple/common/constants/image_paths.dart';
import 'package:fitple/common/theme/app_theme.dart';
import 'package:fitple/features/schedule/presentation/state/employee_select_controller.dart';
import 'package:fitple/features/user/domain/employee.dart';
import 'package:fitple/features/user/presentation/state/employee_controller.dart';
import 'package:fitple/features/work_record/presentation/state/controller/selected_employee_controller.dart';
import 'package:fitple/features/work_record/presentation/widgets/name_icon_widget.dart';

class EmployeeSelectScreen extends ConsumerStatefulWidget {
  late SelectedEmployeeController selectedEmployeeNotifier;
  String? selectedEmployeeId;

  EmployeeSelectScreen({
    super.key,
    this.selectedEmployeeId,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      EmployeeSelectScreenState();
}

class EmployeeSelectScreenState extends ConsumerState<EmployeeSelectScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    widget.selectedEmployeeNotifier = SelectedEmployeeController(
      employees: ref.watch(employeeListProvider).valueOrNull ?? [],
    );

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        backgroundColor: Colors.white,
        title: Text(
          '직원 선택',
          style: AppTextTheme.lg.medium.copyWith(
            color: AppColors.grey600,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(
              context,
            );
          },
          icon: Image.asset(
            ImagePaths.caretLeftIcon,
            width: 24.0,
          ),
          splashRadius: 40 / 2,
        ),
      ),
      backgroundColor: AppColors.white,
      body: getSelectEmployeeWidget(),
    );
  }

  Widget getSelectEmployeeWidget() {
    return Column(
      children: [
        const SizedBox(
          height: 12.0,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24.0,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppColors.grey300,
                width: 1.0,
              ),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 14.0,
              vertical: 10.0,
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: SvgPicture.asset(
                    'asset/images/magnifying_glass.svg',
                    height: 12.5,
                    width: 12.5,
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      isDense: true,
                      border: InputBorder.none,
                      hintText: '직원 이름을 입력해주세요',
                      hintStyle: AppTextTheme.md.regular.copyWith(
                        color: AppColors.grey500,
                      ),
                    ),
                    onChanged: (value) {
                      List<Employee> newEmployees = ref
                          .read(employeeListProvider)
                          .value!
                          .where((employee) => employee.name.contains(value))
                          .toList();

                      widget.selectedEmployeeNotifier.chcangeEmployees(
                        newEmployees,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: AnimatedBuilder(
              animation: widget.selectedEmployeeNotifier,
              builder: (context, child) {
                return ListView.separated(
                  itemCount: widget.selectedEmployeeNotifier.employees.length,
                  itemBuilder: (context, index) {
                    return EmployeeWidget(
                      employee:
                          widget.selectedEmployeeNotifier.employees[index],
                      backGroundColor: (widget.selectedEmployeeId != null &&
                              widget.selectedEmployeeId ==
                                  widget.selectedEmployeeNotifier
                                      .employees[index].id)
                          ? AppColors.grey100
                          : Colors.transparent,
                    );
                  },
                  separatorBuilder: (context, index) => const Divider(
                    height: 8.0,
                    color: Colors.transparent,
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class EmployeeWidget extends ConsumerStatefulWidget {
  Employee employee;
  Color backGroundColor;

  EmployeeWidget({
    super.key,
    required this.employee,
    required this.backGroundColor,
  });

  @override
  ConsumerState<EmployeeWidget> createState() => _EmployeeWidgetState();
}

class _EmployeeWidgetState extends ConsumerState<EmployeeWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          widget.backGroundColor = AppColors.grey100;

          Future.delayed(const Duration(milliseconds: 3), () {
            // 상태 관리 추가
            ref
                .read(employeeSelectProvider.notifier)
                .updateEmployee(widget.employee.id, widget.employee.name);

            context.pop(
              widget.employee,
            );
          });
        });
      },
      child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            color: widget.backGroundColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              NameIconWidget(
                name: widget.employee.name,
                size: const Size(
                  40.0,
                  40.0,
                ),
                textStyle: AppTextTheme.md.medium,
              ),
              const SizedBox(
                width: 16,
              ),
              Text(
                widget.employee.name,
                style: AppTextTheme.lg.medium.copyWith(
                  color: AppColors.grey700,
                ),
              ),
            ],
          )),
    );
  }
}
