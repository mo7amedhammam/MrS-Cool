#import os
#import re
#
#def extract_strings_from_swift_files(directory):
#    strings = set()
#    pattern = re.compile(r'\"(.*?)\"\.localized\(\)')
#
#    for root, _, files in os.walk(directory):
#        for file in files:
#            if file.endswith(".swift"):
#                with open(os.path.join(root, file), "r", encoding="utf-8") as f:
#                    content = f.read()
#                    matches = pattern.findall(content)
#                    for match in matches:
#                        strings.add(match)
#
#    return strings
#
#def write_to_localizable(strings, output_file):
#    with open(output_file, "w", encoding="utf-8") as f:
#        for string in sorted(strings):
#            f.write(f'"{string}" = "{string}";\n')
#
#if __name__ == "__main__":
#    project_directory = "."  # Change this to your project directory if needed
#    output_file = "en.lproj/Localizable.strings"
#
#    strings = extract_strings_from_swift_files(project_directory)
#    os.makedirs(os.path.dirname(output_file), exist_ok=True)
#    write_to_localizable(strings, output_file)
#
#    print(f"Extracted {len(strings)} strings to {output_file}")




# // Enhanced Pytgon Code to Double Check

import os
import re

def extract_strings_from_swift_files(directory):
    strings = set()
    patterns = [
        re.compile(r'\"(.*?)\"\.localized\(\)'),
        re.compile(r'NSLocalizedString\(\s*\"(.*?)\"\s*,\s*comment:\s*\".*?\"\s*\)'),
        re.compile(r'\"(.*?)\"')  # Generic string pattern
    ]

    for root, _, files in os.walk(directory):
        for file in files:
            if file.endswith(".swift"):
                with open(os.path.join(root, file), "r", encoding="utf-8") as f:
                    content = f.read()
                    for pattern in patterns:
                        matches = pattern.findall(content)
                        for match in matches:
                            strings.add(match)

    return strings

def write_to_localizable(strings, output_file):
    with open(output_file, "w", encoding="utf-8") as f:
        for string in sorted(strings):
            f.write(f'"{string}" = "{string}";\n')

if __name__ == "__main__":
    project_directory = "."  # Change this to your project directory if needed
    output_file = "en.lproj/Localizable.strings"

    strings = extract_strings_from_swift_files(project_directory)
    os.makedirs(os.path.dirname(output_file), exist_ok=True)
    write_to_localizable(strings, output_file)

    print(f"Extracted {len(strings)} strings to {output_file}")



# // new script to get strings from view files only
#import os
#import re
#
#def extract_strings_from_swiftui_files(directory):
#    strings = []
#    swiftui_string_pattern = re.compile(r'Text\("([^"]*)"\)|TextField\("([^"]*)"\)|Button\("([^"]*)"\)')
#
#    for root, _, files in os.walk(directory):
#        for file in files:
#            if file.endswith('.swift'):
#                with open(os.path.join(root, file), 'r', encoding='utf-8') as f:
#                    content = f.read()
#                    matches = swiftui_string_pattern.findall(content)
#                    for match in matches:
#                        for s in match:
#                            if s:  # Only add non-empty strings
#                                strings.append(s)
#    
#    return strings
#
#def write_to_localizable(strings, output_file):
#    with open(output_file, "w", encoding="utf-8") as f:
#        for string in sorted(strings):
#            f.write(f'"{string}" = "{string}";\n')
#
#if __name__ == "__main__":
#    project_directory = "."  # Change this to your project directory if needed
#    output_file = "en.lproj/Localizable.strings"
#
#    strings = extract_strings_from_swiftui_files(project_directory)
#    os.makedirs(os.path.dirname(output_file), exist_ok=True)
#    write_to_localizable(strings, output_file)
#
#    print(f"Extracted {len(strings)} strings to {output_file}")


