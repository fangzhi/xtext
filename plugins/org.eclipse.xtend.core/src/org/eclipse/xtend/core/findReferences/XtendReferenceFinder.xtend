/*******************************************************************************
 * Copyright (c) 2014 itemis AG (http://www.itemis.eu) and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *******************************************************************************/
package org.eclipse.xtend.core.findReferences

import com.google.inject.Inject
import org.eclipse.core.runtime.IProgressMonitor
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EReference
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtend.core.jvmmodel.AnonymousClassUtil
import org.eclipse.xtend.core.xtend.AnonymousClass
import org.eclipse.xtext.EcoreUtil2
import org.eclipse.xtext.common.types.JvmMember
import org.eclipse.xtext.findReferences.ReferenceFinder
import org.eclipse.xtext.findReferences.TargetURIs
import org.eclipse.xtext.resource.IResourceDescription
import org.eclipse.xtext.xbase.XAbstractFeatureCall
import org.eclipse.xtext.xbase.XFeatureCall
import org.eclipse.xtext.xbase.XMemberFeatureCall
import org.eclipse.xtext.xbase.imports.StaticallyImportedMemberProvider
import org.eclipse.xtext.xtype.XImportDeclaration

import static org.eclipse.xtext.xbase.XbasePackage.Literals.*
import static org.eclipse.xtext.xtype.XtypePackage.Literals.*
import org.eclipse.core.runtime.OperationCanceledException

/**
 * @author Sebastian Zarnekow - Initial contribution and API
 */
class XtendReferenceFinder extends ReferenceFinder {
	
	@Inject
	extension StaticallyImportedMemberProvider
	
	@Inject 
	extension AnonymousClassUtil
	
	@Inject
	Declarators declarators
	
	override findReferencesInDescription(TargetURIs targetURIs, IResourceDescription resourceDescription, IResourceAccess resourceAccess, Acceptor acceptor, IProgressMonitor monitor) {
		val names = declarators.getDeclaratorData(targetURIs, resourceAccess).declaratorNames
		if (monitor.canceled)
			throw new OperationCanceledException
		val importedNames = resourceDescription.importedNames.toSet
		if (names.exists[ importedNames.contains(it) ]) {
			resourceAccess.readOnly(resourceDescription.URI) [
				findReferences(targetURIs, getResource(resourceDescription.URI, true), acceptor, monitor)
				return null
			]
		}
	}
	
	override protected findLocalReferencesFromElement(TargetURIs targetURIs, EObject sourceCandidate, Resource localResource, Acceptor acceptor) {
		switch sourceCandidate {
			// ignore type references in package fragments
			XAbstractFeatureCall case sourceCandidate.packageFragment: return
			default: super.findLocalReferencesFromElement(targetURIs, sourceCandidate, localResource, acceptor)
		}
		switch sourceCandidate {
			XImportDeclaration case sourceCandidate.static && !sourceCandidate.wildcard: {
				addReferenceToFeatureFromStaticImport(sourceCandidate, targetURIs, acceptor)
			} 
			XFeatureCall case sourceCandidate.actualReceiver == null && sourceCandidate.static: {
				addReferenceToTypeFromStaticImport(sourceCandidate, targetURIs, acceptor)
			}
			XMemberFeatureCall: { 
				if(sourceCandidate.static && !sourceCandidate.staticWithDeclaringType) 
					addReferenceToTypeFromStaticImport(sourceCandidate, targetURIs, acceptor)
			}
			AnonymousClass: {
				addReferencesToSuper(sourceCandidate, targetURIs, acceptor)
			}
		}
	}
	
	protected def addReferencesToSuper(AnonymousClass anonymousClass, TargetURIs targetURISet, Acceptor acceptor) {
		val constructorCall = anonymousClass.constructorCall
		val superType = anonymousClass.superType
		superType?.addReferenceIfTarget(targetURISet, constructorCall, XCONSTRUCTOR_CALL__CONSTRUCTOR, acceptor)
		val superConstructor = anonymousClass.superTypeConstructor
		superConstructor?.addReferenceIfTarget(targetURISet, constructorCall, XCONSTRUCTOR_CALL__CONSTRUCTOR, acceptor)
	}
	
	protected def addReferenceToFeatureFromStaticImport(XImportDeclaration importDeclaration, TargetURIs targetURISet, Acceptor acceptor) {
		importDeclaration.allFeatures.forEach [
			addReferenceIfTarget(targetURISet, importDeclaration, XIMPORT_DECLARATION__IMPORTED_TYPE, acceptor)
		] 
	}
	
	protected def addReferenceToTypeFromStaticImport(XAbstractFeatureCall sourceCandidate, TargetURIs targetURISet, Acceptor acceptor) {
		val feature = sourceCandidate.feature
		if(feature instanceof JvmMember) {
			val type = feature.declaringType
			type.addReferenceIfTarget(targetURISet, sourceCandidate, XABSTRACT_FEATURE_CALL__FEATURE, acceptor)
		}
	}

	protected def addReferenceIfTarget(EObject candidate, TargetURIs targetURISet, EObject sourceElement, EReference reference, Acceptor acceptor) {
		val candidateURI = EcoreUtil2.getPlatformResourceOrNormalizedURI(candidate)
		if (targetURISet.contains(candidateURI)) {
			val sourceURI = EcoreUtil2.getPlatformResourceOrNormalizedURI(sourceElement)
			acceptor.accept(sourceElement, sourceURI, reference, -1, candidate, candidateURI)
		}
	}
	
}