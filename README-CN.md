# 迷你动力系统与遍历论

一套**从零开始、零依赖的 Lean 4 实现**，涵盖大学层次的动力系统与遍历论 —— 从分岔理论和复动力系统到哈密顿系统和随机动力系统。每个子包对应 MIT、Princeton 等顶尖大学课程，使用 Lean 4 证明助手从第一性原理构建动力系统基础。

## 子模块

| 子模块 | 主题 | 核心课程 |
|--------|------|----------|
| [mini-bifurcation-theory](mini-bifurcation-theory/) | 鞍结分岔、叉形分岔、Hopf 分岔；规范形；中心流形约化；Feigenbaum 普适性；分岔控制 | MIT 18.385, Cambridge Part III |
| [mini-complex-dynamics](mini-complex-dynamics/) | Julia 集、Fatou 集、Mandelbrot 集；周期点分类；Montel-Caratheodory 理论；共轭；抛物爆破；重整化 | MIT 18.112, Harvard Math 213, Cambridge Part III |
| [mini-ergodic-theory](mini-ergodic-theory/) | 保测变换；Birkhoff 与 von Neumann 遍历定理；Poincaré 回复定理；混合层次；Kolmogorov-Sinai 熵；等分布 | MIT 18.158, Princeton MAT 529 |
| [mini-hamiltonian-systems](mini-hamiltonian-systems/) | 辛几何；Poisson 括号；Liouville 测度；Noether 定理；Arnold-Liouville 可积性；Darboux 定理；KAM 理论 | MIT 18.353, Princeton MAT 520, Berkeley Math 242 |
| [mini-random-dynamical-systems](mini-random-dynamical-systems/) | 上闭链（Cocycle）；Lyapunov 指数；Oseledets 乘性遍历定理（MET）；Kingman 次加性遍历定理；随机吸引子；随机不动点 | MIT 18.175, Princeton MAT 536, ETH 401-4601 |
| [mini-stability-theory](mini-stability-theory/) | Lyapunov 稳定性；渐近与指数稳定性；Hartman-Grobman 定理；LaSalle 不变性原理；Routh-Hurwitz 判据；结构稳定性；输入-状态稳定性（ISS） | MIT 18.385, Stanford MATH 205, Berkeley Math 250A |
| [mini-symbolic-dynamics](mini-symbolic-dynamics/) | 移位空间；子移位；有限型移位（SFT）；Sofic 移位；滑动块码；拓扑共轭；熵；受限编码 | MIT 18.158, Princeton MAT 529, Cambridge Part III |
| [mini-topological-dynamics](mini-topological-dynamics/) | 拓扑空间上的连续动力系统；极小性、回复性、传递性；近端/远端关系；拓扑熵；Ellis 半群；Furstenberg 结构定理 | MIT 18.901, Berkeley Math 242, ETH 401-3462 |

## 设计理念

- **零外部依赖** — 纯 Lean 4，仅导入内核模块；每个子模块自包含
- **自包含子包** — 每个子包拥有独立的 `lakefile.lean`、`Main.lean`，以及模块化的 `Core/`、`Morphisms/`、`Constructions/`、`Properties/`、`Theorems/`、`Examples/`、`Bridges/` 目录结构
- **理论到代码的映射** — 每个模块包含内联 `#eval` 示例和验证过的定理陈述，覆盖 L1–L9 知识层级（定义 → 核心概念 → 数学结构 → 定理 → 证明技巧 → 示例 → 应用 → 进阶专题 → 研究前沿）
- **完全证明实现** — 零 `sorry` 占位符；所有定义和定理均在 Lean 4 中完整形式化并验证

## 构建

每个子包独立构建。使用 Lake 构建：

```bash
cd mini-bifurcation-theory
lake build
lake env lean --run Test/Smoke.lean
```

需要 **Lean 4**（v4.31.0+）和 **Lake**。

## 项目结构

```
18. mini-dynamical-ergodic-systems/
├── mini-bifurcation-theory/           # 分岔理论：定性变化、规范形、Feigenbaum 普适性
├── mini-complex-dynamics/             # 复动力系统：Julia/Fatou 集、Mandelbrot 集、有理映射迭代
├── mini-ergodic-theory/               # 遍历论：Birkhoff 定理、混合、熵、等分布
├── mini-hamiltonian-systems/          # 哈密顿系统：辛几何、Noether 定理、KAM、可积系统
├── mini-random-dynamical-systems/     # 随机动力系统：上闭链、Lyapunov 指数、MET、随机吸引子
├── mini-stability-theory/             # 稳定性理论：Lyapunov 方法、Hartman-Grobman、LaSalle、结构稳定性
├── mini-symbolic-dynamics/            # 符号动力系统：移位空间、SFT、Sofic 移位、滑动块码
├── mini-topological-dynamics/         # 拓扑动力系统：极小性、回复性、Ellis 半群、Furstenberg 结构
├── lean-toolchain                     # Lean 版本规范
├── README.md
└── README-CN.md
```

## 许可证

MIT
