import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
class ImageReader extends StatefulWidget {
  const ImageReader({super.key, File? selectedImage });

  @override
  State<ImageReader> createState() => _ImageReaderState();
}

class _ImageReaderState extends State<ImageReader> {
  File? selectedImage;
  Uint8List? _imageBytes;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => selectImage(context),
      child: const Text("Select Image"),

    );
  }

  void selectImage(BuildContext context) {
    showModalBottomSheet(
        context: context, builder:( builder) {
          return  Card(
            child: Container(
              color: const Color(0xFFE1E8D7),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height*1/6,
              padding: const EdgeInsets.all(20),
              child:  Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      width: 100,
                      height: 70,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xDA000000), // Border color
                          width: 2.0, // Border width
                        ),
                      ),

                      child: const Column(
                        children: [
                          Icon(Icons.camera_alt_outlined),
                          Text("Camera")
                        ],
                      ),
                    ),
                    onTap: (){
                      openCamera();
                    },
                  ),
                  InkWell(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      width: 100,
                      height: 70,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xDA000000), // Border color
                          width: 2.0, // Border width
                        ),
                      ),

                      child: const Column(
                        children: [
                          Icon(Icons.photo_album_outlined),
                          Text("Gallery")
                        ],
                      ),
                    ),
                    onTap: (){
                      openGallery();
                    },
                  ),
                ]
              ),
            ),
          );
    });
  }
  final picker = ImagePicker();

  openCamera()  async {
   await picker.pickImage(source: ImageSource.camera).then((value) {
     if((value)!=null) {
       convertImg(File(value.path));
     }

   });
  }

 openGallery() async {
   await picker.pickImage(source: ImageSource.gallery).then((value) {
     if ((value) != null) {
       convertImg(File(value.path));
     }
   });
  }
  convertImg(File selectedImage) async{
    // Get temporary directory
    var resizedImage = await FlutterImageCompress.compressWithFile(selectedImage.absolute.path, minHeight: 300, minWidth: 300, quality: 94);
    print("resized");



      String base64Image = base64Encode(resizedImage as List<int>);
      print('Base64 Image: $base64Image');
      Uint8List decodedBytes = base64Decode(base64Image);
      print('Decoded Bytes: $decodedBytes');

      setState(() {
        _imageBytes = decodedBytes;
      });
    Navigator.push(context, MaterialPageRoute(
      builder: (context) => ImageDisplay(
        selectedImageBytes: _imageBytes,
      ),
    ),

    );
    }

  }



class ImageDisplay extends StatelessWidget {
  final Uint8List? selectedImageBytes;
  const ImageDisplay({Key? key, required this.selectedImageBytes}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final decodedImage = Image.memory(selectedImageBytes!);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Display'),
      ),
      body: Center(
        child: selectedImageBytes == null
            ?const Text('No image selected')
            : decodedImage,
      ),
    );
  }
}
