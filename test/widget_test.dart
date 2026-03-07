import 'package:flutter_test/flutter_test.dart';
import 'package:sv_team/app/app.dart';

void main() {
  testWidgets('App boots and shows main segmented controls', (tester) async {
    await tester.pumpWidget(const CateringApp());
    expect(find.text('Reserve'), findsOneWidget);
    expect(find.text('Manage'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
  });
}
