// ignore_for_file: file_names
import 'package:flutter/material.dart';

import '../../config/palette.dart';
import '../../utils/device.dart';
import 'attendance/attendance_verify.dart';
import 'ecuti/ecuti_verify.dart';
import 'reschedule/reschedule_verify.dart';

class ScheduleVerifyMain extends StatefulWidget {
  final bool? isAttendanceList, isEcutiList, isReschedule;

  const ScheduleVerifyMain(
      {Key? key, this.isAttendanceList, this.isEcutiList, this.isReschedule})
      : super(key: key);

  @override
  State<ScheduleVerifyMain> createState() => _ScheduleVerifyMainState();
}

class _ScheduleVerifyMainState extends State<ScheduleVerifyMain> {
  final Devices _device = Devices();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        _buildVerifyCard(context, widget.isAttendanceList, "Kehadiran",
            "Sahkan Kehadiran", const AttendanceVerify()),
        _buildVerifyCard(context, widget.isEcutiList, "E-Cuti", "Sahkan E-Cuti",
            const EcutiVerify()),
        _buildVerifyCard(context, widget.isReschedule, "Penjadualan Semula",
            "Luluskan", const RescheduleVerify()),
      ],
    );
  }

  Padding _buildVerifyCard(BuildContext context, bool? isCardExist,
      String? cardTitle, String? buttonTitle, redirect) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: isCardExist == true
          ? SizedBox(
              width: _device.screenWidth(context),
              child: Card(
                //Tugasan Card
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                shadowColor: white54,
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            cardTitle!,
                            style: TextStyle(
                                color: black87,
                                fontWeight: FontWeight.w700,
                                fontSize: 15),
                          ),
                          Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 3, horizontal: 5),
                              child: redirect),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        width: _device.screenWidth(context) * 0.7,
                        child: ElevatedButton(
                          style: ButtonStyle(
                              elevation: MaterialStateProperty.all(0),
                              overlayColor: MaterialStateColor.resolveWith(
                                  (states) => green800),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                              minimumSize: MaterialStateProperty.all(
                                  Size(_device.screenWidth(context), 42)),
                              backgroundColor:
                                  MaterialStateProperty.all(green)),
                          child: Text(buttonTitle!,
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: white)),
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : null,
    );
  }
}
