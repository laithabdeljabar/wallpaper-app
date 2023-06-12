import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:wallpaper_app/core/util/state_widget.dart';

import '../controllers/wallpaper_controller.dart';
import '../model/photo.dart';

class WallpaperDetailsScreen extends StatelessWidget {
  final Photo photo;
  const WallpaperDetailsScreen({super.key, required this.photo});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                Provider.of<WillpaperController>(context, listen: false)
                    .addWallpaperToFavorit(photo, () {
                  StateWidget().showSnackBarMessage(
                      message: "The image has been added successfully",
                      color: Colors.green,
                      context: context);
                }, () {
                  StateWidget().showSnackBarMessage(
                      message: "An error occurred while adding the image",
                      color: Colors.redAccent,
                      context: context);
                });
              },
              icon: const Icon(Icons.favorite)),
          IconButton(
              onPressed: () async {
                //
                Provider.of<WillpaperController>(context, listen: false)
                    .saveImage(photo.original, () {
                  StateWidget().showLoadingWidget(context);
                }, () {
                  Navigator.pop(context);
                  StateWidget().showSnackBarMessage(
                      message: "Image saved successfully",
                      color: Colors.green,
                      context: context);
                }, () {
                  Navigator.pop(context);
                  StateWidget().showSnackBarMessage(
                      message: "Image saved successfully",
                      color: Colors.redAccent,
                      context: context);
                });
              },
              icon: const Icon(Icons.save))
        ],
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Image.network(
          photo.original,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
            );
          },
          height: size.height,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
