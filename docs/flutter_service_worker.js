'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "assets/AssetManifest.json": "84dcc58d36bd594930c6f4bd38126a0e",
"assets/assets/icon/banner.png": "9a25f65d70e0ce63b26244b1444ac299",
"assets/assets/icon/debug.log": "40d262824adbaff09e7abcf698334efa",
"assets/assets/icon/icon.png": "7b250820d4c3f34da4c71db4bf78ca12",
"assets/assets/icon/icon512.png": "ab1abb99ed61990c1f37b43ec41649f5",
"assets/assets/images/1select.png": "eaf5df943d87d3d006f734f8679d9171",
"assets/assets/images/2move.png": "5eba5dcb9e8caa385502ff5d7ae9a7ad",
"assets/assets/images/3takepng.png": "269c42d80a78f3230acdbc25beedca42",
"assets/assets/images/4grave.png": "2ac72b13e3b1860b30ebd659af2e4689",
"assets/assets/images/5revive.png": "1297235db737c9c4b4550767ec71d056",
"assets/assets/images/6knigthpng.png": "348949549d827c0191667f6676cead96",
"assets/assets/images/7win.png": "e41464d09f8f1f212b6905118fb21416",
"assets/assets/images/8clock.png": "d7892101fec9f171e8b06cce0a76802e",
"assets/assets/images/9moves.png": "896538dcce5781658916d9ab09b5c25e",
"assets/assets/images/avatar.png": "f4e0bcf3c42ed46c0f7c3aeb061d4d84",
"assets/assets/images/bishopB.png": "f8b7fd33142018c5a6da6c5355c0d1fa",
"assets/assets/images/bishopW.png": "f356fb25fb9aa54b024bfc81a490bb3f",
"assets/assets/images/board.png": "509c5ce76ba0d682bc5c36d15228f1b1",
"assets/assets/images/glogo.png": "85346762215169a2f0013f2283bf56e4",
"assets/assets/images/gplay.png": "8412cc2c8fb288c9c3cb9063e2e2aa11",
"assets/assets/images/icon.png": "7b250820d4c3f34da4c71db4bf78ca12",
"assets/assets/images/kingB.png": "ebeb5a958d79282276ebc1dc14519464",
"assets/assets/images/kingW.png": "e7c3b688ecd6e180e3c25f31982b9166",
"assets/assets/images/knightB.png": "710497377685773edc29dd1c3dbd0a8f",
"assets/assets/images/knightW.png": "cb9f86a206989b04b7171d21dbb8795a",
"assets/assets/images/m2.png": "c35d548beea5e4da11a6466209e96da3",
"assets/assets/images/m3psd.png": "43b8eef12b827feeb7c5175bbb202350",
"assets/assets/images/m4png.png": "7f96317a0bfe5a6d01c0931c6c82c4f4",
"assets/assets/images/m5.png": "15dc9fbc2fdd062ea6179172762bb24b",
"assets/assets/images/pawnB.png": "9379023f5def61cf680f764cb7000d33",
"assets/assets/images/pawnW.png": "56c9aa252c1f006b22f18c953d486acd",
"assets/assets/images/placeholder.png": "1632e46a5c79d43f3125ca62c54189cb",
"assets/assets/images/queenB.png": "e28adf842b2f45c82ebffdc6f7b24431",
"assets/assets/images/queenW.png": "dea010e2723d066c481a6d5d56fea281",
"assets/assets/images/rockB.png": "f7d8987d4b71073b84292914d1480f0f",
"assets/assets/images/rockW.png": "1e9f7568b625c03908a9918b83c016c6",
"assets/assets/images/selected.png": "615b0379ed0c30b25f82d1988c31be19",
"assets/assets/images/tutorial.psd": "47fbb255ff065eaf9ab921e8954bc9df",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/fonts/MaterialIcons-Regular.otf": "e7069dfd19b331be16bed984668fe080",
"assets/NOTICES": "fe9180bc09f41b25bcfc5ac9c1294ef4",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "6d342eb68f170c97609e9da345464e5e",
"canvaskit/canvaskit.js": "97937cb4c2c2073c968525a3e08c86a3",
"canvaskit/canvaskit.wasm": "3de12d898ec208a5f31362cc00f09b9e",
"canvaskit/profiling/canvaskit.js": "c21852696bc1cc82e8894d851c01921a",
"canvaskit/profiling/canvaskit.wasm": "371bc4e204443b0d5e774d64a046eb99",
"favicon.png": "04db912f860ff064712ceb47f4136f97",
"firebase-messaging-sw.js": "8f733150b8f1c6754319099cd3b75921",
"flutter.js": "a85fcf6324d3c4d3ae3be1ae4931e9c5",
"icons/Icon-192.png": "fcc2647ea7211a37e0562c8afdba0ebc",
"icons/Icon-512.png": "76e5bf89ef26d5a0e3693aa763f93486",
"icons/Icon-maskable-192.png": "fcc2647ea7211a37e0562c8afdba0ebc",
"icons/Icon-maskable-512.png": "76e5bf89ef26d5a0e3693aa763f93486",
"index.html": "f3310f6b17fa14a26f808545e29b1ef3",
"/": "f3310f6b17fa14a26f808545e29b1ef3",
"main.dart.js": "7e19db866428573dca564332106c79bc",
"manifest.json": "d4e8251ce9c21a0d6a1a85beb4c41a3d",
"version.json": "301a202b8c17c58894e9766ec6d913af"
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
