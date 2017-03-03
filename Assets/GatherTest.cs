using UnityEngine;

[ExecuteInEditMode]
[RequireComponent(typeof(Camera))]
public class GatherTest : MonoBehaviour
{
    [SerializeField] Shader _shader;

    Material _material;

    void OnDestroy()
    {
        if (_material != null)
            if (Application.isPlaying)
                Destroy(_material);
            else
                DestroyImmediate(_material);
    }

    void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        if (_material == null)
        {
            _material = new Material(_shader);
            _material.hideFlags = HideFlags.DontSave;
        }

        var rt = RenderTexture.GetTemporary(source.width, source.height);

        Graphics.Blit(source, rt, _material, 0);
        Graphics.Blit(rt, destination, _material, 1);

        RenderTexture.ReleaseTemporary(rt);
    }
}
