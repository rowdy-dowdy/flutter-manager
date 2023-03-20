import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manager/models/RoomModel.dart';
import 'package:manager/repositories/RoomRepository.dart';

class RoomData {
  final RoomModel? room;
  final bool loading;

  RoomData({
    required this.room,
    required this.loading,
  });

  RoomData.unknown()
    : room = null,
      loading = false;

  RoomData copyWithLoading (bool loading) {
    return RoomData(room: room, loading: loading);
  }
}

class RoomNotifier extends StateNotifier<RoomData> {
  final Ref ref;
  final String id;
  RoomNotifier(this.ref, this.id): super(RoomData.unknown()) {
    load(id);
  }
  
  Future<void> load(String id) async {
    state = RoomData(room: null, loading: true);
    var data = await ref.read(roomRepositoryProvider).getDetailRoom(id);
    state = RoomData(room: data, loading: false);
  }
}

final roomProvider = StateNotifierProvider.family<RoomNotifier, RoomData, String>((ref, id) {
  return RoomNotifier(ref, id);
});