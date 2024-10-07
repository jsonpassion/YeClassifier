//
//  EmotionAnalyzer.swift
//  Ye
//
//  Created by Jason on 10/4/24.
//

import Foundation
import CoreML
import NaturalLanguage

struct EmotionAnalyzer {
    // 감정 분석 수행
    static func analyze(quote: String, completion: @escaping (Result<String, Error>) -> Void) {
        DispatchQueue.global().async {
            do {
                let model = try Ye7(configuration: MLModelConfiguration()) // CreateML 모델 로드
                let output = try model.prediction(text: quote)

                // 예측된 레이블을 감정 이름으로 매핑
                let emotionMapping = [
                    "0": "Sadness",
                    "1": "Joy",
                    "2": "Love",
                    "3": "Anger",
                    "4": "Fear",
                    "5": "Surprise"
                ]

                if let emotion = emotionMapping[output.label] {
                    completion(.success(emotion))
                } else {
                    completion(.failure(NSError(domain: "Unknown label", code: -1, userInfo: nil)))
                }
            } catch {
                completion(.failure(error))
                print("Error predicting sentiment: \(error)")
            }
        }
    }
}
