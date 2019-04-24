import UIKit

extension Data {

    func cropImage(toRect: CGRect, from size: CGSize) -> Data? {
        guard let image = UIImage(data: self)
            else {
                return nil
        }
        let croppedImage: UIImage = image.crop(toRect: toRect, from: size)
        return croppedImage.jpegData(compressionQuality: 1.0)
    }

}
