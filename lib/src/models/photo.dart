import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_app/src/models/photo_location.dart';

class Photo {
  final String? id;
  final PhotoLocation? location;
  final File? image;

  Photo({@required this.id, @required this.location, @required this.image});
}
