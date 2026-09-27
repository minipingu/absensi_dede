import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'bottom_nav.g.dart';

@riverpod
class BottomNav extends _$BottomNav {
  @override
  int build() {
    return 0;
  }

  void setIndex(int newIndex) {
    state = newIndex;
  }
}
