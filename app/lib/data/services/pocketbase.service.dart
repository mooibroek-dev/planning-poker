import 'dart:async';

import 'package:app/data/services/event_source.service.dart';
import 'package:app/env.dart';
import 'package:app/main.dart';
import 'package:flutter/foundation.dart';
import 'package:pocketbase/pocketbase.dart';

enum DbCollection {
  rooms,
  participants,
}

abstract class IPocketBaseService {
  Future<RecordModel?> get(
    DbCollection collection,
    String id, {
    String? expand,
  });

  Future<List<RecordModel>> getList(
    DbCollection collection,
    Map<String, dynamic> query, {
    String? expand,
  });

  Future<RecordModel> create(
    DbCollection collection,
    Map<String, dynamic> data, {
    String? expand,
  });

  Future<RecordModel> update(
    DbCollection rooms,
    String id,
    Map<String, dynamic> data, {
    String? expand,
  });

  Future<void> delete(DbCollection collection, String id);

  Stream<RecordModel> startWatch(
    DbCollection rooms,
    String id, {
    String? expand,
  });

  Future<void> stopWatch(DbCollection rooms, String id);
}

class PocketBaseService implements IPocketBaseService {
  PocketBaseService() {
    final env = inject<Env>();
    _pocketBase = PocketBase(env.pocketBaseUrl);
  }

  late PocketBase _pocketBase;

  @override
  Future<RecordModel?> get(DbCollection collection, String id, {String? expand}) async {
    final record = await _pocketBase
        .collection(collection.name)
        .getOne(
          id,
          expand: expand,
        )
        .catchError((e) {
      return RecordModel();
    });

    return record.id.isEmpty ? null : record;
  }

  @override
  Future<List<RecordModel>> getList(DbCollection collection, Map<String, dynamic> query, {String? expand}) async {
    final resultList = await _pocketBase //
        .collection(collection.name)
        .getList(
          query: query,
          expand: expand,
        );
    return resultList.items;
  }

  @override
  Future<RecordModel> create(DbCollection collection, Map<String, dynamic> data, {String? expand}) {
    return _pocketBase //
        .collection(collection.name)
        .create(body: data);
  }

  @override
  Future<RecordModel> update(DbCollection collection, String id, Map<String, dynamic> data, {String? expand}) {
    return _pocketBase //
        .collection(collection.name)
        .update(id, body: data, expand: expand);
  }

  @override
  Future<void> delete(DbCollection collection, String id) {
    return _pocketBase.collection(collection.name).delete(id);
  }

  @override
  Stream<RecordModel> startWatch(DbCollection collection, String id, {String? expand}) {
    final streamController = StreamController<RecordModel>();

    if (kIsWeb) {
      inject<IEventSourceService>().subscribe('${collection.name}/$id', expand, (event) {
        if (event.record == null) return;
        streamController.add(event.record!);
      });
    } else {
      _pocketBase.collection(collection.name).subscribe(
        id,
        (event) {
          if (event.record == null) null;
          streamController.add(event.record!);
        },
        expand: expand,
      );
    }

    return streamController.stream;
  }

  @override
  Future<void> stopWatch(DbCollection collection, String id) {
    return _pocketBase.collection(collection.name).unsubscribe(id);
  }
}
