import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rectanglo/components/flat_dropdown.dart';
import 'package:rectanglo/components/pop_button.dart';
import 'package:rectanglo/components/textarea.dart';
import 'package:rectanglo/config/themes.dart';
import 'package:rectanglo/models/level.dart';
import 'package:rectanglo/objects/blockTile.dart';
import 'package:rectanglo/scenes/level_editor.scene.dart';
import 'package:rectanglo/utils/nav_helper.dart';
import 'package:rectanglo/utils/tools.dart';
import 'package:widget_helper/widget_helper.dart';

import '../components/ripple_button.dart';

class CreateLevelInfo extends StatefulWidget {
  const CreateLevelInfo({super.key});

  @override
  State<CreateLevelInfo> createState() => _CreateLevelInfoState();
}

class _CreateLevelInfoState extends State<CreateLevelInfo> {
  final TextEditingController levelNameController = TextEditingController();
  final TextEditingController creatorNameController = TextEditingController();
  DropDownItem? selectedDifficulty;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SizedBox(
          width: kIsWeb ? 441 : MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Row(
                children: [
                  RippleButton(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.chevron_left_rounded,
                      size: 32,
                    ),
                  ),
                  Text(
                    "Level Information",
                    style: Themes().black18,
                  ).addMarginLeft(12),
                ],
              ),
              ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  TextArea(
                    controller: levelNameController,
                    hint: "Level Name",
                  ),
                  FlatDropDown(
                    selected: selectedDifficulty?.title,
                    selectedValue: selectedDifficulty?.value,
                    menu: const ["Easy", "Normal", "Hard"],
                    value: const [0, 1, 2],
                    hint: "Select Difficulty",
                    onSelected: (selected) {
                      setState(() {
                        selectedDifficulty = selected;
                      });
                    },
                  ).addMarginTop(24),
                  TextArea(
                    controller: creatorNameController,
                    hint: "Your creator name",
                  ).addMarginTop(24),
                ],
              ).addExpanded,
              PopButton(
                text: "Continue",
                onTap: () {
                  if (levelNameController.text.isNotEmpty &&
                      selectedDifficulty != null &&
                      creatorNameController.text.isNotEmpty) {
                    List<BlockTile> blocks = [];
                    List<int> blockSize = [25, 100, 225];
                    for (int i = 0;
                        i < blockSize[selectedDifficulty?.value];
                        i++) {
                      blocks.add(
                        BlockTile(
                          state: 0,
                          currentState: 0,
                          color: Themes.primary,
                          editMode: true,
                        ),
                      );
                    }

                    Level level = Level(
                      id: DateTime.now().microsecondsSinceEpoch.toString(),
                      difficulty: selectedDifficulty?.value as int,
                      data: blocks,
                      creatorName: creatorNameController.text,
                      playersCount: 0,
                      rate: 0,
                      description: levelNameController.text,
                      backgroundColor: Colors.white,
                    );

                    NavHelper.navigateReplace(
                      context,
                      LevelEditorScreen(level: level),
                    );
                  } else {
                    Tools.showToast(text: "All field is required");
                  }
                },
              ).addAllPadding(24),
            ],
          ),
        ),
      ),
    );
  }
}
