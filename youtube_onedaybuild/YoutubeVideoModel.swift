//
//  YoutubeVideoModel.swift
//  youtube_onedaybuild
//
//  Created by Daundkar, Sagar(AWF) on 18/04/22.
//

import UIKit

class YoutubeVideoModel: NSObject {

	func getVideos() {
		
		let urlStr = URL.init(string: Constants.API_URL)
		
		guard let url = urlStr else { return }
		
		let task = URLSession.shared.dataTask(with: url) { (data, urlResponse, error) in
			guard error == nil && data != nil else {
				return
			}
			do {
				let jsonDecoder = JSONDecoder()
				jsonDecoder.dateDecodingStrategy = .iso8601
				let model = try jsonDecoder.decode(Response.self, from: data!)
				dump(model)
			}
			catch {
				debugPrint("seems like something went wrong")
				debugPrint(error.localizedDescription)
			}
		}
		task.resume()
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
