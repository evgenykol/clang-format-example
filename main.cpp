
#include "version.h"
#include "hello/hello.h"

using namespace HelloNamespace;

int main([[maybe_unused]]int argc, char** argv) {std::cout<<argv[0]<<" was just born, version: "<<int(PROJECT_VERSION_PATCH)<<std::endl;Hello h("Hello unformatted world");h.get();return 0;}
