
import youtube_ios_player_helper

/// Used to wrap a single slideshow video item
@objcMembers
open class VideoSlideshowItem: UIView, SlideshowItem {

    //Player to play youtube videos
    lazy var videoPlayer: YTPlayerView = {
        let vp = YTPlayerView()
        return vp
    }()

    /// Input Source for the item
    open let videoSource: InputSource

    init(videoSource: InputSource) {
        self.videoSource = videoSource
        super.init(frame: CGRect.null)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func isImage() -> Bool {
        return false
    }
}
