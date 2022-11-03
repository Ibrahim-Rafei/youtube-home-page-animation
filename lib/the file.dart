import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:ui' as ui;
import 'package:youtube_pull_down_to_home_screen/swipe_provider.dart';

class YoutubeHome extends StatefulWidget {

  const  YoutubeHome({ super.key} );

  @override
  State<YoutubeHome> createState() => _YoutubeHomeState();
}

class _YoutubeHomeState extends State<YoutubeHome> {
  double mainheight = 0.0;
  var imgheight = 0.0;
  var fixedimageheight = 0.0;
  int realindex = 0;
  int imgindex = 0;
  List images = [
    'https://images.pexels.com/photos/313782/pexels-photo-313782.jpeg?auto=compress&cs=tinysrgb&w=600',
        'https://images.pexels.com/photos/1252869/pexels-photo-1252869.jpeg?auto=compress&cs=tinysrgb&w=600',
        'https://images.pexels.com/photos/1906658/pexels-photo-1906658.jpeg?auto=compress&cs=tinysrgb&w=600',
        'https://images.pexels.com/photos/1563355/pexels-photo-1563355.jpeg?auto=compress&cs=tinysrgb&w=600',
    'https://images.pexels.com/photos/801625/pexels-photo-801625.jpeg?auto=compress&cs=tinysrgb&w=600'
'https://images.pexels.com/photos/5834975/pexels-photo-5834975.jpeg?auto=compress&cs=tinysrgb&w=600'
  ];


  @override
  Widget build(BuildContext context) {
    Image image = Image.network(
        images[imgindex]
        , fit: BoxFit.cover);
    Completer<ui.Image> completer = Completer<ui.Image>();
    image.image.resolve(const ImageConfiguration()).addListener(
        ImageStreamListener((ImageInfo info, bool synchronousCall) {
          completer.complete(info.image);
        }));
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          if (constraints.minHeight == 0) {
            mainheight = MediaQuery
                .of(context)
                .size
                .height - 24;
          } else if (constraints.minHeight != 0) {
            mainheight = constraints.minHeight;
          }
          return Consumer<SwipeProvider>(
              builder: (context, swipeval, child) {
                return Stack(
                  children: [
                    SizedBox(
                      height: mainheight,
                      child: Stack(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            child: ListView.builder(
                              itemCount: images.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () async {
                                    imgindex = index;
                                    realindex = 0;

                                    if (swipeval.second == 1) {
                                      swipeval.second = 0;
                                      swipeval.status = 'up';
                                      swipeval.upspeed(
                                          context, swipeval.imageheight,
                                          fixedimageheight);
                                    }
                                    setState(() {

                                    });
                                  },
                                  child: Container(
                                    constraints: BoxConstraints(
                                      maxHeight: mainheight / 2.1,
                                    ),
                                    margin: const EdgeInsets.only(bottom: 20),
                                    color: Colors.white,
                                    child: Image.network(
                                      images[index]
                                      , fit: BoxFit.cover,),
                                  ),
                                );
                              },
                            ),
                          ),
                          FutureBuilder(
                              future: completer.future,
                              builder: (BuildContext context, AsyncSnapshot<
                                  ui.Image> snapshot) {
                                if (snapshot.hasData) {
                                  swipeval.mainheight = mainheight;
                                  if (imgheight == 0.0) {
                                    swipeval.imagewidth = MediaQuery
                                        .of(context)
                                        .size
                                        .width;
                                    swipeval.imageheight =
                                    ((snapshot.data!.height *
                                        MediaQuery
                                            .of(context)
                                            .size
                                            .width) / snapshot.data!.width) >=
                                        mainheight / 2.1
                                        ? mainheight / 2.1
                                        : ((snapshot.data!.height * MediaQuery
                                        .of(context)
                                        .size
                                        .width) / snapshot.data!.width);
                                    imgheight = 10.0;
                                    fixedimageheight = ((snapshot.data!.height *
                                        MediaQuery
                                            .of(context)
                                            .size
                                            .width) / snapshot.data!.width) >=
                                        mainheight / 2.1
                                        ? mainheight / 2.1
                                        : ((snapshot.data!.height * MediaQuery
                                        .of(context)
                                        .size
                                        .width) / snapshot.data!.width);
                                    realindex = -1;
                                  }

                                  return AnimatedContainer(
                                    duration: swipeval.isupdating
                                        ? const Duration(milliseconds: 0)
                                        : const Duration(milliseconds: 200),
                                    transform: Matrix4.identity()
                                      ..translate(0.0, swipeval.position.dy),
                                    child: Column(
                                      children: [
                                        GestureDetector(
                                            onPanUpdate: (value) {
                                              swipeval.updateposition(
                                                  value, context,
                                                  swipeval.imageheight,
                                                  snapshot.data!.height,
                                                  fixedimageheight);
                                              if (value.delta.dy > 0) {
                                                swipeval.status = 'down';
                                              } else if (value.delta.dy < 0) {
                                                swipeval.status = 'up';
                                              }
                                            },

                                            onPanEnd: (value) {
                                              if (value.primaryVelocity ==
                                                  0.0) {
                                                if (swipeval.second == 1 &&
                                                    swipeval.firsttime == 1) {
                                                  swipeval.second = 0;
                                                  swipeval.firsttime = 0;
                                                  swipeval.endposition(
                                                      context,
                                                      swipeval.imageheight,
                                                      snapshot.data!.height,
                                                      fixedimageheight);
                                                }
                                              } else {
                                                if (swipeval.status == 'up') {
                                                  if (swipeval.second == 1) {
                                                    swipeval.second = 0;
                                                    swipeval.upspeed(context,
                                                        swipeval.imageheight,
                                                        fixedimageheight);
                                                  }
                                                } else
                                                if (swipeval.status == 'down') {
                                                  if (swipeval.firsttime == 1) {
                                                    swipeval.firsttime = 0;
                                                    swipeval.downspeed(context,
                                                        swipeval.imageheight,
                                                        fixedimageheight);
                                                  }
                                                }
                                              }
                                            },

                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Stack(
                                                children: [
                                                  AnimatedContainer(
                                                    duration: swipeval
                                                        .isupdating
                                                        ? const Duration(
                                                        milliseconds: 0)
                                                        : const Duration(
                                                        milliseconds: 200),
                                                    height: swipeval
                                                        .imageheight,
                                                    width: MediaQuery
                                                        .of(context)
                                                        .size
                                                        .width,

                                                    color: Colors.white,
                                                  ),
                                                  AnimatedContainer(
                                                      duration: swipeval
                                                          .isupdating
                                                          ? const Duration(
                                                          milliseconds: 0)
                                                          : const Duration(
                                                          milliseconds: 200),
                                                      height: swipeval
                                                          .imageheight,
                                                      constraints: BoxConstraints(
                                                          maxHeight: mainheight /
                                                              2.1
                                                      ),
                                                      width: swipeval
                                                          .imagewidth,
                                                      onEnd: () {
                                                        if (swipeval
                                                            .imageheight ==
                                                            swipeval
                                                                .afterheight &&
                                                            swipeval.status ==
                                                                'up') {
                                                          fixedimageheight =
                                                          ((snapshot.data!
                                                              .height *
                                                              MediaQuery
                                                                  .of(context)
                                                                  .size
                                                                  .width) /
                                                              snapshot.data!
                                                                  .width) >=
                                                              mainheight / 3
                                                              ? mainheight / 2.1
                                                              : ((snapshot.data!
                                                              .height *
                                                              MediaQuery
                                                                  .of(context)
                                                                  .size
                                                                  .width) /
                                                              snapshot.data!
                                                                  .width);
                                                          swipeval.imageheight =
                                                              fixedimageheight;
                                                          swipeval.position =
                                                              Offset.zero;
                                                          setState(() {

                                                          });
                                                        }

                                                        if (swipeval
                                                            .imageheight ==
                                                            swipeval
                                                                .afterheight &&
                                                            swipeval.status ==
                                                                'down') {
                                                          swipeval.imagewidth =
                                                              MediaQuery
                                                                  .of(context)
                                                                  .size
                                                                  .width *
                                                                  swipeval
                                                                      .afterwidth;
                                                          swipeval.imageheight =
                                                              swipeval
                                                                  .afterheight -
                                                                  50;
                                                          swipeval.position =
                                                              Offset(0.0,
                                                                  (mainheight -
                                                                      swipeval
                                                                          .imageheight));
                                                          setState(() {

                                                          });
                                                        }
                                                      },
                                                      color: Colors.black,
                                                      child: image),
                                                ],
                                              ),
                                            )
                                        ),
                                        Flexible(
                                          child: SizedBox(
                                            width: MediaQuery
                                                .of(context)
                                                .size
                                                .width,
                                            child: ListView.builder(
                                                itemCount: images.length,
                                                shrinkWrap: true,
                                                itemBuilder: (context, index) {
                                                  return Container(
                                                    height: 200,
                                                    color: Colors.white,
                                                    padding: const EdgeInsets
                                                        .all(20),
                                                    child: Image.network(
                                                      images[index],
                                                    fit: BoxFit.cover,),
                                                  );
                                                }
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                                return Container();
                              }
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: mainheight,
                      left: 0,
                      right: 0,
                      child: Container(
                        color: Colors.white,
                        height: MediaQuery
                            .of(context)
                            .size
                            .height - mainheight - MediaQuery
                            .of(context)
                            .padding
                            .top,
                      ),
                    )
                  ],
                );
              }
          );
        }
    );
  }
}
