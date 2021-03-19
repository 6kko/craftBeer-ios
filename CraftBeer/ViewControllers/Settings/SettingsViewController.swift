//
//  Created by Michele Restuccia on 13/3/21.
//

import UIKit
import CraftBeerAccessibility

class SettingsViewController: UIViewController {
    
    enum Constants {
        static let SmallSpacing: CGFloat = 4
        static let NormalSpacing: CGFloat = 8
        static let Spacing: CGFloat = 16
        static let BigSpacing: CGFloat = 24
        static let LineHeightMultiplier: CGFloat = 1.3
    }
    
    private var data: [TableSection] = [.section1, .section2]
    private let tableView = UITableView.init(frame: .zero, style: .insetGrouped)
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .craftBeerBackgroundColor
        navigationItem.title = "settings-title".localized
        view.addAutolayoutSubview(tableView)
        tableView.pinToSuperview()
        
        tableView.backgroundColor = .clear
        tableView.registerReusableCell(Cell.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 48
        
        /// Setup accesibility
        setCraftBeerIdentifier(.settings)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setEditing(false, animated: false)
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
        navigationItem.rightBarButtonItem = {
            let icon: UIBarButtonItem.SystemItem = {
                return editing ? .cancel : .edit
            }()
            return UIBarButtonItem(barButtonSystemItem: icon, target: self, action: #selector(onEditButtonTapped))
        }()
    }
    
    //MARK: Actions
    
    @objc private func onEditButtonTapped() {
        self.setEditing(!isEditing, animated: true)
    }
}

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data[section].rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: Cell = tableView.dequeueReusableCell(indexPath: indexPath)
        cell.configureFor(viewModel: data[indexPath.section].rows[indexPath.row].title)
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        guard let tableSection = TableSection(rawValue: indexPath.section) else { return false }
        switch tableSection {
        case .section1: return true
        default: return false
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal, title: nil) { _,_,_ in
            self.showTodoAlert()
        }
        let image = UIImage.craftBeerIcon(.like).scaleTo(CGSize(width: 20, height: 20))
        action.image = image
        action.backgroundColor = .orange
        
        /// Setup accesibility
        action.setCraftBeerIdentifier(Identifiers.Buttons.like)
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let tableSection = TableSection(rawValue: section) else { return nil }
        return tableSection.header
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.backgroundColor = .clear
        header.textLabel?.textColor = .craftBeerTextTitleColor
        header.textLabel?.text = header.textLabel?.text?.capitalized
        header.textLabel?.font = boldTextStyler.fontForStyle(.headline)
        header.textLabel?.textAlignment = .center
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showTodoAlert()
    }
}

private extension SettingsViewController {
    
    enum TableSection: Int, CaseIterable {
        case section1 = 0, section2
        
        enum Row {
            case setting1, setting2, setting3
            
            var title: String {
                switch self {
                case .setting1: return "settings-1".localized
                case .setting2: return "settings-2".localized
                case .setting3: return "settings-3".localized
                }
            }
        }
        
        var rows: [Row] {
            switch self {
            case .section1: return [.setting1, .setting2]
            case .section2: return [.setting3]
            }
        }
        
        var header: String {
            switch self {
            case .section1: return "Section 1"
            case .section2: return "Section 2"
            }
        }
    }
}

extension SettingsViewController: AppModule {
    var analyticsName: String? { "SettingsViewController" }
}
