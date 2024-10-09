import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:the_holy_quran/globals.dart';
import 'package:the_holy_quran/models/model_ayat.dart';
import 'package:the_holy_quran/models/model_surah.dart';

class DetailScreen extends StatefulWidget {
  final int noSurat;

  const DetailScreen({super.key, required this.noSurat});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool isplaying = true;

  final player = AudioPlayer();
  Future<Surah> _getDetailSurah() async {
    var data = await Dio().get("https://equran.id/api/surat/${widget.noSurat}");
    return Surah.fromJson(json.decode(data.toString()));
  }

  @override
  void initState() {
    if (SystemCheck.musiccheck) {
      player.play(UrlSource(
          'https://equran.nos.wjv-1.neo.id/audio-full/Misyari-Rasyid-Al-Afasi/001.mp3'));
    }

    AudioPlayerService.audioPlayer.isPlaying.listen((bool playing) {
      setState(() {
        isplaying = playing;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Surah>(
        future: _getDetailSurah(),
        initialData: null,
        builder: ((context, snapshot) {
          if (!snapshot.hasData) {
            return Scaffold(
              backgroundColor: background,
            );
          }
          Surah surah = snapshot.data!;
          return Scaffold(
            backgroundColor: background,
            appBar: _appBar(context: context, surah: surah),
            body: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                SliverToBoxAdapter(
                  child: _details(surah: surah),
                )
              ],
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: ListView.separated(
                  itemBuilder: (context, index) => _ayatItem(
                      ayat: surah.ayat!
                          .elementAt(index + (widget.noSurat == 1 ? 1 : 0))),
                  itemCount: surah.jumlahAyat + (widget.noSurat == 1 ? -1 : 0),
                  separatorBuilder: (context, index) => Container(),
                ),
              ),
            ),
          );
        }));
  }

  Widget _ayatItem({required Ayat ayat}) => Padding(
        padding: const EdgeInsets.only(top: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                  color: subtext, borderRadius: BorderRadius.circular(10)),
              child: Row(
                children: [
                  Container(
                    width: 27,
                    height: 27,
                    decoration: BoxDecoration(
                        color: primary,
                        borderRadius: BorderRadius.circular(27 / 2)),
                    child: Center(
                        child: Text(
                      '${ayat.nomor}',
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500, color: Colors.white),
                    )),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.share_outlined,
                    color: Colors.white,
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  IconButton(
                    icon: Icon(
                      isplaying ? Icons.music_note : Icons.music_off,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      if (isplaying) {
                        AudioPlayerService.pause();
                        SystemCheck.setmusic(false);
                      } else {
                        AudioPlayerService.play();
                        SystemCheck.setmusic(true);
                      }
                      setState(() {
                        isplaying = !isplaying;
                      });
                    },
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  const Icon(
                    Icons.bookmark_outline,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            Text(
              ayat.ar,
              style: GoogleFonts.amiri(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
              textAlign: TextAlign.right,
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              ayat.idn,
              style: GoogleFonts.poppins(color: subtext, fontSize: 16),
            )
          ],
        ),
      );

  Widget _details({required Surah surah}) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Stack(children: [
          Container(
            height: 257,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: [
                      0,
                      .6,
                      1
                    ],
                    colors: [
                      Color(0xFFDF98FA),
                      Color(0xFFB070FD),
                      Color(0xFF9055FF)
                    ])),
          ),
          Positioned(
              bottom: 0,
              right: 0,
              child: Opacity(
                  opacity: .2,
                  child: SvgPicture.asset(
                    'assets/svgs/quran.svg',
                    width: 324 - 55,
                  ))),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(28),
            child: Column(
              children: [
                Text(
                  surah.namaLatin,
                  style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 26),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  surah.arti,
                  style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 16),
                ),
                Divider(
                  color: Colors.white.withOpacity(.35),
                  thickness: 2,
                  height: 32,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      surah.tempatTurun.name,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          color: Colors.white),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      "${surah.jumlahAyat} Ayat",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 32,
                ),
                SvgPicture.asset('assets/svgs/bismillah.svg')
              ],
            ),
          )
        ]),
      );

  AppBar _appBar({required BuildContext context, required Surah surah}) =>
      AppBar(
        backgroundColor: background,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Row(children: [
          IconButton(
              onPressed: (() => Navigator.of(context).pop()),
              icon: SvgPicture.asset('assets/svgs/back-icon.svg')),
          const SizedBox(
            width: 24,
          ),
          Text(
            surah.namaLatin,
            style:
                GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          IconButton(
              onPressed: (() => {}),
              icon: SvgPicture.asset('assets/svgs/search.svg')),
        ]),
      );
}

class AudioPlayerService {
  static final AssetsAudioPlayer audioPlayer = AssetsAudioPlayer();

  static void open(Audio audio) {
    audioPlayer.open(audio);
  }

  static void play() {
    audioPlayer.play();
  }

  static void pause() {
    audioPlayer.pause();
  }

  static void dispose() {
    audioPlayer.dispose();
  }
}

class SystemCheck {
  static bool musiccheck = true;
  static bool sfxcheck = true;

  static void setmusic(bool val) {
    musiccheck = val;
  }

  static void setsfx(bool val) {
    sfxcheck = val;
  }

  static bool getmusic() {
    return musiccheck;
  }

  static bool getsfx() {
    return sfxcheck;
  }
}
