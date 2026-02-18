//
//  LiveActivityRegisterToken.swift
//  Runner
//
//  Created by Андрей Чернышев on 25.01.2026.
//

import Foundation
import ActivityKit

final class LiveActivityRegisterToken {
    func register<A: ActivityAttributes>(
        activity: Activity<A>,
        vehicleId: String,
        type: String
    ) async {
        let tokenData = await withTimeout(seconds: 5) {
            for await token in activity.pushTokenUpdates {
                return token
            }
            return nil
        }
        guard let tokenData else { return }
        
        // TODO:
        let anonymousId =  ""//OtterScale.shared.getAnonymousID()
        let internalId = "" // OtterScale.shared.getInternalID()
        
        let tokenHex = tokenData.map { String(format: "%02x", $0) }.joined()
        
        let body = Body(
            anonymous_id: anonymousId,
            internal_id: anonymousId == internalId ? nil : internalId,
            token: tokenHex,
            vehicle_id: vehicleId,
            type: type
        )
        
        try? await postLiveActions(body: body)
    }
}

// MARK: Private
private extension LiveActivityRegisterToken {
    struct Body: Encodable {
        let anonymous_id: String
        let internal_id: String?
        let token: String
        let vehicle_id: String
        let type: String
    }
    
    func postLiveActions(body: Body) async throws {
        let url = URL(string: "\(GlobalDefinitions.domain)/api/v1/vehicle/actions/live")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(GlobalDefinitions.apiKey, forHTTPHeaderField: "Access-Token")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(body)
        request.timeoutInterval = 10

        let (_, response) = try await URLSession.shared.data(for: request)

        guard let http = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }

        guard (200...299).contains(http.statusCode) else {
            throw URLError(.badServerResponse)
        }
    }
    
    func withTimeout<T>(seconds: UInt64, operation: @escaping () async -> T?) async -> T? {
        await withTaskGroup(of: T?.self) { group in
            group.addTask {
                await operation()
            }
            group.addTask {
                try? await Task.sleep(nanoseconds: seconds * 1_000_000_000)
                return nil
            }

            let result = await group.next() ?? nil
            group.cancelAll()
            return result
        }
    }
}
