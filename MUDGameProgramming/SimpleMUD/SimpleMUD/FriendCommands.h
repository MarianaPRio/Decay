#ifndef FRIEND_COMMANDS_H
#define FRIEND_COMMANDS_H

#include <string>
#include "Player.h"
#include "FriendManager.h"

namespace SimpleMUD {

class FriendCommands {
public:
    FriendCommands(FriendManager& fm) : m_friendManager(fm) {}

    void Handle(Player* player, const std::string& input);

private:
    FriendManager& m_friendManager;

    void CmdAddFriend(Player* player, const std::string& targetName);
    void CmdAcceptFriend(Player* player, const std::string& targetName);
    void CmdRemoveFriend(Player* player, const std::string& targetName);
    void CmdListFriends(Player* player);
};

} // namespace SimpleMUD

#endif
