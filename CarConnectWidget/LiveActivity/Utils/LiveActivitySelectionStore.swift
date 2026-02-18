//
//  LiveActivitySelectionStore.swift
//  Runner
//
//  Created by Андрей Чернышев on 16.01.2026.
//

import ActivityKit

// TODO: все по LiveActivity внутри CarConnectWidget -> Live Activity
final class LiveActivitySelectionStore {
    private lazy var registerToken = LiveActivityRegisterToken()
}

// MARK: Public
extension LiveActivitySelectionStore {
    func getSelectedTypeRaw(vehicleId: String) -> String? {
        if Activity<AccessCarLiveActivityAttributes>.activities.contains(where: { $0.attributes.vehicleId == vehicleId }) {
            return LiveActivityType.accessCar.rawValue
        }

        if Activity<PowerLiveActivityAttributes>.activities.contains(where: { $0.attributes.vehicleId == vehicleId }) {
            return LiveActivityType.power.rawValue
        }

        if Activity<TirePressureLiveActivityAttributes>.activities.contains(where: { $0.attributes.vehicleId == vehicleId }) {
            return LiveActivityType.tirePressure.rawValue
        }

        return nil
    }

    func start(
        type: LiveActivityType,
        vehicleId: String,
        vehicleMark: String,
        vehicleModel: String,
        vehicleUrl: String?,
        isElectric: Bool,
        tirePressureFLeft: Double?,
        tirePressureBLeft: Double?,
        tirePressureFRight: Double?,
        tirePressureBRight: Double?,
        powerPercent: Int?
    ) async {
        await endAllLiveActivities()

        guard ActivityAuthorizationInfo().areActivitiesEnabled else {
            return
        }

        switch type {
        case .accessCar:
            await startAccessCar(
                vehicleId: vehicleId,
                vehicleMark: vehicleMark,
                vehicleModel: vehicleModel,
                vehicleUrl: vehicleUrl
            )
        case .power:
            await startPower(
                vehicleId: vehicleId,
                vehicleMark: vehicleMark,
                vehicleModel: vehicleModel,
                vehicleUrl: vehicleUrl,
                isElectric: isElectric,
                powerPercent: powerPercent
            )
        case .tirePressure:
            await startTirePressure(
                vehicleId: vehicleId,
                fLeft: tirePressureFLeft,
                bLeft: tirePressureBLeft,
                fRight: tirePressureFRight,
                bRight: tirePressureBRight
            )
        }
    }
    
    func end(vehicleId: String) {
        Task {
            await endLiveActivities(vehicleId: vehicleId)
        }
    }
}

// MARK: Private
private extension LiveActivitySelectionStore {
    func endLiveActivities(vehicleId: String) async {
        let access = Activity<AccessCarLiveActivityAttributes>.activities
            .filter { $0.attributes.vehicleId == vehicleId }

        let power = Activity<PowerLiveActivityAttributes>.activities
            .filter { $0.attributes.vehicleId == vehicleId }

        let tire = Activity<TirePressureLiveActivityAttributes>.activities
            .filter { $0.attributes.vehicleId == vehicleId }

        await endActivities(access)
        await endActivities(power)
        await endActivities(tire)
    }
    
    func endAllLiveActivities() async {
        await endActivities(Activity<AccessCarLiveActivityAttributes>.activities)
        await endActivities(Activity<PowerLiveActivityAttributes>.activities)
        await endActivities(Activity<TirePressureLiveActivityAttributes>.activities)
    }

    func endActivities<A: ActivityAttributes>(_ activities: [Activity<A>]) async {
        for activity in activities {
            await activity.end(nil, dismissalPolicy: .immediate)
        }
    }
    
    func startAccessCar(
        vehicleId: String,
        vehicleMark: String,
        vehicleModel: String,
        vehicleUrl: String?
    ) async {
        let attributes = AccessCarLiveActivityAttributes(vehicleId: vehicleId)
        let state = AccessCarLiveActivityAttributes.ContentState(
            vehicleMark: vehicleMark,
            vehicleModel: vehicleModel,
            vehicleUrl: vehicleUrl
        )

        _ = try? Activity.request(
            attributes: attributes,
            content: ActivityContent(state: state, staleDate: nil),
            pushType: nil
        )
    }

    func startPower(
        vehicleId: String,
        vehicleMark: String,
        vehicleModel: String,
        vehicleUrl: String?,
        isElectric: Bool,
        powerPercent: Int?
    ) async {
        let attributes = PowerLiveActivityAttributes(vehicleId: vehicleId)
        let state = PowerLiveActivityAttributes.ContentState(
            vehicleMark: vehicleMark,
            vehicleModel: vehicleModel,
            vehicleUrl: vehicleUrl,
            isElectric: isElectric,
            powerPercent: powerPercent
        )

        let activity = try? Activity.request(
            attributes: attributes,
            content: ActivityContent(state: state, staleDate: nil),
            pushType: .token
        )
        
        if let activity {
            await registerToken.register(activity: activity, vehicleId: vehicleId, type: "power")
        }
    }

    func startTirePressure(
        vehicleId: String,
        fLeft: Double?,
        bLeft: Double?,
        fRight: Double?,
        bRight: Double?
    ) async {
        let attributes = TirePressureLiveActivityAttributes(vehicleId: vehicleId)
        let state = TirePressureLiveActivityAttributes.ContentState(
            fLeft: fLeft,
            bLeft: bLeft,
            fRight: fRight,
            bRight: bRight
        )

        let activity = try? Activity.request(
            attributes: attributes,
            content: ActivityContent(state: state, staleDate: nil),
            pushType: .token
        )
        
        if let activity {
            await registerToken.register(activity: activity, vehicleId: vehicleId, type: "tire_pressure")
        }
    }
}
