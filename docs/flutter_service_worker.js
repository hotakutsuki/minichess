'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "assets/AssetManifest.json": "f48b78f8b521c8c20dc8187bb45e4323",
"assets/assets/animations/moon.json": "23944282a8e053cb7cdcfc99cd6bcdcc",
"assets/assets/icon/banner.png": "9a25f65d70e0ce63b26244b1444ac299",
"assets/assets/icon/debug.log": "32654af77226ce37dc1c41ad9abeaa9c",
"assets/assets/icon/icon.png": "faeb5c825ff2a64ea6b1195a718aab9e",
"assets/assets/icon/icon320.png": "166b55aede75bd06714b6b20f09494f5",
"assets/assets/icon/icon512.png": "51ee18a1379442069282422dd5f056dd",
"assets/assets/icon/icon512old.png": "ab1abb99ed61990c1f37b43ec41649f5",
"assets/assets/icon/iconold.png": "7b250820d4c3f34da4c71db4bf78ca12",
"assets/assets/images/avatar.png": "f4e0bcf3c42ed46c0f7c3aeb061d4d84",
"assets/assets/images/backgrounds/bg1.png": "23cc68a7c82bf91ae557100acc8a5f37",
"assets/assets/images/backgrounds/bg2.png": "4b2a1f2258614d500bada309ab402107",
"assets/assets/images/backgrounds/bg3.png": "e6c0afcafd3e4179d25c121846982490",
"assets/assets/images/backgrounds/bg4.png": "970614f90fdadfcde0fe13e0dde843cc",
"assets/assets/images/board.png": "aef63029ab2283fc8868ab23e40d6146",
"assets/assets/images/border.png": "f8976fa640843c822d82e62465df839c",
"assets/assets/images/darkborder.png": "1e02d9a9e7e34ac4a294c5856b1e58ae",
"assets/assets/images/glogo.png": "85346762215169a2f0013f2283bf56e4",
"assets/assets/images/gplay.png": "8412cc2c8fb288c9c3cb9063e2e2aa11",
"assets/assets/images/icon.png": "51ee18a1379442069282422dd5f056dd",
"assets/assets/images/iconold.png": "7b250820d4c3f34da4c71db4bf78ca12",
"assets/assets/images/old/bishopB.png": "f8b7fd33142018c5a6da6c5355c0d1fa",
"assets/assets/images/old/bishopW.png": "f356fb25fb9aa54b024bfc81a490bb3f",
"assets/assets/images/old/board.png": "509c5ce76ba0d682bc5c36d15228f1b1",
"assets/assets/images/old/kingB.png": "ebeb5a958d79282276ebc1dc14519464",
"assets/assets/images/old/kingW.png": "e7c3b688ecd6e180e3c25f31982b9166",
"assets/assets/images/old/knightB.png": "710497377685773edc29dd1c3dbd0a8f",
"assets/assets/images/old/knightW.png": "cb9f86a206989b04b7171d21dbb8795a",
"assets/assets/images/old/pawnB.png": "9379023f5def61cf680f764cb7000d33",
"assets/assets/images/old/pawnW.png": "56c9aa252c1f006b22f18c953d486acd",
"assets/assets/images/old/queenB.png": "e28adf842b2f45c82ebffdc6f7b24431",
"assets/assets/images/old/queenW.png": "dea010e2723d066c481a6d5d56fea281",
"assets/assets/images/old/rockB.png": "f7d8987d4b71073b84292914d1480f0f",
"assets/assets/images/old/rockW.png": "1e9f7568b625c03908a9918b83c016c6",
"assets/assets/images/pieces/bbd.png": "b8e738ccdc886e11445dd71903b2bc94",
"assets/assets/images/pieces/bbs.png": "4f7ba93d7d99f14a805b33514966cabb",
"assets/assets/images/pieces/bd.png": "cc0ff9da644d949c78b1f09ec20b0541",
"assets/assets/images/pieces/bkd.png": "835e0d6a76b72aebcad3a1862a7ec1f4",
"assets/assets/images/pieces/bkingd.png": "3a3066c798c5fa1d009e391f108bb7ac",
"assets/assets/images/pieces/bkings.png": "0f9bb1d654752c9bef9ddf9b78329dc7",
"assets/assets/images/pieces/bks.png": "b2fb20b2e6de35ca57c86d1bcda1d5b2",
"assets/assets/images/pieces/bpd.png": "8e2dac7be18f5375fb2c8828f435a5f3",
"assets/assets/images/pieces/bps.png": "a1e6931de0db5317669e01e4d68c4427",
"assets/assets/images/pieces/brd.png": "c507f578c03bfbb1139b3660666a4356",
"assets/assets/images/pieces/brs.png": "c67ad8c539c19f8740800097f75ab158",
"assets/assets/images/pieces/bs.png": "b376795a0f71ac99a8c7c752f63ea798",
"assets/assets/images/pieces/wbd.png": "b4cfa7367b2e7d25e91cdba30593fb37",
"assets/assets/images/pieces/wbs.png": "6cd75189c8b33afe7f05b8b1a063ed5a",
"assets/assets/images/pieces/wd.png": "08b0707208e8a12bd19e505672cf7809",
"assets/assets/images/pieces/wkd.png": "471a45eb65bab4a86bb5fd5bfb60aaa4",
"assets/assets/images/pieces/wkingd.png": "13ac063dac2f3bf0cc4e44abb8b3baf5",
"assets/assets/images/pieces/wkings.png": "51ee18a1379442069282422dd5f056dd",
"assets/assets/images/pieces/wks.png": "4d81c2d7fa1cfdcf2bd5766b78bebba7",
"assets/assets/images/pieces/wpd.png": "2cd7f58002ef638a0b8bbbcd69617e5e",
"assets/assets/images/pieces/wps.png": "14a36865229cdfa43b1a99fc6ac0d16c",
"assets/assets/images/pieces/wrd.png": "733e64917c24e5f2fe3074c71f499075",
"assets/assets/images/pieces/wrs.png": "8698eb7766c9c64475d367dfc81be8f8",
"assets/assets/images/pieces/ws.png": "29c5408f343f87f967263eecc3eb7587",
"assets/assets/images/placeholder.png": "1632e46a5c79d43f3125ca62c54189cb",
"assets/assets/images/selected.png": "e785042849ff4d6c1ddb072acd93ba15",
"assets/assets/images/selectedBlue.png": "615b0379ed0c30b25f82d1988c31be19",
"assets/assets/images/tutorial/1.png": "60a185f0e1f4ba390103f019134d47c3",
"assets/assets/images/tutorial/10.png": "4acbb7b963ad8e68cb0633a17927e2e4",
"assets/assets/images/tutorial/11.png": "476d4ec4805cb45002c1570e3b563457",
"assets/assets/images/tutorial/1select.png": "eaf5df943d87d3d006f734f8679d9171",
"assets/assets/images/tutorial/2.png": "7f670075ef406bac3806ca93ce873707",
"assets/assets/images/tutorial/2move.png": "5eba5dcb9e8caa385502ff5d7ae9a7ad",
"assets/assets/images/tutorial/3.png": "2abffec6a5567c200f3b88dbcd8f7954",
"assets/assets/images/tutorial/3takepng.png": "269c42d80a78f3230acdbc25beedca42",
"assets/assets/images/tutorial/4.png": "118d792ac9c822fac2df420c4a1287c4",
"assets/assets/images/tutorial/4grave.png": "2ac72b13e3b1860b30ebd659af2e4689",
"assets/assets/images/tutorial/5.png": "5edec4343d3e8a9b07e880b608f7bc94",
"assets/assets/images/tutorial/5revive.png": "1297235db737c9c4b4550767ec71d056",
"assets/assets/images/tutorial/6.png": "ffde3a0cafc7ea712ec6d8150b71097b",
"assets/assets/images/tutorial/6knigthpng.png": "348949549d827c0191667f6676cead96",
"assets/assets/images/tutorial/7.png": "74df2349763c6836df341cd938b581f8",
"assets/assets/images/tutorial/7win.png": "e41464d09f8f1f212b6905118fb21416",
"assets/assets/images/tutorial/8.png": "52b754408f5a9fa19db9946ab943d271",
"assets/assets/images/tutorial/8clock.png": "d7892101fec9f171e8b06cce0a76802e",
"assets/assets/images/tutorial/9.png": "548a013e1c42276e81f21b4cdd4d0231",
"assets/assets/images/tutorial/9moves.png": "896538dcce5781658916d9ab09b5c25e",
"assets/assets/images/tutorial/m2.png": "c35d548beea5e4da11a6466209e96da3",
"assets/assets/images/tutorial/m3psd.png": "43b8eef12b827feeb7c5175bbb202350",
"assets/assets/images/tutorial/m4png.png": "7f96317a0bfe5a6d01c0931c6c82c4f4",
"assets/assets/images/tutorial/m5.png": "15dc9fbc2fdd062ea6179172762bb24b",
"assets/assets/images/tutorial.psd": "fe1eadb300fb92ad4d845f52350562c5",
"assets/assets/sounds/battle.mp3": "679371f8a449dfaec6e4a3b4c86f52f5",
"assets/assets/sounds/bell.wav": "92bffd8d646dd3dfd1e2c8b86f54d47a",
"assets/assets/sounds/button.mp3": "b6b720746d876dddbbaf0e361c02238f",
"assets/assets/sounds/click.mp3": "bf049b2d59b65a0443d364468b7b9616",
"assets/assets/sounds/notif.mp3": "64ab09622066f9c4e8f45c2ef034e771",
"assets/assets/sounds/titlescreen.mp3": "c7f3e81259ffaa4a2d6347c06d16b26a",
"assets/assets/sounds/viento.ogg": "f83cf6bba1a2164260c1bf31952e7291",
"assets/assets/sounds/wind.mp3": "6be3334ab7128279d35977ab90ef63b0",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/fonts/MaterialIcons-Regular.otf": "e7069dfd19b331be16bed984668fe080",
"assets/NOTICES": "6d64809717b9e9499533d056a351d552",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "6d342eb68f170c97609e9da345464e5e",
"canvaskit/canvaskit.js": "97937cb4c2c2073c968525a3e08c86a3",
"canvaskit/canvaskit.wasm": "3de12d898ec208a5f31362cc00f09b9e",
"canvaskit/profiling/canvaskit.js": "c21852696bc1cc82e8894d851c01921a",
"canvaskit/profiling/canvaskit.wasm": "371bc4e204443b0d5e774d64a046eb99",
"favicon.png": "7aa0b535774121f0dd54eaf29b58c3f3",
"firebase-messaging-sw.js": "8f733150b8f1c6754319099cd3b75921",
"flutter.js": "a85fcf6324d3c4d3ae3be1ae4931e9c5",
"icons/Icon-192.png": "cdcf8f892ff41e7606e93f5295f20de7",
"icons/Icon-512.png": "69c20838d8867ce28c3a1accdad6086b",
"icons/Icon-maskable-192.png": "cdcf8f892ff41e7606e93f5295f20de7",
"icons/Icon-maskable-512.png": "69c20838d8867ce28c3a1accdad6086b",
"index.html": "2b8ca4c7a1f04e3597e4c05868015058",
"/": "2b8ca4c7a1f04e3597e4c05868015058",
"main.dart.js": "7f5816e8c2b2c5cf03a629cf85f7f3bd",
"manifest.json": "ee8467536621544deff4e985916fa474",
"version.json": "4cd08082982fdea3b86ee178c4ff4f8b"
};

// The application shell files that are downloaded before a service worker can
// start.
const CORE = [
  "main.dart.js",
"index.html",
"assets/AssetManifest.json",
"assets/FontManifest.json"];
// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});

// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});

// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});

self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});

// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}

// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
