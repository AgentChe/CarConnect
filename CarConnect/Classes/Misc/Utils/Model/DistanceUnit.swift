//
//  DistanceUnit.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 27.05.2026.
//

import Foundation

enum DistanceUnit: String, Codable, Hashable {
    case metric   // km/h, km
    case imperial // mph, miles
}

struct DistanceConverter {
    // MARK: Distance

    /// Meters → kilometers
    static func metersToKilometers(_ meters: Double) -> Double {
        meters / 1000.0
    }

    /// Meters → miles
    static func metersToMiles(_ meters: Double) -> Double {
        meters / 1609.344
    }

    /// Kilometers → miles
    static func kilometersToMiles(_ km: Double) -> Double {
        km * 0.621371
    }

    /// Miles → kilometers
    static func milesToKilometers(_ miles: Double) -> Double {
        miles * 1.609344
    }

    /// Miles → meters
    static func milesToMeters(_ miles: Double) -> Double {
        miles * 1609.344
    }
    
    /// Converts meters to the distance value for the given unit (km or miles)
    static func metersToDistance(_ meters: Double, unit: DistanceUnit) -> Double {
        switch unit {
        case .metric:
            return metersToKilometers(meters)
        case .imperial:
            return metersToMiles(meters)
        }
    }
    
    /// Formatted route distance string (e.g. "12.5 km" / "7.8 mi")
    static func formattedDistance(_ meters: Double, unit: DistanceUnit) -> String {
        switch unit {
        case .metric:
            let km = metersToKilometers(meters)
            return String(format: "%.1f \("km".localized)", km)
        case .imperial:
            let miles = metersToMiles(meters)
            return String(format: "%.1f \("mi".localized)", miles)
        }
    }

    // MARK: Speed

    /// km/h → mph
    static func kmhToMph(_ kmh: Double) -> Double {
        kmh * 0.621371
    }

    /// mph → km/h
    static func mphToKmh(_ mph: Double) -> Double {
        mph * 1.609344
    }

    /// m/s → km/h
    static func msToKmh(_ ms: Double) -> Double {
        ms * 3.6
    }

    /// m/s → mph
    static func msToMph(_ ms: Double) -> Double {
        ms * 2.23694
    }

    /// Converts km/h to the speed value for the given unit
    static func kmhToSpeed(_ kmh: Double, unit: DistanceUnit) -> Double {
        switch unit {
        case .metric:
            return kmh
        case .imperial:
            return kmhToMph(kmh)
        }
    }
    
    /// Formatted speed string (e.g. "60 km/h" / "37 mph")
    static func formattedSpeed(_ kmh: Double, unit: DistanceUnit) -> String {
        switch unit {
        case .metric:
            return "\(Int(kmh.rounded())) \("km/h".localized)"
        case .imperial:
            return "\(Int(kmhToMph(kmh).rounded())) \("mph".localized)"
        }
    }
}
