$(shell if [ ! -d sbin ]; then mkdir sbin; fi;)
TAR := ./sbin/cppcompiletemplate
CXX := g++ # -m32 -m64

#SOURCES := $(patsubst %.cpp,%.o,$(wildcard *.cpp)) # 逐一单独把cpp替换成.o；%:任意长度的字符串
SOURCES :=$(wildcard *.cpp) $(wildcard *.c) $(wildcard *.hpp) $(wildcard *.cc)
AllDirs := $(shell ls -R | grep '^\./.*:$$' | awk '{gsub(":","");print}' | grep -vE 'cmakebuild|sbin')
$(info AllDirs: $(AllDirs))
SOURCES += $(foreach subdir,$(AllDirs),$(wildcard $(subdir)/*.cpp) $(wildcard $(subdir)/*.c)) # 遍历子目录

# -w 关闭编译时的警告，最好不要用；
# -W 相当于-Wextra，是对-Wall的补充；
# -Werror 使所有的警告进入错误；
# -Werror= 将指定的警告转换为错误，简写为 -Wxxx ;
# -Wno-error= 开关使得指定警告不是错误，即使在-Werror有效时也是如此，简写为 -Wno-xxx ;
# -Wfatal-errors 此选项会导致编译器在发生第一个错误时中止编译，而不是尝试继续并打印更多错误消息。
# -fno-diagnostics-show-option 标志禁用警告消息中的选项打印，设置这项就不会告诉你哪个编译告警了。
# -fpermissive 禁用类型转换错误告警，从错误级别降为了警告，与-Werror互斥。
COPTION := -W -Wall -Wfatal-errors -fpermissive # -Werror -Wshadow -Wdouble-promotion -fno-common -Wconversion
#COPTION += -Wno-unused-function -Wno-error=missing-field-initializers

CFLAGS := -pthread -std=c++11 $(COPTION)
CFLAGS_DEBUG := -g -O0
CFLAGS_RELEASE := -s -O2 -static-libstdc++ -static-libgcc # -static



###############################################################################################################

DEFS := #-DNDEBUG
CFLAGS += # -pg
INC := # -I ./3rdlib/jsoncpp/include
LIB := # ./3rdlib/jsoncpp/lib/libjsoncpp.a
LFLAGS := -pthread #-lrt -ldl

###############################################################################################################



all: $(TAR)
debug: $(TAR)

$(TAR): $(SOURCES)
	@echo -e =====================DEBUG=========================
	$(CXX) $(DEFS) $(CFLAGS) $(CFLAGS_DEBUG) -o $(TAR) $(SOURCES) $(INC) $(LIB) $(LFLAGS)

release: $(SOURCES)
	@echo -e =====================RELEASE=======================
	$(CXX) $(DEFS) $(CFLAGS) $(CFLAGS_RELEASE) -o $(TAR) $(SOURCES) $(INC) $(LIB) $(LFLAGS)

%.o: %.cpp
	@echo -e ======================COMPLING====================
	@echo Compling $< "->" $@
	@echo -e ==================================================
	$(CXX) $(CFLAGS) -c $*.cpp $(INC)

clean: 
	rm -f *.o
	rm -f $(TAR)
