//
//  Row.swift
//  The XY Designer
//
//  Created by Mohamed Salah on 20/05/2023.
//

import SwiftUI

struct Row: View {
    let link: String
    let id: String
    let time: Date
    var name = ""
    var firstCharacter: String = ""
    let dateFormatter = DateFormatter()
    func extractSceneName(from string: String, userIDLength: Int) -> (String, Character) {
        guard string.count > userIDLength else {
            fatalError("Invalid string format.")
        }
        
        let startIndex = string.index(string.startIndex, offsetBy: userIDLength)
        let sceneName = String(string[startIndex...])
        let firstCharacter = sceneName.first ?? Character("")
        
        return (sceneName, firstCharacter)
    }
    init(link: String, id: String, time: Date) {
        self.link = link
        self.id = id
        self.time = time
        let (sceneName, fC) = extractSceneName(from: id, userIDLength: 28)
        name = sceneName
        firstCharacter = String(fC)
        dateFormatter.dateFormat = "yyyy-MM-dd"
    }
    var body: some View {
            ZStack(alignment: .leading) {
                Color.flatDarkCardBackground
                HStack {
               NavigationLink(destination: ViewRoom(link: link)) {
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [.white,.black,.black]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                        VStack {
                            Text("\(firstCharacter)")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white)
                            
//                            Text("km")
//                                .font(.caption)
//                                .foregroundColor(.white)
                        }
                    }
                    .frame(width: 70, height: 70, alignment: .center)
                    
                    VStack(alignment: .leading) {
                        Text("\(name)")
                            .font(.title2)
                            .fontWeight(.bold)
                            .lineLimit(2)
                            .padding(.bottom, 5)
                        
                        Text("\(dateFormatter.string(from: time))")
                            .padding(.bottom, 5)
                    }
                    .padding(.horizontal, 5)
                }
               .background(Color.flatDarkCardBackground)
               .cornerRadius(10)
               .padding(15)

            }
            .clipShape(RoundedRectangle(cornerRadius: 15))
      
            }
            .cornerRadius(10)
    }
}


//struct Row_Previews: PreviewProvider {
//    static var previews: some View {
//        Row(link: "Https:Salah", id: "Salah", time: "2001/6/10")
//    }
//}
extension UIColor {
    
    static let flatDarkBackground = UIColor(red: 36, green: 36, blue: 36)
    static let flatDarkCardBackground = UIColor(red: 46, green: 46, blue: 46)
    
    convenience init(red: Int, green: Int, blue: Int, a: CGFloat = 1.0) {
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: a)
    }
}

extension Color {
    public init(decimalRed red: Double, green: Double, blue: Double) {
        self.init(red: red / 255, green: green / 255, blue: blue / 255)
    }
    
    public static var flatDarkBackground: Color {
        return Color(decimalRed: 36, green: 36, blue: 36)
    }
    
    public static var flatDarkCardBackground: Color {
        return Color(decimalRed: 46, green: 46, blue: 46)
    }
}
