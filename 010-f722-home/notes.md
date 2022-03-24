Drone's frame has 3mm holes, 45mm apart from each other.
Flight's controller base has 5mm of border around these holes, so it's 55x55mm.

```
     ╔ ╔════════╗
     ║ ║·      ·║ ╗
55mm ╣ ║        ║ ╠ 45mm
     ║ ║·      ·║ ╝
     ╚ ╚════════╝
```

BetaFPV F722 has 3mm holes with 25mm spaces, so let's find the vertical distance between them:

```
╔═══════════╗
║     · ╗   ║
║       ║   ║
║ ·   h ╣ · ║
║       ║   ║
║     · ╝   ║
╚═══════════╝
```

```js
h = Math.sqrt(2) * 25
```

Now we have to find the distance between border and one of those F722 screw:

```
║     ·     ║ ╗
║           ║ ╠ d
╚═══════════╝ ╝
```

```js
d = (55 - Math.sqrt(2) * 25) / 2
```
