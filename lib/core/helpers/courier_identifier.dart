String courierIdentifier(String receipt) {
  final Map<RegExp, String> mapping = {
    RegExp(r'^1000|^11000'): 'Anteraja',
    RegExp(r'^00|^000'): 'SiCepat',
    RegExp(r'^JD|^JX|^JP|^JB'): 'J&T Express',
    RegExp(r'^SPXID'): 'Shopee Express',
    RegExp(r'^IDS'): 'ID Express',
    RegExp(r'^CM'): 'JNE Express',
    RegExp(r'^JT'): 'JNE Trucking',
    RegExp(r'^20065'): 'J&T Cargo',
    RegExp(r'^SHP'): 'Ninja Express',
  };

  for (var e in mapping.entries) {
    if (receipt.startsWith(e.key)) {
      return e.value;
    }
  }

  return 'Unidentified Courier';
}
