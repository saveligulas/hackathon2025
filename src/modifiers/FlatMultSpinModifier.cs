using hackathon_2025.core;

namespace hackathon_2025.modifiers;

public partial class FlatMultSpinModifier : SpinModifier
{
    [Export] public int Mult { get; set; }
    public override void ApplyModifier()
    {
        throw new NotImplementedException();
    }
}