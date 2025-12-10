#ifndef MESSAGE_MANAGER_H
#define MESSAGE_MANAGER_H

#include <string>
#include <memory>

namespace SimpleMUD {

class Player;

class MessageManager {
public:
    // Envia mensagem privada
    void SendPrivateMessage(Player* sender, Player* receiver, const std::string& msg);
};

} // namespace SimpleMUD

#endif
