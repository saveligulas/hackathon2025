# C# Cheat Sheet for Java Experts (Godot Game Development)

## Core Syntax Differences

### Type System
```csharp
// Java
String name = "Player";
int health = 100;
boolean isAlive = true;
List<String> items = new ArrayList<>();

// C#
string name = "Player";
int health = 100;
bool isAlive = true;
List<string> items = new List<string>();
```

### Properties (Instead of Getters/Setters)
```csharp
// Java style
private int health;
public int getHealth() { return health; }
public void setHealth(int value) { health = value; }

// C# style
public int Health { get; set; }  // Auto-property

// With logic
private int _health;
public int Health 
{
    get => _health;
    set 
    {
        _health = Mathf.Clamp(value, 0, 100);
        OnHealthChanged?.Invoke();
    }
}
```

### Godot-Specific Core Types
```csharp
// Vector types (Godot uses single-precision)
Vector2 position = new Vector2(10.5f, 20.3f);
Vector3 worldPosition = new Vector3(1.0f, 2.0f, 3.0f);

// Colors
Color red = Colors.Red;
Color customColor = new Color(1.0f, 0.5f, 0.0f);

// Node references
[Export] private Node2D _targetNode;
```

## Game Loop Methods (Godot)

```csharp
public override void _Ready()
{
    // Called when node enters scene tree (like Start() in Unity)
    // Initialize variables, get node references
}

public override void _Process(double delta)
{
    // Called every frame
    // Handle continuous input, animations
    float deltaFloat = (float)delta;
}

public override void _PhysicsProcess(double delta)
{
    // Called at fixed timestep (for physics)
    // Move characters, handle collisions
}

public override void _Input(InputEvent @event)
{
    // Handle input events
    if (@event is InputEventKey keyEvent && keyEvent.Pressed)
    {
        if (keyEvent.Keycode == Key.Space)
        {
            Jump();
        }
    }
}
```

## Common Game Patterns in C#

### Singleton Pattern (Godot Style)
```csharp
// Game Manager
public partial class GameManager : Node
{
    public static GameManager Instance { get; private set; }
    
    public int Score { get; set; }
    
    public override void _Ready()
    {
        if (Instance == null)
        {
            Instance = this;
        }
        else
        {
            QueueFree(); // Destroy duplicate
        }
    }
}

// Usage in other scripts
GameManager.Instance.Score += 100;
```

### Event System (C# Events)
```csharp
public class Player : CharacterBody2D
{
    public event Action<int> HealthChanged;
    public event Action PlayerDied;
    
    private int _health = 100;
    
    public void TakeDamage(int damage)
    {
        _health -= damage;
        HealthChanged?.Invoke(_health);
        
        if (_health <= 0)
            PlayerDied?.Invoke();
    }
}

// Subscribe elsewhere
player.HealthChanged += (health) => UpdateHealthBar(health);
player.PlayerDied += OnPlayerDeath;
```

## Input Handling

```csharp
// In _Process or _PhysicsProcess
Vector2 inputVector = Vector2.Zero;

// Method 1: Input system
if (Input.IsActionPressed("move_right"))
    inputVector.X += 1.0f;
if (Input.IsActionPressed("move_left")) 
    inputVector.X -= 1.0f;

// Method 2: Get action strength (for analog input)
inputVector = Input.GetVector("move_left", "move_right", "move_up", "move_down");

// Apply movement
Velocity = inputVector * Speed;
MoveAndSlide();
```

## Collision Detection

```csharp
public override void _Ready()
{
    // Connect collision signal
    Area2D area = GetNode<Area2D>("Area2D");
    area.AreaEntered += OnAreaEntered;
    area.BodyEntered += OnBodyEntered;
}

private void OnAreaEntered(Area2D area)
{
    if (area.IsInGroup("pickups"))
    {
        PickupItem(area);
    }
}

private void OnBodyEntered(Node2D body)
{
    if (body.IsInGroup("enemies"))
    {
        TakeDamage(10);
    }
}
```

## Coroutines (Async/Await instead of Java Threads)

```csharp
using System.Threading.Tasks;

public async void StartCountdown()
{
    for (int i = 3; i > 0; i--)
    {
        ShowCountdown(i);
        await Task.Delay(1000); // Wait 1 second
    }
    StartGame();
}

// Godot-specific coroutine
public async void FlashDamage()
{
    Modulate = Colors.Red;
    await ToSignal(GetTree().CreateTimer(0.1f), "timeout");
    Modulate = Colors.White;
}
```

## LINQ (Replaces Java Streams)

```csharp
using System.Linq;

// Find all enemies in range
var nearbyEnemies = GetTree().GetNodesInGroup("enemies")
    .Cast<Node2D>()
    .Where(enemy => Position.DistanceTo(enemy.Position) < detectionRange)
    .ToList();

// Get closest enemy
var closestEnemy = GetTree().GetNodesInGroup("enemies")
    .Cast<Node2D>()
    .OrderBy(enemy => Position.DistanceTo(enemy.Position))
    .FirstOrDefault();
```

## Key Differences to Remember

1. **Naming**: `PascalCase` for methods/properties vs Java's `camelCase`
2. **String**: `string` (lowercase) vs Java's `String`
3. **Boolean**: `bool` vs `boolean`
4. **Properties**: Use properties instead of getter/setter methods
5. **Events**: Use events instead of observers/interfaces
6. **LINQ**: More powerful than Java streams for collections
7. **Godot API**: Similar to Unity but with different method names

## Common Godot Patterns

### State Machine
```csharp
public abstract class PlayerState
{
    public abstract void Enter();
    public abstract void Update(double delta);
    public abstract void Exit();
}

public class IdleState : PlayerState
{
    private Player _player;
    
    public IdleState(Player player) => _player = player;
    
    public override void Enter() => _player.PlayAnimation("idle");
    
    public override void Update(double delta)
    {
        if (Input.IsActionPressed("move_right") || Input.IsActionPressed("move_left"))
        {
            _player.ChangeState(new MoveState(_player));
        }
    }
    
    public override void Exit() { }
}
```

## Useful Godot C# Tips

### Export Variables (Visible in Editor)
```csharp
[Export] public int MaxHealth { get; set; } = 100;
[Export] public float MovementSpeed { get; set; } = 300.0f;
[Export] private NodePath _playerPath;
```

### Signal Connections in C#
```csharp
public override void _Ready()
{
    // Connect signals
    GetNode<Button>("StartButton").Pressed += OnStartButtonPressed;
    GetNode<Timer>("GameTimer").Timeout += OnGameTimerTimeout;
}

private void OnStartButtonPressed()
{
    // Handle button press
}

private void OnGameTimerTimeout()
{
    // Handle timer timeout
}
```

This should cover the core logic differences you'll need for Godot game development coming from Java!