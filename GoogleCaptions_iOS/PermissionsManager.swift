//
//  PermissionsManager.swift
//  BanterPrototype
//
//  Created by Devin Johnson on 6/10/21.
//

import Foundation
import AVFoundation
import Speech

final class PermissionsManager: NSObject {

    static let shared = PermissionsManager()
    private override init() {}

    static let isGrantedKey = "isPermissionGranted"

    private(set) var isSpeechRecognitionGranted = false {
        didSet {
            guard oldValue != isSpeechRecognitionGranted else { return }
            NotificationCenter.default.post(
                name: .onSpeechRecognitionPermissionChanged,
                object: self,
                userInfo: [PermissionsManager.isGrantedKey : isSpeechRecognitionGranted]
            )
        }
    }

    private(set) var isVideoCaptureEnabled = false {
        didSet {
            guard oldValue != isVideoCaptureEnabled else { return }
            NotificationCenter.default.post(
                name: .onVideoCapturePermissionChanged,
                object: self,
                userInfo: [PermissionsManager.isGrantedKey : isVideoCaptureEnabled]
            )
        }
    }

    private var isCameraAccessGranted = false {
        didSet {
            guard oldValue != isCameraAccessGranted else { return }
            determineIfVideoCaptureEnabled()
        }
    }
    private var isMicrophoneAccessGranted = false {
        didSet {
            guard oldValue != isMicrophoneAccessGranted else { return }
            determineIfVideoCaptureEnabled()
        }
    }

    private func determineIfVideoCaptureEnabled() {
        isVideoCaptureEnabled = isMicrophoneAccessGranted && isCameraAccessGranted
    }

    func requestAllPermissions() {
        requestVideoCapturePermissions()
        requestSpeechRecognitionPermission()
    }

    private func requestVideoCapturePermissions() {
        checkAccessOrRequest(for: .audio) { [weak self] granted in
            self?.isMicrophoneAccessGranted = granted
        }
        checkAccessOrRequest(for: .video) { [weak self] granted in
            self?.isCameraAccessGranted = granted
        }
    }

    private func requestSpeechRecognitionPermission() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            self.isSpeechRecognitionGranted = (authStatus == .authorized)
        }
    }

    private func checkAccessOrRequest(
        for mediaType: AVMediaType,
        completion: @escaping (Bool) -> ()
    ) {
        var permissionGranted = false
        switch AVCaptureDevice.authorizationStatus(for: mediaType) {
        case .authorized:
            permissionGranted = true
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: mediaType) { granted in
                if granted {
                    completion(granted)
                }
            }
        default:
            break
        }
        completion(permissionGranted)
    }
}

extension Notification.Name {
    static let onVideoCapturePermissionChanged = Notification.Name("onVideoCapturePermissionChanged")
    static let onSpeechRecognitionPermissionChanged = Notification.Name("onSpeechRecognitionPermissionChanged")
}
