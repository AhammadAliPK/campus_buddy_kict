# Week 7 exercise: malfunction report

Set-up: emulator → ⋯ → Extended Controls → Cellular → Network type → **No network**.

## 1. The four website links

With no network, each website link still leaves the app: Android hands the
`https:` address to the browser, and the browser opens but cannot load the page.

- IIUM portal: Chrome opened and showed "No internet" (ERR_INTERNET_DISCONNECTED).
- IIUM website: Chrome opened and showed "No internet" (ERR_INTERNET_DISCONNECTED).
- Library: Chrome opened and showed "No internet" (ERR_INTERNET_DISCONNECTED).
- KICT: Chrome opened and showed "No internet" (ERR_INTERNET_DISCONNECTED).

With "Open in-app" switched on, the same "No internet" page appears inside the
in-app browser instead. No SnackBar appears, because launching the browser
itself worked.

## 2. Map, dialer and mail

- Map: the Maps app opened at the IIUM Gombak location, but the map tiles did not
  load (grey or blank map) because there is no data connection.
- Phone dialer: the dialer opened with +60361964000 filled in, the same as with
  the network on (calls use the phone network, not the internet).
- Mail: the mail app opened with the advisor address, subject and body filled in.
  The email can be written, but it stays in the outbox until the network is back.
  (On an emulator with no mail app, the "Cannot open … on this device" SnackBar
  appears instead.)

## Why the two groups behave differently

The website links hand an `https:` address to the browser, and the browser then
has to download the page from IIUM's servers, which is impossible offline, so
the browser shows its own "no internet" page. `tel:`, `mailto:` and `geo:` only
ask another app on the phone to open; the dialer, mail app and maps app start
fine without a connection (a call or an email is only sent later). Our
`LinkOpener` reports success in both cases, because launching the app worked;
it never checks whether the page can load. The place to check the internet
first is `LinksScreen._open` (or a check before building the website rows),
before calling `LinkOpener.open` for an `https:` link. That is next week's topic.
