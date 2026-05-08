require 'xcodeproj'

project_path = 'ImageViewer.xcodeproj'
project = Xcodeproj::Project.open(project_path)

# 1. Remove SPM Packages
packages_to_remove = ["Moya", "Alamofire", "SwiftyJSON", "Siren", "lottie-ios", "aws-sdk-ios-spm", "IQKeyboardManager"]
project.root_object.package_references.each do |pkg|
  if packages_to_remove.any? { |p| pkg.repositoryURL.downcase.include?(p.downcase) }
    puts "Removing package reference: #{pkg.repositoryURL}"
    pkg.remove_from_project
  end
end

target = project.targets.first
target.package_product_dependencies.each do |dep|
  if packages_to_remove.any? { |p| dep.product_name.downcase.include?(p.downcase) || (dep.package && dep.package.repositoryURL.to_s.downcase.include?(p.downcase)) }
    puts "Removing package product dependency: #{dep.product_name}"
    dep.remove_from_project
  end
end

project.save
puts "Project saved successfully."
