//
//  ViewController.swift
//  ImageSlideshow
//
//  Created by Petr Zvoníček on 30.07.15.
//  Copyright (c) 2015 Petr Zvonicek. All rights reserved.
//

import UIKit
import ImageSlideshow
import BMPlayer
import SnapKit
import MHVideoPhotoGallery

class ViewController: UIViewController {

    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    @IBOutlet var slideshow: ImageSlideshow!
    @IBOutlet weak var playerConatiner: UIView!
    
    var player = BMPlayer()

    let localSource = [ImageSource(imageString: "img1")!, ImageSource(imageString: "img2")!, ImageSource(imageString: "img3")!, ImageSource(imageString: "img4")!]
    let afNetworkingSource = [AFURLSource(urlString: "https://images.unsplash.com/photo-1432679963831-2dab49187847?w=1080")!, AFURLSource(urlString: "https://images.unsplash.com/photo-1447746249824-4be4e1b76d66?w=1080")!, AFURLSource(urlString: "https://images.unsplash.com/photo-1463595373836-6e0b0a8ee322?w=1080")!]
    let alamofireSource = [AlamofireSource(urlString: "https://images.unsplash.com/photo-1432679963831-2dab49187847?w=1080")!, AlamofireSource(urlString: "https://images.unsplash.com/photo-1447746249824-4be4e1b76d66?w=1080")!, AlamofireSource(urlString: "https://images.unsplash.com/photo-1463595373836-6e0b0a8ee322?w=1080")!]
    let sdWebImageSource = [SDWebImageSource(urlString: "https://images.unsplash.com/photo-1432679963831-2dab49187847?w=1080")!, SDWebImageSource(urlString: "https://images.unsplash.com/photo-1447746249824-4be4e1b76d66?w=1080")!, SDWebImageSource(urlString: "https://images.unsplash.com/photo-1463595373836-6e0b0a8ee322?w=1080")!]
    let kingfisherSource = [KingfisherSource(urlString: "https://images.unsplash.com/photo-1432679963831-2dab49187847?w=1080")!, KingfisherSource(urlString: "https://images.unsplash.com/photo-1447746249824-4be4e1b76d66?w=1080")!, KingfisherSource(urlString: "https://images.unsplash.com/photo-1463595373836-6e0b0a8ee322?w=1080")!]
    
    let videoUrl = URL(string: "https://bitdash-a.akamaihd.net/content/sintel/hls/playlist.m3u8")

    override func viewDidLoad() {
        super.viewDidLoad()

        slideshow.backgroundColor = UIColor.white
        slideshow.slideshowInterval = 0
        slideshow.pageControlPosition = PageControlPosition.insideScrollView
        slideshow.pageControl.currentPageIndicatorTintColor = UIColor.red
        slideshow.pageControl.pageIndicatorTintColor = UIColor.white
        slideshow.contentScaleMode = UIViewContentMode.scaleAspectFill

        // optional way to show activity indicator during image load (skipping the line will show no activity indicator)
        slideshow.activityIndicator = DefaultActivityIndicator()
        slideshow.currentPageChanged = { page in
            print("current page:", page)
        }

        // can be used with other sample sources as `afNetworkingSource`, `alamofireSource` or `sdWebImageSource` or `kingfisherSource`
        slideshow.setImageInputs(localSource)

        let recognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.didTap))
        slideshow.addGestureRecognizer(recognizer)
        
        BMPlayerConf.allowLog = false
        BMPlayerConf.shouldAutoPlay = false
        BMPlayerConf.topBarShowInCase = .always
        BMPlayerConf.enableVolumeGestures = true
        
        playerConatiner.addSubview(player)
        player.snp.makeConstraints { (make) in
            make.top.equalTo(self.playerConatiner).offset(20)
            make.left.right.equalTo(self.playerConatiner)
            // Note here, the aspect ratio 16:9 priority is lower than 1000 on the line, because the 4S iPhone aspect ratio is not 16:9
            make.height.equalTo(player.snp.width).multipliedBy(9.0/16.0).priority(750)
        }
        // Back button event
//        player.backBlock = { [unowned self] (isFullScreen) in
//            if isFullScreen == true { return }
//            let _ = self.navigationController?.popViewController(animated: true)
//        }
        
        let asset = BMPlayerResource(url: videoUrl!, name: "Ark Of Lost World")
        player.setVideo(resource: asset)
        
    }
    
    @IBAction func showFullScreen(_ sender: Any) {
        //gallery item
        let item1 = MHGalleryItem(url: "https://images.unsplash.com/photo-1432679963831-2dab49187847?w=1080", galleryType: .image)
        let item2 = MHGalleryItem(url: "https://bitdash-a.akamaihd.net/content/sintel/hls/playlist.m3u8", galleryType: .video)
        let item3 = MHGalleryItem(youtubeVideoID: "t_iSI89ZxYU")
        
        let galleryData = [item1, item2, item3]
        let galleryController = MHGalleryController(presentationStyle: .imageViewerNavigationBarHidden)
        galleryController?.galleryItems = galleryData as! [MHGalleryItem]
        self.present(galleryController: galleryController, animated: true) {
            print("completion of gallery controller")
        }
    }

    @objc func didTap() {
        let fullScreenController = slideshow.presentFullScreenController(from: self)
        // set the activity indicator for full screen controller (skipping the line will show no activity indicator)
        fullScreenController.slideshow.activityIndicator = DefaultActivityIndicator(style: .white, color: nil)
    }
}
