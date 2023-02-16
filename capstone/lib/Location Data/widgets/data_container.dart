import 'package:capstone/Location%20Data/models/census_data.dart';
import 'package:capstone/Location%20Data/models/geographic_types.dart';
import 'package:capstone/Location%20Data/models/location_data.dart';
import 'package:capstone/Location%20Data/models/sections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/data_service.dart';

class MyStatefulWidget extends ConsumerStatefulWidget {
  const MyStatefulWidget({super.key});

  @override
  ConsumerState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends ConsumerState<MyStatefulWidget> {
  late List<String> headers;
  late List<String> values;
  late List<LocationData> _data;

  @override
  Widget build(BuildContext context) {
    headers = ref.watch(sectionsProvider).currentSections ?? [];
    values = ref.watch(censusDataProvider).currentCensusData ?? [];

    _data = headers.map((header) {
      return LocationData(
          headerValue: header, values: values, id: headers.indexOf(header));
    }).toList();

    // _data.forEach((element) {
    //   final locationData = ref.watch(locationDataProvider);
    //   bool isExpanded = locationData.isExpanded;
    //   String header = locationData.headerValue;

    //   if (isExpanded) {
    //     getCensusData(header);
    //   }
    // });

    return SingleChildScrollView(
      child: Container(
        child: _buildPanel(),
      ),
    );
  }

  void getCensusData(String section) async {
    final stateCode = ref.watch(geographicTypesProvider).stateCode;
    final county = ref.watch(geographicTypesProvider).county;
    final tract = ref.watch(geographicTypesProvider).tract;

    final locationDataService = ref.watch(locationDataServiceProvider);
    final CensusData censusData = await locationDataService.getCensusData(
        stateCode!, county!, tract!, section);

    ref
        .read(censusDataProvider.notifier)
        .specifyCurrentCensusData(censusData.currentCensusData);
  }

  Widget _buildPanel() {
    return ExpansionPanelList.radio(
      initialOpenPanelValue: 2,
      children: _data.map<ExpansionPanelRadio>((LocationData item) {
        return ExpansionPanelRadio(
          value: item.id,
          headerBuilder: (BuildContext context, bool isExpanded) {
            if (isExpanded == true) {
              getCensusData(item.headerValue);
            }
            return ListTile(
              title: Text(item.headerValue),
            );
          },
          body: Column(children: [
            ...values.map((item) => ListTile(
                  title: Text(item),
                ))
          ]),
        );
      }).toList(),
    );
  }
}

/*
* List of Expansion Panel Widgets
* Dynamically Rendered from inputted data
*/
class DataContainer extends ConsumerStatefulWidget {
  const DataContainer({Key? key}) : super(key: key);

  @override
  ConsumerState createState() => _DataContainerState();
}

class _DataContainerState extends ConsumerState<DataContainer> {
  // Temporary Hardcoded data to be replaced with data from the API
  late List<String> headers;
  late List<String> values;
  late List<LocationData> _data;

  @override
  Widget build(BuildContext context) {
    headers = ref.watch(sectionsProvider).currentSections ?? [];
    values = ref.watch(censusDataProvider).currentCensusData ?? [];
    _data = headers.map((header) => LocationData(headerValue: header)).toList();
    _data.forEach((element) {
      final locationData = ref.watch(locationDataProvider);
      bool isExpanded = locationData.isExpanded;
      String header = locationData.headerValue;

      if (isExpanded) {
        setData(header);
      }
    });

    return SingleChildScrollView(
      child: Container(
        child: _buildPanel(),
      ),
    );
  }

  void setData(String section) async {
    final stateCode = ref.watch(geographicTypesProvider).stateCode;
    final county = ref.watch(geographicTypesProvider).county;
    final tract = ref.watch(geographicTypesProvider).tract;

    final locationDataService = ref.watch(locationDataServiceProvider);
    final CensusData censusData = await locationDataService.getCensusData(
        stateCode!, county!, tract!, section);

    ref
        .read(censusDataProvider.notifier)
        .specifyCurrentCensusData(censusData.currentCensusData);
  }

  Widget _buildPanel() {
    return ExpansionPanelList(
        expansionCallback: (int index, bool isExpanded) {
          setState(() {
            _data[index].isExpanded = !isExpanded;
          });
        },
        children: _data.map<ExpansionPanel>((LocationData item) {
          final tiles = item.values.map((element) => ListTile(
                title: Text(element),
              ));
          return ExpansionPanel(
            headerBuilder: (BuildContext context, bool isExpanded) {
              return ListTile(
                title: Text(item.headerValue),
              );
            },
            body: Column(children: [
              ...values.map((item) => ListTile(
                    title: Text(item),
                  ))
            ]),
            isExpanded: item.isExpanded,
          );
        }).toList());
  }
}
