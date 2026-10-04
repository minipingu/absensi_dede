import 'package:flutter_riverpod/flutter_riverpod.dart';

class MapRefreshNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void trigger() {
    state++;
  }
}

final mapRefreshTriggerProvider = NotifierProvider<MapRefreshNotifier, int>(
  MapRefreshNotifier.new,
);
