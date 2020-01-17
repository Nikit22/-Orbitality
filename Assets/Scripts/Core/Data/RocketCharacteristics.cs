using UnityEngine;

namespace Orbitality.Core.Data
{
    [CreateAssetMenu(fileName = "New Rocket Characteristics", menuName = "Rocket Characteristics", order = 51)]
    public class RocketCharacteristics : ScriptableObject
    {
        public float weight;
        public float acceleration;
        public float cooldown;
        public int damage;
    }
}