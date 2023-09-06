import 'package:flutter/widgets.dart';

class ScreenConfig {
  late MediaQueryData _mediaQueryData;
  late double blockSizeHorizontal;
  late double blockSizeVertical;
 
  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    blockSizeHorizontal = _mediaQueryData.size.width / 100;
    blockSizeVertical = _mediaQueryData.size.height / 100;
  }
}