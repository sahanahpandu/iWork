import 'package:flutter/material.dart';

import '../../models/schedule/filter/schedule_filter_main_routes.dart';
import '../../models/schedule/filter/schedule_filter_parks.dart';
import '../../models/schedule/filter/schedule_filter_streets.dart';
import '../../models/schedule/filter/schedule_filter_sub_routes.dart';
import '../../screens/list_of_park/list_of_parks2.dart';
import '../../screens/list_of_sub_routes/list_of_sub_routes.dart';
import '../../config/dimen.dart';
import '../../config/font.dart';
import '../../config/palette.dart';
import '../../providers/schedule_filter_api.dart';
import '../list_of_road/list_of_road_text_form_field2.dart';
import '../list_of_routes/list_of_routes.dart';

class ScheduleFilterList extends StatefulWidget {
  const ScheduleFilterList({Key? key}) : super(key: key);

  @override
  ScheduleFilterListState createState() => ScheduleFilterListState();
}

class ScheduleFilterListState extends State<ScheduleFilterList> {
  //==================== UI default=============================================

  double spaceBetweenItem = 24;
  double spaceBetweenLabel = 16;
  TextStyle textFormFieldStyle = const TextStyle(
    fontSize: 15,
    color: Color(0xff2B2B2B),
    fontWeight: FontWeight.w400,
  );
  Color textFieldFillColor = Colors.white;
  TextStyle textLabelStyle = TextStyle(
    color: blackCustom,
    fontSize: 15,
    fontWeight: FontWeight.w400,
  );

  TextStyle hintTextStyle = TextStyle(
    fontSize: 15,
    color: labelTextColor,
    fontWeight: textFormFieldLabelFontWeight,
  );

  bool clickable = true;
  TextStyle textFormFieldLabelStyle = TextStyle(
    fontSize: 15,
    color: labelTextColor,
    fontWeight: textFormFieldLabelFontWeight,
  );

  InputBorder errorBorderStyle = OutlineInputBorder(
    borderSide: BorderSide(width: borderSideWidth, color: Colors.red),
    borderRadius: BorderRadius.circular(borderRadiusCircular),
  );

  InputBorder disableBorderStyle = OutlineInputBorder(
    borderSide: BorderSide(
      width: borderSideWidth,
      color: enabledBorderWithoutText,
    ),
    borderRadius: BorderRadius.circular(
      borderRadiusCircular,
    ),
  );
  //==================== end of UI default======================================

  //==================== variables =============================================
  final TextEditingController namaLaluan = TextEditingController();
  final TextEditingController namaSubLaluan = TextEditingController();
  final TextEditingController namaTaman = TextEditingController();
  final TextEditingController namaJalan = TextEditingController();

  int idTaman = 0;
  int idJalan = 0;
  List<ScheduleFilterMainRoutes> dataLaluan = [];
  List<ScheduleFilterSubRoutes> dataSubLaluan = [];
  List<ScheduleFilterParks> dataTaman = [];
  List<ScheduleFilterStreets> dataJalan = [];

  List<ScheduleFilterMainRoutes>? senaraiLaluan = [];
  List<ScheduleFilterSubRoutes>? senaraiSubLaluan = [];
  List<ScheduleFilterParks>? senaraiTaman = [];
  List<ScheduleFilterStreets>? senaraiJalan = [];

  //==================== end of variables ======================================

  //==================== Methods ===============================================

  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() async {
    var filteredData = {
      'laluan': "",
      'subLaluan': "",
      'taman': null,
      'jalan': null,
    };
    // ignore: unused_local_variable
    var fetchData = await ScheduleFilterApi.getDataScheduleFilter(filteredData)
        .then((theData) {
      setState(() {
        //need to clear because this method also used for reset selection from dropdown
        //this is list of list use to get data from api
        dataLaluan.clear();
        dataSubLaluan.clear();
        dataTaman.clear();
        dataJalan.clear();

        //this is variable that hold data for selected item for all dropdown
        namaLaluan.clear();
        namaSubLaluan.clear();
        idTaman = 0;
        namaTaman.clear();
        idJalan = 0;
        namaJalan.clear();

        //this is list of list use to pass to all the dropdown
        senaraiLaluan!.clear();
        senaraiSubLaluan!.clear();
        senaraiTaman!.clear();
        senaraiJalan!.clear();

        if (theData.mainRoute != null || theData.mainRoute != []) {
          dataLaluan.addAll(theData.mainRoute);
        }

        if (theData.subRoutes != null || theData.subRoutes != []) {
          dataSubLaluan.addAll(theData.subRoutes);
        }

        if (theData.parks != null || theData.parks != []) {
          dataTaman.addAll(theData.parks);
        }

        if (theData.streets != null || theData.streets != []) {
          dataJalan.addAll(theData.streets);
        }

        senaraiLaluan!.addAll(dataLaluan);
        senaraiSubLaluan!.addAll(dataSubLaluan);
        senaraiTaman!.addAll(dataTaman);
        senaraiJalan!.addAll(dataJalan);
      });
    });
  }

  updateFilterItems(item, value) async {
    if (item == 'reset') {
      //reset button from dropdown selection
      loadData();
    } else {
      dynamic filteredValue;

      if (item == 'laluan') {
        filteredValue = {
          'laluan': value,
          'subLaluan': namaSubLaluan.text,
          'taman': idTaman,
          'jalan': idJalan,
        };
      } else if (item == 'sub-laluan') {
        filteredValue = {
          'laluan': namaLaluan.text,
          'subLaluan': value,
          'taman': idTaman,
          'jalan': idJalan,
        };
      } else if (item == 'taman') {
        filteredValue = {
          'laluan': namaLaluan.text,
          'subLaluan': namaSubLaluan.text,
          'taman': value['id'],
          'jalan': idJalan,
        };
      } else if (item == 'jalan') {
        filteredValue = {
          'laluan': namaLaluan.text,
          'subLaluan': namaSubLaluan.text,
          'taman': idTaman,
          'jalan': value['id'],
        };
      }

      await ScheduleFilterApi.getDataScheduleFilter(filteredValue)
          .then((theData) {
        setState(() {
          if (item == 'laluan') {
            namaLaluan.text = value;

            senaraiSubLaluan!.clear();
            senaraiTaman!.clear();
            senaraiJalan!.clear();

            if (theData.subRoutes != null || theData.subRoutes != []) {
              senaraiSubLaluan!.addAll(theData.subRoutes);

              //this is to check the list of sub laluan have current selection of the sub laluan
              //if the selected sub laluan still in the new list , no need to clear the text
              if (namaSubLaluan.text != "") {
                if (theData.subRoutes.where((subRoutes) =>
                        subRoutes.subRoute == namaSubLaluan.text) ==
                    null) {
                  namaSubLaluan.clear();
                }
              }
            }

            if (theData.parks != null || theData.parks != []) {
              senaraiTaman!.addAll(theData.parks);
              if (namaTaman.text != "") {
                if (theData.parks
                        .where((parks) => parks.parkName == namaTaman.text) ==
                    null) {
                  namaTaman.clear();
                }
              }
            }

            if (theData.streets != null || theData.streets != []) {
              senaraiJalan!.addAll(theData.streets);
              if (namaJalan.text != "") {
                if (theData.streets.where(
                        (streets) => streets.streetName == namaJalan.text) ==
                    null) {
                  namaJalan.clear();
                }
              }
            }
          } else if (item == 'sub-laluan') {
            namaSubLaluan.text = value;

            senaraiLaluan!.clear();
            senaraiTaman!.clear();
            senaraiJalan!.clear();

            if (theData.mainRoute != null || theData.mainRoute != []) {
              senaraiLaluan!.addAll(theData.mainRoute);

              //this is to check the list of laluan have current selection of the laluan
              //if the selected laluan still in the new list , no need to clear the text
              if (namaLaluan.text != "") {
                if (theData.mainRoute.where((mainRoute) =>
                        mainRoute.mainRouteName == namaLaluan.text) ==
                    null) {
                  namaLaluan.clear();
                }
              }
            }

            if (theData.parks != null || theData.parks != []) {
              senaraiTaman!.addAll(theData.parks);
              if (namaTaman.text != "") {
                if (theData.parks
                        .where((parks) => parks.parkName == namaTaman.text) ==
                    null) {
                  namaTaman.clear();
                }
              }
            }

            if (theData.streets != null || theData.streets != []) {
              senaraiJalan!.addAll(theData.streets);
              if (namaJalan.text != "") {
                if (theData.streets.where(
                        (streets) => streets.streetName == namaJalan.text) ==
                    null) {
                  namaJalan.clear();
                }
              }
            }
          } else if (item == 'taman') {
            idTaman = value['id'];
            namaTaman.text = value['name'];

            senaraiLaluan!.clear();
            senaraiSubLaluan!.clear();
            senaraiJalan!.clear();

            if (theData.mainRoute != null || theData.mainRoute != []) {
              senaraiLaluan!.addAll(theData.mainRoute);

              //this is to check the list of laluan have current selection of the laluan
              //if the selected laluan still in the new list , no need to clear the text
              if (namaLaluan.text != "") {
                if (theData.mainRoute.where((mainRoute) =>
                        mainRoute.mainRouteName == namaLaluan.text) ==
                    null) {
                  namaLaluan.clear();
                }
              }
            }

            if (theData.subRoutes != null || theData.subRoutes != []) {
              senaraiSubLaluan!.addAll(theData.subRoutes);
              if (namaSubLaluan.text != "") {
                if (theData.subRoutes.where((subRoutes) =>
                        subRoutes.subRoute == namaSubLaluan.text) ==
                    null) {
                  namaSubLaluan.clear();
                }
              }
            }

            if (theData.streets != null || theData.streets != []) {
              senaraiJalan!.addAll(theData.streets);
              if (namaJalan.text != "") {
                if (theData.streets.where(
                        (streets) => streets.streetName == namaJalan.text) ==
                    null) {
                  namaJalan.clear();
                }
              }
            }
          } else if (item == 'jalan') {
            idJalan = value['id'];
            namaJalan.text = value['name'];

            senaraiLaluan!.clear();
            senaraiSubLaluan!.clear();
            senaraiTaman!.clear();

            if (theData.mainRoute != null || theData.mainRoute != []) {
              senaraiLaluan!.addAll(theData.mainRoute);

              //this is to check the list of laluan have current selection of the laluan
              //if the selected laluan still in the new list , no need to clear the text
              if (namaLaluan.text != "") {
                if (theData.mainRoute.where((mainRoute) =>
                        mainRoute.mainRouteName == namaLaluan.text) ==
                    null) {
                  namaLaluan.clear();
                }
              }
            }

            if (theData.subRoutes != null || theData.subRoutes != []) {
              senaraiSubLaluan!.addAll(theData.subRoutes);
              if (namaSubLaluan.text != "") {
                if (theData.subRoutes.where((subRoutes) =>
                        subRoutes.subRoute == namaSubLaluan.text) ==
                    null) {
                  namaSubLaluan.clear();
                }
              }
            }

            if (theData.parks != null || theData.parks != []) {
              senaraiTaman!.addAll(theData.parks);
              if (namaTaman.text != "") {
                if (theData.parks
                        .where((parks) => parks.parkName == namaTaman.text) ==
                    null) {
                  namaTaman.clear();
                }
              }
            }
          }
        });
      });
    }
  }

  //==================== end of Methods ========================================

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //============== Laluan ====================================
        Text(
          "Laluan",
          style: textLabelStyle,
        ),
        SizedBox(
          height: spaceBetweenLabel,
        ),

        ListOfRoutes(
          uiData: {
            "style": textFormFieldStyle,
            "controller": namaLaluan,
            "fillColor": textFieldFillColor,
            "hintStyle": hintTextStyle,
            "clickable": clickable,
            "labelStyle": textFormFieldLabelStyle,
            "errorBorder": errorBorderStyle,
            "disableBorder": disableBorderStyle,
          },
          data: senaraiLaluan,
          updateData: updateFilterItems,
        ),

        //============== end of Laluan =============================

        SizedBox(
          height: spaceBetweenItem,
        ),

        //============== Sub-Laluan ================================
        Text(
          "Sub-Laluan",
          style: textLabelStyle,
        ),
        SizedBox(
          height: spaceBetweenLabel,
        ),

        ListOfSubRoutes(
          uiData: {
            "style": textFormFieldStyle,
            "controller": namaSubLaluan,
            "fillColor": textFieldFillColor,
            "hintStyle": hintTextStyle,
            "clickable": clickable,
            "labelStyle": textFormFieldLabelStyle,
            "errorBorder": errorBorderStyle,
            "disableBorder": disableBorderStyle,
          },
          data: senaraiSubLaluan,
          updateData: updateFilterItems,
        ),

        //============== end of Sub-Laluan =====================================
        SizedBox(
          height: spaceBetweenItem,
        ),
        //============== Taman =================================================
        Text(
          "Taman",
          style: textLabelStyle,
        ),
        SizedBox(
          height: spaceBetweenLabel,
        ),

        ListOfParks2(
          uiData: {
            "style": textFormFieldStyle,
            "controller": namaTaman,
            "fillColor": textFieldFillColor,
            "hintStyle": hintTextStyle,
            "clickable": clickable,
            "labelStyle": textFormFieldLabelStyle,
            "errorBorder": errorBorderStyle,
            "disableBorder": disableBorderStyle,
          },
          data: senaraiTaman,
          updateData: updateFilterItems,
        ),

        //============== end of Taman =========================================
        SizedBox(
          height: spaceBetweenItem,
        ),
        //============== Jalan =================================================
        Text(
          "Jalan",
          style: textLabelStyle,
        ),
        SizedBox(
          height: spaceBetweenLabel,
        ),

        ListOfRoadTextFormField2(
          uiData: {
            "style": textFormFieldStyle,
            "controller": namaJalan,
            "fillColor": textFieldFillColor,
            "hintStyle": hintTextStyle,
            "clickable": clickable,
            "labelStyle": textFormFieldLabelStyle,
            "errorBorder": errorBorderStyle,
            "disableBorder": disableBorderStyle,
          },
          data: senaraiJalan,
          updateData: updateFilterItems,
        ),

        //============== end of Jalan =========================================

        SizedBox(
          height: spaceBetweenItem,
        ),
      ],
    );
  }
}
