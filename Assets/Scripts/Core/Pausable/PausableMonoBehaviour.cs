using Orbitality.Core.Models;
using UnityEngine;

namespace Orbitality.Core.Pausable
{
    public abstract class PausableMonoBehaviour : MonoBehaviour, IPausable
    {
        public abstract void Pause();
        public abstract void Resume();
        
        private void OnEnable() => 
            Universe.PausableObjects.Add(this);

        private void OnDisable() => 
            Universe.PausableObjects.Remove(this);
    }
}