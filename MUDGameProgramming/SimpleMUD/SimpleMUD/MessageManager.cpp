#include "MessageManager.h"
#include "Player.h"
#include <iostream>

namespace SimpleMUD {

void MessageManager::SendPrivateMessage(Player* sender, Player* receiver,
                                        const std::string& message) {
    if (!sender || !receiver) return;
    receiver->SendString("[PM de " + sender->Name() + "]: " + message + "\n");
}

} // namespace SimpleMUD
