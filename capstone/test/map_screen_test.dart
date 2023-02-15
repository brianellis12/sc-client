import 'package:capstone/Location%20Data/widgets/data_container.dart';
import 'package:capstone/Location%20Data/screens/map_screen.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_test/flutter_test.dart';

/*
* Widget test for Map Screen
* Assoc: Location Data/map_screen.dart
*/
void main() {
  testWidgets('Map Screen Test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MapScreen());

    expect(find.byType(FlutterMap), findsOneWidget);
    expect(find.byType(DataContainer), findsOneWidget);
  });
}
