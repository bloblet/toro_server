DateTime floor(DateTime other) {
  return DateTime(other.year, other.month, other.day);
}

DateTime floorTo15Minutes(DateTime other) => DateTime.fromMillisecondsSinceEpoch((other.millisecondsSinceEpoch/900000).floor()*900000);