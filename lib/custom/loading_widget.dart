import 'package:dous/utils/images_urls.dart';
import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(
            imgUrl,
          ),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.surface,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Text('Loading Database.....',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.surface,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
