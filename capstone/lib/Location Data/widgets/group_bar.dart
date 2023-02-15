import 'package:capstone/Location%20Data/widgets/data_container.dart';
import 'package:flutter/material.dart';

class GroupBar extends StatelessWidget {
  const GroupBar({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> tabs = <String>[
      'Tab 1',
      'Tab 2',
      'Tab 3',
      'Tap 4',
      'Tap 5',
      'Tab 6'
    ];
    return DefaultTabController(
        length: tabs.length,
        child: Scaffold(
          body: SizedBox(
            height: 2000,
            child: Column(children: [
              SizedBox(
                  height: 100,
                  child: TabBar(
                    tabs: tabs.map((String name) => Tab(text: name)).toList(),
                    labelColor: const Color(0xFF000000),
                  )),
              SizedBox(
                  height: 1000,
                  child: TabBarView(
                    children: tabs.map((String name) {
                      return const DataContainer();
                    }).toList(),
                  )),
            ]),
          ),
        ));
  }
}
