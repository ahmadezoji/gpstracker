import 'package:cargpstracker/mainTabScreens/shared.dart';
import 'package:cargpstracker/util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pattern_lock/pattern_lock.dart';

class SetPattern extends StatefulWidget {
  @override
  _SetPatternState createState() => _SetPatternState();
}

class _SetPatternState extends State<SetPattern> {
  bool isConfirm = false;
  List<int>? pattern;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  void saveShared(List<int> input) async {
    List<String> strList = input.map((i) => i.toString()).toList();
    bool result = await savelist(SHARED_SWITCH_PATTERN_KEY, strList);
    print(result);
  }

  @override
  Widget build(BuildContext context) {
    late Color notSelectedColor =
    Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.black;
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("Set Pattern"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Flexible(
            child: Text(
              isConfirm ? "Confirm pattern" : "Draw pattern",
              style: TextStyle(fontSize: 26),
            ),
          ),
          Flexible(
            child: PatternLock(
              notSelectedColor: notSelectedColor,
              selectedColor: Colors.amber,
              pointRadius: 12,
              onInputComplete: (List<int> input) {
                if (input.length < 3) {
                  context.replaceSnackbar(
                    content: Text(
                      "At least 3 points required",
                      style: TextStyle(color: Colors.red),
                    ),
                  );
                  return;
                }
                if (isConfirm) {
                  if (listEquals<int>(input, pattern)) {
                    saveShared(input);
                    Navigator.of(context).pop(pattern);
                  } else {
                    context.replaceSnackbar(
                      content: Text(
                        "Patterns do not match",
                        style: TextStyle(color: Colors.red),
                      ),
                    );
                    setState(() {
                      pattern = null;
                      isConfirm = false;
                    });
                  }
                } else {
                  setState(() {
                    pattern = input;
                    isConfirm = true;
                  });
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
