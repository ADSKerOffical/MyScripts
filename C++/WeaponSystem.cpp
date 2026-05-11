#include <iostream>
#include <string>

class Entity {
    public:
       std::string name = "Entity";
       int health = 100;
       int walkspeed = 16;
       bool isAlive = true;
       bool canDie = true;
};

class Weapon {
    public:
       std::string name;
       int damage;
       
       void makeDamage(Entity* clas) {
           clas -> health -= this -> damage;
           if (clas -> health <= 0 and clas -> canDie == true) {
               clas -> isAlive = false;
               clas -> health = 0;
           }
       }
};

int main() {
    Weapon ak47;
    ak47.name = "AK47";
    ak47.damage = 30;
    
    Entity adsker;
    adsker.name = "ADSKer";
    adsker.health = 1000; 
    adsker.canDie = false;
    ak47.makeDamage(&adsker);
    std::cout << adsker.health; // 970
}
