using System.Collections.Generic;
using UnityEngine;

namespace Orbitality.Core.Physics
{
    public class PhysicsBody : MonoBehaviour
    {
        public float mass;
        
        private Vector3 velocity;
        private Vector3 netForce;
        
        private List<Vector3> forces = new List<Vector3>();

        private void Update() => UpdatePosition();

        public void AddForce(Vector3 forceVector) => forces.Add(forceVector);

        private void UpdatePosition()
        {
            CalculateNetForce();
            Move();
        }

        private void CalculateNetForce()
        {
            netForce = Vector3.zero;
            
            foreach (var forceVector in forces)
                netForce += forceVector;
            
            forces.Clear();
        }

        private void Move()
        {
            var accelerationVector = netForce / mass;
            velocity += accelerationVector * Time.deltaTime;
            transform.position += velocity * Time.deltaTime;
        }
    }
}