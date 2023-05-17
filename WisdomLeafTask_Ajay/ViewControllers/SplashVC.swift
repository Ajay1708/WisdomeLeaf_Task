//
//  SplashVC.swift
//  WisdomLeafTask_Ajay
//
//  Created by Venkata Ajay Sai Nellori on 17/05/23.
//

import UIKit

class SplashVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now()+5) {
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as? ViewController {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
