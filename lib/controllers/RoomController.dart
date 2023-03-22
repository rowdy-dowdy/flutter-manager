// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import 'package:manager/models/MenuModel.dart';
import 'package:manager/models/RoomItemModel.dart';
import 'package:manager/models/RoomModel.dart';
import 'package:manager/repositories/RoomRepository.dart';

class RoomData extends Equatable {
  final RoomModel? room;
  final bool loading;
  final RoomModel? roomBackup;

  RoomData({
    required this.room,
    required this.loading,
    required this.roomBackup,
  });

  RoomData.unknown()
    : room = null,
      roomBackup = null,
      loading = false;

  RoomData copyWithLoading(bool loading) {
    return RoomData(room: room, loading: loading, roomBackup: roomBackup);
  }

  RoomData changeQuantityRoomItem(String itemId, int value) {
    if (room != null) {
      room?.items = room?.items.fold([],(t,e) {
        if (e.id == itemId) {
          e.quantity += value;

          if (e.quantity > 0) {
            t?.add(e);
          }
        }
        else {
          t?.add(e);
        }
        return t;
      }) ?? [];
      // room?.items = itemsTemp;
      // print(room?.toJson());
      // print(roomBackup?.toJson());
      return RoomData(room: room, loading: loading, roomBackup: roomBackup);
    } 
    else {
      return RoomData(room: room, loading: loading, roomBackup: roomBackup);
    }
  }

  RoomData createRoomItem(MenuModel menu) {
    if (room != null) {
      final item = room?.items.singleWhereOrNull((element) => element.menu.id == menu.id);

      if (item == null) {
        final uid = const Uuid().v4();
        room?.items.add(RoomItemModel(
          id: uid,
          menu: menu,
          quantity: 1
        ));
      }

      return RoomData(room: room, loading: loading, roomBackup: roomBackup);
    } 
    else {
      return RoomData(room: room, loading: loading, roomBackup: roomBackup);
    }
  }

  RoomData deleteRoomItem(String itemId) {
    if (room != null) {
      room?.items = room?.items.fold([],(t,e) {
        if (e.id != itemId) {
          t?.add(e);
        }
        return t;
      }) ?? [];
      // room?.items = itemsTemp;
      return RoomData(room: room, loading: loading, roomBackup: roomBackup);
    } 
    else {
      return RoomData(room: room, loading: loading, roomBackup: roomBackup);
    }
  }

  RoomData refresh() {
    if (room != null) {
      return RoomData(room: RoomModel.fromMap(roomBackup!.toMap()), loading: loading, roomBackup: roomBackup);
    } 
    else {
      return RoomData(room: room, loading: loading, roomBackup: roomBackup);
    }
  }

  @override
  List<Object?> get props => [room, loading, roomBackup];
}

class RoomNotifier extends StateNotifier<RoomData> {
  final Ref ref;
  final String id;
  RoomNotifier(this.ref, this.id): super(RoomData.unknown()) {
    load(id);
  }
  
  Future<void> load(String id) async {
    state = RoomData(room: null, loading: true, roomBackup: null);
    var data = await ref.read(roomRepositoryProvider).getDetailRoom(id);
    if (data == null) {
      state = RoomData(room: null, loading: false, roomBackup: null);
    }
    else {
      // RoomModel.fromMap(data.toMap());
      state = RoomData(room: RoomModel.fromMap(data.toMap()), loading: false, roomBackup: RoomModel.fromMap(data.toMap()));
    }
    
  }

  Future<void> refresh() async {
    state = state.refresh();
  }

  Future<void> changeQuantityRoomItem(String itemId, int value) async {
    state = state.changeQuantityRoomItem(itemId, value);
  }

  Future<void> createRoomItem(MenuModel menu) async {
    state = state.createRoomItem(menu);
    // print(state.room?.toJson());
    // print(state.roomBackup?.toJson());
  }

  Future<void> deleteRoomItem(String itemId) async {
    state = state.deleteRoomItem(itemId);
  }
}

final roomProvider = StateNotifierProvider.family<RoomNotifier, RoomData, String>((ref, id) {
  return RoomNotifier(ref, id);
});

// final roomItemProvider = Provider.family<RoomItemModel?, Map>((ref, data) {
//   final roomData = ref.watch(roomProvider(data['id']).notifier).state;
//   // print(roomData);
//   final items = roomData.room?.items ?? [];
//   final roomItem = items.singleWhereOrNull((element) => element.menu.id == data['itemId']);
//   return roomItem;
// });