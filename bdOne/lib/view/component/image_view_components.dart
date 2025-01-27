import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../theme/AppColor.dart';

class ImageViewComponent extends StatefulWidget {
  late final String? imageUrl;
  late final String placeholderImage;
  late final double width;
  late final double height;
  late final BorderRadius borderRadius;
  late final bool isDarkMode;

  ImageViewComponent({
    required this.imageUrl,
    required this.placeholderImage,
    required this.width,
    required this.height,
    required this.borderRadius,
    required this.isDarkMode,
  });

  @override
  _ImageViewComponentState createState() => _ImageViewComponentState();
}

class _ImageViewComponentState extends State<ImageViewComponent> {
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return widget.imageUrl == ""
        ? Container(
            decoration: BoxDecoration(
                borderRadius: widget.borderRadius, color: AppColor.PRIMARY),
            child: ClipRRect(
              borderRadius: widget.borderRadius,
              child: Image.asset(
                "${widget.placeholderImage}",
                width: widget.width,
                height: widget.height,
                fit: BoxFit.contain,
              ),
            ),
          )
        : Container(
            decoration: BoxDecoration(
              borderRadius: widget.borderRadius,
              border:
                  Border.all(color: Theme.of(context).cardColor, width: 0.3),
              color:
                  widget.isDarkMode ? AppColor.DARK_CARD_COLOR : Colors.white,
            ),
            child: ClipRRect(
              borderRadius: widget.borderRadius,
              child: Image.network(
                "${widget.imageUrl}",
                width: widget.width,
                height: widget.height,
                fit: BoxFit.contain,
                errorBuilder: (BuildContext context, Object exception,
                    StackTrace? stackTrace) {
                  return Container(
                    child: ClipRRect(
                      borderRadius: widget.borderRadius,
                      child: Image.asset(
                        "${widget.placeholderImage}",
                        width: widget.width,
                        height: widget.height,
                        fit: BoxFit.contain,
                      ),
                    ),
                  );
                },
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  } else {
                    return Shimmer.fromColors(
                      baseColor: Colors.white38,
                      highlightColor: widget.isDarkMode
                          ? AppColor.DARK_CARD_COLOR
                          : Colors.grey,
                      child: Container(
                        decoration: BoxDecoration(
                            color: widget.isDarkMode
                                ? AppColor.DARK_CARD_COLOR
                                : Colors.white,
                            borderRadius: widget.borderRadius),
                        width: widget.width,
                        height: widget.height,
                      ),
                    );
                  }
                },
              ),
            ),
          );
  }
}
