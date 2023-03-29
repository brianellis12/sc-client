import 'dart:io';

import 'package:capstone/Location%20Data/models/census_data.dart';
import 'package:capstone/Location%20Data/models/geographic_types.dart';
import 'package:capstone/Location%20Data/models/location_data.dart';
import 'package:capstone/Location%20Data/models/sections.dart';
import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../authentication/state/auth_provider.dart';
import '../services/data_service.dart';
import 'package:path_provider/path_provider.dart';

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
  late String? stateCode;
  late String? county;
  late String? tract;

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
    stateCode = ref.watch(geographicTypesProvider).stateCode;
    county = ref.watch(geographicTypesProvider).county;
    tract = ref.watch(geographicTypesProvider).tract;

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
              trailing: ElevatedButton(
                child: const Text('Save'),
                onPressed: () {
                  mail(values, '$county, $stateCode', item.headerValue);
                },
              ),
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

  mail(List<String> data, String location, String header) async {
    String email = ref.watch(authProvider).user?.email ?? 'ellisbxn@gmail.com';
    String token = ref.watch(authProvider).googleToken;

    final smtpServer = gmailSaslXoauth2(email, token);

    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/data.txt');
    await file.writeAsString(data.join('\n'));

    final message = Message()
      ..from = Address(email, 'Your name')
      ..recipients.add(email)
      ..subject = 'Data Maps Information'
      ..html =
          '<h1>Data Maps Save File</h1>\n<p>Thanks for using Data Maps! Your information for $header from $location is attached</p>'
      ..attachments = [
        FileAttachment(File('${directory.path}/data.txt'))
          ..location = Location.inline
          ..cid = '<myimg@3.141>'
      ];

    try {
      await send(message, smtpServer);
    } on MailerException catch (e) {
      print('Message not sent.');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
  }
}
