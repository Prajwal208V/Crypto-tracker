
import SwiftUI
import Foundation

extension Color{
    static let theme = ColorTheme()
    static let launch = LaunchTheme()
}
struct ColorTheme{
    let accent = Color("AccentColor")
    let background = Color("BackgroundColor")
    let green = Color("GreenColor")
    let red = Color("RedColor")
    let SecondaryText = Color("SecondaryTextColor")
}

struct LaunchTheme{
    let account = Color("LaunchAccentColor")
    let background = Color("LaunchBackgroundColor")
}
