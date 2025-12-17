using TMPro;
using UnityEngine;
using UnityEngine.UI;

public class FillBar : MonoBehaviour
{
    [SerializeField] private Image fillImage;
    [SerializeField] private TMP_Text valueText;

    public void SetFillAmount(float current, float max)
    {
        float amount = current / max;
        fillImage.fillAmount = Mathf.Clamp01(amount);
        if (valueText != null)
        {
            valueText.text = $"{current}/{max}";
        }
    }
}
