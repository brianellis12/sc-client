import 'package:capstone/Location%20Data/models/geographic_types.dart';
import 'package:capstone/Location%20Data/models/sections.dart';
import 'package:capstone/Location%20Data/services/data_service.dart';
import 'package:capstone/Location%20Data/widgets/data_container.dart';
import 'package:flutter/material.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:capstone/Location Data/models/location_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

  Future<void> setSections(GroupNames group) async {
    final locationDataService = ref.watch(locationDataServiceProvider);
    final Sections sections = await locationDataService.getSections(group.code);
    ref
        .read(sectionsProvider.notifier)
        .specifyCurrentSections(sections.currentSections);
  }

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
            children: enums.map((String name) {
              return const DataContainer();
            }).toList(),
          ),
        );
      }),
    );
  }
}

//  class GroupBar extends ConsumerStatefulWidget {
//    const GroupBar({Key? key}) : super(key: key);

//    @override
//    ConsumerState<GroupBar> createState() => _GroupBarState();
//  }

//  class _GroupBarState extends ConsumerState<GroupBar> {
  
//    late TabController _tabController;
//    @override
//    void initState() {
//      super.initState();
//      _tabController = TabController(vsync: this, length: tabs.length);

//    }

//    @override
//    Widget build(BuildContext context) {
//      final List<String> enums = EnumToString.toList(GroupNames.values);

//      List<String> tabs = enums.map((e) => e.replaceAll('_', ' ')).toList();

//      return DefaultTabController(
//          length: tabs.length,
//          child: Scaffold(
//            body: Column(children: [
//              SizedBox(
//                  height: 100,
//                  child: TabBar(
//                    tabs: tabs.map((String name) => Tab(text: name)).toList(),
//                    labelColor: const Color(0xFF000000),
//                    isScrollable: true,
//                    controller: _tabController,
//                  )),
//              SizedBox(
//                  height: 1500,
//                  child: TabBarView(
//                   children: tabs.map((String name) {
//                     return const DataContainer();
//                   }).toList(),
//                  )),
//            ]),
//          ));
//    }
//  }
