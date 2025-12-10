\c unmud;
\set iuriPassword `echo "$IURI_PASSWORD"`
\set mauricioPassword `echo "$MAURICIO_PASSWORD"`

INSERT INTO Item (id, name, type, min, max, speed, price, attributes) VALUES
    (1, 'Diagnostic Knife', 'WEAPON', 1, 3, 1, 5,  ROW(0, 0, 0, 0, 10, 0, 0, 0, 0)),
    (2, 'Sync Jacket',      'ARMOR',  0, 0, 0, 25, ROW(0, 0, 0, 0, 0, 10, 0, 0, 0)),
    (3, 'Urban Debugger',   'WEAPON', 2, 6, 2, 30, ROW(0, 0, 0, 0, 12, 0, 1, 0, 0)),
    (4, 'Forest Cloak',     'ARMOR',  0, 0, 0, 180,ROW(0, 0, 2, 0, 0, 15, 0, 0, 0)),
    (5, 'Data Surge Potion','HEALING',15, 35, 0, 60,ROW(0, 0, 0, 0, 0, 0, 0, 0, 2)),
    (6, 'Abyssal Patch',    'HEALING',60, 120,0, 250,ROW(0, 0, 0, 0, 0, 0, 0, 0, 3)),
    (7, 'Silent Injector', 'WEAPON', 3, 7, 2, 45, ROW(0, 0, 1, 0, 14, 5, 0, 0, 0)),
    (8, 'Stability Baton', 'WEAPON', 4, 8, 2, 70, ROW(0, 1, 0, 0, 10, 0, 0, 1, 0)),
    (9, 'Core Plating', 'ARMOR', 0, 0, 0, 120, ROW(0, 0, 0, 0, 0, 0, 10, 0, 0)),
    (10, 'Layered Mesh Suit', 'ARMOR', 0, 0, 0, 160, ROW(0, 0, 1, 0, 0, 8, 5, 0, 0)),
    (11, 'Quick Restore Shot', 'HEALING', 20, 45, 0, 35, ROW(0, 0, 0, 0, 0, 0, 0, 0, 0));

SELECT setval(pg_get_serial_sequence('Item', 'id'), 12, false) FROM Item;

INSERT INTO Store (id, name) VALUES
    (1, 'Core Supply Node'),
    (2, 'Static Mesh Commerce Terminal'),
    (3, 'Processing Maintenance Depot'),
    (4, 'Packet Pier Outpost'),
    (5, 'Harbor Simulation Market');

SELECT setval(pg_get_serial_sequence('Store', 'id'), 6, false) FROM Store;

INSERT INTO StoreVendeItem (storeId, itemId) VALUES
    -- Loja 1 – Core Supply Node (Núcleo Inicial)
    (1, 1),  -- Diagnostic Knife
    (1, 2),  -- Sync Jacket
    (1, 5),  -- Data Surge Potion
    (1, 11), -- Quick Restore Shot (cura rápida inicial)

    -- Loja 2 – Static Mesh Commerce Terminal (Malha Urbana Estática)
    (2, 1),  -- Diagnostic Knife
    (2, 3),  -- Urban Debugger
    (2, 5),  -- Data Surge Potion
    (2, 7),  -- Silent Injector (arma focada em INFILTRAR)
    (2, 11), -- Quick Restore Shot

    -- Loja 3 – Processing Maintenance Depot (Subcamadas de Processamento)
    (3, 3),  -- Urban Debugger
    (3, 5),  -- Data Surge Potion (script de estabilização)
    (3, 4),  -- Forest Cloak
    (3, 8),  -- Stability Baton (arma pensada pra RESTAURAR)
    (3, 9),  -- Core Plating (armadura pesada)

    -- Loja 4 – Packet Pier Outpost (Mar de Dados)
    (4, 5),  -- Data Surge Potion
    (4, 6),  -- Abyssal Patch
    (4, 7),  -- Silent Injector (opção high-end de precisão)
    (4, 8),  -- Stability Baton
    (4, 10), -- Layered Mesh Suit (armadura híbrida avançada)

    -- Loja 5 – Harbor Simulation Market (Mar de Dados / transição pro Núcleo Abissal)
    (5, 3),  -- Urban Debugger
    (5, 4),  -- Forest Cloak
    (5, 5),  -- Data Surge Potion
    (5, 6),  -- Abyssal Patch
    (5, 10); -- Layered Mesh Suit


INSERT INTO Enemy (
    id, name, hitPoints, accuracy, dodging,
    strikeDamage, damageAbsorb, experience,
    weaponId, moneyMin, moneyMax
) VALUES
    (1, 'Glitched Critter', 6,   35,  0, 0, 0,   3,  1,  0,   2),
    (2, 'Corrupted Avatar', 20,  75,  0, 1, 0,  12,  3,  1,   5),
    (3, 'Zombie Process', 28,  90, -5, 2, 1,  20,  3,  2,   8),
    (4, 'Fractal Beast', 24,  95, 20, 2, 0,  25,  1,  5,  15),
    (5, 'Data Leviathan', 180, 140,  0, 8, 4, 200,  3, 50, 150),
    (6, 'Abyssal Fragment', 120, 150, 10, 6, 4, 180,  3, 80, 200);

SELECT setval(pg_get_serial_sequence('Enemy', 'id'), 7, false) FROM Enemy;

INSERT INTO Loot (enemyId, itemId, itemQuantity) VALUES
    -- Inimigos da Malha Urbana: introduzem scripts de cura
    (2, 5, 1),

    -- Subcamadas de Processamento: foco em estabilidade e defesa
    (3, 5, 1),
    (3, 9, 1),

    -- Setor Florestal: foco em esquiva e precisão
    (4, 4, 1),
    (4, 7, 1),

    -- Mar de Dados e Núcleo Abissal: consumíveis raros de alto impacto
    (5, 6, 1),
    (6, 6, 1);

INSERT INTO Map (id, name, description, type, region, corruptionLevel, storeId, enemyId, maxEnemies) VALUES

    -- 1–4 : Initial Core (corruption 0)
    (1, 'Initial Core: Boot Terminal',
        'You wake up in a white, static space. Diagnostic lines blink in the background, pointing to failures in the Grid.',
        'PLAINROOM', 'NUCLEO_INICIAL', 0, NULL, NULL, 0),

    (2, 'Initial Core: Sync Corridor',
        'A corridor of floating panels displays error messages a...s relatively stable, but something moves between the glitches.',
        'PLAINROOM', 'NUCLEO_INICIAL', 0, NULL, 1, 1),

    (3, 'Initial Core: Training Room',
        'Old terminals project text tutorials. A virtual instructor watches your movements and offers controlled challenges.',
        'TRAININGROOM', 'NUCLEO_INICIAL', 0, NULL, 1, 1),

    (4, 'Initial Core: Supply Node',
        'A cluster of surviving commercial consoles still sells basic equipment for the simulation.',
        'STORE', 'NUCLEO_INICIAL', 0, 1, NULL, 0),

    -- 5–10 : Static Urban Mesh (corruption 1)
    (5, 'Static Urban Mesh: Fragmented Square',
        'Remains of an old social plaza. Frozen avatars and halved buildings reveal the damage caused by the Decay.',
        'PLAINROOM', 'MALHA_URBANA_ESTATICA', 1, NULL, 2, 2),

    (6, 'Static Urban Mesh: Unstable Street',
        'Streets slowly reconfigure under your feet. Digital graffiti flickers between error messages.',
        'PLAINROOM', 'MALHA_URBANA_ESTATICA', 1, NULL, 2, 2),

    (7, 'Static Urban Mesh: Corrupted Alley',
        'A dark alley where the floor texture fails and sound ec...es with a delay. Hostile entities hide on the corrupted edges.',
        'PLAINROOM', 'MALHA_URBANA_ESTATICA', 1, NULL, 2, 2),

    (8, 'Static Urban Mesh: Commerce Terminal',
        'Old shop modules still partially work, selling leftover items from the ruined virtual economy.',
        'STORE', 'MALHA_URBANA_ESTATICA', 1, 2, NULL, 0),

    (9, 'Static Urban Mesh: Glitched Crossroads',
        'Streams of traffic data cross at high speed. Lost packets explode into sparks of light.',
        'PLAINROOM', 'MALHA_URBANA_ESTATICA', 1, NULL, 2, 3),

    (10, 'Static Urban Mesh: Gate to the Sub-layers',
        'A damaged administrative access gate. Red security locks warn about severe instability in the deeper layers.',
        'PLAINROOM', 'MALHA_URBANA_ESTATICA', 1, NULL, 2, 2),

    -- 11–16 : Processing Sub-layers (corruption 2)
    (11, 'Processing Sub-layers: Looping Corridor',
        'Identical corridors repeat as if the environment were stuck in an execution loop.',
        'PLAINROOM', 'SUBCAMADAS_PROCESSAMENTO', 2, NULL, 3, 2),

    (12, 'Processing Sub-layers: Processing Node',
        'A central node responsible for task distribution. Now it just forwards corrupted processes.',
        'PLAINROOM', 'SUBCAMADAS_PROCESSAMENTO', 2, NULL, 3, 1),

    (13, 'Processing Sub-layers: Overflowing Buffer',
        'Stacks of data overflow visual containers and spill as glowing blocks over the floor.',
        'PLAINROOM', 'SUBCAMADAS_PROCESSAMENTO', 2, NULL, 3, 2),

    (14, 'Processing Sub-layers: Zombie Process Queue',
        'Processes that should have been terminated still wait in line, creating a limbo of unfinished tasks.',
        'PLAINROOM', 'SUBCAMADAS_PROCESSAMENTO', 2, NULL, 3, 2),

    (15, 'Processing Sub-layers: Corrupted Cache Core',
        'A memory cache that replays stuck frames of past simulations endlessly.',
        'PLAINROOM', 'SUBCAMADAS_PROCESSAMENTO', 2, NULL, 3, 1),

    (16, 'Processing Sub-layers: Access to the Forest Sector',
        'A transition zone with remnants of both rigid architecture and organic procedural structures.',
        'PLAINROOM', 'SUBCAMADAS_PROCESSAMENTO', 2, NULL, 3, 1),

    -- 17–22 : Procedural Forest Sector (corruption 3)
    (17, 'Procedural Forest Sector: Unstable Edge',
        'Trees and plants reconfigure in real time, changing shapes as their generation algorithms struggle.',
        'PLAINROOM', 'SETOR_FLORESTAL_PROCEDURAL', 3, NULL, 4, 2),

    (18, 'Procedural Forest Sector: Organic Data Market',
        'A small marketplace where entities trade organic-looking data clusters.',
        'STORE', 'SETOR_FLORESTAL_PROCEDURAL', 3, 3, NULL, 0),

    (19, 'Procedural Forest Sector: Corrupted Clearing',
        'A clearing where the ground is covered with corrupted textures and glitching wildlife.',
        'PLAINROOM', 'SETOR_FLORESTAL_PROCEDURAL', 3, NULL, 4, 1),

    (20, 'Procedural Forest Sector: Reconfigurable Trail',
        'Trails constantly rewire themselves, forcing you to adapt your path every few steps.',
        'PLAINROOM', 'SETOR_FLORESTAL_PROCEDURAL', 3, NULL, 4, 2),

    (21, 'Procedural Forest Sector: Root of the Grid',
        'A massive tree-shaped node anchors several subsystems of the simulation.',
        'PLAINROOM', 'SETOR_FLORESTAL_PROCEDURAL', 3, NULL, 4, 1),

    (22, 'Procedural Forest Sector: Passage to the Data Sea',
        'The terrain becomes liquid and glowing, announcing the transition to deeper layers.',
        'PLAINROOM', 'SETOR_FLORESTAL_PROCEDURAL', 3, NULL, 4, 1),

    -- 23–27 : Data Sea (corruption 4)
    (23, 'Data Sea: Bit Surface',
        'You float over an ocean of bits. Digital waves rise and fall, trying to drag your avatar down.',
        'PLAINROOM', 'MAR_DE_DADOS', 4, NULL, 5, 2),

    (24, 'Data Sea: Packet Pier',
        'A makeshift pier where larger data packets can be “docked” and inspected. Some merchants profit from the chaos.',
        'STORE', 'MAR_DE_DADOS', 4, 4, NULL, 0),

    (25, 'Data Sea: Unstable Current',
        'High-speed data streams distort the environment and push everything around.',
        'PLAINROOM', 'MAR_DE_DADOS', 4, NULL, 5, 2),

    (26, 'Data Sea: Harbor of Nautical Simulations',
        'Old ship and harbor simulations have been glued together, forming a chaotic coastal scene.',
        'STORE', 'MAR_DE_DADOS', 4, 5, NULL, 0),

    (27, 'Data Sea: Vortex to the Abyss',
        'A massive whirlpool of data drags everything toward the depths of the system.',
        'PLAINROOM', 'MAR_DE_DADOS', 4, NULL, 5, 1),

    -- 28–30 : Abyssal Core (corruption 5)
    (28, 'Abyssal Core: Antechamber of Decay',
        'Space itself seems broken here. Parts of your avatar appear misaligned, as if the model were failing.',
        'PLAINROOM', 'NUCLEO_ABISSAL', 5, NULL, 6, 1),

    (29, 'Abyssal Core: Fragmented Chamber',
        'Fragments of environments from all over the Grid float in pieces, colliding and regrouping into impossible shapes.',
        'PLAINROOM', 'NUCLEO_ABISSAL', 5, NULL, 6, 1),

    (30, 'Abyssal Core: Heart of Corruption',
        'At the center of everything, a mass of pulsating code e...waves of energy that distort the very logic of the simulation.',
        'PLAINROOM', 'NUCLEO_ABISSAL', 5, NULL, 6, 1);


INSERT INTO Conecta VALUES
    -- Núcleo Inicial (1–4)
    ('NORTH', 1, 2), ('SOUTH', 2, 1),
    ('EAST',  2, 3), ('WEST',  3, 2),
    ('WEST',  2, 4), ('EAST',  4, 2),
    ('NORTH', 2, 5), ('SOUTH', 5, 2),

    -- Malha Urbana (5–10)
    ('NORTH', 5, 6), ('SOUTH', 6, 5),
    ('EAST',  5, 7), ('WEST',  7, 5),
    ('WEST', 5, 8), ('EAST', 8, 5),

    

    -- Portão para Subcamadas
    ('NORTH', 6, 9), ('SOUTH',  9, 6),
    ('NORTH', 9, 10), ('SOUTH', 10, 9),
    ('NORTH', 10, 11), ('SOUTH', 11, 10),

    -- Subcamadas (11–16)
    ('NORTH', 11, 12), ('SOUTH', 12, 11),
    ('EAST',  12, 13), ('WEST',  13, 12),
    ('NORTH', 13, 14), ('SOUTH', 14, 13),
    ('WEST',  14, 15), ('EAST',  15, 14),
    ('NORTH', 15, 16), ('SOUTH', 16, 15),

    -- Acesso ao Setor Florestal
    ('NORTH', 16, 17), ('SOUTH', 17, 16),
    ('WEST', 17, 18), ('EAST', 18, 17),
    ('EAST',  17, 19), ('WEST',  19, 17),
    ('NORTH', 17, 20), ('SOUTH', 20, 17),

    ('NORTH', 20, 21), ('SOUTH', 21, 20),
    ('NORTH', 21, 22), ('SOUTH', 22, 21),
    ('NORTH', 22, 23), ('SOUTH', 23, 22),

    -- Mar de Dados (23–27)
    ('WEST',  23, 24), ('EAST', 24, 23),
    ('EAST',  23, 25), ('WEST', 25, 23),
    ('SOUTH', 25, 26), ('NORTH', 26, 25),

    ('NORTH', 24, 27), ('SOUTH', 27, 24),

    -- Acesso ao Núcleo Abissal
    ('NORTH', 27, 28), ('SOUTH', 28, 27),

    -- Núcleo Abissal (28–30)
    ('NORTH', 28, 29), ('SOUTH', 29, 28),
    ('NORTH', 29, 30), ('SOUTH', 30, 29);


INSERT INTO MapVolatile VALUES
    (1, 0), (2, 0), (3, 0), (4, 0), (5, 0),
    (6, 0), (7, 0), (8, 0), (9, 0), (10, 0),
    (11, 0), (12, 0), (13, 0), (14, 0), (15, 0),
    (16, 0), (17, 0), (18, 0), (19, 0), (20, 0),
    (21, 0), (22, 0), (23, 0), (24, 0), (25, 0),
    (26, 0), (27, 0), (28, 0), (29, 0), (30, 0);

INSERT INTO EnemyInstance (id, templateId, hitPoints, mapId, nextAttackTime) VALUES
    (1,  1,   6,  2, 0),
    (2,  1,   6,  3, 0),

    (3,  2,  20,  5, 0),
    (4,  2,  20,  6, 0),
    (5,  2,  20,  7, 0),
    (6,  2,  20,  9, 0),
    (7,  2,  20, 10, 0),

    (8,  3,  28, 11, 0),
    (9,  3,  28, 12, 0),
    (10, 3,  28, 13, 0),
    (11, 3,  28, 14, 0),
    (12, 3,  28, 15, 0),
    (13, 3,  28, 16, 0),

    (14, 4,  24, 17, 0),
    (15, 4,  24, 19, 0),
    (16, 4,  24, 20, 0),
    (17, 4,  24, 21, 0),
    (18, 4,  24, 22, 0),

    (19, 5, 180, 23, 0),
    (20, 5, 180, 25, 0),
    (21, 5, 180, 27, 0),

    (22, 6, 120, 28, 0),
    (23, 6, 120, 29, 0),
    (24, 6, 120, 30, 0);

SELECT setval(pg_get_serial_sequence('EnemyInstance', 'id'), 25, false) FROM EnemyInstance;

INSERT INTO Player
    (id, name, pass, rank, class, statPoints, experience, level,
     mapId, money, hitPoints, nextAttackTime, attributes, weaponId, armorId)
VALUES
    (3435973837, 'test', '123', 'REGULAR', 'NONE',
        0, 0, 1,
        1, 9999, 10, 0,
        ROW(7, 7, 7, 0, 0, 0, 0, 0, 0),
        1, 2);
