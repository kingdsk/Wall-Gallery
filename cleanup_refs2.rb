require 'xcodeproj'

project = Xcodeproj::Project.open('ImageViewer.xcodeproj')
to_remove = [
  "UIAlertViewControllerStyle+Extension.swift",
  "UIImageView+Extension.swift",
  "UILabel+FormatStyle.swift",
  "Vibration.swift"
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
