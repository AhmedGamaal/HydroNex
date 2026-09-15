import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hydronex_app/features/alerts/cubit/alert/alert_cubit.dart';
import 'package:hydronex_app/features/alerts/cubit/alert/alert_service.dart';
import 'package:hydronex_app/features/aibot/view/tab/ai_bot_tab.dart';
import 'package:hydronex_app/features/analysis/view/tab/analysis_tab.dart';
import 'package:hydronex_app/features/crops/cubit/crop/crop_cubit.dart';
import 'package:hydronex_app/features/crops/data/crop_service.dart';
import 'package:hydronex_app/features/home/view/tab/home_tab.dart';
import 'package:hydronex_app/features/home/view/widgets/nav_bar_border.dart';
import 'package:hydronex_app/features/home/view/widgets/nav_bar_icon.dart';
import 'package:hydronex_app/features/profile/view/tab/profile_tab.dart';
import 'package:hydronex_app/features/plant_vision/view/screens/camera_screen.dart';
import '../../../../core/routes/app_routes.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = AppRoutes.home;

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final PageController pageController;
  late final CropCubit cropCubit;
  late final AlertCubit alertCubit;

  int currentIndex = 0;

  final List<Widget> tabs = [
    const HomeTab(),
    AnalysisTab(),
    AiBotTab(),
    ProfileTab(),
  ];

  @override
  void initState() {
    super.initState();

    pageController = PageController();

    cropCubit = CropCubit(repository: CropService.createRepository());

    alertCubit = AlertCubitService.create();
  }

  @override
  void dispose() {
    pageController.dispose();
    cropCubit.close();
    alertCubit.close();
    super.dispose();
  }

  void openPlantVision() {
    final crops = cropCubit.state.crops;

    if (crops.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No crop found. Please add a crop first.'),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CameraScreen(cropId: crops.first.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: cropCubit),
        BlocProvider.value(value: alertCubit),
      ],
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          child: PageView.builder(
            controller: pageController,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return tabs[index];
            },
          ),
        ),
        bottomNavigationBar: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: NavBarBorder(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: BottomNavigationBar(
                onTap: (index) {
                  if (currentIndex == index) return;

                  setState(() {
                    currentIndex = index;
                    HapticFeedback.lightImpact();
                  });

                  pageController.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                currentIndex: currentIndex,
                items: [
                  BottomNavigationBarItem(
                    icon: NavBarIcon(iconName: 'home'),
                    activeIcon: NavBarIcon(iconName: 'home_active'),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Transform.translate(
                      offset: const Offset(-20, 0),
                      child: NavBarIcon(iconName: 'analysis'),
                    ),
                    activeIcon: Transform.translate(
                      offset: const Offset(-20, 0),
                      child: NavBarIcon(iconName: 'analysis_active'),
                    ),
                    label: 'Analysis',
                  ),
                  BottomNavigationBarItem(
                    icon: Transform.translate(
                      offset: const Offset(20, 0),
                      child: NavBarIcon(iconName: 'chatbot'),
                    ),
                    activeIcon: Transform.translate(
                      offset: const Offset(20, 0),
                      child: NavBarIcon(iconName: 'chatbot_active'),
                    ),
                    label: 'ChatBot',
                  ),
                  BottomNavigationBarItem(
                    icon: NavBarIcon(iconName: 'profile'),
                    activeIcon: NavBarIcon(iconName: 'profile_active'),
                    label: 'Profile',
                  ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: Transform.translate(
          offset: Offset(0, 20 + MediaQuery.viewInsetsOf(context).bottom),
          child: FloatingActionButton(
            onPressed: openPlantVision,
            child: SvgPicture.asset('assets/icons/camera.svg'),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}
