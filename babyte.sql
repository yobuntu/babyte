drop table if exists match;

create table match (
    id integer primary key autoincrement,
    team1_player1 text not null,
    team1_player2 text,
    team2_player1 text not null,
    team2_player2 text,
    score_team1 integer,
    score_team2 integer
);
