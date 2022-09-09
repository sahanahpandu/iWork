import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:keyboard_visibility_pro/keyboard_visibility_pro.dart';

//import files
// import '../../config/font.dart';
import '../../config/font.dart';
import '../../config/palette.dart';
import '../../models/laluan.dart';
import '../../config/config.dart';
import '../../utils/device.dart';
import '../../models/reports.dart';
import '../../screens/reports/pra/pra_section_report_form.dart';
import '../../widgets/buttons/report_submit_button.dart';

class ReportForm extends StatefulWidget {
  final String screen;
  final Reports? data;
  final Laluan? dataLaluan;

  const ReportForm(
      {Key? key,
      required this.screen,
      required this.data,
      required this.dataLaluan})
      : super(key: key);

  @override
  State<ReportForm> createState() => _ReportFormState();
}

class _ReportFormState extends State<ReportForm> {
  final Devices _device = Devices();
  //late StreamSubscription<bool> keyboardSubscription;
  // ignore: prefer_final_fields
  ExpandableController _expandController =
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
  int borderCondition = 1;
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
    if (widget.screen == "3" || widget.screen == "4") {
      //screen 3 = from Report form, screen 4 = from Report List, screen 6 = from drawer
      setState(() {
        textFieldFillColor =
            widget.screen == "4" ? textFormFieldFillColor : Colors.white;
        iconCondition = 0;
        borderCondition = 0;
        formTitleText =
            widget.screen == "4" ? "Butiran maklumat laporan: " : formTitleText;

        _expandController.expanded = widget.screen == "3" ? true : false;
        buttonVisibility = widget.screen == "4" ? false : true;

        //nama laluan
        (widget.screen == "3" &&
                widget.dataLaluan!.namaLaluan !=
                    "") // from button Report in work shedule details
            ? _namaLaluan.text = widget.dataLaluan!.namaLaluan
            : (widget.screen == "4" &&
                    widget.data!.namaLaluan != "") // from report list
                ? _namaLaluan.text = widget.data!.namaLaluan
                : _namaLaluan.text = namaLaluan;

        //no kenderaan
        (widget.screen == "3" &&
                widget.dataLaluan!.noKenderaan !=
                    "") // from button Report in work shedule details
            ? _noKenderaan.text = widget.dataLaluan!.noKenderaan
            : (widget.screen == "4" &&
                    widget.data!.noKenderaan != "") // from report list
                ? _noKenderaan.text = widget.data!.noKenderaan
                : _noKenderaan.text = noKenderaan;
      });
    }
  }

  clearForm() {
    _reportFormKey.currentState!.reset();
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
                SingleChildScrollView(
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  child: Container(
                    margin: userRole != 100
                        ? const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 5)
                        : (userRole == 100 &&
                                _device.isLandscape(
                                    context)) // condition for compactor panel
                            ? const EdgeInsets.fromLTRB(100, 80, 100, 150)
                            : const EdgeInsets.symmetric(
                                horizontal: 80, vertical: 60),
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
                              label: Container(
                                color: Colors.white,
                                child: const Text('Laluan'),
                              ),
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
                                borderRadius:
                                    BorderRadius.circular(borderRadiusCircular),
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
                              label: Container(
                                color: Colors.white,
                                child: const Text('No. Kenderaan'),
                              ),
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
                                borderRadius:
                                    BorderRadius.circular(borderRadiusCircular),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: userRole == 100 ? 30 : 0,
                          ),
                          Expandable(
                            collapsed: Container(
                              width: 0,
                            ),
                            expanded: PraSectionReportForm(
                              screen: widget.screen,
                              data: widget.data,
                              updateButton: updateButtonVisibility,
                            ),
                          ),

                          //Supervisor sections
                          if (widget.screen == "4") supervisorSection(),
                          //put this at the end of the column widget list ,
                          //because to able scroll all item without being covered by the button at the bottom
                          const SizedBox(
                            height: 100,
                          ),
                        ],
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
                        color: Colors.white,
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.1,
                        child: Center(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.8,
                            height: MediaQuery.of(context).size.height * 0.06,
                            child: ReportSubmitButton(
                              formKey: _reportFormKey,
                              clearForm: clearForm,
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
          height: 32,
        ),
        const Divider(
          thickness: 1,
          color: Color(0xffE5E5E5),
        ),
        const SizedBox(
          height: 32,
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
            label: Container(
              color: Colors.white,
              child: const Text("Status"),
            ),
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
            label: Container(
              color: Colors.white,
              child: const Text("Maklumbalas Penyelia"),
            ),
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
