import os

from conans import ConanFile, CMake, tools


class ConsumerRegular(ConanFile):
    settings = "os", "compiler", "build_type", "arch"
    generators = "cmake"
    name = "consumer_regular"
    version = "1.0"
    exports = "CMakeLists.txt", "example.cpp"
    requires = "libR/1.0"

    def build(self):
        print("|-----------------------------------------|")
        print("|-------------   BUILDING   --------------|")
        print("|----------   consumer regular  ----------|")
        print("|-----------------------------------------|")      
        cmake = CMake(self)
        # Current dir is "test_package/build/<build_id>" and CMakeLists.txt is
        # in "test_package"
        cmake.configure()
        cmake.build()
        if not tools.cross_building(self):
            os.chdir("bin")
            self.run(".%sexample" % os.sep)

    def imports(self):
        self.copy("*.dll", dst="bin", src="bin")
        self.copy("*.dylib*", dst="bin", src="lib")
        self.copy('*.so*', dst='bin', src='lib')
