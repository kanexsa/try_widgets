import 'package:flutter/material.dart';

class Tabs extends StatelessWidget {
  const Tabs({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //defaulttabcontroller en yakın tabbarı arar
      //tabcontroller ile oluştursaydık tabbarın içine controllerı vermemiz gerekirdi.
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(tabs: [
              Tab(icon: Icon(Icons.directions_car)),
              Tab(icon: Icon(Icons.directions_transit)),
              Tab(icon: Icon(Icons.directions_bike)),
            ]),
          ),
          body: const TabBarView(children: [
            //sıralama aynı olmalı
            Icon(Icons.directions_car),
            Icon(Icons.directions_transit),
            Icon(Icons.directions_bike),
          ]),
        ),
      ),
    );
  }
}
