import 'package:flutter/material.dart';

class OfferBanner extends StatelessWidget {
  const OfferBanner({super.key, required this.offerImage});

  final String offerImage;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(25),
          ),
          width: 350,
          child: Stack(
            children: [
              Image.network(
                offerImage,
                width: 350,
                height: 200,
                fit: BoxFit.fill,
              ),
            ],
          ),
        ),
        const SizedBox(
          width: 20,
        )
      ],
    );
  }
}
