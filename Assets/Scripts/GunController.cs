using UnityEngine;

public class GunController : MonoBehaviour
{
    [Header("Gun Config")]
    public Camera playerCamera;
    public float shootingRange = 100f;
    public AudioSource gunshotAudioSource;
    public AudioClip gunshotSound;

    [Header("Layer Setup")]
    public LayerMask hitLayers = ~0;

    public void Shoot()
    {
        // 1. Can shoot check
        if (GameManager.Instance == null || !GameManager.Instance.CanShoot())
        {
            return;
        }

        // 2. Ammo deduct
        GameManager.Instance.BulletUsed();

        // 3. Gunshot audio
        if (gunshotAudioSource != null && gunshotSound != null)
        {
            gunshotAudioSource.PlayOneShot(gunshotSound);
        }

        // 4. Exact screen center raycast (Viewport 0.5, 0.5)
        Ray ray = playerCamera.ViewportPointToRay(new Vector3(0.5f, 0.5f, 0f));
        
        // Offset ray origin slightly forward so camera near clip / body doesn't interfere
        Vector3 rayOrigin = ray.origin + (ray.direction * 0.4f);

        // Visual debug ray in Scene view (Cyan ray for 1 second)
        Debug.DrawRay(rayOrigin, ray.direction * shootingRange, Color.cyan, 1.0f);

        RaycastHit hit;

        if (Physics.Raycast(rayOrigin, ray.direction, out hit, shootingRange, hitLayers))
        {
            // Ignore Player hits
            if (hit.collider.CompareTag("Player") || hit.collider.gameObject == this.gameObject)
            {
                return;
            }

            // Target check: Bottle script on object or parent
            Bottle bottle = hit.collider.GetComponent<Bottle>();
            if (bottle == null)
            {
                bottle = hit.collider.GetComponentInParent<Bottle>();
            }

            if (bottle != null || hit.collider.CompareTag("Bottle"))
            {
                if (bottle != null)
                {
                    bottle.Break();
                }
            }
        }
    }
}