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

class GradientPainter extends CustomPainter {
  GradientPainter({required this.gradient, required this.strokeWidth});

  final Gradient gradient;
  final double strokeWidth;
  final Paint paintObject = Paint();

  @override
  void paint(Canvas canvas, Size size) {
    Rect innerRect = Rect.fromLTRB(strokeWidth, strokeWidth,
        size.width - strokeWidth, size.height - strokeWidth);
    Rect outerRect = Offset.zero & size;

    paintObject.shader = gradient.createShader(outerRect);
    Path borderPath = _calculateBorderPath(outerRect, innerRect);
    canvas.drawPath(borderPath, paintObject);
  }

  Path _calculateBorderPath(Rect outerRect, Rect innerRect) {
    Path outerRectPath = Path()..addRect(outerRect);
    Path innerRectPath = Path()..addRect(innerRect);
    return Path.combine(PathOperation.difference, outerRectPath, innerRectPath);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

/*
* Expansion Panel to store the data for each section of a census data group
*/
class DataContainer extends ConsumerStatefulWidget {
  final String listPart;
  const DataContainer(this.listPart, {Key? key}) : super(key: key);

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
    List<String> allList = ref.watch(sectionsProvider).currentSections;
    var half = (allList.length / 2).round();

    switch (widget.listPart) {
      case "all":
        headers = allList;
        break;
      case "first":
        headers = allList.sublist(0, half);
        break;
      case "second":
        headers = allList.sublist(half);
        break;
      default:
    }
    values = ref.watch(censusDataProvider).currentCensusData ?? [];
    try {
      _data = headers.map((header) {
        return LocationData(
            headerValue: header, values: values, id: headers.indexOf(header));
      }).toList();

      return SingleChildScrollView(
        child: Container(
          child: _buildPanel(),
        ),
      );
    } catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Data Fields failed to load $err'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
    return Container();
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
      dividerColor: Colors.black,
      children: _data.map<ExpansionPanelRadio>((LocationData item) {
        return ExpansionPanelRadio(
            value: item.id,
            headerBuilder: (BuildContext context, bool isExpanded) {
              // If a expansion panel is opened, populate with the associated data
              if (isExpanded == true) {
                getCensusData(item.headerValue);
              }
              return SizedBox(
                  width: 1200,
                  child: ListTile(
                    title: Text(item.headerValue),
                    trailing: ElevatedButton(
                      child: const Text('Save'),
                      onPressed: () {
                        try {
                          showModalBottomSheet<void>(
                            context: context,
                            builder: (BuildContext context) {
                              return SizedBox(
                                height: 200,
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      ElevatedButton(
                                        onPressed: () => mail(
                                            values,
                                            '$county, $stateCode',
                                            item.headerValue),
                                        child: const Text('Send to Email'),
                                      ),
                                      const SizedBox(width: 100),
                                      ElevatedButton(
                                        onPressed: () => writeFile(values),
                                        child: const Text('Save as File'),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        } catch (err) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content:
                                  Text('Save selection failed to load $err'),
                              backgroundColor:
                                  Theme.of(context).colorScheme.error,
                            ),
                          );
                        }
                      },
                    ),
                  ));
            },
            body: SizedBox(
              width: 1200,
              child: Column(children: [
                ...values.map((item) => ListTile(
                      title: Text(item),
                      minVerticalPadding: 2.0,
                      shape: const RoundedRectangleBorder(
                        side: BorderSide(
                          color: Colors.black,
                        ),
                      ),
                    ))
              ]),
            ));
      }).toList(),
    );
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/data_maps_save.txt');
  }

  writeFile(List<String> data) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString(data.join('\n'));
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
    } catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to send email $err'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }
}
