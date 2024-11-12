XCODE_PROJECT = ReadBeeb.xcodeproj/project.pbxproj
TOPICS_FILE = ReadBeeb/Files/Topics.json

release-version:
	bin/version-bump --xcode-project $(XCODE_PROJECT) --version $(VERSION)

release-major:
	bin/version-bump --xcode-project $(XCODE_PROJECT) --bump-type major

release-minor:
	bin/version-bump --xcode-project $(XCODE_PROJECT) --bump-type minor

release-patch:
	bin/version-bump --xcode-project $(XCODE_PROJECT) --bump-type patch

release: release-patch

topics:
	bin/fetch-topics $(API_KEY) > $(TOPICS_FILE)
