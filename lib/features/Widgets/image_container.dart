import 'dart:io';

import 'package:flutter/material.dart';

import '../../core/Utilits/colors.dart';
import '../../core_new/widgets/custom_image.dart';

class ImageContainer extends StatelessWidget {
  final String imagePath;
  final VoidCallback onImagePressed;
  final bool isLoading;

  const ImageContainer({
    super.key,
    required this.imagePath,
    required this.onImagePressed,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: onImagePressed,
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: weevoDarkGreyColor,
                  borderRadius: BorderRadius.circular(
                    25.0,
                  ),
                ),
                height: size.width * 0.4,
                width: size.width * 0.4,
                child: imagePath.isEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(
                          25.0,
                        ),
                        child: Image.asset(
                          'assets/images/profile_picture.png',
                        ),
                      )
                    : imagePath.contains('merchants')
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(
                              25.0,
                            ),
                            child: CustomImage(
                              imageUrl: imagePath,
                            ),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(
                              25.0,
                            ),
                            child: Image.file(
                              File(imagePath),
                              fit: BoxFit.fill,
                            ),
                          ),
              ),
              isLoading
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(25.0),
                      child: Container(
                        color: Colors.black.withOpacity(
                          0.6,
                        ),
                        height: size.width * 0.4,
                        width: size.width * 0.4,
                        child: const Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              weevoPrimaryBlueColor,
                            ),
                          ),
                        ),
                      ),
                    )
                  : Container(),
              isLoading
                  ? Container()
                  : Positioned(
                      bottom: 0.0,
                      right: 0.0,
                      child: Container(
                        width: 30.0,
                        height: 30.0,
                        decoration: BoxDecoration(
                          color: weevoPrimaryBlueColor,
                          borderRadius: BorderRadius.circular(
                            10.0,
                          ),
                        ),
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 20.0,
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ],
    );
  }
}
