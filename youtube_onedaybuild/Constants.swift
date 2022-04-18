//
//  Constants.swift
//  youtube_onedaybuild
//
//  Created by Daundkar, Sagar(AWF) on 18/04/22.
//

import Foundation

struct Constants {
	
	static let API_KEY = "AIzaSyD7oRg0k-aGizozgItOG7EN29hqxlVIydQ"
	static let PLAYLIST_ID = "PLMRqhzcHGw1aLoz4pM_Mg2TewmJcMg9ua"
	static let API_URL = "https://youtube.googleapis.com/youtube/v3/playlistItems?part=snippet&playlistId=\(Constants.PLAYLIST_ID)&key=\(Constants.API_KEY)"
}
