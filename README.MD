#### Unmystify: Deobfuscating Firebase Crashlytics Stack Traces

`Unmystify is a user-friendly tool for deobfuscating Firebase Crashlytics stack traces. It allows you to analyze and understand crash reports in your Android projects by converting obfuscated stack traces into readable ones`

### Features
- Deobfuscate Firebase Crashlytics stack traces locally without uploading mapping files.
- Generate a mapping file for your Android Studio project or select an existing one.
- Specify the output file name or use the default naming convention.
- View the deobfuscated stack trace in the terminal for easy analysis.
- Simple command-line interface for quick and efficient usage.

### Prerequisites
- Macos Terminal `for now`.
- Android Studio project with Gradle build system.
- Android SDK.


## Usage

```bash
cd unmystify
chmod +x unmystify.sh generateMapping.sh
```

### Generating Mapping File
- Generate a mapping file for your released android APK:
- Replace `/path/to/android-studio-project-root` with your project's `root directory`.

```bash
./generateMapping.sh -p /path/to/android-studio-project-root
```

### Deobfuscating Stack Traces
- Replace /path/to/stack/trace.txt with the path to your stack trace file.

```bash
./unmystify.sh -s /path/to/stack/trace.txt
```


### Additional options:
```
./unmystify.sh

-m, --mapping-file: Specify the mapping file (optional).
-o, --output-file: Specify the output file (optional).
-h, --help: Display the help message.
```

### Examples:

Deobfuscate a stack trace using an existing mapping file:
- in this case if you didn't provide `-o` the `output` will be at the same `-s` location with a `-cracked.txt` at the end.

```bash
./unmystify.sh -s /path/to/crashylatics-downloaded-stack-trace.txt -m /path/to/generated-mapping-file.txt
```

- or you can Specify the output using `-o`

```bash
./unmystify.sh -s /path/to/stack/trace.txt -o /path/to/output.txt
```


That's it! Use Unmystify to simplify your crash analysis process and identify the root causes of crashes in your Android projects.

# Demo
- Generating a new mapping.txt file that holds the conversion of the obfuscated and non obfuscated code

![generate](https://user-images.githubusercontent.com/28542963/236470963-777b6a8e-a6f2-4bea-93bf-d5a7509e34fb.png)

- giving we have this stack trace 

![image](https://user-images.githubusercontent.com/28542963/236473205-aeec18dd-e12d-4b3a-b535-8b02ae3c317a.png)

- Unmystifying the code `deobfuscating` it using the mapping.txt.

![image](https://user-images.githubusercontent.com/28542963/236474094-a8f7d748-eb6b-475d-8fae-fdc5fb743ab3.png)

