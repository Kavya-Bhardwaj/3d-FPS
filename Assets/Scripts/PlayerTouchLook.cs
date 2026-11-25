using UnityEngine;
using UnityEngine.InputSystem;

public class PlayerTouchLook : MonoBehaviour
{
    [Header("Look Sensitivity")]
    public float sensitivity = 0.15f;
    public Transform playerCamera;

    private float xRotation = 0f;

    void Update()
    {
        // Agar touchscreen device connected nahi hai toh return karein
        if (Touchscreen.current == null) return;

        // Active touches check karein
        foreach (var touch in Touchscreen.current.touches)
        {
            if (touch.isInProgress)
            {
                Vector2 touchDelta = touch.delta.ReadValue();
                Vector2 touchPosition = touch.position.ReadValue();

                // Check karein ki touch screen ke left/aiming zone me hai (Shoot button se overlap na ho)
                // Shoot button generally right-bottom me hota hai
                if (touchPosition.x < Screen.width * 0.7f)
                {
                    float mouseX = touchDelta.x * sensitivity;
                    float mouseY = touchDelta.y * sensitivity;

                    // Camera pitch (up/down) clamp
                    xRotation -= mouseY;
                    xRotation = Mathf.Clamp(xRotation, -60f, 60f);
                    playerCamera.localRotation = Quaternion.Euler(xRotation, 0f, 0f);

                    // Player yaw (left/right)
                    transform.Rotate(Vector3.up * mouseX);
                    break;
                }
            }
        }
    }
}
