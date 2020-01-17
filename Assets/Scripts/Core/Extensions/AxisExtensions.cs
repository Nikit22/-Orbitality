using System;
using Orbitality.Core.Enums;
using UnityEngine;

namespace Orbitality.Core.Extensions
{
    public static class AxisExtensions
    {
        public static Vector3 Vector(this Axis self, Transform transform)
        {
            switch (self)
            {
                case Axis.Forward:
                    return transform.forward;
                case Axis.Up:
                    return transform.up;
                case Axis.Right:
                    return transform.right;
                default:
                    throw new ArgumentOutOfRangeException(nameof(self), self, null);
            }
        }
    }
}