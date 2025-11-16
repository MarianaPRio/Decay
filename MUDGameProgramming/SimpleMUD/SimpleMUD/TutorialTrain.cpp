#include "TutorialTrain.h"
#include "BasicLib/BasicLib.h"
#include "PlayerDatabase.h"

using namespace SocketLib;

namespace SimpleMUD {
void TutorialTrain::Handle(string p_data) {
  using namespace BasicLib;

  p_data = BasicLib::LowerCase(ParseWord(p_data, 0));

  Player &p = *m_player;

  if (p_data == "quit") {
    // save the player to disk
    PlayerDatabase::GetInstance().SavePlayer(p.ID());

    // go back to the previous handler
    p.Conn()->RemoveHandler();
    return;
  }

  char n = p_data[0];
  if (n >= '1' && n <= '3') {
    if (p.StatPoints() > 0) {
      p.StatPoints()--;
      p.AddToBaseAttr(n - '1', 1);
    }
  }

  PrintStats(true);
}

// ------------------------------------------------------------------------
//  This notifies the handler that there is a new connection
// ------------------------------------------------------------------------
void TutorialTrain::Enter() {
  Player &p = *m_player;

  p.Active() = false;

  if (p.Newbie()) {
    p.SendString(magenta + bold + "Welcome, " + p.Name() +
                 "!\r\n" +
                 "You must train your character with your desired stats,\r\n" +
                 "before you enter the grid\r\n\r\n");
    p.Newbie() = false;
  }

  PrintStats(false);
}

// ------------------------------------------------------------------------
//  This function prints out your statistics.
// ------------------------------------------------------------------------
void TutorialTrain::PrintStats(bool p_clear) {
  using BasicLib::tostring;

  Player &p = *m_player;

  if (p_clear) {
    p.SendString(clearscreen);
  }

  p.SendString(
      white + bold +
      "--------------------------------- Your Stats "
      "----------------------------------\r\n" +
      "Player:           " + p.Name() + "\r\n" +
      "Level:            " + tostring(p.Level()) + "\r\n" +
      "Stat Points Left: " + tostring(p.StatPoints()) + "\r\n" +
      "1) Strength:      " + tostring(p.GetAttr(STRENGTH)) + "\r\n" +
      "2) Health:        " + tostring(p.GetAttr(HEALTH)) + "\r\n" +
      "3) Agility:       " + tostring(p.GetAttr(AGILITY)) + "\r\n" + bold +
      "------------------------------------------------------------------------"
      "-------\r\n" +
      "Enter 1, 2, or 3 to add a stat point, or \"quit\" to enter: ");
}

// ------------------------------------------------------------------------
//  This function prints a Tutorial for new players.
// ------------------------------------------------------------------------
void TutorialTrain::PrintTutorial() {
  Player &p = *m_player;

  p.SendString(
    white + bold +
    "--------------------------------- Training complete. "
    "-----------------------------------\r\n" +
    "> Uploading basic protocols...\r\n"+
    " Welcome to SimpleMUD! This tutorial will help you get started.\r\n"+
    "> Stand by...\r\n\r\n"+
    yellow + "── DECAY PROTOCOL: INITIATION SEQUENCE ──\r\n"+
    "Welcome to the decayed network.\r\n"+
    "Use commands to interact with your environment:\r\n"+
    white +
    " help                       - Shows the menu with all possible commands\r\n" +
    " As you progress, you'll gain experience and level up, improving your\r\n"+
    " character's attributes. Don't forget to train your stats in the trainning room\r\n"+
    "\r\n"+
    " Good luck on the gr%%d, " + p.Name() + "!\r\n" +
    "---------------------------------------------------------------"
    "--------------------");
  }
}
