import UIKit
import SDWebImage

extension UIImageView {
    
    func imageFromPhoto(_ photo: Photo, placeholder: UIImage?) {
        sd_setImage(with: photo.url, placeholderImage: placeholder, options: .refreshCached) { image, error, _,_ in
            if error == nil { photo.cachedData = image?.jpegData(compressionQuality: 1.0) }
        }
    }
    
}

