//
//  ContentView.swift
//  example
//
//  Created by Jeong Deokho on 8/6/24.
//

import SwiftUI

struct Card: Identifiable, Hashable {
    var id = UUID()
    var title: String
    var subtitle: String
    var image: String
}

struct ParallaxCarouselView: View {
    let cardList: [Card] = [
        Card(title: "슈퍼카", subtitle: "람보르기니", image: "image1"),
        Card(title: "우주", subtitle: "넓은 우주", image: "image2"),
        Card(title: "건축물", subtitle: "인도에 있는 한 건축물", image: "image3"),
        Card(title: "도시", subtitle: "유럽에 있는 한 도시", image: "image4"),
        Card(title: "슈퍼카", subtitle: "람보르기니", image: "image1"),
        Card(title: "우주", subtitle: "넓은 우주", image: "image2"),
        Card(title: "건축물", subtitle: "인도에 있는 한 건축물", image: "image3"),
        Card(title: "도시", subtitle: "유럽에 있는 한 도시", image: "image4"),
    ]

    var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading, spacing: 5) {
                CarouselView(cardList: cardList, title: "어떤 사진이 마음에 드세요?")
                    .padding(.bottom, 20)

                CarouselView(cardList: cardList, title: "이런 사진은 어떠세요?")
                    .padding(.bottom, 20)
            }
        }
    }
}


struct CarouselView: View {

    let cardList: [Card]
    let title: String

    var body: some View {
        Text(title)
            .frame(alignment: .leading)
            .font(.largeTitle)
            .fontWeight(.bold)
            .padding(.leading, 10)
        GeometryReader { proxy in
            let size = proxy.size
            let cardWidth = size.width * 0.70
            ScrollView(.horizontal, showsIndicators: false) {
                HStack() {
                    ForEach(cardList, id: \.id) { card in
                        GeometryReader { geometry in
                            let cardSize = geometry.size
                            let minX = min(
                                geometry.frame(in: .scrollView).minX,
                                geometry.size.width
                            )

                            Image(card.image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .offset(x: -minX) // 1. 이렇게
                                .frame(width: cardSize.width * 2) // 1. 두개가 사진이 움직이는듯한 느낌을 줌
                                .frame(width: cardSize.width, height: cardSize.height)
                                .overlay {
                                    overLayView(card: card)
                                }
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .shadow(color: .black.opacity(0.15), radius: 8, x: 5, y: 10)
                                .scrollTransition(.interactive, axis: .horizontal) { view, phase in
                                    view.scaleEffect(phase.isIdentity ? 1 : 0.90) //이게 스크롤 밖에 있는 페이지들을 작게만듬
                                }
                        }
                        .frame(width: cardWidth, height: size.height)
                    }
                }
                .scrollTargetLayout()
                .frame(height: size.height, alignment: .top)
                .padding(.horizontal, ((size.width - cardWidth) / 2))
            }
            .scrollTargetBehavior(.viewAligned) // scrollTargetLayout 한곳을 중심으로 페이징을 고정시킴
        }
        .frame(height: 500)
        .padding(.top, 5)
        .padding(.leading, -15)
        .padding(.trailing, -15)
    }


    @ViewBuilder
    func overLayView(card: Card) -> some View {
        ZStack(alignment: .bottomLeading) {
            LinearGradient(
                colors: [
                    .clear,
                    .black.opacity(0.1),
                    .black.opacity(0.5),
                    .black
                ], startPoint: .top, endPoint: .bottom
            )

            VStack(alignment: .leading) {
                Text("\(card.title)")
                    .font(.title)
                    .bold()
                Text("\(card.subtitle)")
                    .fontWeight(.semibold)
            }
            .foregroundStyle(.white)
            .padding()
        }
    }
}
