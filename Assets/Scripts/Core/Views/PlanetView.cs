using System;
using Orbitality.Core.Models;
using Orbitality.Core.Physics;
using UnityEngine;

namespace Orbitality.Core.Views
{
    public class PlanetView : MonoBehaviour, IDamagable
    {
        public string name;

        private PlanetHealthView planetHealthView;

        public Planet Planet { get; private set; }

        public float Health => Planet.Health;

        private Vector3 initialPosition;
        private Quaternion initialRotation;

        private void Awake()
        {
            initialPosition = transform.position;
            initialRotation = transform.rotation;
            
            planetHealthView = GetComponent<PlanetHealthView>();

            Planet = new Planet(GetComponent<PhysicsBody>(), transform, name);

            Universe.GravityObjects.Add(Planet);
        }

        private void OnEnable()
        {
            Universe.Planets.Add(this);
            
            if (planetHealthView)
                Planet.HealthChanged += planetHealthView.UpdateUI;

            Planet.Die += Destroy;
            Planet.Die += Universe.CheckPlanets;
        }

        private void OnDisable()
        {
            Universe.Planets.Remove(this);

            if (planetHealthView)
                Planet.HealthChanged -= planetHealthView.UpdateUI;

            Planet.Die -= Destroy;
            Planet.Die -= Universe.CheckPlanets;

        }

        public void TakeDamage(int damage) => Planet.TakeDamage(damage);

        public void SetInitialValues()
        {
            transform.position = initialPosition;
            transform.rotation = initialRotation;
        }

        private void Destroy()
        {
            Debug.Log($"Planet {name} is dead");
            //particles
            Universe.GravityObjects.Remove(Planet);
            gameObject.SetActive(false);
        }
    }
}