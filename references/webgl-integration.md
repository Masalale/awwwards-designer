# WebGL Integration

Immersive 3D experiences when the project demands it.

---

## When to Use WebGL

| Use WebGL | Don't Use WebGL |
|-----------|-----------------|
| Hero 3D scenes with interaction | Simple UI elements |
| Product configurators (shoes, cars) | Background decorations |
| Data visualization (3D charts) | Standard page layouts |
| Immersive brand experiences | Text-heavy content |
| Particle systems | Mobile-first sites (performance) |

**Rule:** WebGL is for "moments," not for entire sites.

---

## React Three Fiber Setup

### Basic Scene

```tsx
import { Canvas } from '@react-three/fiber';
import { Environment, ContactShadows, Float } from '@react-three/drei';

function Scene() {
  return (
    <Canvas
      camera={{ position: [0, 0, 5], fov: 45 }}
      dpr={[1, 2]} // Responsive pixel ratio
      gl={{ antialias: true, alpha: true }}
    >
      <Environment preset="city" />
      <ambientLight intensity={0.5} />
      <directionalLight position={[10, 10, 5]} intensity={1} />
      
      <Float rotationIntensity={0.4} floatIntensity={0.5}>
        <Mesh />
      </Float>
      
      <ContactShadows 
        position={[0, -1.5, 0]} 
        opacity={0.5} 
        scale={10} 
        blur={2.5} 
        far={4} 
      />
    </Canvas>
  );
}
```

### Performance-First Canvas

```tsx
<Canvas
  frameloop="demand"        // Only render on changes
  dpr={[1, 1.5]}            // Limit pixel ratio
  camera={{ position: [0, 0, 5], fov: 45 }}
  gl={{
    antialias: false,       // Disable for performance
    powerPreference: "high-performance",
    stencil: false,
    depth: false
  }}
>
  {/* Scene */}
</Canvas>
```

---

## Scroll-Linked 3D

### Basic Scroll Integration

```tsx
import { useScroll, ScrollControls } from '@react-three/drei';
import { useFrame } from '@react-three/fiber';

function ScrollScene() {
  return (
    <ScrollControls pages={3} damping={0.1}>
      <Scene />
    </ScrollControls>
  );
}

function Scene() {
  const scroll = useScroll();
  const meshRef = useRef();
  
  useFrame(() => {
    // scroll.offset: 0 to 1 through entire scroll
    // scroll.range(start, end): 0 to 1 for specific range
    
    meshRef.current.rotation.y = scroll.offset * Math.PI * 2;
    meshRef.current.position.y = scroll.range(0, 0.5) * 2;
  });
  
  return <mesh ref={meshRef}>...</mesh>;
}
```

### Sync with DOM Scroll (GSAP)

```tsx
import { useEffect, useRef } from 'react';
import gsap from 'gsap';
import { ScrollTrigger } from 'gsap/ScrollTrigger';
import { useThree } from '@react-three/fiber';

function ScrollSyncedScene() {
  const { camera } = useThree();
  const triggerRef = useRef();
  
  useEffect(() => {
    const tl = gsap.timeline({
      scrollTrigger: {
        trigger: triggerRef.current,
        start: 'top top',
        end: 'bottom bottom',
        scrub: true
      }
    });
    
    tl.to(camera.position, { z: 10, y: 2 });
    tl.to(camera.rotation, { x: 0.2 }, 0);
    
    return () => {
      tl.kill();
      ScrollTrigger.getAll().forEach(st => st.kill());
    };
  }, []);
  
  return <div ref={triggerRef} style={{ height: '300vh' }} />;
}
```

---

## Post-Processing Effects

### Selective Effects

```tsx
import { EffectComposer, Bloom, Noise } from '@react-three/postprocessing';

function Effects() {
  return (
    <EffectComposer disableNormalPass>
      <Bloom 
        intensity={0.5} 
        luminanceThreshold={0.9} 
        luminanceSmoothing={0.9} 
      />
      <Noise opacity={0.02} />
    </EffectComposer>
  );
}
```

**Performance Note:** Post-processing is expensive. Use sparingly.

---

## Performance Optimization

### Critical Rules

1. **Limit Lights**
   - Max 2-3 lights in scene
   - Use `useHelper` sparingly (dev only)
   - Prefer environment maps

2. **Geometry Optimization**
   ```tsx
   // Reuse geometries
   const boxGeometry = useMemo(() => new BoxGeometry(1, 1, 1), []);
   
   // Instance for repeated objects
   <instancedMesh geometry={boxGeometry} material={material} count={100}>
   ```

3. **Material Optimization**
   ```tsx
   // Share materials
   const material = useMemo(() => {
     return new MeshStandardMaterial({ 
       color: 'white',
       roughness: 0.5,
       metalness: 0.1
     });
   }, []);
   ```

4. **Texture Optimization**
   - Use compressed textures (KTX2, WebP)
   - Limit texture size (max 2048x2048)
   - Use texture atlases

5. **LOD (Level of Detail)**
   ```tsx
   import { useLOD } from '@react-three/drei';
   
   function Model() {
     const ref = useLOD([
       { distance: 0, geometry: highPoly },
       { distance: 10, geometry: mediumPoly },
       { distance: 20, geometry: lowPoly }
     ]);
     
     return <mesh ref={ref} />;
   }
   ```

6. **Frustum Culling**
   ```tsx
   <mesh frustumCulled>...</mesh>
   ```

---

## Error Boundaries

### WebGL Error Fallback

```tsx
import { ErrorBoundary } from 'react-error-boundary';

function SafeCanvas({ children }) {
  return (
    <ErrorBoundary 
      fallback={<div className="webgl-fallback">{children}</div>}
    >
      <Canvas>{children}</Canvas>
    </ErrorBoundary>
  );
}

// Also catch WebGL context loss
function Scene() {
  const gl = useThree(state => state.gl);
  
  useEffect(() => {
    const handleContextLost = () => {
      console.warn('WebGL context lost');
      // Show fallback or reload
    };
    
    gl.domElement.addEventListener('webglcontextlost', handleContextLost);
    return () => {
      gl.domElement.removeEventListener('webglcontextlost', handleContextLost);
    };
  }, [gl]);
  
  return ...;
}
```

---

## Mobile Considerations

### Detect Mobile / Low Power

```tsx
import { useState, useEffect } from 'react';

function useIsMobile() {
  const [isMobile, setIsMobile] = useState(false);
  
  useEffect(() => {
    const check = () => {
      setIsMobile(window.innerWidth < 768 || navigator.hardwareConcurrency <= 4);
    };
    check();
    window.addEventListener('resize', check);
    return () => window.removeEventListener('resize', check);
  }, []);
  
  return isMobile;
}

// Usage
function Scene() {
  const isMobile = useIsMobile();
  
  return (
    <Canvas
      dpr={isMobile ? 1 : [1, 2]}
      frameloop={isMobile ? 'demand' : 'always'}
    >
      {isMobile ? <SimpleScene /> : <ComplexScene />}
    </Canvas>
  );
}
```

---

## Common Patterns

### Floating Elements

```tsx
import { Float } from '@react-three/drei';

<Float
  speed={1.5}
  rotationIntensity={0.5}
  floatIntensity={0.5}
  floatingRange={[-0.1, 0.1]}
>
  <mesh>...</mesh>
</Float>
```

### Particles

```tsx
import { Points, PointMaterial } from '@react-three/drei';

function Particles({ count = 1000 }) {
  const positions = useMemo(() => {
    const arr = new Float32Array(count * 3);
    for (let i = 0; i < count * 3; i++) {
      arr[i] = (Math.random() - 0.5) * 10;
    }
    return arr;
  }, [count]);
  
  return (
    <Points>
      <bufferGeometry>
        <bufferAttribute
          attach="attributes-position"
          count={count}
          array={positions}
          itemSize={3}
        />
      </bufferGeometry>
      <PointMaterial
        size={0.02}
        color="white"
        transparent
        opacity={0.8}
        sizeAttenuation
      />
    </Points>
  );
}
```

---

## Summary Checklist

Before shipping WebGL:

- [ ] Mobile fallback in place
- [ ] Context loss handling
- [ ] Performance: < 16ms frame time
- [ ] Memory: No texture/geometry leaks
- [ ] Accessibility: Alternative for reduced motion
- [ ] Battery: `frameloop="demand"` when possible
- [ ] Progressive: Works without WebGL (fallback)
