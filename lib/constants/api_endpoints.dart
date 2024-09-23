class ApiEndpoints {
  ///WEATHER
  static String weatherBaseUrl =
      "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline";
  static const String location = '/{location}';
  static const String last7Days = '$location/last7days';

  ///CURRENCY
  static const String exchangeRate = 'http://api.exchangeratesapi.io/v1/latest';
}
