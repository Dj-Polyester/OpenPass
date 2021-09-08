# Installation

## 1. VSCode

https://code.visualstudio.com/Download

## 2. Flutter

https://flutter.dev/docs/get-started/install/linux#get-sdk

### Flutter SDK

1. **Linux** - flutter_linux_2.2.3-stable.tar.xz \
   **Windows** - flutter_linux_2.2.3-stable.zip

```
wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_2.2.3-stable.tar.xz
```

2. Git repository

```
git clone https://github.com/flutter/flutter.git
git branch -a #list available versions
```

### 2. Export path

**Linux**

```
touch /etc/profile.d/flutter.sh
echo 'export PATH="$PATH:$HOME/flutter/bin"' > /etc/profile.d/flutter.sh
```

**Windows** \
Control Panel -> set environment variables

### 3. Flutter doctor (optional for dependencies, or missing files)

```
flutter doctor [-v]
```

## Android emulator (IOS devices require `xcode`)

### Install cmdline-tools

https://developer.android.com/studio#command-tools

In my case: `cd ~/Android/cmdline-tools/version/bin`

### Install sdk (sdkmanager)

```
./sdkmanager --help #shows commands
./sdkmanager --sdk_root=$PATH #default path is ./
./sdkmanager --list #list available packages
./sdkmanager [--install] $PACKAGE_NAME #to install packages
./sdkmanager --licenses #accept licenses
```

### Install avds (avdmanager)

```
./avdmanager create avd --name $AVD_NAME --package $PACKAGE_NAME
#example below
echo "no" | avdmanager --verbose create avd --force --name "pixel_11.0" --device "pixel" --package "system-images;android-30;google_apis;x86" --tag "google_apis" --abi "x86"#android 11
```

https://gist.github.com/mrk-han/66ac1a724456cadf1c93f4218c6060ae

API levels: https://en.wikipedia.org/wiki/Android_version_history

### Delete avds

```
rm -rf ~/.android/avd/*
```

### Run emulator

```
cd ~/Android/emulator
./emulator --help #shows commands
./emulator -list-avds #get $AVD_NAME
./emulator -avd $AVD_NAME -gpu host #host is host machine, requires gpu acceleration
```

### ERROR: Running multiple emulators with the same AVD is an experimental feature.

```
rm -rf "~/.android/avd/$AVD_NAME.avd/\*.lock"
```

### configure avd using config.ini file

```
vim avd/$AVD_NAME.avd/config.ini
#hw.keyboard to en/disable keyboard
#hw.mainKeys to en/disable controls
```

# Dart

- Single threaded

- Not sequential

## `final` vs `const`

```
final varname = init(); //Runtime constant, single assignment
const constant = 3; //Compile time constant
```

## Null safety

```
int nonNullableVar = 24;//Null safety enabled by default, not nullable
int? nullableVar;//Do not need to initialize
```

## Null Assertion Operator (`!`)

> If you’re sure that an expression with a nullable type isn’t null, you can use a null assertion operator (`!`) to make Dart treat it as non-nullable. By adding `!` just after the expression, you tell Dart that the value won’t be null, and that it’s safe to assign it to a non-nullable variable.
>
> <cite>https://dart.dev/codelabs/null-safety</cite>

```
String? str = "hello";
...
String tmp = str!;//Ensure str is not null
```

## Other operators

```
List? alist = null;
...
alist?.forEach((item) => item*2);
```

```
double currency = tl ?? usd;
currency ??= tl // currency = currency ?? tl
```

## Lazy evaluation (`late`)

```
late double tl;//currently unknown
...
tl = init();
```

```
late double tl = init()//evaluates just before the first read
```

https://www.dartpad.dev/?null_safety=true for experiments

# Flutter

To create `flutter create`
To run `flutter run`

`CTRL+SHIFT+P` in vscode.

## Stateless widgets

```
class CustomStatelessWidget extends StatelessWidget {
  const CustomStatelessWidget({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(

    );
  }
}
```

## Stateful widgets

```
class CustomStatefulWidget extends StatefulWidget {
  const CustomStatefulWidget({ Key? key }) : super(key: key);

  @override
  _CustomStatefulWidgetState createState() => _CustomStatefulWidgetState();
}

class _CustomStatefulWidgetState extends State<CustomStatefulWidget> {
  @override
  void initState() {
    // Called when this object is inserted into the tree.
    super.initState();
  }
  @override
  void dispose() {
    // Called when this object is removed from the tree.
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Container(

    );
  }
}
```

## Widget tree

## `setState()`

## Provider package

https://medium.com/flutter-community/making-sense-all-of-those-flutter-providers-e842e18f45dd

Use `pubspec.yaml` to install dependencies.

### context.read, context.select, context.watch

### Cannot use `context.read` in `build`

https://stackoverflow.com/a/62434596/10713877

# Avoid rebuilding widgets

- Push the state to the **LEAVES**.

- Use **CONST** widgets where possible. (This is equivalent to caching a
  widget and re-using it.)

- If a subtree does not change, **CACHE** the widget that represents that
  subtree and re-use it each time it can be used.

- Minimize the number of nodes transitively created by the build method and
  any widgets it creates. Ideally, a stateful widget would only create a
  single widget, and that widget would be a [RenderObjectWidget].
  (Obviously this isn't always practical, but the closer a widget gets to
  this ideal, the more efficient it will be.)

- Avoid changing the depth of any created subtrees or changing the type of
  any widgets in the subtree. For example, rather than returning either the
  child or the child wrapped in an [IgnorePointer], always wrap the child
  widget in an [IgnorePointer] and control the [IgnorePointer.ignoring]
  property. This is because changing the depth of the subtree requires
  rebuilding, laying out, and painting the entire subtree, whereas just
  changing the property will require the least possible change to the
  render tree (in the case of [IgnorePointer], for example, no layout or
  repaint is necessary at all).

- If the depth must be changed for some reason, consider wrapping the
  common parts of the subtrees in widgets that have a [GlobalKey] that
  remains consistent for the life of the stateful widget. (The
  [KeyedSubtree] widget may be useful for this purpose if no other widget
  can conveniently be assigned the key.)

https://api.flutter.dev/flutter/widgets/StatefulWidget-class.html#performance-considerations

# SQLITE

Use `text` instead of `string` for character representation
String is converted to numeric by default. Sqflite retrieves `string` as `int`

`sqflite` package (the most popular sqlite implementation for flutter): \
https://pub.dev/packages/sqflite

## Important:

You may want to consider the popular package `hive`, which is clamed to be about ten times faster than `sqflite` for database operations. \
Details: https://pub.dev/packages/hive

Or you can use NoSQL/document stored popular alternative, `Firebase`: \
https://flutter.dev/docs/development/data-and-backend/firebase

# Miscellanous

## Convert between list - map (Syntactic sugar)

https://www.bezkoder.com/dart-convert-list-map/

## Visibility of a widget

https://medium.com/flutter/managing-visibility-in-flutter-f558588adefe
https://stackoverflow.com/a/66268351/10713877

## Wrap Around and Match Parent

https://stackoverflow.com/questions/42257668/the-equivalent-of-wrap-content-and-match-parent-in-flutter

## ListView.builder not updating after insert

https://stackoverflow.com/a/64417638/10713877
