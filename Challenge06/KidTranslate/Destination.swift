import SwiftUI

/// Rotas navegáveis via NavigationStack (push)
enum Destination: Hashable {
    case recording
    case detail(id: Int)
}
