//
//  ContentView.swift
//  motivateme
//
//  Created by Luis Yuja on 3/14/26.
//

import SwiftUI

let pastelColors: [Color] = [
    Color(red: 1.0,  green: 0.80, blue: 0.82), // pastel pink
    Color(red: 0.80, green: 0.90, blue: 1.0),  // pastel blue
    Color(red: 0.80, green: 1.0,  blue: 0.84), // pastel green
    Color(red: 1.0,  green: 0.93, blue: 0.76), // pastel yellow
    Color(red: 0.90, green: 0.80, blue: 1.0),  // pastel lavender
    Color(red: 1.0,  green: 0.85, blue: 0.75), // pastel peach
    Color(red: 0.78, green: 0.95, blue: 0.95), // pastel mint
    Color(red: 1.0,  green: 0.80, blue: 0.95), // pastel rose
    Color(red: 0.85, green: 0.92, blue: 0.80), // pastel sage
    Color(red: 0.95, green: 0.88, blue: 1.0),  // pastel lilac
]

struct CardView: View {
    let color: Color
    let bottomInset: CGFloat

    var body: some View {
        ZStack(alignment: .bottom) {
            color
                .ignoresSafeArea()

            Button(action: {}) {
                Image(systemName: "heart")
                    .font(.system(size: 22, weight: .regular))
                    .foregroundStyle(.black)
                    .padding(16)
            }
            .glassEffect(.clear.interactive(), in: Circle())
            .padding(.bottom, bottomInset + 24)
        }
    }
}

struct ContentView: View {
    @State private var currentIndex: Int = 0
    @State private var dragOffset: CGFloat = 0
    @State private var isAnimating: Bool = false

    var body: some View {
        GeometryReader { geo in
            ZStack {
                // Previous card (above)
                if currentIndex > 0 {
                    CardView(color: pastelColors[currentIndex - 1], bottomInset: geo.safeAreaInsets.bottom)
                        .offset(y: -geo.size.height + dragOffset)
                }

                // Next card (below)
                if currentIndex < pastelColors.count - 1 {
                    CardView(color: pastelColors[currentIndex + 1], bottomInset: geo.safeAreaInsets.bottom)
                        .offset(y: geo.size.height + dragOffset)
                }

                // Current card
                CardView(color: pastelColors[currentIndex], bottomInset: geo.safeAreaInsets.bottom)
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
