import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_app/src/providers/photo_provider.dart';
import 'package:photo_app/src/screens/photo_location.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:photo_app/src/models/photo_location.dart';

import 'package:photo_app/src/services/location_service.dart';

class PhotosList extends StatefulWidget {
  const PhotosList({Key? key}) : super(key: key);

  static const String routeName = '/';

  @override
  State<PhotosList> createState() => _PhotosListState();
}

class _PhotosListState extends State<PhotosList> {
  File? _storedImage;
  PhotoLocation? _location;

  Future<void> _takePicture() async {
    final picker = ImagePicker();
    final imageFile = await picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 600,
    );
    if (imageFile == null) {
      return; // Error handling when user goes back without taking a picture
    }

    setState(() {
      _storedImage = File(imageFile.path);
    });
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(imageFile.path);
    final savedImage = await _storedImage!.copy('${appDir.path}/$fileName');
    _storedImage = savedImage;
    final shotLocation = await LocationService.getGeolocation();
    _location = shotLocation;
    print('location loaded successfully');
    print(
        'latitude: ${_location!.latitude} and longitude: ${_location!.longitude}');
    if (_storedImage == null || _location == null) {
      print('null error on image or location');

      return;
    }
    Provider.of<PhotoProvider>(context, listen: false)
        .addPhoto(_storedImage!, _location!);
    print('Provider Updates nicely');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Photo Gallery'),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: Provider.of<PhotoProvider>(context, listen: false)
            .fetchAndSetPhotos(),
        builder: (ctx, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? const Center(
                child: SpinKitWave(
                  color: Colors.blue,
                  size: 150,
                ),
              )
            : Consumer<PhotoProvider>(
                child: const Center(
                    child: Text('No images found. Start adding one')),
                builder: (ctx, photoProvider, ch) => photoProvider.items.isEmpty
                    ? ch!
                    : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: photoProvider.items.length,
                        itemBuilder: (ctx, i) => Container(
                          padding: const EdgeInsets.fromLTRB(5, 10, 5, 100),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50)),
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          child: MaterialButton(
                            onPressed: () {
                              Navigator.pushNamed(context, MapScreen.routeName,
                                  arguments: photoProvider.items[i].location);
                            },
                            child: Image(
                              image: FileImage(photoProvider.items[i].image!),
                            ),
                          ),
                        ),
                      ),
              ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        elevation: 10,
        onPressed: _takePicture,
        label: const Text('Take a Picture'),
        icon: const Icon(Icons.camera),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}
