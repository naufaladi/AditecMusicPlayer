import 'dart:convert';

enum SortMethod {
  alphabeticalAsc,
  alphabeticalDsc,
  chronologicalAsc,
  chronologicalDsc,
  random,
}

String toTitleCase(String string) {
  String result = string.trim().toLowerCase();
  result = '${result[0].toUpperCase()}${result.substring(1)}';

  result = result.splitMapJoin(
    RegExp(r'[ ].'),
    onMatch: (m) {
      return ' ${result[m.start + 1].toUpperCase()}';
    },
  );

  return result;
}

String formattedTimestamp(int timestamp) {
  int minuteHand = (timestamp / 60).floor();
  int secondHand = (timestamp % 60).toInt();
  return '$minuteHand:${secondHand.toString().padLeft(2, '0')}';
}

String simplifyCount(int count) {
  String symbol = '';
  String simpleNum = count.toString();

  if (count > 999) {
    simpleNum = (count / 1000).toStringAsFixed(1);
    symbol = 'k';
  } else if (count > 99999) {
    simpleNum = (count / 1000).toStringAsFixed(0);
  } else if (count > 999999) {
    simpleNum = (count / 1000000).toStringAsFixed(1);
    symbol = 'm';
  }

  return (simpleNum + symbol);
}

void printMap(Map map) {
  print(JsonEncoder.withIndent('  ').convert(map));
}
