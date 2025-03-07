# 'Inti: The Inka Chess Game'
A minichess game in flutter

try it out:
https://inkachess.com/
also:
https://minichess-34a02.firebaseapp.com/
or
https://hotakutsuki.github.io/minichess/

to run debug:
flutter run -d chrome --web-renderer canvaskit

to deploy:
run: "flutter build web --web-renderer canvaskit --release"
copy /build/web => /docs.
(you can overwrite index.html)
then run: "firebase deploy --only hosting"

to build abb:
1. Increrse version on pubspec.yaml
2. Build>flutter>build app bundle