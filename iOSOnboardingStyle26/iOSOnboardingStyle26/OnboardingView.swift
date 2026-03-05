//
//  ContentView.swift
//  iOSOnboardingStyle26
//
//  Created by Toan Doan on 4/3/26.
//

import SwiftUI

struct OnboardingView: View {
    @State var currentIndex: Int = .zero
    @State var screenshotSize: CGSize = .zero
    
    var items: [Item]
    var tint: Color = .blue
    var shouldShowBezel = true
    var animation = Animation.interpolatingSpring()
    var onCompleted: () -> Void = {}

    var deviceCornerRadius: CGFloat {
        if let imageSize = items.first?.screenshot?.size {
            let ratio = screenshotSize.height / imageSize.height
            let actualCornerRadius: CGFloat = 190
            return actualCornerRadius * ratio
        }
        return .zero
    }
    var body: some View {
        ZStack(alignment: .bottom) {
            ScreenshotView()
                .compositingGroup()
                .scaleEffect(
                    items[currentIndex].zoomScale,
                    anchor: items[currentIndex].zoomAnchor
                )
                .padding(.top, 35)
                .padding(.horizontal, 30)
                .padding(.bottom, 220)

            VStack(spacing: 10) {
                TextContentView()
                IndicatorView()
                ContinueButton()
            }
            .padding(.top, 20)
            .padding(.horizontal, 16)
            .frame(height: 210)
            .multilineTextAlignment(.center)
            .background {
                VariableGlassBlur(15)
            }

            BackButton()
        }
        .preferredColorScheme(.dark)
        .padding()
    }

    struct Item: Identifiable {
        var id: Int
        var title: String
        var subtitle: String
        var screenshot: UIImage?
        var zoomScale: CGFloat = 1
        var zoomAnchor: UnitPoint = .center
        var offset: CGSize = .zero
    }

    @ViewBuilder func ScreenshotView() -> some View {
        let shape = ConcentricRectangle(corners: .concentric, isUniform: true)
        GeometryReader { proxy in
            let size = proxy.size

            Rectangle()
                .fill(.black)

            ScrollView(.horizontal) {
                HStack(spacing: 12) {
                    ForEach(items) { item in
                        Group {
                            if let screenshot = item.screenshot {
                                Image(uiImage: screenshot)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .onGeometryChange(for: CGSize.self) {
                                        proxy in
                                        proxy.size
                                    } action: { newValue in
                                        screenshotSize = newValue
                                    }
                                    .clipShape(shape)

                            } else {
                                Rectangle()
                                    .fill(.black)
                            }
                        }
                        .frame(width: size.width, height: size.height)
                    }
                }
                .scrollTargetLayout()
            }
            .scrollDisabled(true)
            .scrollTargetBehavior(.viewAligned)
            .scrollIndicators(.hidden)
            .scrollPosition(id: $currentIndex.optionalValue)
        }
        .clipShape(shape)
        .overlay {
            if screenshotSize != .zero && shouldShowBezel {
                ZStack {
                    shape.stroke(.yellow, lineWidth: 6)
                    shape.stroke(.black, lineWidth: 4)
                    shape.stroke(.black, lineWidth: 6).padding(4)
                }
                .padding(-6)
            }
        }
        .frame(
            maxWidth: screenshotSize.width == .zero
                ? nil : screenshotSize.width,
            maxHeight: screenshotSize.height == .zero
                ? nil : screenshotSize.height
        )
        .containerShape(RoundedRectangle(cornerRadius: deviceCornerRadius))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .offset(items[currentIndex].offset)
    }

    @ViewBuilder func IndicatorView() -> some View {
        HStack(spacing: 6) {
            ForEach(items, id: \.id) { index in
                let isActive = currentIndex == index.id
                Capsule()
                    .fill(.white.opacity(isActive ? 1 : 0.36))
                    .frame(width: isActive ? 25 : 6, height: 6)
            }
        }
        .padding(.bottom, 8)
    }

    @ViewBuilder func TextContentView() -> some View {
        GeometryReader { proxy in
            let size = proxy.size

            ScrollView(.horizontal) {
                HStack(spacing: .zero) {
                    ForEach(items) { item in
                        let isActive = item.id == currentIndex

                        VStack(spacing: 6) {
                            Text(item.title)
                                .font(.title2)
                                .fontWeight(.semibold)
                                .lineLimit(1)

                            Text(item.subtitle)
                                .font(.callout)
                                .lineLimit(2)
                                .foregroundStyle(.white.opacity(0.8))
                        }
                        .frame(width: size.width)
                        .compositingGroup()
                        .blur(radius: isActive ? 0 : 30)
                        .opacity(isActive ? 1 : 0)
                    }
                }
                .scrollTargetLayout()
            }
            .scrollIndicators(.hidden)
            .scrollDisabled(true)
            .scrollClipDisabled()
            .scrollTargetBehavior(.paging)
            .scrollPosition(id: $currentIndex.optionalValue)
        }
    }

    @ViewBuilder func ContinueButton() -> some View {
        Button {
            withAnimation(animation) {
                currentIndex = min(currentIndex + 1, items.endIndex - 1)
            }
            if currentIndex == items.endIndex - 1 {
                onCompleted()
                let _ = print("Completed Onboarding")
            }
        } label: {
            Text(currentIndex == items.endIndex - 1 ? "Get Started" : "Continue")
                .contentTransition(.numericText())
                .fontWeight(.medium)
                .padding(.vertical, 6)
        }
        .tint(tint)
        .buttonStyle(.glassProminent)
        .buttonSizing(.flexible)
    }

    @ViewBuilder func BackButton() -> some View {
        Button {
            withAnimation(animation) {
                currentIndex = max(currentIndex - 1, 0)
            }
        } label: {
            Image(systemName: "chevron.left")
                .font(.title3)
                .frame(width: 18, height: 24)
        }
        .opacity(currentIndex == .zero ? 0 : 1)
        .transition(.opacity)
        .buttonStyle(.glass)
        .buttonBorderShape(.circle)
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity,
            alignment: .topLeading
        )
    }

    @ViewBuilder func VariableGlassBlur(_ radius: CGFloat) -> some View {
        let tintColor = Color.black.opacity(0.5)
        Rectangle()
            .fill(.clear)
            .glassEffect(.clear.tint(tintColor), in: .rect)
            .blur(radius: radius)
            .padding([.horizontal, .bottom], -radius * 2)
            .opacity(items[currentIndex].zoomScale != 1 ? 1 : 0)
            .ignoresSafeArea()
    }
}

extension Binding {
    fileprivate var optionalValue: Binding<Value?> {
        .init {
            wrappedValue
        } set: { _ in
        }
    }
}

#Preview {
    let image = UIImage(named: "screen")
    let title = "Welcome to iOS 26"
    let subtitle = "Introducting a new desgin with \n Liquid Glass."

    OnboardingView(items: [
        .init(
            id: 0,
            title: title,
            subtitle: subtitle,
            screenshot: image,
            zoomScale: 1.5,
            zoomAnchor: .center,
            offset: CGSize.init(width: 0, height: 50)
        ),
        .init(
            id: 1,
            title: title,
            subtitle: subtitle,
            screenshot: image,
            zoomScale: 1.0,
            zoomAnchor: .center
        ),
        .init(
            id: 2,
            title: title,
            subtitle: subtitle,
            screenshot: image,
            zoomScale: 1.3,
            zoomAnchor: .bottom
        ),
        .init(
            id: 3,
            title: title,
            subtitle: subtitle,
            screenshot: image,
            zoomScale: 1.2,
            zoomAnchor: .init(x: 0.5, y: -0.15)
        ),
        .init(
            id: 4,
            title: title,
            subtitle: subtitle,
            screenshot: image,
            zoomScale: 1.1,
            zoomAnchor: .init(x: 0.5, y: -0.2)
        ),

    ])
}
