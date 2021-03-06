from conans import ConanFile, CMake


class LibXConan(ConanFile):
    name = "libX"
    license = "<Put the package license here>"
    author = "<Put your name here> <And your email here>"
    url = "<Package recipe repository url here, for issues about the package>"
    description = "<Description of LibX here>"
    topics = ("<Put some tag here>", "<here>", "<and here>")
    settings = "os", "compiler", "build_type", "arch"
    options = {"shared": [True, False]}
    default_options = {"shared": False}
    generators = "cmake"
    exports_sources = "src/*"

    def build(self):
        print("|-----------------------------------------|")
        print("|-------------   BUILDING   --------------|")
        print("|---------------   libX   ----------------|")
        print("|-----------------------------------------|")      
        cmake = CMake(self)
        cmake.configure(source_folder="src")
        cmake.build()

    def package(self):
        self.copy("*.h", dst="include", src="src")
        self.copy("*.lib", dst="lib", keep_path=False)
        self.copy("*.dll", dst="bin", keep_path=False)
        self.copy("*.dylib*", dst="lib", keep_path=False)
        self.copy("*.so", dst="lib", keep_path=False)
        self.copy("*.a", dst="lib", keep_path=False)

    def package_info(self):
        self.cpp_info.libs = ["hello"]


# new revision# new revision
# new revision
# new revision
# new revision
# new revision
# new revision
# new revision
# new revision
# new revision
# new revision
# new revision
# new revision
# new revision
# new revision
# new revision
# new revision
# new revision
# new revision
# new revision
# new revision
# new revision
# new revision
# new revision
# new revision
# new revision
# new revision
# new revision
# new revision
# new revision
# new revision
# new revision
# new revision
# new revision
# new revision
# new revision
# new revision
# new revision
# new revision
# new revision
# new revision
# new revision
# new revision
# new revision
# new revision
# new revision
# new revision
# new revision
# new revision
# new revision
# new revision
# new revision
# new revision
# new revision
# new revision
# new revision
# new revision
# new revision
# new revision
# new revision
# new revision
# new revision
# new revision
# new revision
# new revision
# new revision
# new revision
# new revision
# new revision
# new revision
# new revision
# new revision
# new revision
# new revision
# new revision
# new revision
# new revision
# new revision
# new revision
# new revision
# new revision
# new revision
# new revision
# new revision
# new revision
# new revision
# new revision
# new revision
# new revision
# new revision
# new revision
# new revision
