import 'package:flutter/material.dart';
import 'package:mathgasing/models/materi/materi.dart';
import 'package:mathgasing/screens/main_screen/map_unit_level/pages/map_screen/pages/map_unit_level.dart';
import 'package:mathgasing/core/color/color.dart';


class CardWidget extends StatelessWidget {
  const CardWidget({
    super.key,
    required this.materi,
    });

  final Materi materi;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) {
            return MapUnitLevel(materi: materi);
          }),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          elevation: 12,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          color: Colors.white,
          child: Column(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(20),
                  topLeft: Radius.circular(20),
                ),
                child: Image.network(
                  'http://127.0.0.1:8000/storage/${materi.imageCard.replaceFirst('public/', '')}',
                  height: 150,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
              ListTile(
                title: Text(
                  materi.title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
