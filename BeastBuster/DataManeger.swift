//
//  DataManeger.swift
//  BeastBuster
//
//  Created by 古川貴史 on 2024/08/25.
//
import Foundation

class SettingsManager {
    static var shared = SettingsManager()
    
    private init() {}
    
    private let normalSoundKey = "normalSoundKey"
    private let playbackIntervalKey = "playbackIntervalKey"
    private let emergencySoundKey = "emergencySoundKey"
    private let lightBlinkingKey = "lightBlinkingKey"
    private let volumeSettingKey = "volumeSettingKey"
    
    var normalSoundSelection: Int {
        get {
            return UserDefaults.standard.integer(forKey: normalSoundKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: normalSoundKey)
        }
    }
    
    var playbackInterval: Int {
        get {
            return UserDefaults.standard.integer(forKey: playbackIntervalKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: playbackIntervalKey)
        }
    }
    
    var emergencySoundSelection: Int {
        get {
            return UserDefaults.standard.integer(forKey: emergencySoundKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: emergencySoundKey)
        }
    }
    
    var lightBlinkingSetting: Int {
        get {
            return UserDefaults.standard.integer(forKey: lightBlinkingKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: lightBlinkingKey)
        }
    }
    
    var volumeSetting: Double {
        get {
            return UserDefaults.standard.double(forKey: volumeSettingKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: volumeSettingKey)
        }
    }
}
