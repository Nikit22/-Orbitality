using UnityEngine;

namespace Orbitality.Core.Input
{
    public class PlayerInput : MonoBehaviour
    {
        private Physics.Launcher launcher;

        private void Awake()
        {
            launcher = GetComponentInChildren<Physics.Launcher>();
        }

        private void Update()
        {
            if (!launcher.ReadyToLaunch && UnityEngine.Input.GetMouseButtonDown(0))
                launcher.StartLaunching();

            if (launcher.ReadyToLaunch && UnityEngine.Input.GetMouseButtonUp(0))
                launcher.Launch();
        }
    }
}