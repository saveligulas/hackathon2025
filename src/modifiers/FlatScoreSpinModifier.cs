using hackathon_2025.core;

namespace hackathon_2025.modifiers;

public partial class FlatScoreSpinModifier : SpinModifier
{
    [Export] public int Score { get; set; }
    public override void ApplyModifier()
    {
        throw new NotImplementedException();
    }
}