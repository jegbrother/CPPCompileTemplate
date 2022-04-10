# CPPCompileTemplate
c++编译模板，make、cmake、bazel最基本的编译模板

## Makefile使用方法
需要GNU make工具，使用g++编译c和c++
- 拷贝文件到工程根目录
- 执行make指令，会扫描当前目录与子目录下的所有c++源文件进行编译，注意：
- - 1、生成二进制文件在sbin目录下
- - 2、make与make debug等效，生成可调试的二进制
- - 3、make release是静态编译，生成二进制没有环境依赖，可以放到服务器中直接运行
- - 4、如果有不想参与编译的目录，参考模板修改
- - 5、windows上要自己创建&清理sbin目录

## CMakeLists.txt使用方法
需要cmake工具，使用g++编译c和c++
- 拷贝文件到工程根目录
- 创建cmakebuild子目录，并进入cmakebuild目录
- 生成Debug模式Makefile：cmake -DCMAKE_BUILD_TYPE=Debug ..
- 生成Release模式Makefile：cmake -DCMAKE_BUILD_TYPE=Release ..
- 执行make生成二进制，生成二进制文件在sbin目录下

## BUILD使用方法
需要bazel工具，推荐使用[bazelisk](https://github.com/bazelbuild/bazelisk)安装
- 拷贝文件到工程根目录
- 在仓库的根目录下创建一个WORKSPACE文件
- 执行bazel build :cppcompiletemplate生成二进制
- 生成的二进制在WORKSPACE文件所在目录下的bazel-out软链接的目录中
详细可参考[bazel官方文档](https://github.com/bazelbuild/bazel)
