import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mymeattest/models/businessLayer/baseRoute.dart';
import 'package:mymeattest/models/businessLayer/global.dart' as global;
import 'package:mymeattest/screens/checkOutScreen.dart';
import 'package:mymeattest/screens/homeScreen.dart';
import 'package:mymeattest/screens/offerScreen.dart';
import 'package:mymeattest/screens/profileScreen.dart';
import 'package:mymeattest/screens/searchScreen.dart';

class BottomNavigationWidget extends BaseRoute {
  BottomNavigationWidget({a, o})
      : super(a: a, o: o, r: 'BottomNavigationWidget');
  @override
  _BottomNavigationWidgetState createState() =>
      new _BottomNavigationWidgetState();
}

class _BottomNavigationWidgetState extends BaseRouteState {
  int _currentIndex = 0;
  TabController _tabController;
  List<IconData> _iconDataList = [
    MdiIcons.homeOutline,
    MdiIcons.magnify,
    MdiIcons.brightnessPercent,
    MdiIcons.accountOutline
  ];
  var _bottomNavIndex = 0;

  _BottomNavigationWidgetState() : super();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        exitAppDialog();
        return null;
      },
      child: SafeArea(
          child: Scaffold(
        resizeToAvoidBottomInset: false,
        bottomNavigationBar: AnimatedBottomNavigationBar.builder(
          itemCount: _iconDataList
              .length, //global.isDarkModeEnable ? darkimageList.length : lightImageList.length,
          tabBuilder: (int index, bool isActive) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _iconDataList[index],
                  color: Theme.of(context)
                      .bottomNavigationBarTheme
                      .unselectedIconTheme
                      .color,
                  size: Theme.of(context)
                      .bottomNavigationBarTheme
                      .unselectedIconTheme
                      .size,
                ),
                const SizedBox(height: 5),
                isActive
                    ? Container(
                        height: 2,
                        width: 15,
                        color: Theme.of(context).primaryColorLight,
                      )
                    : SizedBox()
              ],
            );
          },
          splashRadius: 0,
          elevation: 0,
          backgroundColor:
              Theme.of(context).bottomNavigationBarTheme.backgroundColor,
          activeIndex: _bottomNavIndex,
          notchSmoothness: NotchSmoothness.softEdge,
          gapLocation: GapLocation.center,
          onTap: (index) => setState(() => _bottomNavIndex = index),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          elevation: 0,
          backgroundColor: Color(0xFFFA692C),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) =>
                    CheckoutScreen(a: widget.analytics, o: widget.observer),
              ),
            );
          },
          child: global.currentUser.cartCount != null &&
                  global.currentUser.cartCount > 0
              ? Badge(
                  badgeContent: Text(
                    "${global.currentUser.cartCount}",
                    style: TextStyle(color: Colors.red, fontSize: 08),
                  ),
                  padding: EdgeInsets.all(6),
                  badgeColor: Colors.white,
                  child: Icon(
                    MdiIcons.shoppingOutline,
                    color: Colors.white,
                    size: Theme.of(context)
                        .bottomNavigationBarTheme
                        .unselectedIconTheme
                        .size,
                  ),
                )
              : Icon(
                  MdiIcons.shoppingOutline,
                  color: Colors.white,
                  size: Theme.of(context)
                      .bottomNavigationBarTheme
                      .unselectedIconTheme
                      .size,
                ),

          // Icon(
          //   MdiIcons.shopping,
          //   color: Colors.white,
          //   size: Theme.of(context).bottomNavigationBarTheme.unselectedIconTheme.size,
          // )
        ),
        body: _screens().elementAt(_bottomNavIndex),
      )),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _tabController =
        new TabController(length: 4, vsync: this, initialIndex: _currentIndex);
    _tabController.addListener(_tabControllerListener);
  }

  List<Widget> _screens() => [
        HomeScreen(a: widget.analytics, o: widget.observer),
        SearchScreen(a: widget.analytics, o: widget.observer),
        OfferListScreen(
          a: widget.analytics,
          o: widget.observer,
        ),
        ProfileScreen(a: widget.analytics, o: widget.observer)
      ];

  void _tabControllerListener() {
    setState(() {
      _currentIndex = _tabController.index;
    });
  }
}
