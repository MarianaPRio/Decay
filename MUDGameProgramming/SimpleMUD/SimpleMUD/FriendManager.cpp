#include "FriendManager.h"
#include "Player.h"
#include <iostream>

namespace SimpleMUD {

// --------------------
// Amizades em memória
// --------------------
void FriendManager::AddFriendRequest(Player* sender, Player* target) {
    if (!sender || !target) return;
    pending[sender->ID()].insert(target->ID());
    std::cout << "Pedido de amizade enviado de "
              << sender->ID() << " para " << target->ID() << std::endl;
}

void FriendManager::AcceptFriend(Player* player, Player* requester) {
    if (!player || !requester) return;
    int pid = player->ID();
    int rid = requester->ID();

    // Verifica se tinha pedido pendente
    if (pending[rid].erase(pid)) {
        friendships[pid].insert(rid);
        friendships[rid].insert(pid);
        std::cout << "Amizade confirmada entre " << pid << " e " << rid << std::endl;

        // Também salva no banco
        AddFriendshipToDB(pid, rid);
    }
}

void FriendManager::RemoveFriend(Player* player, Player* target) {
    if (!player || !target) return;
    int pid = player->ID();
    int tid = target->ID();

    friendships[pid].erase(tid);
    friendships[tid].erase(pid);

    try {
        pqxx::work txn(*m_conn);
        txn.exec_params("DELETE FROM Friendship WHERE playerId = $1 AND friendId = $2",
                        pid, tid);
        txn.exec_params("DELETE FROM Friendship WHERE playerId = $1 AND friendId = $2",
                        tid, pid);
        txn.commit();
    } catch (const std::exception& e) {
        std::cerr << "Erro ao remover amizade: " << e.what() << std::endl;
    }
}

std::unordered_set<int> FriendManager::GetFriends(int playerId) {
    return friendships[playerId];
}

std::unordered_set<int> FriendManager::GetPendingRequests(int playerId) {
    return pending[playerId];
}

// --------------------
// Persistência no DB
// --------------------
void FriendManager::AddFriendshipToDB(int playerId, int friendId) {
    try {
        pqxx::work txn(*m_conn);
        txn.exec_params(
            "INSERT INTO Friendship (playerId, friendId) VALUES ($1, $2) "
            "ON CONFLICT DO NOTHING",
            playerId, friendId
        );
        txn.exec_params(
            "INSERT INTO Friendship (playerId, friendId) VALUES ($1, $2) "
            "ON CONFLICT DO NOTHING",
            friendId, playerId
        );
        txn.commit();
    } catch (const std::exception& e) {
        std::cerr << "Erro ao salvar amizade: " << e.what() << std::endl;
    }
}

std::vector<int> FriendManager::LoadFriendsFromDB(int playerId) {
    std::vector<int> result;
    try {
        pqxx::work txn(*m_conn);
        pqxx::result r = txn.exec_params(
            "SELECT friendId FROM Friendship WHERE playerId = $1",
            playerId
        );
        for (auto row : r) {
            result.push_back(row[0].as<int>());
        }
    } catch (const std::exception& e) {
        std::cerr << "Erro ao carregar amigos: " << e.what() << std::endl;
    }
    return result;
}

} // namespace SimpleMUD
