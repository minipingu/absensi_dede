import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectedAttendanceNotifier extends Notifier<int?> {
  @override
  int? build() => null;

  void select(int? id) {
    state = id;
  }
}

final selectedAttendanceIdProvider =
    NotifierProvider<SelectedAttendanceNotifier, int?>(
      SelectedAttendanceNotifier.new,
    );
