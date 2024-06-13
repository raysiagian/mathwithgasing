import 'package:flutter/material.dart';
import 'package:mathgasing/core/constants/constants.dart';
import 'package:mathgasing/models/materi/materi.dart';
import 'package:mathgasing/screens/main_screen/statistic_screen/pages/statistic_detail.dart';

class StatisticWidget extends StatelessWidget {
  final Materi materi;
  final Function(Materi) onSelected;

  const StatisticWidget({
    required this.materi,
    required this.onSelected,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () {
        onSelected(materi);
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return StatisticDetail(materi: materi);
        }));
      },
      child: Container(
        height: 300,
        width: 130,
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(10),
                  topLeft: Radius.circular(10),
                ),
                child: Image.network(
                  '${materi.imageStatistic}',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 130,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    materi.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
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
