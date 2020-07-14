import 'package:flutter/material.dart';

class HomeModel {
  List getList() => HomeDataSingleton.getInstance()._list;
}

class HomeDataSingleton {
  /// 單例對象
  static HomeDataSingleton _instance;

  var _list = new List();

  /// 內部構造方法 可避免外部暴露構造函數 進行實例化
  HomeDataSingleton._internal() {
    initList();
  }

  void initList() {
    _list.add(HomeBean(
        coverPath: 'assets/icon_first.jpg',
        movieUrl: 'http://vjs.zencdn.net/v/oceans.mp4'));
    _list.add(HomeBean(
        coverPath: 'assets/icon_second.jpg',
        movieUrl: 'http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4'));
    _list.add(HomeBean(
        coverPath: 'assets/icon_third.jpg',
        movieUrl: 'http://www.w3school.com.cn/example/html5/mov_bbb.mp4'));
    _list.add(HomeBean(
        coverPath: 'assets/icon_first.jpg',
        movieUrl: 'http://vjs.zencdn.net/v/oceans.mp4'));
    _list.add(HomeBean(
        coverPath: 'assets/icon_second.jpg',
        movieUrl: 'http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4'));
    _list.add(HomeBean(
        coverPath: 'assets/icon_third.jpg',
        movieUrl: 'http://www.w3school.com.cn/example/html5/mov_bbb.mp4'));
  }

  /// 工廠構造方法 這裡使用命名構造函數方式進行聲明
  factory HomeDataSingleton.getInstance() => _getInstance();

  /// 獲取單例內部方法
  static _getInstance() {
    // 只能有一個實例
    if (_instance == null) _instance = HomeDataSingleton._internal();
    return _instance;
  }
}

class HomeBean {
  final String coverPath;
  final String movieUrl;

  HomeBean({@required this.coverPath, @required this.movieUrl});
}
