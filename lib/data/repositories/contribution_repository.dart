import 'package:money_box/data/data.dart';
import 'package:money_box/domain/domain.dart';

class ContributionRepository implements IContributionRepository {
  ContributionRepository(this.moneyBoxDb);
  final MoneyBoxDb moneyBoxDb;

  @override
  Future<void> add(Contribution contribution) async {
    await moneyBoxDb.insertMobility(contribution);
  }
}
