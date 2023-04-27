// ignore_for_file: constant_identifier_names
import 'package:flutter_riverpod/flutter_riverpod.dart';

/*
* Location data model for use with the content of the Data Containers
*/
class LocationData {
  int id;
  String headerValue;
  List<String> values;
  bool isExpanded;

  LocationData({
    this.id = 0,
    this.values = const [''],
    this.headerValue = '',
    this.isExpanded = false,
  });
}

/*
* Holds the state of the Location data for use with the Data Container functionality
*/
class LocationDataNotifier extends StateNotifier<LocationData> {
  LocationDataNotifier(LocationData initialState) : super(initialState);

  void reset() {
    state = LocationData();
  }
}

final locationDataProvider =
    StateNotifierProvider<LocationDataNotifier, LocationData>((ref) {
  final initialState = LocationData();
  return LocationDataNotifier(initialState);
});

/*
* The group names to be used for the Group Bar Widget
*/
enum GroupNames {
  Sex_and_Age,
  Race,
  Latino_Ancestry,
  Non_Latino_Ancestry,
  Non_US_Place_of_Birth,
  Place_of_Birth_within_US,
  Geographic_Mobility,
  Transportation,
  Children_and_Seniors,
  Households_Grandparents_and_Grandchildren,
  Households,
  Marital_Status,
  Births,
  Education_Enrollment,
  Education_Attainment,
  Languages,
  Income,
  Disabilities,
  Income_By_Household,
  Income_By_Sex,
  Veteran_Status,
  Food_Stamp_Utilization,
  Employment_Status,
  Occupations,
  Housing_Status,
  Housing_Status_in_Group_Quarters,
  Health_Insurance_Status,
  Household_Technology,
  Basic_Demographics_by_Voting_Age
}

extension GroupNamesExtension on GroupNames {
  String get code {
    switch (this) {
      case GroupNames.Sex_and_Age:
        return 'B01';
      case GroupNames.Race:
        return 'B02';
      case GroupNames.Latino_Ancestry:
        return 'B03';
      case GroupNames.Non_Latino_Ancestry:
        return 'B04';
      case GroupNames.Non_US_Place_of_Birth:
        return 'B05';
      case GroupNames.Place_of_Birth_within_US:
        return 'B06';
      case GroupNames.Geographic_Mobility:
        return 'B07';
      case GroupNames.Transportation:
        return 'B08';
      case GroupNames.Children_and_Seniors:
        return 'B09';
      case GroupNames.Households_Grandparents_and_Grandchildren:
        return 'B10';
      case GroupNames.Households:
        return 'B11';
      case GroupNames.Marital_Status:
        return 'B12';
      case GroupNames.Births:
        return 'B13';
      case GroupNames.Education_Enrollment:
        return 'B14';
      case GroupNames.Education_Attainment:
        return 'B15';
      case GroupNames.Languages:
        return 'B16';
      case GroupNames.Income:
        return 'B17';
      case GroupNames.Disabilities:
        return 'B18';
      case GroupNames.Income_By_Household:
        return 'B19';
      case GroupNames.Income_By_Sex:
        return 'B20';
      case GroupNames.Veteran_Status:
        return 'B21';
      case GroupNames.Food_Stamp_Utilization:
        return 'B22';
      case GroupNames.Employment_Status:
        return 'B23';
      case GroupNames.Occupations:
        return 'B24';
      case GroupNames.Housing_Status:
        return 'B25';
      case GroupNames.Housing_Status_in_Group_Quarters:
        return 'B26';
      case GroupNames.Health_Insurance_Status:
        return 'B27';
      case GroupNames.Household_Technology:
        return 'B28';
      case GroupNames.Basic_Demographics_by_Voting_Age:
        return 'B29';

      default:
        return '';
    }
  }
}

List<String> dataDescriptions = [
  "This data group provides statistics on the sex and age distribution of the population, as well as median age and sex ratios by geographic area.",
  "This data group provides statistics on the racial composition of the population, as well as the diversity index, which measures the probability that two people chosen at random will be from different race groups.",
  "This data group provides statistics on the Latino or Hispanic origin and ancestry of the population, as well as the countries of origin and generational status of Latinos in the US.",
  "This data group provides statistics on the non-Latino or non-Hispanic ancestry of the population, as well as the countries of origin and generational status of non-Latinos in the US.",
  "This data group provides statistics on the foreign-born population, including their place of birth, citizenship status, year of entry, and naturalization rate.",
  "This data group provides statistics on the native-born population, including their place of birth within the US, state of residence, and migration patterns.",
  "This data group provides statistics on the mobility and migration of the population, including their residence one year ago, reason for moving, and distance moved.",
  "This data group provides statistics on the transportation modes and means of travel to work for workers 16 years and over, as well as their travel time, departure time, and vehicle occupancy.",
  "This data group provides statistics on the characteristics and well-being of children under 18 years and seniors 65 years and over, such as their living arrangements, school enrollment, health insurance coverage, disability status, and poverty status.",
  "This data group provides statistics on the household composition and family structure of the population, including the number and type of households, family size, marital status, and presence of grandparents and grandchildren in households.",
  "This data group provides statistics on the characteristics and economic situation of households, such as their income, poverty status, food stamp utilization, housing tenure, housing costs, and housing value.",
  "This data group provides statistics on the marital status and history of the population 15 years and over, such as their current marital status, number of marriages, age at first marriage, and marital transitions.",
  "This data group provides statistics on the fertility and birth rates of women 15 to 50 years old, as well as their marital status at birth, birthplace of mother, birthplace of father, and plurality of births.",
  "This data group provides statistics on the school enrollment and educational attainment of the population 3 years and over, such as their level of enrollment, type of school, grade level, field of degree, and school costs.",
  "This data group provides statistics on the educational attainment and achievement of the population 25 years and over, such as their highest level of education completed, degree field, and earnings by education level.",
  "This data group provides statistics on the language use and proficiency of the population 5 years and over, such as their ability to speak English, language spoken at home, and linguistic isolation.",
  "This data group provides statistics on the income distribution and sources of income of the population 15 years and over, such as their median income, income inequality, earnings, interest, dividends, rents, retirement income,and public assistance income.",
  "This data group provides statistics on the disability status and type of disability of the civilian noninstitutionalized population,such as their hearing difficulty, vision difficulty, cognitive difficulty, ambulatory difficulty, self-care difficulty, and independent living difficulty.",
  "This data group provides statistics on the income distribution by household type, such as their median income by household type, income quintiles by household type, and income-to-poverty ratio by household type.",
  "This data group provides statistics on the income distribution by sex, such as their median income by sex, income quintiles by sex, and income-to-poverty ratio by sex.",
  "This data group provides statistics on the veteran status and characteristics of veterans in the civilian population 18 years and over, such as their period of service, disability status, health insurance coverage, poverty status, and employment status.",
  "This data group provides statistics on the participation and benefits of the Supplemental Nutrition Assistance Program (SNAP), formerly known as food stamps, for households and individuals, such as their SNAP status, SNAP income, SNAP benefit amount, and SNAP-to-poverty ratio.",
  "This data group provides statistics on the labor force status and characteristics of the population 16 years and over, such as their employment status, occupation, industry, class of worker, hours worked, and earnings.",
  "This data group provides statistics on the occupational distribution and characteristics of workers 16 years and over, such as their occupation group, occupation code, occupation title, median earnings by occupation, and occupation-to-population ratio.",
  "This data group provides statistics on the housing units and characteristics of occupied and vacant housing units, such as their housing unit type, housing unit size, year built, plumbing facilities, kitchen facilities, telephone service availability, and heating fuel type.",
  "This data group provides statistics on the population living in group quarters, such as institutionalized and noninstitutionalized group quarters, by type of group quarters, such as correctional facilities, nursing homes, college dormitories, military barracks, etc.",
  "This data group provides statistics on the health insurance coverage and type of coverage of the civilian noninstitutionalized population, such as their health insurance status, private health insurance coverage, public health insurance coverage, and type of public health insurance coverage, such as Medicare, Medicaid, VA health care, etc.",
  "This data group provides statistics on the availability and usage of technology devices and services in households, such as their computer ownership, internet access, type of internet subscription, devices used to access the internet, and online activities.",
  "This data group provides statistics on the basic demographic characteristics of the population 18 years and over who are eligible to vote, such as their sex, race, ethnicity, citizenship status, educational attainment, and poverty status.",
  ""
];
