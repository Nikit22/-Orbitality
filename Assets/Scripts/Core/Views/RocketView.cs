using System;
using System.Threading;
using Orbitality.Core.Data;
using Orbitality.Core.Enums;
using Orbitality.Core.Models;
using Orbitality.Core.Physics;
using UnityEngine;
using UnityEngine.Serialization;

namespace Orbitality.Core.Views
{
    public class RocketView : MonoBehaviour
    {
        public RocketType rocketType;
        public RocketCharacteristics characteristics;
        
        private PlanetView creator;
        public Rocket Rocket  { get; private set; }

        private void OnEnable()
        {
            creator = transform.GetComponentInParent<PlanetView>();
            
            Rocket = new Rocket(GetComponent<PhysicsBody>(), transform, creator.Planet, characteristics);
            
            Universe.GravityObjects.Add(Rocket);
        }

        private void OnTriggerEnter(Collider other)
        {
            if (other.GetComponent<Indestructible>())
            {
                Destroy();
                return;
            }

            if (other.GetComponent<PlanetView>() == creator)
                return;
            
            var damagable = other.GetComponent<IDamagable>();
            if (damagable == null)
                return;

            damagable.TakeDamage(Rocket.Characteristics.damage);
            Destroy();
        }

        private void Destroy()
        {
            //particles
            Universe.GravityObjects.Remove(Rocket);
            Universe.ReturnRocketOfType(gameObject, rocketType);
        }

    }
}