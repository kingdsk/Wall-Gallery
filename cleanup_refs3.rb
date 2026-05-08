require 'xcodeproj'
project = Xcodeproj::Project.open('ImageViewer.xcodeproj')
to_remove = [
  "Date+Extension.swift", "CGFloat+Extension.swift", "UITextView+Extension.swift",
  "UIBarButtonItem+Extension.swift", "UIScrollView+Extension.swift", "UIContol+Extension.swift",
  "SessionManager.swift", "DeviceManager.swift", "UIButton+Class.swift", "UITextField+Class.swift"
]
project.main_group.recursive_children.each do |node|
  if node.is_a?(Xcodeproj::Project::Object::PBXFileReference)
    if to_remove.include?(node.name) || to_remove.include?(node.path)
      puts "Removing: #{node.name || node.path}"
      node.remove_from_project
    end
  end
end
project.save
puts "Done."
