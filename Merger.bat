@echo off
chcp 65001 > nul
setlocal

REM Get the path to the folder where this bat file is located
set "script_dir=%~dp0"

REM Replacing backslashes with double slashes for proper handling in Python
set "escaped_script_dir=%script_dir:\=\\%"

REM Path to the Blender executable file ( y o u   m u s t  s p e c i f y  t h e  c o r r e c t  p a t h!!!)
set "blender_executable=C:\Program Files\Blender\blender.exe"

REM Python script path and output file name
set "python_script=%script_dir%merge_objects.py"
set "output_file=%script_dir%merged.obj"

REM Create a Python script for merging
echo import bpy > "%python_script%"
echo import os >> "%python_script%"
echo import glob >> "%python_script%"
echo import addon_utils >> "%python_script%"
echo addon_utils.enable('io_scene_obj') >> "%python_script%"
echo input_folder = r'%escaped_script_dir%' >> "%python_script%"
echo output_file = r'%output_file%' >> "%python_script%"
echo files = glob.glob(os.path.join(input_folder, '*.obj')) >> "%python_script%"
echo for obj_file in files: >> "%python_script%"
echo.    bpy.ops.import_scene.obj(filepath=obj_file, filter_glob='*.obj;*.mtl', use_split_groups=False) >> "%python_script%"
echo bpy.ops.object.select_all(action='SELECT') >> "%python_script%"
echo bpy.ops.object.join() >> "%python_script%"
echo bpy.ops.export_scene.obj(filepath=output_file) >> "%python_script%"

REM Display the contents of the generated Python script for debugging
type "%python_script%"

REM Run Blender with our Python script and save the logs
"%blender_executable%" -b -P "%python_script%" > blender_log.txt 2>&1

REM Delete the created Python script
del "%python_script%"

echo The merge is complete. The result is saved in the file %output_file%
pause

endlocal
