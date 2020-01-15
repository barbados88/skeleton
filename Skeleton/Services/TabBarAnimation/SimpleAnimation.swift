import UIKit

class SimpleAnimation: WXAnimation {

    private var duration: TimeInterval = 0.5

    override func animate(to index: Int) {
        playBounceAnimation(getImageView(at: index))
    }

    private func getImageView(at index: Int) -> UIImageView? {
        var imageView: UIImageView? = nil
        if index + 1 < tabBar.subviews.count {
            let view = tabBar.subviews[index + 1]
            imageView = view.subviews.first as? UIImageView
            imageView?.contentMode = .center
        }
        return imageView
    }

    private func playBounceAnimation(_ icon: UIImageView?) {
        let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        bounceAnimation.values = [1.0, 1.4, 0.9, 1.15, 0.95, 1.02, 1.0]
        bounceAnimation.duration = TimeInterval(duration)
        bounceAnimation.calculationMode = CAAnimationCalculationMode.cubic
        icon?.layer.add(bounceAnimation, forKey: "bounceAnimation")
    }

}
