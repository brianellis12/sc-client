import 'package:capstone/Location%20Data/models/geographic_types.dart';
import 'package:capstone/Location%20Data/models/sections.dart';
import 'package:capstone/Location%20Data/services/data_service.dart';
import 'package:capstone/Location%20Data/widgets/data_container.dart';
import 'package:flutter/material.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:capstone/Location Data/models/location_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:info_popup/info_popup.dart';

/*
* Holds a collection of dabs with the data containers, one for each census data group
*/
class GroupBar extends ConsumerStatefulWidget {
  const GroupBar({Key? key}) : super(key: key);

  @override
  ConsumerState createState() => _GroupBarState();
}

class _GroupBarState extends ConsumerState<GroupBar> {
  static final List<String> enums = EnumToString.toList(GroupNames.values)
      .map((e) => e.replaceAll('_', ' '))
      .toList();

  final List<Tab> myTabs = enums.map((String name) => Tab(text: name)).toList();

  var description = dataDescriptions[0];
  // Get and set the sections for the group selected
  Future<void> setSections(GroupNames group) async {
    final locationDataService = ref.watch(locationDataServiceProvider);
    final Sections sections = await locationDataService.getSections(group.code);
    ref
        .read(sectionsProvider.notifier)
        .specifyCurrentSections(sections.currentSections);
  }

  // Build the Tab Bar
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: myTabs.length,
      // The Builder widget is used to have a different BuildContext to access
      // closest DefaultTabController.
      child: Builder(builder: (BuildContext context) {
        final TabController? tabController = DefaultTabController.of(context);
        tabController?.addListener(() {
          if (!tabController.indexIsChanging) {
            final group = GroupNames.values[tabController.index];
            description = dataDescriptions[tabController.index];
            setSections(group);
          }
        });
        return SizedBox(
            width: 100,
            child: Scaffold(
              appBar: TabBar(
                tabs: myTabs,
                isScrollable: true,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.black,
              ),
              body: TabBarView(
                children: [
                  info(),
                  ...enums.map((String name) {
                    return const DataContainer();
                  }).toList()
                ],
              ),
            ));
      }),
    );
  }
}

Widget info() {
  return Text("");
  // return const InfoPopupWidget(
  //   contentTitle: 'Info Popup Icon Examplee',
  //   contentMaxWidth: 10,
  //   arrowTheme: InfoPopupArrowTheme(
  //     color: Colors.pink,
  //   ),
  //   child: Icon(Icons.info, color: Colors.pink, size: 5),
  // );
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
  "This data group provides statistics on the housing units and characteristics of occupied and vacant housing units, such as their housing unit type, housing unit size, year built, plumbing facilities, kitchen facilities, telephone service availability, and heating fuel type."
      "This data group provides statistics on the population living in group quarters, such as institutionalized and noninstitutionalized group quarters, by type of group quarters, such as correctional facilities, nursing homes, college dormitories, military barracks, etc.",
  "This data group provides statistics on the health insurance coverage and type of coverage of the civilian noninstitutionalized population, such as their health insurance status, private health insurance coverage, public health insurance coverage, and type of public health insurance coverage, such as Medicare, Medicaid, VA health care, etc.",
  "This data group provides statistics on the availability and usage of technology devices and services in households, such as their computer ownership, internet access, type of internet subscription, devices used to access the internet, and online activities.",
  "This data group provides statistics on the basic demographic characteristics of the population 18 years and over who are eligible to vote, such as their sex, race, ethnicity, citizenship status, educational attainment, and poverty status."
];
