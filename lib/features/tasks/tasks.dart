import 'package:advent_of_code/features/tasks/y2022/year.dart';
import 'package:advent_of_code/features/tasks/y2023/year.dart';
import 'package:advent_of_code/features/years/models/advent_structure.dart';

const allYears = {
  2022: year2022,
  2023: year2023,
};

YearData getYear(int year) => allYears[year]!;

DayData getDay(int year, int day) => getYear(year).days[day]!;
