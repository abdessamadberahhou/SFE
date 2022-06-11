import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:sfe_courrier/Screens/components/constatnts.dart';

import '../appbar_and_drawer/drawer.dart';

class FixedPage extends StatefulWidget {
  final Widget body;
  final bool? canBack;
  final String? title;
  const FixedPage({Key? key, required this.body, this.canBack = false, this.title}) : super(key: key);

  @override
  State<FixedPage> createState() => _FixedPageState();
}

class _FixedPageState extends State<FixedPage> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text( widget.title ?? '', style: TextStyle(color: Colors.white),),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        leading: !widget.canBack! ? Builder(builder: (BuildContext context) {
          return IconButton(
            icon: const Icon(IconlyLight.category, color: Colors.white,), onPressed: () {
            Scaffold.of(context).openDrawer();
          },
            tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
          );
        },
        ) : null,
        backgroundColor: testColor,
        elevation: 0,
      ),
      drawer: !widget.canBack! ? const NavigationDrawerWidget() : null,
      body: widget.body,
    );
  }
}
