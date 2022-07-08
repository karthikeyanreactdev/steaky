import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:marquee/marquee.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mymeattest/models/businessLayer/baseRoute.dart';
import 'package:mymeattest/models/businessLayer/global.dart' as global;
import 'package:mymeattest/models/categoryFilterModel.dart';
import 'package:mymeattest/models/categoryModel.dart';
import 'package:mymeattest/models/homeModel.dart';
import 'package:mymeattest/screens/chatScreen.dart';
import 'package:mymeattest/screens/locationScreen.dart';
import 'package:mymeattest/screens/productDetailScreen.dart';
import 'package:mymeattest/screens/productRequestScreen.dart';
import 'package:mymeattest/screens/subCategoryListScreen.dart';
import 'package:shimmer/shimmer.dart';
// import 'package:speed_dial_fab/speed_dial_fab.dart';

class HomeScreen extends BaseRoute {
  HomeScreen({a, o}) : super(a: a, o: o, r: 'HomeScreen');
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends BaseRouteState {
  bool _isDataLoaded = false;
  CarouselController _carouselController;
  CarouselController _secondCarouselController;
  HomeModel _homeModel = HomeModel();
  int _currentIndex = 0;
  int _secondBannercurrentIndex = 0;

  GlobalKey<ScaffoldState> _scaffoldKey;
  final List<Category> _categoryList = [];
  final CatgoryFilter _catgoryFilter = CatgoryFilter();
  bool _isMoreDataLoaded = false;
  int page = 1;
  bool _isRecordPending = true;
  _HomeScreenState() : super();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        body: RefreshIndicator(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          color: Theme.of(context).primaryColor,
          onRefresh: () async {
            _isDataLoaded = false;
            setState(() {});
            await _init();

            return null;
          },
          child: Column(
            children: [
              ListTile(
                onTap: () async {
                  if (global.lat != null && global.lng != null) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => LocationScreen(
                            a: widget.analytics, o: widget.observer),
                      ),
                    );
                  } else {
                    await getCurrentPosition().then((_) async {
                      if (global.lat != null && global.lng != null) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => LocationScreen(
                                a: widget.analytics, o: widget.observer),
                          ),
                        );
                      }
                    });
                  }
                },
                horizontalTitleGap: 2,
                contentPadding: const EdgeInsets.all(0),
                leading: Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8),
                  child: Container(
                    alignment: Alignment.center,
                    height: 40,
                    width: 40,
                    child: CachedNetworkImage(
                      imageUrl:
                          global.appInfo.imageUrl + global.appInfo.appLogo,
                      imageBuilder: (context, imageProvider) => Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          image: DecorationImage(
                              image: imageProvider, fit: BoxFit.cover),
                        ),
                      ),
                      placeholder: (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) => Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          image: DecorationImage(
                              image: AssetImage(global.defaultImage),
                              fit: BoxFit.cover),
                        ),
                      ),
                    ),
                  ),
                ),
                title: Text('${AppLocalizations.of(context).txt_deliver} @',
                    style: Theme.of(context).primaryTextTheme.bodyText1),
                subtitle: Text(global.currentLocation,
                    style: Theme.of(context)
                        .primaryTextTheme
                        .headline2
                        .copyWith(
                            fontWeight: FontWeight.w300,
                            fontFamily: 'PoppinsLight')),
                // trailing: Row(
                //   mainAxisSize: MainAxisSize.min,
                //   children: [
                //     IconButton(
                //         padding: EdgeInsets.all(0),
                //         onPressed: () async {
                //           await openBarcodeScanner(_scaffoldKey);
                //         },
                //         icon: Icon(
                //           MdiIcons.barcode,
                //           color: Theme.of(context)
                //               .appBarTheme
                //               .actionsIconTheme
                //               .color,
                //         )),
                //     global.currentUser.id != null
                //         ? IconButton(
                //             padding: EdgeInsets.all(0),
                //             onPressed: () {
                //               Navigator.of(context).push(
                //                 MaterialPageRoute(
                //                   builder: (context) => NotificationScreen(
                //                       a: widget.analytics,
                //                       o: widget.observer),
                //                 ),
                //               );
                //             },
                //             icon: Icon(
                //               MdiIcons.bellOutline,
                //               color: Theme.of(context)
                //                   .appBarTheme
                //                   .actionsIconTheme
                //                   .color,
                //             ),
                //           )
                //         : SizedBox(),
                //     global.currentUser.id != null &&
                //             global.currentUser.wallet > 0
                //         ? InkWell(
                //             customBorder: RoundedRectangleBorder(
                //               borderRadius: BorderRadius.circular(10),
                //             ),
                //             onTap: () {
                //               Navigator.of(context).push(
                //                 MaterialPageRoute(
                //                   builder: (context) => WalletScreen(
                //                       a: widget.analytics,
                //                       o: widget.observer),
                //                 ),
                //               );
                //             },
                //             child: Container(
                //               decoration: BoxDecoration(
                //                   color: Color(0xFFF05656),
                //                   borderRadius:
                //                       BorderRadius.all(Radius.circular(6))),
                //               margin: EdgeInsets.only(right: 10),
                //               padding: EdgeInsets.only(left: 5, right: 5),
                //               width: 85,
                //               height: 25,
                //               child: Row(
                //                 children: [
                //                   Icon(
                //                     MdiIcons.walletOutline,
                //                     color: Colors.white,
                //                     size: 20,
                //                   ),
                //                   Padding(
                //                     padding: EdgeInsets.only(
                //                       left: 5,
                //                     ),
                //                     child: Text(
                //                       '${global.appInfo.currencySign} ${global.currentUser.wallet}',
                //                       style: Theme.of(context)
                //                           .primaryTextTheme
                //                           .caption,
                //                     ),
                //                   ),
                //                 ],
                //               ),
                //             ),
                //           )
                //         : SizedBox()
                //   ],
                // )
              ),
              global.appNotice != null &&
                      global.appNotice.status == 1 &&
                      global.appNotice.notice != null &&
                      global.appNotice.notice.isNotEmpty
                  ? global.languageCode == "en"
                      ? Container(
                          width: MediaQuery.of(context).size.width,
                          height: 23,
                          color: Theme.of(context).primaryColor,
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 8, right: 8, top: 4, bottom: 4),
                            child: Marquee(
                              text: global.appNotice.notice,
                              style: const TextStyle(
                                  fontSize: 11, color: Colors.white),
                            ),
                          ),
                        )
                      : Directionality(
                          textDirection: TextDirection.ltr,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 23,
                            color: Theme.of(context).primaryColor,
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 8, right: 8, top: 4, bottom: 4),
                              child: Marquee(
                                text: global.appNotice.notice,
                                style: const TextStyle(
                                    fontSize: 11, color: Colors.white),
                              ),
                            ),
                          ),
                        )
                  : const SizedBox(),
              Expanded(
                child: global.nearStoreModel.id != null
                    ? SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _isDataLoaded
                                  ? _homeModel.bannerlist.isNotEmpty
                                      ? SizedBox(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.15,
                                          child: CarouselSlider(
                                              items: _bannerItems(),
                                              carouselController:
                                                  _carouselController,
                                              options: CarouselOptions(
                                                  viewportFraction: 0.99,
                                                  initialPage: _currentIndex,
                                                  enableInfiniteScroll: true,
                                                  reverse: false,
                                                  autoPlay: true,
                                                  autoPlayInterval:
                                                      const Duration(
                                                          seconds: 3),
                                                  autoPlayAnimationDuration:
                                                      const Duration(
                                                          milliseconds: 800),
                                                  autoPlayCurve:
                                                      Curves.fastOutSlowIn,
                                                  enlargeCenterPage: true,
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  onPageChanged: (index, _) {
                                                    _currentIndex = index;
                                                    setState(() {});
                                                  })))
                                      : const SizedBox()
                                  : _bannerShimmer(),
                              _isDataLoaded && _homeModel.bannerlist.isNotEmpty
                                  ? DotsIndicator(
                                      dotsCount: _isDataLoaded &&
                                              _homeModel.bannerlist.isNotEmpty
                                          ? _homeModel.bannerlist.length
                                          : 1,
                                      position: _currentIndex.toDouble(),
                                      onTap: (i) {
                                        _currentIndex = i.toInt();
                                        _carouselController.animateToPage(
                                            _currentIndex,
                                            duration:
                                                const Duration(microseconds: 1),
                                            curve: Curves.easeInOut);
                                      },
                                      decorator: DotsDecorator(
                                        activeSize: const Size(6, 6),
                                        size: const Size(6, 6),
                                        activeShape:
                                            const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(50.0),
                                          ),
                                        ),
                                        activeColor:
                                            Theme.of(context).primaryColor,
                                        color: global.isDarkModeEnable
                                            ? Colors.white
                                            : Colors.grey,
                                      ),
                                    )
                                  : const SizedBox(),
                              !_isDataLoaded ||
                                      (_isDataLoaded &&
                                          _homeModel.categoryList.isNotEmpty)
                                  ? Padding(
                                      padding: const EdgeInsets.only(
                                          top: 5, left: 10, right: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            AppLocalizations.of(context)
                                                .tle_all_category,
                                            style: Theme.of(context)
                                                .primaryTextTheme
                                                .headline5,
                                          ),
                                          // InkWell(
                                          //   onTap: () {
                                          //     Navigator.of(context).push(
                                          //       MaterialPageRoute(
                                          //         builder: (context) =>
                                          //             CategoryListScreen(
                                          //                 a: widget.analytics,
                                          //                 o: widget.observer),
                                          //       ),
                                          //     );
                                          //   },
                                          //   child: Text(
                                          //     '${AppLocalizations.of(context).btn_explore_all}',
                                          //     style: Theme.of(context)
                                          //         .primaryTextTheme
                                          //         .headline1,
                                          //   ),
                                          // )
                                        ],
                                      ),
                                    )
                                  : const SizedBox(),
                              _isDataLoaded
                                  ? _homeModel.categoryList.isNotEmpty
                                      ? SingleChildScrollView(
                                          //controller: _scrollController,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 10,
                                                left: 4,
                                                right: 4,
                                                top: 10),
                                            child: _isDataLoaded
                                                ? _categoryList.isNotEmpty
                                                    ? Wrap(
                                                        spacing: 0,
                                                        runSpacing: 10,
                                                        children:
                                                            _categoryListWidget(),
                                                      )
                                                    : SizedBox(
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height -
                                                            20,
                                                        child: Align(
                                                          alignment:
                                                              Alignment.center,
                                                          child: Text(
                                                            AppLocalizations.of(
                                                                    context)
                                                                .txt_nothing_to_show,
                                                            style: Theme.of(
                                                                    context)
                                                                .primaryTextTheme
                                                                .bodyText1,
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                        ),
                                                      )
                                                : Wrap(
                                                    spacing: 0,
                                                    runSpacing: 10,
                                                    children: catgoryShimmer(),
                                                  ),
                                          ),
                                        )
                                      //  Container(
                                      //     height: 200,
                                      //     child: ListView(
                                      //       shrinkWrap: true,
                                      //       scrollDirection: Axis.horizontal,
                                      //       children: _allCategoryWidgetList(),
                                      //     ),
                                      //   )
                                      : const SizedBox()
                                  : SizedBox(
                                      height: 200,
                                      child: _allCategoryShimmer(),
                                    ),
                              // !_isDataLoaded ||
                              //         (_isDataLoaded &&
                              //             _homeModel.topSellingProductList
                              //                     .length >
                              //                 0)
                              //     ? Padding(
                              //         padding: EdgeInsets.only(
                              //             top: 15, left: 10, right: 10),
                              //         child: Row(
                              //           mainAxisAlignment:
                              //               MainAxisAlignment.spaceBetween,
                              //           children: [
                              //             Text(
                              //               '${AppLocalizations.of(context).lbl_top_selling}',
                              //               style: Theme.of(context)
                              //                   .primaryTextTheme
                              //                   .headline5,
                              //             ),
                              //             InkWell(
                              //               onTap: () {
                              //                 Navigator.of(context).push(
                              //                   MaterialPageRoute(
                              //                     builder: (context) =>
                              //                         ProductListScreen(
                              //                             2,
                              //                             AppLocalizations.of(
                              //                                     context)
                              //                                 .lbl_top_selling,
                              //                             a: widget.analytics,
                              //                             o: widget.observer),
                              //                   ),
                              //                 );
                              //               },
                              //               child: Text(
                              //                 '${AppLocalizations.of(context).btn_explore_all}',
                              //                 style: Theme.of(context)
                              //                     .primaryTextTheme
                              //                     .headline1,
                              //               ),
                              //             )
                              //           ],
                              //         ),
                              //       )
                              //     : SizedBox(),
                              // _isDataLoaded
                              //     ? _homeModel.topSellingProductList.length > 0
                              //         ? Container(
                              //             height: 210,
                              //             child: ListView(
                              //               scrollDirection: Axis.horizontal,
                              //               children: _topSellingWidgetList(),
                              //             ),
                              //           )
                              //         : SizedBox()
                              //     : Container(
                              //         height: 210, child: _topSellingShimmer()),
                              // !_isDataLoaded ||
                              //         (_isDataLoaded &&
                              //             _homeModel
                              //                     .spotLightProductList.length >
                              //                 0)
                              //     ? Padding(
                              //         padding: EdgeInsets.only(
                              //             top: 15, left: 10, right: 10),
                              //         child: Row(
                              //           mainAxisAlignment:
                              //               MainAxisAlignment.spaceBetween,
                              //           children: [
                              //             Text(
                              //               '${AppLocalizations.of(context).lbl_in_spotlight}',
                              //               style: Theme.of(context)
                              //                   .primaryTextTheme
                              //                   .headline5,
                              //             ),
                              //             InkWell(
                              //               onTap: () {
                              //                 Navigator.of(context).push(
                              //                   MaterialPageRoute(
                              //                     builder: (context) =>
                              //                         ProductListScreen(
                              //                             3,
                              //                             AppLocalizations.of(
                              //                                     context)
                              //                                 .lbl_in_spotlight,
                              //                             a: widget.analytics,
                              //                             o: widget.observer),
                              //                   ),
                              //                 );
                              //               },
                              //               child: Text(
                              //                 '${AppLocalizations.of(context).btn_explore_all}',
                              //                 style: Theme.of(context)
                              //                     .primaryTextTheme
                              //                     .headline1,
                              //               ),
                              //             )
                              //           ],
                              //         ),
                              //       )
                              //     : SizedBox(),
                              // _isDataLoaded
                              //     ? _homeModel.spotLightProductList.length > 0
                              //         ? Container(
                              //             height: 140,
                              //             child: ListView(
                              //               scrollDirection: Axis.horizontal,
                              //               children: _spotLightWidgetList(),
                              //             ),
                              //           )
                              //         : SizedBox()
                              //     : Container(
                              //         height: 140,
                              //         child: _inSpotLightShimmer()),
                              // !_isDataLoaded ||
                              //         (_isDataLoaded &&
                              //             _homeModel.recentSellingProductList
                              //                     .length >
                              //                 0)
                              //     ? Padding(
                              //         padding: EdgeInsets.only(
                              //             top: 10, left: 10, right: 10),
                              //         child: Row(
                              //           mainAxisAlignment:
                              //               MainAxisAlignment.spaceBetween,
                              //           children: [
                              //             Text(
                              //               '${AppLocalizations.of(context).lbl_recent_selling}',
                              //               style: Theme.of(context)
                              //                   .primaryTextTheme
                              //                   .headline5,
                              //             ),
                              //             InkWell(
                              //               onTap: () {
                              //                 Navigator.of(context).push(
                              //                   MaterialPageRoute(
                              //                     builder: (context) =>
                              //                         ProductListScreen(
                              //                             4,
                              //                             AppLocalizations.of(
                              //                                     context)
                              //                                 .lbl_recent_selling,
                              //                             a: widget.analytics,
                              //                             o: widget.observer),
                              //                   ),
                              //                 );
                              //               },
                              //               child: Text(
                              //                 '${AppLocalizations.of(context).btn_explore_all}',
                              //                 style: Theme.of(context)
                              //                     .primaryTextTheme
                              //                     .headline1,
                              //               ),
                              //             )
                              //           ],
                              //         ),
                              //       )
                              //     : SizedBox(),
                              // _isDataLoaded
                              //     ? _homeModel.recentSellingProductList.length >
                              //             0
                              //         ? Container(
                              //             height: 210,
                              //             child: ListView(
                              //               scrollDirection: Axis.horizontal,
                              //               children: _recentSellingWidget(),
                              //             ),
                              //           )
                              //         : SizedBox()
                              //     : Container(
                              //         height: 210, child: _topSellingShimmer()),
                              _isDataLoaded
                                  ? _homeModel.secondBannerList.isNotEmpty
                                      ? Container(
                                          margin:
                                              const EdgeInsets.only(top: 20),
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.15,
                                          child: CarouselSlider(
                                              items: _secondBannerItems(),
                                              carouselController:
                                                  _secondCarouselController,
                                              options: CarouselOptions(
                                                  viewportFraction: 0.99,
                                                  initialPage:
                                                      _secondBannercurrentIndex,
                                                  enableInfiniteScroll: true,
                                                  reverse: false,
                                                  autoPlay: true,
                                                  autoPlayInterval:
                                                      const Duration(
                                                          seconds: 3),
                                                  autoPlayAnimationDuration:
                                                      const Duration(
                                                          milliseconds: 800),
                                                  autoPlayCurve:
                                                      Curves.fastOutSlowIn,
                                                  enlargeCenterPage: true,
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  onPageChanged: (index, _) {
                                                    _secondBannercurrentIndex =
                                                        index;
                                                    setState(() {});
                                                  })),
                                        )
                                      : const SizedBox()
                                  : _bannerShimmer(),
                              _isDataLoaded &&
                                      _homeModel.secondBannerList.isNotEmpty
                                  ? DotsIndicator(
                                      dotsCount: _isDataLoaded &&
                                              _homeModel
                                                  .secondBannerList.isNotEmpty
                                          ? _homeModel.secondBannerList.length
                                          : 1,
                                      position:
                                          _secondBannercurrentIndex.toDouble(),
                                      onTap: (i) {
                                        _secondBannercurrentIndex = i.toInt();
                                        _secondCarouselController.animateToPage(
                                            _secondBannercurrentIndex,
                                            duration:
                                                const Duration(microseconds: 1),
                                            curve: Curves.easeInOut);
                                      },
                                      decorator: DotsDecorator(
                                        activeSize: const Size(6, 6),
                                        size: const Size(6, 6),
                                        activeShape:
                                            const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(50.0),
                                          ),
                                        ),
                                        activeColor:
                                            Theme.of(context).primaryColor,
                                        color: global.isDarkModeEnable
                                            ? Colors.white
                                            : Colors.grey,
                                      ),
                                    )
                                  : const SizedBox(),
                              // !_isDataLoaded ||
                              //         (_isDataLoaded &&
                              //             _homeModel.recentSellingProductList
                              //                     .length >
                              //                 0)
                              //     ? Padding(
                              //         padding: EdgeInsets.only(
                              //             top: 15, left: 10, right: 10),
                              //         child: Row(
                              //           mainAxisAlignment:
                              //               MainAxisAlignment.spaceBetween,
                              //           children: [
                              //             Text(
                              //               "${AppLocalizations.of(context).lbl_whats_new}",
                              //               style: Theme.of(context)
                              //                   .primaryTextTheme
                              //                   .headline5,
                              //             ),
                              //             InkWell(
                              //               onTap: () {
                              //                 Navigator.of(context).push(
                              //                   MaterialPageRoute(
                              //                     builder: (context) =>
                              //                         ProductListScreen(
                              //                             5,
                              //                             AppLocalizations.of(
                              //                                     context)
                              //                                 .lbl_whats_new,
                              //                             a: widget.analytics,
                              //                             o: widget.observer),
                              //                   ),
                              //                 );
                              //               },
                              //               child: Text(
                              //                 '${AppLocalizations.of(context).btn_explore_all}',
                              //                 style: Theme.of(context)
                              //                     .primaryTextTheme
                              //                     .headline1,
                              //               ),
                              //             )
                              //           ],
                              //         ),
                              //       )
                              //     : SizedBox(),
                              // _isDataLoaded
                              //     ? _homeModel.whatsnewProductList.length > 0
                              //         ? Container(
                              //             height: 210,
                              //             child: ListView(
                              //               scrollDirection: Axis.horizontal,
                              //               children:
                              //                   _whatsNewProductWidgetList(),
                              //             ),
                              //           )
                              //         : SizedBox()
                              //     : Container(
                              //         height: 210, child: _topSellingShimmer()),
                              // !_isDataLoaded ||
                              //         (_isDataLoaded &&
                              //             _homeModel.dealProductList.length > 0)
                              //     ? Padding(
                              //         padding: EdgeInsets.only(
                              //             top: 15, left: 10, right: 10),
                              //         child: Row(
                              //           mainAxisAlignment:
                              //               MainAxisAlignment.spaceBetween,
                              //           children: [
                              //             Text(
                              //               '${AppLocalizations.of(context).lbl_deal_products}',
                              //               style: Theme.of(context)
                              //                   .primaryTextTheme
                              //                   .headline5,
                              //             ),
                              //             InkWell(
                              //               onTap: () {
                              //                 Navigator.of(context).push(
                              //                   MaterialPageRoute(
                              //                     builder: (context) =>
                              //                         ProductListScreen(
                              //                             6,
                              //                             AppLocalizations.of(
                              //                                     context)
                              //                                 .lbl_deal_products,
                              //                             a: widget.analytics,
                              //                             o: widget.observer),
                              //                   ),
                              //                 );
                              //               },
                              //               child: Text(
                              //                 '${AppLocalizations.of(context).btn_explore_all}',
                              //                 style: Theme.of(context)
                              //                     .primaryTextTheme
                              //                     .headline1,
                              //               ),
                              //             )
                              //           ],
                              //         ),
                              //       )
                              //     : SizedBox(),
                              // _isDataLoaded
                              //     ? _homeModel.dealProductList.length > 0
                              //         ? Container(
                              //             height: 210,
                              //             child: ListView(
                              //               scrollDirection: Axis.horizontal,
                              //               children: _dealProductWidgetList(),
                              //             ),
                              //           )
                              //         : SizedBox()
                              //     : Container(
                              //         height: 210, child: _topSellingShimmer())
                            ],
                          ),
                        ),
                      )
                    : Center(
                        child: Text(
                          global.locationMessage,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).primaryTextTheme.bodyText1,
                        ),
                      ),
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: global.currentUser != null &&
                global.currentUser.id != null &&
                global.nearStoreModel.id != null
            ? SpeedDial(
                icon: Icons.menu,
                activeIcon: Icons.menu,
                spacing: 3,
                // openCloseDial: false,
                childPadding: const EdgeInsets.all(5),
                spaceBetweenChildren: 4,
                overlayOpacity: 0.8,
                gradientBoxShape: BoxShape.circle,
                // dialRoot: (ctx, open, toggleChildren) {
                //   return FloatingActionButton(
                //     backgroundColor: Theme.of(context).primaryColor,
                //     onPressed: toggleChildren,
                //     heroTag: "1",
                //     child: Icon(Icons.menu),
                //   );
                // },

                // The label of the main button.
                /// The active label of the main button, Defaults to label if not specified.

                direction: SpeedDialDirection.up,

                backgroundColor: Theme.of(context).primaryColor,

                onOpen: () => debugPrint('OPENING DIAL'),
                onClose: () => debugPrint('DIAL CLOSED'),
                // useRotationAnimation: useRAnimation,
                tooltip: 'Open Speed Dial',
                heroTag: 'speed-dial-hero-tag',

                elevation: 8.0,
                isOpenOnStart: false,
                animationSpeed: 200,
                //  shape: const RoundedRectangleBorder(),
                children: _speedDialWidget(),
                // children: [
                //   SpeedDialChild(
                //     child: const Icon(Icons.share),
                //     backgroundColor: Theme.of(context).primaryColor,
                //     foregroundColor: Colors.white,
                //     onTap: () {},
                //   ),
                //   SpeedDialChild(
                //     child: const Icon(MdiIcons.messageDraw),
                //     backgroundColor: Theme.of(context).primaryColor,
                //     foregroundColor: Colors.white,
                //     onTap: () {},
                //   ),
                //   SpeedDialChild(
                //     child: const Icon(MdiIcons.comment),
                //     backgroundColor: Theme.of(context).primaryColor,
                //     foregroundColor: Colors.white,
                //     visible: true,
                //     onTap: () {},
                //   ),
                // ],
              )
            : null,
      ),
    );
  }

  List<SpeedDialChild> _speedDialWidget() {
    List<SpeedDialChild> widgetList = [];
    if (global.currentUser != null && global.currentUser.id != null) {
      widgetList.add(
        SpeedDialChild(
          child: const Icon(Icons.share),
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          onTap: () {
            br.inviteFriendShareMessage();
          },
        ),
      );
    }

    if (global.currentUser != null &&
        global.currentUser.id != null &&
        global.nearStoreModel.id != null) {
      widgetList.add(
        SpeedDialChild(
          child: const Icon(MdiIcons.messageDraw),
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ProductRequestScreen(
                    a: widget.analytics, o: widget.observer),
              ),
            );
          },
        ),
      );
    }

    if (global.currentUser != null &&
        global.currentUser.id != null &&
        global.nearStoreModel.id != null &&
        global.appInfo.liveChat != null &&
        global.appInfo.liveChat == 1) {
      // chat Option
      widgetList.add(
        SpeedDialChild(
          child: const Icon(MdiIcons.comment),
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          visible: true,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ChatScreen(
                  a: widget.analytics,
                  o: widget.observer,
                ),
              ),
            );
          },
        ),
      );
    }

    return widgetList;
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  Widget _allCategoryShimmer() {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: Shimmer.fromColors(
            baseColor: Colors.grey[300],
            highlightColor: Colors.grey[100],
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (BuildContext context, int index) {
                  return const SizedBox(
                    width: 145,
                    height: 172,
                    child: Card(
                      margin: EdgeInsets.only(left: 5, right: 5),
                    ),
                  );
                })));
  }

  List<Widget> _categoryListWidget() {
    List<Widget> productList = [];

    for (int i = 0; i < _categoryList.length; i++) {
      productList.add(
        InkWell(
          customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => SubcategoryListScreen(
                    _categoryList[i], _categoryList,
                    a: widget.analytics, o: widget.observer),
              ),
            );
          },
          child: Container(
            height: 140,
            margin: const EdgeInsets.only(top: 30, left: 4, right: 4),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                SizedBox(
                  height: 170,
                  width: (MediaQuery.of(context).size.width / 3.5),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardTheme.color,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(5),
                      ),
                    ),
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 78, left: 7, right: 7),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _categoryList[i].title,
                            style: Theme.of(context).primaryTextTheme.bodyText1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          // Text(
                          //   '${_categoryList[i].subcategoryCount}+ items',
                          //   style: Theme.of(context).primaryTextTheme.headline2,
                          // ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              RichText(
                                  text: TextSpan(
                                      text:
                                          "${AppLocalizations.of(context).txt_from} ${global.appInfo.currencySign} ",
                                      style: Theme.of(context)
                                          .primaryTextTheme
                                          .headline2,
                                      children: [
                                    TextSpan(
                                      text: '${_categoryList[i].startFrom}',
                                      style: Theme.of(context)
                                          .primaryTextTheme
                                          .bodyText1,
                                    ),
                                  ])),
                              Image.asset('assets/orange_next.png'),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  top: -30,
                  child: SizedBox(
                    height: 90,
                    width: 110,
                    child: CachedNetworkImage(
                      imageUrl:
                          global.appInfo.imageUrl + _categoryList[i].image,
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          image: DecorationImage(
                              image: imageProvider, fit: BoxFit.cover),
                        ),
                      ),
                      placeholder: (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) => Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          image: DecorationImage(
                              image: AssetImage(global.defaultImage),
                              fit: BoxFit.cover),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }
    if (_isMoreDataLoaded) {
      productList.add(const Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.white,
          strokeWidth: 2,
        ),
      ));
    }

    return productList;
  }

  List<Widget> _allCategoryWidgetList() {
    List<Widget> widgetList = [];
    try {
      for (int i = 0; i < _homeModel.categoryList.length; i++) {
        widgetList.add(
          InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => SubcategoryListScreen(
                      _homeModel.categoryList[i], const [],
                      a: widget.analytics, o: widget.observer),
                ),
              );
            },
            child: Container(
              height: 172,
              margin: const EdgeInsets.only(top: 40, left: 10),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  SizedBox(
                    height: 172,
                    width: 140,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardTheme.color,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(5),
                        ),
                      ),
                      child: Padding(
                        padding:
                            const EdgeInsets.only(top: 78, left: 10, right: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _homeModel.categoryList[i].title,
                              style:
                                  Theme.of(context).primaryTextTheme.bodyText1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              _homeModel.categoryList[i].description,
                              style:
                                  Theme.of(context).primaryTextTheme.headline2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      '${AppLocalizations.of(context).txt_from} ',
                                      style: Theme.of(context)
                                          .primaryTextTheme
                                          .headline2,
                                    ),
                                    Text(
                                      '${global.appInfo.currencySign} ',
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: Theme.of(context)
                                              .primaryTextTheme
                                              .headline2
                                              .color),
                                    ),
                                    Text(
                                      '${_homeModel.categoryList[i].startFrom}',
                                      style: Theme.of(context)
                                          .primaryTextTheme
                                          .bodyText1,
                                    )
                                  ],
                                ),
                                InkWell(
                                    customBorder: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              SubcategoryListScreen(
                                                  _homeModel.categoryList[i],
                                                  const [],
                                                  a: widget.analytics,
                                                  o: widget.observer),
                                        ),
                                      );
                                    },
                                    child:
                                        Image.asset('assets/orange_next.png')),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: -30,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Container(
                        alignment: Alignment.center,
                        height: 100,
                        width: 130,
                        child: CachedNetworkImage(
                          imageUrl: global.appInfo.imageUrl +
                              _homeModel.categoryList[i].image,
                          imageBuilder: (context, imageProvider) => Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              image: DecorationImage(
                                  image: imageProvider, fit: BoxFit.cover),
                            ),
                          ),
                          placeholder: (context, url) =>
                              const Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) => Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              image: DecorationImage(
                                  image: AssetImage(global.defaultImage),
                                  fit: BoxFit.cover),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      }
      return widgetList;
    } catch (e) {
      widgetList.add(const SizedBox());
      print("Exception - homeScreen.dart - _allCategoryWidgetList():$e");
      return widgetList;
    }
  }

  List<Widget> _bannerItems() {
    List<Widget> list = [];
    for (int i = 0; i < _homeModel.bannerlist.length; i++) {
      list.add(GestureDetector(
        onTap: () {
          // Navigator.of(context).push(
          //   MaterialPageRoute(
          //     builder: (context) => SubcategoryListScreen(
          //         _homeModel.bannerlist[i], [],
          //         a: widget.analytics, o: widget.observer),
          //   ),
          // );
          int catIndex = _categoryList.indexWhere(
              (catg) => catg.catId == _homeModel.bannerlist[i].catId);
          if (catIndex >= 0) {
            // Navigator.of(context).push(
            //   MaterialPageRoute(
            //     builder: (context) => SubcategoryListScreen(
            //         _categoryList[catIndex], _categoryList,
            //         a: widget.analytics, o: widget.observer),
            //   ),
            // );
          }
        },
        child: CachedNetworkImage(
          imageUrl:
              global.appInfo.imageUrl + _homeModel.bannerlist[i].bannerImage,
          imageBuilder: (context, imageProvider) => Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
            ),
          ),
          placeholder: (context, url) =>
              const Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) => Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              image: DecorationImage(
                  image: AssetImage(global.defaultImage), fit: BoxFit.cover),
            ),
          ),
        ),
      ));
    }
    return list;
  }

  Widget _bannerShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300],
      highlightColor: Colors.grey[100],
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.15,
            width: MediaQuery.of(context).size.width,
            child: const Card(),
          ),
        ],
      ),
    );
  }

  List<Widget> _dealProductWidgetList() {
    List<Widget> widgetList = [];
    try {
      for (int i = 0; i < _homeModel.dealProductList.length; i++) {
        widgetList.add(
          InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ProductDetailScreen(
                    a: widget.analytics,
                    o: widget.observer,
                    productId: _homeModel.dealProductList[i].productId,
                  ),
                ),
              );
            },
            child: Container(
              height: 210,
              margin: const EdgeInsets.only(top: 10, left: 10),
              child: Stack(
                children: [
                  SizedBox(
                    height: 160,
                    width: 140,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: i % 3 == 1
                            ? const LinearGradient(
                                stops: [0, .90],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Color(0XFF9EEEFF), Color(0XFFC0F4FF)],
                              )
                            : i % 3 == 2
                                ? const LinearGradient(
                                    stops: [0, .90],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Color(0XFFFFF1C0),
                                      Color(0XFFFFF1C0)
                                    ],
                                  )
                                : const LinearGradient(
                                    stops: [0, .90],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Color(0XFFFFD4D7),
                                      Color(0XFFFFD4D7)
                                    ],
                                  ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(17),
                          bottomLeft: Radius.circular(17),
                          bottomRight: Radius.circular(17),
                        ),
                      ),
                      child: Padding(
                        padding:
                            const EdgeInsets.only(top: 27, left: 10, right: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              _homeModel.dealProductList[i].productName,
                              style:
                                  Theme.of(context).primaryTextTheme.subtitle1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              _homeModel.dealProductList[i].type,
                              style:
                                  Theme.of(context).primaryTextTheme.subtitle2,
                            ),
                            Container(
                              width: 130,
                              padding: const EdgeInsets.only(top: 2),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "${global.appInfo.currencySign} ",
                                        style: Theme.of(context)
                                            .primaryTextTheme
                                            .subtitle2,
                                      ),
                                      Text(
                                        '${_homeModel.dealProductList[i].price} ',
                                        style: Theme.of(context)
                                            .primaryTextTheme
                                            .subtitle1,
                                      ),
                                      Text(
                                        '/ ${_homeModel.dealProductList[i].quantity}${_homeModel.dealProductList[i].unit}',
                                        style: Theme.of(context)
                                            .primaryTextTheme
                                            .subtitle2,
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: const BoxDecoration(
                        color: Colors.white60,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                        ),
                      ),
                      child: Icon(
                        Icons.add,
                        color: global.isDarkModeEnable
                            ? Theme.of(context).scaffoldBackgroundColor
                            : i % 3 == 1
                                ? const Color(0XFF9EEEFF)
                                : i % 3 == 2
                                    ? const Color(0XFFFFF1C0)
                                    : const Color(0XFFFFD4D7),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: SizedBox(
                        height: 100,
                        width: 130,
                        child: CachedNetworkImage(
                          imageUrl: global.appInfo.imageUrl +
                              _homeModel.dealProductList[i].productImage,
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              image: DecorationImage(
                                  image: imageProvider, fit: BoxFit.cover),
                            ),
                            alignment: Alignment.center,
                            child: Visibility(
                              visible: _homeModel.dealProductList[i].stock > 0
                                  ? false
                                  : true,
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .primaryColorLight
                                        .withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(15)),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5)),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  child: Text(
                                    AppLocalizations.of(context)
                                        .txt_out_of_stock,
                                    style: Theme.of(context)
                                        .primaryTextTheme
                                        .headline2,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          placeholder: (context, url) =>
                              const Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) => Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              image: DecorationImage(
                                  image: AssetImage(global.defaultImage),
                                  fit: BoxFit.cover),
                            ),
                            alignment: Alignment.center,
                            child: Visibility(
                              visible: _homeModel.dealProductList[i].stock > 0
                                  ? false
                                  : true,
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .primaryColorLight
                                        .withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(15)),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5)),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  child: Text(
                                    AppLocalizations.of(context)
                                        .txt_out_of_stock,
                                    style: Theme.of(context)
                                        .primaryTextTheme
                                        .headline2,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      }
      return widgetList;
    } catch (e) {
      widgetList.add(const SizedBox());
      print("Exception - homeScreen.dart - _topSellingWidgetList():$e");
      return widgetList;
    }
  }

  _init() async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        if (global.lat == null && global.lng == null) {
          await getCurrentPosition();
        }

        await apiHelper.getHomeData().then((result) async {
          if (result != null) {
            if (result.status == "1") {
              _homeModel = result.data;
            }
          }
        });
        await apiHelper
            .getCategoryList(_catgoryFilter, page)
            .then((result) async {
          if (result != null) {
            if (result.status == "1") {
              List<Category> tList = result.data;
              if (tList.isEmpty) {
                _isRecordPending = false;
              }
              _categoryList.addAll(tList);
              setState(() {
                _isMoreDataLoaded = false;
              });
            }
          }
        });
      } else {
        showNetworkErrorSnackBar(_scaffoldKey);
      }

      _isDataLoaded = true;
      setState(() {});
    } catch (e) {
      print("Exception - homeScreen.dart- _init():$e");
    }
  }

  Widget _inSpotLightShimmer() {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: Shimmer.fromColors(
            baseColor: Colors.grey[300],
            highlightColor: Colors.grey[100],
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (BuildContext context, int index) {
                  return const SizedBox(
                    width: 180,
                    height: 105,
                    child: Card(
                      margin: EdgeInsets.only(left: 5, right: 5),
                    ),
                  );
                })));
  }

  List<Widget> _recentSellingWidget() {
    List<Widget> widgetList = [];
    try {
      for (int i = 0; i < _homeModel.recentSellingProductList.length; i++) {
        widgetList.add(
          InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ProductDetailScreen(
                    a: widget.analytics,
                    o: widget.observer,
                    productId: _homeModel.recentSellingProductList[i].productId,
                  ),
                ),
              );
            },
            child: Container(
              height: 210,
              margin: const EdgeInsets.only(top: 10, left: 10),
              child: Stack(
                children: [
                  SizedBox(
                    height: 160,
                    width: 140,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: i % 3 == 1
                            ? const LinearGradient(
                                stops: [0, .90],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Color(0XFF9EEEFF), Color(0XFFC0F4FF)],
                              )
                            : i % 3 == 2
                                ? const LinearGradient(
                                    stops: [0, .90],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Color(0XFFFFF1C0),
                                      Color(0XFFFFF1C0)
                                    ],
                                  )
                                : const LinearGradient(
                                    stops: [0, .90],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Color(0XFFFFD4D7),
                                      Color(0XFFFFD4D7)
                                    ],
                                  ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(17),
                          bottomLeft: Radius.circular(17),
                          bottomRight: Radius.circular(17),
                        ),
                      ),
                      child: Padding(
                        padding:
                            const EdgeInsets.only(top: 27, left: 10, right: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              _homeModel
                                  .recentSellingProductList[i].productName,
                              style:
                                  Theme.of(context).primaryTextTheme.subtitle1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              _homeModel.recentSellingProductList[i].type,
                              style:
                                  Theme.of(context).primaryTextTheme.subtitle2,
                            ),
                            Container(
                              width: 130,
                              padding: const EdgeInsets.only(top: 2),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "${global.appInfo.currencySign} ",
                                        style: Theme.of(context)
                                            .primaryTextTheme
                                            .subtitle2,
                                      ),
                                      Text(
                                        '${_homeModel.recentSellingProductList[i].price} ',
                                        style: Theme.of(context)
                                            .primaryTextTheme
                                            .subtitle1,
                                      ),
                                      Text(
                                        '/ ${_homeModel.recentSellingProductList[i].quantity} ${_homeModel.recentSellingProductList[i].unit}',
                                        style: Theme.of(context)
                                            .primaryTextTheme
                                            .subtitle2,
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: const BoxDecoration(
                        color: Colors.white60,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                        ),
                      ),
                      child: Icon(
                        Icons.add,
                        color: global.isDarkModeEnable
                            ? Theme.of(context).scaffoldBackgroundColor
                            : i % 3 == 1
                                ? const Color(0XFF9EEEFF)
                                : i % 3 == 2
                                    ? const Color(0XFFFFF1C0)
                                    : const Color(0XFFFFD4D7),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: SizedBox(
                        height: 100,
                        width: 130,
                        child: CachedNetworkImage(
                          imageUrl: global.appInfo.imageUrl +
                              _homeModel
                                  .recentSellingProductList[i].productImage,
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              image: DecorationImage(
                                  image: imageProvider, fit: BoxFit.cover),
                            ),
                            alignment: Alignment.center,
                            child: Visibility(
                              visible:
                                  _homeModel.recentSellingProductList[i].stock >
                                          0
                                      ? false
                                      : true,
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .primaryColorLight
                                        .withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(15)),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5)),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  child: Text(
                                    AppLocalizations.of(context)
                                        .txt_out_of_stock,
                                    style: Theme.of(context)
                                        .primaryTextTheme
                                        .headline2,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          placeholder: (context, url) =>
                              const Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) => Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              image: DecorationImage(
                                  image: AssetImage(global.defaultImage),
                                  fit: BoxFit.cover),
                            ),
                            alignment: Alignment.center,
                            child: Visibility(
                              visible:
                                  _homeModel.recentSellingProductList[i].stock >
                                          0
                                      ? false
                                      : true,
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .primaryColorLight
                                        .withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(15)),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5)),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  child: Text(
                                    AppLocalizations.of(context)
                                        .txt_out_of_stock,
                                    style: Theme.of(context)
                                        .primaryTextTheme
                                        .headline2,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      }
      return widgetList;
    } catch (e) {
      widgetList.add(const SizedBox());
      print("Exception - homeScreen.dart - _recentSellingWidget():$e");
      return widgetList;
    }
  }

  List<Widget> _secondBannerItems() {
    List<Widget> list = [];
    for (int i = 0; i < _homeModel.secondBannerList.length; i++) {
      list.add(GestureDetector(
        onTap: () {
          // Navigator.of(context).push(
          //   MaterialPageRoute(
          //       builder: (context) => ProductDetailScreen(
          //             varientId: _homeModel.secondBannerList[i].varientId,
          //             a: widget.analytics,
          //             o: widget.observer,
          //           )),
          // );
          int catIndex = _categoryList.indexWhere(
              (catg) => catg.catId == _homeModel.bannerlist[i].catId);
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => SubcategoryListScreen(
                  _categoryList[catIndex], _categoryList,
                  a: widget.analytics, o: widget.observer),
            ),
          );
        },
        child: CachedNetworkImage(
          imageUrl: global.appInfo.imageUrl +
              _homeModel.secondBannerList[i].bannerImage,
          imageBuilder: (context, imageProvider) => Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
            ),
          ),
          placeholder: (context, url) =>
              const Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) => Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              image: DecorationImage(
                  image: AssetImage(global.defaultImage), fit: BoxFit.cover),
            ),
          ),
        ),
      ));
    }
    return list;
  }

  List<Widget> _spotLightWidgetList() {
    List<Widget> widgetList = [];
    try {
      for (int i = 0; i < _homeModel.spotLightProductList.length; i++) {
        widgetList.add(
          InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ProductDetailScreen(
                      productId: _homeModel.spotLightProductList[i].productId,
                      a: widget.analytics,
                      o: widget.observer),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(top: 10, left: 10),
              child: Stack(
                children: [
                  SizedBox(
                    height: 105,
                    width: 180,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardTheme.color,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(17),
                          bottomLeft: Radius.circular(17),
                          bottomRight: Radius.circular(17),
                        ),
                      ),
                      child: Padding(
                        padding:
                            const EdgeInsets.only(top: 28, left: 10, right: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 80,
                              child: Text(
                                _homeModel.spotLightProductList[i].productName,
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .bodyText1,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                            Container(
                              width: 130,
                              padding: const EdgeInsets.only(top: 2),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "${global.appInfo.currencySign} ",
                                        style: Theme.of(context)
                                            .primaryTextTheme
                                            .headline2,
                                      ),
                                      Text(
                                        '${_homeModel.spotLightProductList[i].price} ',
                                        style: Theme.of(context)
                                            .primaryTextTheme
                                            .headline5,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              _homeModel.spotLightProductList[i].type,
                              maxLines: 1,
                              style:
                                  Theme.of(context).primaryTextTheme.headline2,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: global.isRTL ? null : 0,
                    left: global.isRTL ? 0 : null,
                    top: 30,
                    child: SizedBox(
                      height: 100,
                      width: 98,
                      child: CachedNetworkImage(
                        imageUrl: global.appInfo.imageUrl +
                            _homeModel.spotLightProductList[i].productImage,
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            image: DecorationImage(
                                image: imageProvider, fit: BoxFit.cover),
                          ),
                          alignment: Alignment.center,
                          child: Visibility(
                            visible:
                                _homeModel.spotLightProductList[i].stock > 0
                                    ? false
                                    : true,
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .primaryColorLight
                                      .withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(15)),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5)),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                child: Text(
                                  AppLocalizations.of(context).txt_out_of_stock,
                                  style: Theme.of(context)
                                      .primaryTextTheme
                                      .headline2,
                                ),
                              ),
                            ),
                          ),
                        ),
                        placeholder: (context, url) =>
                            const Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) => Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            image: DecorationImage(
                                image: AssetImage(global.defaultImage),
                                fit: BoxFit.cover),
                          ),
                          child: Visibility(
                            visible:
                                _homeModel.spotLightProductList[i].stock > 0
                                    ? false
                                    : true,
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .primaryColorLight
                                      .withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(15)),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5)),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                child: Text(
                                  '${AppLocalizations.of(context).txt_out_of_stock}',
                                  style: Theme.of(context)
                                      .primaryTextTheme
                                      .headline2,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    top: 0,
                    child: Container(
                      height: 20,
                      width: 70,
                      decoration: const BoxDecoration(
                        color: Colors.lightBlue,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                      ),
                      child: Text(
                        "${_homeModel.spotLightProductList[i].discount}% ${AppLocalizations.of(context).txt_off}",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).primaryTextTheme.caption,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .bottomNavigationBarTheme
                            .backgroundColor,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                        ),
                      ),
                      child: Icon(
                        Icons.add,
                        color: Theme.of(context).primaryColorLight,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
      return widgetList;
    } catch (e) {
      widgetList.add(const SizedBox());
      print("Exception - homeScreen.dart - _spotLightWidgetList():$e");
      return widgetList;
    }
  }

  Widget _topSellingShimmer() {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: Shimmer.fromColors(
            baseColor: Colors.grey[300],
            highlightColor: Colors.grey[100],
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (BuildContext context, int index) {
                  return const SizedBox(
                    width: 140,
                    height: 210,
                    child: Card(
                      margin: EdgeInsets.only(left: 5, right: 5),
                    ),
                  );
                })));
  }

  List<Widget> _topSellingWidgetList() {
    List<Widget> widgetList = [];
    try {
      for (int i = 0; i < _homeModel.topSellingProductList.length; i++) {
        widgetList.add(
          InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ProductDetailScreen(
                    a: widget.analytics,
                    o: widget.observer,
                    productId: _homeModel.topSellingProductList[i].productId,
                  ),
                ),
              );
            },
            child: Container(
              height: 210,
              margin: const EdgeInsets.only(top: 10, left: 10),
              child: Stack(
                children: [
                  SizedBox(
                    height: 160,
                    width: 140,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: i % 3 == 1
                            ? const LinearGradient(
                                stops: [0, .90],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Color(0XFF9EEEFF), Color(0XFFC0F4FF)],
                              )
                            : i % 3 == 2
                                ? const LinearGradient(
                                    stops: [0, .90],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Color(0XFFFFF1C0),
                                      Color(0XFFFFF1C0)
                                    ],
                                  )
                                : const LinearGradient(
                                    stops: [0, .90],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Color(0XFFFFD4D7),
                                      Color(0XFFFFD4D7)
                                    ],
                                  ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(17),
                          bottomLeft: Radius.circular(17),
                          bottomRight: Radius.circular(17),
                        ),
                      ),
                      child: Padding(
                        padding:
                            const EdgeInsets.only(top: 27, left: 10, right: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              _homeModel.topSellingProductList[i].productName,
                              style:
                                  Theme.of(context).primaryTextTheme.subtitle1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              _homeModel.topSellingProductList[i].type,
                              style:
                                  Theme.of(context).primaryTextTheme.subtitle2,
                            ),
                            Container(
                              width: 130,
                              padding: const EdgeInsets.only(top: 2),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "${global.appInfo.currencySign} ",
                                        style: Theme.of(context)
                                            .primaryTextTheme
                                            .subtitle2,
                                      ),
                                      Text(
                                        '${_homeModel.topSellingProductList[i].price} ',
                                        style: Theme.of(context)
                                            .primaryTextTheme
                                            .subtitle1,
                                      ),
                                      Text(
                                        '/ ${_homeModel.topSellingProductList[i].quantity}${_homeModel.topSellingProductList[i].unit}',
                                        style: Theme.of(context)
                                            .primaryTextTheme
                                            .subtitle2,
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: const BoxDecoration(
                        color: Colors.white60,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                        ),
                      ),
                      child: Icon(
                        Icons.add,
                        color: global.isDarkModeEnable
                            ? Theme.of(context).scaffoldBackgroundColor
                            : i % 3 == 1
                                ? const Color(0XFF9EEEFF)
                                : i % 3 == 2
                                    ? const Color(0XFFFFF1C0)
                                    : const Color(0XFFFFD4D7),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: SizedBox(
                        height: 100,
                        width: 130,
                        child: CachedNetworkImage(
                          imageUrl: global.appInfo.imageUrl +
                              _homeModel.topSellingProductList[i].productImage,
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              image: DecorationImage(
                                  image: imageProvider, fit: BoxFit.cover),
                            ),
                            alignment: Alignment.center,
                            child: Visibility(
                              visible:
                                  _homeModel.topSellingProductList[i].stock > 0
                                      ? false
                                      : true,
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .primaryColorLight
                                        .withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(15)),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5)),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  child: Text(
                                    AppLocalizations.of(context)
                                        .txt_out_of_stock,
                                    style: Theme.of(context)
                                        .primaryTextTheme
                                        .headline2,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          placeholder: (context, url) =>
                              const Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) => Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              image: DecorationImage(
                                  image: AssetImage(global.defaultImage),
                                  fit: BoxFit.cover),
                            ),
                            alignment: Alignment.center,
                            child: Visibility(
                              visible:
                                  _homeModel.topSellingProductList[i].stock > 0
                                      ? false
                                      : true,
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .primaryColorLight
                                        .withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(15)),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5)),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  child: Text(
                                    AppLocalizations.of(context)
                                        .txt_out_of_stock,
                                    style: Theme.of(context)
                                        .primaryTextTheme
                                        .headline2,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      }
      return widgetList;
    } catch (e) {
      widgetList.add(const SizedBox());
      print("Exception - homeScreen.dart - _topSellingWidgetList():$e");
      return widgetList;
    }
  }

  List<Widget> _whatsNewProductWidgetList() {
    List<Widget> widgetList = [];
    try {
      for (int i = 0; i < _homeModel.whatsnewProductList.length; i++) {
        widgetList.add(
          InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ProductDetailScreen(
                    a: widget.analytics,
                    o: widget.observer,
                    productId: _homeModel.whatsnewProductList[i].productId,
                  ),
                ),
              );
            },
            child: Container(
              height: 210,
              margin: const EdgeInsets.only(top: 10, left: 10),
              child: Stack(
                children: [
                  SizedBox(
                    height: 160,
                    width: 140,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: i % 3 == 1
                            ? const LinearGradient(
                                stops: [0, .90],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Color(0XFF9EEEFF), Color(0XFFC0F4FF)],
                              )
                            : i % 3 == 2
                                ? const LinearGradient(
                                    stops: [0, .90],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Color(0XFFFFF1C0),
                                      Color(0XFFFFF1C0)
                                    ],
                                  )
                                : const LinearGradient(
                                    stops: [0, .90],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Color(0XFFFFD4D7),
                                      Color(0XFFFFD4D7)
                                    ],
                                  ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(17),
                          bottomLeft: Radius.circular(17),
                          bottomRight: Radius.circular(17),
                        ),
                      ),
                      child: Padding(
                        padding:
                            const EdgeInsets.only(top: 27, left: 10, right: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              _homeModel.whatsnewProductList[i].productName,
                              style:
                                  Theme.of(context).primaryTextTheme.subtitle1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              _homeModel.whatsnewProductList[i].type,
                              style:
                                  Theme.of(context).primaryTextTheme.subtitle2,
                            ),
                            Container(
                              width: 130,
                              padding: const EdgeInsets.only(top: 2),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "${global.appInfo.currencySign} ",
                                        style: Theme.of(context)
                                            .primaryTextTheme
                                            .subtitle2,
                                      ),
                                      Text(
                                        '${_homeModel.whatsnewProductList[i].price} ',
                                        style: Theme.of(context)
                                            .primaryTextTheme
                                            .subtitle1,
                                      ),
                                      Text(
                                        '/ ${_homeModel.whatsnewProductList[i].quantity} ${_homeModel.whatsnewProductList[i].unit}',
                                        style: Theme.of(context)
                                            .primaryTextTheme
                                            .subtitle2,
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: const BoxDecoration(
                        color: Colors.white60,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                        ),
                      ),
                      child: Icon(
                        Icons.add,
                        color: global.isDarkModeEnable
                            ? Theme.of(context).scaffoldBackgroundColor
                            : i % 3 == 1
                                ? const Color(0XFF9EEEFF)
                                : i % 3 == 2
                                    ? const Color(0XFFFFF1C0)
                                    : const Color(0XFFFFD4D7),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: SizedBox(
                        height: 100,
                        width: 130,
                        child: CachedNetworkImage(
                          imageUrl: global.appInfo.imageUrl +
                              _homeModel.whatsnewProductList[i].productImage,
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              image: DecorationImage(
                                  image: imageProvider, fit: BoxFit.cover),
                            ),
                            alignment: Alignment.center,
                            child: Visibility(
                              visible:
                                  _homeModel.whatsnewProductList[i].stock > 0
                                      ? false
                                      : true,
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .primaryColorLight
                                        .withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(15)),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5)),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  child: Text(
                                    AppLocalizations.of(context)
                                        .txt_out_of_stock,
                                    style: Theme.of(context)
                                        .primaryTextTheme
                                        .headline2,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          placeholder: (context, url) =>
                              const Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) => Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              image: DecorationImage(
                                  image: AssetImage(global.defaultImage),
                                  fit: BoxFit.cover),
                            ),
                            alignment: Alignment.center,
                            child: Visibility(
                              visible:
                                  _homeModel.whatsnewProductList[i].stock > 0
                                      ? false
                                      : true,
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .primaryColorLight
                                        .withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(15)),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5)),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  child: Text(
                                    AppLocalizations.of(context)
                                        .txt_out_of_stock,
                                    style: Theme.of(context)
                                        .primaryTextTheme
                                        .headline2,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      }
      return widgetList;
    } catch (e) {
      widgetList.add(const SizedBox());
      print("Exception - homeScreen.dart - _whatsNewProductWidgetList():$e");
      return widgetList;
    }
  }
}
