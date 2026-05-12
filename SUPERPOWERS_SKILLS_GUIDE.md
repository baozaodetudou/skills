# Superpowers Skills 说明 / Superpowers Skills Guide

## 概述 / Overview

Superpowers 是一个**语言无关的开发方法论框架**，包含 14 个核心 skills，适用于所有编程语言。

**重要**: Superpowers 的 skills 不是语言特定的工具，而是通用的开发工作流和最佳实践。

---

## 📦 默认包含的 Skills（14 个）

### 1. **brainstorming**
**用途**: 功能开发前的头脑风暴和需求分析

**何时使用**:
- 开始新功能开发前
- 需求不明确时
- 需要探索多种方案时

**语言无关**: ✅ 适用于所有语言

---

### 2. **test-driven-development (TDD)**
**用途**: 测试驱动开发工作流

**核心原则**:
```
NO PRODUCTION CODE WITHOUT A FAILING TEST FIRST
```

**工作流**:
1. RED - 写失败的测试
2. GREEN - 写最小代码使测试通过
3. REFACTOR - 重构优化

**何时使用**:
- 新功能开发
- Bug 修复
- 重构
- 行为变更

**语言支持**: ✅ 所有语言
- Python: pytest, unittest
- Rust: cargo test
- Go: go test
- TypeScript/JavaScript: Jest, Vitest, Mocha
- 任何有测试框架的语言

---

### 3. **systematic-debugging**
**用途**: 系统化调试流程

**核心原则**:
```
NO FIXES WITHOUT ROOT CAUSE INVESTIGATION FIRST
```

**四个阶段**:
1. 根因调查
2. 假设形成
3. 验证假设
4. 实施修复

**何时使用**:
- 任何 bug
- 测试失败
- 意外行为
- 性能问题
- 构建失败

**语言无关**: ✅ 适用于所有语言

---

### 4. **subagent-driven-development**
**用途**: 使用子代理进行开发

**工作流**:
- 规范审查
- 实现
- 代码质量审查

**何时使用**:
- 复杂功能开发
- 需要多角度审查
- 大型重构

**语言无关**: ✅ 适用于所有语言

---

### 5. **writing-plans**
**用途**: 编写实施计划

**何时使用**:
- 复杂功能开发前
- 需要与团队对齐
- 多步骤任务

**语言无关**: ✅ 适用于所有语言

---

### 6. **executing-plans**
**用途**: 执行已制定的计划

**何时使用**:
- 有明确计划后
- 分步实施

**语言无关**: ✅ 适用于所有语言

---

### 7. **requesting-code-review**
**用途**: 请求代码审查

**何时使用**:
- 代码完成后
- 提交 PR 前

**语言无关**: ✅ 适用于所有语言

---

### 8. **receiving-code-review**
**用途**: 接收和处理代码审查反馈

**何时使用**:
- 收到审查反馈后

**语言无关**: ✅ 适用于所有语言

---

### 9. **verification-before-completion**
**用途**: 完成前的验证检查

**何时使用**:
- 任务完成前
- 提交代码前

**语言无关**: ✅ 适用于所有语言

---

### 10. **using-git-worktrees**
**用途**: 使用 Git worktree 管理多分支

**何时使用**:
- 需要同时处理多个分支
- 需要快速切换上下文

**语言无关**: ✅ 适用于所有语言

---

### 11. **finishing-a-development-branch**
**用途**: 完成开发分支的收尾工作

**何时使用**:
- 分支开发完成
- 准备合并前

**语言无关**: ✅ 适用于所有语言

---

### 12. **dispatching-parallel-agents**
**用途**: 派发并行子代理

**何时使用**:
- 需要并行处理多个独立任务
- 需要多角度分析

**语言无关**: ✅ 适用于所有语言

---

### 13. **writing-skills**
**用途**: 编写新的 skills

**何时使用**:
- 需要创建自定义 skill
- 扩展 Superpowers

**语言无关**: ✅ 适用于所有语言

---

### 14. **using-superpowers**
**用途**: Superpowers 使用指南

**何时使用**:
- 首次使用 Superpowers
- 需要了解工作流

**语言无关**: ✅ 适用于所有语言

---

## ❓ 常见问题 / FAQ

### Q1: 需要为 Python/Rust/Go/TS/JS 安装额外的 skills 吗？

**A**: ❌ **不需要**

Superpowers 的 skills 是**语言无关的开发方法论**，不是语言特定的工具。

例如：
- `test-driven-development` skill 教你 TDD 工作流，适用于任何有测试框架的语言
- `systematic-debugging` skill 教你系统化调试方法，适用于任何语言
- `brainstorming` skill 教你需求分析，与语言无关

### Q2: 如何在不同语言中使用这些 skills？

**A**: Skills 会根据项目自动适配

例如，使用 `test-driven-development` skill 时：
- **Python 项目**: 会使用 pytest 或 unittest
- **Rust 项目**: 会使用 cargo test
- **Go 项目**: 会使用 go test
- **TypeScript 项目**: 会使用 Jest 或 Vitest

Skills 提供的是**方法论**，具体工具由项目决定。

### Q3: 示例代码中的 TypeScript 是什么意思？

**A**: 仅用于示例说明

Skills 文档中的代码示例（如 TypeScript）只是为了说明概念，不代表只支持该语言。

同样的原则适用于所有语言：
```typescript
// TypeScript 示例
test('retries 3 times', () => { ... })
```

等价于：
```python
# Python
def test_retries_3_times(): ...
```

```rust
// Rust
#[test]
fn test_retries_3_times() { ... }
```

```go
// Go
func TestRetries3Times(t *testing.T) { ... }
```

### Q4: 需要配置语言特定的设置吗？

**A**: ❌ **不需要**

Superpowers 是零配置的。它会：
1. 检测项目使用的语言
2. 检测项目使用的工具（测试框架、构建工具等）
3. 自动适配到项目环境

### Q5: 如果我的项目使用多种语言怎么办？

**A**: ✅ **完全支持**

Superpowers 的 skills 是语言无关的，可以在同一个项目中处理多种语言：
- 前端: TypeScript/JavaScript
- 后端: Python/Rust/Go
- 移动端: Swift/Kotlin

每个 skill 都会根据当前处理的文件自动适配。

---

## 🎯 使用建议 / Usage Recommendations

### 常用语言的最佳实践

#### Python
- ✅ 使用 `test-driven-development` + pytest
- ✅ 使用 `systematic-debugging` + pdb
- ✅ 使用 `verification-before-completion` + mypy/ruff

#### Rust
- ✅ 使用 `test-driven-development` + cargo test
- ✅ 使用 `systematic-debugging` + cargo check
- ✅ 使用 `verification-before-completion` + clippy

#### Go
- ✅ 使用 `test-driven-development` + go test
- ✅ 使用 `systematic-debugging` + delve
- ✅ 使用 `verification-before-completion` + go vet

#### TypeScript/JavaScript
- ✅ 使用 `test-driven-development` + Jest/Vitest
- ✅ 使用 `systematic-debugging` + Chrome DevTools
- ✅ 使用 `verification-before-completion` + ESLint/TypeScript

---

## 📊 Skills 分类 / Skills Categories

### 规划类 / Planning
- `brainstorming` - 头脑风暴
- `writing-plans` - 编写计划
- `executing-plans` - 执行计划

### 开发类 / Development
- `test-driven-development` - TDD 工作流
- `subagent-driven-development` - 子代理开发
- `using-git-worktrees` - Git worktree 管理

### 调试类 / Debugging
- `systematic-debugging` - 系统化调试

### 审查类 / Review
- `requesting-code-review` - 请求审查
- `receiving-code-review` - 接收审查
- `verification-before-completion` - 完成前验证

### 协作类 / Collaboration
- `dispatching-parallel-agents` - 并行代理
- `finishing-a-development-branch` - 完成分支

### 元类 / Meta
- `using-superpowers` - 使用指南
- `writing-skills` - 编写 skills

---

## ✅ 总结 / Summary

### 核心要点

1. ✅ **Superpowers 是语言无关的**
   - 不需要为特定语言安装额外 skills
   - 所有 14 个 skills 适用于所有语言

2. ✅ **Skills 是方法论，不是工具**
   - 教你如何开发，而不是使用什么工具
   - 自动适配项目环境

3. ✅ **零配置**
   - 安装后即可使用
   - 自动检测语言和工具

4. ✅ **多语言支持**
   - Python, Rust, Go, TypeScript, JavaScript
   - 以及任何其他语言

### 默认安装已包含所有必要的 skills

安装 Superpowers 后，你已经拥有：
- ✅ 14 个核心 skills
- ✅ 支持所有常用语言
- ✅ 完整的开发工作流
- ✅ 零额外配置

**不需要安装任何额外的语言特定 skills！**
