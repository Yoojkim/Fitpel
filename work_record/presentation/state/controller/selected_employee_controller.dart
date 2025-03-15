import 'package:flutter/material.dart';
import 'package:fitple/features/user/domain/employee.dart';

class SelectedEmployeeController extends ChangeNotifier {
  List<Employee> employees;

  SelectedEmployeeController({
    required this.employees,
  });

  void chcangeEmployees(List<Employee> newEmployees) {
    employees = newEmployees;

    notifyListeners();
  }
}
