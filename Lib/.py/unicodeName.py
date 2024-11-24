import sys
import os
import unicodedata

def get_unicode_name(char):
    try:
        return unicodedata.name(char)
    except ValueError:
        return "Unknown character"

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python unicodeName.py <character> <output_directory>")
        sys.exit(1)
    
    char = sys.argv[1]
    output_dir = sys.argv[2]
    output_file = os.path.join(output_dir, "uniName.txt")

    if len(char) != 1:
        print("Please provide a single character.")
        sys.exit(1)

    unicode_name = get_unicode_name(char)

    try:
        if not os.path.exists(output_dir):
            print(f"Directory '{output_dir}' does not exist.")
            sys.exit(1)

        with open(output_file, 'w', encoding='utf-8') as f:
            f.write(unicode_name)
        print(f"Unicode name written to {output_file}")
    except Exception as e:
        print(f"Failed to write to file: {e}")
        sys.exit(1)
