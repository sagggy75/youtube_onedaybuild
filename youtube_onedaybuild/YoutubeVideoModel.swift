//
//  YoutubeVideoModel.swift
//  youtube_onedaybuild
//
//  Created by Daundkar, Sagar(AWF) on 18/04/22.
//

import UIKit

class YoutubeVideoModel: NSObject {

	func getVideos() {
		
		HTTPUtility().getResponseFor(apiEndPoint: PlayListAPIEndPoint()) { (res: Response?, error) in
			debugPrint(res?.items?.count)
			debugPrint(error?.localizedDescription)
		}
	}
	
}

struct Video: Decodable {
	var videoId: String?
	var title: String?
	var description: String?
	var thumbnail: String?
	var published: Date?
	
	enum CodingKeys: String, CodingKey {
		case snippet
		case thumbnails
		case high
		case resourceId
		
		case videoId
		case published = "publishedAt"
		case thumbnail = "url"
		case description
		case title
	}
	
	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		let snippet = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .snippet)
		let thumbnails = try snippet.nestedContainer(keyedBy: CodingKeys.self, forKey: .thumbnails)
		let resourceId = try snippet.nestedContainer(keyedBy: CodingKeys.self, forKey: .resourceId)
		let high = try thumbnails.nestedContainer(keyedBy: CodingKeys.self, forKey: .high)
		
		videoId = try resourceId.decodeIfPresent(String.self, forKey: .videoId)
		title = try snippet.decodeIfPresent(String.self, forKey: .title)
		thumbnail = try high.decodeIfPresent(String.self, forKey: .thumbnail)
		published = try snippet.decodeIfPresent(Date.self, forKey: .published)
		description = try snippet.decodeIfPresent(String.self, forKey: .description)
	}
}

struct Response: Decodable {
	var items: [Video]?
}
