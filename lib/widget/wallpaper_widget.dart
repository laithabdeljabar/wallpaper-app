import 'package:flutter/material.dart';

import '../model/photo.dart';
import '../screens/wallpaper_details_screen.dart';

class WillpaperWidget extends StatelessWidget {
  final Photo photo;

  const WillpaperWidget({
    super.key,
    required this.photo,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WallpaperDetailsScreen(
              photo: photo,
            ),
          )),
      child: Image.network(
        photo.portrait,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes!
                : null,
          );
        },
        fit: BoxFit.fill,
      ),
    );
  }
}
