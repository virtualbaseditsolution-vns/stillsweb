import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stillsweb/model/select_image_model.dart';

class SelectedImageUploading extends StatefulWidget {
  final List<SelectedImage>? images;

  const SelectedImageUploading({Key? key, this.images}) : super(key: key);

  @override
  State<SelectedImageUploading> createState() => _SelectedImageUploadingState();
}

class _SelectedImageUploadingState extends State<SelectedImageUploading> {
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    uploading();
  }

  uploading() async {
    for (var i = 0; i < widget.images!.length; i++) {
      if (widget.images![i].status != Status.failed) {
        setState(() {
          widget.images![i].status = Status.processing;
        });
        await Future.delayed(const Duration(seconds: 10), () {
          if (i % 3 == 0) {
            setState(() {
              widget.images![i].status = Status.done;
            });
          } else if (i % 2 == 0) {
            setState(() {
              widget.images![i].status = Status.failed;
            });
          } else {
            setState(() {
              widget.images![i].status = Status.done;
            });
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    List<SelectedImage>? images = widget.images;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 150,
              child: Center(
                child: Text(
                  "Uploading Selected Images",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade600),
                ),
              ),
            ),
            Expanded(
              child: GridView.extent(
                maxCrossAxisExtent: 150.0,
                children: List.generate(widget.images!.length, (index) {
                  return Container(
                    decoration: BoxDecoration(color: Colors.grey.shade50),
                    child: Padding(
                      padding: const EdgeInsets.all(2.5),
                      child: Stack(
                        alignment: Alignment.center,
                        fit: StackFit.passthrough,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Image.file(
                              File(images![index].image.path),
                              fit: BoxFit.cover,
                            ),
                          ),

                          /// Showing uploading status is done
                          Positioned(
                            top: 0,
                            right: 0,
                            bottom: 0,
                            left: 0,
                            child:

                                /// Checking Status is done
                                (images[index].status == Status.done)
                                    ? done(index)

                                    /// Checking status is pending
                                    : (images[index].status == Status.pending)
                                        ? pending(index)

                                        /// Checking status is processing
                                        : (images[index].status ==
                                                Status.processing)
                                            ? processing(index)

                                            /// Checking status is failed
                                            : (images[index].status ==
                                                    Status.failed)
                                                ? failed(index)

                                                /// is not available status
                                                : const SizedBox(),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
                controller: scrollController,
              ),
            ),

            /// Uploading Done button
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 100, vertical: 15)),
                onPressed: () {
                  Get.back();
                },
                child: const Text("DONE"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///Done Widget
  Widget done(int index) => Center(
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.8), shape: BoxShape.circle),
          child: const Icon(
            Icons.check,
            size: 25,
            color: Colors.white,
          ),
        ),
      );

  /// Pending Widget
  Widget pending(int index) => InkWell(
        onTap: () {
          setState(() {
            widget.images![index].status = Status.failed;
          });
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            const SizedBox(
                height: 50, width: 50, child: CircularProgressIndicator()),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.6), shape: BoxShape.circle),
              child: const Icon(
                Icons.close,
                size: 25,
                color: Colors.white,
              ),
            ),
          ],
        ),
      );

  /// Processing widget
  Widget processing(int index) => Stack(
        alignment: Alignment.center,
        children: [
          const SizedBox(
              height: 50,
              width: 50,
              child: CircularProgressIndicator(
                value: 0.4,
                color: Colors.green,
              )),
          InkWell(
            onTap: () {
              // setState(() {
              //   widget.images![index].status=Status.failed;
              // });
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.6), shape: BoxShape.circle),
              child: const Icon(
                Icons.close,
                size: 25,
                color: Colors.white,
              ),
            ),
          ),
        ],
      );

  /// Failed Widget
  Widget failed(int index) => Stack(
        alignment: Alignment.center,
        children: [
          InkWell(
            onTap: () async {
              setState(() {
                widget.images![index].status = Status.processing;
              });
              await Future.delayed(const Duration(seconds: 5), () {
                setState(() {
                  widget.images![index].status = Status.done;
                });
              });
            },
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.8), shape: BoxShape.circle),
              child: const Icon(
                Icons.upload_outlined,
                size: 25,
                color: Colors.amber,
              ),
            ),
          ),
        ],
      );
}
