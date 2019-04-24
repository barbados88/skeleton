import UIKit

extension String {

    static func endOfWord(words: [String], number: Int) -> String {
        let str = String(format: "%@", number % 10 == 1 && number % 100 != 11 ? words[0] : (number % 10 >= 2 && number % 10 <= 4 && (number % 100 < 10 || number % 100 >= 20) ? words[1] : words[2]))
        return "\(number) \(str)"
    }

    static func partEndOfWord(words: [String], number: Int) -> String {
        let str = String(format: "%@", number % 10 == 1 && number % 100 != 11 ? words[0] : (number % 10 >= 2 && number % 10 <= 4 && (number % 100 < 10 || number % 100 >= 20) ? words[1] : words[2]))
        return str
    }

    var md5: String {
        var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        if let data = self.data(using: String.Encoding.utf8) {
            CC_MD5((data as NSData).bytes, CC_LONG(data.count), &digest)
        }
        var digestHex = ""
        for index in 0..<Int(CC_MD5_DIGEST_LENGTH) {
            digestHex += String(format: "%02x", digest[index])
        }
        return digestHex
    }

    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }

    func heightOfString(usingFont font: UIFont?) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font ?? UIFont.systemFont(ofSize: 16.0)]
        let size = self.size(withAttributes: fontAttributes)
        return size.height == 0 ? 44 : size.height
    }

    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return String(self[fromIndex...])
    }

    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return String(self[..<toIndex])
    }

    private func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }

    private func substring(with r: Range<Int>) -> String {
        return String(self[r])
    }

    subscript(i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }

    subscript(i: Int) -> String {
        return String(self[i] as Character)
    }

    subscript(r: Range<Int>) -> String {
        let start = index(startIndex, offsetBy: r.lowerBound)
        let end = index(startIndex, offsetBy: r.upperBound - r.lowerBound)
        return String(self[start ..< end])
    }

    static func randomString(length: Int) -> String {
        let allowedChars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let allowedCharsCount = UInt32(allowedChars.count)
        var randomString = ""
        for _ in (0..<length) {
            let randomNum = Int(arc4random_uniform(allowedCharsCount))
            let newCharacter = allowedChars[allowedChars.index(allowedChars.startIndex, offsetBy: randomNum)]
            randomString += String(newCharacter)
        }
        return randomString
    }

    var firstUppercased: String {
        guard let first = first else { return "" }
        return String(first).uppercased() + dropFirst()
    }

    func separate(every stride: Int = 4, with separator: Character = "\t") -> String {
        return String(enumerated().map { $0 > 0 && $0 % stride == 0 ? [separator, $1] : [$1]}.joined())
    }

    var fromHTML: NSAttributedString {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }

    func date(using format: Format) -> Date? {
        return Formatter.formatter(using: format).date(from: self)
    }

}
