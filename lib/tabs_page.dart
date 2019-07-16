import 'package:flutter/material.dart';
import 'package:firebase_analytics/observer.dart';

class TabsPage extends StatefulWidget {

  TabsPage(this.observer);

  final FirebaseAnalyticsObserver observer;
  static const String routeName = '/tab';

  @override
  _TabsPageState createState() => _TabsPageState(observer);
}

class _TabsPageState extends State<TabsPage> with SingleTickerProviderStateMixin, RouteAware {

  _TabsPageState(this.observer);

  final FirebaseAnalyticsObserver observer;
  TabController controller;
  int selectedIndex = 0;

  final List<Tab> tabs = <Tab>[
    const Tab(text: 'LEFT'),
    const Tab(text: 'RIGHT'),
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    observer.subscribe(this, ModalRoute.of(context));
  }

  @override
  void dispose() {
    observer.unsubscribe(this);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    controller = TabController(
      vsync: this,
      length: tabs.length,
      initialIndex: selectedIndex,
    );
    controller.addListener(() {
      setState(() {
        if (selectedIndex != controller.index) {
          selectedIndex = controller.index;
          sendCurrentTabToAnalytics();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: TabBar(
          controller: controller,
          tabs: tabs,
        ),
      ),
      body: TabBarView(
        controller: controller,
        children: tabs.map((Tab tab) {
          return Center(child: Text(tab.text));
        }).toList(),
      ),
    );
  }

  @override
  void didPush() {
    sendCurrentTabToAnalytics();
  }

  @override
  void didPopNext() {
    sendCurrentTabToAnalytics();
  }

  void sendCurrentTabToAnalytics() {
    observer.analytics.setCurrentScreen(
      screenName: '${TabsPage.routeName}/tab$selectedIndex',
    );
  }

}
