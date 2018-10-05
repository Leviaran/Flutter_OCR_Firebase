import 'package:flutter/material.dart';

import 'dart:async';
import 'dart:io';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'detector_painter.dart';

void main() => runApp(new MaterialApp(home: new _MyHomePage()));

class _MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<_MyHomePage> {
  File _imageFile;
  Size _imageSize;
  List<dynamic> _scanResult;
  String text = "Hasil";
  bool _visibility = true;

  Future<void> _getImage() async {
    setState(() {
      _imageFile = null;
      _imageSize = null;
    });

    final File imageFile =
        await ImagePicker.pickImage(source: ImageSource.camera);

    if (imageFile != null) {
      _getImageSize(imageFile);
      _scanImage(imageFile);
    }

    setState(() {
      _imageFile = imageFile;
    });
  }

  Future<void> _getImageSize(File fileImage) async {
    final Completer<Size> completer = new Completer<Size>();

    final Image image = new Image.file(fileImage);
    image.image
        .resolve(const ImageConfiguration())
        .addListener((ImageInfo info, bool _) {
      completer.complete(
          Size(info.image.width.toDouble(), info.image.height.toDouble()));
    });

    final Size sizeImage = await completer.future;

    setState(() {
      _imageSize = sizeImage;
    });
  }

  Future<String> textScaned(List<TextBlock> listString) async {
    StringBuffer buffer = new StringBuffer();
    listString.forEach((item) {
      buffer.write(item.text);
    });
    setState(() {
      text = buffer.toString();
    });
  }

  Future<void> _scanImage(File imageFile) async {
    setState(() {
      _scanResult = null;
    });

    final FirebaseVisionImage visionImage =
        FirebaseVisionImage.fromFile(imageFile);
    final FirebaseVisionDetector textDetector =
        FirebaseVision.instance.textDetector();

    final List<TextBlock> result =
        await textDetector.detectInImage(visionImage) ?? <dynamic>[];

    textScaned(result);

    setState(() {
      _scanResult = result;
      _visibility = false;
    });
  }

  Widget _buildImage() {
    return new Container(
      child: SingleChildScrollView(
          child: new ConstrainedBox(
        constraints: new BoxConstraints(),
        child: new Column(
          children: <Widget>[
            new Container(
                constraints: BoxConstraints.expand(height: 700.0),
                decoration: new BoxDecoration(
                    image: new DecorationImage(
                        image: Image.file(_imageFile).image, fit: BoxFit.fill)),
                child: _imageSize == null || _scanResult == null
                    ? const Center(
                        child: Text('Loading scan Image',
                            style:
                                TextStyle(color: Colors.green, fontSize: 30.0)),
                      )
                    : _buildResult(_imageSize, _scanResult)),
            // new Image(
            //   image: Image.file(_imageFile).image,
            //   fit: BoxFit.fill,
            // ),
            // _buildResult(_imageSize, _scanResult)
            new Container(
              padding: const EdgeInsets.all(10.0),
              child: new Text(text, textAlign: TextAlign.center),
            ),
          ],
        ),
      )),
    );
  }

  // String getTextDetection(List<TextBlock> listString) {
  //   var buffer = new StringBuffer();
  //   listString.forEach((item) {
  //     buffer.write(item);
  //   });
  // }

  CustomPaint _buildResult(Size imageSize, List<dynamic> result) {
    CustomPainter painter;
    painter = new TextDetectorPainter(imageSize, result);
    return new CustomPaint(painter: painter);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: const Text("ML Kit Flutter"),
      ),
      body: _imageFile == null
          ? const Center(
              child: Text("No image Selected"),
            )
          : _buildImage(),
      floatingActionButton: new Opacity(
        opacity: _visibility ? 1.0 : 0.0,
        child: new FloatingActionButton(
          onPressed: _getImage,
          tooltip: "picking image",
          child: const Icon(Icons.add_a_photo),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
