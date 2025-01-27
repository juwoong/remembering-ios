//
//  Speaking.swift
//  remembering
//
//  Created by 배주웅 on 1/27/25.
//

import AVFoundation

func speakJapanese(_ text: String) {
    let synthesizer = AVSpeechSynthesizer()
    let utterance = AVSpeechUtterance(string: text)
    
    utterance.voice = AVSpeechSynthesisVoice(language: "ja-JP")
    synthesizer.speak(utterance)
}
