import SwiftUI

@MainActor
public protocol LoginNavDelegate: AnyObject {
    func onLoginSuccessful()
}
