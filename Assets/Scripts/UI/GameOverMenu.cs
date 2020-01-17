using System.Collections;
using System.Collections.Generic;
using Orbitality.Core.Models;
using Orbitality.Core.Views;
using Orbitality.UI;
using UnityEngine;

public class GameOverMenu : MonoBehaviour
{
    public GameObject gameOverMenu;
    public GameObject youWinMenu;
    public MainMenu mainMenu;
    public GameObject pauseButton;

    public void GoBackToMenu()
    {
        foreach (var rocket in FindObjectsOfType<RocketView>())
        {
            if (rocket.transform.parent != Universe.RocketsParent)
                rocket.transform.parent = Universe.RocketsParent;

            rocket.gameObject.SetActive(false);
        }

        Destroy(mainMenu.planets);
    }

    public void ActivateGameOverMenu()
    {
        pauseButton.SetActive(false);
        gameOverMenu.SetActive(true);
    }

    public void ActivateYouWinMenuMenu()
    {
        pauseButton.SetActive(false);
        youWinMenu.SetActive(true);
    }
}