import 'package:animate_do/animate_do.dart';
import 'package:crystal_navigation_bar/crystal_navigation_bar.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return HomeViewBody();
  }
}

class HomeViewBody extends StatelessWidget {
  const HomeViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Upload your document',
                style: GoogleFonts.inter(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 5.h,
              ),
              Text(
                'Drag and drop or browse to upload your document. We support PDF and DOCX files.',
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(
                height: 16.h,
              ),
              UploadFileContainer(),
              SizedBox(
                height: 16.h,
              ),
              Text(
                'Recent Uploads',
                style: GoogleFonts.inter(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 5.h,
              ),
              RecentItemsListView(),
            ],
          ),
        ),
      ),
    );
  }
}

class RecentItemsListView extends StatelessWidget {
  const RecentItemsListView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: const RecentItem(),
      ),
      itemCount: 5,
    );
  }
}

class RecentItem extends StatelessWidget {
  const RecentItem({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 40.w,
        height: 60.h,
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          color: Color(0xffE8EDF5),
        ),
        child: Icon(
          IconlyLight.document,
          color: Colors.grey,
          size: 25.sp,
        ),
      ),
      title: Text(
        'Document.pdf',
        style: GoogleFonts.inter(
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        'Uploaded 12/12/2023',
        style: GoogleFonts.inter(
          fontSize: 12.sp,
          color: Color(0xff4A709C),
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}

class UploadFileContainer extends StatelessWidget {
  const UploadFileContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      borderType: BorderType.RRect,
      radius: Radius.circular(10.r),
      color: Color(0xffCFD9E8),
      strokeWidth: 2,
      dashPattern: const [8, 4],
      child: Container(
        alignment: Alignment.center,
        height: 310.h,
        width: 358.w,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadiusDirectional.circular(10.r),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 16.h,
            ),
            FittedBox(
              child: Text(
                'Drag and drop your file here.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 5.h,
            ),
            Text(
              'or',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: Color(0xff0D141C),
              ),
            ),
            SizedBox(
              height: 15.h,
            ),
            Image.asset(
              'assets/robot2.png',
              height: 120.h,
              width: 100.w,
            ),
            SizedBox(
              height: 10.h,
            ),
            BrowseFileButtton(),
          ],
        ),
      ),
    );
  }
}

class BrowseFileButtton extends StatelessWidget {
  const BrowseFileButtton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        shadowColor: Colors.grey,
        backgroundColor: const Color(0xff390050),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        child: Text(
          'Browse File',
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class HomeLayout extends StatefulWidget {
  const HomeLayout({super.key});

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    const HomeView(),
    const Center(child: Text('Summary Screen')),
    const Center(child: Text('Profile Screen')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(),
      body: _pages[_currentIndex],
      bottomNavigationBar: CustomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          FadeInDown(
            duration: Duration(milliseconds: 300),
            child: CircleAvatar(
              radius: 40.r,
              backgroundColor: Colors.grey.shade200,
              backgroundImage: const AssetImage("assets/avatar.png"),
            ),
          ),
          SizedBox(
            width: 16,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 16,
                ),
                Text(
                  'Welcome back!',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  'Mahmoud Elnagar',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(65.0);
}

class CustomNavBar extends StatelessWidget {
  const CustomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final void Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    return CrystalNavigationBar(
      margin: EdgeInsets.zero,
      marginR: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      enablePaddingAnimation: true,
      currentIndex: currentIndex,
      onTap: onTap,
      borderRadius: 50.r,
      unselectedItemColor: Colors.white70,
      backgroundColor: const Color(0xff390050),
      outlineBorderColor: Colors.white,
      items: [
        CrystalNavigationBarItem(
          icon: IconlyBold.home,
          unselectedIcon: IconlyLight.home,
          selectedColor: Colors.white,
        ),
        CrystalNavigationBarItem(
          icon: IconlyBold.paper,
          unselectedIcon: IconlyLight.paper,
          selectedColor: Colors.white,
        ),
        CrystalNavigationBarItem(
          icon: IconlyBold.profile,
          unselectedIcon: IconlyLight.profile,
          selectedColor: Colors.white,
        ),
      ],
    );
  }
}
