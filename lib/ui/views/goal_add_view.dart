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
                      child: TextField(),
                    ),
                    FieldContainer(
                      padding: const EdgeInsets.all(Space.m),
                      labelText: 'Target Date',
                      child: TextField(),
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
    return Center(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(mediaQuery.size.widthPercent(24))),
        elevation: 1,
        child: InkWell(
          borderRadius: BorderRadius.circular(mediaQuery.size.widthPercent(24)),
          onTap: () {},
          child: Stack(
            children: [
              CircleAvatar(
                backgroundColor: appTheme.colors.canvasLight,
                backgroundImage: image == null ? null : MemoryImage(image),
                radius: mediaQuery.size.widthPercent(20),
                child: image == null
                    ? Icon(
                        AppIcons.pig,
                        size: mediaQuery.size.widthPercent(24),
                      )
                    : null,
              ),
              Positioned(
                  bottom: 0,
                  right: mediaQuery.size.widthPercent(3),
                  child: Icon(
                    AppIcons.camera,
                    color: appTheme.colors.font,
                    size: mediaQuery.size.widthPercent(8),
                  ))
            ],
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
