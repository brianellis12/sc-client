import 'package:capstone/Location%20Data/widgets/data_container.dart';
import 'package:flutter/material.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:capstone/Location Data/models/location_data.dart';

class GroupBar extends StatelessWidget {
  const GroupBar({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> enums = EnumToString.toList(GroupNames.values);

    List<String> tabs = enums.map((e) => e.replaceAll('_', ' ')).toList();

    return DefaultTabController(
        length: tabs.length,
        child: Scaffold(
          body: Column(children: [
            SizedBox(
                height: 100,
                child: TabBar(
                  tabs: tabs.map((String name) => Tab(text: name)).toList(),
                  labelColor: const Color(0xFF000000),
                  isScrollable: true,
                )),
            SizedBox(
                height: 1500,
                child: TabBarView(
                  children: tabs.map((String name) {
                    return const DataContainer();
                  }).toList(),
                )),
          ]),
        ));
  }
}
