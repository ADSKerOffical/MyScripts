#include <iostream>
#include <vector>
#include <thread>
#include <chrono>

void worker_function(int id, int delay_ms) { std::this_thread::sleep_for(std::chrono::milliseconds(delay_ms));
    
    std::cout << "Thread " << id << " finished after " << delay_ms << "ms delay.\n";
}

int main() {
    std::vector<std::thread> threads; // контейнер со всеми потоками

    for (int i = 1; i < 6; i++){
       threads.push_back(std::thread(worker_function, i, 250 * i)); // второй аргумент это айди потока (он обязательный)
    }

    // ждёт пока все потоки не будут выполнены
    for (auto& t : threads) {
        if (t.joinable()) {
            t.join();
        }
    }

    std::cout << "All threads have finished execution. Main program exiting.\n";
    return 0;
}
