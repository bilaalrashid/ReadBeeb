XCODE_PROJECT = ReadBeeb.xcodeproj/project.pbxproj
TOPICS_FILE = ReadBeeb/Files/Topics.json
BUMP=patch
PUSH=true

release-version:
	bin/version-bump --xcode-project $(XCODE_PROJECT) --version $(VERSION)

release:
	bin/version-bump --xcode-project $(XCODE_PROJECT) --bump-type $(BUMP)
	ifeq ($(PUSH), true)
		git push --follow-tags
	endif

topics:
	bin/fetch-topics $(API_KEY) > $(TOPICS_FILE)
