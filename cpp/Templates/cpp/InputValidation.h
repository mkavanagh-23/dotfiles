#ifndef INPUT_VALIDATION_H
#define INPUT_VALIDATION_H

#include <ios>
#include <iostream>
#include <limits>
#include <string_view>

namespace InputValidation {

  //Returns true if extraction from cin failed
  inline bool fail() {
    return !std::cin;
  }

  //Clear the input buffer up to the new line character
  inline void clearBuffer() {
    std::cin.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
  }

  //Reset cin from fail state, display error message, and clear the input buffer
  inline void clearInvalid(std::string_view errMsg) {
    std::cin.clear();
    std::cout << errMsg;
    clearBuffer();
  }
}

#endif
