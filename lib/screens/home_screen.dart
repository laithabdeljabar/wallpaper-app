import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:wallpaper_app/controllers/wallpaper_controller.dart';
import 'package:wallpaper_app/core/util/state_widget.dart';

import 'package:wallpaper_app/screens/search_view.dart';

import '../widget/wallpaper_widget.dart';
import 'favorit_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _controller = ScrollController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _getWellpaper(context, false);
      _controller.addListener(() {
        if (_controller.position.maxScrollExtent == _controller.offset) {
          _getWellpaper(context, false);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final willpaperController =
        Provider.of<WillpaperController>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Home Screen"),
        actions: [
          IconButton(
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FavoritScreen(),
                  )),
              icon: const Icon(Icons.favorite_sharp))
        ],
        leading: IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SearchView(),
                  ));
            },
            icon: const Icon(Icons.search)),
      ),
      body: RefreshIndicator(
          onRefresh: () async => _getWellpaper(context, true),
          child: Center(
            child: Selector<WillpaperController, int>(
              selector: (p0, controller) => controller.photos.length,
              builder: (context, length, child) => GridView.builder(
                  controller: _controller,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemCount: length,
                  itemBuilder: (context, index) {
                    return WillpaperWidget(
                      photo: willpaperController.photos[index],
                    );
                  }),
            ),
          )),
    );
  }

  _getWellpaper(BuildContext context, bool refresh) {
    final willpaperController =
        Provider.of<WillpaperController>(context, listen: false);
    willpaperController.getRoundomWellpaper(
        refresh,
        () => StateWidget().showLoadingWidget(context),
        () => Navigator.pop(context), () {
      Navigator.pop(context);
      StateWidget().showSnackBarMessage(
          message: willpaperController.errorMessage,
          color: Colors.redAccent,
          context: context);
    });
  }
}
