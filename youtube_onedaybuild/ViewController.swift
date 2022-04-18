//
//  ViewController.swift
//  youtube_onedaybuild
//
//  Created by Daundkar, Sagar(AWF) on 17/04/22.
//

import UIKit

class ViewController: UIViewController {

	let model = YoutubeVideoModel()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		
		model.getVideos()
	}
	


}

