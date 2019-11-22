//
// Created by root on 11/12/19.
//
#include <iostream>
#include <cstdio>
#include <ctime>
extern "C" int someFunction();

int anotherFunction(){
    int i = 5;
    return i;
}

using namespace std;
int main(){
    std::clock_t start, start2;
    double duration, duration2;

    start = std::clock();
    cout << "the result is: " << someFunction() << endl;
    duration = ( std::clock() - start ) / (double) CLOCKS_PER_SEC;
    std::cout << "time: " << duration << std::endl;
    start2 = std::clock();
    cout << "the result is: " << anotherFunction() << endl;
    duration2 = ( std::clock() - start2 ) / (double) CLOCKS_PER_SEC;
    std::cout << "time: " << duration2 << std::endl;
}
