#!/bin/bash

# Отримуємо шлях до цього скрипта
script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Шлях до виконуючого файлу Blender (потрібно вказати правильний шлях)
blender_executable="/usr/bin/blender"

# Ім'я вихідного файлу
output_file="$script_dir/merged.obj"

# Створюємо Python-скрипт для об'єднання
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

# Виконуємо Blender з нашим скриптом Python
"$blender_executable" -b -P "$merge_script"

# Видаляємо створений скрипт Python
rm "$merge_script"

echo "Об'єднання завершено. Результат збережено у файлі $output_file"

