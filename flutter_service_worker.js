'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "favicon.png": "5dcef449791fa27946b3d35ad8803796",
"main.dart.js": "3670e91c99745884625062881917bce2",
"index.html": "d834f5e3e235e66727316d497481b54e",
"/": "d834f5e3e235e66727316d497481b54e",
"flutter.js": "195f32f4217e034162a6697208586f44",
"manifest.json": "c7c685fa0dd5e47b44b5549304857ce0",
"canvaskit/canvaskit.js": "687636ce014616f8b829c44074231939",
"canvaskit/canvaskit.wasm": "d4972dbefe733345d4eabb87d17fcb5f",
"canvaskit/profiling/canvaskit.js": "ba8aac0ba37d0bfa3c9a5f77c761b88b",
"canvaskit/profiling/canvaskit.wasm": "05ad694fda6cfca3f9bbac4b18358f93",
"assets/AssetManifest.json": "14be0d6260d0600929e5a40ae982a8b4",
"assets/shaders/ink_sparkle.frag": "a04e492a05f9fd1a8cc6f12163b184dd",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "6d342eb68f170c97609e9da345464e5e",
"assets/packages/fluttertoast/assets/toastify.js": "e7006a0a033d834ef9414d48db3be6fc",
"assets/packages/fluttertoast/assets/toastify.css": "a85675050054f179444bc5ad70ffc635",
"assets/FontManifest.json": "9ab68d6b9a18f15b7e5c73071b8f2c4e",
"assets/assets/plus-icon.svg": "5e6695cfb706c47d0ff26f94ac805f11",
"assets/assets/switch-lock2.svg": "e196329587afbbe38045399c2f5dbcd4",
"assets/assets/light/plus-icon.svg": "767037d5912bb6eeac79257f177cb7cd",
"assets/assets/light/live-icon-selected.svg": "ab60aa770c64edf51022f570162f50c2",
"assets/assets/light/history-icon-selected.svg": "04c86440f19c3c749b6ee9036c48f72b",
"assets/assets/light/history-icon.svg": "d5aafe24baefe5d70e133aad30d9bada",
"assets/assets/light/live-icon.svg": "a862e9cd4a3ff277bf1087b6ddc112a7",
"assets/assets/light/plus-icon-selected.svg": "c4f17f831e2f4dccd55267b26bdbab03",
"assets/assets/gpsplus.png": "38a3cfb6eb2703ea87c812b3c57a4d5a",
"assets/assets/switchOnOff.svg": "cee1cc6cc545a10f3352860b765db686",
"assets/assets/timezoneWhite.svg": "7aaece246847229de7f54d957f47f64c",
"assets/assets/fence-config-banner.svg": "7974caa6d2ace578804e376100ba6d33",
"assets/assets/ellipse.svg": "97eb4d8ad8f31c49c44cbd6b63464796",
"assets/assets/dark/plus-icon.svg": "5e6695cfb706c47d0ff26f94ac805f11",
"assets/assets/dark/live-icon-selected.svg": "24a0eb10212fdd78a44eba1bbe60d511",
"assets/assets/dark/history-icon-selected.svg": "a317e339a10c84ad4fa4b110ea3789f7",
"assets/assets/dark/history-icon.svg": "1ae01ec6c1afa40ce380a867b97debbb",
"assets/assets/dark/live-icon.svg": "d368b107f160af33f10be32ab4c8b683",
"assets/assets/dark/plus-icon-selected.svg": "c2a1b86d748b86344beb9d55fa0dccfa",
"assets/assets/gps-pointer.json": "05b9173f571dbece8c0f0ffc8220bf54",
"assets/assets/minimotor.svg": "1c1157eddf60e46f0383fd78bd75ae21",
"assets/assets/switch-lock-banner.svg": "7ffe612b649b2688f6a8447ea9b556cf",
"assets/assets/lang.svg": "89b28d8e2f1af3bec736c10ed8741263",
"assets/assets/timezone.svg": "90e7c15b35f78602691a41e2b7ad1e9c",
"assets/assets/speed-alarm.png": "e2613ed0c78ae6ee06c3a9539c798d96",
"assets/assets/alarmNew.svg": "3db32b2c6141cc33599ed49c27eec775",
"assets/assets/theme.svg": "017ffa79399087a3bfdf736a0252f5ac",
"assets/assets/addVehicle.svg": "195bc3bf765c50bf9181260b9f805d18",
"assets/assets/speed-alarm-banner.svg": "13603bb966026f13e85bb9b18a1fb7b4",
"assets/assets/arrow.png": "ed66f716e0c8647544090a8f604ecce5",
"assets/assets/flutter-logo.png": "3b87320b0f7fffa16e05e4829fd92da3",
"assets/assets/switch-lock.svg": "e196329587afbbe38045399c2f5dbcd4",
"assets/assets/finish.png": "cc7faec3a76b00a82463fbc42b08d854",
"assets/assets/custom-icon.png": "a5d3d56e9ff5f6226d8487ca8ec4585f",
"assets/assets/liveDemo.json": "4bcd9d98f3c2111583713aadde3e722e",
"assets/assets/plus.svg": "25119557d0cd59c96a089502f036a0d5",
"assets/assets/backDrawer.png": "0ce3ce9203942947fa07736f2a1bfff4",
"assets/assets/switch-unlock-banner.svg": "ac46e299b2bf3a49bce1925ce2974521",
"assets/assets/minicar.svg": "f53f54029a5cb49ae9d5abac6d41ad24",
"assets/assets/user_outline.png": "8dc6cd2df2a0f0900c150422b9907991",
"assets/assets/fence-control.png": "166ba3fd511da0503909516b260c3c9f",
"assets/assets/langWhite.svg": "fb8dcc9e99f29f82497d3c735bd26533",
"assets/assets/arrow-bg.png": "2f00bcfa29a9d80f5e37c97c1a48ae90",
"assets/assets/minitruck.svg": "cc90b0cfba9370a1989b09d1d56dac08",
"assets/assets/fencePn.svg": "75f0d2f576fd27d45a184ae8c5dff79d",
"assets/assets/profileimg.svg": "48d87f91a2a3577dc763cd0c900eae39",
"assets/assets/plus-icon-selected.svg": "c2a1b86d748b86344beb9d55fa0dccfa",
"assets/assets/simpleCar.svg": "f43e95db06b1826a38857d25f33beb17",
"assets/fonts/iran-sans.ttf": "0f5573de75f1112d5cb5863eef1951fd",
"assets/fonts/MaterialIcons-Regular.otf": "e7069dfd19b331be16bed984668fe080",
"assets/NOTICES": "7cde7c709b167664d1026d38f33c5403",
"version.json": "5c6efea802bc6455d4ed9496585b0f15",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea"
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
