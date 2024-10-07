//
//  EmotionImageProvider.swift
//  Ye
//
//  Created by Jason on 10/4/24.
//

import Foundation

struct EmotionImageProvider {
    // 감정에 맞는 이미지 이름 반환
    static func getImageName(for emotion: String, celebrity: String) -> String {
        let celebrityPrefix: String
        switch celebrity {
        case "Kanye West":
            celebrityPrefix = "Kanye"
        default:
            celebrityPrefix = "Default"
        }

        switch emotion {
        case "Sadness":
            return "\(celebrityPrefix)_sad"
        case "Joy":
            return "\(celebrityPrefix)_joy"
        case "Love":
            return "\(celebrityPrefix)_love"
        case "Anger":
            return "\(celebrityPrefix)_anger"
        case "Fear":
            return "\(celebrityPrefix)_fear"
        case "Surprise":
            return "\(celebrityPrefix)_surprise"
        default:
            return "\(celebrityPrefix)_default"
        }
    }
}
