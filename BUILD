cc_import(
    name = 'libjsoncpp',
    hdrs = glob([
        '3rdlib/jsoncpp/include/**/*.h',
        ]),
    static_library = '3rdlib/jsoncpp/lib/libjsoncpp.a',
)

cc_library(
    name = 'cppcompiletemplate_comm',
    srcs = glob([
        '*.cpp',
        '*.cc',
        #'*.c',  # 如果打开了-Werror，就会报错:c不支持--std=c++11参数。所以.c最好是extern 'C'导出成lib库
        '*.hpp',
    ],
    exclude = ['main.cpp'],
    ),
    hdrs = glob(['*.h']),
    includes =['.'],
    deps = [
        #':libjsoncpp',
    ],
    copts = [
        '-W',
        '-Wall',
        '-Werror',
        '--std=c++11',
    ],
    linkopts = [
        '-pthread',
    ]
)

cc_binary(
    name = 'cppcompiletemplate',
    srcs = ['main.cpp'],
    includes =['.'],
    deps = [
        ':cppcompiletemplate_comm',
    ],
    copts = [
        '-W',
        '-Wall',
        '-Werror',
        '--std=c++11',
    ],
    linkopts = []
)
