import SwiftUI
import Observation


@MainActor
@Observable
final class AppCoordinator {
    var path = NavigationPath()

    // MARK: - Push navigation
    func push(_ destination: Destination) {
        path.append(destination)
    }

    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    func popToRoot() {
        path.removeLast(path.count)
    }

    func popTo(count: Int) {
        guard count >= 0, count <= path.count else { return }
        path.removeLast(path.count - count)
    }
}
