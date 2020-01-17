using System;
using Orbitality.Core.Enums;
using UnityEngine;

namespace Orbitality.Core.Extensions
{
    public static class RocketTypeExtensions
    {
        public static GameObject CreateRocketWith(this RocketType self, Transform parent) => 
            GameObject.Instantiate(self.Prefab(), parent);
        public static GameObject Prefab(this RocketType self) => 
            Resources.Load<GameObject>(Enum.GetName(typeof(RocketType), self) + "Rocket");
    }
}