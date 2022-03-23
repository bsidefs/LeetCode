//
//  Concurrency.cpp
//  dsa
//
//  Created by Brian Tamsing on 3/19/22.
//

///
/// LC Concurrency problems.
///

///
/// "print in order"
///     - decided to play around and make a simple semaphore for this one
///     - the other problems just use sem_t
///
#include <mutex>
#include <condition_variable>

class Semaphore {
private:
    int value;
    std::mutex mtx;
    std::condition_variable cond;
public:
    Semaphore(int value) {
        this->value = value;
    }
    
    void acquire() {
        std::unique_lock<std::mutex> lck (mtx);
        while (value <= 0) {
            cond.wait(lck);
        }
        value--;
    }
    
    void release() {
        std::lock_guard<std::mutex> lck (mtx);
        value++;
        cond.notify_one();
    }
};

class Foo {
private:
    Semaphore sem_one;
    Semaphore sem_two;
public:
    Foo() : sem_one (0), sem_two (0) {}

    void first(function<void()> printFirst) {
        // printFirst() outputs "first". Do not change or remove this line.
        printFirst();
        
        sem_one.release();
    }

    void second(function<void()> printSecond) {
        sem_one.acquire();
        
        // printSecond() outputs "second". Do not change or remove this line.
        printSecond();
        
        sem_two.release();
    }

    void third(function<void()> printThird) {
        sem_two.acquire();
        
        // printThird() outputs "third". Do not change or remove this line.
        printThird();
    }
};

///
/// "print foobar alternately"
///
/// a simplistic producer/consumer problem
///
#include <semaphore.h>

class FooBar {
private:
    int n;
    sem_t start;
    sem_t finish;

public:
    FooBar(int n) {
        this->n = n;
        sem_init(&(this->start), 0, 1);
        sem_init(&(this->finish), 0, 0);
    }

    void foo(function<void()> printFoo) {
        for (int i = 0; i < n; i++) {
            sem_wait(&(this->start));
            // printFoo() outputs "foo". Do not change or remove this line.
            printFoo();
            sem_post(&(this->finish));
        }
    }

    void bar(function<void()> printBar) {
        for (int i = 0; i < n; i++) {
            sem_wait(&(this->finish));
            // printBar() outputs "bar". Do not change or remove this line.
            printBar();
            sem_post(&(this->start));
        }
    }
};

///
/// "the dining philosophers"
///
#include <semaphore.h>
#define PHIL_COUNT 5

class DiningPhilosophers {
private:
    sem_t forks[PHIL_COUNT];
    
    int left_fork_idx(int p) {
        return p;
    }
    
    int right_fork_idx(int p) {
        return (p + 1) % PHIL_COUNT;
    }
public:
    DiningPhilosophers() {
        for (int i = 0; i < PHIL_COUNT; i++) {
            sem_init(&(this->forks[i]), 0, 1);
        }
    }

    void wantsToEat(int philosopher,
                    function<void()> pickLeftFork,
                    function<void()> pickRightFork,
                    function<void()> eat,
                    function<void()> putLeftFork,
                    function<void()> putRightFork) {
        int left = left_fork_idx(philosopher);
        int right = right_fork_idx(philosopher);
        
        bool is_last_philosopher = philosopher == PHIL_COUNT - 1;
        
        if (is_last_philosopher) { // avoid deadlock by breaking the circular dependency (ex., grab the right fork before the left if last philosopher)
            sem_wait(&(forks[right]));
            sem_wait(&(forks[left]));
            
            pickRightFork();
            pickLeftFork();
        } else {
            sem_wait(&(forks[left]));
            sem_wait(&(forks[right]));
            
            pickLeftFork();
            pickRightFork();
        }
        
        eat();
        
        putLeftFork();
        putRightFork();
        sem_post(&(forks[left]));
        sem_post(&(forks[right]));
    }
};

///
/// "building h2o"
///
#include <mutex>
#include <condition_variable>

class H2O {
private:
    int num_oxy, num_hyd;
    std::mutex mtx;
    std::condition_variable cond;
    bool isAcceptingOxy, isAcceptingHyd;
    
    void allowNextMolecule() {
        if (num_oxy == 1 && num_hyd == 2) {
            num_oxy = 0;
            num_hyd = 0;
            isAcceptingOxy = true;
            isAcceptingHyd = true;
        }
    }
public:
    H2O() {
        this->num_oxy = 0;
        this->num_hyd = 0;
        this->isAcceptingOxy = true;
        this->isAcceptingHyd = true;
    }

    void hydrogen(function<void()> releaseHydrogen) { // called upon barrier arrival
        std::unique_lock<std::mutex> lck (mtx);
        
        while (!isAcceptingHyd) {
            cond.wait(lck);
        }
        
        num_hyd++;
        if (num_hyd == 2) {
            isAcceptingHyd = false;
        }
        
        releaseHydrogen();
        allowNextMolecule();
        
        cond.notify_all();
    }

    void oxygen(function<void()> releaseOxygen) {
        std::unique_lock<std::mutex> lck (mtx);
        
        while (!isAcceptingOxy) {
            cond.wait(lck);
        }
        
        num_oxy++;
        if (num_oxy == 1) { // for consistency with hydrogen(). technically we can get away w/o tracking num_oxy
            isAcceptingOxy = false;
        }
        
        releaseOxygen();
        allowNextMolecule();
        
        cond.notify_all();
    }
};
