import 'package:dio/dio.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:keyboard_visibility_pro/keyboard_visibility_pro.dart';

//import files
import '../../config/config.dart';
import '../../config/dimen.dart';
import '../../config/font.dart';
import '../../config/palette.dart';
import '../../models/report/report_details/report_details_info.dart';
import '../../providers/reports_api.dart';
import '../../screens/reports/pra/pra_section_report_form.dart';
import '../../utils/device/orientations.dart';
import '../../utils/device/sizes.dart';
import '../../widgets/buttons/report_submit_button.dart';
import '../list_of_obstacles/list_of_obstacles.dart';
import '../list_of_park/list_of_parks.dart';
import '../list_of_road/list_of_road_text_form_field.dart';
import '../list_of_sub_routes/list_of_sub_routes_text_form_field.dart';

class ReportForm extends StatefulWidget {
  final String screen;
  final dynamic
      passData; // data task list , to get nama sub laluan and vehicle no
  final dynamic data; // data report details, to get the report id

  const ReportForm({
    Key? key,
    required this.screen,
    required this.passData,
    this.data,
  }) : super(key: key);

  @override
  State<ReportForm> createState() => _ReportFormState();
}

class _ReportFormState extends State<ReportForm> {
  final praSectionKey = GlobalKey<PraSectionReportFormState>();
  final namaSubLaluanKey = GlobalKey<ListOfSubRoutesTextFormFieldState>();
  final namaTamanKey = GlobalKey<ListOfParksState>();
  final namaJalanKey = GlobalKey<ListOfRoadTextFormFieldState>();
  final jenisHalanganKey = GlobalKey<ListOfObstaclesState>();
  final ExpandableController _expandController =
      ExpandableController(initialExpanded: true);
  final _reportFormKey = GlobalKey<FormState>();
  final TextEditingController _namaLaluan = TextEditingController();
  final TextEditingController _noKenderaan = TextEditingController();
  final TextEditingController _maklumbalasPenyelia = TextEditingController();
  final TextEditingController _statusPenyelia = TextEditingController();
  String formTitleText = "Sila lengkapkan maklumat di bawah: ";
  String namaLaluan = "Laluan";
  String noKenderaan = "No Kenderaan";
  Color textFieldFillColor = Colors.white;
  double _height = 500;
  bool buttonVisibility = true;
  int iconCondition = 1;
  ReportDetailsInfo? currReportData;

  void onClick() {
    if (_height == 500) {
      setState(() {
        _height = 0;
      });
    } else {
      setState(() {
        _height = 500;
      });
    }
  }

  updateButtonVisibility(visible) {
    setState(() {
      buttonVisibility = visible;
    });
  }

  loadData() {
    //to get nama laluan and no kenderaan
    if (widget.passData != null) {
      _namaLaluan.text = widget.passData.mainRoute;
      _noKenderaan.text = widget.passData.vehicleNo;
    }

    //set icon condition
    iconCondition = 0;

    if (widget.screen == "3" || widget.screen == "7") {
      // clear form
      // Screen 3 = From Report Button, Screen 7 = From tab (case: after submit form)
      textFieldFillColor = Colors.white;
      formTitleText = formTitleText;
      _expandController.expanded = true;
      buttonVisibility = true;
    } else if (widget.screen == "4") {
      // load form
      // from Report List
      textFieldFillColor = textFormFieldFillColor;
      formTitleText = "Butiran maklumat laporan: ";
      _expandController.expanded = false;
      buttonVisibility = false;

      //fetch data based on report id
      ReportsApi.getDetailLaporan(widget.data.id)!.then((theDetails) {
        if (theDetails != null) {
          //set read only UI
          praSectionKey.currentState!.iconCondition = 0;
          praSectionKey.currentState!.textFieldFillColor =
              textFormFieldFillColor;
          praSectionKey.currentState!.focusBorderColor = Colors.grey.shade300;
          praSectionKey.currentState!.enableBorderWithTextColor =
              Colors.grey.shade300;

          //set data
          namaSubLaluanKey.currentState!.namaSubLaluan.text =
              theDetails.subRouteName!;
          namaTamanKey.currentState!.namaTaman.text = theDetails.park!.parkName;
          namaJalanKey.currentState!.namaJalan.text =
              theDetails.street!.streetName;
          jenisHalanganKey.currentState!.jenisHalangan.text =
              theDetails.obstacleType!.obsTypeName;
          praSectionKey.currentState!.catatan.text = theDetails.remarks!;

          if (theDetails.uploadFileId != null) {
            // String path = theDetails.uploadFileId!.filePath;
            // String findString = "localhost";
            // String replaceString = "10.0.2.2";
            // String thePath = path.replaceAll(findString, replaceString);

            // have attachment
            praSectionKey.currentState!.pathGambar =
                theDetails.uploadFileId!.filePath;
          }
        }
      });
    }
  }

  postNewReport() async {
    //checking attachment data
    String? imagePath;

    if (praSectionKey.currentState!.gambarLampiran?.path != null) {
      imagePath = praSectionKey.currentState!.gambarLampiran!.path;
    } else {
      imagePath = null;
    }

    //post data to the database
    String getAccessToken = userInfo[1];

    FormData formData = FormData.fromMap({
      "sc_main_id":
          userRole == 100 ? widget.passData?.id : widget.passData?.scMainId,
      "sub_route_name": namaSubLaluanKey.currentState!.namaSubLaluan.text,
      "park_id": namaTamanKey.currentState!.idTaman,
      "street_id": namaJalanKey.currentState!.idJalan,
      "obstacle_type_id": jenisHalanganKey.currentState!.idJenisHalangan,
      "remarks": praSectionKey.currentState!.catatan.text,
      "report_attachment": imagePath != null
          ? await MultipartFile.fromFile(
              praSectionKey.currentState!.gambarLampiran!.path,
              filename: praSectionKey.currentState!.namaGambar,
              contentType: MediaType(
                "image",
                "png,jpeg",
              ),
            )
          : imagePath,
    });

    try {
      Response response = await Dio().post(
        '$theBase/report/new',
        data: formData,
        options: Options(headers: {
          "authorization": "Bearer $getAccessToken",
          "Content-Type": "multipart/form-data",
        }),
      );

      if (response.statusCode == 200) {
        clearForm();
      }
    } on DioError catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  clearForm() {
    _reportFormKey.currentState!.reset();
    namaSubLaluanKey.currentState!.namaSubLaluan.clear();
    namaTamanKey.currentState!.namaTaman.clear();
    namaJalanKey.currentState!.namaJalan.clear();
    jenisHalanganKey.currentState!.jenisHalangan.clear();
    praSectionKey.currentState!.gambarLampiran = null;
    praSectionKey.currentState!.catatan.clear();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibility(
      onChanged: (bool keyboardVisible) {
        if (keyboardVisible) {
          setState(() {
            buttonVisibility = false;
          });
        } else {
          setState(() {
            buttonVisibility = true;
          });
        }
      },
      child: KeyboardDismisser(
        gestures: const [
          GestureType.onTap,
          GestureType.onVerticalDragDown,
        ],
        child: GestureDetector(
          onTap: () {
            if (widget.screen != "4") {
              // only applicable for new form
              setState(() {
                buttonVisibility = true;
              });
            }
          },
          onVerticalDragDown: (DragDownDetails details) {
            if (widget.screen != "4") {
              // only applicable for new form
              setState(() {
                buttonVisibility = true;
              });
            }
          },
          child: ExpandableNotifier(
            controller: _expandController,
            child: Stack(
              children: [
                ScrollConfiguration(
                  behavior: const MaterialScrollBehavior()
                      .copyWith(overscroll: false),
                  child: SingleChildScrollView(
                    child: Container(
                      margin: userRole != 100
                          ? const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 5)
                          : Orientations().isLandscape(
                                  context) // condition for compactor panel
                              ? const EdgeInsets.fromLTRB(150, 35, 150, 0)
                              : const EdgeInsets.symmetric(
                                  horizontal: 60, vertical: 20),
                      child: Form(
                        key: _reportFormKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (widget.screen == "4")
                              const SizedBox(
                                height: 24,
                              ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                //form title
                                Text(
                                  formTitleText,
                                  style: const TextStyle(
                                    color: Color(0xff2B2B2B),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                if (widget.screen == "4")
                                  //expand button
                                  ExpandableButton(
                                    child: InkWell(
                                        onTap: () {
                                          _expandController.toggle();
                                          setState(() {});
                                        },
                                        child: expandButton()),
                                  ),
                              ],
                            ),
                            SizedBox(
                              height: userRole == 100 ? 30 : 33,
                            ),
                            //nama laluan
                            TextFormField(
                              style: const TextStyle(
                                fontSize: 15,
                                color: Color(0xff2B2B2B),
                                fontWeight: FontWeight.w400,
                              ),
                              controller: _namaLaluan,
                              readOnly: true,
                              enabled: false,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: textFormFieldFillColor,
                                contentPadding: userRole == 100
                                    ? const EdgeInsets.symmetric(
                                        vertical: 15, horizontal: 20)
                                    : const EdgeInsets.all(8),
                                hintText: "Laluan",
                                hintStyle: TextStyle(
                                  fontSize: 15,
                                  color: labelTextColor,
                                  fontWeight: textFormFieldLabelFontWeight,
                                ),
                                suffixIcon: iconCondition == 1
                                    ? const Icon(
                                        Icons.expand_more,
                                        size: 20,
                                        color: Color(0xff2B2B2B),
                                      )
                                    : null,
                                label: const Text('Laluan'),
                                labelStyle: TextStyle(
                                  fontSize: 15,
                                  color: labelTextColor,
                                  fontWeight: textFormFieldLabelFontWeight,
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: borderSideWidth,
                                    color: enabledBorderWithoutText,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                      borderRadiusCircular),
                                ),
                              ),
                            ),

                            SizedBox(
                              height: userRole == 100 ? 30 : 24,
                            ),
                            //no kenderaan
                            TextFormField(
                              style: const TextStyle(
                                fontSize: 15,
                                color: Color(0xff2B2B2B),
                                fontWeight: FontWeight.w400,
                              ),
                              controller: _noKenderaan,
                              readOnly: true,
                              enabled: false,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: textFormFieldFillColor,
                                contentPadding: userRole == 100
                                    ? const EdgeInsets.symmetric(
                                        vertical: 15, horizontal: 20)
                                    : const EdgeInsets.all(8),
                                hintText: "No Kenderaan",
                                hintStyle: TextStyle(
                                  fontSize: 15,
                                  color: labelTextColor,
                                  fontWeight: textFormFieldLabelFontWeight,
                                ),
                                suffixIcon: iconCondition == 1
                                    ? const Icon(
                                        Icons.expand_more,
                                        size: 20,
                                        color: Color(0xff2B2B2B),
                                      )
                                    : null,
                                label: const Text('No. Kenderaan'),
                                labelStyle: TextStyle(
                                  fontSize: 15,
                                  color: labelTextColor,
                                  fontWeight: textFormFieldLabelFontWeight,
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: borderSideWidth,
                                    color: enabledBorderWithoutText,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                      borderRadiusCircular),
                                ),
                              ),
                            ),
                            Expandable(
                              collapsed: Container(
                                width: 0,
                              ),
                              expanded: PraSectionReportForm(
                                key: praSectionKey,
                                screen: widget.screen,
                                subLaluanKey: namaSubLaluanKey,
                                tamanKey: namaTamanKey,
                                jalanKey: namaJalanKey,
                                jenisHalanganKey: jenisHalanganKey,
                                data: currReportData,
                                scMainId: userRole == 100
                                    ? widget.passData?.id
                                    : widget.passData?.scMainId,
                                updateButton: updateButtonVisibility,
                              ),
                            ),

                            //Supervisor sections
                            if (widget.screen == "4") supervisorSection(),
                            //put this at the end of the column widget list ,
                            //because to able scroll all item without being covered by the button at the bottom
                            SizedBox(
                              height: userRole == 100 ? 90 : 100,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                //button
                if (buttonVisibility) // screen 3-from Lapor Isu button and screen 6: from drawer menu
                  Positioned(
                    bottom: 0,
                    child: Material(
                      elevation: 50,
                      child: Container(
                        decoration: BoxDecoration(
                          color:
                              userRole == 100 ? const Color(0xf2f6f6f6) : white,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(.2),
                                blurRadius: 6,
                                spreadRadius: 0.5)
                          ],
                        ),
                        width: Sizes().screenWidth(context),
                        height: userRole == 100
                            ? Orientations().isTabletPortrait(context)
                                ? Sizes().screenHeight(context) * 0.065
                                : Sizes().screenHeight(context) * 0.11
                            : Sizes().screenHeight(context) * 0.1,
                        child: Center(
                          child: SizedBox(
                            width: userRole == 100
                                ? Sizes().screenWidth(context) * 0.5
                                : Sizes().screenWidth(context) * 0.8,
                            height: userRole == 100
                                ? Orientations().isTabletPortrait(context)
                                    ? Sizes().screenHeight(context) * 0.04
                                    : Sizes().screenHeight(context) * 0.07
                                : Sizes().screenHeight(context) * 0.06,
                            child: ReportSubmitButton(
                              formKey: _reportFormKey,
                              postData: postNewReport,
                              clearForm: clearForm,
                              passData: widget.passData,
                              // dataLaluan: widget.passData,
                            ),
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
    );
  }

  Widget expandButton() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xff3269F8),
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Icon(
        _expandController.expanded
            ? Icons.arrow_drop_up
            : Icons.arrow_drop_down,
        size: 20,
        color: Colors.white,
      ),
    );
  }

  Widget supervisorSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 25,
        ),
        const Divider(
          thickness: 1,
          color: Color(0xffE5E5E5),
        ),
        const SizedBox(
          height: 25,
        ),
        Text(
          "Tindakan dari Penyelia: ",
          style: TextStyle(
            fontSize: 15,
            color: blackCustom,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(
          height: 24,
        ),
        //status permohonan
        TextFormField(
          style: TextStyle(
            fontSize: 15,
            color: blackCustom,
            fontWeight: FontWeight.w400,
          ),
          controller: _statusPenyelia,
          readOnly: true,
          enabled: false,
          decoration: InputDecoration(
            filled: true,
            fillColor: textFieldFillColor,
            contentPadding: userRole == 100
                ? const EdgeInsets.symmetric(vertical: 15, horizontal: 20)
                : const EdgeInsets.all(8),
            label: const Text("Status"),
            labelStyle: TextStyle(
              fontSize: 15,
              color: labelTextColor,
              fontWeight: textFormFieldLabelFontWeight,
            ),
            disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: borderSideWidth,
                color: enabledBorderWithoutText,
              ),
              borderRadius: BorderRadius.circular(borderRadiusCircular),
            ),
          ),
        ),

        const SizedBox(
          height: 24,
        ),
        //Maklumbalas penyelia
        TextFormField(
          style: TextStyle(
            fontSize: 15,
            color: blackCustom,
            fontWeight: FontWeight.w400,
          ),
          controller: _maklumbalasPenyelia,
          readOnly: true,
          enabled: false,
          minLines: 1,
          maxLines: 5,
          decoration: InputDecoration(
            filled: true,
            fillColor: textFieldFillColor,
            contentPadding: userRole == 100
                ? const EdgeInsets.symmetric(vertical: 15, horizontal: 20)
                : const EdgeInsets.all(8),
            label: const Text("Maklumbalas Penyelia"),
            labelStyle: TextStyle(
              fontSize: 15,
              color: labelTextColor,
              fontWeight: textFormFieldLabelFontWeight,
            ),
            disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: borderSideWidth,
                color: enabledBorderWithoutText,
              ),
              borderRadius: BorderRadius.circular(borderRadiusCircular),
            ),
          ),
        ),
      ],
    );
  }
}
