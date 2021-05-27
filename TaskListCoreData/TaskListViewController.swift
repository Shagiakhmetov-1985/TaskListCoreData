//
//  ViewController.swift
//  TaskListCoreData
//
//  Created by Marat Shagiakhmetov on 26.05.2021.
//

import UIKit
import CoreData

class TaskListViewController: UITableViewController {
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private let cellID = "cell"
    private var taskList: [Task] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID) //зарегистрировать и указать идентификатор для ячейки
        setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        print("viewWillAppear")
        fetchData()
//        print(taskList)
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
        newTaskVC.modalPresentationStyle = .fullScreen
        present(newTaskVC, animated: true)
    }
    
    private func fetchData() {
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        do {
            taskList = try context.fetch(fetchRequest)
            tableView.reloadData()
        } catch let error {
            print(error.localizedDescription)
        }
    } //для восстановления данных нужен метод fetchData, это значит чтобы восстановить данные из базы и нам нужно создать запрос к этой базе. нам надо создать запрос fetchRequest для объектов с типом task, поэтому, мы должны указать тип, который нам нужен. можно настраивать различные параметры сортировки или фильтрации данных для извлечения
}

// MARK: - Table View Data Source
extension TaskListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        taskList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        var content = cell.defaultContentConfiguration()
        let task = taskList[indexPath.row]
        content.text = task.name
        print(task.name!)
        cell.contentConfiguration = content
        return cell
    }
}
