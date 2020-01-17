using UnityEngine;

namespace Orbitality.Core.Models
{
    public interface IGravityObject
    {
        float Mass { get; }
        Transform Transform { get; }

        bool CanApplyTo(IGravityObject @object);
        
        void AddForce(Vector3 vector);
    }
}