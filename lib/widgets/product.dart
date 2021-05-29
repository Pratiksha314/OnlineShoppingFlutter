import 'package:flutter/material.dart';

Widget productField(TextEditingController prodNameC, TextEditingController desC,
    TextEditingController price) {
  return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            TextFormField(
              controller: prodNameC,
              decoration: InputDecoration(labelText: 'Product Name'),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter a Product Name.';
                }
                if (value.length < 3) {
                  return 'Should be at least 3 characters long.';
                }
                return null;
              },
            ),
            TextFormField(
              controller: desC,
              decoration: InputDecoration(
                labelText: 'Description',
              ),
              keyboardType: TextInputType.multiline,
              maxLines: 5,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter a description.';
                }
                if (value.length < 10) {
                  return 'Should be at least 10 characters long.';
                }
                return null;
              },
            ),
            TextFormField(
              controller: price,
              decoration: InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
                                          validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter a Price.';
                              }
                              if (value.length < 1) {
                                return 'Should be at least 1 character.';
                              }
                              return null;
                            },
            ),
            SizedBox(height: 35),
          ],
        ),
  );
}
