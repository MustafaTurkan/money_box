import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:money_box/data/data.dart';
import 'package:money_box/domain/domain.dart';
import 'package:money_box/infrastructure/infrastructure.dart';
import 'package:money_box/ui/ui.dart';

class GoalAddView extends StatefulWidget {
  GoalAddView({Key key}) : super(key: key);

  @override
  _GoalAddViewState createState() => _GoalAddViewState();
}

class _GoalAddViewState extends State<GoalAddView> {
  _GoalAddViewState()
      : repository = AppService.get<IGoalRepository>(),
        navigator = AppService.get<AppNavigator>();

  final IGoalRepository repository;
  final AppNavigator navigator;
  final TextEditingController tecTitle = TextEditingController();
  final TextEditingController tecAmount = TextEditingController();
  final formKey = GlobalKey<FormState>();
  Localizer localizer;
  AppTheme appTheme;
  Uint8List image;
  MediaQueryData mediaQuery;
  WaitDialog waitDialog;
  DateTime currentDate = DateTime.now();
  SavingPeriod currentSavingPeriod = SavingPeriod.periodless;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    localizer = context.getLocalizer();
    mediaQuery = context.getMediaQuery();
    appTheme = context.getTheme();
    waitDialog ??= WaitDialog(context);
  }

  @override
  void dispose() {
    tecTitle.dispose();
    tecAmount.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<GoalAddCubit>(
        create: (context) => GoalAddCubit(goalRepository: repository),
        child: Builder(
          builder: (context) {
            return Scaffold(
              appBar: AppBar(
                title: Text(localizer.addGoal),
              ),
              body: BlocListener<GoalAddCubit, GoalAddState>(
                listener: (context, state) async {
                  if (state is GoalAdding) {
                    waitDialog.show();
                    return;
                  }
                  waitDialog.hide();
                  if (state is GoalAddedSucces) {
                    navigator.pop(context, result: true);
                  }
                  if (state is GoalAddedFail) {
                    await MessageDialog.error(context: context, message: state.message);
                  }
                },
                child: CustomScrollView(
                  slivers: [
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: ContentContainer(
                        child: buildForm(),
                      ),
                    )
                  ],
                ),
              ),
              floatingActionButton: buildGoalAddButton(context),
            );
          },
        ));
  }

  Form buildForm() {
    return Form(
      key: formKey,
      child: Column(
        children: [
          Spacer(),
          buildImage(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: Space.m),
            child: IndentDivider(),
          ),
          FieldContainer(
            padding: const EdgeInsets.all(Space.m),
            labelText: localizer.title,
            child: TextFormField(
              controller: tecTitle,
              validator: RequiredValidator<String>(errorText: localizer.requiredValue),
            ),
          ),
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
            labelText: localizer.goalDate,
            child: DateField(
              value: currentDate,
              onChanged: (val) {
                setState(() {
                  currentDate = val;
                });
              },
            ),
          ),
          FieldContainer(
              padding: const EdgeInsets.all(Space.m),
              labelText: localizer.savingPeriod,
              child: DropdownField<SavingPeriod>(
                  value: currentSavingPeriod,
                  items: SavingPeriod.values.map((e) {
                    return DropdownMenuItem<SavingPeriod>(
                        value: e,
                        child: Text(
                          localizer.translate(Enum.getName(e)),
                        ));
                  }).toList(),
                  onChanged: (val) {
                    setState(() {
                      currentSavingPeriod = val;
                    });
                  })),
          Spacer(
            flex: 4,
          )
        ],
      ),
    );
  }

  Widget buildGoalAddButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        await onSaveGoal(context);
      },
      child: Icon(AppIcons.check),
    );
  }

  Widget buildImage() {
    var emptyPhoto = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          AppIcons.camera,
          size: mediaQuery.size.widthPercent(20),
        ),
        Text(
          localizer.addPhoto,
          style: appTheme.textStyles.caption,
        ),
      ],
    );

    return Center(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(mediaQuery.size.widthPercent(24))),
        elevation: 2,
        child: GestureDetector(
          onTap: () async {
            await imagePicke();
          },
          child: CircleAvatar(
            backgroundColor: appTheme.colors.canvas,
            backgroundImage: image == null ? null : MemoryImage(image),
            radius: mediaQuery.size.widthPercent(20),
            child: image == null ? emptyPhoto : null,
          ),
        ),
      ),
    );
  }

  Future<void> imagePicke() async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
    final imageBytes = await pickedFile.readAsBytes();
    if (pickedFile != null) {
      setState(() {
        image = imageBytes;
      });
    }
  }

  Future<void> onSaveGoal(BuildContext context) async {
    if (formKey.currentState.validate()) {
      await context.getBloc<GoalAddCubit>().add(Goal(
            targetAmount: double.parse(tecAmount.text),
            title: tecTitle.text,
            img: image,
            targetDate: currentDate,
            frequency: currentSavingPeriod.index,
            currency: 'TRY',
          ));
    }
  }
}
