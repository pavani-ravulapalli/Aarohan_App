import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:outline_gradient_button/outline_gradient_button.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:aarohan_app/models/event.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../widgets/bottomMenu.dart';

class Dashboard extends StatefulWidget {
  final bool isIntroDone = false;

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with TickerProviderStateMixin {
  bool isLoading = false;
  String selectedcategory = "All";
  List<String> tags = [
    "Logic",
    "Strategy",
    "Mystery",
    "Innovation",
    "Treasure-Hunt",
    "Coding",
    "Sports",
    "Robotics",
    "Workshops",
    "Business"
  ];

  int x = 0;
  int selectedIndex = -1;
  CarouselSliderController buttonCarouselController =
      CarouselSliderController();

  List<EventItem> arr = [];
  List<EventItem>? _foundUsers = [];
  String day = "";
  // GlobalKey<ScaffoldState> _scaffold = GlobalKey<ScaffoldState>();
  bool showBottomMenu = false;
  bool search = false;
  List<EventItem>? eventItems;

  bool visibleBottomMenu = false;

  void _runFilter(String enteredKeyword, List<EventItem> M, int index) {
    List<EventItem> results = [];
    List<EventItem> result = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      if (index != -1) {
        results = eventItems!
            .where((element) => (element.tag!.contains(tags[index])))
            .toList();
      } else {
        results = M;

        // we use the toLowerCase() method to make it case-insensitive
      }
    } else {
      if (index != -1) {
        result = eventItems!
            .where((element) => (element.tag!.contains(tags[index])))
            .toList();
        results = result
            .where((user) => user.title!
                .toLowerCase()
                .contains(enteredKeyword.toLowerCase()))
            .toList();
      } else {
        results = M
            .where((user) => user.title!
                .toLowerCase()
                .contains(enteredKeyword.toLowerCase()))
            .toList();
        // we use the toLowerCase() method to make it case-insensitive
      }
    }

    // Refresh the UI
    setState(() {
      _foundUsers = results;
    });
  }

  @override
  void initState() {
    // at the beginning, all users are shown

    _foundUsers = eventItems;
    super.initState();
  }

  Widget build(BuildContext context) {
    eventItems = Provider.of<List<EventItem>>(context);

    setState(() {
      if (x == 0 && eventItems!.length != 0) {
        arr = eventItems!;
        x++;
      }
    });

    
    /*return Sizer(builder: (context, orientation, deviceType) {
      return SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.transparent,
          body: Stack(children: [
            // 1. Background image container placed as the first child of the Stack
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/dashbg.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            
            // 2. Scrollable content on top of the background
            SingleChildScrollView(
              child: Column(
                children: [
                  Visibility(
                    visible: search,
                    child: Container(
                      margin: EdgeInsets.symmetric(
                          vertical: 2.h, horizontal: 2.w),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          Color.fromRGBO(2, 84, 114, 0.88),
                          Color.fromRGBO(29, 95, 117, 0.865),
                        ]),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding:
                            EdgeInsets.fromLTRB(1.5.w, 1.5.h, 1.5.w, 1.5.h),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 3.w,
                                ),
                                Container(
                                  width: 70.w,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Color.fromRGBO(
                                              255, 255, 255, 0.318),
                                          width: 0.5.w),
                                      borderRadius:
                                          BorderRadius.circular(10.sp)),
                                  child: Padding(
                                    padding: EdgeInsets.all(1.sp),
                                    child: TextField(
                                      onTap: () {
                                        setState(() {
                                          print(selectedIndex);
                                        });
                                      },
                                      style: TextStyle(
                                        fontFamily: 'Mons',
                                        fontSize: 13.sp,
                                        color: Colors.white,
                                        letterSpacing: 1,
                                      ),
                                      onChanged: (value) {
                                        _runFilter(value, eventItems!,
                                            selectedIndex);
                                      },
                                      decoration: InputDecoration(
                                          contentPadding:
                                              EdgeInsets.all(10.sp),
                                          border: InputBorder.none,
                                          hintText: 'Search',
                                          hintStyle: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'Mons',
                                              fontSize: 15.sp,
                                              fontWeight: FontWeight.w500),
                                          labelStyle: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'Mons',
                                              fontSize: 15.sp,
                                              fontWeight: FontWeight.w500)),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(5.w, 0, 0, 0),
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        search = !search;
                                      });
                                    },
                                    child: Column(
                                      children: [
                                        Icon(
                                          Icons.cancel,
                                          size: 25.sp,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 1.5.h,
                            ),
                            Container(
                              height: 4.h,
                              child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: tags.length,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    radius: 7.sp,
                                    borderRadius: BorderRadius.circular(7.sp),
                                    onTap: () {
                                      if (selectedIndex == index) {
                                        setState(() {
                                          selectedIndex = -1;
                                          _foundUsers = eventItems;
                                        });
                                      } else {
                                        setState(() {
                                          selectedIndex = index;
                                          _foundUsers = eventItems!
                                              .where((element) => (element
                                                  .tag!
                                                  .contains(tags[index])))
                                              .toList();
                                        });
                                      }
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: (selectedIndex == index)
                                              ? Color.fromRGBO(
                                                  51, 130, 154, 0.75)
                                              : const Color.fromARGB(
                                                  0, 0, 0, 0),
                                          borderRadius:
                                              BorderRadius.circular(7.sp)),
                                      alignment: Alignment.center,
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 1.w),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 2.w),
                                      child: Text(
                                        '${tags[index]}',
                                        style: TextStyle(
                                            color: Color.fromRGBO(
                                                255, 255, 255, 1),
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: !search,
                    child: Container(
                      margin: EdgeInsets.symmetric(
                        vertical: 2.h,
                        horizontal: 2.5.w,
                      ),
                      child: OutlineGradientButton(
                        strokeWidth: 3,
                        radius: Radius.circular(17),
                        gradient: LinearGradient(
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight,
                          colors: [
                            Colors.white,
                            Colors.white38,
                            Colors.grey.shade800,
                            const Color.fromARGB(110, 175, 175, 175),
                          ],
                        ),
                        padding: EdgeInsets.all(0),
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 0.85.w, vertical: 0.8.w),
                          alignment: Alignment.bottomCenter,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15)),
                            gradient: LinearGradient(
                              colors: [
                                Color.fromRGBO(16, 59, 73, 0.76),
                                Color.fromRGBO(78, 178, 208, 0.767),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          height: 8.h,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4.w),
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                CircleAvatar(
                                  radius: 23,
                                  backgroundImage:
                                      AssetImage('assets/aarohan_logo.png'),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(vertical: 0.1),
                                  child: Center(
                                    child: Image.asset(
                                      'assets/aarohan_text.png',
                                      height: 7.h,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      _foundUsers = eventItems!;
                                      search = !search;
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                            0, 97, 97, 97),
                                        border: Border.all(
                                            color: Color.fromRGBO(
                                                155, 204, 239, 1),
                                            width: 0.1.w),
                                        borderRadius:
                                            BorderRadius.circular(2.w)),
                                    child: Padding(
                                      padding: EdgeInsets.only(top: 0.5.h),
                                      child: Image.asset('assets/search.png'),
                                    ),
                                    height: 5.h,
                                    width: 11.w,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: !search,
                    child: Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: 2.w, vertical: 1.h),
                      height: 7.5.h,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color.fromRGBO(16, 59, 73, 0.47),
                            Color.fromRGBO(78, 177, 208, 0.38),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: OutlineGradientButton(
                        strokeWidth: 2,
                        radius: Radius.circular(15),
                        gradient: LinearGradient(
                          colors: [
                            const Color.fromARGB(109, 143, 142, 142),
                            const Color.fromARGB(122, 92, 90, 90),
                            Colors.white38,
                            Colors.white,
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 2.w, vertical: 0.1.h),
                              decoration: BoxDecoration(
                                color: (selectedcategory == "All")
                                    ? Color.fromRGBO(255, 255, 255, 0.288)
                                    : const Color.fromARGB(0, 255, 255, 255),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: InkWell(
                                radius: 20,
                                borderRadius: BorderRadius.circular(20.0),
                                onTap: () {
                                  setState(() {
                                    arr = eventItems!;
                                    selectedcategory = "All";
                                    day = "0";
                                  });
                                },
                                child: Container(
                                  height: 8.h,
                                  width: 13.w,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "ALL",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'LemonMilk',
                                            fontSize: 3.w,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      SizedBox(height: 3),
                                      Visibility(
                                        visible: (selectedcategory == "All"),
                                        child: Container(
                                          height: 5,
                                          width: 5,
                                          decoration: BoxDecoration(
                                            color: Color.fromRGBO(
                                                142, 210, 255, 1),
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 2.w, vertical: 0.1.h),
                              decoration: BoxDecoration(
                                  color: (selectedcategory == "Workshop")
                                      ? Color.fromRGBO(255, 255, 255, 0.288)
                                      : const Color.fromARGB(0, 0, 0, 0),
                                  borderRadius: BorderRadius.circular(20.0)),
                              child: InkWell(
                                radius: 20,
                                borderRadius: BorderRadius.circular(20.0),
                                onTap: () {
                                  setState(() {
                                    arr = eventItems!
                                        .where((element) =>
                                            element.category == "Workshop")
                                        .toList();
                                    selectedcategory = "Workshop";
                                    day = "0";
                                  });
                                },
                                child: Container(
                                  height: 8.h,
                                  width: 28.w,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "WORKSHOPS",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'LemonMilk',
                                            fontSize: 2.8.w,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      SizedBox(height: 3.5),
                                      Visibility(
                                        visible:
                                            (selectedcategory == "Workshop"),
                                        child: Container(
                                          height: 8,
                                          width: 5,
                                          decoration: BoxDecoration(
                                              color: Color.fromRGBO(
                                                  142, 210, 255, 1),
                                              shape: BoxShape.circle),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 2.w, vertical: 0.5.h),
                              decoration: BoxDecoration(
                                  color: (selectedcategory == "Event")
                                      ? Color.fromRGBO(255, 255, 255, 0.288)
                                      : const Color.fromARGB(0, 0, 0, 0),
                                  borderRadius: BorderRadius.circular(20.0)),
                              child: InkWell(
                                radius: 20,
                                borderRadius: BorderRadius.circular(20.0),
                                onTap: () {
                                  setState(() {
                                    arr = eventItems!
                                        .where((element) =>
                                            element.category == "Event")
                                        .toList();
                                    selectedcategory = "Event";
                                    day = "0";
                                  });
                                },
                                child: Container(
                                  height: 8.h,
                                  width: 18.w,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "EVENTS",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'LemonMilk',
                                            fontSize: 3.w,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      SizedBox(height: 3.5),
                                      Visibility(
                                        visible:
                                            (selectedcategory == "Event"),
                                        child: Container(
                                          height: 5,
                                          width: 5,
                                          decoration: BoxDecoration(
                                              color: Color.fromRGBO(
                                                  142, 210, 255, 1),
                                              shape: BoxShape.circle),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 2.w, vertical: 0.5.h),
                              decoration: BoxDecoration(
                                  color: (selectedcategory == "Talk")
                                      ? Color.fromRGBO(255, 255, 255, 0.288)
                                      : const Color.fromARGB(0, 0, 0, 0),
                                  borderRadius: BorderRadius.circular(20.0)),
                              child: InkWell(
                                radius: 20,
                                borderRadius: BorderRadius.circular(20.0),
                                onTap: () {
                                  setState(() {
                                    arr = eventItems!
                                        .where((element) =>
                                            element.category == "Talk")
                                        .toList();
                                    selectedcategory = "Talk";
                                    day = "0";
                                  });
                                },
                                child: Container(
                                  height: 8.h,
                                  width: 15.w,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "TALKS",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'LemonMilk',
                                            fontSize: 3.w,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      SizedBox(height: 3.5),
                                      Visibility(
                                        visible: (selectedcategory == "Talk"),
                                        child: Container(
                                          height: 5,
                                          width: 5,
                                          decoration: BoxDecoration(
                                              color: Color.fromRGBO(
                                                  142, 210, 255, 1),
                                              shape: BoxShape.circle),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: !search,
                    child: Container(
                        margin: EdgeInsets.only(top: 1.h),
                        height: 46.h,
                        child: (arr.length != 0)
                            ? CarouselSlider.builder(
                                itemCount: arr.length,
                                options: CarouselOptions(
                                  height: 54.h,
                                  aspectRatio: 1.15,
                                  viewportFraction: 0.72,
                                  initialPage: 0,
                                  enableInfiniteScroll: true,
                                  reverse: false,
                                  autoPlay: true,
                                  autoPlayInterval: Duration(seconds: 3),
                                  autoPlayAnimationDuration:
                                      Duration(milliseconds: 800),
                                  autoPlayCurve:
                                      Curves.fastLinearToSlowEaseIn,
                                  enlargeCenterPage: true,
                                  scrollDirection: Axis.horizontal,
                                ),
                                carouselController: buttonCarouselController,
                                itemBuilder: (BuildContext context, int index,
                                        int pageViewIndex) =>
                                    Column(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            Navigator.pushNamed(
                                                context, '/eventpage',
                                                arguments: {
                                                  'eventItem': arr[index]
                                                });
                                          },
                                          child: Container(
                                            height: 39.h,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      10.sp),
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      10.sp),
                                              child: Transform.scale(
                                                scale: 1.015,
                                                child: CachedNetworkImage(
                                                  fit: BoxFit.cover,
                                                  errorWidget:
                                                      (context, url, error) {
                                                    return ClipRRect(
                                                      borderRadius:
                                                          BorderRadius
                                                              .circular(
                                                                  10.sp),
                                                      child: Image.asset(
                                                          "assets/placeholder.jpg",
                                                          height: 40.h,
                                                          fit: BoxFit.cover),
                                                    );
                                                  },
                                                  placeholder:
                                                      (context, url) =>
                                                          ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.sp),
                                                    child: Image.asset(
                                                        "assets/placeholder.jpg",
                                                        height: 40.h,
                                                        fit: BoxFit.cover),
                                                  ),
                                                  imageUrl:
                                                      arr[index].imageUrl!,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 1.h,
                                        ),
                                        Text(
                                          textAlign: TextAlign.center,
                                          "${arr[index].title}",
                                          style: TextStyle(
                                              fontFamily: 'Gugi',
                                              color: Colors.white,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 12.sp,
                                              letterSpacing: 1.2),
                                        )
                                      ],
                                    ))
                            : Center(
                                child:
                                    LoadingAnimationWidget.staggeredDotsWave(
                                  color: Colors.white,
                                  size: 40,
                                ),
                              )),
                  ),
                  Visibility(
                    visible: search,
                    child: Container(
                      height: 76.h,
                      child: (_foundUsers != null && _foundUsers!.isNotEmpty)
                          ? ListView.builder(
                              padding: EdgeInsets.only(bottom: 5),
                              itemCount: _foundUsers!.length,
                              itemBuilder: (context, index) => Container(
                                height: 10.h,
                                padding:
                                    EdgeInsets.fromLTRB(3.w, 1.h, 3.w, 1.h),
                                child: InkWell(
                                  onTap: () {
                                    FocusManager.instance.primaryFocus!
                                        .unfocus();
                                    Navigator.pushNamed(context, '/eventpage',
                                        arguments: {
                                          'eventItem': _foundUsers![index]
                                        });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(10.sp),
                                      gradient: LinearGradient(colors: [
                                        Color.fromRGBO(2, 84, 114, 0.48),
                                        Color.fromRGBO(29, 95, 117, 0.465),
                                      ]),
                                    ),
                                    child: OutlineGradientButton(
                                      padding: EdgeInsets.all(0),
                                      strokeWidth: 2,
                                      radius: Radius.circular(10),
                                      gradient: LinearGradient(
                                        begin: Alignment.bottomLeft,
                                        end: Alignment.topRight,
                                        colors: [
                                          Colors.transparent,
                                          Colors.grey.shade600,
                                          Colors.white38,
                                          Colors.white,
                                        ],
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                  bottomLeft:
                                                      Radius.circular(10.sp),
                                                  topLeft:
                                                      Radius.circular(10.sp)),
                                            ),
                                            child: SizedBox(
                                              width: 23.w,
                                              height: 23.w,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.only(
                                                  bottomLeft:
                                                      Radius.circular(10.sp),
                                                  topLeft:
                                                      Radius.circular(10.sp),
                                                ),
                                                child: FittedBox(
                                                  fit: BoxFit.cover,
                                                  child: SizedBox(
                                                    width: 23.w,
                                                    height: 23.w,
                                                    child: Transform.scale(
                                                      scale: 1.01,
                                                      child:
                                                          CachedNetworkImage(
                                                        imageUrl:
                                                            _foundUsers![
                                                                    index]
                                                                .imageUrl!,
                                                        fit: BoxFit.cover,
                                                        errorWidget: (context,
                                                            url, error) {
                                                          return Image.asset(
                                                            "assets/placeholder.jpg",
                                                            width: 23.w,
                                                            height: 23.w,
                                                            fit: BoxFit.cover,
                                                          );
                                                        },
                                                        placeholder:
                                                            (context, url) =>
                                                                Image.asset(
                                                          "assets/placeholder.jpg",
                                                          width: 23.w,
                                                          height: 23.w,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              child: Center(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(
                                                          2.0),
                                                  child: Text(
                                                    _foundUsers![index]
                                                        .title
                                                        .toString(),
                                                    overflow:
                                                        TextOverflow.clip,
                                                    textAlign:
                                                        TextAlign.center,
                                                    style: TextStyle(
                                                        color: const Color
                                                            .fromARGB(255,
                                                            255, 255, 255),
                                                        fontFamily: 'Mons',
                                                        letterSpacing: 1.1,
                                                        fontSize: 13.sp,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : Padding(
                              padding:
                                  EdgeInsets.fromLTRB(4.w, 1.h, 4.w, 1.h),
                              child: Container(
                                height: 8.h,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.white, width: 0.2.w),
                                  borderRadius: BorderRadius.circular(15.sp),
                                ),
                                child: Center(
                                  child: Text(
                                    'No results found',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Mons',
                                        letterSpacing: 1.1,
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ),
                            ),
                    ),
                  ),
                  Visibility(
                      visible: !search,
                      child: Container(
                        margin: EdgeInsets.only(bottom: 1.5.h),
                        child: Text(
                          "Fest Dates",
                          style: TextStyle(
                              color: Colors.white,
                              letterSpacing: 3,
                              fontFamily: 'AllertaStencil',
                              fontSize: 27.sp,
                              fontWeight: FontWeight.w500),
                        ),
                      )),
                  Visibility(
                    visible: !search,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          radius: 5.sp,
                          onTap: () {
                            setState(() {
                              day = "1st";
                              selectedcategory = "";
                              arr = eventItems!
                                  .where((element) =>
                                      (DateTime.parse(element.date!).day ==
                                          17))
                                  .toList();
                            });
                          },
                          child: Container(
                            width: 15.w,
                            height: 9.h,
                            decoration: BoxDecoration(
                                color: (day == "1st")
                                    ? Color.fromRGBO(51, 130, 154, 0.85)
                                    : Color.fromRGBO(0, 94, 126, 0.925),
                                borderRadius: BorderRadius.circular(5.sp)),
                            child: OutlineGradientButton(
                              strokeWidth: 2,
                              radius: Radius.circular(5.sp),
                              gradient: (day == "1st")
                                  ? LinearGradient(
                                      colors: [
                                        const Color.fromARGB(
                                            109, 143, 142, 142),
                                        const Color.fromARGB(122, 92, 90, 90),
                                        Colors.white38,
                                        Colors.white,
                                      ],
                                    )
                                  : LinearGradient(colors: [
                                      Colors.transparent,
                                      Colors.transparent
                                    ]),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("17",
                                      style: TextStyle(
                                          fontFamily: 'Mons',
                                          fontSize: 15.sp,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500)),
                                  Text("Fri",
                                      style: TextStyle(
                                          fontFamily: 'Mons',
                                          fontSize: 12.sp,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500)),
                                ],
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          radius: 5.sp,
                          onTap: () {
                            setState(() {
                              day = "2nd";
                              selectedcategory = "";
                              arr = eventItems!
                                  .where((element) =>
                                      (DateTime.parse(element.date!).day ==
                                          18))
                                  .toList();
                            });
                          },
                          child: Container(
                            width: 15.w,
                            height: 9.h,
                            decoration: BoxDecoration(
                                color: (day == "2nd")
                                    ? Color.fromRGBO(51, 130, 154, 0.85)
                                    : Color.fromRGBO(0, 94, 126, 0.925),
                                borderRadius: BorderRadius.circular(5.sp)),
                            child: OutlineGradientButton(
                              strokeWidth: 2,
                              radius: Radius.circular(5.sp),
                              gradient: (day == "2nd")
                                  ? LinearGradient(
                                      colors: [
                                        const Color.fromARGB(
                                            109, 143, 142, 142),
                                        const Color.fromARGB(122, 92, 90, 90),
                                        Colors.white38,
                                        Colors.white,
                                      ],
                                    )
                                  : LinearGradient(colors: [
                                      Colors.transparent,
                                      Colors.transparent
                                    ]),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("18",
                                      style: TextStyle(
                                          fontFamily: 'Mons',
                                          fontSize: 15.sp,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500)),
                                  Text("Sat",
                                      style: TextStyle(
                                          fontFamily: 'Mons',
                                          fontSize: 12.sp,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500)),
                                ],
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          radius: 5.sp,
                          onTap: () {
                            setState(() {
                              day = "3rd";
                              selectedcategory = "";
                              arr = eventItems!
                                  .where((element) =>
                                      (DateTime.parse(element.date!).day ==
                                          19))
                                  .toList();
                            });
                          },
                          child: Container(
                            width: 15.w,
                            height: 9.h,
                            decoration: BoxDecoration(
                                color: (day == "3rd")
                                    ? Color.fromRGBO(51, 130, 154, 0.85)
                                    : Color.fromRGBO(0, 94, 126, 0.925),
                                borderRadius: BorderRadius.circular(5.sp)),
                            child: OutlineGradientButton(
                              strokeWidth: 2,
                              radius: Radius.circular(5.sp),
                              gradient: (day == "3rd")
                                  ? LinearGradient(
                                      colors: [
                                        const Color.fromARGB(
                                            109, 143, 142, 142),
                                        const Color.fromARGB(122, 92, 90, 90),
                                        Colors.white38,
                                        Colors.white,
                                      ],
                                    )
                                  : LinearGradient(colors: [
                                      Colors.transparent,
                                      Colors.transparent
                                    ]),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("19",
                                      style: TextStyle(
                                          fontFamily: 'Mons',
                                          fontSize: 15.sp,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500)),
                                  Text(
                                    "Sun",
                                    style: TextStyle(
                                        fontFamily: 'Mons',
                                        fontSize: 12.sp,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8.h),
                ],
              ),
            ),
            
            // 3. Bottom menu overlay
            Visibility(visible: !search, child: BottomMenu())
          ]),
        ),
      );
    });
  }
}*/
return Sizer(builder: (context, orientation, deviceType) {
      return SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.transparent,
          body: Stack(children: [
            // 1. Background image container placed as the first child of the Stack
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/dashbg.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            
            // 2. Scrollable content on top of the background
            SingleChildScrollView(
              child: Column(
                children: [
                  Visibility(
                    visible: search,
                    child: Container(
                      margin: EdgeInsets.symmetric(
                          vertical: 2.h, horizontal: 2.w),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          Color.fromRGBO(114, 2, 2, 0.88),
                          Color.fromRGBO(117, 29, 29, 0.865),
                        ]),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding:
                            EdgeInsets.fromLTRB(1.5.w, 1.5.h, 1.5.w, 1.5.h),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 3.w,
                                ),
                                Container(
                                  width: 70.w,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Color.fromRGBO(
                                              255, 255, 255, 0.318),
                                          width: 0.5.w),
                                      borderRadius:
                                          BorderRadius.circular(10.sp)),
                                  child: Padding(
                                    padding: EdgeInsets.all(1.sp),
                                    child: TextField(
                                      onTap: () {
                                        setState(() {
                                          print(selectedIndex);
                                        });
                                      },
                                      style: TextStyle(
                                        fontFamily: 'Mons',
                                        fontSize: 13.sp,
                                        color: Colors.white,
                                        letterSpacing: 1,
                                      ),
                                      onChanged: (value) {
                                        _runFilter(value, eventItems!,
                                            selectedIndex);
                                      },
                                      decoration: InputDecoration(
                                          contentPadding:
                                              EdgeInsets.all(10.sp),
                                          border: InputBorder.none,
                                          hintText: 'Search',
                                          hintStyle: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'Mons',
                                              fontSize: 15.sp,
                                              fontWeight: FontWeight.w500),
                                          labelStyle: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'Mons',
                                              fontSize: 15.sp,
                                              fontWeight: FontWeight.w500)),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(5.w, 0, 0, 0),
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        search = !search;
                                      });
                                    },
                                    child: Column(
                                      children: [
                                        Icon(
                                          Icons.cancel,
                                          size: 25.sp,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 1.5.h,
                            ),
                            Container(
                              height: 4.h,
                              child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: tags.length,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    radius: 7.sp,
                                    borderRadius: BorderRadius.circular(7.sp),
                                    onTap: () {
                                      if (selectedIndex == index) {
                                        setState(() {
                                          selectedIndex = -1;
                                          _foundUsers = eventItems;
                                        });
                                      } else {
                                        setState(() {
                                          selectedIndex = index;
                                          _foundUsers = eventItems!
                                              .where((element) => (element
                                                  .tag!
                                                  .contains(tags[index])))
                                              .toList();
                                        });
                                      }
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: (selectedIndex == index)
                                              ? Color.fromRGBO(
                                                  154, 51, 51, 0.75)
                                              : const Color.fromARGB(
                                                  0, 0, 0, 0),
                                          borderRadius:
                                              BorderRadius.circular(7.sp)),
                                      alignment: Alignment.center,
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 1.w),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 2.w),
                                      child: Text(
                                        '${tags[index]}',
                                        style: TextStyle(
                                            color: Color.fromRGBO(
                                                255, 255, 255, 1),
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: !search,
                    child: Container(
                      margin: EdgeInsets.symmetric(
                        vertical: 2.h,
                        horizontal: 2.5.w,
                      ),
                      child: OutlineGradientButton(
                        strokeWidth: 3,
                        radius: Radius.circular(17),
                        gradient: LinearGradient(
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight,
                          colors: [
                            Colors.white,
                            Colors.white38,
                            Colors.grey.shade800,
                            const Color.fromARGB(110, 175, 175, 175),
                          ],
                        ),
                        padding: EdgeInsets.all(0),
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 0.85.w, vertical: 0.8.w),
                          alignment: Alignment.bottomCenter,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15)),
                            gradient: LinearGradient(
                              colors: [
                                Color.fromRGBO(73, 16, 16, 0.76),
                                Color.fromRGBO(208, 78, 78, 0.767),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          height: 8.h,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4.w),
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                CircleAvatar(
                                  radius: 23,
                                  backgroundColor: Colors.transparent,
                                  backgroundImage:
                                      AssetImage('assets/aarohan_logo.png'),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(vertical: 0.1),
                                  child: Center(
                                    child: Image.asset(
                                      'assets/aarohan_text.png',
                                      height: 7.h,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      _foundUsers = eventItems!;
                                      search = !search;
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                            0, 97, 97, 97),
                                        border: Border.all(
                                            color: Color.fromRGBO(
                                                239, 155, 155, 1),
                                            width: 0.1.w),
                                        borderRadius:
                                            BorderRadius.circular(2.w)),
                                    child: Padding(
                                      padding: EdgeInsets.only(top: 0.5.h),
                                      child: Image.asset('assets/search.png'),
                                    ),
                                    height: 5.h,
                                    width: 11.w,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: !search,
                    child: Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: 2.w, vertical: 1.h),
                      height: 7.5.h,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color.fromRGBO(73, 16, 16, 0.47),
                            Color.fromRGBO(208, 77, 77, 0.38),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: OutlineGradientButton(
                        strokeWidth: 2,
                        radius: Radius.circular(15),
                        gradient: LinearGradient(
                          colors: [
                            const Color.fromARGB(109, 143, 142, 142),
                            const Color.fromARGB(122, 92, 90, 90),
                            Colors.white38,
                            Colors.white,
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 2.w, vertical: 0.1.h),
                              decoration: BoxDecoration(
                                color: (selectedcategory == "All")
                                    ? Color.fromRGBO(255, 255, 255, 0.288)
                                    : const Color.fromARGB(0, 255, 255, 255),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: InkWell(
                                radius: 20,
                                borderRadius: BorderRadius.circular(20.0),
                                onTap: () {
                                  setState(() {
                                    arr = eventItems!;
                                    selectedcategory = "All";
                                    day = "0";
                                  });
                                },
                                child: Container(
                                  height: 8.h,
                                  width: 13.w,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "ALL",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'LemonMilk',
                                            fontSize: 3.w,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      SizedBox(height: 3),
                                      Visibility(
                                        visible: (selectedcategory == "All"),
                                        child: Container(
                                          height: 5,
                                          width: 5,
                                          decoration: BoxDecoration(
                                            color: Color.fromRGBO(
                                                255, 142, 142, 1),
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 2.w, vertical: 0.1.h),
                              decoration: BoxDecoration(
                                  color: (selectedcategory == "Workshop")
                                      ? Color.fromRGBO(255, 255, 255, 0.288)
                                      : const Color.fromARGB(0, 0, 0, 0),
                                  borderRadius: BorderRadius.circular(20.0)),
                              child: InkWell(
                                radius: 20,
                                borderRadius: BorderRadius.circular(20.0),
                                onTap: () {
                                  setState(() {
                                    arr = eventItems!
                                        .where((element) =>
                                            element.category == "Workshop")
                                        .toList();
                                    selectedcategory = "Workshop";
                                    day = "0";
                                  });
                                },
                                child: Container(
                                  height: 8.h,
                                  width: 28.w,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "WORKSHOPS",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'LemonMilk',
                                            fontSize: 2.8.w,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      SizedBox(height: 3.5),
                                      Visibility(
                                        visible:
                                            (selectedcategory == "Workshop"),
                                        child: Container(
                                          height: 8,
                                          width: 5,
                                          decoration: BoxDecoration(
                                              color: Color.fromRGBO(
                                                  255, 142, 142, 1),
                                              shape: BoxShape.circle),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 2.w, vertical: 0.5.h),
                              decoration: BoxDecoration(
                                  color: (selectedcategory == "Event")
                                      ? Color.fromRGBO(255, 255, 255, 0.288)
                                      : const Color.fromARGB(0, 0, 0, 0),
                                  borderRadius: BorderRadius.circular(20.0)),
                              child: InkWell(
                                radius: 20,
                                borderRadius: BorderRadius.circular(20.0),
                                onTap: () {
                                  setState(() {
                                    arr = eventItems!
                                        .where((element) =>
                                            element.category == "Event")
                                        .toList();
                                    selectedcategory = "Event";
                                    day = "0";
                                  });
                                },
                                child: Container(
                                  height: 8.h,
                                  width: 18.w,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "EVENTS",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'LemonMilk',
                                            fontSize: 3.w,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      SizedBox(height: 3.5),
                                      Visibility(
                                        visible:
                                            (selectedcategory == "Event"),
                                        child: Container(
                                          height: 5,
                                          width: 5,
                                          decoration: BoxDecoration(
                                              color: Color.fromRGBO(
                                                  255, 142, 142, 1),
                                              shape: BoxShape.circle),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 2.w, vertical: 0.5.h),
                              decoration: BoxDecoration(
                                  color: (selectedcategory == "Talk")
                                      ? Color.fromRGBO(255, 255, 255, 0.288)
                                      : const Color.fromARGB(0, 0, 0, 0),
                                  borderRadius: BorderRadius.circular(20.0)),
                              child: InkWell(
                                radius: 20,
                                borderRadius: BorderRadius.circular(20.0),
                                onTap: () {
                                  setState(() {
                                    arr = eventItems!
                                        .where((element) =>
                                            element.category == "Talk")
                                        .toList();
                                    selectedcategory = "Talk";
                                    day = "0";
                                  });
                                },
                                child: Container(
                                  height: 8.h,
                                  width: 15.w,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "TALKS",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'LemonMilk',
                                            fontSize: 3.w,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      SizedBox(height: 3.5),
                                      Visibility(
                                        visible: (selectedcategory == "Talk"),
                                        child: Container(
                                          height: 5,
                                          width: 5,
                                          decoration: BoxDecoration(
                                              color: Color.fromRGBO(
                                                  255, 142, 142, 1),
                                              shape: BoxShape.circle),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: !search,
                    
                    child: Container(
                        margin: EdgeInsets.only(top: 1.h),
                        height: 46.h,
                        child: (arr.length != 0)
                            ? CarouselSlider.builder(
                                itemCount: arr.length,
                                options: CarouselOptions(
                                  height: 54.h,
                                  aspectRatio: 1.15,
                                  viewportFraction: 0.72,
                                  initialPage: 0,
                                  enableInfiniteScroll: true,
                                  reverse: false,
                                  autoPlay: true,
                                  autoPlayInterval: Duration(seconds: 3),
                                  autoPlayAnimationDuration:
                                      Duration(milliseconds: 800),
                                  autoPlayCurve:
                                      Curves.fastLinearToSlowEaseIn,
                                  enlargeCenterPage: true,
                                  scrollDirection: Axis.horizontal,
                                ),
                                carouselController: buttonCarouselController,
                                itemBuilder: (BuildContext context, int index,
                                        int pageViewIndex) =>
                                    Column(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            Navigator.pushNamed(
                                                context, '/eventpage',
                                                arguments: {
                                                  'eventItem': arr[index]
                                                });
                                          },
                                          child: Container(
                                            height: 39.h,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      10.sp),
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      10.sp),
                                              child: Transform.scale(
                                                scale: 1.015,
                                                child: CachedNetworkImage(
                                                  fit: BoxFit.cover,
                                                  errorWidget:
                                                      (context, url, error) {
                                                    return ClipRRect(
                                                      borderRadius:
                                                          BorderRadius
                                                              .circular(
                                                                  10.sp),
                                                      child: Image.asset(
                                                          "assets/placeholder.jpg",
                                                          height: 40.h,
                                                          fit: BoxFit.cover),
                                                    );
                                                  },
                                                  placeholder:
                                                      (context, url) =>
                                                          ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.sp),
                                                    child: Image.asset(
                                                        "assets/placeholder.jpg",
                                                        height: 40.h,
                                                        fit: BoxFit.cover),
                                                  ),
                                                  imageUrl:
                                                      arr[index].imageUrl!,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 1.h,
                                        ),
                                        Text(
                                          textAlign: TextAlign.center,
                                          "${arr[index].title}",
                                          style: TextStyle(
                                              fontFamily: 'Gugi',
                                              color: Colors.white,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 12.sp,
                                              letterSpacing: 1.2),
                                        )
                                      ],
                                    ))
                            : Center(
                                child:
                                    LoadingAnimationWidget.staggeredDotsWave(
                                  color: Colors.white,
                                  size: 40,
                                ),
                              )),
                  ),
                  Visibility(
                    visible: search,
                    child: Container(
                      height: 76.h,
                      child: (_foundUsers != null && _foundUsers!.isNotEmpty)
                          ? ListView.builder(
                              padding: EdgeInsets.only(bottom: 5),
                              itemCount: _foundUsers!.length,
                              itemBuilder: (context, index) => Container(
                                height: 10.h,
                                padding:
                                    EdgeInsets.fromLTRB(3.w, 1.h, 3.w, 1.h),
                                child: InkWell(
                                  onTap: () {
                                    FocusManager.instance.primaryFocus!
                                        .unfocus();
                                    Navigator.pushNamed(context, '/eventpage',
                                        arguments: {
                                          'eventItem': _foundUsers![index]
                                        });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(10.sp),
                                      gradient: LinearGradient(colors: [
                                        Color.fromRGBO(114, 2, 2, 0.48),
                                        Color.fromRGBO(117, 29, 29, 0.465),
                                      ]),
                                    ),
                                    child: OutlineGradientButton(
                                      padding: EdgeInsets.all(0),
                                      strokeWidth: 2,
                                      radius: Radius.circular(10),
                                      gradient: LinearGradient(
                                        begin: Alignment.bottomLeft,
                                        end: Alignment.topRight,
                                        colors: [
                                          Colors.transparent,
                                          Colors.grey.shade600,
                                          Colors.white38,
                                          Colors.white,
                                        ],
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                  bottomLeft:
                                                      Radius.circular(10.sp),
                                                  topLeft:
                                                      Radius.circular(10.sp)),
                                            ),
                                            child: SizedBox(
                                              width: 23.w,
                                              height: 23.w,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.only(
                                                  bottomLeft:
                                                      Radius.circular(10.sp),
                                                  topLeft:
                                                      Radius.circular(10.sp),
                                                ),
                                                child: FittedBox(
                                                  fit: BoxFit.cover,
                                                  child: SizedBox(
                                                    width: 23.w,
                                                    height: 23.w,
                                                    child: Transform.scale(
                                                      scale: 1.01,
                                                      child:
                                                          CachedNetworkImage(
                                                        imageUrl:
                                                            _foundUsers![
                                                                    index]
                                                                .imageUrl!,
                                                        fit: BoxFit.cover,
                                                        errorWidget: (context,
                                                            url, error) {
                                                          return Image.asset(
                                                            "assets/placeholder.jpg",
                                                            width: 23.w,
                                                            height: 23.w,
                                                            fit: BoxFit.cover,
                                                          );
                                                        },
                                                        placeholder:
                                                            (context, url) =>
                                                                Image.asset(
                                                          "assets/placeholder.jpg",
                                                          width: 23.w,
                                                          height: 23.w,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              child: Center(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(
                                                          2.0),
                                                  child: Text(
                                                    _foundUsers![index]
                                                        .title
                                                        .toString(),
                                                    overflow:
                                                        TextOverflow.clip,
                                                    textAlign:
                                                        TextAlign.center,
                                                    style: TextStyle(
                                                        color: const Color
                                                            .fromARGB(255,
                                                            255, 255, 255),
                                                        fontFamily: 'Mons',
                                                        letterSpacing: 1.1,
                                                        fontSize: 13.sp,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : Padding(
                              padding:
                                  EdgeInsets.fromLTRB(4.w, 1.h, 4.w, 1.h),
                              child: Container(
                                height: 8.h,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.white, width: 0.2.w),
                                  borderRadius: BorderRadius.circular(15.sp),
                                ),
                                child: Center(
                                  child: Text(
                                    'No results found',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Mons',
                                        letterSpacing: 1.1,
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ),
                            ),
                    ),
                  ),
                  Visibility(
                      visible: !search,
                      child: Container(
                        margin: EdgeInsets.only(bottom: 1.5.h),
                        child: Text(
                          "Fest Dates",
                          style: TextStyle(
                              color: Colors.white,
                              letterSpacing: 3,
                              fontFamily: 'AllertaStencil',
                              fontSize: 27.sp,
                              fontWeight: FontWeight.w500),
                        ),
                      )),
                  Visibility(
                    visible: !search,
                    child: Transform.translate(
                      offset: Offset(0, -1.0.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          radius: 5.sp,
                          onTap: () {
                            setState(() {
                              day = "1st";
                              selectedcategory = "";
                              arr = eventItems!
                                  .where((element) =>
                                      (DateTime.parse(element.date!).day ==
                                          17))
                                  .toList();
                            });
                          },
                          child: Container(
                            width: 15.w,
                            height: 9.h,
                            decoration: BoxDecoration(
                                color: (day == "1st")
                                    ? Color.fromRGBO(130, 51, 51, 0.85)
                                    : Color.fromRGBO(126, 0, 0, 0.925),
                                borderRadius: BorderRadius.circular(5.sp)),
                            child: OutlineGradientButton(
                              strokeWidth: 2,
                              radius: Radius.circular(5.sp),
                              gradient: (day == "1st")
                                  ? LinearGradient(
                                      colors: [
                                        const Color.fromARGB(
                                            109, 143, 142, 142),
                                        const Color.fromARGB(122, 92, 90, 90),
                                        Colors.white38,
                                        Colors.white,
                                      ],
                                    )
                                  : LinearGradient(colors: [
                                      Colors.transparent,
                                      Colors.transparent
                                    ]),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("09",
                                      style: TextStyle(
                                          fontFamily: 'Mons',
                                          fontSize: 15.sp,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500)),
                                  Text("Fri",
                                      style: TextStyle(
                                          fontFamily: 'Mons',
                                          fontSize: 12.sp,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500)),
                                ],
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          radius: 5.sp,
                          onTap: () {
                            setState(() {
                              day = "2nd";
                              selectedcategory = "";
                              arr = eventItems!
                                  .where((element) =>
                                      (DateTime.parse(element.date!).day ==
                                          18))
                                  .toList();
                            });
                          },
                          child: Container(
                            width: 15.w,
                            height: 9.h,
                            decoration: BoxDecoration(
                                color: (day == "2nd")
                                    ? Color.fromRGBO(130, 51, 51, 0.85)
                                    : Color.fromRGBO(126, 0, 0, 0.925),
                                borderRadius: BorderRadius.circular(5.sp)),
                            child: OutlineGradientButton(
                              strokeWidth: 2,
                              radius: Radius.circular(5.sp),
                              gradient: (day == "2nd")
                                  ? LinearGradient(
                                      colors: [
                                        const Color.fromARGB(
                                            109, 143, 142, 142),
                                        const Color.fromARGB(122, 92, 90, 90),
                                        Colors.white38,
                                        Colors.white,
                                      ],
                                    )
                                  : LinearGradient(colors: [
                                      Colors.transparent,
                                      Colors.transparent
                                    ]),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("10",
                                      style: TextStyle(
                                          fontFamily: 'Mons',
                                          fontSize: 15.sp,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500)),
                                  Text("Sat",
                                      style: TextStyle(
                                          fontFamily: 'Mons',
                                          fontSize: 12.sp,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500)),
                                ],
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          radius: 5.sp,
                          onTap: () {
                            setState(() {
                              day = "3rd";
                              selectedcategory = "";
                              arr = eventItems!
                                  .where((element) =>
                                      (DateTime.parse(element.date!).day ==
                                          19))
                                  .toList();
                            });
                          },
                          child: Container(
                           // adjusted or kept as 15.w
                            width: 15.w,
                            height: 9.h,
                            decoration: BoxDecoration(
                                color: (day == "3rd")
                                    ? Color.fromRGBO(130, 51, 51, 0.85)
                                    : Color.fromRGBO(126, 0, 0, 0.925),
                                borderRadius: BorderRadius.circular(5.sp)),
                            child: OutlineGradientButton(
                              strokeWidth: 2,
                              radius: Radius.circular(5.sp),
                              gradient: (day == "3rd")
                                  ? LinearGradient(
                                      colors: [
                                        const Color.fromARGB(
                                            109, 143, 142, 142),
                                        const Color.fromARGB(122, 92, 90, 90),
                                        Colors.white38,
                                        Colors.white,
                                      ],
                                    )
                                  : LinearGradient(colors: [
                                      Colors.transparent,
                                      Colors.transparent
                                    ]),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("11",
                                      style: TextStyle(
                                          fontFamily: 'Mons',
                                          fontSize: 15.sp,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500)),
                                  Text(
                                    "Sun",
                                    style: TextStyle(
                                        fontFamily: 'Mons',
                                        fontSize: 12.sp,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),),
                  ),
                  SizedBox(height: 8.h),
                ],
              ),
            ),
            
            // 3. Bottom menu overlay
            Visibility(visible: !search, child: BottomMenu())
          ]),
        ),
      );
    });
  }
}
