#include <builder.hpp>

build_config {
	auto lib = cpp::static_lib(
		"static_lib",
		io::files("test/lib", ".*.cpp"),
		listOf(io::FILE_LIST, {"."})
	);

	auto exe = cpp::exe(
		"test_main",
		io::files("main", ".*.cpp", ".*/build.cpp"),
		listOf(io::FILE_LIST, {}),
		{lib}
	);
}
