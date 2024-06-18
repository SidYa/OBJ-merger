@echo off
chcp 65001 > nul
setlocal

REM Отримуємо шлях до папки, де знаходиться цей bat файл
set "script_dir=%~dp0"

REM Заміна зворотних слешів на подвійні для правильного оброблення в Python
set "escaped_script_dir=%script_dir:\=\\%"

REM Шлях до виконуючого файлу Blender (потрібно вказати правильний шлях)
set "blender_executable=C:\Program Files\Blender\blender.exe"

REM Шлях до скрипта Python та ім'я вихідного файлу
set "python_script=%script_dir%merge_objects.py"
set "output_file=%script_dir%merged.obj"

REM Створюємо Python-скрипт для об'єднання
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

REM Відображаємо вміст створеного Python-скрипта для відлагодження
type "%python_script%"

REM Виконуємо Blender з нашим скриптом Python і зберігаємо логи
"%blender_executable%" -b -P "%python_script%" > blender_log.txt 2>&1

REM Видаляємо створений скрипт Python
del "%python_script%"

echo Об'єднання завершено. Результат збережено у файлі %output_file%
pause

endlocal
