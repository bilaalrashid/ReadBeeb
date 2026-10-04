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
            try self.storyPromo(url: "https://www.bbc.co.uk/iplayer/live/bbcnews").isNewsService,
            "iPlayer destination is not a news service"
        )
        XCTAssertFalse(
            try self.storyPromo(url: "https://www.bbc.co.uk/sounds/play/p0hwl9vc").isNewsService,
            "Sounds destination is not a news service"
        )
        XCTAssertFalse(
            try self.storyPromo(
                url: "https://news-app.api.bbc.co.uk/fd/abl?page=example",
                id: "https://www.bbc.co.uk/iplayer/episode/l0056z0q"
            ).isNewsService,
            "iPlayer destination ID is not a news service"
        )
        XCTAssertTrue(
            try self.storyPromo(url: "https://www.bbc.co.uk/news/uk-12345678").isNewsService,
            "News article destination is a news service"
        )
    }

    func testIsVideoCarousel() throws {
        let newsVideo = try self.storyPromo(
            url: "https://www.bbc.co.uk/news/videos/c20417qxrglo",
            badges: [FDBadge(type: .video, brand: .news, duration: 54_000)]
        )
        let iPlayerVideo = try self.storyPromo(
            url: "https://www.bbc.co.uk/iplayer/episode/l0056z0q",
            badges: [FDBadge(type: .video, brand: .defaultBrand, duration: 6_983_000)]
        )
        let newsArticle = try self.storyPromo(url: "https://www.bbc.co.uk/news/uk-12345678")
        let newsAudio = try self.storyPromo(
            url: "https://www.bbc.co.uk/news/uk-12345678",
            badges: [FDBadge(type: .audio, brand: .news, duration: 54_000)]
        )
        let newsLive = try self.storyPromo(
            url: "https://www.bbc.co.uk/news/live/world-12345678",
            badges: [FDBadge(type: .live, brand: .news)]
        )

        XCTAssertTrue(
            self.carouselGroup(promos: [newsVideo]).isVideoCarousel,
            "Carousel of news videos is a video carousel"
        )
        XCTAssertTrue(
            self.carouselGroup(promos: [newsVideo, iPlayerVideo]).isVideoCarousel,
            "Carousel with a news video is a video carousel"
        )
        XCTAssertFalse(
            self.carouselGroup(promos: [iPlayerVideo]).isVideoCarousel,
            "Carousel whose only videos link to a non-news BBC service is not a video carousel"
        )
        XCTAssertFalse(
            self.carouselGroup(promos: [newsArticle]).isVideoCarousel,
            "Carousel without video badges is not a video carousel"
        )
        XCTAssertFalse(
            self.carouselGroup(promos: [newsAudio]).isVideoCarousel,
            "Carousel of news audio is not a video carousel"
        )
        XCTAssertFalse(
            self.carouselGroup(promos: [newsLive]).isVideoCarousel,
            "Carousel of live news is not a video carousel"
        )
        XCTAssertFalse(
            FDItemGroup(header: nil, body: .simpleCollection(FDSimpleCollection(storyPromos: [newsVideo]))).isVideoCarousel,
            "Non-carousel collection of videos is not a video carousel"
        )
    }

    func testIncludingVideoCarouselsKeepsFeedOrder() throws {
        let newsVideo = try self.storyPromo(
            url: "https://www.bbc.co.uk/news/videos/c20417qxrglo",
            badges: [FDBadge(type: .video, brand: .news, duration: 54_000)]
        )
        let todaysVideos = self.carouselGroup(promos: [newsVideo], header: "Today's videos")
        let playlist = self.carouselGroup(promos: [newsVideo], header: "The video playlist")
        let news = FDItemGroup(
            header: .collectionHeader(FDCollectionHeader(text: "UK", link: nil)),
            body: .simpleCollection(FDSimpleCollection(storyPromos: [newsVideo]))
        )

        XCTAssertEqual(
            [todaysVideos, news, playlist].includingVideoCarousels().map(\.headerText),
            ["Today's videos", "The video playlist"],
            "Video carousels keep their original order and a non-carousel is dropped"
        )
    }

    func testPinningFirstPutsMatchingHeadersFirst() throws {
        let newsVideo = try self.storyPromo(
            url: "https://www.bbc.co.uk/news/videos/c20417qxrglo",
            badges: [FDBadge(type: .video, brand: .news, duration: 54_000)]
        )
        let todaysVideos = self.carouselGroup(promos: [newsVideo], header: "Today's videos")
        let moreVideos = self.carouselGroup(promos: [newsVideo], header: "More videos")
        let playlist = self.carouselGroup(promos: [newsVideo], header: "The video playlist")

        XCTAssertEqual(
            [todaysVideos, moreVideos, playlist].pinningFirst(headers: ["The video playlist"]).map(\.headerText),
            ["The video playlist", "Today's videos", "More videos"],
            "The matching header is moved to the front"
        )
        XCTAssertEqual(
            [todaysVideos, moreVideos, playlist]
                .pinningFirst(headers: ["The video playlist", "Today's videos"])
                .map(\.headerText),
            ["The video playlist", "Today's videos", "More videos"],
            "Pinned headers keep the order of the pin list"
        )
    }

    func testFilteredExcludesHeadersThenVideoCarousels() throws {
        let newsVideo = try self.storyPromo(
            url: "https://www.bbc.co.uk/news/videos/c20417qxrglo",
            badges: [FDBadge(type: .video, brand: .news, duration: 54_000)]
        )
        let newsArticle = try self.storyPromo(url: "https://www.bbc.co.uk/news/uk-12345678")
        let ukSection = FDItemGroup(
            header: .collectionHeader(FDCollectionHeader(text: "UK", link: nil)),
            body: .simpleCollection(FDSimpleCollection(storyPromos: [newsArticle]))
        )
        let mostRead = FDItemGroup(
            header: .collectionHeader(FDCollectionHeader(text: "Most Read", link: nil)),
            body: .simpleCollection(FDSimpleCollection(storyPromos: [newsArticle]))
        )
        let todaysVideos = self.carouselGroup(promos: [newsVideo], header: "Today's videos")

        XCTAssertEqual(
            [ukSection, mostRead, todaysVideos].filtered(excluding: ["Most Read"], videoCarousels: .exclude).map(\.headerText),
            ["UK"],
            "Named sections and video carousels whose headers are not on the denylist are both dropped"
        )
    }

    func testFilteredOnlyKeepsIncludedVideoCarousels() throws {
        let newsVideo = try self.storyPromo(
            url: "https://www.bbc.co.uk/news/videos/c20417qxrglo",
            badges: [FDBadge(type: .video, brand: .news, duration: 54_000)]
        )
        let newsArticle = try self.storyPromo(url: "https://www.bbc.co.uk/news/uk-12345678")
        let ukSection = FDItemGroup(
            header: .collectionHeader(FDCollectionHeader(text: "UK", link: nil)),
            body: .simpleCollection(FDSimpleCollection(storyPromos: [newsArticle]))
        )
        let todaysVideos = self.carouselGroup(promos: [newsVideo], header: "Today's videos")
        let playlist = self.carouselGroup(promos: [newsVideo], header: "The video playlist")

        XCTAssertEqual(
            [ukSection, todaysVideos, playlist]
                .filtered(including: ["Today's videos", "UK"], videoCarousels: .only)
                .map(\.headerText),
            ["Today's videos"],
            "Video-only selection keeps only video carousels whose headers are on the include list"
        )
    }

    func testFilteredDropsGroupsWithoutVisiblePromos() throws {
        let iPlayerVideo = try self.storyPromo(url: "https://www.bbc.co.uk/iplayer/episode/l0056z0q")
        let newsArticle = try self.storyPromo(url: "https://www.bbc.co.uk/news/uk-12345678")
        let ukSection = FDItemGroup(
            header: .collectionHeader(FDCollectionHeader(text: "UK", link: nil)),
            body: .simpleCollection(FDSimpleCollection(storyPromos: [newsArticle]))
        )
        let watch = FDItemGroup(
            header: .collectionHeader(FDCollectionHeader(text: "Watch", link: nil)),
            body: .simpleCollection(FDSimpleCollection(storyPromos: [iPlayerVideo]))
        )

        XCTAssertEqual(
            [ukSection, watch].filtered().map(\.headerText),
            ["UK"],
            "A group whose remaining promos all link to a non-news BBC service is dropped"
        )
    }

    func testHasVisiblePromos() throws {
        let iPlayerVideo = try self.storyPromo(url: "https://www.bbc.co.uk/iplayer/episode/l0056z0q")
        let newsArticle = try self.storyPromo(url: "https://www.bbc.co.uk/news/uk-12345678")
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
        let billboardPromo = try self.storyPromo(url: "https://www.bbc.co.uk/news/billboard")
        let hierarchicalPromo = try self.storyPromo(url: "https://www.bbc.co.uk/news/hierarchical")
        let simplePromo = try self.storyPromo(url: "https://www.bbc.co.uk/news/simple")
        let gridPromo = try self.storyPromo(url: "https://www.bbc.co.uk/news/grid")
        let carouselPromo = try self.storyPromo(url: "https://www.bbc.co.uk/news/carousel")
        let lonePromo = try self.storyPromo(url: "https://www.bbc.co.uk/news/lone")

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
}

private extension FDItemGroupTests {
    func carouselGroup(promos: [FDStoryPromo], header: String? = nil) -> FDItemGroup {
        let collectionHeader: FDItem? = header.map { .collectionHeader(FDCollectionHeader(text: $0, link: nil)) }
        return FDItemGroup(header: collectionHeader, body: .carousel(self.carousel(storyPromos: promos)))
    }

    func carousel(storyPromos: [FDStoryPromo]) -> FDCarousel {
        FDCarousel(
            storyPromos: storyPromos,
            aspectRatio: 1,
            presentation: FDPresentation(type: .web),
            hasPageIndicator: false
        )
    }

    func storyPromo(url: String, id: String? = nil, badges: [FDBadge]? = nil) throws -> FDStoryPromo {
        let destinationUrl = try XCTUnwrap(URL(string: url))

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
