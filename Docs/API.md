#  BBC News API Documentation

This is an attempt to document the internal API used by the BBC News app (v7 on iOS).

## Headers

### User Agent

The API does not seem to check or validate user agent strings. See below for an example string used by the app.

```
User-Agent: BBCNews/25339 (iPhone15,2; iOS 16.6) BBCHTTPClient/9.0.0
```

## GET `/fd/abl`

This endpoint fetches the data for the "Home" tab in the app.

### Parameters

| Parameter | Required | Example | Description |
|-----------|----------|---------|-------------|
| `page` | Required | `chrysalis_discovery` | Unknown |
| `service` | Required | `news` | Unknown |
| `type` | Required | `index` | Unknown |
| `clientName` | Required | `Chrysalis` | "Chrysalis" seems to be an internal codename of the app |
| `clientVersion` | Optional | `pre-5` | Unknown |
| `release` | Optional | `public-alpha` | Unknown |
| `clientLoc` | Optional | `W1A` | The first part of the user's UK postcode, used to provide localised results |
| `mvtOption` | Optional | | Unknown, this is left blank in the app |
| `clientNeedsUpdate` | Optional | `false` | Unknown |

### Response

```javascript
{
  "data": {
    "metadata": {
      "name": string, // The name of the tab
      "allowAdvertising": boolean,
      "lastUpdated": integer, // Unix timestamp of response
      "shareUrl": string, // BBC News website URL to share for this
    },
    "items": [
      {
        "type": "HierarchicalCollection" // A collection of articles to display, currently seems to be the same as "SimpleCollection"
                | "CollectionHeader" // A title heading for a collection, which has a corresponding link to a detail page
                | "SimpleCollection" // A collection of articles to display, currently seems to be the same as "HierarchicalCollection"
                | "WeatherPromoSummary" // The weather details showed in the home tab
                | "Carousel" // A swipable carousel of cards for articles or videos
                | "ChipList" // A section of chip buttons that link to detail pages
                | "CallToActionBanner" // A special message and button
                | "Copyright" // Copyright details
        ... // Depends based on value of `type`
      },
    ],
    "trackers": array // Items likely used for analytics tracking
  },
  "contentType": string // The content type of the response
}
```

### Example

```
https://news-app.api.bbc.co.uk/fd/abl?page=chrysalis_discovery&service=news&type=index&clientName=Chrysalis&clientVersion=pre-5&release=public-alpha&clientLoc=W1A&mvtOption=&clientNeedsUpdate=false
```