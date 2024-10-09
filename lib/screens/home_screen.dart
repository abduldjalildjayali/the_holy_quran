import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:the_holy_quran/globals.dart';
import 'package:the_holy_quran/tabs/hijb_tab.dart';
import 'package:the_holy_quran/tabs/page_tab.dart';
import 'package:the_holy_quran/tabs/para_tab.dart';
import 'package:the_holy_quran/tabs/surah_tab.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: _appbar(),
      bottomNavigationBar: _bottomNavigationBar(),
      body: DefaultTabController(
        length: 4,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverToBoxAdapter(
                child: _greetings(),
              ),
              SliverAppBar(
                pinned: true,
                backgroundColor: background,
                automaticallyImplyLeading: false,
                elevation: 0,
                shape: Border(
                    bottom: BorderSide(
                  width: 3,
                  color: background2.withOpacity(.1),
                )),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(0),
                  child: _tab(),
                ),
              ),
            ],
            body: const TabBarView(
              children: [SurahTab(), ParaTab(), PageTab(), HijbTab()],
            ),
          ),
        ),
      ),
      // bottomNavigationBar: _bottbar(),
    );
  }

  TabBar _tab() {
    return TabBar(
        labelColor: Colors.white,
        unselectedLabelColor: const Color(0xFFA19CC5),
        indicatorColor: primary,
        dividerColor: background2,
        tabs: [
          _tabItems(label: 'Surah'),
          _tabItems(label: 'Para'),
          _tabItems(label: 'Page'),
          _tabItems(label: 'Hijb'),
        ]);
  }

  Tab _tabItems({required label}) => Tab(
          child: Text(
        label,
        style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
      ));

  Column _greetings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 24,
        ),
        Text(
          'Asslamualaikum',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: subtext,
          ),
        ),
        const SizedBox(
          height: 4,
        ),
        Text(
          'Abdul Djalil Djayali',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(
          height: 24,
        ),
        _lastRead(),
        const SizedBox(
          height: 24,
        )
      ],
    );
  }

  Stack _lastRead() {
    return Stack(
      // clipBehavior: Clip.none,
      children: [
        Container(
          height: 131,
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: const LinearGradient(
                  colors: [
                    Color(0xFFDF98FA),
                    Color(0xFF9055FF),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: [0, 1])),
        ),
        Positioned(
          right: -35,
          bottom: -25,
          child: SvgPicture.asset('assets/svgs/quran.svg'),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SvgPicture.asset('assets/svgs/book.svg'),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    'Last Read',
                    style: GoogleFonts.poppins(
                        fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                'Al-Fatiah',
                style: GoogleFonts.poppins(
                    fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                'Ayah No: 1',
                style: GoogleFonts.poppins(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  AppBar _appbar() => AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: background,
        title: Row(
          children: [
            IconButton(
                onPressed: (() => {}),
                icon: SvgPicture.asset('assets/svgs/menu.svg')),
            const SizedBox(
              width: 24,
            ),
            Text(
              'Quran App',
              style: GoogleFonts.poppins(
                  fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            IconButton(
                onPressed: (() => {}),
                icon: SvgPicture.asset('assets/svgs/search.svg')),
          ],
        ),
      );

  BottomNavigationBar _bottomNavigationBar() => BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        backgroundColor: background2,
        items: [
          _bottomBarItem(icon: 'assets/svgs/menu_quran.svg', label: 'Menu1'),
          _bottomBarItem(icon: 'assets/svgs/menu_idea.svg', label: 'Menu1'),
          _bottomBarItem(icon: 'assets/svgs/menu_shalat.svg', label: 'Menu1'),
          _bottomBarItem(icon: 'assets/svgs/menu_pray.svg', label: 'Menu1'),
          _bottomBarItem(icon: 'assets/svgs/menu_bookmark.svg', label: 'Menu1'),
        ],
      );

  BottomNavigationBarItem _bottomBarItem({required icon, required label}) =>
      BottomNavigationBarItem(icon: SvgPicture.asset(icon), label: label);
}
