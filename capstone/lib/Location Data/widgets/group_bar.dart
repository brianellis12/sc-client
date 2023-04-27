import 'package:capstone/Location%20Data/models/sections.dart';
import 'package:capstone/Location%20Data/services/data_service.dart';
import 'package:capstone/Location%20Data/widgets/data_container.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:capstone/Location Data/models/location_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/*
* Holds a collection of dabs with the data containers, one for each census data group
*/
class GroupBar extends ConsumerStatefulWidget {
  const GroupBar({Key? key}) : super(key: key);

  @override
  ConsumerState createState() => _GroupBarState();
}

class _GroupBarState extends ConsumerState<GroupBar> {
  static final List<String> enums = EnumToString.toList(GroupNames.values)
      .map((e) => e.replaceAll('_', ' '))
      .toList();

  final List<Tab> myTabs = enums.map((String name) => Tab(text: name)).toList();
  Sections sections = Sections(currentSections: ["", " "]);
  // Get and set the sections for the group selected
  Future<void> setSections(GroupNames group) async {
    final locationDataService = ref.watch(locationDataServiceProvider);
    sections = await locationDataService.getSections(group.code);
    ref
        .read(sectionsProvider.notifier)
        .specifyCurrentSections(sections.currentSections);
  }

  // Build the Tab Bar
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: myTabs.length,
      // The Builder widget is used to have a different BuildContext to access
      // closest DefaultTabController.
      child: Builder(builder: (BuildContext context) {
        final TabController? tabController = DefaultTabController.of(context);
        tabController?.addListener(() {
          if (!tabController.indexIsChanging) {
            final group = GroupNames.values[tabController.index];
            final description = dataDescriptions[tabController.index];
            setSections(group);
          }
        });
        return Scaffold(
          appBar: TabBar(
            tabs: myTabs,
            isScrollable: true,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.black,
          ),
          body: TabBarView(
            children: [
              LayoutBuilder(builder: (context, constraints) {
                // Check if the parent width is less than 600
                if (constraints.maxWidth < 600) {
                  // Return a single column layout
                  return Column(
                    children: const [DataContainer("all")],
                  );
                } else {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                          flex: 1,
                          child: Column(
                            children: const [DataContainer("first")],
                          )),
                      Flexible(
                          flex: 1,
                          child: Column(
                            children: const [DataContainer("second")],
                          )),
                    ],
                  );
                }
              })
            ],
          ),
        );
      }),
    );
  }
}
