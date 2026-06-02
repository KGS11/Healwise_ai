import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:healwise_ai/features/hospitals/domain/hospital_model.dart';
import 'package:healwise_ai/features/hospitals/presentation/widgets/hospital_card.dart';
import 'package:healwise_ai/features/hospitals/presentation/widgets/location_permission_card.dart';

void main() {
  group('LocationPermissionCard Tests', () {
    testWidgets('renders permission card correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LocationPermissionCard(),
          ),
        ),
      );

      expect(find.text('Location Access Required'), findsOneWidget);
      expect(
        find.text('HealWise needs your location to find naturopathy centers near you.'),
        findsOneWidget,
      );
      expect(find.text('Enable Location Permission'), findsOneWidget);
      expect(find.text('Your location is never stored or shared with anyone.'), findsOneWidget);
    });
  });

  group('HospitalCard Tests', () {
    final mockHospital = HospitalModel(
      placeId: 'place_123',
      name: 'Naturopathy Wellness Centre',
      address: '123 Health Street, Bangalore',
      latitude: 12.9716,
      longitude: 77.5946,
      rating: 4.5,
      userRatingsTotal: 42,
      isOpenNow: true,
      phoneNumber: '+919876543210',
      distanceKm: 2.3,
      types: const ['hospital', 'health', 'point_of_interest', 'establishment'],
    );

    testWidgets('renders hospital details correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HospitalCard(
              hospital: mockHospital,
              onFetchPhoneNumber: (id) async => null,
              onTapCard: () {},
            ),
          ),
        ),
      );

      expect(find.text('Naturopathy Wellness Centre'), findsOneWidget);
      expect(find.text('123 Health Street, Bangalore'), findsOneWidget);
      expect(find.text('2.3 km'), findsOneWidget);
      expect(find.text('4.5'), findsOneWidget);
      expect(find.text('(42 reviews)'), findsOneWidget);
      expect(find.text('Open Now'), findsOneWidget);
      expect(find.text('Call'), findsOneWidget);
      expect(find.text('Directions'), findsOneWidget);
    });

    testWidgets('triggers callbacks and actions on tap', (WidgetTester tester) async {
      bool tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HospitalCard(
              hospital: mockHospital,
              onFetchPhoneNumber: (id) async => null,
              onTapCard: () {
                tapped = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Naturopathy Wellness Centre'));
      await tester.pump();
      expect(tapped, isTrue);
    });
  });
}
