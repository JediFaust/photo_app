// To parse this JSON data, do
//
//     final Location = LocationFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<City> cityFromJson(String str) =>
    List<City>.from(json.decode(str).map((x) => City.fromJson(x)));

String cityToJson(List<City> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class City {
  City({
    @required this.name,
    @required this.lat,
    @required this.lon,
    @required this.country,
  });

  final String? name;
  final double? lat;
  final double? lon;
  final String? country;

  factory City.fromJson(Map<String, dynamic> json) => City(
        name: json["name"],
        lat: json["lat"].toDouble(),
        lon: json["lon"].toDouble(),
        country: json["country"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "lat": lat,
        "lon": lon,
        "country": country,
      };
}
