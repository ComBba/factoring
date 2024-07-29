#ifndef CPUID_H
#define CPUID_H

#ifdef _WIN32
#include <limits.h>
#include <intrin.h>
typedef unsigned __int32  uint32_t;

#else
#include <stdint.h>
#include <array>
#include <string>
#include <iostream>
#include <stdexcept>
#include <cstdio>
#include <memory>
#include <array>

#ifdef __APPLE__
std::string exec(const char* cmd) {
    std::array<char, 128> buffer;
    std::string result;
    std::unique_ptr<FILE, decltype(&pclose)> pipe(popen(cmd, "r"), pclose);
    if (!pipe) {
        throw std::runtime_error("popen() failed!");
    }
    while (fgets(buffer.data(), buffer.size(), pipe.get()) != nullptr) {
        result += buffer.data();
    }
    return result;
}

std::string get_vendor() {
    std::string vendor = exec("sysctl -n machdep.cpu.brand_string");
    return vendor;
}
#endif

#endif

class CPUID {
  uint32_t regs[4];

public:
  explicit CPUID(unsigned i) {
#if defined(_WIN32)
    __cpuid((int *)regs, (int)i);
#elif defined(__x86_64__) || defined(_M_X64) || defined(__i386) || defined(_M_IX86)
    asm volatile
      ("cpuid" : "=a" (regs[0]), "=b" (regs[1]), "=c" (regs[2]), "=d" (regs[3])
       : "a" (i), "c" (0));
    // ECX is set to zero for CPUID function 4
#elif defined(__APPLE__) && defined(__arm64__)
    std::string vendor = get_vendor();
    std::copy(vendor.begin(), vendor.end(), reinterpret_cast<char*>(regs));
    regs[vendor.size()] = 0;
#else
    regs[0] = regs[1] = regs[2] = regs[3] = 0; // ARM 또는 기타 아키텍처의 경우 0으로 초기화
#endif
  }

  const uint32_t &EAX() const { return regs[0]; }
  const uint32_t &EBX() const { return regs[1]; }
  const uint32_t &ECX() const { return regs[2]; }
  const uint32_t &EDX() const { return regs[3]; }
  
  std::string vendor() const {
#if defined(__APPLE__) && defined(__arm64__)
    return std::string(reinterpret_cast<const char*>(regs));
#else
    char vendor[13];
    memcpy(vendor, &regs[1], 4);
    memcpy(vendor + 4, &regs[3], 4);
    memcpy(vendor + 8, &regs[2], 4);
    vendor[12] = '\0';
    return std::string(vendor);
#endif
  }
};

#endif // CPUID_H
