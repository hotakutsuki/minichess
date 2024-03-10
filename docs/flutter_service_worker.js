'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "assets/AssetManifest.json": "c40085d93fdd0243a4fe3b8fe88ef6d9",
"assets/assets/animations/moon.json": "23944282a8e053cb7cdcfc99cd6bcdcc",
"assets/assets/icon/banner.png": "9cef99c2d8fec5115f7d8a299f618c32",
"assets/assets/icon/banner.psd": "522312036991b146907b4c9b0c2b9d80",
"assets/assets/icon/bannerold.png": "9a25f65d70e0ce63b26244b1444ac299",
"assets/assets/icon/debug.log": "41accd61df01585f6895e28b5cfebc5c",
"assets/assets/icon/icon.png": "faeb5c825ff2a64ea6b1195a718aab9e",
"assets/assets/icon/icon320.png": "166b55aede75bd06714b6b20f09494f5",
"assets/assets/icon/icon512.png": "51ee18a1379442069282422dd5f056dd",
"assets/assets/icon/icon512old.png": "ab1abb99ed61990c1f37b43ec41649f5",
"assets/assets/icon/iconold.png": "7b250820d4c3f34da4c71db4bf78ca12",
"assets/assets/images/appstorelogo.png": "bb7264c4e22d66bcdbccd4a41dfb1a36",
"assets/assets/images/avatar.png": "f4e0bcf3c42ed46c0f7c3aeb061d4d84",
"assets/assets/images/backgrounds/bg.jpeg": "a41fbd90c77cdd683e379615a168d906",
"assets/assets/images/board.png": "aef63029ab2283fc8868ab23e40d6146",
"assets/assets/images/border.png": "f8976fa640843c822d82e62465df839c",
"assets/assets/images/darkborder.png": "1e02d9a9e7e34ac4a294c5856b1e58ae",
"assets/assets/images/glogo.png": "85346762215169a2f0013f2283bf56e4",
"assets/assets/images/gplay.png": "8412cc2c8fb288c9c3cb9063e2e2aa11",
"assets/assets/images/icon.png": "51ee18a1379442069282422dd5f056dd",
"assets/assets/images/iconold.png": "7b250820d4c3f34da4c71db4bf78ca12",
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
"assets/assets/images/tale/SC1/bg1.png": "1099603cedebec19d85aa3684c3becb5",
"assets/assets/images/tale/SC1/bg2.png": "2887a488d7b6f0414393dc19bfee751b",
"assets/assets/images/tale/SC1/bg3.png": "a0804f49e7839e64966f2e40d98c1a52",
"assets/assets/images/tale/SC1/bg4.png": "9bf0104793538a7e2b4a1db39f094af8",
"assets/assets/images/tale/SC1/ch.png": "6e47145f52a087f7a7419b21822c940f",
"assets/assets/images/tale/SC10/bg4.png": "a7516cbba1dacde19a5a8778693c68cf",
"assets/assets/images/tale/SC10/ch.png": "a8a1e9f3137d74e4cb2e600833d6a094",
"assets/assets/images/tale/SC2/bg1.png": "47f6a273cc0b81354db95a51e21a7e77",
"assets/assets/images/tale/SC2/bg3.png": "a7d0c7675f1ddcfb88574fb82b411751",
"assets/assets/images/tale/SC2/bg4.png": "8275caf0d2ec4295e8c061e6f9519058",
"assets/assets/images/tale/SC2/ch.png": "759db2c4bcd34b379ce8d826c1e5700c",
"assets/assets/images/tale/SC3/bg1.png": "32e4cd9fa78d2b39ff6b936a0854f838",
"assets/assets/images/tale/SC3/bg2.png": "c7631b98b99143ea5b81d4e368e78f0c",
"assets/assets/images/tale/SC3/bg3.png": "2bab9120ee5becb5bd59ac4abc38b91c",
"assets/assets/images/tale/SC3/bg4.png": "8a94ea23ef4a6e9b90c2ee97ea436957",
"assets/assets/images/tale/SC3/cg.png": "f4c0cd66e3728d871514512ca6ec1bc7",
"assets/assets/images/tale/SC4/bg1.png": "d32cdf91371ea7c4a44e6e68d8eac5d4",
"assets/assets/images/tale/SC4/bg2.png": "bfd1de3b5d7b7bd3ca90d57a634c082a",
"assets/assets/images/tale/SC4/bg3.png": "c3a8fcb32fe05849a1dd978477583fbd",
"assets/assets/images/tale/SC4/bg4.png": "751a1953494a1ec1d3dbb568860e507d",
"assets/assets/images/tale/SC4/ch.png": "efdcfd2c69cc94083ecf49cbb60a71f5",
"assets/assets/images/tale/SC5/bg1.png": "653ccdb1fb055ce4fc8c69b5fb3d5c8e",
"assets/assets/images/tale/SC5/bg2.png": "6ce920e186e526bb5f1f61059f65726c",
"assets/assets/images/tale/SC5/bg3.png": "23ff3a180f617791d838d99eca632e74",
"assets/assets/images/tale/SC5/bg4.png": "467985f1424dbfd8c2bba49f53dcf725",
"assets/assets/images/tale/SC5/ch.png": "83776e468b7a0b0eff036dbfc388f595",
"assets/assets/images/tale/SC6/bg1.png": "239ec9eb10b38e17ccb6f6f5fee884f9",
"assets/assets/images/tale/SC6/bg2.png": "0b619bf25d07c1ac286d7d32a4d54c3f",
"assets/assets/images/tale/SC6/bg3.png": "af537055def759634f60d6018feff2de",
"assets/assets/images/tale/SC6/bg4.png": "bd175c83686505b62113d49b4a3c4335",
"assets/assets/images/tale/SC6/ch.png": "7d59d96cd7a13509c2ac16fa4b7ba202",
"assets/assets/images/tale/SC7/bg3.png": "cbe1d8547e3af4fa84491938124c49aa",
"assets/assets/images/tale/SC7/bg4.png": "56d3cc3c94f65b947447fe18d5c8d38b",
"assets/assets/images/tale/SC7/ch.png": "bf3aa10fb97ea5840efe6a9eba17380a",
"assets/assets/images/tale/SC8/bg3.png": "987acefc5052e98abbd61caae626f70c",
"assets/assets/images/tale/SC8/bg4.png": "7f1fc6a81dd1f5d9ffd3d7a68938eb4a",
"assets/assets/images/tale/SC8/ch.png": "66c460be18a3a278e8f3b9924c2e7485",
"assets/assets/images/tale/SC9/bg1.png": "8208b27664249e2de03438e6939d0578",
"assets/assets/images/tale/SC9/bg2.png": "51239d99c12fb216cf6c9aae839ab50e",
"assets/assets/images/tale/SC9/bg3.png": "a0804f49e7839e64966f2e40d98c1a52",
"assets/assets/images/tale/SC9/bg4.png": "6b8ffabb3580ec0e0a2a10c88b05cade",
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
"assets/assets/sounds/button.mp3": "b6b720746d876dddbbaf0e361c02238f",
"assets/assets/sounds/en/1.mp3": "e48a8035a2fc9545dbc557a2ad655fb6",
"assets/assets/sounds/en/10.mp3": "5d1cebdcf2eec68132329968aa75893e",
"assets/assets/sounds/en/2.mp3": "4129617e8bd1fb0acfa478ef49ec7c40",
"assets/assets/sounds/en/3.mp3": "5f03c09cc38dee57cdc84e7f74d6ca7e",
"assets/assets/sounds/en/4.mp3": "adff846ef4d5b036e926de835ad7d0e3",
"assets/assets/sounds/en/5.mp3": "d630a5457b6b81b0901ee5e4ef66d834",
"assets/assets/sounds/en/6.mp3": "b9eddfdf74e3bb75c1cad6187cd7bf29",
"assets/assets/sounds/en/7.mp3": "5b4e6acc4588533ab71a9c0f725cb12e",
"assets/assets/sounds/en/8.mp3": "7250c93e02fbd99b123864e5ca531ec4",
"assets/assets/sounds/en/9.mp3": "d3f97be0c4bb5617c94ab488da7d1088",
"assets/assets/sounds/es/1.mp3": "bf917598dd5cf75c9c3586a5824602c9",
"assets/assets/sounds/es/10.mp3": "a06ddbb1a31f014552219f282fa1c830",
"assets/assets/sounds/es/2.mp3": "df8caec6ebae6926d55bd8056390c33c",
"assets/assets/sounds/es/3.mp3": "ae7dc97c8a34b2d29b6cfa64b604b71e",
"assets/assets/sounds/es/4.mp3": "118aa695ec05ccf9bdb2cba88f793490",
"assets/assets/sounds/es/5.mp3": "0bc220b31d355934654fdf9c6c18a381",
"assets/assets/sounds/es/6.mp3": "022ca2ea41d7627555597069cec39280",
"assets/assets/sounds/es/7.mp3": "30b3563bac1ef9f8f3c5bdc762ab9f51",
"assets/assets/sounds/es/8.mp3": "028970d36bdc6028c591223da8142e77",
"assets/assets/sounds/es/9.mp3": "ebc2e3aa1cc0d00c7aeacafcb5018f80",
"assets/assets/sounds/titlescreen.mp3": "c7f3e81259ffaa4a2d6347c06d16b26a",
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
"index.html": "50dd7d7fc984c45bb03ab893bb7b6318",
"/": "50dd7d7fc984c45bb03ab893bb7b6318",
"main.dart.js": "5ade0013f70f0cd2e5cc530a7cd803eb",
"manifest.json": "ee8467536621544deff4e985916fa474",
"version.json": "76de264300f2eef216ce0b503e383d3e"
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
