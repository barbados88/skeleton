//
//  WXKeyGenerator.swift
//  Skeleton
//
//  Created by User on 02.12.2019.
//

import UIKit
import Security
import DataCompression

class WXKeyGenerator: NSObject {

    var statusCode: OSStatus?
    var status: OSStatus?
    var publicKey: SecKey?
    var privateKey: SecKey?
    var publicKeyData: Data? = nil
    var privateKeyData: Data? = nil
    
    func generate() {
        let publicKeyAttr: [NSObject: NSObject] = [
            kSecAttrIsPermanent: true as NSObject,
            kSecAttrApplicationTag:"RSAKey.public".data(using: String.Encoding.utf8)! as NSObject,
            kSecClass: kSecClassKey,
            kSecReturnData: kCFBooleanTrue]
        let privateKeyAttr: [NSObject: NSObject] = [
            kSecAttrIsPermanent: true as NSObject,
            kSecAttrApplicationTag:"RSAKey.private".data(using: String.Encoding.utf8)! as NSObject,
            kSecClass: kSecClassKey,
            kSecReturnData: kCFBooleanTrue]
        
        var keyPairAttr: [String: Any] = [:]
        keyPairAttr[kSecAttrKeyType as String] = kSecAttrKeyTypeRSA
        keyPairAttr[kSecAttrKeySizeInBits as String] = 2048 as NSObject
        keyPairAttr[kSecPublicKeyAttrs as String] = publicKeyAttr as NSObject
        keyPairAttr[kSecPrivateKeyAttrs as String] = privateKeyAttr as NSObject
        
        statusCode = SecKeyGeneratePair(keyPairAttr as CFDictionary, &publicKey, &privateKey)
        
        if statusCode == noErr && publicKey != nil && privateKey != nil {
            print("Key pair generated OK")
            var resultPublicKey: AnyObject?
            var resultPrivateKey: AnyObject?
            let statusPublicKey = SecItemCopyMatching(publicKeyAttr as CFDictionary, &resultPublicKey)
            let statusPrivateKey = SecItemCopyMatching(privateKeyAttr as CFDictionary, &resultPrivateKey)
            
            if statusPublicKey == noErr {
                if let publicKey = resultPublicKey as? Data {
                    publicKeyData = publicKey
                    print("Public Key: \((publicKey.base64EncodedString()))")
                }
            }
            
            if statusPrivateKey == noErr {
                if let privateKey = resultPrivateKey as? Data {
                    privateKeyData = privateKey
                    print("Private Key: \((privateKey.base64EncodedString()))")
                }
            }
        } else {
            print("Error generating key pair: \(String(describing: statusCode))")
        }
    }
    
    func post() {
        guard
            let compressedPublicKey = publicKeyData?.compress(withAlgorithm: .zlib)?.base64EncodedString(),
            let uuid = UIDevice.current.identifierForVendor?.uuidString
            else { return }
        var parameters: [String: Any] = [:]
        let data: [String: Any] = ["attributes": ["pub": compressedPublicKey, "time": Int(Date().timeIntervalSince1970), "uuid": uuid], "type": "auth"]
        parameters["data"] = data
        parameters["meta"] = ["sign": signWithSHA1(data: "\(data)") ?? ""]
        Communicator.sendRequest(request: "https://91.203.27.40:8080/api/", method: .post, parameters: parameters) { response in
            print(response)
        }
    }
    
    private func signWithSHA1(data: String) -> String? {
        guard let privateKey = privateKey else { return nil }
        var signedBytesSize: size_t = SecKeyGetBlockSize(privateKey)
        var signedBytes: UnsafeMutablePointer<UInt8>
        signedBytes = UnsafeMutablePointer<UInt8>.allocate(capacity: signedBytesSize)
        memset(signedBytes, 0x0, signedBytesSize)
        defer {
            signedBytes.deinitialize(count: signedBytesSize)
            signedBytes.deallocate()
        }
        let requestorData = data.data(using: String.Encoding.utf8)!
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: requestorData.count)
        let stream = OutputStream(toBuffer: buffer, capacity: requestorData.count)

        stream.open()
        requestorData.withUnsafeBytes { (p: UnsafePointer<UInt8>) -> Void in
            stream.write(p, maxLength: requestorData.count)
        }
        stream.close()
        
        let weidformat = UnsafePointer<UInt8>(buffer)
        status = SecKeyRawSign(privateKey, .PKCS1SHA1, weidformat, requestorData.count, signedBytes, &signedBytesSize)
        if status != errSecSuccess {
            print("Cannot sign the device id info: failed obtaining the signed bytes.")
            return nil
        }
        let encryptedBytes = NSData(bytes: signedBytes, length: signedBytesSize)
        return encryptedBytes.base64EncodedString()
    }
    
}
