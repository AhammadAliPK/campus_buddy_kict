# Campus Buddy KICT 📱

The app we build together in class, week by week — CSCI 4311 Mobile
Application Development (IIUM, KICT).

Never used git before? You only need 4 commands for this whole course, and
every one of them is written out below. Just copy, paste, press Enter.

## ✅ Before you start — checklist (once, before week 1)

- [ ] **GitHub account** — sign up at https://github.com/signup (free).
      Remember your username and password — you'll need them to submit work.
- [ ] **Git installed** — open a terminal and type `git --version`.
      If you see a version number, you're done. If you see "command not
      found", install Git from https://git-scm.com/downloads
- [ ] **Flutter installed** — `flutter doctor` runs and mostly shows ✓
      (we set this up together in lab 1)
- [ ] **An emulator or a phone** that `flutter run` can install to

## Step 1 — Clone this repo (once, at the start of the course)

1. Open a terminal:
   - **Windows:** Start menu → type **Git Bash** → Enter
   - **Mac:** Terminal
2. Type this (or copy-paste it), then press **Enter**:

   ```
   git clone https://github.com/AhammadAliPK/campus_buddy_kict.git
   ```

3. Move into the folder you just downloaded:

   ```
   cd campus_buddy_kict
   ```

✅ Type `ls` and press Enter — you should see `pubspec.yaml`, `lib`,
`android`, `ios`.

## Step 2 — Switch to YOUR section's branch (once)

Everyone gets the same app, but each class has its own branch.

**If you are in Section 1:**

```
git checkout section1
```

**If you are in Section 2:**

```
git checkout section2
```

✅ You should see `Switched to branch 'section1'` (or `'section2'`).

💡 You only do this once. After today, `git pull` (below) is all you need.

## Step 3 — Run the app

1. Download the packages the app needs:

   ```
   flutter pub get
   ```

2. Start your emulator, or plug in your phone, then:

   ```
   flutter run
   ```

✅ The app opens on your device. 💡 The very first build takes a few
minutes — that's normal, not broken.

## Every week — get the latest code we built in class

```
git pull
flutter pub get
flutter run
```

✅ After `git pull` you should see `Already up to date.` or a list of
changed files.

Even if you couldn't finish the lab yourself, `git pull` gives you the
working version from class — study it, run it, learn from it.

💡 If `git pull` shows an error (especially one mentioning "conflict"),
stop and bring your laptop to class or lab — don't guess.

## Assignments — create YOUR branch

**Branch naming convention** (we check your work from this branch):

```
section<N>/week<M>/<matric-no>
```

- `N` = your section (1 or 2)
- `M` = the teaching week the assignment was given (assignments start in
  week 3) — same number as the `week-0M` tag
- `matric-no` = your matric number, e.g. `G251000`

Examples:

| You are… | Assignment given in | Matric no. | Your branch name |
|---|---|---|---|
| Section 1 | week 3 | G251000 | `section1_G251000` |
| Section 2 | week 4 | G251001 | `section2_G251001` |

**Steps** — example below is Section 1, week 3's assignment, matric G251000.
Replace with **your** section, week, and matric:

1. Create your branch from the week tag given in the assignment sheet
   (same number as the week — week 3's assignment → tag `week-03`):

   ```
   git checkout -b section1_G251000 week-03
   ```

2. Build the assignment. **Commit as you go** — many small commits are
   better than one big one:

   ```
   git add -A
   git commit -m "week3: added profile screen"
   ```

3. Submit = push your branch to GitHub:

   ```
   git push -u origin section1_G251000
   ```

   💡 **The first time you ever push**, a browser window opens and asks you
   to sign in to GitHub. That's normal — sign in, click **Authorize**, and
   the push continues. It only happens once.

4. Made more changes after pushing? Commit and push again (no `-u`):

   ```
   git add -A
   git commit -m "week3: fixed layout"
   git push
   ```

✅ Check it worked: open the repo on GitHub
(https://github.com/AhammadAliPK/campus_buddy_kict) → click the dropdown
that says `main` → type your branch name → your code is there. That's your
submission.

## Rules

- **Never** push to `main`, `section1`, or `section2` — those are the
  lecturer's branches (GitHub will block you anyway).
- Only push branches named `section<N>/week<M>/<matric-no>`.

## Troubleshooting

| You see | What it means | Fix |
|---|---|---|
| `git: command not found` | Git isn't installed | Install from git-scm.com/downloads, then **close and reopen** the terminal |
| `flutter: command not found` | Flutter not on PATH | Redo the lab-1 setup, then reopen the terminal |
| `fatal: Repository not found` | Typo in the URL | Copy-paste the exact clone command above |
| Browser window on first push | Git asking who you are | Sign in to GitHub → Authorize. Once only |
| `git pull` error / "conflict" | Your local files touched the same lines | Stop. Ask in class or lab |
| `flutter run` says no devices | Emulator/phone not connected | Start the emulator first (Android Studio → Device Manager) |

## Flutter version used in class

```
Flutter 3.47.6 • channel stable
Dart 3.13.5
```

If something behaves strangely, run `flutter --version` and compare.
