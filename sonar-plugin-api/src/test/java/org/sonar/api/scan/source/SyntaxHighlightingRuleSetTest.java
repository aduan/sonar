/*
 * Sonar, open source software quality management tool.
 * Copyright (C) 2008-2012 SonarSource
 * mailto:contact AT sonarsource DOT com
 *
 * Sonar is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 3 of the License, or (at your option) any later version.
 *
 * Sonar is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with Sonar; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02
 */
package org.sonar.api.scan.source;


import org.junit.Rule;
import org.junit.Test;
import org.junit.rules.ExpectedException;
import org.sonar.api.utils.SonarException;

import static org.fest.assertions.Assertions.assertThat;

public class SyntaxHighlightingRuleSetTest {

  @Rule
  public ExpectedException throwable = ExpectedException.none();

  @Test
  public void should_register_supported_highlighting_rule() throws Exception {

    SyntaxHighlightingRuleSet.Builder highlightingRuleSet = new SyntaxHighlightingRuleSet.Builder();
    highlightingRuleSet.registerHighlightingRule(1, 10, HighlightableTextType.LINE_COMMENT);
    highlightingRuleSet.registerHighlightingRule(1, 10, HighlightableTextType.LINE_COMMENT);

    assertThat(highlightingRuleSet.build().getSyntaxHighlightingRuleSet()).hasSize(2);
  }

  @Test
  public void should_reject_unsupported_highlighting_rule() throws Exception {

    throwable.expect(SonarException.class);

    SyntaxHighlightingRuleSet.Builder highlightingRuleSet = new SyntaxHighlightingRuleSet.Builder();
    highlightingRuleSet.registerHighlightingRule(1, 10, "UnsupportedTextType");
  }
}
