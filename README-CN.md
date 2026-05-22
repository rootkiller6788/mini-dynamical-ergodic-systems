# Mini Dynamical & Ergodic Systems（迷你动力系统与遍历论）

一套**从零开始、零依赖的 Lean 4 实现**，涵盖大学层次的动力系统与遍历论。每个子包对应 MIT（及其他顶尖大学）课程，使用 Lean 4 证明助手从第一性原理构建动力系统与遍历论基础。

## 子包

| 子包 | 主题 | 核心课程 |
|------|------|----------|
| [mini-ergodic-theory](mini-ergodic-theory/) | 遍历性、混合、Birkhoff 定理、熵、Kolmogorov-Sinai、Furstenberg 对应 | MIT 18.158, Princeton MAT 585 |
| [mini-topological-dynamics](mini-topological-dynamics/) | 拓扑熵、扩张性、Anosov 微分同胚、结构稳定性 | MIT 18.158, Berkeley Math 242 |
| [mini-symbolic-dynamics](mini-symbolic-dynamics/) | 移位空间、有限型子移位、熵、zeta 函数 | MIT 18.158, Oxford Part C |
| [mini-bifurcation-theory](mini-bifurcation-theory/) | 局部分岔、正规形、中心流形、混沌、Lyapunov 指数 | MIT 18.385, Cambridge Part III |
| [mini-complex-dynamics](mini-complex-dynamics/) | Julia/Fatou 集、Mandelbrot、Montel/Carleman、拟共形手术 | MIT 18.158, Harvard Math 118 |
| [mini-hamiltonian-systems](mini-hamiltonian-systems/) | Hamilton 力学、可积系统、KAM 理论、Arnold 扩散 | MIT 18.385, Princeton MAT 585 |
| [mini-stability-theory](mini-stability-theory/) | Lyapunov 稳定性、LaSalle 不变性、输入到状态稳定性 | MIT 18.385, Stanford AA 203 |
| [mini-random-dynamical-systems](mini-random-dynamical-systems/) | 随机动力系统、乘性遍历定理、Lyapunov 谱 | MIT 18.158, Cambridge Part III |

## 设计理念

- **零外部依赖** -- 纯 Lean 4，仅导入内核模块
- **自包含子包** -- 每个子包拥有独立的 `lakefile.lean`、Core/、Morphisms/、Constructions/、Properties/、Theorems/
- **理论到代码的映射** -- 每个模块包含内联 `#eval` 示例和定理陈述

## 构建

每个子包独立构建。使用 Lake 构建：

```bash
cd mini-ergodic-theory
lake build
lake env lean --run Test/Smoke.lean
```

需要 **Lean 4** 和 **Lake**。

## 项目结构

```
18. mini-dynamical-ergodic-systems/
├── mini-ergodic-theory/             # 遍历性、Birkhoff 定理、熵
├── mini-topological-dynamics/       # 拓扑熵、Anosov 微分同胚
├── mini-symbolic-dynamics/          # 移位空间、有限型子移位、熵
├── mini-bifurcation-theory/         # 分岔、混沌、Lyapunov 指数
├── mini-complex-dynamics/           # Julia/Fatou 集、Mandelbrot
├── mini-hamiltonian-systems/        # Hamilton 力学、KAM 理论
├── mini-stability-theory/           # Lyapunov 稳定性、LaSalle
└── mini-random-dynamical-systems/   # 随机动力系统、Lyapunov 谱
```

## 许可证

MIT
