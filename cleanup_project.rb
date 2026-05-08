require 'xcodeproj'

project_path = 'ImageViewer.xcodeproj'
project = Xcodeproj::Project.open(project_path)

# 1. Remove SPM Packages
packages_to_remove = ["Moya", "Alamofire", "SwiftyJSON", "Siren", "lottie-ios", "aws-sdk-ios-spm", "IQKeyboardManager"]
project.root_object.package_references.each do |pkg|
  # repositoryURL could end with .git
  if packages_to_remove.any? { |p| pkg.repositoryURL.downcase.include?(p.downcase) }
    puts "Removing package reference: #{pkg.repositoryURL}"
    pkg.remove_from_project
  end
end

# Find the main target to remove package products
target = project.targets.first
target.package_product_dependencies.each do |dep|
  if packages_to_remove.any? { |p| dep.product_name.downcase.include?(p.downcase) || dep.package.repositoryURL.to_s.downcase.include?(p.downcase) }
    puts "Removing package product dependency: #{dep.product_name}"
    dep.remove_from_project
  end
end

# 2. Remove files from the project
files_to_remove = [
  'ImageViewer/WebService',
  'ImageViewer/ThirdPartyLibrary/CryptLib',
  'ImageViewer/ThirdPartyLibrary/KeyboardLayoutConstraint.swift',
  'ImageViewer/ThirdPartyLibrary/KeychainItem.swift',
  'ImageViewer/Scenes/Models/List',
  'ImageViewer/Scenes/Models/User',
  'ImageViewer/Scenes/Models/Bindable'
]

def remove_group_or_file(parent, path_components)
  return if path_components.empty?
  
  component = path_components.first
  # find child
  child = parent.children.find { |c| c.display_name == component || c.path == component }
  
  if child
    if path_components.count == 1
      puts "Removing from project: #{child.path || child.display_name}"
      child.remove_from_project
    else
      remove_group_or_file(child, path_components.drop(1))
    end
  else
    puts "Could not find #{component} in #{parent.display_name || parent.path}"
  end
end

files_to_remove.each do |path|
  components = path.split('/')
  # components[0] is 'ImageViewer' which is a group under main group
  # But the main group usually has the same name as the project or is just the root.
  
  # Wait, let's search recursively
  nodes = project.main_group.recursive_children
  matched_nodes = nodes.select do |n|
    n.real_path.to_s.end_with?(path)
  end
  
  matched_nodes.each do |node|
    puts "Removing node: #{node.real_path}"
    node.remove_from_project
  end
end

project.save
puts "Project saved successfully."
