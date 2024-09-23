String getOnlyDate(String date) {
  return date.split('-').first;
}

String getOnlyTime(String date) {
  return date.split(' - ').last;
}

String? getDateNoYear(String date) {
  return '${getOnlyDate(date).split('/').last.trim()}. ${getOnlyDate(date).split('/').elementAt(1)}.';
}

String formatDateTime(String date) {
  return '${date.split(' - ').first.replaceAll('/', '-')}T${date.split(' - ').last}';
}
