import 'package:flutter/material.dart';
import 'home_model.dart';
import 'home_screen_list_view_item.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ValueNotifier<double> notifier = ValueNotifier(-1);

  @override
  Widget build(BuildContext context) {
    HomeModel().getList();
    return Scaffold(
      body: NotificationListener<ScrollNotification>(
        onNotification: onNotification,
        child: Stack(
          children: [
            buildListWheelScrollView(),
            buildColumn(),
          ],
        ),
      ),
    );
  }

  bool onNotification(ScrollNotification notification) {
    switch (notification.runtimeType) {
      case ScrollStartNotification:
        debugPrint("開始滾動");
        break;
      case ScrollUpdateNotification:
        debugPrint("正在滾動");
        break;
      case ScrollEndNotification:
        debugPrint("滾動停止");
        notifier.value = notification.metrics.pixels;
        break;
      case OverscrollNotification:
        debugPrint("滾動到邊界");
        break;
    }
    return true;
  }

  ListWheelScrollView buildListWheelScrollView() {
    var height = MediaQuery.of(context).size.height;
    var childCount = HomeModel().getList().length;
    return ListWheelScrollView.useDelegate(
        itemExtent: height,
        diameterRatio: 100,
        childDelegate: ListWheelChildBuilderDelegate(
            builder: (context, index) => HomeScreenListViewItem(
                index: index,
                notifier: notifier,
                bean: HomeModel().getList()[index]),
            childCount: childCount),
        physics: FixedExtentScrollPhysics());
  }

  Column buildColumn() {
    return Column(children: <Widget>[
      Expanded(flex: 1, child: SizedBox()),
      Row(children: <Widget>[
        Expanded(flex: 1, child: SizedBox()),
        Image.asset('assets/icon_right_bar.png',
            width: 100, fit: BoxFit.contain)
      ]),
      Image.asset('assets/icon_bottom_bar.png',
          width: double.infinity, fit: BoxFit.contain)
    ]);
  }
}
