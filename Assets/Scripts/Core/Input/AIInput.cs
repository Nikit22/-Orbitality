using UnityEngine;

namespace Orbitality.Core.Input
{
    public class AIInput : MonoBehaviour
    {
        private Physics.Launcher launcher;

        private void Awake()
        {
            launcher = GetComponentInChildren<Physics.Launcher>();
        }

        private void FixedUpdate()
        {
            if (Random.Range(0, 1001) > 10) 
                return;
            
            launcher.Launch(Random.Range(0.4f, 1f));
        }
    }
}