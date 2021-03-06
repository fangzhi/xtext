/**
 * Copyright (c) 2013 itemis AG (http://www.itemis.eu) and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 */
package org.eclipse.xtend.ide.macro;

import com.google.common.base.Objects;
import com.google.common.collect.Iterables;
import java.io.Closeable;
import java.io.File;
import java.io.IOException;
import java.net.URL;
import java.net.URLClassLoader;
import java.util.HashSet;
import java.util.LinkedHashSet;
import java.util.Set;
import org.apache.log4j.Logger;
import org.eclipse.core.resources.IProject;
import org.eclipse.core.resources.IResource;
import org.eclipse.core.resources.IWorkspace;
import org.eclipse.core.resources.IWorkspaceRoot;
import org.eclipse.core.runtime.IPath;
import org.eclipse.emf.common.notify.Adapter;
import org.eclipse.emf.common.notify.Notifier;
import org.eclipse.emf.common.notify.impl.AdapterImpl;
import org.eclipse.emf.common.util.EList;
import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.ecore.resource.Resource;
import org.eclipse.emf.ecore.resource.ResourceSet;
import org.eclipse.jdt.core.IClasspathEntry;
import org.eclipse.jdt.core.IJavaProject;
import org.eclipse.jdt.core.JavaCore;
import org.eclipse.xtend.core.macro.ProcessorInstanceForJvmTypeProvider;
import org.eclipse.xtend.lib.annotations.Accessors;
import org.eclipse.xtend.lib.macro.TransformationContext;
import org.eclipse.xtext.common.types.JvmType;
import org.eclipse.xtext.resource.ResourceSetContext;
import org.eclipse.xtext.resource.XtextResourceSet;
import org.eclipse.xtext.xbase.lib.CollectionLiterals;
import org.eclipse.xtext.xbase.lib.Conversions;
import org.eclipse.xtext.xbase.lib.Exceptions;
import org.eclipse.xtext.xbase.lib.IterableExtensions;
import org.eclipse.xtext.xbase.lib.Pure;

@SuppressWarnings("all")
public class JdtBasedProcessorProvider extends ProcessorInstanceForJvmTypeProvider {
  @Accessors
  public static class ProcessorClassloaderAdapter extends AdapterImpl {
    private ClassLoader classLoader;
    
    public ProcessorClassloaderAdapter(final ClassLoader classLoader) {
      this.classLoader = classLoader;
    }
    
    @Override
    public boolean isAdapterForType(final Object type) {
      return Objects.equal(type, JdtBasedProcessorProvider.ProcessorClassloaderAdapter.class);
    }
    
    @Override
    public void unsetTarget(final Notifier oldTarget) {
      this.discard();
    }
    
    @Override
    public void setTarget(final Notifier newTarget) {
      boolean _equals = Objects.equal(newTarget, null);
      if (_equals) {
        this.discard();
      }
    }
    
    public ClassLoader discard() {
      ClassLoader _xifexpression = null;
      if ((this.classLoader instanceof Closeable)) {
        ClassLoader _xtrycatchfinallyexpression = null;
        try {
          ClassLoader _xblockexpression = null;
          {
            ((Closeable) this.classLoader).close();
            _xblockexpression = this.classLoader = null;
          }
          _xtrycatchfinallyexpression = _xblockexpression;
        } catch (final Throwable _t) {
          if (_t instanceof IOException) {
            final IOException e = (IOException)_t;
            String _message = e.getMessage();
            JdtBasedProcessorProvider.LOG.error(_message, e);
          } else {
            throw Exceptions.sneakyThrow(_t);
          }
        }
        _xifexpression = _xtrycatchfinallyexpression;
      }
      return _xifexpression;
    }
    
    @Pure
    public ClassLoader getClassLoader() {
      return this.classLoader;
    }
    
    public void setClassLoader(final ClassLoader classLoader) {
      this.classLoader = classLoader;
    }
  }
  
  private final static Logger LOG = Logger.getLogger(JdtBasedProcessorProvider.class);
  
  @Override
  public Object getProcessorInstance(final JvmType type) {
    try {
      final ClassLoader classLoader = this.getClassLoader(type);
      String _identifier = type.getIdentifier();
      final Class<?> result = classLoader.loadClass(_identifier);
      return result.newInstance();
    } catch (final Throwable _t) {
      if (_t instanceof Exception) {
        final Exception e = (Exception)_t;
        String _identifier_1 = type.getIdentifier();
        String _plus = ("Problem during instantiation of " + _identifier_1);
        String _plus_1 = (_plus + " : ");
        String _message = e.getMessage();
        String _plus_2 = (_plus_1 + _message);
        throw new IllegalStateException(_plus_2, e);
      } else {
        throw Exceptions.sneakyThrow(_t);
      }
    }
  }
  
  @Override
  public ClassLoader getClassLoader(final EObject ctx) {
    Resource _eResource = ctx.eResource();
    ResourceSet _resourceSet = _eResource.getResourceSet();
    final XtextResourceSet rs = ((XtextResourceSet) _resourceSet);
    ResourceSetContext _get = ResourceSetContext.get(rs);
    final boolean isBuilder = _get.isBuilder();
    ResourceSetContext _get_1 = ResourceSetContext.get(rs);
    final boolean isEditor = _get_1.isEditor();
    if (isBuilder) {
      EList<Adapter> _eAdapters = rs.eAdapters();
      Iterable<JdtBasedProcessorProvider.ProcessorClassloaderAdapter> _filter = Iterables.<JdtBasedProcessorProvider.ProcessorClassloaderAdapter>filter(_eAdapters, JdtBasedProcessorProvider.ProcessorClassloaderAdapter.class);
      final JdtBasedProcessorProvider.ProcessorClassloaderAdapter adapter = IterableExtensions.<JdtBasedProcessorProvider.ProcessorClassloaderAdapter>head(_filter);
      boolean _notEquals = (!Objects.equal(adapter, null));
      if (_notEquals) {
        return adapter.classLoader;
      }
    }
    if (isEditor) {
      Resource _editorResource = this.getEditorResource(ctx);
      EList<Adapter> _eAdapters_1 = _editorResource.eAdapters();
      Iterable<JdtBasedProcessorProvider.ProcessorClassloaderAdapter> _filter_1 = Iterables.<JdtBasedProcessorProvider.ProcessorClassloaderAdapter>filter(_eAdapters_1, JdtBasedProcessorProvider.ProcessorClassloaderAdapter.class);
      final JdtBasedProcessorProvider.ProcessorClassloaderAdapter adapter_1 = IterableExtensions.<JdtBasedProcessorProvider.ProcessorClassloaderAdapter>head(_filter_1);
      boolean _notEquals_1 = (!Objects.equal(adapter_1, null));
      if (_notEquals_1) {
        boolean _equals = Objects.equal(adapter_1.classLoader, null);
        if (_equals) {
          Resource _editorResource_1 = this.getEditorResource(ctx);
          EList<Adapter> _eAdapters_2 = _editorResource_1.eAdapters();
          _eAdapters_2.remove(adapter_1);
        } else {
          return adapter_1.classLoader;
        }
      }
    }
    Object _classpathURIContext = rs.getClasspathURIContext();
    final IJavaProject project = ((IJavaProject) _classpathURIContext);
    final URLClassLoader classloader = this.createClassLoaderForJavaProject(project);
    if (isBuilder) {
      EList<Adapter> _eAdapters_3 = rs.eAdapters();
      JdtBasedProcessorProvider.ProcessorClassloaderAdapter _processorClassloaderAdapter = new JdtBasedProcessorProvider.ProcessorClassloaderAdapter(classloader);
      _eAdapters_3.add(_processorClassloaderAdapter);
    }
    if (isEditor) {
      Resource _editorResource_2 = this.getEditorResource(ctx);
      EList<Adapter> _eAdapters_4 = _editorResource_2.eAdapters();
      JdtBasedProcessorProvider.ProcessorClassloaderAdapter _processorClassloaderAdapter_1 = new JdtBasedProcessorProvider.ProcessorClassloaderAdapter(classloader);
      _eAdapters_4.add(_processorClassloaderAdapter_1);
    }
    return classloader;
  }
  
  private Resource getEditorResource(final EObject ctx) {
    Resource _eResource = ctx.eResource();
    ResourceSet _resourceSet = _eResource.getResourceSet();
    EList<Resource> _resources = _resourceSet.getResources();
    return IterableExtensions.<Resource>head(_resources);
  }
  
  /**
   * Construct a Classloader with the classpathentries from the provided and all upstream-projects,
   * except the output folders of the local project.
   */
  protected URLClassLoader createClassLoaderForJavaProject(final IJavaProject projectToUse) {
    final LinkedHashSet<URL> urls = CollectionLiterals.<URL>newLinkedHashSet();
    HashSet<IJavaProject> _newHashSet = CollectionLiterals.<IJavaProject>newHashSet();
    this.collectClasspathURLs(projectToUse, urls, false, _newHashSet);
    ClassLoader _parentClassLoader = this.getParentClassLoader();
    return new URLClassLoader(((URL[])Conversions.unwrapArray(urls, URL.class)), _parentClassLoader);
  }
  
  protected void collectClasspathURLs(final IJavaProject projectToUse, final LinkedHashSet<URL> result, final boolean includeOutputFolder, final Set<IJavaProject> visited) {
    try {
      boolean _add = visited.add(projectToUse);
      boolean _not = (!_add);
      if (_not) {
        return;
      }
      if (includeOutputFolder) {
        IPath _outputLocation = projectToUse.getOutputLocation();
        IPath path = _outputLocation.addTrailingSeparator();
        String _string = path.toString();
        URI _createPlatformResourceURI = URI.createPlatformResourceURI(_string, true);
        String _string_1 = _createPlatformResourceURI.toString();
        URL url = new URL(_string_1);
        result.add(url);
      }
      final IClasspathEntry[] resolvedClasspath = projectToUse.getResolvedClasspath(true);
      for (final IClasspathEntry entry : resolvedClasspath) {
        {
          URL url_1 = null;
          int _entryKind = entry.getEntryKind();
          switch (_entryKind) {
            case IClasspathEntry.CPE_SOURCE:
              if (includeOutputFolder) {
                final IPath path_1 = entry.getOutputLocation();
                boolean _notEquals = (!Objects.equal(path_1, null));
                if (_notEquals) {
                  IPath _addTrailingSeparator = path_1.addTrailingSeparator();
                  String _string_2 = _addTrailingSeparator.toString();
                  URI _createPlatformResourceURI_1 = URI.createPlatformResourceURI(_string_2, true);
                  String _string_3 = _createPlatformResourceURI_1.toString();
                  URL _uRL = new URL(_string_3);
                  url_1 = _uRL;
                }
              }
              break;
            case IClasspathEntry.CPE_PROJECT:
              IPath path_2 = entry.getPath();
              IWorkspaceRoot _workspaceRoot = this.getWorkspaceRoot(projectToUse);
              final IResource project = _workspaceRoot.findMember(path_2);
              IProject _project = project.getProject();
              final IJavaProject referencedProject = JavaCore.create(_project);
              this.collectClasspathURLs(referencedProject, result, true, visited);
              break;
            case IClasspathEntry.CPE_LIBRARY:
              IPath path_3 = entry.getPath();
              IWorkspaceRoot _workspaceRoot_1 = this.getWorkspaceRoot(projectToUse);
              final IResource library = _workspaceRoot_1.findMember(path_3);
              URL _xifexpression = null;
              boolean _notEquals_1 = (!Objects.equal(library, null));
              if (_notEquals_1) {
                java.net.URI _rawLocationURI = library.getRawLocationURI();
                _xifexpression = _rawLocationURI.toURL();
              } else {
                File _file = path_3.toFile();
                java.net.URI _uRI = _file.toURI();
                _xifexpression = _uRI.toURL();
              }
              url_1 = _xifexpression;
              break;
            default:
              {
                IPath path_4 = entry.getPath();
                File _file_1 = path_4.toFile();
                java.net.URI _uRI_1 = _file_1.toURI();
                URL _uRL_1 = _uRI_1.toURL();
                url_1 = _uRL_1;
              }
              break;
          }
          boolean _notEquals_2 = (!Objects.equal(url_1, null));
          if (_notEquals_2) {
            result.add(url_1);
          }
        }
      }
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  protected ClassLoader getParentClassLoader() {
    final ClassLoader bundleClassLoader = TransformationContext.class.getClassLoader();
    return bundleClassLoader;
  }
  
  private IWorkspaceRoot getWorkspaceRoot(final IJavaProject javaProject) {
    IProject _project = javaProject.getProject();
    IWorkspace _workspace = _project.getWorkspace();
    return _workspace.getRoot();
  }
}
