#ifndef FRIEND_MANAGER_H
#define FRIEND_MANAGER_H

#include <unordered_map>
#include <unordered_set>
#include <string>
#include <memory>
#include <vector>
#include <pqxx/pqxx>

namespace SimpleMUD {

class Player;

class FriendManager {
public:
    // Envia pedido de amizade
    void AddFriendRequest(Player* sender, Player* target);

    // Aceita amizade
    void AcceptFriend(Player* player, Player* requester);

    // Remove amizade
    void RemoveFriend(Player* player, Player* target);

    // Retorna lista de amigos (IDs ou ponteiros)
    std::unordered_set<int> GetFriends(int playerId);

    // Mostra pedidos pendentes
    std::unordered_set<int> GetPendingRequests(int playerId);

    // --- Persistência no banco ---
    void AddFriendshipToDB(int playerId, int friendId);
    std::vector<int> LoadFriendsFromDB(int playerId);

    // Construtor recebe conexão com o banco
    FriendManager() : m_conn(nullptr) {}   // construtor padrão
    FriendManager(std::shared_ptr<pqxx::connection> conn)
        : m_conn(conn) {}

private:
    // Amizades confirmadas
    std::unordered_map<int, std::unordered_set<int>> friendships;

    // Pedidos pendentes (player -> alvos)
    std::unordered_map<int, std::unordered_set<int>> pending;

    // Conexão com PostgreSQL
    std::shared_ptr<pqxx::connection> m_conn;
};

} // namespace SimpleMUD

#endif
