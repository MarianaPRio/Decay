#ifndef PLAYERCLASS_H
#define PLAYERCLASS_H

#include <string>

namespace SimpleMUD {

// Definição das classes
enum PlayerClass {
    CLASS_DESTRUIR = 0,
    CLASS_RESTAURAR = 1,
    CLASS_INFILTRAR = 2,
    CLASS_NONE = 3
};

// Converte enum para string (útil para salvar no BD/logs)
inline std::string ToString(PlayerClass c) {
    switch (c) {
        case CLASS_DESTRUIR:  return "DESTRUIR";
        case CLASS_RESTAURAR: return "RESTAURAR";
        case CLASS_INFILTRAR: return "INFILTRAR";
        default:        return "NONE";
    }
}

// Converte string para enum (útil ao carregar do BD)
inline PlayerClass FromString(const std::string& s) {
    if (s == "DESTRUIR" || s == "destruir" || s == "1")  return CLASS_DESTRUIR;
    if (s == "RESTAURAR" || s == "restaurar" || s == "2") return CLASS_RESTAURAR;
    if (s == "INFILTRAR" || s == "infiltrar" || s == "3") return CLASS_INFILTRAR;
    return CLASS_NONE;
}

} // namespace SimpleMUD

#endif
