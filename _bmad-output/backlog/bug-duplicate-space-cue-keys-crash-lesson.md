---
id: 6
type: bug
title: "Lesson crashes when multiple incorrect spaces are shown"
parent: none
covers: []
after: []
assignee: ""
refined: true
hitl: false
risk: medium
severity: P2
estimate: ""
---

# Lesson crashes when multiple incorrect spaces are shown

## Description

During a typing lesson, the text display throws a Flutter duplicate-key assertion when more than one word chunk shows an incorrect space cue. The lesson should continue to display feedback for every mistyped space without an exception.

## Reproduction

1. Run the macOS app in Flutter debug mode and open a typing lesson with at least three words.
2. Mistype the space after the first word, then continue until the space after the second word.
3. Mistype that space too, leaving both spaces marked incorrect.
4. Actual, as reported: Flutter asserts `Duplicate keys found` because the lesson text's `Wrap` has multiple children keyed `[<'space-cue-incorrect'>]`; the relevant widget is the lesson display's `Container`. Expected: both incorrect spaces remain visible and the lesson continues without an exception.

## Cause Hypothesis

Each word chunk containing an incorrect space gets a cue widget keyed only by the cue state. Separate chunks with incorrect spaces can therefore become siblings with the same key. Confirm this against the reported lesson and typing sequence before choosing a correction.

## Acceptance Criteria

1. **Multiple incorrect spaces do not interrupt a lesson**
   **Given** a lesson with at least two spaces in different word chunks
   **When** the learner mistypes both spaces and continues typing
   **Then** feedback for each space remains visible and the lesson does not throw an exception.
2. **Tests cover the condition found and fixed**
   **Given** the lesson display tests
   **When** they run
   **Then** a regression test that fails on the reported behavior and passes after correction covers multiple incorrect spaces in separate word chunks, and tests cover other cue states affected by the change.
3. **Or: no change is needed, with proof**
   **Given** the reported assertion
   **When** the typing sequence is reproduced on current code
   **Then** the lesson already works without duplicate keys, or the report is mistaken, with evidence recorded in Notes; this supersedes criteria 1 and 2.

## References

- parent — none

## Notes

- Reported assertion: `Wrap ... has multiple children with key [<'space-cue-incorrect'>]`; the stack identifies `Container` at `lib/widgets/typing_display.dart:134`.
- Assumption: the crash occurred in a macOS debug lesson with two incorrect spaces in different word chunks; the exact lesson, inputs, and platform of the original report were not provided. Confirm the reproduction when this ticket is picked up.
- Risk: the lesson display is shared across exercises, so a change could affect feedback or wrapping elsewhere.
- Severity: this interrupts typing under a specific error sequence; other lessons or a fresh attempt remain available.

## Original Stack Trace

```text
══╡ EXCEPTION CAUGHT BY WIDGETS LIBRARY ╞═══════════════════════════════════════════════════════════
The following assertion was thrown building Container(padding: EdgeInsets(18.6, 15.5, 18.6, 15.5),
bg:
      BoxDecoration(color: Color(alpha: 1.0000, red: 1.0000, green: 1.0000, blue: 1.0000, colorSpace:
ColorSpace.sRGB), border: Border.all(BorderSide(color: Color(alpha: 1.0000, red: 0.5059, green:
0.7804, blue: 0.5176, colorSpace: ColorSpace.sRGB), width: 2.0)), borderRadius:
BorderRadius.circular(16.0),
         boxShadow: [BoxShadow(Color(alpha: 0.1000, red: 0.2980, green:
            0.6863, blue: 0.3137, colorSpace: ColorSpace.sRGB), Offset(0.0,
            4.0), 12.0, 0.0, BlurStyle.normal)]
         )
   , constraints: BoxConstraints(w=Infinity, 0.0<=h<=Infinity)):
Duplicate keys found.
If multiple keyed widgets exist as children of another widget, they must have unique keys.
Wrap(direction: horizontal, alignment: center, spacing: 0.0, runAlignment: center, runSpacing: 0.0,
crossAxisAlignment: start) has multiple children with key [<'space-cue-incorrect'>].

The relevant error-causing widget was:
   Container
   Container:file:///Users/nico/repos/side-projects/typer_kids/lib/widgets/typing_display.dart:134:12

When the exception was thrown, this was the stack:
#0      debugChildrenHaveDuplicateKeys.<anonymous closure> (package:flutter/src/widgets/debug.dart:243:7)
#1      debugChildrenHaveDuplicateKeys (package:flutter/src/widgets/debug.dart:250:4)
#2      MultiChildRenderObjectElement.update (package:flutter/src/widgets/framework.dart:7307:13)
#3      Element.updateChild (package:flutter/src/widgets/framework.dart:4050:15)
#4      SingleChildRenderObjectElement.update (package:flutter/src/widgets/framework.dart:7135:14)
#5      Element.updateChild (package:flutter/src/widgets/framework.dart:4050:15)
#6      SingleChildRenderObjectElement.update (package:flutter/src/widgets/framework.dart:7135:14)
#7      Element.updateChild (package:flutter/src/widgets/framework.dart:4050:15)
#8      SingleChildRenderObjectElement.update (package:flutter/src/widgets/framework.dart:7135:14)
#9      Element.updateChild (package:flutter/src/widgets/framework.dart:4050:15)
#10     ComponentElement.performRebuild (package:flutter/src/widgets/framework.dart:5854:16)
#11     Element.rebuild (package:flutter/src/widgets/framework.dart:5542:7)
#12     StatelessElement.update (package:flutter/src/widgets/framework.dart:5908:5)
#13     Element.updateChild (package:flutter/src/widgets/framework.dart:4050:15)
#14     ComponentElement.performRebuild (package:flutter/src/widgets/framework.dart:5854:16)
#15     Element.rebuild (package:flutter/src/widgets/framework.dart:5542:7)
#16     StatelessElement.update (package:flutter/src/widgets/framework.dart:5908:5)
#17     Element.updateChild (package:flutter/src/widgets/framework.dart:4050:15)
#18     SingleChildRenderObjectElement.update (package:flutter/src/widgets/framework.dart:7135:14)
#19     Element.updateChild (package:flutter/src/widgets/framework.dart:4050:15)
#20     SingleChildRenderObjectElement.update (package:flutter/src/widgets/framework.dart:7135:14)
#21     Element.updateChild (package:flutter/src/widgets/framework.dart:4050:15)
#22     ComponentElement.performRebuild (package:flutter/src/widgets/framework.dart:5854:16)
#23     Element.rebuild (package:flutter/src/widgets/framework.dart:5542:7)
#24     ProxyElement.update (package:flutter/src/widgets/framework.dart:6162:5)
#25     Element.updateChild (package:flutter/src/widgets/framework.dart:4050:15)
#26     Element.updateChildren (package:flutter/src/widgets/framework.dart:4204:32)
#27     MultiChildRenderObjectElement.update (package:flutter/src/widgets/framework.dart:7308:17)
#28     Element.updateChild (package:flutter/src/widgets/framework.dart:4050:15)
#29     _LayoutBuilderElement._rebuildWithConstraints.updateChildCallback (package:flutter/src/widgets/layout_builder.dart:247:18)
#30     BuildOwner.buildScope (package:flutter/src/widgets/framework.dart:3114:19)
#31     _LayoutBuilderElement._rebuildWithConstraints (package:flutter/src/widgets/layout_builder.dart:270:12)
#32     RenderAbstractLayoutBuilderMixin.layoutCallback (package:flutter/src/widgets/layout_builder.dart:333:38)
#33     RenderObjectWithLayoutCallbackMixin.runLayoutCallback.<anonymous closure> (package:flutter/src/rendering/object.dart:4313:33)
#34     RenderObject.invokeLayoutCallback.<anonymous closure> (package:flutter/src/rendering/object.dart:3042:17)
#35     PipelineOwner._enableMutationsToDirtySubtrees (package:flutter/src/rendering/object.dart:1223:15)
#36     RenderObject.invokeLayoutCallback (package:flutter/src/rendering/object.dart:3041:14)
#37     RenderObjectWithLayoutCallbackMixin.runLayoutCallback (package:flutter/src/rendering/object.dart:4313:5)
#38     _RenderLayoutBuilder.performLayout (package:flutter/src/widgets/layout_builder.dart:447:5)
#39     RenderObject.layout (package:flutter/src/rendering/object.dart:2923:7)
#40     RenderPadding.performLayout (package:flutter/src/rendering/shifted_box.dart:262:12)
#41     RenderObject.layout (package:flutter/src/rendering/object.dart:2923:7)
#42     RenderProxyBoxMixin.performLayout (package:flutter/src/rendering/proxy_box.dart:118:18)
#43     RenderObject.layout (package:flutter/src/rendering/object.dart:2923:7)
#44     RenderProxyBoxMixin.performLayout (package:flutter/src/rendering/proxy_box.dart:118:18)
#45     RenderObject.layout (package:flutter/src/rendering/object.dart:2923:7)
#46     RenderProxyBoxMixin.performLayout (package:flutter/src/rendering/proxy_box.dart:118:18)
#47     RenderObject.layout (package:flutter/src/rendering/object.dart:2923:7)
#48     MultiChildLayoutDelegate.layoutChild (package:flutter/src/rendering/custom_layout.dart:180:12)
#49     _ScaffoldLayout.performLayout (package:flutter/src/material/scaffold.dart:1113:7)
#50     MultiChildLayoutDelegate._callPerformLayout (package:flutter/src/rendering/custom_layout.dart:246:7)
#51     RenderCustomMultiChildLayoutBox.performLayout (package:flutter/src/rendering/custom_layout.dart:417:14)
#52     RenderObject._layoutWithoutResize (package:flutter/src/rendering/object.dart:2771:7)
#53     PipelineOwner.flushLayout (package:flutter/src/rendering/object.dart:1174:18)
#54     PipelineOwner.flushLayout (package:flutter/src/rendering/object.dart:1187:15)
#55     RendererBinding.drawFrame (package:flutter/src/rendering/binding.dart:692:23)
#56     WidgetsBinding.drawFrame (package:flutter/src/widgets/binding.dart:1573:13)
#57     RendererBinding._handlePersistentFrameCallback (package:flutter/src/rendering/binding.dart:558:5)
#58     SchedulerBinding._invokeFrameCallback (package:flutter/src/scheduler/binding.dart:1430:15)
#59     SchedulerBinding.handleDrawFrame (package:flutter/src/scheduler/binding.dart:1345:9)
#60     SchedulerBinding._handleDrawFrame (package:flutter/src/scheduler/binding.dart:1198:5)
#61     _invoke (dart:ui/hooks.dart:441:13)
#62     PlatformDispatcher._drawFrame (dart:ui/platform_dispatcher.dart:450:5)
#63     _drawFrame (dart:ui/hooks.dart:413:31)

════════════════════════════════════════════════════════════════════════════════════════════════════
```