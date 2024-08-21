//
//  ContentView.swift
//  StickyHeader
//
//  Created by Jeong Deokho on 8/6/24.
//

import SwiftUI

struct OffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct OffsetModifier: ViewModifier {
    @Binding var offset: CGFloat
    var returnFromStart: Bool = true
    @State var startValue: CGFloat = .zero

    func body(content: Content) -> some View {
        content
            .overlay {
                GeometryReader { geometry in
                    Color.clear
                        .preference(key: OffsetKey.self, value: geometry.frame(in: .named("scroll")).minY)
                        .onPreferenceChange(OffsetKey.self, perform: { value in
                            if startValue == 0 {
                                startValue = value
                            }
                            offset = (value - (returnFromStart ? startValue : 0))
                        })
                }
            }
    }

}

struct ContentView: View {
    @State var currentType: String = "선택11"
    @State var headerOffset: (CGFloat, CGFloat) = (.zero, .zero)

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 0) {
                HeaderView()
                LazyVStack(pinnedViews: [.sectionHeaders]) {
                    Section {
                        ForEach(1..<50, id: \.self) { _ in
                            RowView()
                        }
                    } header: {
                        PinnedHeaderView(currentType: $currentType)
                            .offset(y: headerOffset.1 > 0 ? 0 : -headerOffset.1 / 8)
                            .modifier(OffsetModifier(offset: $headerOffset.0, returnFromStart: false))
                            .modifier(OffsetModifier(offset: $headerOffset.1))
                    }
                }
            }
        }
        .overlay(content: {
            Rectangle()
                .fill(.white)
                .frame(height: UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0)
                .frame(maxHeight: .infinity, alignment: .top)
                .opacity(headerOffset.0 < 2 ? 1 : 0)
        })
        .coordinateSpace(name: "scroll")
        .ignoresSafeArea(.container, edges: .vertical)
    }
}

struct HeaderView: View {
    var body: some View {
        GeometryReader { geometry in
            let minY = geometry.frame(in: .named("scroll")).minY // scroll 다른걸로 바꿔보기
            let size = geometry.size
            let height = (size.height + minY)

            Image("image")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: size.width,
                       height: height > 0 ? height : 0,
                       alignment: .top)
                .overlay {
                    ZStack(alignment: .bottomLeading) {
                        LinearGradient(colors: [.clear, .black.opacity(0.5)],
                                       startPoint: .top,
                                       endPoint: .bottom)

                        VStack(alignment: .leading) {
                            Text("사진")
                                .font(.largeTitle)
                                .foregroundColor(.white)
                                .bold()
                            Text("사진에 대할 설명")
                                .foregroundColor(.white)
                                .bold()
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading) //없애보기
                    }
                }
                .clipShape(.rect(cornerRadius: 15))
                .offset(y: -minY)
        }
        .frame(height: 250)
    }
}

struct PinnedHeaderView: View {

    @Binding var currentType: String
    @Namespace var animation
    let types: [String] = ["선택11", "선택22222", "선택33333", "선택4", "선택5", "선택6", "선택7", "선택8"]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 25) {
                ForEach(types, id: \.self) { type in
                    VStack(spacing: 12) {
                        Text(type)
                            .fontWeight(.semibold)
                            .foregroundStyle(currentType == type ? .black : .gray)

                        ZStack {
                            if currentType == type {
                                RoundedRectangle(cornerRadius: 4, style: .continuous)
                                    .fill(.black)
                                    .matchedGeometryEffect(id: "TAB", in: animation)
                            } else {
                                RoundedRectangle(cornerRadius: 4, style: .continuous)
                                    .fill(.clear)
                            }

                        }
                        .padding(.horizontal, 8)
                        .frame(height: 4)
                        .padding(.top, -5)
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation(.easeInOut) {
                            currentType = type
                        }
                    }
                }
            }
        }
        .padding(.horizontal)
        .padding(.top, 25)
        .padding(.bottom, 5)
        .background(.white)
    }
}

struct RowView: View {
    var body: some View {
        HStack {
            Circle()
                .frame(width: 50)
                .foregroundStyle(.gray)

            VStack {
                Text("아무거나..")
                    .font(.title3)
                    .bold()
                    .foregroundStyle(.black)

                Text("아무설명..")
                    .fontWeight(.semibold)
                    .foregroundStyle(.black)
                    .padding(.leading, -10)
            }

            Spacer()
        }
        .padding()
    }
}


#Preview(body: {
    ContentView()
})
