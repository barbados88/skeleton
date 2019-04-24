//
//  Sound.swift
//  Incognito
//
//  Created by Woxapp on 25.12.2017.
//  Copyright © 2017 Woxapp. All rights reserved.
//

import UIKit
import RealmSwift
import AudioToolbox
import AVFoundation

class Sound: NSObject {

    static func defaultSound() {
        let selectedSound: String = "Anticipate.caf"
        if let url = allSounds.filter({
            return $0.lastPathComponent.contains(selectedSound)
        }).first {
            var soundID: SystemSoundID = SystemSoundID()
            AudioServicesCreateSystemSoundID(url as CFURL, &soundID)
            AudioServicesPlaySystemSound(soundID)
        }
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
    }

    static var sms: URL? { return URL(string: "file:///System/Library/Audio/UISounds/SentMessage.caf") }

    static func myMessageSound() {
        play()
    }

    static func messageSound() {
        addBadge()
//        check your conditions and use vibrate or playsound with url
//        for example:
//        let settings = Settings.my
//        if settings.soft?.alert?.isVibro == true {
//            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
//        }
//        if settings.soft?.alert?.isSound == true {
//            play(settings.soft?.alert?.soundPath)
//        }
    }

    static func play(_ url: URL? = nil) {
        let path: URL? = url ?? sms
        if path == nil {
            return
        }
        var soundID: SystemSoundID = SystemSoundID()
        AudioServicesCreateSystemSoundID(path! as CFURL, &soundID)
        AudioServicesPlaySystemSound(soundID)
    }

    static var allSounds: [URL] {
        var allSounds: [URL] = []
        let fileManager: FileManager = FileManager()
        if let directoryURL = URL(string: "/System/Library/Audio/UISounds") {
            let keys = [URLResourceKey.isDirectoryKey]
            if let enumerator = fileManager.enumerator(at: directoryURL, includingPropertiesForKeys: keys, options: .skipsSubdirectoryDescendants, errorHandler: { url, error in
                return true
            }) {
                for case let url as URL in enumerator {
                    if url.lastPathComponent.contains(".caf") {
                        allSounds.append(url)
                    }
                }
            }
        }
        return allSounds
    }

    static func addBadge() {
        UIApplication.shared.applicationIconBadgeNumber = 1
    }

}
