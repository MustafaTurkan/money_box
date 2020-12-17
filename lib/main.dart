import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_box/app.dart';

import 'domain/domain.dart';

Future<void> main() async {
  Bloc.observer = AppBlocObserver();
  await App().run();
}
