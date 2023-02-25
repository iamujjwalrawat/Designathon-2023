//
//  ContentView.swift
//  Designathon 2023
//
//  Created by Ujjwal Rawat on 25/02/23.
//

import SwiftUI

extension UIView {
    var globalFrame: CGRect? {
        let rootView = UIApplication.shared.windows.filter({$0.isKeyWindow}).first?.rootViewController?.view
        return self.superview?.convert(self.frame, to: rootView)
    }
}

struct Movie: Hashable {
    let title, imageName: String
}

struct ContentView: View {
    init() {
        UINavigationBar.appearance().barTintColor = .systemBackground
    }
    
    let topMovies: [Movie] = [
        .init(title: "", imageName: "card1"),
        .init(title: "", imageName: "card2"),
        .init(title: "", imageName: "card3"),
        .init(title: "", imageName: "card4"),
        .init(title: "", imageName: "card5"),
        .init(title: "", imageName: "card6"),
    ]
    
    let animationMovies: [Movie] = [
        .init(title: "", imageName: "card4"),
        .init(title: "", imageName: "card5"),
        .init(title: "", imageName: "card6"),
        .init(title: "", imageName: "card3"),
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                MoviesCarousel(categoryName: "Major Places to Witness Ganga River in India", movies: topMovies)

                MoviesCarousel(categoryName: "Design Hackathon 2023 - Doon University", movies: animationMovies)
            }.navigationBarTitle(" Hackathon 2023", displayMode: .large)
        }
    }
}

struct MoviesCarousel: View {
    let categoryName: String
    let movies: [Movie]
    
    func getScale(proxy: GeometryProxy) -> CGFloat {
        let midPoint: CGFloat = 125
        let viewFrame = proxy.frame(in: CoordinateSpace.global)
        
        var scale: CGFloat = 1.0
        let deltaXAnimationThreshold: CGFloat = 125
        
        let diffFromCenter = abs(midPoint - viewFrame.origin.x - deltaXAnimationThreshold / 2)
        if diffFromCenter < deltaXAnimationThreshold {
            scale = 1 + (deltaXAnimationThreshold - diffFromCenter) / 500
        }
        
        return scale
    }
    
    var body: some View {
        HStack {
            Text(categoryName)
                .font(.system(size: 16.5, weight: .heavy))
                .padding(.vertical, 6)
                .padding(.horizontal, 12)
                .background(Color.orange)
                .foregroundColor(.white)
                .cornerRadius(2)
            Spacer()
        }.padding(.horizontal)
        .padding(.top)
        
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .top, spacing: 16) {
                ForEach(movies, id: \.self) { num in
                    GeometryReader { proxy in
                        let scale = getScale(proxy: proxy)
                        NavigationLink(
                            destination: MovieDetailsView(movie: num),
                            label: {
                                VStack(spacing: 8) {
                                    Image(num.imageName)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 180)
                                        .clipped()
                                        .cornerRadius(8)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(Color(white: 0.4))
                                        )
                                        .shadow(radius: 3)
                                    Text(num.title)
                                        .font(.system(size: 16, weight: .semibold))
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(.black)
                                    HStack(spacing: 0) {
                                        ForEach(0..<5) { num in
                                            Image(systemName: "")
                                                .foregroundColor(.orange)
                                                .font(.system(size: 14))
                                        }
                                    }.padding(.top, -4)
                                }
                            })
                        
                            .scaleEffect(.init(width: scale, height: scale))
                            .padding(.vertical)
                    }
                    .frame(width: 125, height: 400)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 32)
                }
                Spacer()
                    .frame(width: 16)
            }
        }
    }
}

struct MovieDetailsView: View {
    let movie: Movie
    var body: some View {
        Image(movie.imageName)
            .resizable()
            .scaledToFill()
            .navigationTitle(movie.title)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
