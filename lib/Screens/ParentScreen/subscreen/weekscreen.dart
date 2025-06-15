import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sapience/Controller/Provider/monthprovider.dart';
import 'package:sapience/Controller/Provider/subjectprovider.dart';
import 'package:sapience/Controller/Provider/termsprovider.dart';
import 'package:sapience/Controller/Provider/video.dart';
import 'package:sapience/Controller/Provider/videocategory.dart';
import 'package:sapience/Controller/Provider/weekprovider.dart';
import 'package:sapience/Screens/ParentScreen/syllabusvideos.dart';
import 'package:sapience/constant/app_theme.dart';
import 'package:sapience/constant/error_page.dart';
import 'package:sapience/constant/shimmer_skeleton.dart';
import 'package:sapience/constant/snackbar_util.dart';
import 'package:sapience/helper/appconstant.dart';

int? selected;
Map<String, int> selectedWeekIndexes = {};
String? monthid;
String? weekid;

class WeeksList extends ConsumerStatefulWidget {
  String? sectionid;
  String? termid;
  String? section;



  WeeksList({
    super.key,
    this.sectionid,
    this.termid,
    this.section,

  });

  @override
  _WeeksListState createState() => _WeeksListState();
}

class _WeeksListState extends ConsumerState<WeeksList> {
  //String weekid = "";
  //String monthid = "";
  int isSelectedIndex = -1;
  String subjectid = "";
  String subjectName = "";
  bool _isDialogShownmonth = false;
  bool _isDialogShownweek = false;
  bool _isDialogShownsubject = false;

  String? selectedSubjectId;
  bool isNavigating = false;



  List<bool> _expandedStates = [];

  @override
  void initState() {
    _isDialogShownmonth = false;
    _isDialogShownweek = false;
    _isDialogShownsubject = false;
    super.initState();
  }

  void _showTimeoutDialog() {
    if (!mounted) return;
    _isDialogShownmonth = true;
    _isDialogShownweek = true;
    _isDialogShownsubject = true;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Timer(const Duration(seconds: 3), () {
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
            _isDialogShownmonth = false;
            _isDialogShownweek = false;
            _isDialogShownsubject = false;
          }
        });
        return const AlertDialog(
          title: Text("Request timed out"),
          content: Text(
              "Server is taking too long to respond. Please try again after sometime."),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {


   return ref.watch(addtermsNotifier).id.when(
        data:(snapshot) {
          try {
            if (snapshot != null) {
              if (snapshot == "Nocache") {
                if (!_isDialogShownmonth) {
                  _isDialogShownmonth = true;
                  // SnackbarUtil.showNetworkError();
                }
              }
              _expandedStates =
              List<bool>.generate(snapshot['data'].length, (index) => false);
              return Expanded(
                flex: 8,
                child: ListView.builder(
                    key: Key('builder ${selected.toString()}'),
                    itemCount: snapshot['data'].length,
                    padding: const EdgeInsets.only(top: 0),
                    itemBuilder: (BuildContext context, int index) {

                      return _buildMonthPanel(
                        index,
                        widget.section!,
                        snapshot['data'][index]['name'].toString(),
                        widget.sectionid.toString(),
                        snapshot['data'][index]["id"].toString(),
                        unlocked:
                                snapshot['data'][index]['status'].toString() == "true"
                            ? true
                            : false,
                      );
                    }),
              );
            } else {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted && !_isDialogShownmonth) _showTimeoutDialog();
              });
              return Expanded(
                flex: 7,
                child: ShimmerSkeleton(
                  child: ListView.builder(
                      itemCount: 3,
                      padding: const EdgeInsets.only(top: 15),
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.only(
                              bottom: 15.0, left: 20, right: 20),
                          child: Container(
                            margin: const EdgeInsets.all(0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ExpansionTile(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: const BorderSide(
                                  color: Colors.transparent,
                                  style: BorderStyle.solid,
                                ),
                              ),
                              onExpansionChanged: (bool expanded) {
                                AudioPlayer()
                                    .play(AssetSource("audio/Bubble 02.mp3"));
                              },
                              backgroundColor: Colors.white,
                              title: Container(
                                height: MediaQuery.of(context).size.height * 0.05,
                                child: const ListTile(
                                  title: Padding(
                                    padding: EdgeInsets.only(bottom: 10.0),
                                    child: Text(
                                      'Month1',
                                      style: TextStyle(
                                          fontSize: AppTheme.mediumFontSize,
                                          color: AppTheme.blackcolor),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                ),
              );
            }
          } catch (e) {
            print("e-----------------> ${e}");
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted && !_isDialogShownmonth) _showTimeoutDialog();
            });
            return Expanded(
              flex: 7,
              child: ShimmerSkeleton(
                child: ListView.builder(
                    itemCount: 3,
                    padding: const EdgeInsets.only(top: 15),
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.only(
                            bottom: 15.0, left: 20, right: 20),
                        child: Container(
                          margin: const EdgeInsets.all(0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ExpansionTile(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: const BorderSide(
                                color: Colors.transparent,
                                style: BorderStyle.solid,
                              ),
                            ),
                            onExpansionChanged: (bool expanded) {
                              AudioPlayer()
                                  .play(AssetSource("audio/Bubble 02.mp3"));
                            },
                            backgroundColor: Colors.white,
                            title: Container(
                              height: MediaQuery.of(context).size.height * 0.05,
                              child: const ListTile(
                                title: Padding(
                                  padding: EdgeInsets.only(bottom: 10.0),
                                  child: Text(
                                    'Month1',
                                    style: TextStyle(
                                        fontSize: AppTheme.mediumFontSize,
                                        color: AppTheme.blackcolor),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            );
          }
        },
        error: (e, s) {
          return const SizedBox();
        }, loading: () {
      return Expanded(
        child: ShimmerSkeleton(
          child: ListView.builder(
              itemCount: 3,
              padding: const EdgeInsets.only(top: 15),
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding:
                  const EdgeInsets.only(bottom: 15.0, left: 20, right: 20),
                  child: Container(
                    margin: const EdgeInsets.all(0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ExpansionTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(
                          color: Colors.transparent,
                          style: BorderStyle.solid,
                        ),
                      ),
                      onExpansionChanged: (bool expanded) {
                        AudioPlayer().play(AssetSource("audio/Bubble 02.mp3"));
                      },
                      backgroundColor: Colors.white,
                      title: Container(
                        height: MediaQuery.of(context).size.height * 0.05,
                        child: const ListTile(
                          title: Padding(
                            padding: EdgeInsets.only(bottom: 10.0),
                            child: Text(
                              'Month1',
                              style: TextStyle(
                                  fontSize: AppTheme.mediumFontSize,
                                  color: AppTheme.blackcolor),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
        ),
      );
    }
    );










//donot  need for update
  /*  return ref.watch(addmonthNotifier).id.when(
        data: (snapshot) {
      try {
        if (snapshot != null) {
          if (snapshot == "Nocache") {
            if (!_isDialogShownmonth) {
              _isDialogShownmonth = true;
             // SnackbarUtil.showNetworkError();
            }
          }
          _expandedStates =
              List<bool>.generate(snapshot['data'].length, (index) => false);
          return Expanded(
            flex: 7,
            child: ListView.builder(
                key: Key('builder ${selected.toString()}'),
                itemCount: snapshot['data'].length,
                padding: const EdgeInsets.only(top: 15),
                itemBuilder: (BuildContext context, int index) {
                  return _buildMonthPanel(
                    index,
                    widget.section!,
                    snapshot['data'][index]['name'].toString(),
                    widget.sectionid.toString(),
                    widget.termid.toString(),
                    snapshot['data'][index]['id'].toString(),
                    unlocked:
                        snapshot['data'][index]['status'].toString() == "true"
                            ? true
                            : false,
                  );
                }),
          );
        } else {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted && !_isDialogShownmonth) _showTimeoutDialog();
          });
          return Expanded(
            flex: 7,
            child: ShimmerSkeleton(
              child: ListView.builder(
                  itemCount: 3,
                  padding: const EdgeInsets.only(top: 15),
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.only(
                          bottom: 15.0, left: 20, right: 20),
                      child: Container(
                        margin: const EdgeInsets.all(0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ExpansionTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: const BorderSide(
                              color: Colors.transparent,
                              style: BorderStyle.solid,
                            ),
                          ),
                          onExpansionChanged: (bool expanded) {
                            AudioPlayer()
                                .play(AssetSource("audio/Bubble 02.mp3"));
                          },
                          backgroundColor: Colors.white,
                          title: Container(
                            height: MediaQuery.of(context).size.height * 0.05,
                            child: const ListTile(
                              title: Padding(
                                padding: EdgeInsets.only(bottom: 10.0),
                                child: Text(
                                  'Month1',
                                  style: TextStyle(
                                      fontSize: AppTheme.mediumFontSize,
                                      color: AppTheme.blackcolor),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
            ),
          );
        }
      } catch (e) {
        print("e-----------------> ${e}");
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && !_isDialogShownmonth) _showTimeoutDialog();
        });
        return Expanded(
          flex: 7,
          child: ShimmerSkeleton(
            child: ListView.builder(
                itemCount: 3,
                padding: const EdgeInsets.only(top: 15),
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.only(
                        bottom: 15.0, left: 20, right: 20),
                    child: Container(
                      margin: const EdgeInsets.all(0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ExpansionTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: const BorderSide(
                            color: Colors.transparent,
                            style: BorderStyle.solid,
                          ),
                        ),
                        onExpansionChanged: (bool expanded) {
                          AudioPlayer()
                              .play(AssetSource("audio/Bubble 02.mp3"));
                        },
                        backgroundColor: Colors.white,
                        title: Container(
                          height: MediaQuery.of(context).size.height * 0.05,
                          child: const ListTile(
                            title: Padding(
                              padding: EdgeInsets.only(bottom: 10.0),
                              child: Text(
                                'Month1',
                                style: TextStyle(
                                    fontSize: AppTheme.mediumFontSize,
                                    color: AppTheme.blackcolor),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
          ),
        );
      }
    }, error: (e, s) {
      return const SizedBox();
    }, loading: () {
      return Expanded(
        child: ShimmerSkeleton(
          child: ListView.builder(
              itemCount: 3,
              padding: const EdgeInsets.only(top: 15),
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding:
                      const EdgeInsets.only(bottom: 15.0, left: 20, right: 20),
                  child: Container(
                    margin: const EdgeInsets.all(0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ExpansionTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(
                          color: Colors.transparent,
                          style: BorderStyle.solid,
                        ),
                      ),
                      onExpansionChanged: (bool expanded) {
                        AudioPlayer().play(AssetSource("audio/Bubble 02.mp3"));
                      },
                      backgroundColor: Colors.white,
                      title: Container(
                        height: MediaQuery.of(context).size.height * 0.05,
                        child: const ListTile(
                          title: Padding(
                            padding: EdgeInsets.only(bottom: 10.0),
                            child: Text(
                              'Month1',
                              style: TextStyle(
                                  fontSize: AppTheme.mediumFontSize,
                                  color: AppTheme.blackcolor),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
        ),
      );
    });
*/


  }





  Widget  _buildMonthPanel(
      int index,
      String section,
      String title,
      String sectionid,
      String termid, {
        required bool unlocked,
      }) {
    bool isTvScreen = MediaQuery.of(context).size.width >= 540;
    return Padding(
      padding:  EdgeInsets.only(bottom: 15.0,  left: isTvScreen ? 110 : 20, right:  isTvScreen ? 110 : 20),
      child: Container(
        margin: const EdgeInsets.all(0),
        decoration: BoxDecoration(
          color: index == 3 ? section == "LKG" ? const Color(0xffb673d0)
              : const Color(0xffffa8e6)
              : unlocked ? Colors.yellow[700] : const Color(0xffeeda55),
          borderRadius: BorderRadius.circular(10),
        ),
        child: unlocked
            ? ExpansionTile(
          collapsedIconColor: index == 3 ? Colors.white : Colors.black,
          iconColor: index == 3 ? Colors.white : Colors.black,
          key: Key(index.toString()),
          //key: Key(monthid),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(
              color: Colors.transparent,
              style: BorderStyle.solid,
            ),
          ),
          onExpansionChanged: ((newState) async{
            if (newState) {
              //await ref.refresh(addmonthNotifier);
              await ref.read(addmonthNotifier.notifier).addmonth(
                  widget.sectionid.toString(), termid);
              setState(() {
                selected = index;
                selectedWeekIndexes[termid] = -1;

             /*   if(index == 3){
                  var week =  ref.read(addmonthNotifier).id.value;
                  print("weeek---------->${week["data"][0]["id"]}");

                  weekid = week["data"][0]["id"].toString();
                  selectedWeekIndexes[termid] = 1;
                  ref.refresh(addsubjectsNotifier);
                  ref.read(addsubjectsNotifier.notifier).addsubjects(sectionid, termid, monthid, weekid);
                }*/

              });

            } else {
              setState(() {
                selected = -1;
              });
            }
          }),

          initiallyExpanded: index == selected,
          // initiallyExpanded: _expandedStates[index],
          backgroundColor: index == 3 ? widget.section == "LKG"
              ? const Color(0xffb673d0)
              : const Color(0xffffa8e6) : Colors.white,
          title: Container(
            height: isTvScreen ? MediaQuery.of(context).size.height * 0.08 :MediaQuery.of(context).size.height *  0.05,
            child: ListTile(
              title: Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Text(
                  title,
                  style:  TextStyle(
                    fontSize: 16.0,
                    color: index == 3 ? Colors.white : Colors.black,
                  ),
                ),
              ),
              trailing: unlocked
                  ? const SizedBox()
                  : Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Icon(
                  Icons.lock,
                  color: Colors.yellow[700],
                ),
              ),
            ),
          ),

          children: unlocked
              ? _buildWeekButtons( index, section, sectionid, termid)
              : _buildLockedContent(),
        )
            : Padding(
          padding: const EdgeInsets.only(left: 12.0, right: 8.0),
          child: ListTile(
            title: Text(
              title,
              style:  TextStyle(
                fontSize: 16.0,
                color: index == 3 ? Colors.white : Colors.black,
              ),
            ),
            trailing: Icon(
              Icons.lock,
              color:  index == 3 ? Colors.white : Colors.yellow[700],
            ),
          ),
        ),
      ),
    );
  }





//donot  need for update
 /*  Widget  _buildMonthPanel(
    int index,
    String section,
    String title,
    String sectionid,
    String termid,
    String monthid, {
    required bool unlocked,
  }) {
    bool isTvScreen = MediaQuery.of(context).size.width >= 540;
    return Padding(
      padding:  EdgeInsets.only(bottom: 15.0,  left: isTvScreen ? 110 : 20, right:  isTvScreen ? 110 : 20),
      child: Container(
        margin: const EdgeInsets.all(0),
        decoration: BoxDecoration(
          color: index == 3 ? section == "LKG" ? const Color(0xffb673d0)
              : const Color(0xffffa8e6)
          : unlocked ? Colors.yellow[700] : const Color(0xffeeda55),
          borderRadius: BorderRadius.circular(10),
        ),
        child: unlocked
            ? ExpansionTile(
          collapsedIconColor: index == 3 ? Colors.white : Colors.black,
          iconColor: index == 3 ? Colors.white : Colors.black,
                key: Key(index.toString()),
                //key: Key(monthid),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: const BorderSide(
                    color: Colors.transparent,
                    style: BorderStyle.solid,
                  ),
                ),
                onExpansionChanged: ((newState) async{
                  if (newState) {
                    await ref.refresh(addweekNotifier);
                   await ref.read(addweekNotifier.notifier).addweek(
                        widget.sectionid.toString(), termid, monthid);
                    setState(() {
                      selected = index;
                      selectedWeekIndexes[monthid] = -1;



                      if(index == 3){
                        var week =  ref.read(addweekNotifier).id.value;
                        print("weeek---------->${week["data"][0]["id"]}");

                        weekid = week["data"][0]["id"].toString();
                        selectedWeekIndexes[monthid] = 1;
                        ref.refresh(addsubjectsNotifier);
                        ref.read(addsubjectsNotifier.notifier).addsubjects(sectionid, termid, monthid, weekid);
                      }

                    });



                  } else {
                    setState(() {
                      selected = -1;
                    });
                  }
                }),

                initiallyExpanded: index == selected,
                // initiallyExpanded: _expandedStates[index],
                backgroundColor: index == 3 ? widget.section == "LKG"
                ? const Color(0xffb673d0)
                : const Color(0xffffa8e6) : Colors.white,
                title: Container(
                  height: isTvScreen ? MediaQuery.of(context).size.height * 0.08 :MediaQuery.of(context).size.height *  0.05,
                  child: ListTile(
                    title: Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Text(
                        title,
                        style:  TextStyle(
                          fontSize: 16.0,
                          color: index == 3 ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                    trailing: unlocked
                        ? const SizedBox()
                        : Padding(
                            padding: const EdgeInsets.only(bottom: 20.0),
                            child: Icon(
                              Icons.lock,
                              color: Colors.yellow[700],
                            ),
                          ),
                  ),
                ),

                children: unlocked
                    ? _buildWeekButtons( index, section, sectionid, termid, monthid)
                    : _buildLockedContent(),
              )
            : Padding(
                padding: const EdgeInsets.only(left: 12.0, right: 8.0),
                child: ListTile(
                  title: Text(
                    title,
                    style:  TextStyle(
                      fontSize: 16.0,
                      color: index == 3 ? Colors.white : Colors.black,
                    ),
                  ),
                  trailing: Icon(
                    Icons.lock,
                    color:  index == 3 ? Colors.white : Colors.yellow[700],
                  ),
                ),
              ),
      ),
    );
  }*/

  List<Widget> _buildWeekButtons(
      int index,
    String section,
    String sectionid,
    String termid,
  ) {
    return [
      Column(
        children: [
          //donot  need for update
          //ref.watch(addweekNotifier).id.when(data: (snapshot) {

        ref.watch(addmonthNotifier).id.when(data: (snapshot) {


            try {
              if (snapshot != null) {
                if (snapshot == "Nocache") {
                  if (!_isDialogShownweek) {
                    _isDialogShownweek = true;
                    //SnackbarUtil.showNetworkError();
                  }
                }
                return index == 3 ? SizedBox()
                    :  Padding(
                  padding: const EdgeInsets.only(left: 5.0, right: 5),
                  child: Wrap(
                    children: List.generate(
                       snapshot['data'].toString().isEmpty
                          ? 0
                          : snapshot['data'].length,
                      (index) {
                        double radiusSize =
                            MediaQuery.of(context).size.width <= 320 ? 27 : 31;
                        return GestureDetector(
                          onTap: ()async {
                            AudioPlayer()
                                .play(AssetSource("audio/Bubble 02.mp3"));
                           await ref.read(addweekNotifier.notifier).addweek(widget.sectionid.toString(), termid, snapshot['data'][index]['id'].toString());

                            setState(() {
                              monthid = snapshot['data'][index]['id'].toString();
                              int currentIndex =
                                  selectedWeekIndexes[termid] ?? -1;
                              print("first selectedWeekIndexes[termid] ${selectedWeekIndexes[termid]}");
                              print("first [termid] ${[termid]}");
                              if (currentIndex == index) {
                              } else {
                                 ref.watch(addweekNotifier).id.when(data: (weekdata){
                                   if(snapshot['data'][index]["name"] == "Full Syllabus"){
                                     weekid = weekdata["data"][0]['id'].toString();
                                   }else{
                                     weekid = weekdata["data"][3]['id'].toString();
                                   }

                                 },  error: (e, s) {
                                   return const SizedBox();
                                 }, loading: (){

                                 });

                               // weekid = snapshot['data'][index]['id'].toString();
                                // want to change the content
                                ref.refresh(addsubjectsNotifier);
                                ref.read(addsubjectsNotifier.notifier).addsubjects(sectionid, termid, monthid!, weekid!);
                                selectedWeekIndexes[termid] = index;

                                 print("second selectedWeekIndexes[termid] ${selectedWeekIndexes[termid]}");
                                 print("second [termid] ${[termid]}");
                              }
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width <= 375
                                        ? 2.6
                                        : 4.5),
                            child: CircleAvatar(
                              backgroundColor:
                                  selectedWeekIndexes[termid] == index
                                      ? const Color(0xFF10a8b3)
                                      : sectionid == "1"
                                          ? const Color(0xffb673d0)
                                          : const Color(0xffc773d0),
                              radius: radiusSize,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 5.0,left: 5, right: 5, bottom: 5),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      snapshot['data'][index]['name'].toString()
                                          .split(" ")[0],
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: AppTheme.verySmallFontSize,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      snapshot['data'][index]['name']
                                          .toString()
                                          .split(" ")[1],
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: AppTheme.verySmallFontSize,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              } else {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted && !_isDialogShownweek) _showTimeoutDialog();
                });
                return ShimmerSkeleton(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5.0, right: 5),
                    child: Wrap(
                      children: List.generate(4, (index) {
                        double radiusSize =
                            MediaQuery.of(context).size.width <= 320 ? 27 : 31;
                        return GestureDetector(
                          onTap: () {},
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width <= 375
                                        ? 2.6
                                        : 4.5),
                            child: CircleAvatar(
                              backgroundColor:
                                  selectedWeekIndexes[termid] == index
                                      ? const Color(0xFF10a8b3)
                                      : sectionid == "1"
                                          ? const Color(0xffb673d0)
                                          : const Color(0xffc773d0),
                              radius: radiusSize,
                              child: const Padding(
                                padding: EdgeInsets.only(top: 5.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "week",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: AppTheme.verySmallFontSize,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "1",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: AppTheme.mediumFontSize,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                );
              }
            } catch (e) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted && !_isDialogShownweek) _showTimeoutDialog();
              });
              return ShimmerSkeleton(
                child: Padding(
                  padding: const EdgeInsets.only(left: 5.0, right: 5),
                  child: Wrap(
                    children: List.generate(4, (index) {
                      double radiusSize =
                          MediaQuery.of(context).size.width <= 320 ? 27 : 31;
                      return GestureDetector(
                        onTap: () {},
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width <= 375
                                      ? 2.6
                                      : 4.5),
                          child: CircleAvatar(
                            backgroundColor:
                                selectedWeekIndexes[termid] == index
                                    ? const Color(0xFF10a8b3)
                                    : sectionid == "1"
                                        ? const Color(0xffb673d0)
                                        : const Color(0xffc773d0),
                            radius: radiusSize,
                            child: const Padding(
                              padding: EdgeInsets.only(top: 5.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "week",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: AppTheme.verySmallFontSize,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "1",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: AppTheme.mediumFontSize,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              );
            }
          }, error: (e, s) {
            return const SizedBox();
          }, loading: () {
            return ShimmerSkeleton(
              child: Padding(
                padding: const EdgeInsets.only(left: 5.0, right: 5),
                child: Wrap(
                  children: List.generate(4, (index) {
                    double radiusSize =
                        MediaQuery.of(context).size.width <= 320 ? 27 : 31;
                    return GestureDetector(
                      onTap: () {},
                      child: Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: MediaQuery.of(context).size.width <= 375
                                ? 2.6
                                : 4.5),
                        child: CircleAvatar(
                          backgroundColor: selectedWeekIndexes[termid] == index
                              ? const Color(0xFF10a8b3)
                              : sectionid == "1"
                                  ? const Color(0xffb673d0)
                                  : const Color(0xffc773d0),
                          radius: radiusSize,
                          child: const Padding(
                            padding: EdgeInsets.only(top: 5.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "week",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: AppTheme.verySmallFontSize,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "1",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: AppTheme.mediumFontSize,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            );
          }),
          const SizedBox(
            height: 15,
          ),
          Visibility(
            visible: selectedWeekIndexes[termid] != -1,
            child: ref.watch(addsubjectsNotifier).id.when(data: (snapshot) {
              try {
                if (snapshot != null) {
                  if (snapshot == "Nocache") {
                    if (!_isDialogShownsubject) {
                      _isDialogShownsubject = true;
                      SnackbarUtil.showNetworkError();
                    }
                  }
                  return SingleChildScrollView(
                    child: Container(
                      child: ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(8),
                        itemCount: snapshot['data'].length,
                        itemBuilder: (BuildContext context, int index) {
                          Color? backgroundColor = index.isEven
                              ? const Color(0xffeeda55)
                              : Colors.yellow[700];

                          return Padding(
                            padding:
                                const EdgeInsets.only(left: 10.0, right: 10),
                            child: InkWell(
                              onTap: isNavigating
                                  ? null
                                  : () async {
                                      try {
                                        setState(() {
                                          selectedSubjectId = snapshot['data']
                                                  [index]['id']
                                              .toString();
                                          isNavigating = true;
                                          isSelectedIndex = index;
                                        });
                                        AudioPlayer().play(
                                            AssetSource("audio/Bubble 02.mp3"));
                                        String subjectid = snapshot['data']
                                                [index]['id']
                                            .toString();
                                        String subjectName = snapshot['data']
                                                [index]['name']
                                            .toString();

                                        print("Nanncy-->${selectedWeekIndexes[termid]}");

                                        print("section-->${section}");
                                        print("context-->${context}");
                                        print("index-->${index}");
                                        print("sectionid-->${sectionid}");
                                        print("termid-->${termid}");
                                        print("monthid-->${monthid}");
                                        print("weekid-->${weekid}");
                                        print("subjectid-->${subjectid}");
                                        print("subjectName-->${subjectName}");


                                        handleAPIsAndNavigate(
                                          section,
                                          context,
                                          index,
                                          sectionid,
                                          termid,
                                          monthid!,
                                          weekid!,
                                          subjectid,
                                          subjectName,

                                        );
                                      } catch (e) {
                                      } finally {
                                        // await Future.delayed(
                                        //     const Duration(milliseconds: 1000));
                                        // setState(() {
                                        //   isSelectedIndex = -1;
                                        // });
                                      }
                                    },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: isSelectedIndex == index
                                      ? const Color(0xff9d8b29)
                                      : backgroundColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: ListTile(
                                  title: isSelectedIndex == index
                                      ? Center(
                                          child: SizedBox(
                                            width: 30,
                                            height: 30,
                                            child: LoadingAnimationWidget
                                                .staggeredDotsWave(
                                              color: Colors.white,
                                              size: 30,
                                            ),
                                          ),
                                        )
                                      : Text(
                                          snapshot['data'][index]['name']
                                              .toString(),
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) =>
                            const SizedBox(
                          height: 10,
                        ),
                      ),
                    ),
                  );
                } else {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted && !_isDialogShownsubject) _showTimeoutDialog();
                  });
                  return ShimmerSkeleton(
                    child: ListView.separated(
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(8),
                      itemCount: 3,
                      itemBuilder: (BuildContext context, int index) {
                        Color? backgroundColor = index.isEven
                            ? const Color(0xffeeda55)
                            : Colors.yellow[700];

                        return Padding(
                          padding: const EdgeInsets.only(left: 10.0, right: 10),
                          child: Container(
                            decoration: BoxDecoration(
                              color:
                                  backgroundColor, // Use the color based on the index
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ListTile(
                              title: const Text(
                                "Tamil",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppTheme.blackcolor,
                                  fontSize: AppTheme.mediumFontSize,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              onTap: () {},
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          const SizedBox(
                        height: 10,
                      ),
                    ),
                  );
                }
              } catch (e) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted && !_isDialogShownsubject) _showTimeoutDialog();
                });
                return ShimmerSkeleton(
                  child: ListView.separated(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(8),
                    itemCount: 3,
                    itemBuilder: (BuildContext context, int index) {
                      Color? backgroundColor = index.isEven
                          ? const Color(0xffeeda55)
                          : Colors.yellow[700];

                      return Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            color:
                                backgroundColor, // Use the color based on the index
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            title: const Text(
                              "Tamil",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppTheme.blackcolor,
                                fontSize: AppTheme.mediumFontSize,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            onTap: () {},
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        const SizedBox(
                      height: 10,
                    ),
                  ),
                );
              }
            }, error: (e, s) {
              return const SizedBox();
            }, loading: () {
              return ShimmerSkeleton(
                child: ListView.separated(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(8),
                  itemCount: 3,
                  itemBuilder: (BuildContext context, int index) {
                    Color? backgroundColor = index.isEven
                        ? const Color(0xffeeda55)
                        : Colors.yellow[700];

                    return Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          color:
                              backgroundColor, // Use the color based on the index
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          title: const Text(
                            "Tamil",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppTheme.blackcolor,
                              fontSize: AppTheme.mediumFontSize,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          onTap: () {},
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      const SizedBox(
                    height: 10,
                  ),
                ),
              );
            }),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    ];
  }

  List<Widget> _buildLockedContent() {
    return [
      const Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(
          "This content is locked.",
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.red,
          ),
        ),
      ),
    ];
  }

  void handleAPIsAndNavigate(

    String section,
    BuildContext context,
    int index,
    String sectionid,
    String termid,
    String monthid,
    String weekid,
    String subjectid,
    String subjectName,


  ) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      UserPreferences.sectionid(sectionid);
      UserPreferences.termid(termid);
      UserPreferences.monthid(monthid);
      UserPreferences.weekid(weekid);
      UserPreferences.subjectid(subjectid);
      ref.refresh(addvideocategoryNotifier);
      ref.refresh(addvideoNotifier);
      await ref
          .read(addvideocategoryNotifier.notifier)
          .addvideocategory(sectionid, termid, monthid, weekid, subjectid);
      var videocategorydata = await ref.read(addvideocategoryNotifier).id.value;
      if (videocategorydata == "Nocache") {
        SnackbarUtil.showNetworkError();

        setState(() {
          isSelectedIndex = -1;
          isNavigating = false;
        });
      } else {
        if (sectionid == null ||
            termid == null ||
            monthid == null ||
            weekid == null ||
            subjectid == null) {
          Get.to(() => errorPage(),
              // transition: Transition.rightToLeft,
              // duration: const Duration(milliseconds: 1)
          );
          ref.refresh(addmonthNotifier);
          await ref
              .read(addmonthNotifier.notifier)
              .addmonth(widget.sectionid.toString(), termid);
        } else {
          print("videocate----->${ videocategorydata['data'].isEmpty}");
          Get.to(
              () => Syllabusvideo(
                    titleid: 0,
                    section: section,
                    sectionid: sectionid,
                    subcatlen: videocategorydata['data'].length,
                    subcatid: videocategorydata['data'].isEmpty ? "0" : videocategorydata['data'][0]['id'].toString(),
                    subjectName: subjectName,
                monthid: monthid,
                weekid: weekid,

                  ),
              // transition: Transition.rightToLeft,
              // duration: const Duration(milliseconds: 500)
          );
          await ref.read(addvideoNotifier.notifier).addvideo(
              sectionid,
              termid,
              monthid,
              weekid,
              subjectid,
              videocategorydata['data'][0]['id'].toString());

          await Future.delayed(Duration(milliseconds: 500));
          setState(() {
            selectedSubjectId = null;
            isNavigating = false;
            isSelectedIndex = -1;
          });
        }
      }
    } catch (error) {
    } finally {
      setState(() {
        isSelectedIndex = -1;
        isNavigating = false;
      });
    }
  }
}
