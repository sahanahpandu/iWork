// ignore_for_file: must_be_immutable

import 'package:eswm/config/string.dart';
import 'package:flutter/material.dart';

import '../../config/font.dart';
import '../../config/palette.dart';
import 'package:eswm/providers/taman_api.dart';

class ListOfParks extends StatefulWidget {
  Function(dynamic)? showSenaraiJalan;
  String hintText;
  double fontSize;
  int borderCondition;
  Color fillColor;
  int iconCondition;
  String data;

  ListOfParks(
      {Key? key,
      required this.showSenaraiJalan,
      required this.hintText,
      required this.fontSize,
      required this.borderCondition,
      required this.fillColor,
      required this.iconCondition,
      required this.data})
      : super(key: key);

  @override
  State<ListOfParks> createState() => _ListOfParksState();
}

class _ListOfParksState extends State<ListOfParks> {
  final TextEditingController _namaTaman = TextEditingController();

  int totalTaman = 0;

  getTotalData() {
    TamanApi.getTamanData(context).then((value) {
      if (value.isNotEmpty) {
        setState(() {
          totalTaman = value.length;
        });
      }
    });

    if (widget.data != "") {
      setState(() {
        _namaTaman.text = widget.data;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getTotalData();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (widget.iconCondition == 1) {
          showListOfParks();
        }
      },
      child: TextFormField(
        controller: _namaTaman,
        readOnly: true,
        enabled: false,
        decoration: InputDecoration(
          filled: true,
          fillColor: widget.fillColor,
          contentPadding: const EdgeInsets.all(8),
          hintText: widget.hintText,
          hintStyle: TextStyle(
            fontSize: widget.fontSize,
            color: labelTextColor,
            fontWeight: textFormFieldLabelFontWeight,
          ),
          suffixIcon: widget.iconCondition == 1
              ? const Icon(
                  Icons.arrow_drop_down,
                  size: 30,
                  color: Colors.black87,
                )
              : null,
          labelText: widget.borderCondition == 1 && widget.iconCondition == 1
              ? widget.hintText
              : null,
          labelStyle: widget.borderCondition == 1 && widget.iconCondition == 1
              ? TextStyle(
                  fontSize: widget.fontSize,
                  color: labelTextColor,
                  fontWeight: textFormFieldLabelFontWeight,
                )
              : null,
          disabledBorder: OutlineInputBorder(
            borderSide: widget.borderCondition == 0
                ? BorderSide.none
                : BorderSide(
                    width: borderSideWidth,
                    color: _namaTaman.text != '' && widget.iconCondition == 1
                        ? enabledBorderWithText
                        : enabledBorderWithoutText,
                  ),
            borderRadius: BorderRadius.circular(borderRadiusCircular),
            gapPadding: 6.0,
          ),
        ),
      ),
    );
  }

  Widget? showListOfParks() {
    showModalBottomSheet(
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        context: context,
        builder: (builder) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 25,
                    left: 25,
                    bottom: 10,
                  ),
                  child: Text(
                    "${totalTaman.toString()} Senarai Taman",
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                FutureBuilder<List>(
                  future: TamanApi.getTamanData(context),
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
                            child: Text("Some error occured!"),
                          );
                        } else {
                          return Expanded(
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              padding: const EdgeInsets.all(6),
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: dataFuture!.length,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () {
                                      if (widget.showSenaraiJalan != null) {
                                        widget.showSenaraiJalan!(
                                            dataFuture[index].id);
                                      }

                                      setState(() {
                                        _namaTaman.text =
                                            dataFuture[index].namaTaman;

                                        Navigator.pop(context);
                                      });
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 12),
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          top: BorderSide.none,
                                          bottom: BorderSide(
                                            color: grey400,
                                            width: 0.9,
                                            style: BorderStyle.solid,
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        dataFuture[index].namaTaman,
                                        style: const TextStyle(
                                          color: Colors.black87,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        }
                    }
                  },
                ),
              ],
            ),
          );
        });
    return null;
  }
}
