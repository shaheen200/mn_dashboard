import 'package:flutter/material.dart';

double pageSizeWidth(BuildContext context, double w) {
  return MediaQuery.of(context).size.width * w;
}

double pageSizeHeight(BuildContext context, double h) {
  return MediaQuery.of(context).size.height * h;
}
