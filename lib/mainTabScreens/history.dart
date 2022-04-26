import 'dart:core';
import 'package:cargpstracker/mapHistory.dart';
import 'package:cargpstracker/maplive.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'dart:convert' as convert;

import 'package:http/http.dart' as http;

import 'dart:developer';

class History extends StatefulWidget {
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History>
    with AutomaticKeepAliveClientMixin<History> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('build saam');
    return mapHistory();
  }

  @override
  bool get wantKeepAlive => true;
}
