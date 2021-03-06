/*
 * generated by Xtext
 */
package org.eclipse.xtext.idea.sdomain.generator

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IGenerator
import org.eclipse.xtext.generator.IFileSystemAccess
import org.eclipse.xtext.idea.sdomain.sDomain.Entity

/**
 * Generates code from your model files on save.
 * 
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#code-generation
 */
class SDomainGenerator implements IGenerator {
	
	override void doGenerate(Resource resource, IFileSystemAccess fsa) {
		fsa.generateFile(resource.URI.trimFileExtension.lastSegment+'.txt', '''
			Entities : «resource.allContents.filter(Entity).map[name].join(', ')»
			updated «System.currentTimeMillis»
		''')
	}
}
