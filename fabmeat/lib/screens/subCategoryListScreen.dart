import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mymeattest/models/businessLayer/baseRoute.dart';
import 'package:mymeattest/models/businessLayer/global.dart' as global;
import 'package:mymeattest/models/categoryModel.dart';
import 'package:mymeattest/models/subModel.dart';
import 'package:mymeattest/screens/checkOutScreen.dart';
import 'package:mymeattest/screens/loginScreen.dart';
import 'package:mymeattest/widgets/bottomNavigationWidget.dart';

class SubcategoryListScreen extends BaseRoute {
  final Category category;
  final List<Category> list;
  SubcategoryListScreen(this.category, this.list, {a, o})
      : super(a: a, o: o, r: 'SubcategoryListScreen');
  @override
  _SubcategoryListScreenState createState() =>
      _SubcategoryListScreenState(category, list);
}

class _SubcategoryListScreenState extends BaseRouteState {
  GlobalKey<ScaffoldState> _scaffoldKey;
  final List<SubModel> _subCategoryList = [];

  bool _isDataLoaded = false;
  int page = 1;
  Category category;
  List<Category> list;
  bool isSelected = false;
  _SubcategoryListScreenState(this.category, this.list) : super();
  bool _isRecordPending = true;
  bool _isMoreDataLoaded = false;
  final ScrollController _scrollController = ScrollController();
  final ScrollController _scrollController2 = ScrollController();
  @override
  Widget build(BuildContext context) {
    print(
        "width  ${MediaQuery.of(context).size.width} - height ${MediaQuery.of(context).size.height}");
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          leading: InkWell(
            customBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            onTap: () {
              // Navigator.of(context).pop();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => BottomNavigationWidget(
                      a: widget.analytics, o: widget.observer),
                ),
              );
            },
            child: const Align(
              alignment: Alignment.center,
              child: Icon(MdiIcons.arrowLeft),
            ),
          ),
          centerTitle: true,
          title: Text(category.title),
          // actions: [
          //   global.currentUser.cartCount != null &&
          //           global.currentUser.cartCount > 0
          //       ? FloatingActionButton(
          //           elevation: 0,
          //           backgroundColor: Colors.transparent,
          //           heroTag: null,
          //           child: Badge(
          //             badgeContent: Text(
          //               "${global.currentUser.cartCount}",
          //               style: TextStyle(color: Colors.white, fontSize: 08),
          //             ),
          //             padding: EdgeInsets.all(6),
          //             badgeColor: Colors.red,
          //             child: Icon(
          //               MdiIcons.shoppingOutline,
          //               color: Theme.of(context)
          //                   .appBarTheme
          //                   .actionsIconTheme
          //                   .color,
          //             ),
          //           ),
          //           mini: true,
          //           onPressed: () {
          //             Navigator.of(context).push(
          //               MaterialPageRoute(
          //                 builder: (context) => CheckoutScreen(
          //                     a: widget.analytics, o: widget.observer),
          //               ),
          //             );
          //           },
          //         )
          //       : FloatingActionButton(
          //           elevation: 0,
          //           backgroundColor: Colors.transparent,
          //           heroTag: null,
          //           child: Icon(
          //             MdiIcons.shoppingOutline,
          //             color:
          //                 Theme.of(context).appBarTheme.actionsIconTheme.color,
          //           ),
          //           mini: true,
          //           onPressed: () {
          //             Navigator.of(context).push(
          //               MaterialPageRoute(
          //                 builder: (context) => CheckoutScreen(
          //                     a: widget.analytics, o: widget.observer),
          //               ),
          //             );
          //           },
          //         ),
          // ],
        ),
        body: _categoryWidget(),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: global.currentUser.cartCount != null &&
                global.currentUser.cartCount > 0
            ? FloatingActionButton(
                elevation: 0,
                backgroundColor:
                    Theme.of(context).primaryTextTheme.caption.color,
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => CheckoutScreen(
                          a: widget.analytics, o: widget.observer),
                    ),
                  );
                },
                child:

                    //  Icon(
                    //   MdiIcons.shoppingOutline,
                    //   color: Theme.of(context).appBarTheme.actionsIconTheme.color,
                    // ),

                    global.currentUser.cartCount != null &&
                            global.currentUser.cartCount > 0
                        ? Badge(
                            badgeContent: Text(
                              "${global.currentUser.cartCount}",
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 08),
                            ),
                            padding: const EdgeInsets.all(6),
                            badgeColor: Colors.red,
                            child: Icon(
                              MdiIcons.shoppingOutline,
                              color: Theme.of(context)
                                  .appBarTheme
                                  .actionsIconTheme
                                  .color,
                            ),
                          )
                        : Icon(
                            MdiIcons.shoppingOutline,
                            color: Theme.of(context)
                                .appBarTheme
                                .actionsIconTheme
                                .color,
                          ),
              )
            : null,
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    _init();
  }

  _init() async {
    try {
      await _getData();
      _scrollController.addListener(() async {
        if (_scrollController.position.pixels ==
                _scrollController.position.maxScrollExtent &&
            !_isMoreDataLoaded) {
          setState(() {
            _isMoreDataLoaded = true;
          });
          await _getData();
          setState(() {
            _isMoreDataLoaded = false;
          });
        }
      });
      _isDataLoaded = true;
      setState(() {});
    } catch (e) {
      print("Exception - subcategoryListScreen.dart - _init():$e");
    }
  }

  _getData() async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        if (_isRecordPending) {
          setState(() {
            _isDataLoaded = false;
            _isMoreDataLoaded = true;
          });
          if (_subCategoryList.isEmpty) {
            page = 1;
          } else {
            page++;
          }
          await apiHelper
              .getSubCategoryList(page, category.catId)
              .then((result) async {
            if (result != null) {
              if (result.status == "1") {
                List<SubModel> tList = result.data;
                if (tList.isEmpty) {
                  _isRecordPending = false;
                }
                _subCategoryList.addAll(tList);
                setState(() {
                  _isMoreDataLoaded = false;
                });

                // for (var i in _subCategoryList) {
                //   await apiHelper
                //       .getSubcategoryProduct(i.catId, page, ProductFilter())
                //       .then((result) async {
                //     if (result != null) {
                //       if (result.status == "1") {
                //         List<Product> _tList = result.data;
                //         if (_tList.isEmpty) {
                //           _isRecordPending = false;
                //         }
                //         i.cuttingStyle.addAll(_tList);
                //         setState(() {
                //           _isMoreDataLoaded = false;
                //         });
                //       }
                //     }
                //   });
                // }
                print(_subCategoryList);
                _isDataLoaded = true;
              } else {
                _isRecordPending = false;
                setState(() {
                  _isMoreDataLoaded = false;
                });
              }
            }
          });
        }
      } else {
        showNetworkErrorSnackBar(_scaffoldKey);
      }
    } catch (e) {
      print("Exception - subcategoryListScreen.dart - _init():$e");
    }
  }

  List<Widget> _subCategoryListWidget() {
    List<Widget> productList = [];

    for (int i = 0; i < _subCategoryList[0].products.length; i++) {
      productList.add(
        InkWell(
          customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          onTap: () {
            // Navigator.of(context).push(
            //   MaterialPageRoute(
            //     builder: (context) => ProductListScreen(
            //         1, _subCategoryList[0].title,
            //         subcategoryId: _subCategoryList[0].catId,
            //         a: widget.analytics,
            //         o: widget.observer),
            //   ),
            // );
          },
          child: Container(
            height: _subCategoryList[0].products[i].stock <= 0
                ? 250
                : _subCategoryList[0].products[i].hideVarient == "Y"
                    ? 330
                    : 510,
            margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
            child: SizedBox(
              height: _subCategoryList[0].products[i].stock <= 0 ? 250 : 510,
              width: (MediaQuery.of(context).size.width) * .95,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardTheme.color,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(5),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 10, left: 7, right: 7),
                  child: Column(
                    //mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: _subCategoryList[0].products[i].stock <= 0
                            ? SizedBox(
                                height: 140,
                                width: 215,
                                child: CachedNetworkImage(
                                  imageUrl: global.appInfo.imageUrl +
                                      _subCategoryList[0]
                                          .products[i]
                                          .productImage,
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover),
                                    ),
                                    alignment: Alignment.center,
                                    child: Visibility(
                                      visible: _subCategoryList[0]
                                                  .products[i]
                                                  .stock >
                                              0
                                          ? false
                                          : true,
                                      child: Container(
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .primaryColorLight
                                                .withOpacity(0.5),
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(5)),
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
                                  placeholder: (context, url) => Center(
                                      child: CircularProgressIndicator()),
                                  errorWidget: (context, url, error) =>
                                      Container(
                                    child: Visibility(
                                      visible: _subCategoryList[0]
                                                  .products[i]
                                                  .stock >
                                              0
                                          ? false
                                          : true,
                                      child: Container(
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .primaryColorLight
                                                .withOpacity(0.5),
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(5)),
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
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      image: DecorationImage(
                                        image: AssetImage(
                                            '${global.defaultImage}'),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : SizedBox(
                                height: 175,
                                child: CachedNetworkImage(
                                  imageUrl: global.appInfo.imageUrl +
                                      _subCategoryList[0]
                                          .products[i]
                                          .productImage,
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                                  placeholder: (context, url) => Center(
                                      child: CircularProgressIndicator()),
                                  errorWidget: (context, url, error) =>
                                      Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      image: DecorationImage(
                                          image: AssetImage(
                                              '${global.defaultImage}'),
                                          fit: BoxFit.fill),
                                    ),
                                  ),
                                ),
                                //width: 110,
                              ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              _subCategoryList[0].products[i].productName,
                              style:
                                  Theme.of(context).primaryTextTheme.bodyText1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              _subCategoryList[0].products[i].hideVarient == "Y"
                                  ? 'Gross: ${_subCategoryList[0].products[i].grossWt}  Net: ${_subCategoryList[0].products[i].quantity} ${_subCategoryList[0].products[i].unit}'
                                  : 'Gross: ${_subCategoryList[0].products[i].grossWt}',
                              style:
                                  Theme.of(context).primaryTextTheme.bodyText1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            if (_subCategoryList[0].products[i].hideVarient ==
                                "Y")
                              RichText(
                                text: TextSpan(
                                  text:
                                      "Price: ${global.appInfo.currencySign} ",
                                  style: Theme.of(context)
                                      .primaryTextTheme
                                      .bodyText1,
                                  children: [
                                    TextSpan(
                                      text:
                                          '${_subCategoryList[0].products[i].price}  ',
                                      style: Theme.of(context)
                                          .primaryTextTheme
                                          .bodyText1,
                                    ),
                                    TextSpan(
                                      text:
                                          '${global.appInfo.currencySign} ${_subCategoryList[0].products[i].mrp}',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            const SizedBox(
                              height: 10,
                            ),
                            if (_subCategoryList[0].products[i].hideVarient ==
                                "Y") ...[
                              _subCategoryList[0].products[i].stock > 0
                                  ? _subCategoryList[0].products[i].cartQty ==
                                              null ||
                                          (_subCategoryList[0]
                                                      .products[i]
                                                      .cartQty !=
                                                  null &&
                                              _subCategoryList[0]
                                                      .products[i]
                                                      .cartQty ==
                                                  0)
                                      ? Container(
                                          height: 30,
                                          width: 70,
                                          decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .iconTheme
                                                .color,
                                            borderRadius:
                                                const BorderRadius.only(
                                              bottomRight: Radius.circular(10),
                                              topLeft: Radius.circular(10),
                                            ),
                                          ),
                                          child: IconButton(
                                            padding: const EdgeInsets.all(0),
                                            visualDensity: const VisualDensity(
                                                vertical: -4, horizontal: -4),
                                            onPressed: () async {
                                              if (global.currentUser.id ==
                                                  null) {
                                                Future.delayed(Duration.zero,
                                                    () {
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            LoginScreen(
                                                              a: widget
                                                                  .analytics,
                                                              o: widget
                                                                  .observer,
                                                            )),
                                                  );
                                                });
                                              } else {
                                                bool isAdded = await addToCart(
                                                  1,
                                                  _subCategoryList[0]
                                                      .products[i]
                                                      .varientId,
                                                  0,
                                                  _scaffoldKey,
                                                  true,
                                                  _subCategoryList[0]
                                                      .products[i]
                                                      .price,
                                                );
                                                if (isAdded) {
                                                  _subCategoryList[0]
                                                          .products[i]
                                                          .cartQty =
                                                      _subCategoryList[0]
                                                              .products[i]
                                                              .cartQty +
                                                          1;
                                                  // product
                                                  //     .varient[
                                                  //         index]
                                                  //     .cartQty = product
                                                  //         .varient[index].cartQty +
                                                  //     1;
                                                }
                                                setState(() {});
                                              }
                                            },
                                            icon: Container(
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.add,
                                                    color: Theme.of(context)
                                                        .primaryTextTheme
                                                        .caption
                                                        .color,
                                                  ),
                                                  Text('Add',
                                                      style: TextStyle(
                                                          color: Theme.of(
                                                                  context)
                                                              .primaryTextTheme
                                                              .caption
                                                              .color))
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                      : Container(
                                          height: 28,
                                          width: 100,
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              stops: const [0, .90],
                                              begin: Alignment.centerLeft,
                                              end: Alignment.centerRight,
                                              colors: [
                                                Theme.of(context)
                                                    .primaryColorLight,
                                                Theme.of(context).primaryColor
                                              ],
                                            ),
                                            borderRadius:
                                                const BorderRadius.only(
                                              bottomRight: Radius.circular(10),
                                              topLeft: Radius.circular(10),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              IconButton(
                                                  padding:
                                                      const EdgeInsets.all(0),
                                                  visualDensity:
                                                      const VisualDensity(
                                                          vertical: -4,
                                                          horizontal: -4),
                                                  onPressed: () async {
                                                    bool isAdded =
                                                        await addToCart(
                                                      _subCategoryList[0]
                                                              .products[i]
                                                              .cartQty -
                                                          1,
                                                      _subCategoryList[0]
                                                          .products[i]
                                                          .varientId,
                                                      0,
                                                      _scaffoldKey,
                                                      false,
                                                      _subCategoryList[0]
                                                          .products[i]
                                                          .price,
                                                    );
                                                    if (isAdded) {
                                                      _subCategoryList[0]
                                                              .products[i]
                                                              .cartQty =
                                                          _subCategoryList[0]
                                                                  .products[i]
                                                                  .cartQty -
                                                              1;
                                                    }
                                                    setState(() {});
                                                  },
                                                  icon: Icon(
                                                    FontAwesomeIcons.minus,
                                                    size: 11,
                                                    color: Theme.of(context)
                                                        .primaryTextTheme
                                                        .caption
                                                        .color,
                                                  )),
                                              Text(
                                                "${_subCategoryList[0].products[i].cartQty}",
                                                style: Theme.of(context)
                                                    .primaryTextTheme
                                                    .bodyText1
                                                    .copyWith(
                                                        color: Theme.of(context)
                                                            .primaryTextTheme
                                                            .caption
                                                            .color),
                                              ),
                                              IconButton(
                                                  padding:
                                                      const EdgeInsets.all(0),
                                                  visualDensity:
                                                      const VisualDensity(
                                                          vertical: -4,
                                                          horizontal: -4),
                                                  onPressed: () async {
                                                    bool isAdded =
                                                        await addToCart(
                                                      _subCategoryList[0]
                                                              .products[i]
                                                              .cartQty +
                                                          1,
                                                      _subCategoryList[0]
                                                          .products[i]
                                                          .varientId,
                                                      0,
                                                      _scaffoldKey,
                                                      false,
                                                      _subCategoryList[0]
                                                          .products[i]
                                                          .price,
                                                    );
                                                    if (isAdded) {
                                                      _subCategoryList[0]
                                                        ..products[i].cartQty =
                                                            _subCategoryList[0]
                                                                    .products[i]
                                                                    .cartQty +
                                                                1;
                                                    }
                                                    setState(() {});
                                                  },
                                                  icon: Icon(
                                                    FontAwesomeIcons.plus,
                                                    size: 11,
                                                    color: Theme.of(context)
                                                        .primaryTextTheme
                                                        .caption
                                                        .color,
                                                  )),
                                            ],
                                          ),
                                        )
                                  : const SizedBox(),
                            ]
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          _subCategoryList[0].products[i].stock > 0 &&
                                  _subCategoryList[0].products[i].hideVarient ==
                                      "N"
                              ? SizedBox(
                                  height: 230,
                                  width: 400,
                                  child: ListView.builder(
                                    controller: _scrollController2,
                                    scrollDirection: Axis.horizontal,
                                    // physics: NeverScrollableScrollPhysics(),
                                    itemCount: _subCategoryList[0]
                                        .products[i]
                                        .varients
                                        .length,
                                    //  shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        height: 180,
                                        margin: const EdgeInsets.only(
                                            top: 40, left: 10),
                                        child: Stack(
                                          clipBehavior: Clip.none,
                                          children: [
                                            SizedBox(
                                              height: 178,
                                              width: 160,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  //color: Colors.red,
                                                  border: Border.all(
                                                      width: 4,
                                                      color: Colors.white),
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                    Radius.circular(12),
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 78,
                                                          left: 10,
                                                          right: 0),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        _subCategoryList[0]
                                                            .products[i]
                                                            .varients[index]
                                                            .description,
                                                        style: Theme.of(context)
                                                            .primaryTextTheme
                                                            .bodyText1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                      RichText(
                                                        text: TextSpan(
                                                          text:
                                                              "Net: ${_subCategoryList[0].products[i].varients[index].quantity} ${_subCategoryList[0].products[i].varients[index].unit} ",
                                                          style: Theme.of(
                                                                  context)
                                                              .primaryTextTheme
                                                              .headline2,
                                                          children: const [
                                                            // TextSpan(
                                                            //   text:
                                                            //       '${_subCategoryList[0].products[i].varients[index].price}',
                                                            //   style: Theme.of(
                                                            //           context)
                                                            //       .primaryTextTheme
                                                            //       .bodyText1,
                                                            // ),
                                                          ],
                                                        ),
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          RichText(
                                                            textScaleFactor:
                                                                1.0,
                                                            text: TextSpan(
                                                              text:
                                                                  "Price: ${global.appInfo.currencySign} ",
                                                              style: Theme.of(
                                                                      context)
                                                                  .primaryTextTheme
                                                                  .headline2,
                                                              children: [
                                                                TextSpan(
                                                                  text:
                                                                      '${_subCategoryList[0].products[i].varients[index].price}   ',
                                                                  style: Theme.of(
                                                                          context)
                                                                      .primaryTextTheme
                                                                      .bodyText1,
                                                                ),
                                                                TextSpan(
                                                                  text:
                                                                      '${global.appInfo.currencySign} ${_subCategoryList[0].products[i].varients[index].mrp}',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .grey,
                                                                    decoration:
                                                                        TextDecoration
                                                                            .lineThrough,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      _subCategoryList[0]
                                                                  .products[i]
                                                                  .varients[
                                                                      index]
                                                                  .stock >
                                                              0
                                                          ? _subCategoryList[0]
                                                                          .products[
                                                                              i]
                                                                          .varients[
                                                                              index]
                                                                          .cartQty ==
                                                                      null ||
                                                                  (_subCategoryList[0]
                                                                              .products[
                                                                                  i]
                                                                              .varients[
                                                                                  index]
                                                                              .cartQty !=
                                                                          null &&
                                                                      _subCategoryList[0]
                                                                              .products[i]
                                                                              .varients[index]
                                                                              .cartQty ==
                                                                          0)
                                                              ? Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .end,
                                                                  children: [
                                                                    Container(
                                                                      height:
                                                                          30,
                                                                      width: 70,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: Theme.of(context)
                                                                            .iconTheme
                                                                            .color,
                                                                        borderRadius:
                                                                            const BorderRadius.only(
                                                                          bottomRight:
                                                                              Radius.circular(10),
                                                                          topLeft:
                                                                              Radius.circular(10),
                                                                        ),
                                                                      ),
                                                                      child:
                                                                          IconButton(
                                                                        padding:
                                                                            const EdgeInsets.all(0),
                                                                        visualDensity: const VisualDensity(
                                                                            vertical:
                                                                                -4,
                                                                            horizontal:
                                                                                -4),
                                                                        onPressed:
                                                                            () async {
                                                                          if (global.currentUser.id ==
                                                                              null) {
                                                                            Future.delayed(Duration.zero,
                                                                                () {
                                                                              Navigator.of(context).push(
                                                                                MaterialPageRoute(
                                                                                    builder: (context) => LoginScreen(
                                                                                          a: widget.analytics,
                                                                                          o: widget.observer,
                                                                                        )),
                                                                              );
                                                                            });
                                                                          } else {
                                                                            bool isAdded = await addToCart(
                                                                                1,
                                                                                _subCategoryList[0].products[i].varients[index].varientId,
                                                                                0,
                                                                                _scaffoldKey,
                                                                                true,
                                                                                _subCategoryList[0].products[i].varients[index].price);
                                                                            if (isAdded) {
                                                                              _subCategoryList[0].products[i].varients[index].cartQty = _subCategoryList[0].products[i].varients[index].cartQty + 1;
                                                                              // product
                                                                              //     .varient[
                                                                              //         index]
                                                                              //     .cartQty = product
                                                                              //         .varient[index].cartQty +
                                                                              //     1;
                                                                            }
                                                                            setState(() {});
                                                                          }
                                                                        },
                                                                        icon:
                                                                            Container(
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              Icon(
                                                                                Icons.add,
                                                                                color: Theme.of(context).primaryTextTheme.caption.color,
                                                                              ),
                                                                              Text('Add', style: TextStyle(color: Theme.of(context).primaryTextTheme.caption.color))
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                )
                                                              : Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .end,
                                                                  children: [
                                                                    Container(
                                                                      height:
                                                                          28,
                                                                      width:
                                                                          100,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        gradient:
                                                                            LinearGradient(
                                                                          stops: const [
                                                                            0,
                                                                            .90
                                                                          ],
                                                                          begin:
                                                                              Alignment.centerLeft,
                                                                          end: Alignment
                                                                              .centerRight,
                                                                          colors: [
                                                                            Theme.of(context).primaryColorLight,
                                                                            Theme.of(context).primaryColor
                                                                          ],
                                                                        ),
                                                                        borderRadius:
                                                                            const BorderRadius.only(
                                                                          bottomRight:
                                                                              Radius.circular(10),
                                                                          topLeft:
                                                                              Radius.circular(10),
                                                                        ),
                                                                      ),
                                                                      child:
                                                                          Row(
                                                                        mainAxisSize:
                                                                            MainAxisSize.min,
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceEvenly,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.center,
                                                                        children: [
                                                                          IconButton(
                                                                              padding: const EdgeInsets.all(0),
                                                                              visualDensity: const VisualDensity(vertical: -4, horizontal: -4),
                                                                              onPressed: () async {
                                                                                bool isAdded = await addToCart(_subCategoryList[0].products[i].varients[index].cartQty - 1, _subCategoryList[0].products[i].varients[index].varientId, 0, _scaffoldKey, false, _subCategoryList[0].products[i].varients[index].price);
                                                                                if (isAdded) {
                                                                                  _subCategoryList[0].products[i].varients[index].cartQty = _subCategoryList[0].products[i].varients[index].cartQty - 1;
                                                                                }
                                                                                setState(() {});
                                                                              },
                                                                              icon: Icon(
                                                                                FontAwesomeIcons.minus,
                                                                                size: 11,
                                                                                color: Theme.of(context).primaryTextTheme.caption.color,
                                                                              )),
                                                                          Text(
                                                                            "${_subCategoryList[0].products[i].varients[index].cartQty}",
                                                                            style:
                                                                                Theme.of(context).primaryTextTheme.bodyText1.copyWith(color: Theme.of(context).primaryTextTheme.caption.color),
                                                                          ),
                                                                          IconButton(
                                                                              padding: const EdgeInsets.all(0),
                                                                              visualDensity: const VisualDensity(vertical: -4, horizontal: -4),
                                                                              onPressed: () async {
                                                                                bool isAdded = await addToCart(
                                                                                  _subCategoryList[0].products[i].varients[index].cartQty + 1,
                                                                                  _subCategoryList[0].products[i].varients[index].varientId,
                                                                                  0,
                                                                                  _scaffoldKey,
                                                                                  false,
                                                                                  _subCategoryList[0].products[i].varients[index].price,
                                                                                );
                                                                                if (isAdded) {
                                                                                  _subCategoryList[0].products[i].varients[index].cartQty = _subCategoryList[0].products[i].varients[index].cartQty + 1;
                                                                                }
                                                                                setState(() {});
                                                                              },
                                                                              icon: Icon(
                                                                                FontAwesomeIcons.plus,
                                                                                size: 11,
                                                                                color: Theme.of(context).primaryTextTheme.caption.color,
                                                                              )),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                )
                                                          : const SizedBox(),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              top: -30,
                                              left: 10,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 5),
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  height: 100,
                                                  width: 130,
                                                  child: CachedNetworkImage(
                                                    imageUrl: global
                                                            .appInfo.imageUrl +
                                                        _subCategoryList[0]
                                                            .products[i]
                                                            .varients[index]
                                                            .varientImage,
                                                    imageBuilder: (context,
                                                            imageProvider) =>
                                                        Container(
                                                      alignment:
                                                          Alignment.center,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                        image: DecorationImage(
                                                            image:
                                                                imageProvider,
                                                            fit: BoxFit.cover),
                                                      ),
                                                    ),
                                                    placeholder: (context,
                                                            url) =>
                                                        Center(
                                                            child:
                                                                CircularProgressIndicator()),
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                        image: DecorationImage(
                                                            image: AssetImage(
                                                                '${global.defaultImage}'),
                                                            fit: BoxFit.cover),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                )
                              : Container(),
                          _isMoreDataLoaded
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    backgroundColor: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const SizedBox()
                        ],
                      )
                    ],
                  ),
                ),
              ),
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

  _categoryWidget() {
    return RefreshIndicator(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      color: Theme.of(context).primaryColor,
      onRefresh: () async {
        _isDataLoaded = false;
        _isRecordPending = true;
        setState(() {});
        _subCategoryList.clear();
        await _init();
        return null;
      },
      child: SingleChildScrollView(
        //controller: _scrollController,
        child: Column(
          children: [
            SizedBox(
              height: 50,
              child: ListView.builder(
                  itemCount: list.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          // setState(() {
                          //   isSelected = true;
                          // });

                          setState(() {
                            category = list[index];
                            _subCategoryList.clear();
                          });
                          _getData();
                          // Navigator.of(context).push(
                          //   MaterialPageRoute(
                          //     builder: (context) => SubcategoryListScreen(
                          //         list[index], list,
                          //         a: widget.analytics, o: widget.observer),
                          //   ),
                          // );
                        },
                        child: Chip(
                          padding: EdgeInsets.zero,
                          shape: !(list[index] == category)
                              ? RoundedRectangleBorder(
                                  side: const BorderSide(),
                                  borderRadius: BorderRadius.circular(20))
                              : null,
                          backgroundColor: !(list[index] == category)
                              ? Colors.white
                              : Theme.of(context).iconTheme.color,
                          label: Text(
                            list[index].title,
                            style: TextStyle(
                                fontSize: 13,
                                color: !(list[index] == category)
                                    ? Colors.black
                                    : Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    );
                  }),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(bottom: 10, left: 4, right: 4, top: 10),
              child: _isDataLoaded
                  ? _subCategoryList.isNotEmpty
                      ? Wrap(
                          direction: Axis.vertical,
                          spacing: 0,
                          runSpacing: 10,
                          children: _subCategoryListWidget(),
                        )
                      : SizedBox(
                          height: MediaQuery.of(context).size.height - 20,
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              AppLocalizations.of(context).txt_nothing_to_show,
                              style:
                                  Theme.of(context).primaryTextTheme.bodyText1,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                  : Wrap(
                      spacing: 0,
                      runSpacing: 10,
                      children: catgoryShimmer(),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
