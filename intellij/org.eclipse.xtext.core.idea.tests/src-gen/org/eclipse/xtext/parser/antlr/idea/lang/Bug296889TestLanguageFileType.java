package org.eclipse.xtext.parser.antlr.idea.lang;

import javax.swing.Icon;

import com.intellij.openapi.fileTypes.LanguageFileType;
import org.jetbrains.annotations.NonNls;

public final class Bug296889TestLanguageFileType extends LanguageFileType {

	public static final Bug296889TestLanguageFileType INSTANCE = new Bug296889TestLanguageFileType();
	
	@NonNls 
	public static final String DEFAULT_EXTENSION = "bug296889testlanguage";

	private Bug296889TestLanguageFileType() {
		super(Bug296889TestLanguageLanguage.INSTANCE);
	}

	@Override
	public String getDefaultExtension() {
		return DEFAULT_EXTENSION;
	}

	@Override
	public String getDescription() {
		return "Bug296889TestLanguage files";
	}

	@Override
	public Icon getIcon() {
		return null;
	}

	@Override
	public String getName() {
		return "Bug296889TestLanguage";
	}

}
