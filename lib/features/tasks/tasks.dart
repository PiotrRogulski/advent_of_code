import 'package:advent_of_code/features/tasks/y2022/days/d1.dart';
import 'package:advent_of_code/features/tasks/y2022/days/d10.dart';
import 'package:advent_of_code/features/tasks/y2022/days/d11.dart';
import 'package:advent_of_code/features/tasks/y2022/days/d2.dart';
import 'package:advent_of_code/features/tasks/y2022/days/d3.dart';
import 'package:advent_of_code/features/tasks/y2022/days/d4.dart';
import 'package:advent_of_code/features/tasks/y2022/days/d5.dart';
import 'package:advent_of_code/features/tasks/y2022/days/d6.dart';
import 'package:advent_of_code/features/tasks/y2022/days/d7.dart';
import 'package:advent_of_code/features/tasks/y2022/days/d8.dart';
import 'package:advent_of_code/features/tasks/y2022/days/d9.dart';
import 'package:advent_of_code/features/tasks/y2023/days/d1.dart';
import 'package:advent_of_code/features/tasks/y2023/days/d10.dart';
import 'package:advent_of_code/features/tasks/y2023/days/d11.dart';
import 'package:advent_of_code/features/tasks/y2023/days/d12.dart';
import 'package:advent_of_code/features/tasks/y2023/days/d13.dart';
import 'package:advent_of_code/features/tasks/y2023/days/d14.dart';
import 'package:advent_of_code/features/tasks/y2023/days/d15.dart';
import 'package:advent_of_code/features/tasks/y2023/days/d16.dart';
import 'package:advent_of_code/features/tasks/y2023/days/d17.dart';
import 'package:advent_of_code/features/tasks/y2023/days/d18.dart';
import 'package:advent_of_code/features/tasks/y2023/days/d19.dart';
import 'package:advent_of_code/features/tasks/y2023/days/d2.dart';
import 'package:advent_of_code/features/tasks/y2023/days/d20.dart';
import 'package:advent_of_code/features/tasks/y2023/days/d21.dart';
import 'package:advent_of_code/features/tasks/y2023/days/d22.dart';
import 'package:advent_of_code/features/tasks/y2023/days/d23.dart';
import 'package:advent_of_code/features/tasks/y2023/days/d24.dart';
import 'package:advent_of_code/features/tasks/y2023/days/d25.dart';
import 'package:advent_of_code/features/tasks/y2023/days/d3.dart';
import 'package:advent_of_code/features/tasks/y2023/days/d4.dart';
import 'package:advent_of_code/features/tasks/y2023/days/d5.dart';
import 'package:advent_of_code/features/tasks/y2023/days/d6.dart';
import 'package:advent_of_code/features/tasks/y2023/days/d7.dart';
import 'package:advent_of_code/features/tasks/y2023/days/d8.dart';
import 'package:advent_of_code/features/tasks/y2023/days/d9.dart';
import 'package:advent_of_code/features/years/models/advent_structure.dart';

const allYears = {
  2022: YearData({
    1: Y2022D1(),
    2: Y2022D2(),
    3: Y2022D3(),
    4: Y2022D4(),
    5: Y2022D5(),
    6: Y2022D6(),
    7: Y2022D7(),
    8: Y2022D8(),
    9: Y2022D9(),
    10: Y2022D10(),
    11: Y2022D11(),
  }),
  2023: YearData({
    1: Y2023D1(),
    2: Y2023D2(),
    3: Y2023D3(),
    4: Y2023D4(),
    5: Y2023D5(),
    6: Y2023D6(),
    7: Y2023D7(),
    8: Y2023D8(),
    9: Y2023D9(),
    10: Y2023D10(),
    11: Y2023D11(),
    12: Y2023D12(),
    13: Y2023D13(),
    14: Y2023D14(),
    15: Y2023D15(),
    16: Y2023D16(),
    17: Y2023D17(),
    18: Y2023D18(),
    19: Y2023D19(),
    20: Y2023D20(),
    21: Y2023D21(),
    22: Y2023D22(),
    23: Y2023D23(),
    24: Y2023D24(),
    25: Y2023D25(),
  }),
};

YearData getYear(int year) => allYears[year]!;

DayData getDay(int year, int day) => getYear(year).days[day]!;
