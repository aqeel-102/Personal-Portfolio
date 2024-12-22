'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "957f773170351d5ecd716e784db9a13f",
"assets/AssetManifest.bin.json": "48d5b4700d2c982b62108d3d0e4fe92a",
"assets/AssetManifest.json": "093f5ce0d163b95462021c9bb209be35",
"assets/assets/1.jpg": "8da5421b8ff54dbe4154713c11eec378",
"assets/assets/1.png": "d53f7123f7fa8bec257f54882850cf3e",
"assets/assets/2.jpg": "bd607e91c5d61fcbfdb7f7c87b14c363",
"assets/assets/2.png": "3b4e955d2475e973e3ba392928599c2d",
"assets/assets/3.png": "5f74461da68688d3fbdebda0235009fd",
"assets/assets/4.png": "c8407381981efb5a97800a9f9cd842e2",
"assets/assets/5.png": "8843007bc2c8cc3f8646de825d67ce62",
"assets/assets/6.png": "58027286d52a9273fa1412fbc40f6a83",
"assets/assets/7.png": "00724b64d5c86c71d293cb1240c71ecb",
"assets/assets/8.png": "3c1b4d3c7674c49c1be29a5e29fde439",
"assets/assets/9.png": "36deff7d083147aa43566e3f6bb7e455",
"assets/assets/a.png": "e1e67a9dfcafdc85d47922f3ed18e290",
"assets/assets/aa.png": "8360a96092cbe1ee73f9f54603f061fb",
"assets/assets/b.png": "a5c8d6878b745371e2e054463eda746a",
"assets/assets/bb.png": "aeec72e903a0877df2cd9d8ff0ed975d",
"assets/assets/c.png": "0b849c72f38362fe12072a4916660013",
"assets/assets/c2.png": "0094a8853db3d303390adc40b918892f",
"assets/assets/cc.png": "9c2495e02f6154989c1fe900cd8f14e9",
"assets/assets/css.png": "594aa284c4862d5ee3766d6d0bd42547",
"assets/assets/d.png": "a67ac9d4106a9e0c3fd0446dbfb5e26d",
"assets/assets/dart.png": "4d9daef908521bc755d7f08edef1fe10",
"assets/assets/darttxt.png": "9c836a1c10c99b1777e4afb0971d31c0",
"assets/assets/dd.png": "248558e9e1e9a1f0c683374c2fa4f71d",
"assets/assets/dp.jpg": "a8783a150be1593d967629b01bb7cb7d",
"assets/assets/e.png": "614feb06540c32b46f1c660f84bd5fa7",
"assets/assets/expensetracker.png": "15d2e8931266f3cf6e8afff5da21fc01",
"assets/assets/f.png": "74ae0afddf6c566cafbf98cd68b88b46",
"assets/assets/firebase.png": "45ec5c8523c42019e2aa9fe5436750af",
"assets/assets/flutter.png": "e02a6c427d3f2f6128219c4916cc4c6f",
"assets/assets/github.png": "a17150d90465d2bb381781ab5baf0147",
"assets/assets/gmail.png": "5dfa961f2b38f97f36d23650d237b964",
"assets/assets/html.png": "2e4ed85a249e0d819df884d55176c16c",
"assets/assets/javascript.png": "a00831a712bb4f59eba35cb2c4c7a737",
"assets/assets/linked%2520in.png": "968ea62882943e88bbd318ae5fa67429",
"assets/assets/nft.jpg": "f307fde3e2ae980ca05445ebbdf79b43",
"assets/assets/poerfolioimg.jpg": "2c8240452fe250706fcac62c7bed54af",
"assets/assets/Portfoilio%2520Website.png": "3327d982a55c8a34adb8da1ea4e41a39",
"assets/assets/portfoli.jpg": "89dbc288b0a8a049fe0a9790d71667d2",
"assets/assets/portfolio.png": "99c3bb0f5773f803f3859883bf374432",
"assets/assets/portolio_final.png": "084885d284f55e0e6bb955e13eceb481",
"assets/assets/simpletools.png": "44b47214f5ab1199e44c3b19de82e8dd",
"assets/assets/tracker.png": "08ffea66f3378916f94924d6387a0147",
"assets/FontManifest.json": "5a32d4310a6f5d9a6b651e75ba0d7372",
"assets/fonts/MaterialIcons-Regular.otf": "b7cd03d1d20176e11398ce14b3bd17d2",
"assets/NOTICES": "6604707fe69fe185d2ea8c70bb5bdf71",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "e986ebe42ef785b27164c36a9abc7818",
"assets/packages/font_awesome_flutter/lib/fonts/fa-brands-400.ttf": "4769f3245a24c1fa9965f113ea85ec2a",
"assets/packages/font_awesome_flutter/lib/fonts/fa-regular-400.ttf": "3ca5dc7621921b901d513cc1ce23788c",
"assets/packages/font_awesome_flutter/lib/fonts/fa-solid-900.ttf": "a2eb084b706ab40c90610942d98886ec",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "66177750aff65a66cb07bb44b8c6422b",
"canvaskit/canvaskit.js.symbols": "48c83a2ce573d9692e8d970e288d75f7",
"canvaskit/canvaskit.wasm": "1f237a213d7370cf95f443d896176460",
"canvaskit/chromium/canvaskit.js": "671c6b4f8fcc199dcc551c7bb125f239",
"canvaskit/chromium/canvaskit.js.symbols": "a012ed99ccba193cf96bb2643003f6fc",
"canvaskit/chromium/canvaskit.wasm": "b1ac05b29c127d86df4bcfbf50dd902a",
"canvaskit/skwasm.js": "694fda5704053957c2594de355805228",
"canvaskit/skwasm.js.symbols": "262f4827a1317abb59d71d6c587a93e2",
"canvaskit/skwasm.wasm": "9f0c0c02b82a910d12ce0543ec130e60",
"canvaskit/skwasm.worker.js": "89990e8c92bcb123999aa81f7e203b1c",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "f393d3c16b631f36852323de8e583132",
"flutter_bootstrap.js": "5d8ee170c2c94ccd99adb26f465e8bdc",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "276b090835851c1562a7139950d0f9ab",
"/": "276b090835851c1562a7139950d0f9ab",
"main.dart.js": "00219d1d184654d930bab26f7f998004",
"manifest.json": "d8fe34f7ae4c072a77b924e01dac8a50",
"version.json": "9b818ca9511483c901bed1545384376c"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
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
        // Claim client to enable caching on first launch
        self.clients.claim();
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
      // Claim client to enable caching on first launch
      self.clients.claim();
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
