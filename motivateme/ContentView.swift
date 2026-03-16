//
//  ContentView.swift
//  motivateme
//
//  Created by Luis Yuja on 3/14/26.
//

import SwiftUI

// MARK: - Data

struct QuoteData: Identifiable {
    let id: Int
    let text: String
    let author: String
}

let quotes: [QuoteData] = [
    QuoteData(id: 0, text: "The only way to do great work is to love what you do.", author: "Steve Jobs"),
    QuoteData(id: 1, text: "In the middle of difficulty lies opportunity.", author: "Albert Einstein"),
    QuoteData(id: 2, text: "It does not matter how slowly you go as long as you do not stop.", author: "Confucius"),
    QuoteData(id: 3, text: "The future belongs to those who believe in the beauty of their dreams.", author: "Eleanor Roosevelt"),
    QuoteData(id: 4, text: "Believe you can and you're halfway there.", author: "Theodore Roosevelt"),
    QuoteData(id: 5, text: "You are never too old to set another goal or to dream a new dream.", author: "C.S. Lewis"),
    QuoteData(id: 6, text: "It always seems impossible until it's done.", author: "Nelson Mandela"),
    QuoteData(id: 7, text: "Success is not final, failure is not fatal: it is the courage to continue that counts.", author: "Winston Churchill"),
    QuoteData(id: 8, text: "The best time to plant a tree was 20 years ago. The second best time is now.", author: "Chinese Proverb"),
    QuoteData(id: 9, text: "Do what you can, with what you have, where you are.", author: "Theodore Roosevelt"),
]

let pastelColors: [Color] = Array(repeating: Color(red: 1.0, green: 1.0, blue: 1.0), count: 10)

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

// MARK: - ProfileView

struct ProfileView: View {
    let favorites: Set<Int>
    let topInset: CGFloat
    let onBack: () -> Void

    var favoriteQuotes: [QuoteData] {
        quotes.filter { favorites.contains($0.id) }
    }

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Color.white.ignoresSafeArea()

            VStack(spacing: 0) {
                ZStack {
                    Text("Profile")
                        .font(.system(size: 17, weight: .semibold))
                        .frame(maxWidth: .infinity)

                    HStack {
                        Spacer()
                        Button(action: onBack) {
                            Image(systemName: "arrow.right")
                                .font(.system(size: 18, weight: .regular))
                                .foregroundStyle(.black)
                                .padding(12)
                        }
                        .glassEffect(.clear.interactive(), in: Circle())
                        .overlay(Circle().stroke(Color(red: 0.878, green: 0.878, blue: 0.878), lineWidth: 0.5))
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, topInset + 64)

                List {
                    Section("Favorites") {
                        if favoriteQuotes.isEmpty {
                            Text("No favorites yet.")
                                .foregroundStyle(subtitleColor)
                        } else {
                            ForEach(favoriteQuotes) { quote in
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(quote.text)
                                        .font(.custom("Lora-Regular", size: 15))
                                    Text(quote.author)
                                        .font(.custom("DMMono-Regular", size: 12))
                                        .foregroundStyle(subtitleColor)
                                }
                                .padding(.vertical, 4)
                            }
                        }
                    }
                }
                .listStyle(.plain)
                .padding(.horizontal, 24)
            }
        }
    }
}

// MARK: - CardView

struct CardView: View {
    let color: Color
    let circleColor: Color
    let bottomInset: CGFloat
    let quote: QuoteData
    let isFavorited: Bool
    let onFavorite: () -> Void

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
                        .padding(.bottom, 4)

                    Text(quote.author.uppercased())
                        .font(.custom("DMMono-Regular", size: 14))
                        .foregroundStyle(subtitleColor)
                        .multilineTextAlignment(.center)
                        .lineSpacing(6)
                }
                .padding(.horizontal, 40)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            Button(action: onFavorite) {
                Image(systemName: isFavorited ? "heart.fill" : "heart")
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
    @State private var favorites: Set<Int> = []
    @State private var showProfile: Bool = false
    @State private var horizontalDragOffset: CGFloat = 0

    var body: some View {
        GeometryReader { geo in
            ZStack {
                // Profile page (sits to the left, slides in)
                ProfileView(
                    favorites: favorites,
                    topInset: geo.safeAreaInsets.top,
                    onBack: {
                        withAnimation(.spring(response: 0.38, dampingFraction: 0.82)) {
                            showProfile = false
                        }
                    }
                )
                .frame(width: geo.size.width, height: geo.size.height)
                .offset(x: (showProfile ? 0 : -geo.size.width) + horizontalDragOffset)
                .gesture(
                    DragGesture(minimumDistance: 20)
                        .onChanged { value in
                            guard showProfile else { return }
                            let dx = value.translation.width
                            guard dx < 0 && abs(dx) > abs(value.translation.height) else { return }
                            horizontalDragOffset = dx
                        }
                        .onEnded { value in
                            guard showProfile else { return }
                            let dx = value.translation.width
                            let vx = value.predictedEndTranslation.width
                            if dx < -geo.size.width * 0.25 || vx < -500 {
                                withAnimation(.spring(response: 0.38, dampingFraction: 0.82)) {
                                    showProfile = false
                                    horizontalDragOffset = 0
                                }
                            } else {
                                withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                                    horizontalDragOffset = 0
                                }
                            }
                        }
                )

                // Cards page (slides right when profile opens)
                ZStack {
                    // Previous card (above)
                    if currentIndex > 0 {
                        CardView(
                            color: pastelColors[currentIndex - 1],
                            circleColor: circleColors[currentIndex - 1],
                            bottomInset: geo.safeAreaInsets.bottom,
                            quote: quotes[currentIndex - 1],
                            isFavorited: favorites.contains(currentIndex - 1),
                            onFavorite: { toggleFavorite(currentIndex - 1) }
                        )
                        .offset(y: -geo.size.height + dragOffset)
                    }

                    // Next card (below)
                    if currentIndex < pastelColors.count - 1 {
                        CardView(
                            color: pastelColors[currentIndex + 1],
                            circleColor: circleColors[currentIndex + 1],
                            bottomInset: geo.safeAreaInsets.bottom,
                            quote: quotes[currentIndex + 1],
                            isFavorited: favorites.contains(currentIndex + 1),
                            onFavorite: { toggleFavorite(currentIndex + 1) }
                        )
                        .offset(y: geo.size.height + dragOffset)
                    }

                    // Current card
                    CardView(
                        color: pastelColors[currentIndex],
                        circleColor: circleColors[currentIndex],
                        bottomInset: geo.safeAreaInsets.bottom,
                        quote: quotes[currentIndex],
                        isFavorited: favorites.contains(currentIndex),
                        onFavorite: { toggleFavorite(currentIndex) }
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
                        Button(action: {
                            withAnimation(.spring(response: 0.38, dampingFraction: 0.82)) {
                                showProfile = true
                            }
                        }) {
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

                        ShareLink(item: "\"\(quotes[currentIndex].text)\" — \(quotes[currentIndex].author)") {
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
                .offset(x: (showProfile ? geo.size.width : 0) + horizontalDragOffset)
                .simultaneousGesture(
                    DragGesture(minimumDistance: 20)
                        .onChanged { value in
                            guard !showProfile else { return }
                            let dx = value.translation.width
                            guard dx > 0 && abs(dx) > abs(value.translation.height) else { return }
                            horizontalDragOffset = dx
                        }
                        .onEnded { value in
                            guard !showProfile else { return }
                            let dx = value.translation.width
                            let vx = value.predictedEndTranslation.width
                            if dx > geo.size.width * 0.25 || vx > 500 {
                                withAnimation(.spring(response: 0.38, dampingFraction: 0.82)) {
                                    showProfile = true
                                    horizontalDragOffset = 0
                                }
                            } else {
                                withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                                    horizontalDragOffset = 0
                                }
                            }
                        }
                )
            }
        }
        .ignoresSafeArea()
    }

    private func toggleFavorite(_ index: Int) {
        if favorites.contains(index) {
            favorites.remove(index)
        } else {
            favorites.insert(index)
        }
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
