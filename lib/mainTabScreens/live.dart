
import 'dart:core'; 

import 'package:cargpstracker/maplive.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';



class Live extends StatefulWidget {
  @override
  _LiveState createState() => _LiveState();
}

class _LiveState extends State<Live> with AutomaticKeepAliveClientMixin<Live> {
  @override
  void initState() {
    super.initState();
    // print('initState Live');
  }

  @override
  Widget build(BuildContext context) {
    return mapLive();
  }

  @override
  bool get wantKeepAlive => true;
}