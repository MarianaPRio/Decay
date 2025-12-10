#ifndef SIMPLEMUD_TUTORIALTRAIN_H
#define SIMPLEMUD_TUTORIALTRAIN_H

#include "PlayerDatabase.h"
#include "SocketLib/SocketLib.h"
#include <string>

using SocketLib::Connection;
using SocketLib::Telnet;
using std::string;

namespace SimpleMUD {

class TutorialTrain : public Telnet::handler{

    typedef Telnet::handler thandler;

public:
    TutorialTrain(Connection<Telnet> &p_conn, player p_player)
         : thandler(p_conn), m_player(p_player) {}

    void Enter();
    void Handle(std::string p_data);
    void PrintStats(bool p_clear);
    void PrintTutorial();

    void Leave() {}
    void Hungup() { PlayerDatabase::GetInstance().Logout(m_player); }
    void Flooded() { PlayerDatabase::GetInstance().Logout(m_player); }


    protected:
    player m_player;
};

}

#endif
