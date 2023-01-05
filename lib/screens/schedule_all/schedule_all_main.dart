import 'package:eswm/models/schedule/filter/schedule_filter_status.dart';
import 'package:eswm/providers/jadual_api.dart';
import 'package:eswm/utils/calendar/date.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
// import 'package:multi_select_flutter/multi_select_flutter.dart';

//import files
import '../../config/config.dart';
import '../../config/dimen.dart';
import '../../config/palette.dart';
import '../../utils/device/sizes.dart';
import '../../utils/icon/custom_icon.dart';
import '../../widgets/custom_scroll/custom_scroll.dart';
import '../../widgets/gridview/compactor_panel/compactor_task_list.dart';
import '../../widgets/listview/card_list_view.dart';

class ScheduleAllMainScreen extends StatefulWidget {
  const ScheduleAllMainScreen({Key? key}) : super(key: key);

  @override
  State<ScheduleAllMainScreen> createState() => _ScheduleIssueMainScreen();
}

class _ScheduleIssueMainScreen extends State<ScheduleAllMainScreen> {
  final TextEditingController _filteredDate = TextEditingController();
  DateTime filteredDate = DateTime.now();
  List<ScheduleFilterStatus> preSelectStatus = [];
  List<ScheduleFilterStatus> selectedStatus = [];
  bool displayFilterSection = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print('Display Filter Section: $displayFilterSection');
    // print('Filter Date: $filteredDate');
    // print('Selected Status: $selectedStatus');
    return Scaffold(
      backgroundColor: white,
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
                "Jadual Tugasan",
                style: TextStyle(
                  fontSize: 15,
                  color: blackCustom,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  setState(() {
                    _filteredDate.text =
                        Date.getTheDate(filteredDate, '', 'dd/MM/yyyy', 'ms');
                  });
                  displayFilterBottomSheet(context);
                },
                icon: Icon(
                  CustomIcon.filter,
                  color: blackCustom,
                  size: 13,
                ),
              ),
            ],
          ),
        ),
      ),
      body: ScrollConfiguration(
        behavior: CustomScrollBehavior(),
        child: SingleChildScrollView(
            child: userRole == 100
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          padding: const EdgeInsets.fromLTRB(30, 30, 0, 15),
                          child: const Text("Senarai Jadual Tugasan :",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w400))),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: CompactorTaskList(main: false),
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //filtered selection list
                      if (displayFilterSection) filteredSection(),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(
                            left: 20, right: 20, top: 20, bottom: 10),
                        child: Text(
                          "Senarai Laluan Tugasan :",
                          style: TextStyle(
                              color: blackCustom,
                              fontSize: 15,
                              fontWeight: FontWeight.w400),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: CardListView(
                          type: "Laluan",
                          screens: "drawer",
                          passData: {
                            "filteredDate": _filteredDate.text,
                            "selectedStatus": selectedStatus,
                          },
                        ),
                      ),
                    ],
                  )),
      ),
    );
  }

  Future<dynamic> displayFilterBottomSheet(context) async {
    return showModalBottomSheet(
        backgroundColor: Colors.white,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        constraints: BoxConstraints(
          maxHeight: Sizes().screenHeight(context) * 0.6,
          maxWidth: Sizes().screenWidth(context),
        ),
        context: context,
        builder: (builder) {
          return Container(
            margin: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Tapisan',
                    style: TextStyle(
                      color: blackCustom,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 18,
                ),
                Divider(
                  thickness: 0.5,
                  color: greyCustom,
                ),
                const SizedBox(
                  height: 24,
                ),
                Text(
                  'Tarikh',
                  style: TextStyle(
                    color: blackCustom,
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(
                  height: 16,
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
                const SizedBox(
                  height: 24,
                ),
                Text(
                  'Status',
                  style: TextStyle(
                    color: blackCustom,
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                FutureBuilder<List<ScheduleFilterStatus?>?>(
                  future: JadualApi.getDataStatusJadual(),
                  builder: (context, snapshot) {
                    final statusData = snapshot.data;

                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      default:
                        if (statusData!.isEmpty) {
                          return Center(
                            child: Container(
                              margin: const EdgeInsets.all(20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(CustomIcon.exclamation,
                                      color: Colors.orange, size: 14),
                                  const SizedBox(width: 10),
                                  Text("Tiada rekod dijumpai",
                                      style: TextStyle(color: grey500)),
                                ],
                              ),
                            ),
                          );
                        } else {
                          // var getStatus = selectedStatus.where((theStatus) =>
                          //     theStatus['code'].contains(status));

                          return Wrap(
                            runSpacing: 8,
                            spacing: 16,
                            children: statusData
                                .map(
                                  (status) => GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () {
                                      //to check the status already in the list or not
                                      var data = preSelectStatus.where(
                                          (theStatus) => theStatus.code
                                              .contains(status!.code));

                                      if (data.isEmpty) {
                                        //if not exist then add

                                        preSelectStatus.add(status!);
                                      } else {
                                        //else remove

                                        preSelectStatus.remove(status!);
                                      }

                                      setState(() {});

                                      // print(
                                      //     'Pra Selected Status: $preSelectStatus');
                                      // print('Selected Status: $selectedStatus');
                                    },
                                    child: Container(
                                      height: 40,
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: preSelectStatus
                                                .where((theStatus) => theStatus
                                                    .code
                                                    .contains(status!.code))
                                                .isNotEmpty
                                            ? const Color(0xffC0E4FF)
                                            : const Color(0xffEFEFEF),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(6)),
                                      ),
                                      child: Text(
                                        status!.name,
                                        style: TextStyle(
                                          color: preSelectStatus
                                                  .where((theStatus) =>
                                                      theStatus.code.contains(
                                                          status.code))
                                                  .isNotEmpty
                                              ? const Color(0xff005B9E)
                                              : const Color(0xff969696),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          );

                          // ListView.builder(
                          //   clipBehavior: Clip.none,
                          //   // scrollDirection: Axis.horizontal,
                          //   // physics: const NeverScrollableScrollPhysics(),
                          //   shrinkWrap: true,
                          //   itemCount: statusData.length,
                          //   itemBuilder: (context, index) {
                          //     return Row(
                          //       children: [
                          //         Container(
                          //           padding: const EdgeInsets.all(16),
                          //           // constraints: const BoxConstraints(
                          //           //   maxWidth: 100,
                          //           // ),
                          //           decoration: BoxDecoration(
                          //             color: selectedStatus
                          //                     .contains(statusData[index])
                          //                 ? const Color(0xffC0E4FF)
                          //                 : const Color(0xffEFEFEF),
                          //             borderRadius: const BorderRadius.all(
                          //                 Radius.circular(6)),
                          //           ),
                          //           child: Text(
                          //             statusData[index]!.name,
                          //             style: TextStyle(
                          //               color: selectedStatus
                          //                       .contains(statusData[index])
                          //                   ? const Color(0xff005B9E)
                          //                   : const Color(0xff969696),
                          //               fontSize: 14,
                          //               fontWeight: FontWeight.w400,
                          //             ),
                          //           ),
                          //         ),
                          //         const SizedBox(
                          //           width: 16,
                          //         ),
                          //       ],
                          //     );
                          //   },
                          // );

                          // Align(
                          //   alignment: Alignment.topLeft,
                          //   child: MultiSelectChipField(
                          //     height: 100,
                          //     showHeader: false,
                          //     scroll: false,
                          //     decoration: BoxDecoration(
                          //       border: Border.all(color: transparent),
                          //     ),
                          //     chipShape: const RoundedRectangleBorder(
                          //       borderRadius: BorderRadius.all(
                          //         Radius.circular(6),
                          //       ),
                          //     ),
                          //     chipColor: const Color(0xffEFEFEF),
                          //     textStyle: const TextStyle(
                          //       color: Color(0xff969696),
                          //       fontSize: 14,
                          //       fontWeight: FontWeight.w400,
                          //     ),
                          //     selectedChipColor: const Color(0xffC0E4FF),
                          //     selectedTextStyle: const TextStyle(
                          //       color: Color(0xff005B9E),
                          //       fontSize: 14,
                          //       fontWeight: FontWeight.w400,
                          //     ),
                          //     items: statusData
                          //         .map((status) =>
                          //             MultiSelectItem<ScheduleFilterStatus?>(
                          //                 status!, status.name))
                          //         .toList(),
                          //     onTap: (values) {
                          //       selectedStatus = values;
                          //     },
                          //   ),
                          // );
                        }
                    }
                  },
                ),
                const SizedBox(
                  height: 32,
                ),
                Row(
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
                            setState(() {
                              selectedStatus = preSelectStatus;
                              displayFilterSection = true;
                            });
                          },
                          style: ButtonStyle(
                            elevation: MaterialStateProperty.all(0),
                            shadowColor: MaterialStateProperty.all(transparent),
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
              ],
            ),
          );
        });
  }

  Future<dynamic> displayCupertinoDatePicker(context) {
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
        constraints: BoxConstraints(
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

                            filteredDate = getDate;
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
                  height: Sizes().screenHeight(context) * 0.2,
                  child: CupertinoDatePicker(
                    backgroundColor: Colors.white,
                    dateOrder: DatePickerDateOrder.dmy,
                    mode: CupertinoDatePickerMode.date,
                    initialDateTime: filteredDate,
                    onDateTimeChanged: (theDate) {
                      getDate = theDate;
                    },
                  ),
                ),
              ],
            ),
          );
        });
  }

  Widget filteredSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SizedBox(
            height: 16,
          ),
          SizedBox(
            height: 35,
            child: ListView(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      _filteredDate.text = "";
                      filteredDate = DateTime.now();
                      selectedStatus.clear();
                      displayFilterSection = false;
                    });
                  },
                  child: Container(
                    width: 60,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: const Color(0xffD9D9D9),
                      ),
                      borderRadius: BorderRadius.circular(26),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Center(
                      child: Text(
                        "Reset",
                        style: TextStyle(
                          color: blackCustom,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                if (_filteredDate.text != "")
                  Row(
                    children: [
                      const SizedBox(
                        width: 8,
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xffE7F5FF),
                          border: Border.all(
                            color: const Color(0xffC0E4FF),
                          ),
                          borderRadius: BorderRadius.circular(26),
                        ),
                        child: Row(
                          children: [
                            Text(
                              _filteredDate.text,
                              style: const TextStyle(
                                color: Color(0xff005B9E),
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _filteredDate.text = "";
                                  filteredDate = DateTime.now();
                                  if (selectedStatus.isEmpty) {
                                    displayFilterSection = false;
                                  }
                                });
                              },
                              child: const Icon(
                                Icons.close,
                                color: Color(0xff005B9E),
                                size: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                const SizedBox(
                  width: 8,
                ),
                Container(
                  padding: const EdgeInsets.only(left: 8),
                  child: ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    separatorBuilder: (context, index) {
                      return const SizedBox(
                        width: 8,
                      );
                    },
                    itemCount: selectedStatus.length,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xffE7F5FF),
                          border: Border.all(
                            color: const Color(0xffC0E4FF),
                          ),
                          borderRadius: BorderRadius.circular(26),
                        ),
                        child: Row(
                          children: [
                            Text(
                              "${selectedStatus[index].name}",
                              style: const TextStyle(
                                color: Color(0xff005B9E),
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  selectedStatus.remove(selectedStatus[index]);
                                  if (selectedStatus.isEmpty &&
                                      _filteredDate.text == "") {
                                    displayFilterSection = false;
                                  }
                                });
                              },
                              child: const Icon(
                                Icons.close,
                                color: Color(0xff005B9E),
                                size: 12,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
