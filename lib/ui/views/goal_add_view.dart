import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
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
  Localizer localizer;
  AppTheme appTheme;
  Uint8List image;
  MediaQueryData mediaQuery;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    localizer = context.getLocalizer();
    mediaQuery = context.getMediaQuery();
    appTheme = context.getTheme();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<GoalAddCubit>(
      create: (context) => GoalAddCubit(goalRepository: repository),
      child: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Scaffold(
              appBar: AppBar(
                title: Text(localizer.addGoal),
              ),
              body: ContentContainer(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    buildImage(),
                    FieldContainer(
                      padding: const EdgeInsets.all(Space.m),
                      labelText: 'Title',
                      child: TextField(),
                    ),
                    FieldContainer(
                      padding: const EdgeInsets.all(Space.m),
                      labelText: 'Target Amount',
                      child: TextField(
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          MoneyInputFormatter(
                          
                              )
                        ],
                      ),
                    ),
                    FieldContainer(
                      padding: const EdgeInsets.all(Space.m),
                      labelText: 'Target Date',
                      child: DateField(
                        value: DateTime.now(),
                        onChanged: (val) {},
                      ),
                    ),
                  ],
                ),
              ),
              floatingActionButton: buildGoalAddButton(context),
            ),
          )
        ],
      ),
    );
  }

  Widget buildGoalAddButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {},
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
}
