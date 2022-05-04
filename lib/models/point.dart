class Point {
  late  double lat;
  late  double lon;

  // final String name;
  final String dateTime;
  final double speed;

  final double mileage;
  final double heading;

// required this.name,
   Point({
    required this.lat,
    required this.lon,
    required this.dateTime,
    required this.speed,
    required this.mileage,
    required this.heading,
  });

  double getLat() {
    return lat;
  }

  double getLon() {
    return lon;
  }

  // String getName() {
  //   return name;
  // }
  void setLat(double lat) {
    this.lat = lat;
  }

  void setLon(double lon) {
    this.lon = lon;
  }

  double getSpeed() {
    return speed;
  }

  String getDateTime() {
    return dateTime;
  }

  double getMileage() {
    return mileage;
  }

  double getHeading() {
    return heading;
  }

// name: json['properties']["name"],/
  factory Point.fromJson(Map<String, dynamic> json) {
    return Point(
      lat: json['geometry']['coordinates'][1],
      lon: json['geometry']['coordinates'][0],
      dateTime: json['properties']["time"],
      speed: json['properties']["speed"],
      mileage: json['properties']["mileage"],
      heading: json['properties']["heading"],
    );
  }
}
