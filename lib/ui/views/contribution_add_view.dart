import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_box/data/data.dart';
import 'package:money_box/domain/domain.dart';
import 'package:money_box/infrastructure/infrastructure.dart';
import 'package:money_box/ui/ui.dart';

class ContributionAddView extends StatefulWidget {
  ContributionAddView({Key key, @required this.contributionType, @required this.goal}) : super(key: key);
  final ContributionType contributionType;
  final Goal goal;
  @override
  _ContributionAddViewState createState() => _ContributionAddViewState();
}

class _ContributionAddViewState extends State<ContributionAddView> {
  _ContributionAddViewState()
      : contributionRepository = AppService.get<IContributionRepository>(),
        goalRepository = AppService.get<IGoalRepository>(),
        navigator = AppService.get<AppNavigator>();

  final IContributionRepository contributionRepository;
  final IGoalRepository goalRepository;
  final AppNavigator navigator;
  final TextEditingController tecNote = TextEditingController();
  final TextEditingController tecAmount = TextEditingController();
  final formKey = GlobalKey<FormState>();
  AppTheme appTheme;
  Localizer localizer;
  DateTime currentDate = DateTime.now();
  WaitDialog waitDialog;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    appTheme = context.getTheme();
    localizer = context.getLocalizer();
    waitDialog ??= WaitDialog(context);
  }

  @override
  void dispose() {
    tecAmount.dispose();
    tecNote.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var titleText = widget.contributionType == ContributionType.decrement ? localizer.decrementMoney : localizer.incrementMoney;
    var color = widget.contributionType == ContributionType.decrement ? appTheme.colors.error : appTheme.colors.success;
    return BlocProvider<ContributionCubit>(
      create: (context) => ContributionCubit(goalRepository: goalRepository, contributionRepository: contributionRepository),
      child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              titleText,
              style: appTheme.textStyles.title.copyWith(color: color),
            ),
          ),
          body: BlocListener<ContributionCubit, ContributionState>(
            listener: (context, state) async {
              if (state is ContributionAdding) {
                waitDialog.show();
                return;
              }
              waitDialog.hide();
              if (state is ContributionAddedFail) {
                await MessageDialog.error(context: context, message: state.message);
              }
              if (state is ContributionAddedSucces) {
                navigator.pop(context, result: widget.goal);
              }
            },
            child: ContentContainer(
              margin: EdgeInsets.zero,
              child: buildForm(context),
            ),
          ),
          floatingActionButton: Builder(builder: (context) {
            return FloatingActionButton(
              onPressed: () async {
                await onAdd(context);
              },
              backgroundColor: color,
              child: Icon(AppIcons.check),
            );
          })),
    );
  }

  Widget buildForm(BuildContext context) {
    return Form(
      key: formKey,
      child: ListView(
        shrinkWrap: true,
        children: [
          FieldContainer(
            padding: const EdgeInsets.all(Space.m),
            labelText: localizer.goalAmount,
            child: TextFormField(
              controller: tecAmount,
              validator: MinAmountValidator(min: 0, errorText: localizer.mustBeGreaterThanZero),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
          ),
          FieldContainer(
            padding: const EdgeInsets.all(Space.m),
            labelText: localizer.note,
            child: TextFormField(
              controller: tecNote,
            ),
          ),
          FieldContainer(
            padding: const EdgeInsets.all(Space.m),
            labelText: localizer.goalDate,
            child: DateField(
              value: currentDate,
              onChanged: (val) {
                setState(() {
                  currentDate = val;
                });
              },
            ),
          )
        ],
      ),
    );
  }

  Future<void> onAdd(BuildContext context) async {
    if (!formKey.currentState.validate()) {
      return;
    }
    await context.getBloc<ContributionCubit>().add(
        widget.goal,
        Contribution(
            amount: double.parse(tecAmount.text),
            goalId: widget.goal.id,
            title: tecNote.text,
            transactionDate: currentDate,
            type: widget.contributionType.index));
  }
}
