import 'package:flutter_riverpod/flutter_riverpod.dart';

enum OperationsSegment { reserve, snacky, others }

class OperationsSegmentNotifier extends Notifier<OperationsSegment> {
  @override
  OperationsSegment build() => OperationsSegment.reserve;

  void setSegment(OperationsSegment segment) {
    state = segment;
  }
}

final operationsSegmentProvider =
    NotifierProvider<OperationsSegmentNotifier, OperationsSegment>(
      OperationsSegmentNotifier.new,
    );
