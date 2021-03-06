/*******************************************************************************
 * Copyright (c) 2015 itemis AG (http://www.itemis.eu) and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *******************************************************************************/
package org.eclipse.xtext.idea.containers

import com.intellij.psi.search.GlobalSearchScope
import org.eclipse.emf.common.util.URI
import org.eclipse.xtext.idea.resource.AbstractScopeBasedSelectable
import org.eclipse.xtext.resource.IContainer

class ResolveScopeBasedContainer extends AbstractScopeBasedSelectable implements IContainer {

	override getResourceDescriptionCount() {
		allXtextVirtualFiles.size
	}

	override hasResourceDescription(URI uri) {
		uri.findFile != null
	}
	
	override public setScope(GlobalSearchScope resolveScope) {
		super.setScope(resolveScope)
	}

}
