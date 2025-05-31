XCODE_PROJECT = ReadBeeb.xcodeproj/project.pbxproj
TOPICS_FILE = ReadBeeb/Files/Topics.json
BUMP=patch
PUSH=true

release-version:
	bin/version-bump --xcode-project $(XCODE_PROJECT) --push $(PUSH) --version $(VERSION)

release:
	bin/version-bump --xcode-project $(XCODE_PROJECT) --push $(PUSH) --bump-type $(BUMP)

topics:
	bin/fetch-topics $(API_KEY) > $(TOPICS_FILE)
