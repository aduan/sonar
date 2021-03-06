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
package org.sonar.core.persistence;

import org.junit.Test;
import org.sonar.api.utils.Semaphores;

import static org.mockito.Matchers.anyInt;
import static org.mockito.Matchers.anyString;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

public class SemaphoresImplTest {

  @Test
  public void should_be_a_bridge_over_dao() {
    SemaphoreDao dao = mock(SemaphoreDao.class);
    SemaphoreUpdater updater = mock(SemaphoreUpdater.class);
    Semaphores.Semaphore semaphore = new Semaphores.Semaphore();
    when(dao.acquire(anyString(), anyInt())).thenReturn(semaphore);

    SemaphoresImpl impl = new SemaphoresImpl(dao, updater);

    impl.acquire("do-xxx", 50000, 10);
    verify(dao).acquire("do-xxx", 50000);

    impl.acquire("do-xxx");
    verify(dao).acquire("do-xxx");

    impl.release("do-xxx");
    verify(dao).release("do-xxx");
  }
}
