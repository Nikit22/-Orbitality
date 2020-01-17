using Orbitality.Core.Data;
using Orbitality.Core.Physics;
using UnityEngine;

namespace Orbitality.Core.Models
{
    public class Rocket : IGravityObject
    {
        private readonly IGravityObject creator;
        private readonly PhysicsBody physicsBody;
        public float Mass { get; }
        public Transform Transform { get; }
        public RocketCharacteristics Characteristics { get; }

        public Rocket(PhysicsBody physicsBody, Transform transform, IGravityObject creator,
            RocketCharacteristics rocketCharacteristics)
        {
            this.physicsBody = physicsBody;
            
            Characteristics = rocketCharacteristics;
            Transform = transform;
            
            Mass = physicsBody.mass + Characteristics.weight;
            this.creator = creator;
        }

        public bool CanApplyTo(IGravityObject @object) =>
            @object != this && @object != creator && @object is Planet;

        public void AddForce(Vector3 vector) => physicsBody?.AddForce(vector);

        public override string ToString() => "Rocket from  " + creator;
    }
}