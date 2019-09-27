#include <iostream>
#include <string>

namespace HelloNamespace {

class Hello
{
                                                                        public:
                                                                        Hello(std::string s_);
                                                                        ~Hello();

                                                                        void get();

private:
    std::string s;
};

}