/// An image placeholder page.
//
// Time-stamp: <Sunday 2025-01-05 10:11:31 +1100 Graham Williams>
//
/// Copyright (C) 2025, Togaware Pty Ltd
///
/// Licensed under the GNU General Public License, Version 3 (the "License");
///
/// License: https://www.gnu.org/licenses/gpl-3.0.en.html
//
// This program is free software: you can redistribute it and/or modify it under
// the terms of the GNU General Public License as published by the Free Software
// Foundation, either version 3 of the License, or (at your option) any later
// version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
// details.
//
// You should have received a copy of the GNU General Public License along with
// this program.  If not, see <https://www.gnu.org/licenses/>.
///
/// Authors: Graham Williams

library;

import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

class NoImagePage extends StatelessWidget {
  const NoImagePage({
    super.key,
  });

  /// Load the placeholder image.

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SvgPicture.asset('assets/svg/placeholder.svg'),
    );
  }
}
