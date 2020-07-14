import 'dart:async';
import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'home_model.dart';

class HomeScreenListViewItem extends StatefulWidget {
  final int index;
  final ValueNotifier<double> notifier;
  final HomeBean bean;

  HomeScreenListViewItem(
      {@required this.index, @required this.notifier, @required this.bean});

  @override
  _HomeScreenListViewItemState createState() => _HomeScreenListViewItemState();
}

class _HomeScreenListViewItemState extends State<HomeScreenListViewItem> {
  FijkPlayer _player;
  Timer _timer;
  bool _start = false;
  bool _expectStart = false;

  @override
  void initState() {
    super.initState();
    widget.notifier.addListener(scrollListener);
    int mills = widget.index <= 0 ? 100 : 2000;
    _timer = Timer(Duration(milliseconds: mills), () async {
      _player = FijkPlayer();
      await _player?.setDataSource(widget.bean.movieUrl);
      await _player?.prepareAsync();
      scrollListener();
      if (mounted) setState(() {});
    });
  }

  void scrollListener() {
    if (!mounted) return;
    double pixels = widget.notifier.value * 1.1;
    int x = pixels ~/ 640;
    if (_player != null && widget.index == x) {
      _expectStart = true;
      _player.removeListener(pauseListener);
      if (_start == false && _player.isPlayable()) {
        _player.start();
        _start = true;
      } else if (_start == false) {
        _player.addListener(startListener);
      }
    } else if (_player != null) {
      _expectStart = false;
      _player.removeListener(startListener);
      if (_player.isPlayable() && _start) {
        _player.pause();
        _start = false;
      } else if (_start) {
        _player.addListener(pauseListener);
      }
    }
  }

  void startListener() {
    FijkValue value = _player.value;
    if (value.prepared && !_start && _expectStart) {
      _start = true;
      _player.start();
    }
  }

  void pauseListener() {
    FijkValue value = _player.value;
    if (value.prepared && _start && !_expectStart) {
      _start = false;
      _player?.pause();
    }
  }

  void finalizer() {
    _player?.removeListener(startListener);
    _player?.removeListener(pauseListener);
    var player = _player;
    _player = null;
    player?.release();
  }

  @override
  void dispose() {
    super.dispose();
    widget.notifier.removeListener(scrollListener);
    _timer?.cancel();
    finalizer();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Container(
        height: height,
        child: Column(children: <Widget>[
          Expanded(
              child: _player != null
                  ? FijkView(
                      player: _player,
                      fit: FijkFit.fill,
                      cover: AssetImage(widget.bean.coverPath),
                    )
                  : Image.asset(
                      widget.bean.coverPath,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.fill,
                    ))
        ]));
  }
}
