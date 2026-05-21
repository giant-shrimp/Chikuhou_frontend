class RainCloudTime {
  final String basetime;
  final String validtime;
  final bool isForecast;

  RainCloudTime({
    required this.basetime,
    required this.validtime,
    required this.isForecast,
  });

  factory RainCloudTime.fromJson(Map<String, dynamic> j) => RainCloudTime(
        basetime: j['basetime'] as String,
        validtime: j['validtime'] as String,
        isForecast: (j['member'] as String?) == 'forecast',
      );
}
