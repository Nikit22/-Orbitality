namespace Orbitality.Core
{
    public interface IDamagable
    {
        float Health { get; }
        void TakeDamage(int damage);
    }
}