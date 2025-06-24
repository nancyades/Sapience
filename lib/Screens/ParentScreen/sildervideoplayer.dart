import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:better_player/better_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:sapience/Controller/Provider/generalprovider.dart';
import 'package:sapience/Screens/loaderscreen/sliderloader.dart';
import 'package:sapience/constant/app_theme.dart';
import 'package:sapience/constant/connectivity_manager.dart';
import 'package:sapience/constant/custom_video_contols.dart';
import 'package:sapience/constant/shimmer_skeleton.dart';
import 'package:sapience/constant/snackbar_util.dart';
import 'package:sapience/helper/audiofile.dart';
import 'package:sapience/main.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock_plus/wakelock_plus.dart';


class SliderPlayer extends StatefulWidget {
  final String? section;
  final String? sectionid;
  final String? filePath;
  String? image;
  String? termid;
  SliderPlayer(
      {super.key,
      this.filePath,
      this.image,
      this.section,
      this.sectionid,
      this.termid});

  @override
  State<SliderPlayer> createState() => _SliderPlayerState();
}

class _SliderPlayerState extends State<SliderPlayer>
    with WidgetsBindingObserver {
  BetterPlayerController? _betterPlayerController;
  bool isCarouselVisible = false;

  bool _isVideoPlaying = false;
  bool _showControls = false;
  bool _isBuffering = false;
  Timer? _hideTimer;

  String? _error;

  void toggleCarouselVisibility() {
    // Toggle the state to show or hide the Carousel
    if (mounted) {
      setState(() {
        isCarouselVisible = !isCarouselVisible;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _startHideTimer();
    GlobalState.activeScreen = 'SpecificScreen';
    AudioService().stopMusic();
    WidgetsBinding.instance.addObserver(this);
    setLandscape();
    WakelockPlus.enable();
    _initializePlayer(widget.filePath!);
  }

  void _startHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _showControls = false;
        });
      }
    });
  }
  Future<void> _initializePlayer(String url) async {
    BetterPlayerDataSource dataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      url,
    );

    _betterPlayerController?.dispose();

    _betterPlayerController = BetterPlayerController(
      BetterPlayerConfiguration(
        autoPlay: true,
        aspectRatio: 16 / 9,
        fit: BoxFit.contain,
        controlsConfiguration: const BetterPlayerControlsConfiguration(
          enableFullscreen: false,
          enablePlaybackSpeed: false,
        ),
      ),
      betterPlayerDataSource: dataSource,
    );
  }

  void _toggleControls() {
    if (mounted) {
      setState(() {
        _showControls = !_showControls;
        if (_showControls) {
          _startHideTimer();
        }
      });
    }
  }

  @override
  void dispose() {
    GlobalState.activeScreen = null;
    WidgetsBinding.instance.removeObserver(this);
    _hideTimer?.cancel();
    _betterPlayerController?.dispose();
    AudioService().playMusic();
    WakelockPlus.disable();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    super.dispose(); // Ensure to call this at the end
  }


  Future setLandscape() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Get.off(
            () => Slideloader(
                  termid: widget.termid,
                  section: widget.section,
                  sectionid: widget.sectionid,
                ),
        );
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: <Widget>[
              GestureDetector(
                onTap: _toggleControls,
                onVerticalDragUpdate: (details) {
                  if (details.primaryDelta! < 0) {
                    if (!isCarouselVisible) toggleCarouselVisibility();
                  } else if (details.primaryDelta! > 0) {
                    if (isCarouselVisible) toggleCarouselVisibility();
                  }
                },
                child: Stack(
                  children: [
                    if (_betterPlayerController != null)
                      BetterPlayer(controller: _betterPlayerController!),
                    Positioned(
                      top: 20,
                      left: 0,
                      child: IconButton(
                        iconSize: AppTheme.mediumFontSize,
                        icon: SvgPicture.asset(
                          'assets/images/sapience/back-arrow.svg',
                          color: Colors.white,
                          width: AppTheme.largeFontSize,
                        ),
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          AudioPlayer().play(AssetSource("audio/Bubble 02.mp3"));
                          Get.off(
                            () => Slideloader(
                              termid: widget.termid,
                              section: widget.section,
                              sectionid: widget.sectionid,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
          /*  else
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(
                      widget.image == null || widget.image.toString() == "null"
                          ? "https://t4.ftcdn.net/jpg/04/70/29/97/360_F_470299797_UD0eoVMMSUbHCcNJCdv2t8B2g1GVqYgs.jpg"
                          : widget.image.toString(),
                    ),
                    fit: BoxFit.contain,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: 20,
                      left: 0,
                      child: IconButton(
                        iconSize: AppTheme.mediumFontSize,
                        icon: SvgPicture.asset(
                          'assets/images/sapience/back-arrow.svg',
                          color: Colors.white,
                          width: AppTheme.largeFontSize,
                        ),
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          AudioPlayer().play(AssetSource("audio/Bubble 02.mp3"));
                          Get.off(
                            () => Slideloader(
                              termid: widget.termid,
                              section: widget.section,
                              sectionid: widget.sectionid,
                            ),
                          );
                        },
                      ),
                    ),
                    Center(
                      child: CircularProgressIndicator(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),*/
            Consumer(
              builder: (context, ref, child) {
                final videoState = ref.watch(getslidervideoNotifier);
                return videoState.when(
                  data: (data) {
                    if (data is Map<String, dynamic> &&
                        data.containsKey('data')) {
                      List<dynamic> videos = data['data'] as List<dynamic>;
                      return AnimatedPositioned(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                        bottom: isCarouselVisible ? 0 : -200,
                        left: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: _toggleControls,
                          onVerticalDragUpdate: (details) {
                            if (details.primaryDelta! < 0) {
                              if (!isCarouselVisible) toggleCarouselVisibility();
                            } else if (details.primaryDelta! > 0) {
                               if (isCarouselVisible) toggleCarouselVisibility();
                            }
                          },
                          child: CarouselSlider(
                            items: videos.map((i) {
                              return Builder(
                                builder: (BuildContext context) {
                                  return GestureDetector(
                                    onTap: () {
                                      widget.image = widget.image == null
                                          ? "https://t4.ftcdn.net/jpg/04/70/29/97/360_F_470299797_UD0eoVMMSUbHCcNJCdv2t8B2g1GVqYgs.jpg"
                                          : i['image_url'].toString();

                                      //_playVideo(i['video_url']);
                                      setState(() {
                                        isCarouselVisible = false;
                                      });
                                      _initializePlayer(i['video_url']);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.only(
                                          bottom: 15, left: 10, right: 2),
                                      width: MediaQuery.of(context).size.width /
                                          3,
                                      margin: const EdgeInsets.only(
                                          bottom: 0, left: 5, right: 2),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: CachedNetworkImage(
                                        imageUrl: i['image_url'] == null
                                            ? "https://t4.ftcdn.net/jpg/04/70/29/97/360_F_470299797_UD0eoVMMSUbHCcNJCdv2t8B2g1GVqYgs.jpg"
                                            : i['image_url'],
                                        fit: BoxFit.fill,
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                        placeholder: (context, url) =>
                                            ShimmerSkeleton(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                          ),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                      ),
                                    ),
                                  );
                                },
                              );
                            }).toList(),
                            options: CarouselOptions(
                              padEnds: false,
                              height: 180.0,
                              autoPlay: false,
                              initialPage: 0,
                              viewportFraction: 1 / 3,
                              enableInfiniteScroll: false,
                              enlargeCenterPage: false,
                              onPageChanged: (index, reason) {
                                // Handle page change if needed
                              },
                            ),
                          ),
                        ),
                      );
                    } else {
                      return  Center(
                          child: GestureDetector(
                            onTap: ()async{
                              ConnectivityManager connectivityManager =
                              ConnectivityManager();
                              bool isOnline = await connectivityManager.isConnected();
                              if (!isOnline) {
                                SnackbarUtil.showNetworkError();
                                return;
                              }
                            },

                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 60,
                                  width: 35,
                                  child:
                                  Image.asset('assets/images/sapience/404 Error.png'),
                                ),
                              ],
                            ),));
                    }
                  },
                  loading: () => ShimmerSkeleton(
                    child: AnimatedPositioned(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                      bottom: isCarouselVisible ? 0 : -200,
                      left: 0,
                      right: 0,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        child: CarouselSlider(
                          items: [1, 2, 3, 4, 5, 6].map((i) {
                            return Builder(
                              builder: (BuildContext context) {
                                return GestureDetector(
                                  onTap: () {

                                    isCarouselVisible = false;
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                        bottom: 15, left: 10, right: 10),
                                    width: MediaQuery.of(context).size.width / 3,
                                    margin: const EdgeInsets.only(
                                        bottom: 20, left: 8, right: 8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 10.0,
                                          offset: Offset(0, 10),
                                        ),
                                      ],
                                      image: const DecorationImage(
                                        image: AssetImage(''),
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    child: Text(
                                      'text $i',
                                      style: const TextStyle(fontSize: 16.0),
                                    ),
                                  ),
                                );
                              },
                            );
                          }).toList(),
                          options: CarouselOptions(
                            padEnds: false,
                            height: 180.0,
                            autoPlay: false,
                            initialPage: 0,
                            viewportFraction: 1 / 3,
                            enableInfiniteScroll: false,
                            enlargeCenterPage: false,
                            onPageChanged: (index, reason) {
                              // Handle page change if needed
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  error: (err, stack) => Text('Error: $err'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
