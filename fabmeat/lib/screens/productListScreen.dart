import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mymeattest/models/businessLayer/baseRoute.dart';
import 'package:mymeattest/models/businessLayer/global.dart' as global;
import 'package:mymeattest/models/productFilterModel.dart';
import 'package:mymeattest/models/subModel.dart';
import 'package:mymeattest/screens/checkOutScreen.dart';
import 'package:mymeattest/screens/loginScreen.dart';
import 'package:shimmer/shimmer.dart';

class ProductListScreen extends BaseRoute {
  final int subcategoryId;
  final int screenId;
  final String title;
  ProductListScreen(this.screenId, this.title, {this.subcategoryId, a, o})
      : super(a: a, o: o, r: 'ProductListScreen');
  @override
  _subCategoryListScreenState createState() =>
      _subCategoryListScreenState(screenId, title, subcategoryId);
}

class _subCategoryListScreenState extends BaseRouteState {
  bool _isRecordPending = true;
  bool _isMoreDataLoaded = false;
  final ProductFilter _productFilter = ProductFilter();
  final ScrollController _scrollController = ScrollController();
  bool _isDataLoaded = false;
  final ScrollController _scrollController3 = ScrollController();
  final ScrollController _scrollController2 = ScrollController();
  final List<SubModel> _subCategoryList = [];
  int page = 1;
  int subcategoryId;
  int screenId;
  GlobalKey<ScaffoldState> _scaffoldKey;
  String title;
  _subCategoryListScreenState(this.screenId, this.title, this.subcategoryId)
      : super();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: InkWell(
            customBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            onTap: () {
              Navigator.of(context).pop();
            },
            child: const Align(
              alignment: Alignment.center,
              child: Icon(MdiIcons.arrowLeft),
            ),
          ),
          title: Text(title),
          // actions: [
          //   // IconButton(
          //   //     onPressed: () async {
          //   //       await openBarcodeScanner(_scaffoldKey);
          //   //     },
          //   //     icon: Icon(
          //   //       MdiIcons.barcode,
          //   //       color: Theme.of(context).appBarTheme.actionsIconTheme.color,
          //   //     )),
          //   global.currentUser.cartCount != null &&
          //           global.currentUser.cartCount > 0
          //       ? FloatingActionButton(
          //           elevation: 0,
          //           backgroundColor: Colors.transparent,
          //           heroTag: null,
          //           mini: true,
          //           onPressed: () {
          //             Navigator.of(context).push(
          //               MaterialPageRoute(
          //                 builder: (context) => CheckoutScreen(
          //                     a: widget.analytics, o: widget.observer),
          //               ),
          //             );
          //           },
          //           child: Badge(
          //             badgeContent: Text(
          //               "${global.currentUser.cartCount}",
          //               style:
          //                   const TextStyle(color: Colors.white, fontSize: 08),
          //             ),
          //             padding: const EdgeInsets.all(6),
          //             badgeColor: Colors.red,
          //             child: Icon(
          //               MdiIcons.shoppingOutline,
          //               color: Theme.of(context)
          //                   .appBarTheme
          //                   .actionsIconTheme
          //                   .color,
          //             ),
          //           ),
          //         )
          //       : FloatingActionButton(
          //           elevation: 0,
          //           backgroundColor: Colors.transparent,
          //           heroTag: null,
          //           mini: true,
          //           onPressed: () {
          //             Navigator.of(context).push(
          //               MaterialPageRoute(
          //                 builder: (context) => CheckoutScreen(
          //                     a: widget.analytics, o: widget.observer),
          //               ),
          //             );
          //           },
          //           child: Icon(
          //             MdiIcons.shoppingOutline,
          //             color:
          //                 Theme.of(context).appBarTheme.actionsIconTheme.color,
          //           ),
          //         ),
          //   IconButton(
          //     onPressed: () {
          //       Navigator.of(context)
          //           .push(
          //         MaterialPageRoute(
          //           builder: (context) => FilterScreen(_productFilter,
          //               a: widget.analytics, o: widget.observer),
          //         ),
          //       )
          //           .then((value) async {
          //         if (value != null) {
          //           _isDataLoaded = false;
          //           _isRecordPending = true;
          //           _subCategoryList.clear();
          //           setState(() {});
          //           _productFilter = value;
          //           print("screen id $screenId");
          //           await _init();
          //         }
          //       });
          //     },
          //     icon: Icon(
          //       MdiIcons.tuneVerticalVariant,
          //       color: Theme.of(context).appBarTheme.actionsIconTheme.color,
          //     ),
          //   )
          // ],
        ),
        body: SingleChildScrollView(
          child: Padding(
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
                            style: Theme.of(context).primaryTextTheme.bodyText1,
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
        ),
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
        //  Padding(
        //   padding: EdgeInsets.all(10.0),
        //   child: RefreshIndicator(
        //     backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        //     color: Theme.of(context).primaryColor,
        //     onRefresh: () async {
        //       _isDataLoaded = false;
        //       _isRecordPending = true;
        //       setState(() {});
        //       _subCategoryList.clear();
        //       await _init();
        //       return null;
        //     },
        //     child: _isDataLoaded
        //         ? _subCategoryList.isNotEmpty
        //             ? SingleChildScrollView(
        //                 controller: _scrollController,
        //                 child: Column(
        //                   children: [
        //                     ListView.builder(
        //                       physics: NeverScrollableScrollPhysics(),
        //                       itemCount: _subCategoryList.length,
        //                       shrinkWrap: true,
        //                       itemBuilder: (context, index) {
        //                         return Container(
        //                           margin: EdgeInsets.only(top: 10, bottom: 10),
        //                           decoration: BoxDecoration(
        //                             borderRadius: BorderRadius.all(
        //                               Radius.circular(10),
        //                             ),
        //                           ),
        //                           child: InkWell(
        //                             onTap: () {
        //                               Navigator.of(context).push(
        //                                 MaterialPageRoute(
        //                                   builder: (context) =>
        //                                       ProductDetailScreen(
        //                                           productId: _subCategoryList[index]
        //                                               .productId,
        //                                           a: widget.analytics,
        //                                           o: widget.observer),
        //                                 ),
        //                               );
        //                             },
        //                             borderRadius: BorderRadius.all(
        //                               Radius.circular(10),
        //                             ),
        //                             child: Stack(
        //                               clipBehavior: Clip.none,
        //                               alignment: Alignment.center,
        //                               children: [
        //                                 Container(
        //                                   height: 110,
        //                                   width:
        //                                       MediaQuery.of(context).size.width,
        //                                   child: Container(
        //                                     decoration: BoxDecoration(
        //                                       color: Theme.of(context)
        //                                           .cardTheme
        //                                           .color,
        //                                       borderRadius: BorderRadius.all(
        //                                         Radius.circular(10),
        //                                       ),
        //                                     ),
        //                                     child: Padding(
        //                                       padding: const EdgeInsets.only(
        //                                           top: 15, left: 130),
        //                                       child: Column(
        //                                         mainAxisSize: MainAxisSize.min,
        //                                         mainAxisAlignment:
        //                                             MainAxisAlignment.start,
        //                                         crossAxisAlignment: global.isRTL
        //                                             ? CrossAxisAlignment.end
        //                                             : CrossAxisAlignment.start,
        //                                         children: [
        //                                           Text(
        //                                             '${_subCategoryList[index].productName}',
        //                                             style: Theme.of(context)
        //                                                 .primaryTextTheme
        //                                                 .bodyText1,
        //                                             overflow:
        //                                                 TextOverflow.ellipsis,
        //                                           ),
        //                                           Text(
        //                                             '${_subCategoryList[index].type}',
        //                                             style: Theme.of(context)
        //                                                 .primaryTextTheme
        //                                                 .headline2,
        //                                             overflow:
        //                                                 TextOverflow.ellipsis,
        //                                           ),
        //                                           RichText(
        //                                             text: TextSpan(
        //                                               text:
        //                                                   "${global.appInfo.currencySign} ",
        //                                               style: Theme.of(context)
        //                                                   .primaryTextTheme
        //                                                   .headline2,
        //                                               children: [
        //                                                 TextSpan(
        //                                                   text:
        //                                                       '${_subCategoryList[index].price}',
        //                                                   style: Theme.of(
        //                                                           context)
        //                                                       .primaryTextTheme
        //                                                       .bodyText1,
        //                                                 ),
        //                                                 TextSpan(
        //                                                   text:
        //                                                       ' / ${_subCategoryList[index].quantity} ${_subCategoryList[index].unit}',
        //                                                   style: Theme.of(
        //                                                           context)
        //                                                       .primaryTextTheme
        //                                                       .headline2,
        //                                                 )
        //                                               ],
        //                                             ),
        //                                           ),
        //                                           _subCategoryList[index].rating !=
        //                                                       null &&
        //                                                   _subCategoryList[index]
        //                                                           .rating >
        //                                                       0
        //                                               ? Padding(
        //                                                   padding:
        //                                                       EdgeInsets.only(
        //                                                           top: 4.0),
        //                                                   child: Row(
        //                                                     mainAxisSize:
        //                                                         MainAxisSize
        //                                                             .min,
        //                                                     mainAxisAlignment:
        //                                                         MainAxisAlignment
        //                                                             .start,
        //                                                     crossAxisAlignment:
        //                                                         CrossAxisAlignment
        //                                                             .center,
        //                                                     children: [
        //                                                       Icon(
        //                                                         Icons.star,
        //                                                         size: 18,
        //                                                         color: Theme.of(
        //                                                                 context)
        //                                                             .primaryColorLight,
        //                                                       ),
        //                                                       RichText(
        //                                                         text: TextSpan(
        //                                                           text:
        //                                                               "${_subCategoryList[index].rating} ",
        //                                                           style: Theme.of(
        //                                                                   context)
        //                                                               .primaryTextTheme
        //                                                               .bodyText1,
        //                                                           children: [
        //                                                             TextSpan(
        //                                                               text: '|',
        //                                                               style: Theme.of(
        //                                                                       context)
        //                                                                   .primaryTextTheme
        //                                                                   .headline2,
        //                                                             ),
        //                                                             TextSpan(
        //                                                               text:
        //                                                                   ' ${_subCategoryList[index].ratingCount} ${AppLocalizations.of(context).txt_ratings}',
        //                                                               style: Theme.of(
        //                                                                       context)
        //                                                                   .primaryTextTheme
        //                                                                   .headline1,
        //                                                             )
        //                                                           ],
        //                                                         ),
        //                                                       ),
        //                                                     ],
        //                                                   ),
        //                                                 )
        //                                               : SizedBox()
        //                                         ],
        //                                       ),
        //                                     ),
        //                                   ),
        //                                 ),
        //                                 Positioned(
        //                                   right: 0,
        //                                   top: 0,
        //                                   child: Column(
        //                                     mainAxisSize: MainAxisSize.min,
        //                                     mainAxisAlignment:
        //                                         MainAxisAlignment.start,
        //                                     crossAxisAlignment:
        //                                         CrossAxisAlignment.end,
        //                                     children: [
        //                                       _subCategoryList[index].discount !=
        //                                                   null &&
        //                                               _subCategoryList[index]
        //                                                       .discount >
        //                                                   0
        //                                           ? Container(
        //                                               height: 20,
        //                                               width: 70,
        //                                               decoration: BoxDecoration(
        //                                                 color: Colors.lightBlue,
        //                                                 borderRadius:
        //                                                     BorderRadius.only(
        //                                                   topRight:
        //                                                       Radius.circular(
        //                                                           10),
        //                                                   bottomLeft:
        //                                                       Radius.circular(
        //                                                           10),
        //                                                 ),
        //                                               ),
        //                                               child: Text(
        //                                                 "${_subCategoryList[index].discount} ${AppLocalizations.of(context).txt_off}",
        //                                                 textAlign:
        //                                                     TextAlign.center,
        //                                                 style: Theme.of(context)
        //                                                     .primaryTextTheme
        //                                                     .caption,
        //                                               ),
        //                                             )
        //                                           : SizedBox(
        //                                               height: 20,
        //                                               width: 60,
        //                                             ),
        //                                       IconButton(
        //                                         onPressed: () async {
        //                                           bool _isAdded =
        //                                               await addRemoveWishList(
        //                                                   _subCategoryList[index]
        //                                                       .varientId,
        //                                                   _scaffoldKey);
        //                                           if (_isAdded) {
        //                                             _subCategoryList[index]
        //                                                     .isFavourite =
        //                                                 !_subCategoryList[index]
        //                                                     .isFavourite;
        //                                           }

        //                                           setState(() {});
        //                                         },
        //                                         icon: _subCategoryList[index]
        //                                                 .isFavourite
        //                                             ? Icon(
        //                                                 MdiIcons.heart,
        //                                                 size: 20,
        //                                                 color:
        //                                                     Color(0xFFEF5656),
        //                                               )
        //                                             : Icon(
        //                                                 MdiIcons.heart,
        //                                                 size: 20,
        //                                                 color:
        //                                                     Color(0xFF4A4352),
        //                                               ),
        //                                       )
        //                                     ],
        //                                   ),
        //                                 ),
        //                                 _subCategoryList[index].stock > 0
        //                                     ? Positioned(
        //                                         bottom: 0,
        //                                         right: 0,
        //                                         child: Container(
        //                                           height: 30,
        //                                           width: 30,
        //                                           decoration: BoxDecoration(
        //                                             color: Theme.of(context)
        //                                                 .iconTheme
        //                                                 .color,
        //                                             borderRadius:
        //                                                 BorderRadius.only(
        //                                               bottomRight:
        //                                                   Radius.circular(10),
        //                                               topLeft:
        //                                                   Radius.circular(10),
        //                                             ),
        //                                           ),
        //                                           child: IconButton(
        //                                             padding: EdgeInsets.all(0),
        //                                             visualDensity:
        //                                                 VisualDensity(
        //                                                     vertical: -4,
        //                                                     horizontal: -4),
        //                                             onPressed: () async {
        //                                               await addToCartShowModalBottomSheet(
        //                                                   _subCategoryList[index],
        //                                                   _scaffoldKey);
        //                                             },
        //                                             icon: Icon(
        //                                               Icons.add,
        //                                               color: Theme.of(context)
        //                                                   .primaryTextTheme
        //                                                   .caption
        //                                                   .color,
        //                                             ),
        //                                           ),
        //                                         ),
        //                                       )
        //                                     : SizedBox(),
        //                                 Positioned(
        //                                   left: 0,
        //                                   top: -10,
        //                                   child: Container(
        //                                     child: CachedNetworkImage(
        //                                       imageUrl:
        //                                           global.appInfo.imageUrl +
        //                                               _subCategoryList[index]
        //                                                   .productImage,
        //                                       imageBuilder:
        //                                           (context, imageProvider) =>
        //                                               Container(
        //                                         decoration: BoxDecoration(
        //                                           borderRadius:
        //                                               BorderRadius.circular(15),
        //                                           image: DecorationImage(
        //                                             image: imageProvider,
        //                                             fit: BoxFit.cover,
        //                                           ),
        //                                         ),
        //                                         alignment: Alignment.center,
        //                                         child: Visibility(
        //                                           visible: _subCategoryList[index]
        //                                                       .stock >
        //                                                   0
        //                                               ? false
        //                                               : true,
        //                                           child: Container(
        //                                             alignment: Alignment.center,
        //                                             decoration: BoxDecoration(
        //                                                 color: Theme.of(context)
        //                                                     .primaryColorLight
        //                                                     .withOpacity(0.5),
        //                                                 borderRadius:
        //                                                     BorderRadius
        //                                                         .circular(15)),
        //                                             child: Container(
        //                                               decoration: BoxDecoration(
        //                                                   color: Colors.white,
        //                                                   borderRadius:
        //                                                       BorderRadius
        //                                                           .circular(5)),
        //                                               padding: const EdgeInsets
        //                                                       .symmetric(
        //                                                   horizontal: 10,
        //                                                   vertical: 5),
        //                                               child: Text(
        //                                                 '${AppLocalizations.of(context).txt_out_of_stock}',
        //                                                 style: Theme.of(context)
        //                                                     .primaryTextTheme
        //                                                     .headline2,
        //                                               ),
        //                                             ),
        //                                           ),
        //                                         ),
        //                                       ),
        //                                       placeholder: (context, url) => Center(
        //                                           child:
        //                                               CircularProgressIndicator()),
        //                                       errorWidget:
        //                                           (context, url, error) =>
        //                                               Container(
        //                                         child: Visibility(
        //                                           visible: _subCategoryList[index]
        //                                                       .stock >
        //                                                   0
        //                                               ? false
        //                                               : true,
        //                                           child: Container(
        //                                             alignment: Alignment.center,
        //                                             decoration: BoxDecoration(
        //                                                 color: Theme.of(context)
        //                                                     .primaryColorLight
        //                                                     .withOpacity(0.5),
        //                                                 borderRadius:
        //                                                     BorderRadius
        //                                                         .circular(15)),
        //                                             child: Container(
        //                                               decoration: BoxDecoration(
        //                                                   color: Colors.white,
        //                                                   borderRadius:
        //                                                       BorderRadius
        //                                                           .circular(5)),
        //                                               padding: const EdgeInsets
        //                                                       .symmetric(
        //                                                   horizontal: 10,
        //                                                   vertical: 5),
        //                                               child: Text(
        //                                                 '${AppLocalizations.of(context).txt_out_of_stock}',
        //                                                 style: Theme.of(context)
        //                                                     .primaryTextTheme
        //                                                     .headline2,
        //                                               ),
        //                                             ),
        //                                           ),
        //                                         ),
        //                                         alignment: Alignment.center,
        //                                         decoration: BoxDecoration(
        //                                           borderRadius:
        //                                               BorderRadius.circular(15),
        //                                           image: DecorationImage(
        //                                             image: AssetImage(
        //                                                 '${global.defaultImage}'),
        //                                             fit: BoxFit.cover,
        //                                           ),
        //                                         ),
        //                                       ),
        //                                     ),
        //                                     height: 100,
        //                                     width: 120,
        //                                   ),
        //                                 )
        //                               ],
        //                             ),
        //                           ),
        //                         );
        //                       },
        //                     ),
        //                     _isMoreDataLoaded
        //                         ? Center(
        //                             child: CircularProgressIndicator(
        //                               backgroundColor: Colors.white,
        //                               strokeWidth: 2,
        //                             ),
        //                           )
        //                         : SizedBox()
        //                   ],
        //                 ),
        //               )
        //             : Center(
        //                 child: Text(
        //                   "${AppLocalizations.of(context).txt_nothing_to_show}",
        //                   style: Theme.of(context).primaryTextTheme.bodyText1,
        //                 ),
        //               )
        //         : _productShimmer(),
        //   ),
        // ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  List<Widget> _subCategoryListWidget() {
    List<Widget> productList = [];

    for (int i = 0; i < _subCategoryList[0].products.length; i++) {
      // if (j <= countLimit) {
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
                                  placeholder: (context, url) => const Center(
                                      child: CircularProgressIndicator()),
                                  errorWidget: (context, url, error) =>
                                      Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      image: DecorationImage(
                                        image: AssetImage(global.defaultImage),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
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
                                  placeholder: (context, url) => const Center(
                                      child: CircularProgressIndicator()),
                                  errorWidget: (context, url, error) =>
                                      Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      image: DecorationImage(
                                          image:
                                              AssetImage(global.defaultImage),
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
                                      style: const TextStyle(
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
                                                                      const TextStyle(
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
                                                        const Center(
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
                                                                global
                                                                    .defaultImage),
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

      // }
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

  _getData() async {
    try {
      if (screenId == 1 && subcategoryId != null) {
        // await _getSubcategoryProduct();
      } else if (screenId == 2) {
        //  await _getTopSellingProduct();
      } else if (screenId == 3) {
        //  await _getSpotLightProduct();
      } else if (screenId == 4) {
        // await _getRecentSellingProduct();
      } else if (screenId == 5) {
        // await _getWhatsNewProduct();
      } else if (screenId == 6) {
        // await _getDealProduct();
      } else if (screenId == 7) {
        _productFilter.keyword = title;
        // Search product
        await _getSearchedProduct();
      } else if (screenId == 8) {
        _productFilter.keyword = title;
        // tag product
        // await _getTagProduct();
      }
      // _productFilter.maxPriceValue =
      //     _subCategoryList.length > 0 ? _subCategoryList[0].maxPrice : 0;
    } catch (e) {
      print("Exception - productListScreen.dart - _init():$e");
    }
  }

  // _getTopSellingProduct() async {
  //   try {
  //     if (_isRecordPending) {
  //       setState(() {
  //         _isMoreDataLoaded = true;
  //       });
  //       if (_subCategoryList.isEmpty) {
  //         page = 1;
  //       } else {
  //         page++;
  //       }
  //       await apiHelper
  //           .topSellingProduct(page, _productFilter)
  //           .then((result) async {
  //         if (result != null) {
  //           if (result.status == "1") {
  //             List<Product> _tList = result.data;
  //             if (_tList.isEmpty) {
  //               _isRecordPending = false;
  //             }
  //             _subCategoryList.addAll(_tList);
  //             setState(() {
  //               _isMoreDataLoaded = false;
  //             });
  //           }
  //         }
  //       });
  //     }
  //   } catch (e) {
  //     print("Exception - productListScreen.dart - _getTopSellingProduct():" +
  //         e.toString());
  //   }
  // }

  // _getRecentSellingProduct() async {
  //   try {
  //     if (_isRecordPending) {
  //       setState(() {
  //         _isMoreDataLoaded = true;
  //       });
  //       if (_subCategoryList.isEmpty) {
  //         page = 1;
  //       } else {
  //         page++;
  //       }
  //       await apiHelper
  //           .recentSellingProduct(page, _productFilter)
  //           .then((result) async {
  //         if (result != null) {
  //           if (result.status == "1") {
  //             List<Product> _tList = result.data;
  //             if (_tList.isEmpty) {
  //               _isRecordPending = false;
  //             }
  //             _subCategoryList.addAll(_tList);
  //             setState(() {
  //               _isMoreDataLoaded = false;
  //             });
  //           }
  //         }
  //       });
  //     }
  //   } catch (e) {
  //     print("Exception - productListScreen.dart - _getRecentSellingProduct():" +
  //         e.toString());
  //   }
  // }

  // _getWhatsNewProduct() async {
  //   try {
  //     if (_isRecordPending) {
  //       setState(() {
  //         _isMoreDataLoaded = true;
  //       });
  //       if (_subCategoryList.isEmpty) {
  //         page = 1;
  //       } else {
  //         page++;
  //       }
  //       await apiHelper
  //           .whatsnewProduct(page, _productFilter)
  //           .then((result) async {
  //         if (result != null) {
  //           if (result.status == "1") {
  //             List<Product> _tList = result.data;
  //             if (_tList.isEmpty) {
  //               _isRecordPending = false;
  //             }
  //             _subCategoryList.addAll(_tList);
  //             setState(() {
  //               _isMoreDataLoaded = false;
  //             });
  //           }
  //         }
  //       });
  //     }
  //   } catch (e) {
  //     print("Exception - productListScreen.dart - _getWhatsNewProduct():" +
  //         e.toString());
  //   }
  // }

  // _getDealProduct() async {
  //   try {
  //     if (_isRecordPending) {
  //       setState(() {
  //         _isMoreDataLoaded = true;
  //       });
  //       if (_subCategoryList.isEmpty) {
  //         page = 1;
  //       } else {
  //         page++;
  //       }
  //       await apiHelper.dealProduct(page, _productFilter).then((result) async {
  //         if (result != null) {
  //           if (result.status == "1") {
  //             List<Product> _tList = result.data;
  //             if (_tList.isEmpty) {
  //               _isRecordPending = false;
  //             }
  //             _subCategoryList.addAll(_tList);
  //             setState(() {
  //               _isMoreDataLoaded = false;
  //             });
  //           }
  //         }
  //       });
  //     }
  //   } catch (e) {
  //     print("Exception - productListScreen.dart - _getDealProduct():" +
  //         e.toString());
  //   }
  // }

  _getSearchedProduct() async {
    try {
      if (_isRecordPending) {
        setState(() {
          _isMoreDataLoaded = true;
        });
        if (_subCategoryList.isEmpty) {
          page = 1;
        } else {
          page++;
        }
        await apiHelper
            .getproductSearchResult(page, _productFilter)
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
            }
          }
        });
      }
    } catch (e) {
      print("Exception - productListScreen.dart - _getDealProduct():$e");
    }
  }

  // _getTagProduct() async {
  //   try {
  //     if (_isRecordPending) {
  //       setState(() {
  //         _isMoreDataLoaded = true;
  //       });
  //       if (_subCategoryList.isEmpty) {
  //         page = 1;
  //       } else {
  //         page++;
  //       }
  //       await apiHelper
  //           .getTagProduct(page, _productFilter)
  //           .then((result) async {
  //         if (result != null) {
  //           if (result.status == "1") {
  //             List<Product> _tList = result.data;
  //             if (_tList.isEmpty) {
  //               _isRecordPending = false;
  //             }
  //             _subCategoryList.addAll(_tList);
  //             setState(() {
  //               _isMoreDataLoaded = false;
  //             });
  //           }
  //         }
  //       });
  //     }
  //   } catch (e) {
  //     print("Exception - productListScreen.dart - _getTagProduct():" +
  //         e.toString());
  //   }
  // }

  // _getSpotLightProduct() async {
  //   try {
  //     if (_isRecordPending) {
  //       setState(() {
  //         _isMoreDataLoaded = true;
  //       });
  //       if (_subCategoryList.isEmpty) {
  //         page = 1;
  //       } else {
  //         page++;
  //       }
  //       await apiHelper
  //           .spotLightProduct(page, _productFilter)
  //           .then((result) async {
  //         if (result != null) {
  //           if (result.status == "1") {
  //             List<Product> _tList = result.data;
  //             if (_tList.isEmpty) {
  //               _isRecordPending = false;
  //             }
  //             _subCategoryList.addAll(_tList);
  //             setState(() {
  //               _isMoreDataLoaded = false;
  //             });
  //           }
  //         }
  //       });
  //     }
  //   } catch (e) {
  //     print("Exception - productListScreen.dart - _getSpotLightProduct():" +
  //         e.toString());
  //   }
  // }

  // _getSubcategoryProduct() async {
  //   try {
  //     if (_isRecordPending) {
  //       setState(() {
  //         _isMoreDataLoaded = true;
  //       });
  //       if (_subCategoryList.isEmpty) {
  //         page = 1;
  //       } else {
  //         page++;
  //       }
  //       await apiHelper
  //           .getSubcategoryProduct(subcategoryId, page, _productFilter)
  //           .then((result) async {
  //         if (result != null) {
  //           if (result.status == "1") {
  //             List<Product> _tList = result.data;
  //             if (_tList.isEmpty) {
  //               _isRecordPending = false;
  //             }
  //             _subCategoryList.addAll(_tList);
  //             setState(() {
  //               _isMoreDataLoaded = false;
  //             });
  //           }
  //         }
  //       });
  //     }
  //   } catch (e) {
  //     print("Exception - productListScreen.dart - _getSubcategoryProduct():" +
  //         e.toString());
  //   }
  // }

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
      print("Exception - categoryListScreen.dart - _init():$e");
    }
  }

  Widget _productShimmer() {
    try {
      return ListView.builder(
        itemCount: 10,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(top: 10, bottom: 10),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300],
              highlightColor: Colors.grey[100],
              child: Column(
                children: [
                  SizedBox(
                    height: 110,
                    width: MediaQuery.of(context).size.width,
                    child: const Card(),
                  ),
                ],
              ),
            ),
          );
        },
      );
    } catch (e) {
      print("Exception - wishlistScreen.dart - _productShimmer():$e");
      return const SizedBox();
    }
  }
}
