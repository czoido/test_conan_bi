from conans import ConanFile, CMake


class LibHoConan(ConanFile):
    name = "libHO"
    version = "1.0"
    generators = "cmake"
    exports_sources = "include/*", "CMakeLists.txt"

    def requirements(self):
        self.requires("libX/<VERSION>")

    def build(self):
        print("|-----------------------------------------|")
        print("|-------------   BUILDING   --------------|")
        print("|---------------   libHO  ----------------|")
        print("|-----------------------------------------|")      
        cmake = CMake(self)
        cmake.configure()
        cmake.build()
        cmake.install()

    def package_id(self):
        self.info.header_only()
