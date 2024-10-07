//
//  ContentView.swift
//  Ye
//
//  Created by Jason on 10/4/24.
//

import SwiftUI
import Translation

struct ContentView: View {
    @State private var selectedCelebrity = "Random"
    @State private var quote = ""
    @State private var labelPrediction = ""
    @State private var predictionProbabilities: [String: Double] = [:]
    @State private var emotionImage: String = "neutral" // 기본 이미지 이름
    @State private var isLoading = false
    @State private var showTranslation = false // 번역 UI 표시 여부

    let celebrities = ["Random", "Kanye West"]

    var body: some View {
        VStack {
            // 세그먼트 컨트롤
            Picker(selection: $selectedCelebrity, label: Text("Select Celebrity")) {
                ForEach(celebrities, id: \.self) { celebrity in
                    Text(celebrity).tag(celebrity)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            // 감정 결과 이미지와 그라데이션 배경
            ZStack {
                // 원형 그라데이션 배경
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color(red: 0.9, green: 0.9, blue: 1.0),
                                Color(red: 1.0, green: 0.9, blue: 0.9)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 120, height: 120)
                // 감정 이미지
                Image(emotionImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 140, height: 140)
            }
            .padding(.top, 30)

            Text(labelPrediction)
                .padding(.top, 10)
                .font(.headline)

            // 명언 텍스트 영역
            ScrollView {
                Text(quote)
                    .padding()
                    .font(.body)
                    .multilineTextAlignment(.center)
            }
            .frame(height: 150) // 고정 높이 설정
            .cornerRadius(10)
            .padding(.horizontal)
            .padding(.top, 10)
            // 번역 UI를 표시하는 모디파이어 추가
            .translationPresentation(isPresented: $showTranslation, text: quote)

            // 번역 버튼
            if !quote.isEmpty {
                Button(action: {
                    showTranslation.toggle()
                }) {
                    Text("Translate Quote")
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                }
                .padding(.top, 10)
            }

            // 각 감정의 확률 표시
            List(predictionProbabilities.keys.sorted(), id: \.self) { emotion in
                Text("\(emotion): \(String(format: "%.2f", predictionProbabilities[emotion]! * 100))%")
            }
            .frame(height: 200)
            .padding(.top, 10)

            Spacer()

            if isLoading {
                ProgressView()
                    .padding(.bottom, 30)
            } else {
                Button(action: {
                    fetchQuote()
                }) {
                    Text("Get \(getFirstName())'s Quote and Analyze")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 30)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.bottom, 30)
            }
        }
        .padding()
    }

    // 선택된 유명인의 이름에서 첫 번째 이름 추출
    private func getFirstName() -> String {
        if selectedCelebrity == "Random" {
            return "Random"
        } else {
            return selectedCelebrity.components(separatedBy: " ").first ?? selectedCelebrity
        }
    }

    // 명언 가져오기
    private func fetchQuote() {
        isLoading = true
        switch selectedCelebrity {
        case "Kanye West":
            QuoteFetcher.fetchKanyeQuote { result in
                DispatchQueue.main.async {
                    self.isLoading = false
                    switch result {
                    case .success(let quoteText):
                        self.quote = "\"\(quoteText)\"\n\n- Kanye West"
                        self.analyzeQuote(quote: quoteText)
                    case .failure(let error):
                        print("Error fetching Kanye quote: \(error)")
                    }
                }
            }
        default:
            QuoteFetcher.fetchRandomQuote { result in
                DispatchQueue.main.async {
                    self.isLoading = false
                    switch result {
                    case .success(let (quoteText, author)):
                        self.quote = "\"\(quoteText)\"\n\n- \(author)"
                        self.analyzeQuote(quote: quoteText)
                    case .failure(let error):
                        print("Error fetching random quote: \(error)")
                    }
                }
            }
        }
    }

    // 감정 분석 수행
    private func analyzeQuote(quote: String) {
        EmotionAnalyzer.analyze(quote: quote) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let emotion):
                    self.labelPrediction = emotion
                    self.updateEmotionImage(emotion: emotion)
                case .failure(let error):
                    print("Error analyzing emotion: \(error)")
                }
            }
        }
    }

    // 감정에 맞는 이미지 설정
    private func updateEmotionImage(emotion: String) {
        emotionImage = EmotionImageProvider.getImageName(for: emotion, celebrity: selectedCelebrity)
    }
}

#Preview {
    ContentView()
}
