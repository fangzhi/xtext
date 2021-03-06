/*
 * generated by Xtext
 */
grammar PsiInternalSDomain;

options {
	superClass=AbstractPsiAntlrParser;
}

@lexer::header {
package org.eclipse.xtext.idea.sdomain.idea.parser.antlr.internal;

// Hack: Use our own Lexer superclass by means of import. 
// Currently there is no other way to specify the superclass for the lexer.
import org.eclipse.xtext.parser.antlr.Lexer;
}

@parser::header {
package org.eclipse.xtext.idea.sdomain.idea.parser.antlr.internal;

import org.eclipse.xtext.idea.parser.AbstractPsiAntlrParser;
import org.eclipse.xtext.idea.sdomain.idea.lang.SDomainElementTypeProvider;
import org.eclipse.xtext.idea.parser.TokenTypeProvider;
import org.eclipse.xtext.parser.antlr.XtextTokenStream;
import org.eclipse.xtext.parser.antlr.XtextTokenStream.HiddenTokens;
import org.eclipse.xtext.idea.sdomain.services.SDomainGrammarAccess;

import com.intellij.lang.PsiBuilder;
}

@parser::members {

	protected SDomainGrammarAccess grammarAccess;

	protected SDomainElementTypeProvider elementTypeProvider;

	public PsiInternalSDomainParser(PsiBuilder builder, TokenStream input, SDomainElementTypeProvider elementTypeProvider, SDomainGrammarAccess grammarAccess) {
		this(input);
		setPsiBuilder(builder);
    	this.grammarAccess = grammarAccess;
		this.elementTypeProvider = elementTypeProvider;
	}

	@Override
	protected String getFirstRuleName() {
		return "File";
	}

}

//Entry rule entryRuleFile
entryRuleFile:
	{ markComposite(elementTypeProvider.getFileElementType()); }
	ruleFile
	EOF;

// Rule File
ruleFile:
	(
		(
			{
				markComposite(elementTypeProvider.getFile_ElementsElementParserRuleCall_0ElementType());
			}
			lv_elements_0_0=ruleElement
			{
				doneComposite();
			}
		)
	)*
;

//Entry rule entryRuleImport
entryRuleImport:
	{ markComposite(elementTypeProvider.getImportElementType()); }
	ruleImport
	EOF;

// Rule Import
ruleImport:
	(
		{
			markLeaf(elementTypeProvider.getImport_ImportKeyword_0ElementType());
		}
		otherlv_0='import'
		{
			doneLeaf(otherlv_0);
		}
		(
			(
				{
					markComposite(elementTypeProvider.getImport_ImportedNamespaceQualifiedNameWithWildCardParserRuleCall_1_0ElementType());
				}
				lv_importedNamespace_1_0=ruleQualifiedNameWithWildCard
				{
					doneComposite();
				}
			)
		)
	)
;

//Entry rule entryRuleQualifiedNameWithWildCard
entryRuleQualifiedNameWithWildCard:
	{ markComposite(elementTypeProvider.getQualifiedNameWithWildCardElementType()); }
	ruleQualifiedNameWithWildCard
	EOF;

// Rule QualifiedNameWithWildCard
ruleQualifiedNameWithWildCard:
	(
		{
			markComposite(elementTypeProvider.getQualifiedNameWithWildCard_QualifiedNameParserRuleCall_0ElementType());
		}
		ruleQualifiedName
		{
			doneComposite();
		}
		(
			{
				markLeaf(elementTypeProvider.getQualifiedNameWithWildCard_FullStopAsteriskKeyword_1ElementType());
			}
			kw='.*'
			{
				doneLeaf(kw);
			}
		)?
	)
;

//Entry rule entryRuleQualifiedName
entryRuleQualifiedName:
	{ markComposite(elementTypeProvider.getQualifiedNameElementType()); }
	ruleQualifiedName
	EOF;

// Rule QualifiedName
ruleQualifiedName:
	(
		{
			markLeaf(elementTypeProvider.getQualifiedName_IDTerminalRuleCall_0ElementType());
		}
		this_ID_0=RULE_ID
		{
			doneLeaf(this_ID_0);
		}
		(
			{
				markLeaf(elementTypeProvider.getQualifiedName_FullStopKeyword_1_0ElementType());
			}
			kw='.'
			{
				doneLeaf(kw);
			}
			{
				markLeaf(elementTypeProvider.getQualifiedName_IDTerminalRuleCall_1_1ElementType());
			}
			this_ID_2=RULE_ID
			{
				doneLeaf(this_ID_2);
			}
		)*
	)
;

//Entry rule entryRuleNamespace
entryRuleNamespace:
	{ markComposite(elementTypeProvider.getNamespaceElementType()); }
	ruleNamespace
	EOF;

// Rule Namespace
ruleNamespace:
	(
		(
			(
				{
					markComposite(elementTypeProvider.getNamespace_NameQualifiedNameParserRuleCall_0_0ElementType());
				}
				lv_name_0_0=ruleQualifiedName
				{
					doneComposite();
				}
			)
		)
		{
			markLeaf(elementTypeProvider.getNamespace_LeftCurlyBracketKeyword_1ElementType());
		}
		otherlv_1='{'
		{
			doneLeaf(otherlv_1);
		}
		(
			(
				{
					markComposite(elementTypeProvider.getNamespace_ElementsElementParserRuleCall_2_0ElementType());
				}
				lv_elements_2_0=ruleElement
				{
					doneComposite();
				}
			)
		)*
		{
			markLeaf(elementTypeProvider.getNamespace_RightCurlyBracketKeyword_3ElementType());
		}
		otherlv_3='}'
		{
			doneLeaf(otherlv_3);
		}
	)
;

//Entry rule entryRuleElement
entryRuleElement:
	{ markComposite(elementTypeProvider.getElementElementType()); }
	ruleElement
	EOF;

// Rule Element
ruleElement:
	(
		{
			markComposite(elementTypeProvider.getElement_NamespaceParserRuleCall_0ElementType());
		}
		ruleNamespace
		{
			doneComposite();
		}
		    |
		{
			markComposite(elementTypeProvider.getElement_TypeParserRuleCall_1ElementType());
		}
		ruleType
		{
			doneComposite();
		}
		    |
		{
			markComposite(elementTypeProvider.getElement_ImportParserRuleCall_2ElementType());
		}
		ruleImport
		{
			doneComposite();
		}
	)
;

//Entry rule entryRuleType
entryRuleType:
	{ markComposite(elementTypeProvider.getTypeElementType()); }
	ruleType
	EOF;

// Rule Type
ruleType:
	(
		{
			markComposite(elementTypeProvider.getType_EntityParserRuleCall_0ElementType());
		}
		ruleEntity
		{
			doneComposite();
		}
		    |
		{
			markComposite(elementTypeProvider.getType_DatatypeParserRuleCall_1ElementType());
		}
		ruleDatatype
		{
			doneComposite();
		}
	)
;

//Entry rule entryRuleEntity
entryRuleEntity:
	{ markComposite(elementTypeProvider.getEntityElementType()); }
	ruleEntity
	EOF;

// Rule Entity
ruleEntity:
	(
		{
			markLeaf(elementTypeProvider.getEntity_EntityKeyword_0ElementType());
		}
		otherlv_0='entity'
		{
			doneLeaf(otherlv_0);
		}
		(
			(
				{
					markLeaf(elementTypeProvider.getEntity_NameIDTerminalRuleCall_1_0ElementType());
				}
				lv_name_1_0=RULE_ID
				{
					doneLeaf(lv_name_1_0);
				}
			)
		)
		{
			markLeaf(elementTypeProvider.getEntity_LeftCurlyBracketKeyword_2ElementType());
		}
		otherlv_2='{'
		{
			doneLeaf(otherlv_2);
		}
		(
			(
				{
					markComposite(elementTypeProvider.getEntity_PropertiesPropertyParserRuleCall_3_0ElementType());
				}
				lv_properties_3_0=ruleProperty
				{
					doneComposite();
				}
			)
		)*
		{
			markLeaf(elementTypeProvider.getEntity_RightCurlyBracketKeyword_4ElementType());
		}
		otherlv_4='}'
		{
			doneLeaf(otherlv_4);
		}
	)
;

//Entry rule entryRuleDatatype
entryRuleDatatype:
	{ markComposite(elementTypeProvider.getDatatypeElementType()); }
	ruleDatatype
	EOF;

// Rule Datatype
ruleDatatype:
	(
		{
			markLeaf(elementTypeProvider.getDatatype_DatatypeKeyword_0ElementType());
		}
		otherlv_0='datatype'
		{
			doneLeaf(otherlv_0);
		}
		(
			(
				{
					markLeaf(elementTypeProvider.getDatatype_NameIDTerminalRuleCall_1_0ElementType());
				}
				lv_name_1_0=RULE_ID
				{
					doneLeaf(lv_name_1_0);
				}
			)
		)
	)
;

//Entry rule entryRuleProperty
entryRuleProperty:
	{ markComposite(elementTypeProvider.getPropertyElementType()); }
	ruleProperty
	EOF;

// Rule Property
ruleProperty:
	(
		(
			(
				{
					markComposite(elementTypeProvider.getProperty_TypeTypeCrossReference_0_0ElementType());
				}
				ruleQualifiedName
				{
					doneComposite();
				}
			)
		)
		(
			(
				{
					markLeaf(elementTypeProvider.getProperty_NameIDTerminalRuleCall_1_0ElementType());
				}
				lv_name_1_0=RULE_ID
				{
					doneLeaf(lv_name_1_0);
				}
			)
		)
	)
;

RULE_ID : '^'? ('a'..'z'|'A'..'Z'|'_') ('a'..'z'|'A'..'Z'|'_'|'0'..'9')*;

RULE_INT : ('0'..'9')+;

RULE_STRING : ('"' ('\\' .|~(('\\'|'"')))* '"'|'\'' ('\\' .|~(('\\'|'\'')))* '\'');

RULE_ML_COMMENT : '/*' ( options {greedy=false;} : . )*'*/';

RULE_SL_COMMENT : '//' ~(('\n'|'\r'))* ('\r'? '\n')?;

RULE_WS : (' '|'\t'|'\r'|'\n')+;

RULE_ANY_OTHER : .;
