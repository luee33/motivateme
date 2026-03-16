//
//  ContentView.swift
//  motivateme
//
//  Created by Luis Yuja on 3/14/26.
//

import SwiftUI

// MARK: - Data

struct QuoteData {
    let text: String
    let author: String
}

let quotes: [QuoteData] = [
    QuoteData(text: "The only way to do great work is to love what you do.", author: "Steve Jobs"),
    QuoteData(text: "In the middle of difficulty lies opportunity.", author: "Albert Einstein"),
    QuoteData(text: "It does not matter how slowly you go as long as you do not stop.", author: "Confucius"),
    QuoteData(text: "The future belongs to those who believe in the beauty of their dreams.", author: "Eleanor Roosevelt"),
    QuoteData(text: "Believe you can and you're halfway there.", author: "Theodore Roosevelt"),
    QuoteData(text: "You are never too old to set another goal or to dream a new dream.", author: "C.S. Lewis"),
    QuoteData(text: "It always seems impossible until it's done.", author: "Nelson Mandela"),
    QuoteData(text: "Success is not final, failure is not fatal: it is the courage to continue that counts.", author: "Winston Churchill"),
    QuoteData(text: "The best time to plant a tree was 20 years ago. The second best time is now.", author: "Chinese Proverb"),
    QuoteData(text: "Do what you can, with what you have, where you are.", author: "Theodore Roosevelt"),
]

let pastelColors: [Color] = Array(repeating: Color(red: 250/255, green: 250/255, blue: 250/255), count: 10)

let circleColors: [Color] = [
    Color(red: 0.204, green: 0.780, blue: 0.349), // green
    Color(red: 0.259, green: 0.522, blue: 0.957), // blue
    Color(red: 0.957, green: 0.380, blue: 0.380), // red
    Color(red: 0.957, green: 0.698, blue: 0.204), // yellow
    Color(red: 0.608, green: 0.349, blue: 0.957), // purple
    Color(red: 0.957, green: 0.478, blue: 0.204), // orange
    Color(red: 0.204, green: 0.780, blue: 0.780), // teal
    Color(red: 0.957, green: 0.204, blue: 0.608), // pink
    Color(red: 0.204, green: 0.478, blue: 0.204), // dark green
    Color(red: 0.478, green: 0.204, blue: 0.957), // indigo
]

let subtitleColor = Color(red: 118/255, green: 118/255, blue: 118/255)

let todayFormatted: String = {
    let f = DateFormatter()
    f.dateFormat = "MMMM d, yyyy"
    return f.string(from: Date())
}()

// MARK: - CardView

struct CardView: View {
    let color: Color
    let circleColor: Color
    let bottomInset: CGFloat
    let quote: QuoteData

    var body: some View {
        ZStack(alignment: .bottom) {
            color
                .ignoresSafeArea()

            ZStack {
                Circle()
                    .fill(circleColor)
                    .frame(width: 71, height: 71)
                    .blur(radius: 40)

                VStack(spacing: 24) {
                    Text(todayFormatted.uppercased())
                        .font(.custom("DMMono-Regular", size: 14))
                        .foregroundStyle(subtitleColor)
                        .multilineTextAlignment(.center)
                        .lineSpacing(6)

                    Text(quote.text)
                        .font(.custom("Lora-Regular", size: 28))
                        .foregroundStyle(.black)
                        .multilineTextAlignment(.center)
                        .lineSpacing(8.4)

                    Text(quote.author.uppercased())
                        .font(.custom("DMMono-Regular", size: 14))
                        .foregroundStyle(subtitleColor)
                        .multilineTextAlignment(.center)
                        .lineSpacing(6)
                }
                .padding(.horizontal, 40)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            Button(action: {}) {
                Image(systemName: "heart")
                    .font(.system(size: 22, weight: .regular))
                    .foregroundStyle(.black)
                    .padding(16)
            }
            .glassEffect(.clear.interactive(), in: Circle())
            .overlay(Circle().stroke(Color(red: 0.878, green: 0.878, blue: 0.878), lineWidth: 0.5))
            .padding(.bottom, bottomInset + 24)
        }
    }
}

// MARK: - ContentView

struct ContentView: View {
    @State private var currentIndex: Int = 0
    @State private var dragOffset: CGFloat = 0
    @State private var isAnimating: Bool = false

    var body: some View {
        GeometryReader { geo in
            ZStack {
                // Previous card (above)
                if currentIndex > 0 {
                    CardView(
                        color: pastelColors[currentIndex - 1],
                        circleColor: circleColors[currentIndex - 1],
                        bottomInset: geo.safeAreaInsets.bottom,
                        quote: quotes[currentIndex - 1]
                    )
                    .offset(y: -geo.size.height + dragOffset)
                }

                // Next card (below)
                if currentIndex < pastelColors.count - 1 {
                    CardView(
                        color: pastelColors[currentIndex + 1],
                        circleColor: circleColors[currentIndex + 1],
                        bottomInset: geo.safeAreaInsets.bottom,
                        quote: quotes[currentIndex + 1]
                    )
                    .offset(y: geo.size.height + dragOffset)
                }

                // Current card
                CardView(
                    color: pastelColors[currentIndex],
                    circleColor: circleColors[currentIndex],
                    bottomInset: geo.safeAreaInsets.bottom,
                    quote: quotes[currentIndex]
                )
                .offset(y: dragOffset)
            }
            .gesture(
                DragGesture()
                    .onChanged { value in
                        guard !isAnimating else { return }
                        let translation = value.translation.height
                        if (currentIndex == 0 && translation > 0) ||
                           (currentIndex == pastelColors.count - 1 && translation < 0) {
                            dragOffset = translation * 0.15
                        } else {
                            dragOffset = translation
                        }
                    }
                    .onEnded { value in
                        guard !isAnimating else { return }
                        let threshold: CGFloat = geo.size.height * 0.25
                        let velocity = value.predictedEndTranslation.height

                        if (value.translation.height < -threshold || velocity < -500),
                           currentIndex < pastelColors.count - 1 {
                            navigate(to: currentIndex + 1, screenHeight: geo.size.height)
                        } else if (value.translation.height > threshold || velocity > 500),
                                  currentIndex > 0 {
                            navigate(to: currentIndex - 1, screenHeight: geo.size.height)
                        } else {
                            withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                                dragOffset = 0
                            }
                        }
                    }
            )
            .overlay(alignment: .top) {
                HStack {
                    Button(action: {}) {
                        Image(systemName: "person.circle")
                            .font(.system(size: 18, weight: .regular))
                            .foregroundStyle(.black)
                            .padding(12)
                    }
                    .glassEffect(.clear.interactive(), in: Circle())
                    .overlay(Circle().stroke(Color(red: 0.878, green: 0.878, blue: 0.878), lineWidth: 0.5))

                    Spacer()

                    Text("Sonnet")
                        .font(.system(size: 17, weight: .semibold))

                    Spacer()

                    Button(action: {}) {
                        Image(systemName: "square.and.arrow.up")
                            .font(.system(size: 18, weight: .regular))
                            .foregroundStyle(.black)
                            .padding(12)
                    }
                    .glassEffect(.clear.interactive(), in: Circle())
                    .overlay(Circle().stroke(Color(red: 0.878, green: 0.878, blue: 0.878), lineWidth: 0.5))
                }
                .padding(.horizontal, 24)
                .padding(.top, geo.safeAreaInsets.top + 64)
            }
        }
        .ignoresSafeArea()
    }

    private func navigate(to index: Int, screenHeight: CGFloat) {
        isAnimating = true
        let goingDown = index > currentIndex
        withAnimation(.spring(response: 0.38, dampingFraction: 0.82)) {
            dragOffset = goingDown ? -screenHeight : screenHeight
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.38) {
            currentIndex = index
            dragOffset = 0
            isAnimating = false
        }
    }
}

#Preview {
    ContentView()
}
