import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io' as io;
import 'package:image_picker/image_picker.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedImage = "";
  TextEditingController _controller = TextEditingController();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text("Image to Base64 Converter "),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
                child: GestureDetector(
              onTap: () {
                setState(() {
                  isLoading = true;
                });

                imagePickFromDevice();
              },
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.blueGrey)),
                child: selectedImage.isEmpty
                    ? const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.image_outlined,
                            size: 100,
                            color: Colors.blueGrey,
                          ),
                          Text(
                            "Import Image",
                            style: TextStyle(
                                color: Colors.blueGrey,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.memory(
                          base64.decode(selectedImage),
                          fit: BoxFit.fill,
                        ),
                      ),
              ),
            )),
            const SizedBox(
              height: 20,
            ),
            // Padding(
            //     padding: const EdgeInsets.symmetric(vertical: 10),
            //     child: Container(
            //       height: 50,
            //       width: double.infinity,
            //       decoration: BoxDecoration(
            //         color: Colors.blueGrey,
            //         borderRadius: BorderRadius.circular(20),
            //       ),
            //       alignment: Alignment.center,
            //       child: const Text(
            //         "Convert",
            //         style: TextStyle(
            //             color: Colors.white,
            //             fontSize: 18,
            //             fontWeight: FontWeight.bold),
            //       ),
            //     )),
            Expanded(
                child: selectedImage.isEmpty
                    ? const SizedBox()
                    : Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, top: 40),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.blueGrey)),
                            child: TextField(
                              maxLines: 50,
                              enabled: false,
                              controller: _controller,
                              decoration: const InputDecoration(
                                  border: InputBorder.none),
                            ),
                          ),
                          Positioned(
                              right: 0,
                              child: IconButton.outlined(
                                  color: Colors.blueGrey,
                                  onPressed: ()async {
                                    await Clipboard.setData(ClipboardData(text: _controller.text));
                                  },
                                  icon: const Icon(Icons.copy)))
                        ],
                      ))
          ],
        ),
      ),
    );
  }

  void imagePickFromDevice() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? photo = await picker.pickImage(
        source: ImageSource.gallery,
      );
      final bytes = io.File(photo!.path.toString()).readAsBytesSync();
      String img641 = base64Encode(bytes);
      String img64 = img641.replaceAll(RegExp(r"\s+"), "");
      setState(() {
        selectedImage = img64;
        _controller.text = selectedImage;
        isLoading = false;
      });
    } on PlatformException catch (e) {
      debugPrint('Unsupported operation$e');
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
