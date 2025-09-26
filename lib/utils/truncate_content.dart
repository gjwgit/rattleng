/// Truncate a string to a max length.
///
// Time-stamp: "Friday 2025-09-12 16:58:57 +1000 Graham Williams"
///
/// Copyright (C) 2025, Togaware Pty Ltd
///
/// Licensed under the GNU General Public License, Version 3 (the "License");
///
/// License: https://opensource.org/license/gpl-3-0
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
// this program.  If not, see https://opensource.org/license/gpl-3-0.
///
/// Authors: Zheyuan

library;

/// Truncate [content] to fixed width.

String truncateContent(String content) {
  int maxLength = 45;
  String subStr =
      content.length > maxLength ? content.substring(0, maxLength) : content;
  int lastCommaIndex = subStr.lastIndexOf(',') + 1;

  return '${lastCommaIndex > 0 ? content.substring(0, lastCommaIndex) : subStr} ...';
}
