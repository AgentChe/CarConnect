////
////  AppleMusicAuthorization.swift
////  CarConnect
////
////  Created by Андрей Чернышев on 12.03.2026.
////
//
//import MusicKit
//import Foundation
//
//final class AppleMusicAuthorization {}
//
//extension AppleMusicAuthorization {
//    func request(completion: @escaping ((MKAuthorizationStatus) -> Void)) {
//        Task {
//            let status = await MusicAuthorization.request()
//            let mkStatus = MKAuthorizationStatus(status: status)
//            
//            DispatchQueue.main.async {
//                completion(mkStatus)
//            }
//        }
//    }
//    
//    func currentStatus() -> MKAuthorizationStatus {
//        let status = MusicAuthorization.currentStatus
//        return MKAuthorizationStatus(status: status)
//    }
//    
//    func requestDeveloperToken(
//        ignoreCache: Bool = true,
//        completion: @escaping ((String?, AppleMusicTokenRequestError?) -> Void)
//    ) {
//        Task {
//            do {
//                let token = try await DefaultMusicTokenProvider().developerToken(options: ignoreCache ? [.ignoreCache] : [])
//                
//                DispatchQueue.main.async {
//                    completion(token, nil)
//                }
//            } catch let error {
//                let requestError: AppleMusicTokenRequestError
//                if let musicKitError = error as? MusicTokenRequestError {
//                    requestError = AppleMusicTokenRequestError(error: musicKitError)
//                } else {
//                    requestError = .unknown
//                }
//                
//                DispatchQueue.main.async {
//                    completion(nil, requestError)
//                }
//            }
//        }
//    }
//    
//    func requestUserToken(
//        developerToken: String,
//        ignoreCache: Bool = true,
//        completion: @escaping ((String?, AppleMusicTokenRequestError?) -> Void)
//    ) {
//        Task {
//            do {
//                let token = try await MusicUserTokenProvider().userToken(for: developerToken, options: ignoreCache ? [.ignoreCache] : [])
//                
//                DispatchQueue.main.async {
//                    completion(token, nil)
//                }
//            } catch let error {
//                let requestError: AppleMusicTokenRequestError
//                if let musicKitError = error as? MusicTokenRequestError {
//                    requestError = AppleMusicTokenRequestError(error: musicKitError)
//                } else {
//                    requestError = .unknown
//                }
//                
//                DispatchQueue.main.async {
//                    completion(nil, requestError)
//                }
//            }
//        }
//    }
//}
