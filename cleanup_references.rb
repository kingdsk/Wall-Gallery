require 'xcodeproj'

project_path = 'ImageViewer.xcodeproj'
project = Xcodeproj::Project.open(project_path)
files_deleted = [
  "AppError.swift", "DataSourceError.swift", "FileError.swift", "NetworkError.swift", "ValidationError.swift",
  "APIConstants.swift", "APIEnvelope.swift", "BaseViewController.swift", "RoundeImageWithBorder.swift",
  "NSLayoutConstraint+Class.swift", "UIBarButtonItem+Class.swift", "UICollectionView+Class.swift", 
  "UIImageView+Class.swift", "UILabel+Class.swift", "UITableView+Class.swift", "UITextView+Class.swift",
  "UIView+Class.swift", "AppConstants.swift", "AppLogger.swift", "Debouncer.swift", "Safe.swift", 
  "ValidationConstant.swift", "WebViewLinks.swift", "AppErrors"
]

project.main_group.recursive_children.each do |node|
  if node.is_a?(Xcodeproj::Project::Object::PBXFileReference) || node.is_a?(Xcodeproj::Project::Object::PBXGroup)
    if files_deleted.include?(node.name) || files_deleted.include?(node.path)
      puts "Removing reference: #{node.name || node.path}"
      node.remove_from_project
    end
  end
end

project.save
puts "Project saved."
