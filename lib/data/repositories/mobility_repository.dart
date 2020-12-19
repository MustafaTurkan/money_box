import 'package:money_box/data/data.dart';
import 'package:money_box/domain/domain.dart';

class MobilityRepository implements IMobilityRepository {
  MobilityRepository(this.moneyBoxDb);
  final MoneyBoxDb moneyBoxDb;

  @override
  Future<void> add(Mobility mobility) async {
    await moneyBoxDb.insertMobility(mobility);
  }
}
