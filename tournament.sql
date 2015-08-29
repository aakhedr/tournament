-- Table definitions for the tournament project.
--
-- Put your SQL 'create table' statements in this file; also 'create view'
-- statements if you choose to use it.
--
-- You can write comments in this file by starting them with two dashes, like
-- these lines here.


DROP DATABASE IF EXISTS tournament;
CREATE DATABASE tournament;
\c tournament;

CREATE TABLE players(   id      SERIAL PRIMARY KEY,
                        name    TEXT
                        );

CREATE TABLE matches(   id      SERIAL PRIMARY KEY,
                        player1 INT REFERENCES players(id),
                        player2 INT REFERENCES players(id),
                        winner  INT REFERENCES players(id)
                        );

-- First left join
CREATE VIEW winners AS
    SELECT players.id, matches.winner
    FROM players LEFT JOIN matches
    ON players.id = matches.winner;

-- Aggregate winners
CREATE VIEW wins AS
    SELECT id, count(winner) AS wins
    FROM winners
    GROUP BY id
    ORDER BY wins DESC;

-- Left join and count (one query)
CREATE VIEW played AS
    SELECT players.id, players.name, count(matches.player1) AS played
    FROM players LEFT JOIN matches
    ON players.id = matches.player1 or players.id = matches.player2
    GROUP BY players.id

CREATE VIEW standings AS
    SELECT played.id, played.name, wins.wins, played.played
    FROM played LEFT JOIN wins on played.id = wins.id
    ORDER BY wins.wins DESC, played.name;