import 'package:flutter/material.dart';
import 'package:mathgasing/core/color/color.dart';

class DialogLogout extends StatelessWidget {
  const DialogLogout({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image.asset(
            'assets/images/custom_dialog_image_for_logout.png',
            fit: BoxFit.fitWidth,
          ),
          SizedBox(height: 20),
          Text(
            'Kamu Yakin Ingin\nBerhenti',
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Text(
            'Progress pengerjaanmu akan hilang',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                // onTap: () {
                //   Navigator.pushAndRemoveUntil(
                //     context,
                //     MaterialPageRoute(builder: (context) {
                //       return MapUnitLevel(
                //         materi: materi,
                //       );
                //     }),
                //     (route) => false,
                //   );
                // },
                child: Container(
                  height: 44,
                  width: 130,
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  decoration: BoxDecoration(
                    color: AppColors.logoutColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'Keluar',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 30),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  height: 44,
                  width: 130,
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'Batal',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 30),
        ],
      ),
    );
  }
}