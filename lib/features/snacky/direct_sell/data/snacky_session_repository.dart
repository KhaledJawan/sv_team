import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../../../../core/storage/hive_storage.dart';
import '../models/direct_sell_models.dart';

const _snackySessionStorageKey = 'snacky_session_json';

final snackySessionRepositoryProvider = Provider<SnackySessionRepository>((
  ref,
) {
  return SnackySessionRepository(box: HiveStorage.snackySessionBox());
});

class SnackySessionRepository {
  const SnackySessionRepository({required this.box});

  final Box<String> box;

  DirectSellSessionState? loadSession() {
    final raw = box.get(_snackySessionStorageKey);
    if (raw == null || raw.isEmpty) {
      return null;
    }

    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map) {
        return null;
      }
      return _stateFromMap(Map<String, dynamic>.from(decoded));
    } catch (_) {
      return null;
    }
  }

  Future<void> saveSession(DirectSellSessionState state) {
    return box.put(_snackySessionStorageKey, jsonEncode(_stateToMap(state)));
  }

  Future<void> clearSession() {
    return box.delete(_snackySessionStorageKey);
  }

  Map<String, dynamic> _stateToMap(DirectSellSessionState state) {
    return <String, dynamic>{
      'step': state.step.name,
      'unitPrices': state.unitPrices,
      'startingQuantities': state.startingQuantities,
      'soldQuantities': state.soldQuantities,
      'basketQuantities': state.basketQuantities,
      'sales': state.sales
          .map(
            (sale) => <String, dynamic>{
              'id': sale.id,
              'totalAmount': sale.totalAmount,
              'paidAmount': sale.paidAmount,
              'changeAmount': sale.changeAmount,
              'createdAtMs': sale.createdAt.millisecondsSinceEpoch,
              'lines': sale.lines
                  .map(
                    (line) => <String, dynamic>{
                      'itemId': line.itemId,
                      'itemName': line.itemName,
                      'quantity': line.quantity,
                      'unitPrice': line.unitPrice,
                    },
                  )
                  .toList(),
            },
          )
          .toList(),
    };
  }

  DirectSellSessionState? _stateFromMap(Map<String, dynamic> map) {
    final step = _stepFromName(map['step']);
    final unitPrices = _doubleMap(map['unitPrices']);
    final startingQuantities = _intMap(map['startingQuantities']);
    final soldQuantities = _intMap(map['soldQuantities']);
    final basketQuantities = _intMap(map['basketQuantities']);

    if (step == null) {
      return null;
    }

    final sales = _asList(map['sales'])
        .map((entry) => _saleFromMap(_asMap(entry)))
        .whereType<SnackySale>()
        .toList();

    return DirectSellSessionState(
      step: step,
      unitPrices: unitPrices,
      startingQuantities: startingQuantities,
      soldQuantities: soldQuantities,
      basketQuantities: basketQuantities,
      sales: sales,
    );
  }

  SnackySale? _saleFromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }

    final id = _asString(map['id']);
    final totalAmount = _asDouble(map['totalAmount']);
    final paidAmount = _asDouble(map['paidAmount']);
    final changeAmount = _asDouble(map['changeAmount']);
    final createdAtMs = _asInt(map['createdAtMs']);

    if (id == null ||
        totalAmount == null ||
        paidAmount == null ||
        changeAmount == null ||
        createdAtMs == null) {
      return null;
    }

    final lines = _asList(map['lines'])
        .map((entry) => _saleLineFromMap(_asMap(entry)))
        .whereType<SnackySaleLine>()
        .toList();

    return SnackySale(
      id: id,
      lines: lines,
      totalAmount: totalAmount,
      paidAmount: paidAmount,
      changeAmount: changeAmount,
      createdAt: DateTime.fromMillisecondsSinceEpoch(createdAtMs),
    );
  }

  SnackySaleLine? _saleLineFromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }

    final itemId = _asString(map['itemId']);
    final itemName = _asString(map['itemName']);
    final quantity = _asInt(map['quantity']);
    final unitPrice = _asDouble(map['unitPrice']);

    if (itemId == null ||
        itemName == null ||
        quantity == null ||
        unitPrice == null) {
      return null;
    }

    return SnackySaleLine(
      itemId: itemId,
      itemName: itemName,
      quantity: quantity,
      unitPrice: unitPrice,
    );
  }

  DirectSellStep? _stepFromName(dynamic raw) {
    final value = _asString(raw);
    if (value == null) {
      return null;
    }

    for (final step in DirectSellStep.values) {
      if (step.name == value) {
        return step;
      }
    }
    return null;
  }

  Map<String, int> _intMap(dynamic raw) {
    if (raw is! Map) {
      return const <String, int>{};
    }

    final parsed = <String, int>{};
    for (final entry in raw.entries) {
      final key = entry.key.toString();
      final value = _asInt(entry.value);
      if (value != null) {
        parsed[key] = value;
      }
    }
    return parsed;
  }

  Map<String, double> _doubleMap(dynamic raw) {
    if (raw is! Map) {
      return const <String, double>{};
    }

    final parsed = <String, double>{};
    for (final entry in raw.entries) {
      final key = entry.key.toString();
      final value = _asDouble(entry.value);
      if (value != null) {
        parsed[key] = value;
      }
    }
    return parsed;
  }

  List<dynamic> _asList(dynamic raw) {
    return raw is List ? raw : const <dynamic>[];
  }

  Map<String, dynamic>? _asMap(dynamic raw) {
    if (raw is Map) {
      return Map<String, dynamic>.from(raw);
    }
    return null;
  }

  String? _asString(dynamic raw) {
    if (raw is String) {
      final trimmed = raw.trim();
      return trimmed.isEmpty ? null : trimmed;
    }
    return null;
  }

  int? _asInt(dynamic raw) {
    if (raw is int) {
      return raw;
    }
    if (raw is num) {
      return raw.toInt();
    }
    if (raw is String) {
      return int.tryParse(raw.trim());
    }
    return null;
  }

  double? _asDouble(dynamic raw) {
    if (raw is double) {
      return raw;
    }
    if (raw is num) {
      return raw.toDouble();
    }
    if (raw is String) {
      return double.tryParse(raw.trim());
    }
    return null;
  }
}
