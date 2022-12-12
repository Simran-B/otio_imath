#include <OpenEXR/ImfHeader.h>
#include <iostream>

int main() {
    Imf::Header header(640, 480);
    std::cout << "Testing Imf::Header constructor: " << header.dataWindow().size() << std::endl;
    return 0;
}
