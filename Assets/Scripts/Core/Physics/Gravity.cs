using Orbitality.Core.Models;
using UnityEngine;

namespace Orbitality.Core.Physics
{
    public class Gravity : MonoBehaviour
    {
        private void Update() => ApplyGravity();

        private void ApplyGravity()
        {
            foreach (var firstObject in Universe.GravityObjects)
            foreach (var secondObject in Universe.GravityObjects)
                ApplyGravityFor(firstObject, secondObject);
        }

        private void ApplyGravityFor(IGravityObject firstObject, IGravityObject secondObject)
        {
            if (!firstObject.CanApplyTo(secondObject))
                return;

            if (!firstObject.Transform || !secondObject.Transform)
                return;
            
            var direction = firstObject.Transform.position - secondObject.Transform.position;
            var distanceSquared = Mathf.Pow(direction.magnitude, 2f);

            var gravityMagnitude = firstObject.Mass * secondObject.Mass / distanceSquared;
            var gravityVector = gravityMagnitude * direction.normalized;

            firstObject.AddForce(-gravityVector);
        }
    }
}