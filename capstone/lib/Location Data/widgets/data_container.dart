import 'package:capstone/Location%20Data/models/census_data.dart';
import 'package:capstone/Location%20Data/models/geographic_types.dart';
import 'package:capstone/Location%20Data/models/location_data.dart';
import 'package:capstone/Location%20Data/models/sections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/data_service.dart';

/*
* Expansion Panel to store the data for each section of a census data group
*/
class DataContainer extends ConsumerStatefulWidget {
  const DataContainer({super.key});

  @override
  ConsumerState createState() => _DataContainerState();
}

class _DataContainerState extends ConsumerState<DataContainer> {
  late List<String> headers;
  late List<String> values;
  late List<LocationData> _data;

  //Builds the widgets
  @override
  Widget build(BuildContext context) {
    //Gets the current state of the data and reloads the widget whenever a change occurs
    headers = ref.watch(sectionsProvider).currentSections ?? [];
    values = ref.watch(censusDataProvider).currentCensusData ?? [];

    _data = headers.map((header) {
      return LocationData(
          headerValue: header, values: values, id: headers.indexOf(header));
    }).toList();

    return SingleChildScrollView(
      child: Container(
        child: _buildPanel(),
      ),
    );
  }

  // Get the census data for the current section and the user's location
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

  //List of expansion Panels, one panel for each section in the census data group
  Widget _buildPanel() {
    return ExpansionPanelList.radio(
      initialOpenPanelValue: 2,
      children: _data.map<ExpansionPanelRadio>((LocationData item) {
        return ExpansionPanelRadio(
          value: item.id,
          headerBuilder: (BuildContext context, bool isExpanded) {
            // If a expansion panel is opened, populate with the associated data
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
