require 'xcodeproj'

project_path = 'ImageViewer.xcodeproj'
project = Xcodeproj::Project.open(project_path)
packages_to_remove = ["Moya", "Alamofire", "SwiftyJSON", "Siren", "Lottie", "AWSCore", "AWSS3", "IQKeyboardManagerSwift"]

target = project.targets.first

# Remove from Frameworks Build Phase
frameworks_phase = target.frameworks_build_phase
frameworks_phase.files.each do |build_file|
  if build_file.product_ref
    product_name = build_file.product_ref.product_name
    if packages_to_remove.any? { |p| product_name.to_s.casecmp(p) == 0 }
      puts "Removing from Frameworks: #{product_name}"
      build_file.remove_from_project
    end
  end
end

# Remove Package Product Dependencies
target.package_product_dependencies.each do |dep|
  if packages_to_remove.any? { |p| dep.product_name.to_s.casecmp(p) == 0 }
    puts "Removing Product Dependency: #{dep.product_name}"
    dep.remove_from_project
  end
end

project.save
puts "Cleaned up dependencies"
