import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PickImageWidget extends StatelessWidget {
  const PickImageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FadeInDown(
      duration: Duration(milliseconds: 300),
      child: CircleAvatar(
        radius: 70.r,
        backgroundColor: Colors.grey.shade200,
        backgroundImage: const AssetImage("assets/avatar.png"),
        child: Stack(
          children: [
            Positioned(
              bottom: 5.h,
              right: 5.w,
              child: GestureDetector(
                onTap: () async {
                  // handleImagePicker();
                },
                child: Container(
                  height: 45.h,
                  width: 45.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xff390050),
                    border: Border.all(color: Colors.white, width: 3),
                  ),
                  child: GestureDetector(
                    onTap: () {},
                    child: const Icon(
                      Icons.camera_alt_sharp,
                      color: Colors.white,
                      size: 25,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
