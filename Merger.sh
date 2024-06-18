#!/bin/bash

# Get the path to this script
script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Path to the Blender executable file ( y o u  m u s t   s p e c i f y   t h e   c o r r e c t   p a t h  ! ! !)
blender_executable="/usr/bin/blender"

# Output file name
output_file="$script_dir/merged.obj"

# Create a Python script for merging
merge_script="$script_dir/merge_objects.py"
echo "import bpy" > "$merge_script"
echo "import os" >> "$merge_script"
echo "import glob" >> "$merge_script"
echo "input_folder = '$script_dir'" >> "$merge_script"
echo "output_file = '$output_file'" >> "$merge_script"
echo "files = glob.glob(os.path.join(input_folder, '*.obj'))" >> "$merge_script"
echo "for obj_file in files:" >> "$merge_script"
echo "    bpy.ops.import_scene.obj(filepath=obj_file, filter_glob='*.obj;*.mtl', use_split_groups=False)" >> "$merge_script"
echo "bpy.ops.object.select_all(action='SELECT')" >> "$merge_script"
echo "bpy.ops.object.join()" >> "$merge_script"
echo "bpy.ops.export_scene.obj(filepath=output_file)" >> "$merge_script"

# Running Blender with our Python script
"$blender_executable" -b -P "$merge_script"

# Delete the created Python script
rm "$merge_script"

echo "The merge is complete. The result is saved in the file $output_file"

