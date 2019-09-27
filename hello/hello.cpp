#include "hello.h"

namespace HelloNamespace {

Hello::Hello(std::string s_)
: s(s_)
{
    std::cout << "Hello ctor" << std::endl;
}
    Hello::~Hello() {std::cout << "Hello dtor" << std::endl;}

    void Hello::get()
{std::cout<<s<<std::endl;}


}