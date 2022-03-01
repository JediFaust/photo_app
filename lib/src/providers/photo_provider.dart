import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_app/src/models/photo.dart';
import 'package:photo_app/src/services/db_service.dart';

import '../models/photo_location.dart';

class PhotoProvider extends ChangeNotifier {
  List<Photo> _items = [];

  List<Photo> get items {
    return [..._items];
  }

  void addPhoto(File pickedImage, PhotoLocation location) {
    final newPhoto = Photo(
        id: DateTime.now().toString(), location: location, image: pickedImage);
    _items.add(newPhoto);
    notifyListeners();
    DBService.insert('photos', {
      'id': newPhoto.id as Object,
      'image': newPhoto.image!.path,
      'latitude': location.latitude as Object,
      'longitude': location.longitude as Object,
    });
  }

  Future<void> fetchAndSetPhotos() async {
    final dataList = await DBService.getData('photos');
    _items = dataList.map((item) {
      PhotoLocation location = PhotoLocation(
          latitude: item['latitude'], longitude: item['latitude']);
      return Photo(
          id: item['id'], image: File(item['image']), location: location);
    }).toList();
    notifyListeners();
  }
}
