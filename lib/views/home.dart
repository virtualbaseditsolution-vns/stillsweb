import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stillsweb/model/select_image_model.dart';
import 'package:stillsweb/views/selected_image.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ScrollController scrollController = ScrollController();
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          pickImage();
        },
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              SizedBox(
                  height: 100,
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.menu,size: 30,color: Colors.grey.shade600,),
                        onPressed: (){},
                      ),
                      const SizedBox(width: 10,),
                      Expanded(
                          child: Text("StillsWeb",style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade600
                          ),),
                      ),
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: Colors.blueAccent,
                          shape: BoxShape.circle
                        ),
                        child: const CircleAvatar(
                          radius: 24,
                          backgroundImage: NetworkImage("https://i.pravatar.cc/50?i=19"),
                        ),
                      )
                    ],
                  )),
              Expanded(
                  child: GridView.extent(
                //primary: true, // REMOVED
                maxCrossAxisExtent: 150.0,
                children: List.generate(35, (index) {
                  return Container(
                    decoration: BoxDecoration(color: Colors.grey.shade50),
                    child: Padding(
                      padding: const EdgeInsets.all(2.5),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Image.network(
                            "https://picsum.photos/200?i=$index",
                            fit: BoxFit.cover,
                          )),
                    ),
                  );
                }),
                controller: scrollController, // NEW
              ))
            ],
          ),
        ),
      ),
    );
  }

  pickImage() async {
    final List<XFile>? images = await _picker.pickMultiImage();
    List<SelectedImage> selectedImage = [];
    for (var element in images!) {
      selectedImage.add(SelectedImage(element, Status.pending));
    }
    Get.dialog(
      SelectedImageUploading(
        images: selectedImage,
      ),
      barrierDismissible: false,
      useSafeArea: true,
    );
  }
}
