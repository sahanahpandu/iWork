import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../../config/config.dart';
import '../../config/dimen.dart';
// import '../../config/font.dart';
import '../../config/palette.dart';
import '../../utils/calendar/date.dart';
import '../../utils/device/orientations.dart';
import '../../utils/device/sizes.dart';
import '../../utils/icon/custom_icon.dart';
import '../../widgets/app_bar/app_bar_widget.dart';
import '../list_of_sub_routes/list_of_sub_routes_text_form_field.dart';
import '../schedule_filter/schedule_filter_list.dart';

class ReportFilterDrawer extends StatefulWidget {
  const ReportFilterDrawer({Key? key}) : super(key: key);

  @override
  State<ReportFilterDrawer> createState() => _ReportFilterDrawerState();
}

class _ReportFilterDrawerState extends State<ReportFilterDrawer> {
  final namaSubLaluanKey = GlobalKey<ListOfSubRoutesTextFormFieldState>();
  final TextEditingController _filteredDate = TextEditingController();
  DateTime filteredDate = DateTime.now();
  Color textFieldFillColor = Colors.white;
  TextStyle textLabelStyle = TextStyle(
    color: blackCustom,
    fontSize: 15,
    fontWeight: FontWeight.w400,
  );
  double spaceBetweenItem = 24;
  double spaceBetweenLabel = 16;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const AppBarWidget(
            bgColor: Colors.white,
            leadingIcon: CustomIcon.cross,
            title: "Tapisan",
          ),
          Container(
            margin: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: spaceBetweenItem,
                ),

                //============== Tarikh =========================================
                Text(
                  'Tarikh',
                  style: textLabelStyle,
                ),
                SizedBox(
                  height: spaceBetweenLabel,
                ),
                GestureDetector(
                  onTap: () {
                    displayCupertinoDatePicker(context);
                  },
                  child: TextFormField(
                    controller: _filteredDate,
                    style: TextStyle(
                      color: blackCustom,
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
                    readOnly: true,
                    enabled: false,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: borderSideWidth,
                          color: enabledBorderWithoutText,
                        ),
                        borderRadius: BorderRadius.circular(
                          borderRadiusCircular,
                        ),
                      ),
                      hintText: 'Tarikh',
                      hintStyle: TextStyle(
                        color: greyCustom,
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                      suffixIcon: Icon(
                        CustomIcon.scheduleOutline,
                        size: 16,
                        color: blackCustom,
                      ),
                    ),
                  ),
                ),
                //============== end of Tarikh ====================================

                SizedBox(
                  height: spaceBetweenItem,
                ),

                //================ dropdown section ============================
                const ScheduleFilterList(),
                //================ dropdown section ============================

                SizedBox(
                  height: spaceBetweenItem,
                ),

                Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          width: Sizes().screenWidth(context) * 0.4,
                          height: 40,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: ButtonStyle(
                              elevation: MaterialStateProperty.all(0),
                              shadowColor:
                                  MaterialStateProperty.all(transparent),
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.white),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  side: const BorderSide(
                                    color: Color(0xffE5E5E5),
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'Batal',
                                style: TextStyle(
                                  color: greyCustom,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      Expanded(
                        child: SizedBox(
                          width: Sizes().screenWidth(context) * 0.4,
                          height: 40,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              // setState(() {
                              //   selectedDate = _filteredDate.text;
                              //   selectedStatus = preSelectStatus;
                              //   displayFilterSection = true;
                              // });
                            },
                            style: ButtonStyle(
                              elevation: MaterialStateProperty.all(0),
                              shadowColor:
                                  MaterialStateProperty.all(transparent),
                              backgroundColor:
                                  MaterialStateProperty.all(greenCustom),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                            child: const Center(
                              child: Text(
                                'Pasti',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<dynamic> displayCupertinoDatePicker(context) {
    // ignore: unused_local_variable
    DateTime getDate = DateTime.now();
    return showModalBottomSheet(
        backgroundColor: Colors.white,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        constraints: userRole == 100
            ? (Orientations().isLandscape(context)
                ? const BoxConstraints(maxWidth: 550, maxHeight: 280)
                : const BoxConstraints(maxWidth: 550, maxHeight: 330))
            : BoxConstraints(
                maxHeight: Sizes().screenHeight(context) * 0.4,
                maxWidth: Sizes().screenWidth(context),
              ),
        context: context,
        builder: (builder) {
          return Container(
            margin: const EdgeInsets.all(28),
            child: Column(
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Kembali',
                          style: TextStyle(
                            color: Color(0xffA4A4A4),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Text(
                        'Pilih Tarikh',
                        style: TextStyle(
                          color: blackCustom,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _filteredDate.text = Date.getTheDate(
                                getDate, '', 'dd/MM/yyyy', 'ms');

                            //   filteredDate = getDate;
                          });
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Pasti',
                          style: TextStyle(
                            color: greenCustom,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Divider(
                    thickness: 0.5,
                    color: greyCustom,
                  ),
                ),
                const SizedBox(
                  height: 18,
                ),
                SizedBox(
                  height: userRole == 100
                      ? (Orientations().isLandscape(context)
                          ? Sizes().screenHeight(context) * 0.23
                          : Sizes().screenHeight(context) * 0.18)
                      : Sizes().screenHeight(context) * 0.2,
                  child: Localizations.override(
                    delegates: const [
                      GlobalMaterialLocalizations.delegate,
                      GlobalCupertinoLocalizations.delegate,
                      DefaultWidgetsLocalizations.delegate,
                    ],
                    context: context,
                    locale: const Locale('ms'),
                    child: CupertinoDatePicker(
                      backgroundColor: Colors.white,
                      dateOrder: DatePickerDateOrder.dmy,
                      mode: CupertinoDatePickerMode.date,
                      initialDateTime: filteredDate,
                      maximumYear: 2024,
                      minimumYear: 2022,
                      onDateTimeChanged: (theDate) {
                        getDate = theDate;
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  Widget filterButtonSection() {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            width: Sizes().screenWidth(context) * 0.4,
            height: 40,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ButtonStyle(
                elevation: MaterialStateProperty.all(0),
                shadowColor: MaterialStateProperty.all(transparent),
                backgroundColor: MaterialStateProperty.all(Colors.white),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    side: const BorderSide(
                      color: Color(0xffE5E5E5),
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              child: Center(
                child: Text(
                  'Batal',
                  style: TextStyle(
                    color: greyCustom,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 12,
        ),
        Expanded(
          child: SizedBox(
            width: Sizes().screenWidth(context) * 0.4,
            height: 40,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // setState(() {
                //   selectedDate = _filteredDate.text;
                //   selectedStatus = preSelectStatus;
                //   displayFilterSection = true;
                // });
              },
              style: ButtonStyle(
                elevation: MaterialStateProperty.all(0),
                shadowColor: MaterialStateProperty.all(transparent),
                backgroundColor: MaterialStateProperty.all(greenCustom),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              child: const Center(
                child: Text(
                  'Pasti',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
