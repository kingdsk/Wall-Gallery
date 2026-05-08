require 'xcodeproj'

project_path = 'ImageViewer.xcodeproj'
project = Xcodeproj::Project.open(project_path)
packages_to_remove = ["Moya", "Alamofire", "SwiftyJSON", "Siren", "Lottie", "AWSCore", "AWSS3", "IQKeyboardManagerSwift", "aws-sdk-ios-spm"]

target = project.targets.first

# 1. Remove from Frameworks Build Phase
frameworks_phase = target.frameworks_build_phase
files_to_delete = []
frameworks_phase.files.each do |build_file|
  if build_file.product_ref
    product_name = build_file.product_ref.product_name
    if packages_to_remove.any? { |p| product_name.to_s.casecmp(p) == 0 }
      files_to_delete << build_file
    end
  end
end
files_to_delete.each { |f| f.remove_from_project }

# 2. Remove Package Product Dependencies
deps_to_delete = []
target.package_product_dependencies.each do |dep|
  if packages_to_remove.any? { |p| dep.product_name.to_s.casecmp(p) == 0 }
    deps_to_delete << dep
  end
end
deps_to_delete.each { |d| d.remove_from_project }

# 3. Remove SPM Packages
pkgs_to_delete = []
project.root_object.package_references.each do |pkg|
  if packages_to_remove.any? { |p| pkg.repositoryURL.to_s.downcase.include?(p.downcase) }
    pkgs_to_delete << pkg
  end
end
pkgs_to_delete.each { |p| p.remove_from_project }

project.save
puts "Cleaned up dependencies properly"
