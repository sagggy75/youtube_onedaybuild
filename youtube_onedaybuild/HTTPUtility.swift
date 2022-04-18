//
//  HTTPUtility.swift
//  youtube_onedaybuild
//
//  Created by Daundkar, Sagar(AWF) on 18/04/22.
//

import Foundation

struct HTTPUtility {
	
	
	@discardableResult func getResponseFor<T:Decodable>(apiEndPoint: APIEndPointable,  completionHandler:@escaping ((_ res: T?, _ error: NSError?) -> Void)) -> URLSessionDataTask? {
		
		guard let request = apiEndPoint.resolveURL() else {
			completionHandler(nil,nil)
			return nil
		}
		let session = URLSession.shared
		let task = session.dataTask(with: request) { data, urlResponse, error in
			guard  error == nil && data != nil else {
				completionHandler(nil,error as NSError?)
				return
			}
			do {
				let jsonDecoder = JSONDecoder()
				jsonDecoder.dateDecodingStrategy = .iso8601
				let model = try jsonDecoder.decode(T.self, from: data!)
				completionHandler(model,nil)
			} catch {
				completionHandler(nil,error as NSError?)
			}
		}
		task.resume()
		return task
	}
	
}
// MARK: - HttpMethod Enum

enum HttpMethod: String {
	case get = "get"
	case post = "post"
	case delete = "delete"
}

// MARK: - Blueprint for HTTP Client

protocol APIEndPointable {
	var scheme: String { get }
	var host: String { get }
	var path: String { get }
	var httpHeaders: [String:Any]? { get }
	var httpBody: [String:Any]? { get }
	var httpMethod: HttpMethod { get }
	var queryParams: [String:String]? { get }
	var url: URL? { get }
	
	func resolveURL() -> URLRequest?
}

// MARK: - Default setup

extension APIEndPointable {
	
	var scheme: String { return "https" }
	
	var httpHeaders: [String:Any]? { return nil }
	
	var httpMethod: HttpMethod { return .get }
	
	var queryParams: [String:String]? { return nil }
	
	var httpBody: [String:Any]? { return nil }
	
	var url: URL? {
		var urlComponent = URLComponents.init()
		urlComponent.scheme = scheme
		urlComponent.host = host
		urlComponent.path = path
		urlComponent.queryItems = queryParams?.map({ (key: String, value: String) in
			return URLQueryItem(name: key, value: value)
		})
		return urlComponent.url
	}
	
}

// MARK: - PlayListAPIEndPoint

struct PlayListAPIEndPoint : APIEndPointable {
	
	var queryParams: [String : String]? {
		return ["part": "snippet",
				"playlistId": Constants.PLAYLIST_ID,
				"key": Constants.API_KEY
		]
	}
	
	
	func resolveURL() -> URLRequest? {
		guard let url = url else {
			return nil
		}
		var urlReq = URLRequest(url: url)
		if let httpBody = self.httpBody {
			urlReq.httpBody = try? JSONSerialization.data(withJSONObject: httpBody, options: [])
		}
		return urlReq
	}
	
	var host: String { return  "youtube.googleapis.com" }
	var path: String { return "/youtube/v3/playlistItems" }
	
}

