import YandexMobileMetrica

final class AnalyticsService {
    static let shared = AnalyticsService()

    private init() {}

    func logEvent(event: String, screen: String, item: String) {
        let eventParams: [String: Any] = [
            "event": event,
            "screen": screen,
            "item": item
        ]
        
        YMMYandexMetrica.reportEvent("user_interaction", parameters: eventParams)
    }
}
