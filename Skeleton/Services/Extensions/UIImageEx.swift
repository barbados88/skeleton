import UIKit

internal func radians(_ degrees: CGFloat) -> CGFloat {
    return degrees / 180 * .pi
}

extension UIImage {

    class func imageWithColor(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 0.6)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }

    static func generateQRCode(from string: String?) -> UIImage? {
        guard let string = string
            else {
                return nil
        }
        let data = string.data(using: String.Encoding.ascii)
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 10, y: 10)
            if let output = filter.outputImage?.transformed(by: transform) {
                let image = convertCIImageToCGImage(inputImage: output)
                return UIImage(cgImage: image!)
            }
        }
        return nil
    }

    static func convertCIImageToCGImage(inputImage: CIImage) -> CGImage! {
        let context = CIContext(options: nil)
        return context.createCGImage(inputImage, from: inputImage.extent)
    }

    func crop(toRect: CGRect, from s: CGSize) -> UIImage {
        var scaledRect = toRect
        let ratio = size.width < size.height ? size.width / s.width : size.height / s.height
        scaledRect.size = CGSize(width: toRect.size.width * ratio, height: toRect.size.height * ratio)
        scaledRect.origin = CGPoint(x: size.width / 2 - scaledRect.size.width / 2, y: abs((size.height - scaledRect.size.height) / 3))
        return crop(rect: scaledRect)
    }

    func crop(rect: CGRect) -> UIImage {
        var rectTransform: CGAffineTransform
        switch imageOrientation {
        case .left:
            rectTransform = CGAffineTransform(rotationAngle: radians(90)).translatedBy(x: 0, y: -size.height)
        case .right:
            rectTransform = CGAffineTransform(rotationAngle: radians(-90)).translatedBy(x: -size.width, y: 0)
        case .down:
            rectTransform = CGAffineTransform(rotationAngle: radians(-180)).translatedBy(x: -size.width, y: -size.height)
        default:
            rectTransform = CGAffineTransform.identity
        }
        rectTransform = rectTransform.scaledBy(x: scale, y: scale)
        if let cropped = cgImage?.cropping(to: rect.applying(rectTransform)) {
            return UIImage(cgImage: cropped, scale: scale, orientation: imageOrientation).fixOrientation()
        }
        return self
    }

    func fixOrientation() -> UIImage {
        if imageOrientation == .up {
            return self
        }
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(in: CGRect(origin: .zero, size: size))
        let normalizedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext() ?? self
        UIGraphicsEndImageContext()
        return normalizedImage
    }

}
