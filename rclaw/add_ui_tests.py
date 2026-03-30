#!/usr/bin/env python3
"""
Add UI Tests target to rclaw Xcode project
"""

import uuid
import re

def generate_uuid():
    """Generate a 24-character uppercase hex UUID for Xcode"""
    return str(uuid.uuid4()).replace('-', '')[:24].upper()

def main():
    project_file = 'rclaw.xcodeproj/project.pbxproj'

    with open(project_file, 'r') as f:
        content = f.read()

    # Generate UUIDs for all necessary objects
    test_target_uuid = generate_uuid()
    test_file_ref_uuid = generate_uuid()
    test_build_file_uuid = generate_uuid()
    test_info_plist_uuid = generate_uuid()
    test_group_uuid = generate_uuid()
    test_sources_phase_uuid = generate_uuid()
    test_frameworks_phase_uuid = generate_uuid()
    test_resources_phase_uuid = generate_uuid()
    test_dependency_uuid = generate_uuid()
    test_target_dependency_uuid = generate_uuid()
    test_container_item_proxy_uuid = generate_uuid()
    test_product_ref_uuid = generate_uuid()
    debug_config_uuid = generate_uuid()
    release_config_uuid = generate_uuid()
    config_list_uuid = generate_uuid()

    # Get main target UUID
    main_target_match = re.search(r'(A1000019000000000000001) /\* rclaw \*/', content)
    if not main_target_match:
        print("❌ Could not find main target UUID")
        return
    main_target_uuid = main_target_match.group(1)

    print(f"✓ Found main target: {main_target_uuid}")

    # Add file references
    file_refs_section = re.search(r'/\* End PBXBuildFile section \*/', content)
    if file_refs_section:
        new_build_files = f'''\t\t{test_build_file_uuid} /* rclawUITests.swift in Sources */ = {{isa = PBXBuildFile; fileRef = {test_file_ref_uuid} /* rclawUITests.swift */; }};
/* End PBXBuildFile section */'''
        content = content.replace('/* End PBXBuildFile section */', new_build_files)

    # Add file reference
    file_ref_section = re.search(r'/\* End PBXFileReference section \*/', content)
    if file_ref_section:
        new_file_refs = f'''\t\t{test_file_ref_uuid} /* rclawUITests.swift */ = {{isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = rclawUITests.swift; sourceTree = "<group>"; }};
\t\t{test_info_plist_uuid} /* Info.plist */ = {{isa = PBXFileReference; lastKnownFileType = text.plist.xml; path = Info.plist; sourceTree = "<group>"; }};
\t\t{test_product_ref_uuid} /* rclawUITests.xctest */ = {{isa = PBXFileReference; explicitFileType = wrapper.cfbundle; includeInIndex = 0; path = rclawUITests.xctest; sourceTree = BUILT_PRODUCTS_DIR; }};
/* End PBXFileReference section */'''
        content = content.replace('/* End PBXFileReference section */', new_file_refs)

    # Add group
    groups_section = re.search(r'/\* End PBXGroup section \*/', content)
    if groups_section:
        new_group = f'''\t\t{test_group_uuid} /* rclawUITests */ = {{
\t\t\tisa = PBXGroup;
\t\t\tchildren = (
\t\t\t\t{test_file_ref_uuid} /* rclawUITests.swift */,
\t\t\t\t{test_info_plist_uuid} /* Info.plist */,
\t\t\t);
\t\t\tpath = rclawUITests;
\t\t\tsourceTree = "<group>";
\t\t}};
/* End PBXGroup section */'''
        content = content.replace('/* End PBXGroup section */', new_group)

    # Add native target
    targets_section = re.search(r'/\* End PBXNativeTarget section \*/', content)
    if targets_section:
        new_target = f'''\t\t{test_target_uuid} /* rclawUITests */ = {{
\t\t\tisa = PBXNativeTarget;
\t\t\tbuildConfigurationList = {config_list_uuid} /* Build configuration list for PBXNativeTarget "rclawUITests" */;
\t\t\tbuildPhases = (
\t\t\t\t{test_sources_phase_uuid} /* Sources */,
\t\t\t\t{test_frameworks_phase_uuid} /* Frameworks */,
\t\t\t\t{test_resources_phase_uuid} /* Resources */,
\t\t\t);
\t\t\tbuildRules = (
\t\t\t);
\t\t\tdependencies = (
\t\t\t\t{test_dependency_uuid} /* PBXTargetDependency */,
\t\t\t);
\t\t\tname = rclawUITests;
\t\t\tproductName = rclawUITests;
\t\t\tproductReference = {test_product_ref_uuid} /* rclawUITests.xctest */;
\t\t\tproductType = "com.apple.product-type.bundle.ui-testing";
\t\t}};
/* End PBXNativeTarget section */'''
        content = content.replace('/* End PBXNativeTarget section */', new_target)

    # Add build phases
    sources_phase_section = re.search(r'/\* End PBXSourcesBuildPhase section \*/', content)
    if sources_phase_section:
        new_sources_phase = f'''\t\t{test_sources_phase_uuid} /* Sources */ = {{
\t\t\tisa = PBXSourcesBuildPhase;
\t\t\tbuildActionMask = 2147483647;
\t\t\tfiles = (
\t\t\t\t{test_build_file_uuid} /* rclawUITests.swift in Sources */,
\t\t\t);
\t\t\trunOnlyForDeploymentPostprocessing = 0;
\t\t}};
/* End PBXSourcesBuildPhase section */'''
        content = content.replace('/* End PBXSourcesBuildPhase section */', new_sources_phase)

    frameworks_phase_section = re.search(r'/\* End PBXFrameworksBuildPhase section \*/', content)
    if frameworks_phase_section:
        new_frameworks_phase = f'''\t\t{test_frameworks_phase_uuid} /* Frameworks */ = {{
\t\t\tisa = PBXFrameworksBuildPhase;
\t\t\tbuildActionMask = 2147483647;
\t\t\tfiles = (
\t\t\t);
\t\t\trunOnlyForDeploymentPostprocessing = 0;
\t\t}};
/* End PBXFrameworksBuildPhase section */'''
        content = content.replace('/* End PBXFrameworksBuildPhase section */', new_frameworks_phase)

    resources_phase_section = re.search(r'/\* End PBXResourcesBuildPhase section \*/', content)
    if resources_phase_section:
        new_resources_phase = f'''\t\t{test_resources_phase_uuid} /* Resources */ = {{
\t\t\tisa = PBXResourcesBuildPhase;
\t\t\tbuildActionMask = 2147483647;
\t\t\tfiles = (
\t\t\t);
\t\t\trunOnlyForDeploymentPostprocessing = 0;
\t\t}};
/* End PBXResourcesBuildPhase section */'''
        content = content.replace('/* End PBXResourcesBuildPhase section */', new_resources_phase)

    # Add target dependency
    target_deps_match = re.search(r'/\* End PBXTargetDependency section \*/', content)
    if target_deps_match:
        new_deps = f'''\t\t{test_dependency_uuid} /* PBXTargetDependency */ = {{
\t\t\tisa = PBXTargetDependency;
\t\t\ttarget = {main_target_uuid} /* rclaw */;
\t\t\ttargetProxy = {test_container_item_proxy_uuid} /* PBXContainerItemProxy */;
\t\t}};
/* End PBXTargetDependency section */'''
        content = content.replace('/* End PBXTargetDependency section */', new_deps)
    else:
        # Section doesn't exist, create it
        native_target_end = re.search(r'(/\* End PBXNativeTarget section \*/)', content)
        if native_target_end:
            new_section = f'''/* End PBXNativeTarget section */

/* Begin PBXTargetDependency section */
\t\t{test_dependency_uuid} /* PBXTargetDependency */ = {{
\t\t\tisa = PBXTargetDependency;
\t\t\ttarget = {main_target_uuid} /* rclaw */;
\t\t\ttargetProxy = {test_container_item_proxy_uuid} /* PBXContainerItemProxy */;
\t\t}};
/* End PBXTargetDependency section */'''
            content = content.replace('/* End PBXNativeTarget section */', new_section)

    # Add container item proxy
    proxy_match = re.search(r'/\* End PBXContainerItemProxy section \*/', content)
    if proxy_match:
        new_proxy = f'''\t\t{test_container_item_proxy_uuid} /* PBXContainerItemProxy */ = {{
\t\t\tisa = PBXContainerItemProxy;
\t\t\tcontainerPortal = A1000023000000000000001 /* Project object */;
\t\t\tproxyType = 1;
\t\t\tremoteGlobalIDString = {main_target_uuid};
\t\t\tremoteInfo = rclaw;
\t\t}};
/* End PBXContainerItemProxy section */'''
        content = content.replace('/* End PBXContainerItemProxy section */', new_proxy)
    else:
        # Create the section
        buildfile_end = re.search(r'(/\* End PBXBuildFile section \*/)', content)
        if buildfile_end:
            new_section = f'''/* End PBXBuildFile section */

/* Begin PBXContainerItemProxy section */
\t\t{test_container_item_proxy_uuid} /* PBXContainerItemProxy */ = {{
\t\t\tisa = PBXContainerItemProxy;
\t\t\tcontainerPortal = A1000023000000000000001 /* Project object */;
\t\t\tproxyType = 1;
\t\t\tremoteGlobalIDString = {main_target_uuid};
\t\t\tremoteInfo = rclaw;
\t\t}};
/* End PBXContainerItemProxy section */'''
            content = content.replace('/* End PBXBuildFile section */', new_section)

    # Add build configurations
    config_section = re.search(r'/\* End XCBuildConfiguration section \*/', content)
    if config_section:
        new_configs = f'''\t\t{debug_config_uuid} /* Debug */ = {{
\t\t\tisa = XCBuildConfiguration;
\t\t\tbuildSettings = {{
\t\t\t\tCODE_SIGN_STYLE = Automatic;
\t\t\t\tCURRENT_PROJECT_VERSION = 1;
\t\t\t\tGENERATE_INFOPLIST_FILE = YES;
\t\t\t\tMARKETING_VERSION = 1.0;
\t\t\t\tPRODUCT_BUNDLE_IDENTIFIER = com.rclaw.app.uitests;
\t\t\t\tPRODUCT_NAME = "$(TARGET_NAME)";
\t\t\t\tSWIFT_EMIT_LOC_STRINGS = NO;
\t\t\t\tSWIFT_VERSION = 5.0;
\t\t\t\tTARGETED_DEVICE_FAMILY = "1,2";
\t\t\t\tTEST_TARGET_NAME = rclaw;
\t\t\t}};
\t\t\tname = Debug;
\t\t}};
\t\t{release_config_uuid} /* Release */ = {{
\t\t\tisa = XCBuildConfiguration;
\t\t\tbuildSettings = {{
\t\t\t\tCODE_SIGN_STYLE = Automatic;
\t\t\t\tCURRENT_PROJECT_VERSION = 1;
\t\t\t\tGENERATE_INFOPLIST_FILE = YES;
\t\t\t\tMARKETING_VERSION = 1.0;
\t\t\t\tPRODUCT_BUNDLE_IDENTIFIER = com.rclaw.app.uitests;
\t\t\t\tPRODUCT_NAME = "$(TARGET_NAME)";
\t\t\t\tSWIFT_EMIT_LOC_STRINGS = NO;
\t\t\t\tSWIFT_VERSION = 5.0;
\t\t\t\tTARGETED_DEVICE_FAMILY = "1,2";
\t\t\t\tTEST_TARGET_NAME = rclaw;
\t\t\t}};
\t\t\tname = Release;
\t\t}};
/* End XCBuildConfiguration section */'''
        content = content.replace('/* End XCBuildConfiguration section */', new_configs)

    # Add configuration list
    config_list_section = re.search(r'/\* End XCConfigurationList section \*/', content)
    if config_list_section:
        new_config_list = f'''\t\t{config_list_uuid} /* Build configuration list for PBXNativeTarget "rclawUITests" */ = {{
\t\t\tisa = XCConfigurationList;
\t\t\tbuildConfigurations = (
\t\t\t\t{debug_config_uuid} /* Debug */,
\t\t\t\t{release_config_uuid} /* Release */,
\t\t\t);
\t\t\tdefaultConfigurationIsVisible = 0;
\t\t\tdefaultConfigurationName = Release;
\t\t}};
/* End XCConfigurationList section */'''
        content = content.replace('/* End XCConfigurationList section */', new_config_list)

    # Add test target to project targets list
    targets_pattern = r'(targets = \(\s+A1000019000000000000001 /\* rclaw \*/,\s+\);)'
    new_targets = f'targets = (\n\t\t\t\tA1000019000000000000001 /* rclaw */,\n\t\t\t\t{test_target_uuid} /* rclawUITests */,\n\t\t\t);'
    content = re.sub(targets_pattern, new_targets, content)

    # Add test group to main group
    # Find the main group children
    main_group_pattern = r'(A1000015000000000000001 = \{\s+isa = PBXGroup;\s+children = \([^)]+)'
    def add_test_group(match):
        return match.group(1) + f'\n\t\t\t\t{test_group_uuid} /* rclawUITests */,'
    content = re.sub(main_group_pattern, add_test_group, content)

    # Add test product to products group
    products_pattern = r'(A1000017000000000000001 /\* Products \*/ = \{\s+isa = PBXGroup;\s+children = \([^)]+)'
    def add_test_product(match):
        return match.group(1) + f'\n\t\t\t\t{test_product_ref_uuid} /* rclawUITests.xctest */,'
    content = re.sub(products_pattern, add_test_product, content)

    # Write back
    with open(project_file, 'w') as f:
        f.write(content)

    print("✅ Added UI Tests target to project")
    print(f"   Test Target UUID: {test_target_uuid}")
    print(f"   Test File UUID: {test_file_ref_uuid}")

if __name__ == '__main__':
    main()
