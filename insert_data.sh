#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE games, teams")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WIN_GOALS OPP_GOALS
do
  if [[ $YEAR != "year" ]]
  then
    # Winner ID
    WIN_TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    if [[ -z $WIN_TEAM_ID ]]
    then
      INSERT_WIN_ID_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      WIN_TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    fi
	
    # Opponent ID
    OPP_TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    if [[ -z $OPP_TEAM_ID ]]
    then
      INSERT_OPP_ID_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      OPP_TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    fi
	INSERT_GAME_ID_RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) 
	VALUES( '$YEAR', '$ROUND', $WIN_TEAM_ID, $OPP_TEAM_ID, '$WIN_GOALS', '$OPP_GOALS')")

  fi
done
