import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pattern_lock/pattern_lock.dart';

class CheckPattern extends StatefulWidget {
  const CheckPattern({Key? key, required this.pattern, required this.bswitch})
      : super(key: key);
  final List<int>? pattern;
  final bool bswitch;

  @override
  _CheckPatternState createState() => _CheckPatternState();
}

class _CheckPatternState extends State<CheckPattern>
    with AutomaticKeepAliveClientMixin<CheckPattern> {
  @override
  void initState() {
    super.initState();
  }

  void switchChange() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Check Pattern"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Flexible(
            child: Text(
              "Draw Your pattern",
              style: TextStyle(fontSize: 26),
            ),
          ),
          Flexible(
            child: PatternLock(
              selectedColor: Colors.red,
              pointRadius: 8,
              showInput: true,
              dimension: 3,
              relativePadding: 0.7,
              selectThreshold: 25,
              fillPoints: true,
              onInputComplete: (List<int> input) {
                if (listEquals<int>(input, widget.pattern)) {
                  switchChange();
                  Navigator.of(context).pop(true);
                } else {
                  Fluttertoast.showToast(msg: 'الگو مظابقت ندارد');
                }
              },
            ),
          ),
          // Flexible(
          //   child: TextButton(
          //     onPressed: () {
          //       Navigator.pushReplacement(
          //           context,
          //           MaterialPageRoute(
          //               builder: (_) => SetPattern(), fullscreenDialog: false));
          //     },
          //     child: Text(
          //       "Reset pattern",
          //       style: TextStyle(color: Colors.blue, fontSize: 20),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
