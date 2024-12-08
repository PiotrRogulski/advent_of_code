import 'package:advent_of_code/features/tasks/y2022/d1.dart';
import 'package:advent_of_code/features/tasks/y2022/d10.dart';
import 'package:advent_of_code/features/tasks/y2022/d11.dart';
import 'package:advent_of_code/features/tasks/y2022/d2.dart';
import 'package:advent_of_code/features/tasks/y2022/d3.dart';
import 'package:advent_of_code/features/tasks/y2022/d4.dart';
import 'package:advent_of_code/features/tasks/y2022/d5.dart';
import 'package:advent_of_code/features/tasks/y2022/d6.dart';
import 'package:advent_of_code/features/tasks/y2022/d7.dart';
import 'package:advent_of_code/features/tasks/y2022/d8.dart';
import 'package:advent_of_code/features/tasks/y2022/d9.dart';
import 'package:advent_of_code/features/tasks/y2023/d1.dart';
import 'package:advent_of_code/features/tasks/y2023/d10.dart';
import 'package:advent_of_code/features/tasks/y2023/d11.dart';
import 'package:advent_of_code/features/tasks/y2023/d12.dart';
import 'package:advent_of_code/features/tasks/y2023/d13.dart';
import 'package:advent_of_code/features/tasks/y2023/d14.dart';
import 'package:advent_of_code/features/tasks/y2023/d15.dart';
import 'package:advent_of_code/features/tasks/y2023/d16.dart';
import 'package:advent_of_code/features/tasks/y2023/d17.dart';
import 'package:advent_of_code/features/tasks/y2023/d18.dart';
import 'package:advent_of_code/features/tasks/y2023/d19.dart';
import 'package:advent_of_code/features/tasks/y2023/d2.dart';
import 'package:advent_of_code/features/tasks/y2023/d20.dart';
import 'package:advent_of_code/features/tasks/y2023/d21.dart';
import 'package:advent_of_code/features/tasks/y2023/d22.dart';
import 'package:advent_of_code/features/tasks/y2023/d23.dart';
import 'package:advent_of_code/features/tasks/y2023/d24.dart';
import 'package:advent_of_code/features/tasks/y2023/d25.dart';
import 'package:advent_of_code/features/tasks/y2023/d3.dart';
import 'package:advent_of_code/features/tasks/y2023/d4.dart';
import 'package:advent_of_code/features/tasks/y2023/d5.dart';
import 'package:advent_of_code/features/tasks/y2023/d6.dart';
import 'package:advent_of_code/features/tasks/y2023/d7.dart';
import 'package:advent_of_code/features/tasks/y2023/d8.dart';
import 'package:advent_of_code/features/tasks/y2023/d9.dart';
import 'package:advent_of_code/features/tasks/y2024/d1.dart';
import 'package:advent_of_code/features/tasks/y2024/d2.dart';
import 'package:advent_of_code/features/tasks/y2024/d3.dart';
import 'package:advent_of_code/features/tasks/y2024/d4.dart';
import 'package:advent_of_code/features/tasks/y2024/d5.dart';
import 'package:advent_of_code/features/tasks/y2024/d6.dart';
import 'package:advent_of_code/features/tasks/y2024/d7.dart';
import 'package:advent_of_code/features/tasks/y2024/d8.dart';
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
  2024: YearData({
    1: Y2024D1(),
    2: Y2024D2(),
    3: Y2024D3(),
    4: Y2024D4(),
    5: Y2024D5(),
    6: Y2024D6(),
    7: Y2024D7(),
    8: Y2024D8(),
  }),
};

YearData getYear(int year) => allYears[year]!;

DayData getDay(int year, int day) => getYear(year).days[day]!;
