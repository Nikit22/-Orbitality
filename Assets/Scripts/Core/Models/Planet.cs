using System;
using Orbitality.Core.Physics;
using UnityEngine;

namespace Orbitality.Core.Models
{
    public class Planet : IGravityObject, IDamagable
    {
        public event Action Die;
        public event Action<float> HealthChanged;
        
        private string name;
        public PhysicsBody PhysicsBody { get; }
        public Transform Transform { get; }
        public float Mass { get; }

        private float health = 100f;
        public float Health
        {
            get => health;
            private set
            {
                Debug.Log($"Planet {name} had {health} HP and take {health - value} damage");
                
                health = value;
                
                
                Debug.Log($"Planet {name} has {health} HP now");

                if (health <= 0)
                {
                    health = 0;
                    Die?.Invoke();
                }

                HealthChanged?.Invoke(health);
            }
        }

        public Planet(PhysicsBody physicsBody, Transform transform, string name)
        {
            PhysicsBody = physicsBody;
            Transform = transform;

            this.name = name;

            Mass = physicsBody.mass;
        }

        public bool CanApplyTo(IGravityObject @object) => false;

        public void AddForce(Vector3 vector) => PhysicsBody.AddForce(vector);

        public void TakeDamage(int damage) => Health -= damage;

        public override string ToString() => name;
    }
}