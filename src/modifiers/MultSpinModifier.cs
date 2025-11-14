using hackathon_2025.core;

namespace hackathon_2025.modifiers;

public partial class MultSpinModifier : SpinModifier
{
    [Export] public float Multiplier { get; set; }
    public override void ApplyModifier()
    {
        throw new NotImplementedException();
    }
}