import 'package:flutter_test/flutter_test.dart';
import 'package:ship_tracker/core/helpers/courier_identifier.dart';

void main() {
  test('Shopee Express - 1',
      () => expect(courierIdentifier('SPXID048294639629'), 'Shopee Express'));
  test('Shopee Express - 2',
      () => expect(courierIdentifier('SPXID045818195318'), 'Shopee Express'));
  test('Anteraja - 1',
      () => expect(courierIdentifier('11000474043604'), 'Anteraja'));
  test('Anteraja - 2',
      () => expect(courierIdentifier('10000614611342'), 'Anteraja'));
  test('ID Express - 1',
      () => expect(courierIdentifier('IDS9002389381747'), 'ID Express'));
  test('JNE Express - 1',
      () => expect(courierIdentifier('CM92815696614'), 'JNE Express'));
  test('JNE Express - 2',
      () => expect(courierIdentifier('CM96985249054'), 'JNE Express'));
  test('SiCepat - 1',
      () => expect(courierIdentifier('004347705813'), 'SiCepat'));
  test('SiCepat - 2',
      () => expect(courierIdentifier('004343839880'), 'SiCepat'));
  test('SiCepat - 3',
      () => expect(courierIdentifier('004351817693'), 'SiCepat'));
  test('JNE Trucking - 1',
      () => expect(courierIdentifier('JT40778727428'), 'JNE Trucking'));
  test('JNE Trucking - 2',
      () => expect(courierIdentifier('JT49264514997'), 'JNE Trucking'));
  test('J&T Cargo - 1',
      () => expect(courierIdentifier('200651063269'), 'J&T Cargo'));
  test('J&T Cargo - 2',
      () => expect(courierIdentifier('200654750593'), 'J&T Cargo'));
  test('Ninja Express - 1',
      () => expect(courierIdentifier('SHP8889012797'), 'Ninja Express'));
  test('Ninja Express - 2',
      () => expect(courierIdentifier('SHP0774364150'), 'Ninja Express'));
  test('J&T Express - 1',
      () => expect(courierIdentifier('JP6494753030'), 'J&T Express'));
  test('J&T Express - 2',
      () => expect(courierIdentifier('JP7395920062'), 'J&T Express'));
  test('J&T Express - 3',
      () => expect(courierIdentifier('JX6494753030'), 'J&T Express'));
  test('J&T Express - 4',
      () => expect(courierIdentifier('JB6494753030'), 'J&T Express'));
  test('J&T Express - 5',
      () => expect(courierIdentifier('JD6494753030'), 'J&T Express'));
}
