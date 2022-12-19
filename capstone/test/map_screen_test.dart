import 'package:capstone/Location%20Data/data_container.dart';
import 'package:capstone/Location%20Data/map_screen.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MapScreen());

    expect(find.byType(FlutterMap), findsOneWidget);
    expect(find.byType(DataContainer), findsOneWidget);
  });
}
