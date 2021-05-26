//
//  ViewController.swift
//  TaskListCoreData
//
//  Created by Marat Shagiakhmetov on 26.05.2021.
//

import UIKit

class TaskListViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationBar()
    }

    private func setupNavigationBar() {
        title = "Task List"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Navigation Bar Appearence
        let navBarAppearence = UINavigationBarAppearance()
        navBarAppearence.configureWithOpaqueBackground()//отвечает за прозрачность, но мы его не увидим из-за белого фона
        navBarAppearence.titleTextAttributes = [.foregroundColor: UIColor.white]//цвет фона для маленького текста, который будет отображаться в навигейшн баре
        navBarAppearence.largeTitleTextAttributes = [.foregroundColor: UIColor.white]//цвет фона для большого текста
        
        navBarAppearence.backgroundColor = UIColor(
            red: 240/255,
            green: 51/255,
            blue: 60/255,
            alpha: 190/255
        )
        
        navigationController?.navigationBar.standardAppearance = navBarAppearence
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearence
        //при прокрутки мы можем увидеть, что навигейшн бар сохраняет свой цвет. то есть, как бы сливается при прокрутке вверх или вниз
        
        //Add button to navigation bar
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addNewTask)
        )
        //target определяет в каком месте будет вызываться метод, который мы передадим в параметр
        //action - метод, который мы должны здесь определить через селектор
        navigationController?.navigationBar.tintColor = .white
    }
    
    @objc private func addNewTask() {
        let newTaskVC = NewTaskViewController()
        present(newTaskVC, animated: true)
    }
}

