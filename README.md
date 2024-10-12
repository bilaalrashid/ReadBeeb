<p align="center">
  <img src="https://github.com/user-attachments/assets/114c1533-a0fe-4c00-9eea-bccce21b5d14" alt="ReedBeeb Logo" width="300">
  <br>
  A better client for BBC News.
</p>

# ReadBeeb

![GitHub releases](https://img.shields.io/github/v/release/bilaalrashid/ReedBeeb)
![License](https://img.shields.io/github/license/bilaalrashid/ReedBeeb)
![Tests](https://github.com/bilaalrashid/ReedBeeb/actions/workflows/swift.yml/badge.svg)

A better BBC News client for iOS.

This project is for educational and research purposes only.

## Features

- Dedicated videos tab
- Supports all BBC News international services: English, Cymru, Arabic, Hindi, Mundo and Russian
- Localised news results (English service only)
- Support for low data mode
- Dark mode
- No analytics or tracking
- No account or authentication required
- Personalised news feed displayed in reverse-chronological order
- Rewrite webpage articles to native in-app pages (beta)

## Development

Prerequisites:
- [SwiftLint](https://github.com/realm/SwiftLint)
- [Swift Package Manager](https://www.swift.org/documentation/package-manager/)

To get started:
```
brew install swiftlint
git clone https://github.com/bilaalrashid/ReadBeeb.git
open ReadBeeb/ReadBeeb.xcodeproj
```

Full contributing guidelines can be found in [CONTRIBUTING.md](CONTRIBUTING.md).

## Release

1. Update the list of installed topics:
```bash
make topics API_KEY=<BBC News OAuth2 Token>
```
2. Bump the version and build number in [project.pbxproj](ReadBeeb.xcodeproj/project.pbxproj/)
3. Creating a matching tag and release once merged into `main`
