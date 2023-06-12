import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:wallpaper_app/controllers/local_storge_controller.dart';
import 'package:wallpaper_app/model/photo.dart';
import 'package:wallpaper_app/controllers/network_controller.dart';

import '../core/network/exeption.dart';
import '../core/network/url_component.dart';

class WillpaperController extends ChangeNotifier {
  List<Photo> photos = [];

  String errorMessage = "";
  int page = 1;
  bool photoIsLoaded = false;

  Future<void> getRoundomWellpaper(bool forRefresh, Function onLoading,
      Function onLoaded, Function onFail) async {
    try {
      if (photoIsLoaded) {
        return;
      }

      onLoading();
      if (forRefresh) {
        page = 1;
      }
      photoIsLoaded = true;
      final response = await NetWorkController().restApi(EndPoints.curated.name,
          queryParameters: {"page": page.toString(), "per_page": "10"});
      Map responseMap = json.decode(response?.body ?? "");
      List<Photo> photos = List<Photo>.from(responseMap["photos"].map((json) =>
          Photo(
              id: json["id"],
              original: json["src"]["original"],
              portrait: json["src"]["portrait"])));

      if (photos.length >= 10) {
        photoIsLoaded = false;
      }
      if (forRefresh) {
        this.photos.clear();
      }
      this.photos.addAll(photos);
      page++;
      onLoaded();
    } on SocketException {
      errorMessage = "No Internet Connection,please check your connection";
      onFail();
    } on CustomException catch (e) {
      errorMessage = e.cause;
      onFail();
    } catch (e) {
      errorMessage = "Server Error";

      onFail();
    }
    notifyListeners();
  }

//************************** Favorit Photos *********************** */
  List<Photo> searchedPhotos = [];

  String searchErrorMessage = "";
  int searchedPage = 1;
  bool searchedPhotoIsLoaded = false;

  String query = "";
  Future<void> searchWillpaper(
    String query,
    bool searching,
    Function onLoading,
    Function onLoaded,
    Function onFail,
  ) async {
    if (searching) {
      searchedPage = 1;
      this.query = query;
      searchedPhotoIsLoaded = false;
    }
    if (searchedPhotoIsLoaded) {
      return;
    }
    if (query.isEmpty) {
      searchedPhotos.clear();
      return;
    }
    onLoading();
    searchedPhotoIsLoaded = true;
    try {
      final response = await NetWorkController().restApi(EndPoints.search.name,
          queryParameters: {
            "query": this.query,
            "per_page": "10",
            "page": searchedPage.toString()
          });
      Map responseMap = json.decode(response?.body ?? "");
      List<Photo> photos = List<Photo>.from(responseMap["photos"].map((json) =>
          Photo(
              id: json["id"],
              original: json["src"]["original"],
              portrait: json["src"]["portrait"])));
      if (photos.length >= 10) {
        searchedPhotoIsLoaded = false;
      }
      if (searching) {
        searchedPhotos.clear();
      }
      searchedPhotos.addAll(photos);

      searchedPage++;

      onLoaded();
      notifyListeners();
    } on SocketException {
      searchErrorMessage =
          "No Internet Connection,please check your connection";

      onFail();
      notifyListeners();
    } on CustomException catch (e) {
      searchErrorMessage = e.cause;

      onFail();
      notifyListeners();
    } catch (e) {
      searchErrorMessage = "Server Error";

      onFail();
      notifyListeners();
    }
  }

  void resetVar() {
    searchedPhotos = [];

    searchErrorMessage = "";
    searchedPage = 1;
    searchedPhotoIsLoaded = false;

    query = "";
  }

//************************** Favorit Photos *********************** */
  List<Photo> favoritPhotos = [];

  Future<void> addWallpaperToFavorit(
      Photo photo, Function onSuccess, Function onFail) async {
    try {
      Map<String, Object> photoRequrd = {
        "id": photo.id,
        "original": photo.original,
        "portrait": photo.portrait
      };
      await LocalStorgeController().addPhotoToFavorite(photoRequrd);
      onSuccess();
    } catch (e) {
      onFail();
    }
  }

  getFavoritPhoto() async {
    favoritPhotos = await LocalStorgeController().getSqlPhotos();
    notifyListeners();
  }

  Future<void> rempveWallpaperToFavorit(
      int index, int id, Function onFail) async {
    try {
      await LocalStorgeController().removeFromFavorite(id);
      favoritPhotos.removeAt(index);
      notifyListeners();
    } catch (e) {
      onFail();
    }
  }

  ////**************Save Image *********** */
  Future<void> saveImage(String imagePath, Function onSaving, Function onSucess,
      Function onFail) async {
    onSaving();

    await GallerySaver.saveImage(imagePath)
        .then((success) => onSucess())
        .catchError((e) => onFail());
    notifyListeners();
  }
}
