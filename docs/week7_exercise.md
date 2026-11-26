# Week 7 exercise: malfunction report

Set-up: emulator → ⋯ → Extended Controls → Cellular → Network type → **No network**.

## 1. The four website links

> Fill in what you saw on your emulator, e.g. "Chrome opened and showed
> *No internet* / ERR_INTERNET_DISCONNECTED".

- IIUM portal:
- IIUM website:
- Library:
- KICT:

## 2. Map, dialer and mail

- Map:
- Phone dialer:
- Mail:

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
