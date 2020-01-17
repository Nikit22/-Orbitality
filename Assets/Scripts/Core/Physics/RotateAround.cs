using Orbitality.Core.Enums;
using Orbitality.Core.Extensions;
using UnityEngine;

namespace Orbitality.Core.Physics
{
    public class RotateAround : MonoBehaviour
    {
        public Axis axis;
        public Transform target;
        public int speed;

        private Transform targetTransform;

        private void Awake()
        {
            if (target == null)
                target = gameObject.transform;
    
            targetTransform = target.transform;
        }

        private void Update() =>
            transform.RotateAround(targetTransform.position, axis.Vector(targetTransform), speed * Time.deltaTime);
    }
}