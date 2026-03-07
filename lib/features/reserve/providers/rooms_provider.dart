import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../models/room.dart';

final roomsProvider = Provider<List<Room>>((ref) {
  return List.generate(
    AppConstants.roomNames.length,
    (index) => Room(
      id: 'room_${(index + 1).toString().padLeft(3, '0')}',
      name: AppConstants.roomNames[index],
    ),
  );
});
