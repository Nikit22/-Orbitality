using UnityEngine;

namespace Orbitality.Core.Extensions
{
    public static class CoroutineExtensions
    {
        public static void StopFor(this Coroutine self, MonoBehaviour behaviour)
        {
            if (self != null)
                behaviour.StopCoroutine(self);
        }
    }
}