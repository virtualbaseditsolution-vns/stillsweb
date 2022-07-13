import 'package:image_picker/image_picker.dart';

enum Status { done, failed, processing, pending }

class SelectedImage {
  XFile image;
  Status status;

  SelectedImage(this.image, this.status);
}
