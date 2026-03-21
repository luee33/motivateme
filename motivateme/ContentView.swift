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

let todayIndex: Int = {
    let day = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 1
    return (day - 1) % quotes.count
}()

func dateString(for index: Int) -> String {
    let offset = index - todayIndex
    let date = Calendar.current.date(byAdding: .day, value: offset, to: Date()) ?? Date()
    let f = DateFormatter()
    f.dateFormat = "MMMM d, yyyy"
    return f.string(from: date)
}

// MARK: - ReminderSheet

enum RepeatOption: String, CaseIterable {
    case everyday = "Everyday"
    case weekdays = "Weekdays"
    case weekends = "Weekends"
    case custom = "Custom days"
}

struct ReminderSheet: View {
    @Binding var isPresented: Bool

    @State private var isEnabled: Bool = true
    @State private var time: Date = Calendar.current.date(bySettingHour: 9, minute: 0, second: 0, of: Date()) ?? Date()
    @State private var repeatOption: RepeatOption = .everyday
    @State private var customDays: Set<Int> = []
    @State private var showTimePicker: Bool = false

    private let dayLabels = ["S", "M", "T", "W", "T", "F", "S"]

    var body: some View {
        VStack(spacing: 0) {

            // Header
            ZStack {
                Text("Reminder")
                    .font(.system(size: 17, weight: .semibold))
                    .frame(maxWidth: .infinity)

                HStack {
                    Button(action: { isPresented = false }) {
                        Image(systemName: "arrow.left")
                            .font(.system(size: 18, weight: .regular))
                            .foregroundStyle(.black)
                            .padding(12)
                    }
                    .glassEffect(.clear.interactive(), in: Circle())
                    .overlay(Circle().stroke(Color(red: 0.878, green: 0.878, blue: 0.878), lineWidth: 0.5))
                    Spacer()
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 24)
            .padding(.bottom, 20)

            ScrollView {
                VStack(alignment: .leading, spacing: 28) {

                    // Card: Dropdown + Toggle + (Custom days) + Time row
                    VStack(alignment: .leading, spacing: 0) {

                        // Tenet Reminder row
                        HStack {
                            Text("Tenet Reminder")
                                .font(.system(size: 17, weight: .regular))
                                .foregroundStyle(.black)
                            Spacer()
                            Toggle("", isOn: $isEnabled)
                                .labelsHidden()
                                .tint(Color.black)
                        }
                        .padding(.bottom, 16)

                        Divider()
                            .padding(.bottom, 16)

                        // Repeat row
                        HStack {
                            Text("Repeat")
                                .font(.system(size: 17, weight: .regular))
                                .foregroundStyle(.black)
                            Spacer()
                            Menu {
                                ForEach(RepeatOption.allCases, id: \.self) { option in
                                    Button(action: {
                                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                            repeatOption = option
                                        }
                                    }) {
                                        if repeatOption == option {
                                            Label(option.rawValue, systemImage: "checkmark")
                                        } else {
                                            Text(option.rawValue)
                                        }
                                    }
                                }
                            } label: {
                                ZStack {
                                    // Hidden widest option — drives the pill size
                                    HStack(spacing: 6) {
                                        Text("Custom days")
                                            .font(.system(size: 15, weight: .regular))
                                        Image(systemName: "chevron.down")
                                            .font(.system(size: 11, weight: .medium))
                                    }
                                    .hidden()

                                    HStack(spacing: 6) {
                                        Text(repeatOption.rawValue)
                                            .font(.system(size: 15, weight: .regular))
                                            .foregroundStyle(.black)
                                        Image(systemName: "chevron.down")
                                            .font(.system(size: 11, weight: .medium))
                                            .foregroundStyle(Color(red: 0.6, green: 0.6, blue: 0.6))
                                    }
                                }
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .background(Color(red: 0.92, green: 0.92, blue: 0.92))
                                .clipShape(Capsule())
                            }
                        }

                        // Custom days (below dropdown)
                        HStack(spacing: 8) {
                            ForEach(0..<7, id: \.self) { i in
                                Button(action: {
                                    withAnimation(.spring(response: 0.25, dampingFraction: 0.8)) {
                                        if customDays.contains(i) {
                                            customDays.remove(i)
                                        } else {
                                            customDays.insert(i)
                                        }
                                    }
                                }) {
                                    Text(dayLabels[i])
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundStyle(customDays.contains(i) ? .white : .black)
                                        .frame(width: 40, height: 40)
                                        .background(customDays.contains(i) ? Color.black : Color(red: 0.94, green: 0.94, blue: 0.94))
                                        .clipShape(Circle())
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .frame(height: repeatOption == .custom ? nil : 0)
                        .padding(.top, repeatOption == .custom ? 16 : 0)
                        .opacity(repeatOption == .custom ? 1 : 0)
                        .clipped()
                        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: repeatOption)

                        Divider()
                            .padding(.top, 16)

                        // Time row
                        Button(action: {
                            withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                                showTimePicker.toggle()
                            }
                        }) {
                            HStack {
                                Text("Time")
                                    .font(.system(size: 17, weight: .regular))
                                    .foregroundStyle(.black)
                                Spacer()
                                Text(time, style: .time)
                                    .font(.system(size: 15, weight: .regular))
                                    .foregroundStyle(.black)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 6)
                                    .background(Color(red: 0.92, green: 0.92, blue: 0.92))
                                    .clipShape(Capsule())
                            }
                            .padding(.top, 16)
                        }

                        // Collapsible time picker
                        DatePicker("", selection: $time, displayedComponents: .hourAndMinute)
                            .datePickerStyle(.wheel)
                            .labelsHidden()
                            .frame(maxWidth: .infinity)
                            .frame(height: showTimePicker ? nil : 0)
                            .opacity(showTimePicker ? 1 : 0)
                            .clipped()
                            .animation(.spring(response: 0.35, dampingFraction: 0.8), value: showTimePicker)
                    }
                    .padding(16)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.black.opacity(0.05), lineWidth: 1))
                    .shadow(color: Color.black.opacity(0.06), radius: 14, x: 0, y: 6)

}
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
        }
        .background(Color(red: 250/255, green: 250/255, blue: 250/255))
    }
}

// MARK: - ProfileView

struct ProfileView: View {
    let topInset: CGFloat
    let onBack: () -> Void

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            VStack(spacing: 0) {
                ZStack {
                    Text("Settings")
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

                Spacer()
            }
        }
    }
}

// MARK: - FavoritesView

struct FavoritesView: View {
    let favorites: Set<Int>
    let topInset: CGFloat
    let onBack: () -> Void
    let onRemove: (Int) -> Void

    var favoriteQuotes: [QuoteData] {
        quotes.filter { favorites.contains($0.id) }
    }

    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.white.ignoresSafeArea()

            VStack(spacing: 0) {
                ZStack {
                    Text("Favorites")
                        .font(.system(size: 17, weight: .semibold))
                        .frame(maxWidth: .infinity)

                    HStack {
                        Button(action: onBack) {
                            Image(systemName: "arrow.left")
                                .font(.system(size: 18, weight: .regular))
                                .foregroundStyle(.black)
                                .padding(12)
                        }
                        .glassEffect(.clear.interactive(), in: Circle())
                        .overlay(Circle().stroke(Color(red: 0.878, green: 0.878, blue: 0.878), lineWidth: 0.5))
                        Spacer()
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, topInset + 64)

                if favoriteQuotes.isEmpty {
                    Spacer()
                    Text("Your favorite quotes will show up here.")
                        .font(.custom("DMMono-Regular", size: 14))
                        .foregroundStyle(subtitleColor)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 80)
                    Spacer()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(favoriteQuotes) { quote in
                                VStack(alignment: .leading, spacing: 24) {
                                    Text(quote.text)
                                        .font(.custom("Lora-Regular", size: 20))
                                    HStack {
                                        Text(quote.author.uppercased())
                                            .font(.custom("DMMono-Regular", size: 14))
                                            .foregroundStyle(subtitleColor)
                                        Spacer()
                                        Menu {
                                            ShareLink(item: "\"\(quote.text)\" — \(quote.author)") {
                                                Label("Share", systemImage: "square.and.arrow.up")
                                            }
                                            Button(action: {
                                                withAnimation(.easeOut(duration: 0.2)) {
                                                    onRemove(quote.id)
                                                }
                                            }) {
                                                Label("Remove", systemImage: "trash")
                                            }
                                        } label: {
                                            Image(systemName: "ellipsis")
                                                .font(.system(size: 16, weight: .regular))
                                                .foregroundStyle(subtitleColor)
                                        }
                                    }
                                }
                                .padding(.vertical, 16)
                                .padding(.horizontal, 16)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(
                                    ZStack(alignment: .topLeading) {
                                        Color.white
                                        Circle()
                                            .fill(circleColors[quote.id])
                                            .frame(width: 71, height: 71)
                                            .blur(radius: 40)
                                            .offset(x: -10, y: -10)
                                    }
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.black.opacity(0.05), lineWidth: 1))
                                .shadow(color: Color.black.opacity(0.06), radius: 14, x: 0, y: 6)
                                .transition(.opacity.combined(with: .scale(scale: 0.96, anchor: .top)))
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 16)
                        .padding(.bottom, 32)
                    }
                }
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
    let index: Int
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
                    Text(dateString(for: index).uppercased())
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
                .padding(.horizontal, 24)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            HStack(spacing: 16) {
                ShareLink(item: "\"\(quote.text)\" — \(quote.author)") {
                    Image(systemName: "square.and.arrow.up")
                        .font(.system(size: 24, weight: .regular))
                        .foregroundStyle(.black)
                        .offset(y: -2)
                        .padding(16)
                }
                .glassEffect(.clear.interactive(), in: Circle())
                .overlay(Circle().stroke(Color(red: 0.878, green: 0.878, blue: 0.878), lineWidth: 0.5))

                Button(action: onFavorite) {
                    Image(systemName: isFavorited ? "heart.fill" : "heart")
                        .font(.system(size: 24, weight: .regular))
                        .foregroundStyle(isFavorited ? circleColor : .black)
                        .padding(16)
                }
                .glassEffect(.clear.interactive(), in: Circle())
                .overlay(Circle().stroke(Color(red: 0.878, green: 0.878, blue: 0.878), lineWidth: 0.5))
            }
            .padding(.bottom, bottomInset + 188)
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
    @State private var showFavorites: Bool = false
    @State private var favDragOffset: CGFloat = 0
    @State private var showReminder: Bool = false

    var body: some View {
        GeometryReader { geo in
            ZStack {
                // Profile page (sits to the left, slides in from left)
                ProfileView(
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

                // Cards page
                ZStack {
                    // Previous card (above)
                    if currentIndex > 0 {
                        CardView(
                            color: pastelColors[currentIndex - 1],
                            circleColor: circleColors[currentIndex - 1],
                            bottomInset: geo.safeAreaInsets.bottom,
                            quote: quotes[currentIndex - 1],
                            index: currentIndex - 1,
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
                            index: currentIndex + 1,
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
                        index: currentIndex,
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
                    ZStack {
                        Text("Sonnet")
                            .font(.system(size: 17, weight: .semibold))
                            .frame(maxWidth: .infinity)

                        HStack {
                            Button(action: {
                                withAnimation(.spring(response: 0.38, dampingFraction: 0.82)) {
                                    showProfile = true
                                }
                            }) {
                                Image(systemName: "gearshape")
                                    .font(.system(size: 18, weight: .regular))
                                    .foregroundStyle(.black)
                                    .padding(12)
                            }
                            .glassEffect(.clear.interactive(), in: Circle())
                            .overlay(Circle().stroke(Color(red: 0.878, green: 0.878, blue: 0.878), lineWidth: 0.5))

                            Button(action: { showReminder = true }) {
                                Image(systemName: "bell")
                                    .font(.system(size: 18, weight: .regular))
                                    .foregroundStyle(.black)
                                    .padding(12)
                            }
                            .glassEffect(.clear.interactive(), in: Circle())
                            .overlay(Circle().stroke(Color(red: 0.878, green: 0.878, blue: 0.878), lineWidth: 0.5))

                            Spacer()

                            Button(action: { navigate(to: todayIndex, screenHeight: geo.size.height) }) {
                                Text("Today")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundStyle(.black)
                                    .padding(.horizontal, 14)
                            }
                            .frame(height: 42)
                            .glassEffect(.clear.interactive(), in: Capsule())
                            .overlay(Capsule().stroke(Color(red: 0.878, green: 0.878, blue: 0.878), lineWidth: 0.5))
                            .opacity(currentIndex != todayIndex ? 1 : 0)
                            .disabled(currentIndex == todayIndex)
                            .animation(.spring(response: 0.35, dampingFraction: 0.75), value: currentIndex)

                            Button(action: {
                                withAnimation(.spring(response: 0.38, dampingFraction: 0.82)) {
                                    showFavorites = true
                                }
                            }) {
                                Image(systemName: "heart")
                                    .font(.system(size: 18, weight: .regular))
                                    .foregroundStyle(.black)
                                    .padding(12)
                            }
                            .glassEffect(.clear.interactive(), in: Circle())
                            .overlay(Circle().stroke(Color(red: 0.878, green: 0.878, blue: 0.878), lineWidth: 0.5))
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, geo.safeAreaInsets.top + 64)
                }
                .offset(x: (showProfile ? geo.size.width : showFavorites ? -geo.size.width : 0) + horizontalDragOffset + favDragOffset)
                .simultaneousGesture(
                    DragGesture(minimumDistance: 20)
                        .onChanged { value in
                            let dx = value.translation.width
                            guard abs(dx) > abs(value.translation.height) else { return }
                            if !showProfile && !showFavorites {
                                if dx > 0 {
                                    horizontalDragOffset = dx
                                } else {
                                    favDragOffset = dx
                                }
                            } else if showProfile && dx < 0 {
                                horizontalDragOffset = dx
                            } else if showFavorites && dx > 0 {
                                favDragOffset = dx
                            }
                        }
                        .onEnded { value in
                            let dx = value.translation.width
                            let vx = value.predictedEndTranslation.width
                            if !showProfile && !showFavorites {
                                if dx > geo.size.width * 0.25 || vx > 500 {
                                    withAnimation(.spring(response: 0.38, dampingFraction: 0.82)) {
                                        showProfile = true
                                        horizontalDragOffset = 0
                                    }
                                } else if dx < -geo.size.width * 0.25 || vx < -500 {
                                    withAnimation(.spring(response: 0.38, dampingFraction: 0.82)) {
                                        showFavorites = true
                                        favDragOffset = 0
                                    }
                                } else {
                                    withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                                        horizontalDragOffset = 0
                                        favDragOffset = 0
                                    }
                                }
                            } else if showProfile {
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
                            } else if showFavorites {
                                if dx > geo.size.width * 0.25 || vx > 500 {
                                    withAnimation(.spring(response: 0.38, dampingFraction: 0.82)) {
                                        showFavorites = false
                                        favDragOffset = 0
                                    }
                                } else {
                                    withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                                        favDragOffset = 0
                                    }
                                }
                            }
                        }
                )

                // Favorites page (sits to the right, slides in from right)
                FavoritesView(
                    favorites: favorites,
                    topInset: geo.safeAreaInsets.top,
                    onBack: {
                        withAnimation(.spring(response: 0.38, dampingFraction: 0.82)) {
                            showFavorites = false
                        }
                    },
                    onRemove: { id in
                        toggleFavorite(id)
                    }
                )
                .frame(width: geo.size.width, height: geo.size.height)
                .offset(x: (showFavorites ? 0 : geo.size.width) + favDragOffset)
                .gesture(
                    DragGesture(minimumDistance: 20)
                        .onChanged { value in
                            guard showFavorites else { return }
                            let dx = value.translation.width
                            guard dx > 0 && abs(dx) > abs(value.translation.height) else { return }
                            favDragOffset = dx
                        }
                        .onEnded { value in
                            guard showFavorites else { return }
                            let dx = value.translation.width
                            let vx = value.predictedEndTranslation.width
                            if dx > geo.size.width * 0.25 || vx > 500 {
                                withAnimation(.spring(response: 0.38, dampingFraction: 0.82)) {
                                    showFavorites = false
                                    favDragOffset = 0
                                }
                            } else {
                                withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                                    favDragOffset = 0
                                }
                            }
                        }
                )
            }
        }
        .ignoresSafeArea()
        .preferredColorScheme(.light)
        .sheet(isPresented: $showReminder) {
            ReminderSheet(isPresented: $showReminder)
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
        }
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
