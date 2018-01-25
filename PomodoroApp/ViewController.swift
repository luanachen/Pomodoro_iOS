//
//  ViewController.swift
//  PomodoroApp
//
//  Created by Luana on 18/01/18.
//  Copyright © 2018 lccj. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var labelCounter: UILabel!
    @IBOutlet weak var btnStart: UIButton!
    @IBOutlet weak var btnPause: UIButton!
    @IBOutlet weak var btnRestart: UIButton!
    @IBOutlet weak var labelPauseCount: UILabel!
    
    @IBOutlet weak var pickerViewPausas: UIPickerView!
    
    // MARK: - Properties
    var timer = Timer() // instancia de timer para o pomodoro
    var pomoCounter = 3
    var pauseCounter = 3
    var pauseTimer = Timer() // instancia de timer para a pausa
    
    var arrayPausas = ["curta", "normal", "longa"]
    
    // MARK: - View cicle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelCounter.text = "25:00"
        labelPauseCount.text = "03:00"
        
        btnPause.isEnabled = false
        btnRestart.isEnabled = false
        
        pickerViewPausas.dataSource = self
        pickerViewPausas.delegate = self
    }
    
    // MARK: - Actions
    // Method to start counting
    @IBAction func startCount(_ sender: UIButton?) {
        
        runTimer()
        
        btnStart.isEnabled = false
        btnPause.isEnabled = true
        btnRestart.isEnabled = false
    }
    
    // Method to pause counting
    @IBAction func pauseCount(_ sender: UIButton) {
        
        timer.invalidate()
        
        btnStart.isEnabled = true
        btnPause.isEnabled = false
        btnRestart.isEnabled = true
    }
    
    // Method to set to 0
    @IBAction func restartCount(_ sender: UIButton?) {
        
        pomoCounter = 1500
        
        self.labelCounter.text = "25:00"
        
        btnRestart.isEnabled = false
        btnRestart.isEnabled = false
        btnStart.isEnabled = true
    }
    
    // MARK: - my methods
    
    // Método disparado para iniciar o timer do pomodoro
    func runTimer() {
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(ViewController.updateTimer)), userInfo: nil, repeats: true)
    }
    
    // Método disparado para iniciar o timer da pausa
    func runPauseTimer() {
        
        pauseTimer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(ViewController.updatePauseTimer)), userInfo: nil, repeats: true)
    }
    
    // Método disparado para atualizar o timer do pomodoro
    @objc func updateTimer() {
        
        if pomoCounter != 0 {
            pomoCounter -= 1
        } else {
            // se o timer do pomodoro terminar, soltar o alerta para iniciar o timer da pausa
            timer.invalidate()
            timerAlert()
            labelPauseCount.text = timeString(time: TimeInterval(pauseCounter))
        }
        
        labelCounter.text = timeString(time: TimeInterval(pomoCounter))
    }
    
    // Método disparado para atualizar o timer da pausa
    @objc func updatePauseTimer() {
        
        if pauseCounter != 0 {
            pauseCounter -= 1
        } else {
            // se o timer da pausa terminar, reiniciar o timer do Pomodoro
            timerAlert()
            restartCount(nil)
            pauseTimer.invalidate()
        }
        
        labelPauseCount.text = timeString(time: TimeInterval(pauseCounter))
    }
    
    // metodo que dispara um alerta, o botão "OK" iniciar o timer da Pausa(pauseCounter)
    func timerAlert() {
        
        // alert window
        let alerta = UIAlertController(title: "Time is over! ", message: "É hora da pausa!", preferredStyle: .alert)

        var acaoOk = UIAlertAction(title: "OK", style: .default, handler: { (acaoOk) in
        })

        // se a pausa zerar, iniciar timer do pomodoro após clicar no "OK"
        if pauseCounter == 0 {

            alerta.message = "É hora de focar!"

             acaoOk = UIAlertAction(title: "OK", style: .default, handler: { (acaoOk) in

                self.runTimer()
            })


        // em quando a pausa nao for 0 o timer da pausa continuará
        } else {

             acaoOk = UIAlertAction(title: "OK", style: .default, handler: { (acaoOk) in

                self.runPauseTimer()
            })
        }
        
        // alert button
        alerta.addAction(acaoOk)
        
        present(alerta, animated: true, completion: nil)
    }
    
    // Método que define a formatação do tempo em minutos e segundos
    func timeString(time:TimeInterval) -> String {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i", minutes, seconds)
    }
    
}

// Extensao para adotar protocolo de UIPickerViewDataSource
extension ViewController : UIPickerViewDataSource {
    // método que define número de componentes
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // método que define número de linhas
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrayPausas.count
    }
}

// Extensao para adotar protocolo de UIPickerViewDelegate
extension ViewController : UIPickerViewDelegate {
    
    // Metodo que define o titulo de cada linha do picker
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return arrayPausas[row]
    }
    
    // Metodo disparado quando uma linha do picker é selecionada
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch arrayPausas[row] {
        case "curta":
            pauseCounter = 180
        case "medio":
            pauseCounter = 300
        case "longa":
            pauseCounter = 600
        default:
            pauseCounter = 300
        }
        
        labelPauseCount.text = timeString(time: TimeInterval(pauseCounter))
    }
}

