//
//  ViewController.swift
//  Homework44MemoryGame
//
//  Created by ้ปๆๅ on 2021/12/22.
//

import UIKit

class ViewController: UIViewController {
    //Label
    @IBOutlet weak var preparationTimeLabel: UILabel!
    @IBOutlet weak var gameTimeLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    //button
    @IBOutlet var cardButtons: [UIButton]!
    //emoji
    var emojiArray = ["๐","๐","๐","๐","๐คฉ","๐คฉ","๐ญ","๐ญ","๐ฅณ","๐ฅณ","๐คฏ","๐คฏ"]
    //ๅฒๅญๆ้็Button
    var pressedButton = [UIButton]()
    //็ด้ๅทฒ็ถๅนพๅฐ
    var pairs:Int = 0{
        didSet{
        if pairs == 6 {
                //้ๆฒ็ตๆ
                timer?.invalidate()
                level += 1
                gameTime = 60-(level*10)
                if level < 5{
                    alert(title: "ๆญๅ๏ผ๏ผ๏ผ", message: "ๆ้ๅงๅฎๆ้ๆฒ๏ผ็นผ็บไธไธ้")
                }else if level == 6{
                    alert(title: "ๆญๅ๏ผ๏ผ๏ผ", message: "ๅฎๆๆๆ้ๅก")
                    level = 0
                    gameTime = 60-(level*10)
                }
            }
        }
    }
    //็ญ็ด
    var level:Int = 0{
        didSet{
            levelLabel.text = "Level \(level+1)"
        }
    }
    //้ ๅๆ้
    var preparationTime:Int = 5{
        didSet{
            preparationTimeLabel.text = "\(preparationTime)"
        }
    }
    //้ๆฒๆ้
    var gameTime:Int = 60{
        didSet{
            gameTimeLabel.text = "\(gameTime)"
        }
    }
    //ๆบๅๆ้
    var timer:Timer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gameInit()
        
    }
    //้ๆฒๅๅงๅ
    func gameInit(){
       view.bringSubviewToFront(preparationTimeLabel)
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countDownPreparationTime), userInfo: nil, repeats: true)
        emojiArray.shuffle()
        for (i,Button) in cardButtons.enumerated(){
            Button.setTitle(emojiArray[i], for: .normal)
            Button.alpha = 1
        }
        pairs = 0
    }
    
    //ๅฏ็็ๆ้
    @objc func countDownPreparationTime(){
        preparationTime -= 1
        if preparationTime == 0{
            preparationTimeLabel.text = "Start"
            timer?.invalidate()
            DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.countDownGameTime), userInfo: nil, repeats: true)
                self.view.sendSubviewToBack(self.preparationTimeLabel)
                self.preparationTime = 5
                self.preparationTimeLabel.text = ""
            }
            //็ฟป็ๅ็ซ
            for (i,Button) in cardButtons.enumerated(){
                Button.setTitle("?", for: .normal)
                UIView.transition(with: cardButtons[i], duration: 0.5, options: .transitionFlipFromRight, animations: nil, completion: nil)
            }
        }
    }
    //้ๆฒๆ้
    @objc func countDownGameTime(){
        if gameTime > 0{
            gameTime -= 1
        }else if gameTime == 0{
            timer?.invalidate()
            gameTime = 60
            alert(title:"ๅๆญ...", message: "้ๆฒๆ้ๅฐ")
        }
    }
    //็ฟป็
    @IBAction func flipCard(_ sender: UIButton) {
        if sender.title(for: .normal) == "?"{
            //ๆน่ฎๆ้็ซ้ข
            sender.setTitle(emojiArray[sender.tag], for: .normal)
            UIView.transition(with: sender, duration: 0.5, options: .transitionFlipFromRight, animations: nil, completion: nil)
            //ๅฐๆ้็buttonๅ ๅฅ้ฃๅ
            pressedButton.append(sender)
            //่ฅๆๅทฒ็ถๆๅฉๅๅฐฑๆชขๆฅ
            if pressedButton.count == 2{
                DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                    self.checkCard(buttons: self.pressedButton)
                    self.pressedButton.removeAll()
                }
            }
        }
    }
    //ๆชขๆฅๅฉๅผตๅก็
    func checkCard(buttons:[UIButton]){
        if buttons[0].title(for:.normal) == buttons[1].title(for: .normal){
            for button in buttons {
                UIView.animate(withDuration: 1) {
                    button.alpha = 0
                }
            }
            pairs += 1
        }else{
            for (i,Button) in buttons.enumerated(){
                Button.setTitle("?", for: .normal)
                UIView.transition(with: buttons[i], duration: 0.5, options: .transitionFlipFromLeft, animations: nil, completion: nil)
            }
        }
    }
    //้็ฅไฝฟ็จ่
    func alert(title:String,message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let restartAction = UIAlertAction(title: "Restart", style: .default) { restartAction in
            alert.dismiss(animated: true) {
                self.gameInit()
            }
        }
        alert.addAction(restartAction)
        present(alert, animated: true, completion: nil)
    }
    
}

