import 'package:capstone/Location%20Data/location_data.dart';
import 'package:flutter/material.dart';
import 'data_service.dart';

class DataContainer extends StatefulWidget {
  const DataContainer({super.key});

  @override
  State<DataContainer> createState() => _DataContainerState();
}

class _DataContainerState extends State<DataContainer> {
  final List<LocationData> _data = [
    LocationData(values: [
      'Population: 14,328',
      'Percentage of the population under the age of 5: 3%',
      'Percentage of the population between the ages of 20 and 40: 36%',
      'Median age: 41',
      'Average Household size: 5.2'
    ], headerValue: 'Population Statistics'),
    LocationData(
        values: ['Average Household Income: 32,052'],
        headerValue: 'Income Data'),
    LocationData(
        values: ['Percentage that moved in the past 5 years: 12%'],
        headerValue: 'Geographic Mobility Statistics')
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: _buildPanel(),
      ),
    );
  }

  Widget _buildPanel() {
    return ExpansionPanelList(
        expansionCallback: (int index, bool isExpanded) {
          setState(() {
            _data[index].isExpanded = !isExpanded;
          });
        },
        children: _data.map<ExpansionPanel>((LocationData item) {
          final tiles = item.values?.map((element) => ListTile(
                title: Text(element),
              ));
          return ExpansionPanel(
            headerBuilder: (BuildContext context, bool isExpanded) {
              return ListTile(
                title: Text(item.headerValue),
              );
            },
            body: Column(children: [
              ...item.values!.map((item) => ListTile(
                    title: Text(item),
                  ))
            ]),
            isExpanded: item.isExpanded,
          );
        }).toList());
  }
}
