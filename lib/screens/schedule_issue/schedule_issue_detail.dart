import 'dart:math' as math;

import 'package:flutter/material.dart';

//import files
import '../../../config/palette.dart';
import '../../../screens/work_schedule/supervisor/supervisor_work_schedule_details.dart';
import '../../config/font.dart';
import '../../models/schedule/schedule_data_detail_cp_sv/schedule_detail.dart';
import '../../models/schedule/supervisor/detail/sv_schedule_detail.dart';
import '../../models/task/supervisor/supervisor_task.dart';
import '../../providers/schedule/supervisor/supervisor_schedule_api.dart';
import '../../widgets/alert/user_profile_dialog.dart';
import '../../widgets/buttons/contact_button.dart';
import '../../widgets/container/staff_stack_container.dart';
import '../../widgets/container/status_container.dart';
import '../../widgets/listview/card_list_view.dart';
import '../../widgets/slivers/expand_collapse_header/expand_collapse_header.dart';
import '../reassign_employee/reassign_employee_list.dart';
import '../street_search/street_search.dart';

class ScheduleIssueDetail extends StatefulWidget {
  final Isu getInfo;
  final String getIssue;

  const ScheduleIssueDetail({
    Key? key,
    required this.getIssue,
    required this.getInfo,
  }) : super(key: key);

  @override
  State<ScheduleIssueDetail> createState() => _ScheduleIssueDetailState();
}

class _ScheduleIssueDetailState extends State<ScheduleIssueDetail> {
  String listTitle = "Test";
  Color collapseBgColor = const Color(0xff2b7fe8);

  late SupervisorScheduleDetail scheduleDetail;

  @override
  void initState() {
    _loadListTile();
    super.initState();
  }

  void _loadListTile() {
    switch (widget.getIssue) {
      case "IHD":

        /// kehadiran
        listTitle = "Senarai Pekerja Tidak Hadir";
        break;
      case "ILHK":

        /// laporan halangan kerja
        listTitle = "Senarai Laporan";
        break;
      case "IBMT":

        /// Belum mula tugas
        listTitle = "Pilih Sub-Laluan & Taman:";
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      FutureBuilder<SupervisorScheduleDetail?>(
          future: SupervisorScheduleApi.getSupervisorScheduleDetail(
              context, widget.getInfo.scMainId),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const Center(
                  child: CircularProgressIndicator(),
                );
              default:
                if (snapshot.hasError) {
                  return const Center(child: Text("Some error occurred"));
                } else {
                  scheduleDetail = snapshot.data!;
                  return ExpandCollapseHeader(
                      centerTitle: false,
                      title: _collapseTitle(),
                      headerExpandedHeight: 0.54,
                      alwaysShowLeadingAndAction: false,
                      headerWidget: _header(context, scheduleDetail),
                      fullyStretchable: true,
                      body: [
                        _scrollBody(),
                      ],
                      curvedBodyRadius: 24,
                      fixedTitle: _fixedTitle(context),
                      fixedTitleHeight: 60,
                      collapseFade: 70,
                      backgroundColor: transparent,
                      appBarColor: collapseBgColor,
                      collapseButton: widget.getIssue == "IBMT" ? true : false);
                }
            }
          }),
      widget.getIssue == "IBMT"
          ? Positioned(
              bottom: 25,
              right: -10,
              child: ContactButton(data: widget.getInfo))
          : Container()
    ]);
  }

  SafeArea _scrollBody() {
    return SafeArea(
      child: Container(
          color: white,
          child: Column(
            children: [_getBottomList(widget.getIssue)],
          )),
    );
  }

  Widget _getBottomList(String issue) {
    switch (issue) {
      case "IHD":

        /// Kehadiran
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: ReassignEmployeeList(namaLaluan: widget.getInfo.mainRoute),
        );
      case "IBMT":

        /// Belum Mula Tugas
        return const StreetSearch();
      case "ILHK":

        /// Laporan Halangan Kerja
        return const Padding(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: CardListView(type: "Laporan"),
        );
      default:
        return Container();
    }
  }

  Row _collapseTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          widget.getInfo.mainRoute,
          style: TextStyle(
            color: white,
            fontWeight: FontWeight.w700,
            fontSize: 17,
          ),
        ),
        const SizedBox(width: 10),
        StatusContainer(
          type: "Laluan",
          status: widget.getInfo.statusCode.name,
          statusId: widget.getInfo.statusCode.code,
          fontWeight: statusFontWeight,
          roundedCorner: true,
        ),
        Padding(
            padding: const EdgeInsets.only(top: 5),
            child: //Senarai Staf
                buildStackedImages(scheduleDetail))
      ],
    );
  }

  Widget buildStackedImages(SupervisorScheduleDetail? scheduleDetail) {
    const double size = 56;
    const double xShift = 10;
    List userData = [];
    if (scheduleDetail!.data!.details.workerSchedules!.isNotEmpty) {
      for (int i = 0;
          i < scheduleDetail.data!.details.workerSchedules!.length;
          i++) {
        userData.add(scheduleDetail.data!.details.workerSchedules![i]);
      }
      final items = userData.map((userData) => buildImage(userData)).toList();

      return StaffStackContainer(
        items: items,
        size: size,
        xShift: xShift,
      );
    }
    return Container();
  }

  Widget buildImage(WorkerSchedule userData) {
    const double borderSize = 3;

    return ClipOval(
      child: Container(
        padding: const EdgeInsets.all(borderSize),
        color: collapseBgColor,
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return showUserProfileDialog(
                      context,
                      userData.userId!.userDetail!.profilePic! !=
                              "http://ems.swmsb.com/uploads/profile/blue.png"
                          ? userData.userId!.userDetail!.profilePic!
                          : "https://st3.depositphotos.com/9998432/13335/v/600/depositphotos_133352062-stock-illustration-default-placeholder-profile-icon.jpg",
                      userData.userId!.userDetail!.name,
                      "PRA",
                      userData.userAttendanceId != null
                          ? userData.userAttendanceId!.clockInAt
                          : "--:--",
                      userData.userAttendanceId != null
                          ? userData.userAttendanceId!.clockOutAt ?? "--:--"
                          : "--:--");
                });
          },
          child: ClipOval(
            child: userData.userId!.userDetail!.profilePic !=
                    "http://ems.swmsb.com/uploads/profile/blue.png"
                ? Image.network(
                    userData.userId!.userDetail!.profilePic!,
                    fit: BoxFit.cover,
                  )
                : Container(
                    color:
                        Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
                            .withOpacity(0.5),
                    child: Center(
                      child: Text(
                        userData.userId!.userDetail!.name!.substring(0, 2),
                        style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _header(
      BuildContext context, SupervisorScheduleDetail scheduleDetail) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              child: SupervisorScheduleDetails(data: scheduleDetail),
            ),
          ),
        ],
      ),
    );
  }

  Widget _fixedTitle(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Center(
        child: Text(
          listTitle,
          style: TextStyle(
            color: blackCustom,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
