import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ShellTab { manage, aufgaben, profile }

class BottomNavNotifier extends Notifier<ShellTab> {
  @override
  ShellTab build() => ShellTab.manage;

  void select(ShellTab tab) {
    state = tab;
  }
}

final bottomNavProvider = NotifierProvider<BottomNavNotifier, ShellTab>(
  BottomNavNotifier.new,
);
