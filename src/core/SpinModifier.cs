namespace hackathon_2025.core;

public abstract partial class SpinModifier : Resource
{
    private int _modifierOrder { get; }
    [Export] private string description { get; set; }

    public abstract void ApplyModifier();
}