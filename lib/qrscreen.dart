import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sizer/sizer.dart';

class QRCodeGenerator extends StatefulWidget {
  static const String routeName = 'QRCodeScreen';

  const QRCodeGenerator({super.key});

  @override
  State<QRCodeGenerator> createState() => _QRCodeGeneratorState();
}

class SizeConfig {
  double widthSize(BuildContext context, double value) {
    value /= 50;
    return MediaQuery.of(context).size.width * value;
  }

  double heigthSize(BuildContext context, double value) {
    value /= 100;
    return MediaQuery.of(context).size.width * value;
  }
}

class _QRCodeGeneratorState extends State<QRCodeGenerator> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  final key = GlobalKey();
  File? file;
  final TextEditingController _qrCodeName = TextEditingController();
  final TextEditingController _urlLink = TextEditingController();
  String qrData = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          shadowColor: Colors.transparent,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                      Color(0xFF3366FF),
                      Color(0xFF00CCFF),
                    ],
                    begin: FractionalOffset(0.0, 0.0),
                    end: FractionalOffset(1.0, 0.0),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp)),
          ),
          title: const Center(
            child: Text(
              'QRCode Generator',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        body: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
          child: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFC492B1),
                Color(0xFFfbfbfb),
                Color(0xffbbcaff),
              ],
            )),
            child: Padding(
              padding: const EdgeInsets.only(right: 40.0, left: 40.0),
              child: Center(
                child: SingleChildScrollView(
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.black54),
                        color: Colors.black26),
                    // width: SizeConfig().widthSize(context, 70),
                    // height: SizeConfig().heigthSize(context, 50),
                    width: 350,
                    height: 330,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 20, right: 20, bottom: 20, left: 20),
                      child: Form(
                        key: _formkey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Align(
                              alignment: Alignment.bottomLeft,
                              child: Text(
                                'QRCode Title:',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: _qrCodeName,
                              keyboardType: TextInputType.text,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w300),
                              textCapitalization: TextCapitalization.words,
                              decoration: const InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 15,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white70),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.white, width: 1),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const Align(
                              alignment: Alignment.bottomLeft,
                              child: Text(
                                'URL: ',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: _urlLink,
                              keyboardType: TextInputType.url,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 16),
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 15,
                                ),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white70),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.white, width: 1),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                  borderSide: const BorderSide(
                                    color: Colors.red,
                                    width: 2.0,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'This field is required';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            ElevatedButton(
                                onPressed: () async {
                                  setState(() {
                                    qrData = _urlLink.text;
                                  });

                                  if (_formkey.currentState!.validate()) {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Dialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 10.0,
                                                right: 30,
                                                bottom: 10,
                                                left: 30),
                                            // ignore: sized_box_for_whitespace
                                            child: SingleChildScrollView(
                                              child: SizedBox(
                                                width: 35.w,
                                                height: 350,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 0,
                                                              bottom: 0),
                                                      child: RepaintBoundary(
                                                        key: key,
                                                        child: Container(
                                                          color: Colors.white,
                                                          child: Column(
                                                            children: [
                                                              _qrCodeName.text
                                                                      .isEmpty
                                                                  ? Container(
                                                                      height: 0,
                                                                    )
                                                                  : Text(
                                                                      _qrCodeName
                                                                          .text,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      maxLines:
                                                                          2,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style: const TextStyle(
                                                                          height:
                                                                              1,
                                                                          fontSize:
                                                                              22,
                                                                          color: Colors
                                                                              .black,
                                                                          fontWeight:
                                                                              FontWeight.w700),
                                                                    ),
                                                              _qrCodeName.text
                                                                          .isEmpty &&
                                                                      qrData
                                                                          .isEmpty
                                                                  ? Container(
                                                                      height: 0,
                                                                    )
                                                                  : Container(
                                                                      height:
                                                                          10,
                                                                    ),
                                                              Text(
                                                                qrData,
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                maxLines: 3,
                                                                style: const TextStyle(
                                                                    height: 1,
                                                                    fontSize:
                                                                        14,
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal),
                                                              ),
                                                              QrImageView(
                                                                data: qrData,

                                                                eyeStyle: const QrEyeStyle(
                                                                    eyeShape:
                                                                        QrEyeShape
                                                                            .square,
                                                                    color: Colors
                                                                        .blue),
                                                                // data: _QRCodeName.text,
                                                                version:
                                                                    QrVersions
                                                                        .auto,
                                                                backgroundColor:
                                                                    Colors
                                                                        .white,
                                                                size: 200.0,
                                                                errorStateBuilder:
                                                                    (cxt, err) {
                                                                  return const Center(
                                                                    child: Text(
                                                                      'Uh oh! Something went wrong...',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                    ),
                                                                  );
                                                                },
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    ElevatedButton.icon(
                                                        onPressed: () async {
                                                          RenderRepaintBoundary
                                                              boundary =
                                                              key.currentContext!
                                                                      .findRenderObject()
                                                                  as RenderRepaintBoundary;

                                                          var image =
                                                              await boundary
                                                                  .toImage(
                                                                      pixelRatio:
                                                                          2.0);

                                                          ByteData? byteData =
                                                              await image.toByteData(
                                                                  format:
                                                                      ImageByteFormat
                                                                          .png);

                                                          Uint8List pngBytes =
                                                              byteData!.buffer
                                                                  .asUint8List();

                                                          final appDir =
                                                              await getApplicationDocumentsDirectory();

                                                          var datetime =
                                                              DateTime.now()
                                                                  .toString()
                                                                  .substring(
                                                                      0, 10);
                                                          // String imagePath = Platform
                                                          //         .isWindows
                                                          //     ? '${appDir.path}\\$datetime.png'
                                                          //     : '${appDir.path}/$datetime.png';

                                                          String
                                                              firstThreeLetters =
                                                              qrData.substring(
                                                                  0, 1);

                                                          file = await File(
                                                                  '${appDir.path}\\$firstThreeLetters $datetime.png')
                                                              .create();

                                                          //appending data
                                                          await file
                                                              ?.writeAsBytes(
                                                                  pngBytes);

                                                          await Share
                                                              .shareFiles(
                                                            [file!.path],
                                                            subject: datetime,
                                                            mimeTypes: [
                                                              "image/png"
                                                            ],
                                                          );
                                                        },
                                                        icon: const Icon(
                                                            Icons.share),
                                                        label:
                                                            const Text('Share'))
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  }
                                },
                                child: const Text('Generate QRCode'))
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
