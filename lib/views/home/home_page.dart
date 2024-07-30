import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sharecare/common/custom_appbar.dart';
import 'package:sharecare/common/custom_container.dart';
import 'package:sharecare/common/heading.dart';
import 'package:sharecare/constants/constants.dart';
import 'package:sharecare/views/home/our_impact.dart';
import 'package:sharecare/views/home/quotations.dart';
import 'package:sharecare/views/home/urgent_needs.dart';
import 'package:sharecare/views/home/volunteer_work.dart';
import 'package:sharecare/views/home/widgets/category_list.dart';
import 'package:sharecare/views/home/widgets/impact_lists.dart';
import 'package:sharecare/views/home/widgets/quotes_lists.dart';
import 'package:sharecare/views/home/widgets/urgent_needs_list.dart';
import 'package:sharecare/views/home/widgets/volunteer_lists.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimary,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(130.h),
          child: const CustomAppbar()),
      body: SafeArea(
        child: CustomContainer(
          containerContent: Column(
              children: [
                const CategoryList(),

                Heading(
                text: "Urgent Needs",
                onTap: () {
                  Get.to(() => const AllUrgentNeeds(),
                  transition: Transition.cupertino,
                  duration: const Duration(milliseconds: 900),
                  );
                },
                ),
                const UrgentNeedsList(),

                Heading(
                text: "Interested in Volunteer work ?",
                onTap: () {
                   Get.to(() => const AllVolunteer(),
                  transition: Transition.cupertino,
                  duration: const Duration(milliseconds: 900),
                  );
                },
                ),
                const VolunteerLists(),

                Heading(
                text: "See Our Impact",
                onTap: () {
                   Get.to(() => const AllImpact(),
                  transition: Transition.cupertino,
                  duration: const Duration(milliseconds: 900),
                  );
                },
                ),
                const ImpactLists(),

                Heading(
                text: "Words of Hope",
                onTap: () {
                   Get.to(() => const AllQuotes(),
                  transition: Transition.cupertino,
                  duration: const Duration(milliseconds: 900),
                  );
                },
                ),
                const QuotesLists(),


              ],
              ),
          
        ),
      ),
    );
  }
}
