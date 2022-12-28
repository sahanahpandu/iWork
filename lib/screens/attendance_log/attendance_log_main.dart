import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../config/palette.dart';
import '../../providers/attendance_log_api.dart';
import '../../utils/icon/custom_icon.dart';
import 'attendance_log_details.dart';

class AttendanceLogMain extends StatefulWidget {
  const AttendanceLogMain({Key? key}) : super(key: key);

  @override
  State<AttendanceLogMain> createState() => _AttendanceLogMainState();
}

class _AttendanceLogMainState extends State<AttendanceLogMain> {
  late Future<List> _loadAttendanceLogData;
  String thisWeekDate = "";
  String theFirstDate = "";
  String theLastDate = "";

  getThisWeekDate() {
    DateTime today = DateTime.now();

    DateTime firstDate = today.subtract(Duration(days: today.weekday - 1));
    String convFirstDate = DateFormat("yyyy-MM-dd", "ms").format(firstDate);

    DateTime lastDate =
        today.add(Duration(days: DateTime.daysPerWeek - today.weekday - 2));
    String convLastDate = DateFormat("yyyy-MM-dd", "ms").format(lastDate);

    String thisWeek =
        "${DateFormat("dd MMMM yyyy", "ms").format(firstDate)} - ${DateFormat("dd MMMM yyyy", "ms").format(lastDate)}";

    setState(() {
      theFirstDate = convFirstDate;
      theLastDate = convLastDate;
      thisWeekDate = thisWeek;
    });
  }

  @override
  void initState() {
    // _loadAttendanceLogData = AttendanceLogApi.getAttendanceLogData(context);
    getThisWeekDate();
    _loadAttendanceLogData =
        AttendanceLogApi.getDataAttendance(theFirstDate, theLastDate)!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              color: barShadowColor,
              offset: const Offset(0, 3),
              blurRadius: 8,
            )
          ]),
          child: AppBar(
            backgroundColor: white,
            elevation: 0,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(CustomIcon.arrowBack, color: blackCustom, size: 22),
            ),
            title: Center(
              child: Text(
                "Sejarah Log Masa",
                style: TextStyle(
                  fontSize: 15,
                  color: blackCustom,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: Icon(
                  CustomIcon.scheduleFill,
                  color: blackCustom,
                  size: 15,
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Text("Minggu Ini ($thisWeekDate)",
                  style: TextStyle(
                      color: blackCustom,
                      fontWeight: FontWeight.w400,
                      fontSize: 14)),
            ),
            FutureBuilder<List>(
              future: _loadAttendanceLogData,
              builder: (context, snapshot) {
                final dataFuture = snapshot.data;

                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return const Center(
                      child: CircularProgressIndicator(),
                    );

                  default:
                    if (snapshot.hasError) {
                      return const Center(
                        child: Text("Some errors occurred!"),
                      );
                    } else {
                      return ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: dataFuture!.length,
                        itemBuilder: (context, index) {
                          if (dataFuture.isNotEmpty) {
                            return GestureDetector(
                                onTap: () {},
                                child: AttendanceLogDetails(
                                  data: dataFuture[index],
                                ));
                          } else {
                            Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                child: Text(
                                  "Tiada rekod dijumpai",
                                  style: TextStyle(
                                      color: grey500,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500),
                                ));
                          }
                          return Container();
                        },
                      );
                    }
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
