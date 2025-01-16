import 'package:app/env.dart';
import 'package:app/main.dart';
import 'package:pocketbase/pocketbase.dart';

enum DbCollection {
  rooms,
}

abstract class IPocketBaseService {
  Future<RecordModel?> getOne(DbCollection collection, String id);

  Future<RecordModel> create(DbCollection collection, Map<String, dynamic> data);

  Future<RecordModel> update(DbCollection rooms, String id, Map<String, dynamic> data);
}

class PocketBaseService implements IPocketBaseService {
  PocketBaseService() {
    final env = inject<Env>();
    _pocketBase = PocketBase(env.pocketBaseUrl);
  }

  late PocketBase _pocketBase;

  @override
  Future<RecordModel?> getOne(DbCollection collection, String id) async {
    final record = await _pocketBase.collection(collection.name).getOne(id).catchError((e) {
      return RecordModel();
    });

    return record.id.isEmpty ? null : record;
  }

  @override
  Future<RecordModel> create(DbCollection collection, Map<String, dynamic> data) {
    return _pocketBase.collection(collection.name).create(body: data);
  }

  @override
  Future<RecordModel> update(DbCollection collection, String id, Map<String, dynamic> data) {
    return _pocketBase.collection(collection.name).update(id, body: data);
  }
}
