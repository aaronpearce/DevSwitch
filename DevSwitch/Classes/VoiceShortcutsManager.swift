//
//  VoiceShortcutsManager.swift
//  DevSwitch
//
//  Created by Aaron Pearce on 01/03/19.
//  Copyright © 2019 Aaron Pearce. All rights reserved.
//

import Foundation
import Intents

@available(iOS 12, *)
public class VoiceShortcutsManager {
    static let shared = VoiceShortcutsManager()
    
    public private(set) var voiceShortcuts: [INVoiceShortcut] = []
    
    public init() {
        updateVoiceShortcuts(completion: nil)
    }
    
    func voiceShortcut(for territory: Territory) -> INVoiceShortcut? {
        let voiceShortcut = voiceShortcuts.first { (potentialVoiceShortcut) -> Bool in
            guard let activity = potentialVoiceShortcut.shortcut.userActivity,
                let code = activity.userInfo?["code"] as? String else {
                    return false
            }
            return code == territory.code
        }
        return voiceShortcut
    }
    
    func updateVoiceShortcuts(completion: (() -> Void)?) {
        INVoiceShortcutCenter.shared.getAllVoiceShortcuts { (voiceShortcutsFromCenter, error) in
            guard let voiceShortcutsFromCenter = voiceShortcutsFromCenter else {
                if let error = error as NSError? {
                    print("Failed to fetch voice shortcuts with error: \(error.localizedDescription)")
                }
                return
            }
            
            self.voiceShortcuts = voiceShortcutsFromCenter
            
            if let completion = completion {
                DispatchQueue.main.async {
                    completion()
                }
            }
        }
    }
}
