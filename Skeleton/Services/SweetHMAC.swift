//
//  SweetHMAC.swift
//  BitCoinNews
//
//  Created by User on 7/8/19.
//

import UIKit
import Foundation
import CommonCrypto

public extension String {
    
    func HMAC(algorithm: HMACAlgorithm, secret: String) -> String {
        return SweetHMAC(message: self, secret: secret).HMAC(algorithm: algorithm)
    }
    
    var MD5: String {
        return SweetHMAC.MD5(input: self)
    }
    
    var SHA1: String {
        return SweetHMAC.SHA1(input: self)
    }
    
    var SHA224: String {
        return SweetHMAC.SHA224(input: self)
    }
    
    var SHA256: String {
        return SweetHMAC.SHA256(input: self)
    }
    
    var SHA384: String {
        return SweetHMAC.SHA384(input: self)
    }
    
    var SHA512: String {
        return SweetHMAC.SHA512(input: self)
    }
}

public enum HMACAlgorithm {
    case md5, sha1, sha224, sha256, sha384, sha512
    
    func toNative() -> CCHmacAlgorithm {
        switch self {
        case .md5: return CCHmacAlgorithm(kCCHmacAlgMD5)
        case .sha1: return CCHmacAlgorithm(kCCHmacAlgSHA1)
        case .sha224: return CCHmacAlgorithm(kCCHmacAlgSHA224)
        case .sha256: return CCHmacAlgorithm(kCCHmacAlgSHA256)
        case .sha384: return CCHmacAlgorithm(kCCHmacAlgSHA384)
        case .sha512: return CCHmacAlgorithm(kCCHmacAlgSHA512)
        }
    }
    
    func digestLength() -> Int {
        switch self {
        case .md5: return Int(CC_MD5_DIGEST_LENGTH)
        case .sha1: return Int(CC_SHA1_DIGEST_LENGTH)
        case .sha224: return Int(CC_SHA224_DIGEST_LENGTH)
        case .sha256: return Int(CC_SHA256_DIGEST_LENGTH)
        case .sha384: return Int(CC_SHA384_DIGEST_LENGTH)
        case .sha512: return Int(CC_SHA512_DIGEST_LENGTH)
        }
    }
}

public class SweetHMAC {
    
    struct UTF8EncodedString {
        
        var data:[CChar]
        var length:Int
        
        public init(string: String) {
            data = string.cString(using: String.Encoding.utf8)!
            length = string.lengthOfBytes(using: String.Encoding.utf8)
        }
    }
    
    fileprivate var message: String = ""
    fileprivate var secret: String = ""
    
    public init(message: String, secret: String) {
        self.message = message
        self.secret = secret
    }
    
    public func HMAC(algorithm: HMACAlgorithm) -> String {
        let seed = UTF8EncodedString(string: message)
        let key = UTF8EncodedString(string: secret)
        let digestLength = algorithm.digestLength()
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLength)
        CCHmac(algorithm.toNative(), key.data, key.length, seed.data, seed.length, result)
        let hash = NSMutableString()
        for i in 0..<digestLength {
            hash.appendFormat("%02x", result[i])
        }
        return String(hash)
    }
    
    public class func MD5(input: String) -> String {
        return digest(algorithm: .md5, input: input)
    }
    
    public class func SHA1(input: String) -> String {
        return digest(algorithm: .sha1, input: input)
    }
    
    public class func SHA224(input: String) -> String {
        return digest(algorithm: .sha224, input: input)
    }
    
    public class func SHA256(input: String) -> String {
        return digest(algorithm: .sha256, input: input)
    }
    
    public class func SHA384(input: String) -> String {
        return digest(algorithm: .sha384, input: input)
    }
    
    public class func SHA512(input: String) -> String {
        return digest(algorithm: .sha512, input: input)
    }
    
    public class func digest(algorithm: HMACAlgorithm, input: String) -> String {
        let seed  = UTF8EncodedString(string: input)
        let digestLength = algorithm.digestLength()
        let result = UnsafeMutablePointer<UInt8>.allocate(capacity: digestLength)
        switch algorithm {
        case .md5: CC_MD5(seed.data, CC_LONG(seed.length), result)
        case .sha1: CC_SHA1(seed.data, CC_LONG(seed.length), result)
        case .sha224: CC_SHA224(seed.data, CC_LONG(seed.length), result)
        case .sha256: CC_SHA256(seed.data, CC_LONG(seed.length), result)
        case .sha384: CC_SHA384(seed.data, CC_LONG(seed.length), result)
        case .sha512: CC_SHA512(seed.data, CC_LONG(seed.length), result)
        }
        let hash = NSMutableString()
        for i in 0..<digestLength {
            hash.appendFormat("%02x", result[i])
        }
        return String(hash)
    }
    
}
