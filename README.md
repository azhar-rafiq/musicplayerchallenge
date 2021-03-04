# musicplayerchallenge
by Azhar Rafiq (azhar@outlook.co.id)

Music Player using Flutter for Android.

## Supported devices.
Tested on Realme 5 Pro with Android 10. Tested on Android Studio virtual device using Android 10.0 x86

## Supported features.
- Search artis/song from US iTunes Store, the app will fetch 20 result
- The music list will list track name, artist name, track artwork, and album/collection name.
- Click the song to 'play' (simulation, not really playing music)
- To change the song, click another song, it will 'play' automatically
- If play/pause button clicked, the state will change, but the selected song remain
- If a new search is conducted, the music bar at the bottom will disappear.
- The music bar will appear if a song is selected
- There will be an indicator on the right side of the list of which song is being selected. It is an icon of a music note.
- Another indicator is the title of the song will also change into bright color.

## Requirements to build the app.
- Android Studio
- Flutter SDK
- Flutter Dependencies:
    - http

## Instructions to build and deploy the app.
Open the project in Android Studio, select android device/simulator, click Run 'main.dart'.

To build the app, open terminal in Android Studio, run 'flutter build apk'. Drag/open the apk on Android device/simulator.

