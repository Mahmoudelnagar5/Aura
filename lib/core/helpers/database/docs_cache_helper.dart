import 'package:aura/features/home/data/models/recent_doc_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class DocsCacheHelper {
  static const String boxName = 'recent_docs';

  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(RecentDocModelAdapter());
    if (!Hive.isBoxOpen(boxName)) {
      await Hive.openBox(boxName);
    }
  }

  static Future<void> addDoc(RecentDocModel doc) async {
    final box = Hive.box(boxName);
    await box.add(doc.toMap());
  }

  static List<RecentDocModel> getDocs() {
    final box = Hive.box(boxName);
    return box.values
        .map((e) => RecentDocModel.fromMap(Map<String, dynamic>.from(e)))
        .toList()
        .reversed
        .toList();
  }

  static Future<void> clearDocs() async {
    final box = Hive.box(boxName);
    await box.clear();
  }
}
