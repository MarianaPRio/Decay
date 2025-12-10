#ifndef MESSAGE_COMMANDS_H
#define MESSAGE_COMMANDS_H

#include <string>
#include "Player.h"
#include "MessageManager.h"

namespace SimpleMUD {

class MessageCommands {
public:
    MessageCommands(MessageManager& mm) : m_messageManager(mm) {}

    void Handle(Player* player, const std::string& input);

private:
    MessageManager& m_messageManager;

    void CmdPrivateMessage(Player* player,
                           const std::string& targetName,
                           const std::string& message);
};

} // namespace SimpleMUD

#endif
