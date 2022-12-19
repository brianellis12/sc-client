import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('ExpansionPanelList test', (WidgetTester tester) async {
    late int capturedIndex;
    late bool capturedIsExpanded;

    await tester.pumpWidget(
      MaterialApp(
        home: SingleChildScrollView(
          child: ExpansionPanelList(
            expansionCallback: (int index, bool isExpanded) {
              capturedIndex = index;
              capturedIsExpanded = isExpanded;
            },
            children: <ExpansionPanel>[
              ExpansionPanel(
                headerBuilder: (BuildContext context, bool isExpanded) {
                  return Text(isExpanded ? 'B' : 'A');
                },
                body: const SizedBox(height: 100.0),
              ),
            ],
          ),
        ),
      ),
    );

    expect(find.text('A'), findsOneWidget);
    expect(find.text('B'), findsNothing);
    RenderBox box = tester.renderObject(find.byType(ExpansionPanelList));
    final double oldHeight = box.size.height;
    expect(find.byType(ExpandIcon), findsOneWidget);
    await tester.tap(find.byType(ExpandIcon));
    expect(capturedIndex, 0);
    expect(capturedIsExpanded, isFalse);
    box = tester.renderObject(find.byType(ExpansionPanelList));
    expect(box.size.height, equals(oldHeight));

    // Now, expand the child panel.
    await tester.pumpWidget(
      MaterialApp(
        home: SingleChildScrollView(
          child: ExpansionPanelList(
            expansionCallback: (int index, bool isExpanded) {
              capturedIndex = index;
              capturedIsExpanded = isExpanded;
            },
            children: <ExpansionPanel>[
              ExpansionPanel(
                headerBuilder: (BuildContext context, bool isExpanded) {
                  return Text(isExpanded ? 'B' : 'A');
                },
                body: const SizedBox(height: 100.0),
                isExpanded: true, // this is the addition
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.text('A'), findsNothing);
    expect(find.text('B'), findsOneWidget);
    box = tester.renderObject(find.byType(ExpansionPanelList));
    expect(box.size.height - oldHeight,
        greaterThanOrEqualTo(100.0)); // 100 + some margin
  });
}
