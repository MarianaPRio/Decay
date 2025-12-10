CREATE TABLE IF NOT EXISTS Friendship (
    playerId BIGINT NOT NULL,
    friendId BIGINT NOT NULL,
    createdAt TIMESTAMP DEFAULT now(),
    CONSTRAINT Friendship_Player_FK FOREIGN KEY(playerId) REFERENCES Player(id),
    CONSTRAINT Friendship_Friend_FK FOREIGN KEY(friendId) REFERENCES Player(id),
    CONSTRAINT Friendship_UQ UNIQUE (playerId, friendId)
);

CREATE TABLE IF NOT EXISTS Party (
    id BIGSERIAL PRIMARY KEY,
    name TEXT,
    createdBy BIGINT NOT NULL,
    createdAt TIMESTAMP DEFAULT now(),
    CONSTRAINT Party_Player_FK FOREIGN KEY(createdBy) REFERENCES Player(id)
);

CREATE TABLE IF NOT EXISTS PartyMember (
    partyId BIGINT NOT NULL,
    playerId BIGINT NOT NULL,
    joinedAt TIMESTAMP DEFAULT now(),
    CONSTRAINT PartyMember_Party_FK FOREIGN KEY(partyId) REFERENCES Party(id),
    CONSTRAINT PartyMember_Player_FK FOREIGN KEY(playerId) REFERENCES Player(id),
    CONSTRAINT PartyMember_UQ UNIQUE (partyId, playerId)
);
