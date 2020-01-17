using Orbitality.Core.Models;
using UnityEngine;

namespace Orbitality.Core
{
    public class Singularity : MonoBehaviour
    {
        private void Awake() => Universe.MakeBigBang();
    }
}
