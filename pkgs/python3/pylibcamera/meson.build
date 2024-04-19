# SPDX-License-Identifier: CC0-1.0

project('pylibcamera', 'c', 'cpp',
    meson_version : '>= 0.64',
    version : '0.1.0',
    default_options : [
        'werror=false',
        'warning_level=2',
        'cpp_std=c++17',
    ],
    license : 'LGPL 2.1+')

libcamera_includes = include_directories('libcamera/include')
libcamera_private = dependency(
    'libcamera', required : true,
    not_found_message : 'Requires libcamera-dev package to be installed - apt install libcamera-dev'
)

py = import('python').find_installation()

controls_files = [
    'control_ids_core.yaml',
    'control_ids_draft.yaml',
    'control_ids_rpi.yaml',
]

properties_files = [
    'property_ids_core.yaml',
    'property_ids_draft.yaml',
]

subdir('libcamera/src/py')

message('Using python version @0@ from @1@'.format(py.version(), py.full_path()))

py.install_sources(
    'libcamera/src/py/libcamera/__init__.py',
    subdir : 'libcamera',
    pure : false,
)

py.extension_module(
    '_libcamera',
    pycamera_sources,
    install : true,
    subdir : 'libcamera',
    dependencies : pycamera_deps,
    include_directories : libcamera_includes,
    cpp_args : pycamera_args,
)
