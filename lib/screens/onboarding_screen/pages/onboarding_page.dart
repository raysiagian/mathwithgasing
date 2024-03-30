import 'package:flutter/material.dart';
import 'package:mathgasing/screens/auth/login_screen/pages/login_page.dart';
import 'package:mathgasing/screens/onboarding_screen/models/onboarding_model.dart';
import 'package:mathgasing/screens/onboarding_screen/widget/lewati_onboarding_button_widget.dart';
import 'package:mathgasing/screens/onboarding_screen/widget/onboarding_widget.dart';
import 'package:mathgasing/screens/onboarding_screen/widget/selanjutnya_onnboarding_button_widget.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({Key? key}) : super(key: key);

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  final List<OnboardingModel> listOnboarding = OnboardingModel.listOnboarding;
  final PageController _pageController = PageController();
  bool _hasReachEnd = false;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!.toInt();
        _hasReachEnd = _currentPage == listOnboarding.length - 1;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!_hasReachEnd)
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 15, top: 15),
                  child: LewatiButton(
                    onPressed: () {
                      _pageController.jumpToPage(listOnboarding.length - 1);
                    },
                  ),
                ),
              ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: listOnboarding.length,
                itemBuilder: (context, index) {
                  return OnboardingWidget(onboarding: listOnboarding[index]);
                },
              ),
            ),
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: SelanjutnyaOnboardingButton(
                onboardingSelanjutnya: () {
                  if (_currentPage >= listOnboarding.length - 1) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Login()),
                    );
                  } else {
                    _pageController.nextPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.ease,
                    );
                  }
                },
              ),
            ),
            SizedBox(height: 60),
          ],
        ),
      ),
    );
  }
}
