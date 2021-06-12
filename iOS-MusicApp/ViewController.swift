//
//  ViewController.swift
//  iOS-MusicApp
//
//  Created by H43RO on 2021/06/12.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioPlayerDelegate {
    
    // MARK:- Properties
    var player: AVAudioPlayer!
    var timer: Timer!
    
    
    // MARK:- IBOutlets
    @IBOutlet var playPauseButton: UIButton!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var progressSlider: UISlider!

    
    // MARK:- Methods
    // 뷰가 모두 구성되면 Player 초기화 수행
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initializePlayer()
    }
    
    // Timer 동작 시작 (도화선 느낌으로다가 fire 라는 이름의 메소드 사용)
    func makeAndFireTimer() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { [unowned self] (timer: Timer) in
            
            if self.progressSlider.isTracking { return }
            
            self.updateTimeLabelText(time: self.player.currentTime)
            self.progressSlider.value = Float(self.player.currentTime)
        })
        self.timer.fire()
    }
    
    // Timer 동작 종료 (Timer 객체 nil 화 시킴)
    func invalidateTimer(){
        self.timer.invalidate()
        self.timer = nil
    }
    
    // 사용자에 의해 Slider 의 값이 변경되었을 때 (AVAudioPlayer 객체를 통해 음원 재생 위치 조정)
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        self.updateTimeLabelText(time: TimeInterval(sender.value))
        if sender.isTracking { return }
        self.player.currentTime = TimeInterval(sender.value)
    }
    
    // 초기화 작업
    // - Asset 매니저로부터 'sound'라는 음원 파일 로드하여 이를 통해 AVAudioPlayer 초기화
    // - AVAudioPlayer 객체의 Delegate 등록 후 Slider 최댓값 음원 총 재생 길이로 설정
    func initializePlayer(){
        guard let soundAsset: NSDataAsset = NSDataAsset(name: "sound") else{
            print("음원 파일 에셋을 가져올 수 없습니다")
            return
        }
        
        do {
            try self.player = AVAudioPlayer(data: soundAsset.data)
            self.player.delegate = self
        } catch let error as NSError {
            print("플레이어 초기화 실패")
            print("코드 : \(error.code), 메세지 : \(error.localizedDescription)")
        }
        
        self.progressSlider.maximumValue = Float(self.player.duration)
        self.progressSlider.minimumValue = 0
        self.progressSlider.value = Float(self.player.currentTime)
    }
    
    // 밀리세컨트 단위로 Slider 의 Text (음원 재생 위치) 변경 수행
    func updateTimeLabelText(time: TimeInterval){
        let minute: Int = Int(time / 60)
        let second: Int = Int(time.truncatingRemainder(dividingBy: 60))
        let milisecond: Int = Int(time.truncatingRemainder(dividingBy: 1) * 100)
        
        let timeText: String = String(format: "%02ld:%02ld:%02ld", minute, second, milisecond)
        
        self.timeLabel.text = timeText
    }
    
    // Play & Pause 버튼을 눌렀을 때 정의된 토글 동작 수행 (음원 재생 및 일시정지)
    @IBAction func touchUpPlayPauseButton(_ sender: UIButton){
        print("Button tapped")
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            self.player?.play()
        } else{
            self.player?.pause()
        }
        
        if sender.isSelected{
            self.makeAndFireTimer()
        }else{
            self.invalidateTimer()
        }
    }
    
    // AVAudioPlayer 실행 시 오류가 발생했을 때
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        guard let error: Error = error else {
            print("오디오 플레이어 디코드 오류 발생")
            return
        }
        
        let message: String
        message = ("오디오 플레이어 오류 발생 \(error.localizedDescription)")
        
        let alert: UIAlertController = UIAlertController(title: "알림", message: message, preferredStyle: UIAlertController.Style.alert)
        let okAction: UIAlertAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.default) { (action: UIAlertAction) -> Void in
            self.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    // 음원 재생이 완료되었을 때
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.playPauseButton.isSelected = false
        self.progressSlider.value = 0
        self.updateTimeLabelText(time: 0)
        self.invalidateTimer()
    }
}

