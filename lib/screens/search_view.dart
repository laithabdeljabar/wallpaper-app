import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../controllers/wallpaper_controller.dart';
import '../core/util/state_widget.dart';
import '../widget/wallpaper_widget.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final _controller = ScrollController();
  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      if (_controller.position.maxScrollExtent == _controller.offset) {
        _searchWallpaper(context, false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final willpaperController =
        Provider.of<WillpaperController>(context, listen: false);

    return WillPopScope(
      onWillPop: () async {
        willpaperController.resetVar();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            TextField(
              decoration:
                  const InputDecoration(hintText: "Search wallpaper . . ."),
              onChanged: (query) =>
                  Provider.of<WillpaperController>(context, listen: false)
                      .searchWillpaper(
                          query,
                          true,
                          () {},
                          () {},
                          () => StateWidget().showSnackBarMessage(
                              message: willpaperController.searchErrorMessage,
                              color: Colors.redAccent,
                              context: context)),
            ),
            Selector<WillpaperController, int>(
              selector: (p0, controller) => controller.searchedPhotos.length,
              builder: (context, length, child) => Expanded(
                child: GridView.builder(
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    controller: _controller,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    itemCount: length,
                    itemBuilder: (context, index) {
                      return WillpaperWidget(
                        photo: willpaperController.searchedPhotos[index],
                      );
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _searchWallpaper(BuildContext context, bool refresh) {
    final willpaperController =
        Provider.of<WillpaperController>(context, listen: false);
    willpaperController.searchWillpaper(
      "",
      false,
      () => StateWidget().showLoadingWidget(context),
      () => Navigator.pop(context),
      () {
        Navigator.pop(context);
        StateWidget().showSnackBarMessage(
            message: willpaperController.searchErrorMessage,
            color: Colors.redAccent,
            context: context);
      },
    );
  }
}
