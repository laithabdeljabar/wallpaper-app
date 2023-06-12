import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:wallpaper_app/controllers/wallpaper_controller.dart';

import '../core/util/state_widget.dart';
import '../widget/wallpaper_widget.dart';

class FavoritScreen extends StatelessWidget {
  const FavoritScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final wellpeperController =
        Provider.of<WillpaperController>(context, listen: false);
    wellpeperController.getFavoritPhoto();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Favorite Screen"),
      ),
      body: Center(
        child: Selector<WillpaperController, int>(
          selector: (p0, controller) => controller.favoritPhotos.length,
          builder: (context, length, child) => length == 0
              ? const Text("There is no Image")
              : GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemCount: length,
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        SizedBox(
                            width: size.width,
                            child: WillpaperWidget(
                                photo:
                                    wellpeperController.favoritPhotos[index])),
                        IconButton(
                            onPressed: () {
                              wellpeperController.rempveWallpaperToFavorit(
                                  index,
                                  wellpeperController.favoritPhotos[index].id,
                                  () {
                                StateWidget().showSnackBarMessage(
                                    message:
                                        "An error occurred while deletion the image",
                                    color: Colors.redAccent,
                                    context: context);
                              });
                            },
                            icon: const Icon(Icons.delete, color: Colors.white))
                      ],
                    );
                  }),
        ),
      ),
    );
  }
}
