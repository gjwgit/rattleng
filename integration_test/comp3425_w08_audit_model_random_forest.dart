/// COMP3425 W08 ADULT -> ADABOOST.
//
// Time-stamp: <Tuesday 2025-04-22 13:27:04 +1000 >
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

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:rattle/main.dart' as app;

import 'utils/add_delay.dart';
import 'utils/load_dataset_by_path.dart';
import 'utils/navigate_to_feature.dart';
import 'utils/navigate_to_page.dart';
import 'utils/navigate_to_tab.dart';
import 'utils/set_partition.dart';
import 'utils/tap_button.dart';
import 'utils/tap_chip.dart';
import 'utils/verify_dataset_role.dart';
import 'utils/verify_selectable_text.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('COMP3425 W08 ADULT -> RANDOM FOREST:', () {
    testWidgets('verify.', (WidgetTester tester) async {
      app.main();

      // Load the dataset and set variable roles.

      await tester.pumpAndSettle();
      await setPartition(tester, true);
      await loadDatasetByPath(tester, 'integration_test/data/adult.csv');
      await verifyDatasetRole('income', 'Target');

      // Build random forest.

      await navigateToTab(tester, 'Model');
      await navigateToFeature(tester, 'Forest');
      await tapButton(tester, 'Build Random Forest');
      await addDelay(tester, 55);

      await navigateToPage(tester, 1, back: 1, title: 'Random Forest Model');
      await verifySelectableText(
        tester,
        [
          'randomForest(formula = form, data = trds',
          'OOB estimate of  error rate: 13.76%',
          'Confusion matrix:',
          '<=50K >50K class.error',
          '<=50K 16111 1157  0.06700255',
        ],
      );

      await navigateToPage(tester, 2, back: 1, title: 'Sample Rules');
      await verifySelectableText(
        tester,
        [
          'Random Forest Model 1 ',
          'Tree 1 Rule 1 Node 60 Decision <=50K',
          '1: occupation IN ("Armed-Forces", "Exec-managerial", "Prof-specialty")',
          '2: relationship IN ("Not-in-family", "Other-relative", "Own-child", "Unmarried")',
          '3: eductation IN ("5th-6th", "Doctorate", "Preschool", "Prof-school")',
          '4: capital_gain <= 4030',
          '5: workclass IN ("Federal-gov", "Self-emp-not-inc")',
          '6: age <= 31.5',
          'Number of rules in Tree 1: 2186',
        ],
      );

      await navigateToPage(
        tester,
        3,
        back: 2,
        title: 'Variable Importance — Numeric',
      );
      await verifySelectableText(
        tester,
        [
          '<=50K   >50K MeanDecreaseAccuracy MeanDecreaseGini',
          'capital_gain   166.60 228.53               228.02           569.26',
          'capital_loss    61.35 113.51               112.10           173.98',
          'occupation      38.98  68.12                87.95           429.46',
          'age            -10.39  94.68                68.23           593.91',
          'eductation      61.02   7.29                54.82           324.59',
          'hours_per_week  13.88  60.70                53.06           347.09',
          'martial         49.19  19.99                44.82           424.95',
          'education_num   38.93  18.92                41.04           341.65',
          'workclass       34.89  13.41                40.37           190.38',
          'relationship    27.36  39.81                36.87           623.95',
          'sex             34.00   2.45                33.66            52.19',
          'race            -0.46  16.69                10.52            73.22',
          'fnlwgt           2.11   1.97                 2.89           653.56',
        ],
      );

      // Build decision tree for comparison.

      await navigateToTab(tester, 'Model');
      await navigateToFeature(tester, 'Tree');
      await tapButton(tester, 'Build Decision Tree');

      await navigateToTab(tester, 'Evaluate');
      await tapButton(tester, 'Evaluate');

      await navigateToPage(tester, 1, back: 1, title: 'Error Matrix');
      await verifySelectableText(
        tester,
        [
          'Error matrix for the RPART Decision Tree model [TUNING] (counts)',
          'Predicted',
          'Actual  <=50K >50K Error',
          '<=50K  3537  191   5.1',
          '>50K    564  592  48.8',
          'Error matrix for the RPART Decision Tree model [TUNING] (proportions)',
          'Predicted',
          'Actual  <=50K >50K Error',
          '<=50K  72.4  3.9   5.1',
          '>50K   11.5 12.1  48.8',
          'Overall Error = 15.46%; Average Error = 26.96%.',
          'Error matrix for the RANDOM FOREST model [TUNING] (proportions)',
          'Predicted',
          'Actual  <=50K >50K Error',
          '<=50K  3474  254   6.8',
          '>50K    403  753  34.9',
          'Error matrix for the RANDOM FOREST model [TUNING] (counts)',
          'Predicted',
          'Actual  <=50K >50K Error',
          '<=50K  71.1  5.2   6.8',
          '>50K    8.3 15.4  34.9',
          'Overall Error = 13.45%; Average Error = 20.84%.',
        ],
      );

      // Build decision tree for comparison.

      await navigateToTab(tester, 'Model');
      await navigateToFeature(tester, 'Boost');
      await tapChip(tester, 'Adaptive');
      await tapButton(tester, 'Build Boosted Trees');
      await addDelay(tester, 55);

      await navigateToPage(tester, 1, back: 2, title: 'AdaBoost - Summary');
      await verifySelectableText(
        tester,
        [
          'True value <=50K  >50K',
          '<=50K 16351   917',
          '>50K   2310  3214',
          'Train Error: 0.142',
          'Out-Of-Bag Error:  0.141  iteration= 50',
          'Additional Estimates of number of iterations:',
          'train.err1 train.kap1',
          '26         12',
        ],
      );

      await navigateToTab(tester, 'Evaluate');
      await tapButton(tester, 'Evaluate');
      await addDelay(tester, 50);

      await navigateToPage(tester, 1, back: 1, title: 'Error Matrix');
      await verifySelectableText(
        tester,
        [
          'Error matrix for the RPART Decision Tree model [TUNING] (counts)',
          'Predicted',
          'Actual  <=50K >50K Error',
          '<=50K  3537  191   5.1',
          '>50K    564  592  48.8',
          'Error matrix for the RPART Decision Tree model [TUNING] (proportions)',
          'Predicted',
          'Actual  <=50K >50K Error',
          '<=50K  72.4  3.9   5.1',
          '>50K   11.5 12.1  48.8',
          'Overall Error = 15.46%; Average Error = 26.96%.',
          'Error matrix for the RANDOM FOREST model [TUNING] (proportions)',
          'Predicted',
          'Actual  <=50K >50K Error',
          '<=50K  3474  254   6.8',
          '>50K    403  753  34.9',
          'Error matrix for the RANDOM FOREST model [TUNING] (counts)',
          'Predicted',
          'Actual  <=50K >50K Error',
          '<=50K  71.1  5.2   6.8',
          '>50K    8.3 15.4  34.9',
          'Overall Error = 13.45%; Average Error = 20.84%.',
          'Error matrix for the ADABOOST model [TUNING] (counts)',
          'Predicted',
          'Actual  <=50K >50K Error',
          '<=50K  3537  191   5.1',
          '>50K    485  671  42.0',
          'Error matrix for the ADABOOST model [TUNING] (proportions)',
          'Predicted',
          'Actual  <=50K >50K Error',
          '<=50K  72.4  3.9   5.1',
          '>50K    9.9 13.7  42.0',
          'Overall Error = 13.84%; Average Error = 23.54%.',
        ],
      );
    });
  });
}
