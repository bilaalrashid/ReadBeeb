//
//  URLTests.swift
//  ReadBeebTests
//
//  Created by Bilaal Rashid on 23/07/2024.
//

import XCTest
import BbcNews
@testable import ReadBeeb

final class URLTests: XCTestCase {
    func testIsBbcUrl() throws {
        XCTAssertTrue(URL(string: "https://bbc.co.uk")!.isBbc, "URL on root doman matches")
        XCTAssertTrue(URL(string: "https://bbci.co.uk")!.isBbc, "URL on root doman matches")
        XCTAssertTrue(URL(string: "https://bbc.com")!.isBbc, "URL on root doman matches")

        XCTAssertTrue(URL(string: "https://bbc.co.uk/blah")!.isBbc, "URL with path matches")
        XCTAssertTrue(URL(string: "https://bbci.co.uk/blah")!.isBbc, "URL with path matches")
        XCTAssertTrue(URL(string: "https://bbc.com/blah")!.isBbc, "URL with path matches")

        XCTAssertTrue(URL(string: "https://blah.bbc.co.uk/blah")!.isBbc, "URL on hostname matches")
        XCTAssertTrue(URL(string: "https://blah.bbci.co.uk/blah")!.isBbc, "URL on hostname matches")
        XCTAssertTrue(URL(string: "https://blah.bbc.com/blah")!.isBbc, "URL on hostname matches")

        XCTAssertFalse(URL(string: "https://bilaal.co.uk")!.isBbc, "URL on different domain doesn't hit")
    }

    func testIsNewsService() throws {
        XCTAssertFalse(URL(string: "https://www.bbc.co.uk/iplayer")!.isNewsService, "iPlayer root path is not a news service")
        XCTAssertFalse(URL(string: "https://www.bbc.co.uk/iplayer/live/bbcnews")!.isNewsService, "Nested iPlayer path is not a news service")
        XCTAssertFalse(URL(string: "https://www.bbc.co.uk/sounds")!.isNewsService, "Sounds root path is not a news service")
        XCTAssertFalse(URL(string: "https://www.bbc.co.uk/sounds/play/p0hwl9vc")!.isNewsService, "Sounds play path is not a news service")
        XCTAssertFalse(URL(string: "https://bbc.com/iplayer/episode/l0056z0q")!.isNewsService, "iPlayer on bbc.com is not a news service")
        XCTAssertFalse(URL(string: "/iplayer/episode/l0056z0q")!.isNewsService, "Path-only iPlayer ID is not a news service")

        XCTAssertTrue(URL(string: "https://www.bbc.co.uk/news/uk-12345678")!.isNewsService, "News article URL is a news service")
        XCTAssertTrue(URL(string: "https://www.bbc.co.uk/news/videos/c20417qxrglo")!.isNewsService, "News video URL is a news service")
    }

    func testValueOf() throws {
        XCTAssertNil(URL(string: "https://bbc.co.uk")!.valueOf("doesnotexist"), "No parameter returns nil")
        XCTAssertEqual(URL(string: "https://bbc.co.uk?param=1")!.valueOf("param"), "1", "Extracts value of parameter")
        XCTAssertEqual(URL(string: "https://bbc.co.uk?param=1&param=2")!.valueOf("param"), "1", "Extracts first value of parameter")
    }
}

final class FDItemGroupTests: XCTestCase {
    func testStoryPromoIsNewsService() throws {
        XCTAssertFalse(
            self.storyPromo(url: "https://www.bbc.co.uk/iplayer/live/bbcnews").isNewsService,
            "iPlayer destination is not a news service"
        )
        XCTAssertFalse(
            self.storyPromo(url: "https://www.bbc.co.uk/sounds/play/p0hwl9vc").isNewsService,
            "Sounds destination is not a news service"
        )
        XCTAssertFalse(
            self.storyPromo(
                url: "https://news-app.api.bbc.co.uk/fd/abl?page=example",
                id: "https://www.bbc.co.uk/iplayer/episode/l0056z0q"
            ).isNewsService,
            "iPlayer destination ID is not a news service"
        )
        XCTAssertTrue(
            self.storyPromo(url: "https://www.bbc.co.uk/news/uk-12345678").isNewsService,
            "News article destination is a news service"
        )
    }

    func testHasVisiblePromos() throws {
        let iPlayerVideo = self.storyPromo(url: "https://www.bbc.co.uk/iplayer/episode/l0056z0q")
        let newsArticle = self.storyPromo(url: "https://www.bbc.co.uk/news/uk-12345678")
        let iPlayerOnly = [iPlayerVideo]

        XCTAssertFalse(
            FDItemGroup(header: nil, body: .billboard(FDBillboard(storyPromos: iPlayerOnly))).hasVisiblePromos,
            "Billboard of only non-news BBC services is hidden"
        )
        XCTAssertFalse(
            FDItemGroup(header: nil, body: .hierarchicalCollection(FDHierarchicalCollection(storyPromos: iPlayerOnly))).hasVisiblePromos,
            "Hierarchical collection of only non-news BBC services is hidden"
        )
        XCTAssertFalse(
            FDItemGroup(header: nil, body: .simpleCollection(FDSimpleCollection(storyPromos: iPlayerOnly))).hasVisiblePromos,
            "Collection of only non-news BBC services is hidden"
        )
        XCTAssertFalse(
            FDItemGroup(header: nil, body: .simplePromoGrid(FDSimplePromoGrid(storyPromos: iPlayerOnly))).hasVisiblePromos,
            "Promo grid of only non-news BBC services is hidden"
        )
        XCTAssertFalse(
            FDItemGroup(header: nil, body: .carousel(self.carousel(storyPromos: iPlayerOnly))).hasVisiblePromos,
            "Carousel of only non-news BBC services is hidden"
        )
        XCTAssertFalse(
            FDItemGroup(header: nil, body: .storyPromo(iPlayerVideo)).hasVisiblePromos,
            "Single non-news story promo is hidden"
        )
        XCTAssertTrue(
            FDItemGroup(
                header: nil,
                body: .simpleCollection(FDSimpleCollection(storyPromos: [iPlayerVideo, newsArticle]))
            ).hasVisiblePromos,
            "Mixed collection remains visible"
        )
        XCTAssertTrue(
            FDItemGroup(header: nil, body: .copyright(FDCopyright(lastUpdated: Date()))).hasVisiblePromos,
            "Copyright remains visible"
        )
        XCTAssertTrue(
            FDItemGroup(header: nil, body: .chipList(FDChipList(topics: []))).hasVisiblePromos,
            "Chip list remains visible"
        )
    }

    func testDataStoryPromos() throws {
        let billboardPromo = self.storyPromo(url: "https://www.bbc.co.uk/news/billboard")
        let hierarchicalPromo = self.storyPromo(url: "https://www.bbc.co.uk/news/hierarchical")
        let simplePromo = self.storyPromo(url: "https://www.bbc.co.uk/news/simple")
        let gridPromo = self.storyPromo(url: "https://www.bbc.co.uk/news/grid")
        let carouselPromo = self.storyPromo(url: "https://www.bbc.co.uk/news/carousel")
        let lonePromo = self.storyPromo(url: "https://www.bbc.co.uk/news/lone")

        let data = FDData(
            metadata: FDDataMetadata(name: "", allowAdvertising: false, lastUpdated: Date(), shareUrl: nil),
            items: [
                .billboard(FDBillboard(storyPromos: [billboardPromo])),
                .hierarchicalCollection(FDHierarchicalCollection(storyPromos: [hierarchicalPromo])),
                .simpleCollection(FDSimpleCollection(storyPromos: [simplePromo])),
                .simplePromoGrid(FDSimplePromoGrid(storyPromos: [gridPromo])),
                .carousel(self.carousel(storyPromos: [carouselPromo])),
                .storyPromo(lonePromo),
                .copyright(FDCopyright(lastUpdated: Date()))
            ]
        )

        XCTAssertEqual(
            data.storyPromos,
            Set([billboardPromo, hierarchicalPromo, simplePromo, gridPromo, carouselPromo, lonePromo]),
            "Every promo-bearing item contributes its promo"
        )
    }

    private func carousel(storyPromos: [FDStoryPromo]) -> FDCarousel {
        FDCarousel(
            storyPromos: storyPromos,
            aspectRatio: 1,
            presentation: FDPresentation(type: .web),
            hasPageIndicator: false
        )
    }

    private func storyPromo(url: String, id: String? = nil, badges: [FDBadge]? = nil) -> FDStoryPromo {
        let destinationUrl = URL(string: url)!

        return FDStoryPromo(
            style: .smallHorizontalPromoCard,
            languageCode: "en",
            link: FDLink(
                destinations: [
                    FDLinkDestination(
                        sourceFormat: .html,
                        url: destinationUrl,
                        id: id ?? url,
                        presentation: FDPresentation(type: .web)
                    )
                ],
                trackers: []
            ),
            badges: badges
        )
    }
}
