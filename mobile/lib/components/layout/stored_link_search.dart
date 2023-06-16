import 'package:flutter/material.dart';
import 'package:mobile/theme/colors.dart';

class StoredLinkSearch extends StatelessWidget {
  final TextEditingController controller;
  final Function setState;
  const StoredLinkSearch(
      {super.key, required this.controller, required this.setState});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: (_) {
        setState(() {});
      },
      decoration: InputDecoration(
        hintText: "Rechercher un lien",
        suffixIcon: const Icon(Icons.search, color: DoggoColors.secondary),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24),
            borderSide: const BorderSide(color: DoggoColors.darkSecondary)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: const BorderSide(width: 4, color: DoggoColors.secondary),
        ),
      ),
    );
  }
}
