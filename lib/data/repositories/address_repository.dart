import 'package:drift/drift.dart';

import '../database/database.dart';

class AddressRepository {
  final AppDatabase _db;

  AddressRepository(this._db);

  Stream<List<AddressesData>> watchAll() =>
      (_db.select(_db.addresses)..orderBy([
            (t) => OrderingTerm.desc(t.isDefault),
            (t) => OrderingTerm.desc(t.id),
          ]))
          .watch();

  Future<AddressesData?> defaultAddress() async {
    return (_db.select(_db.addresses)
          ..where((t) => t.isDefault.equals(true)))
        .getSingleOrNull();
  }

  Future<int> upsert({
    int? id,
    required String name,
    required String phone,
    required String region,
    required String detail,
    bool isDefault = false,
  }) async {
    return _db.transaction(() async {
      if (isDefault) {
        await _db.update(_db.addresses)
            .write(const AddressesCompanion(isDefault: Value(false)));
      }
      if (id == null) {
        // 首个地址强制默认
        final any = await _db.select(_db.addresses).get();
        if (any.isEmpty) isDefault = true;
        return _db.into(_db.addresses).insert(
              AddressesCompanion.insert(
                name: name,
                phone: phone,
                region: region,
                detail: detail,
                isDefault: Value(isDefault),
              ),
            );
      }
      await (_db.update(_db.addresses)..where((t) => t.id.equals(id))).write(
        AddressesCompanion(
          name: Value(name),
          phone: Value(phone),
          region: Value(region),
          detail: Value(detail),
          isDefault: Value(isDefault),
        ),
      );
      return id;
    });
  }

  Future<void> setDefault(int id) async {
    await _db.transaction(() async {
      await _db.update(_db.addresses)
          .write(const AddressesCompanion(isDefault: Value(false)));
      await (_db.update(_db.addresses)..where((t) => t.id.equals(id)))
          .write(const AddressesCompanion(isDefault: Value(true)));
    });
  }

  Future<void> remove(int id) async {
    await _db.transaction(() async {
      final addr = await (_db.select(_db.addresses)
            ..where((t) => t.id.equals(id)))
          .getSingleOrNull();
      await (_db.delete(_db.addresses)..where((t) => t.id.equals(id))).go();
      // 删除默认地址后自动指定另一个为默认
      if (addr?.isDefault == true) {
        final rest = await _db.select(_db.addresses).get();
        if (rest.isNotEmpty) {
          await (_db.update(_db.addresses)
                ..where((t) => t.id.equals(rest.first.id)))
              .write(const AddressesCompanion(isDefault: Value(true)));
        }
      }
    });
  }
}
