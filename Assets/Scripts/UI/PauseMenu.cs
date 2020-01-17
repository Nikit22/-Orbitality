using System.Linq;
using Orbitality.Core.Models;
using UnityEngine;

namespace Orbitality.UI
{
    public class PauseMenu : MonoBehaviour
    {
        public GameOverMenu gameOverMenu;
        public void Pause() => Universe.Pause();
        public void Resume() => Universe.Resume();

        public void Quit() => Universe.MakeBigCrunch();

        public void GoBackToMenu() => gameOverMenu.GoBackToMenu();
    }
}