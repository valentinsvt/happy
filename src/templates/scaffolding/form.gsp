<% import grails.persistence.Event %>
<%=packageName%>
<!DOCTYPE html>
<html>
    <head>
        <meta name="layout" content="main">
        <title>\${${propertyName}?.id ? "Editar":"Crear"} ${className}</title>
    </head>

    <body>

        <g:if test="\${flash.message}">
            <div class="alert \${flash.tipo == 'error' ? 'alert-danger' : flash.tipo == 'success' ? 'alert-success' : 'alert-info'} \${flash.clase}">
                <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
                <g:if test="\${flash.tipo == 'error'}">
                    <i class="fa fa-warning fa-2x pull-left"></i>
                </g:if>
                <g:elseif test="\${flash.tipo == 'success'}">
                    <i class="fa fa-check-square fa-2x pull-left"></i>
                </g:elseif>
                <g:elseif test="\${flash.tipo == 'notFound'}">
                    <i class="icon-ghost fa-2x pull-left"></i>
                </g:elseif>
                <p>
                    \${flash.message}
                </p>
            </div>
        </g:if>

    <!-- botones -->
        <div class="btn-toolbar toolbar">
            <div class="btn-group">
                <g:link action="form" class="btn btn-default btnCrear">
                    <i class="fa fa-file-o"></i> Crear
                </g:link>

                <g:link action="list" class="btn btn-default btnCrear">
                    <i class="fa fa-list"></i> Lista
                </g:link>
            </div>

        </div>

        <div class="panel panel-default">
            <div class="panel-heading">
                <h3 class="panel-title">Modificar datos de ${className}</h3>
            </div>

            <div class="panel-body">
                <g:if test="\${!${propertyName}}">
                    <elm:notFound elem="${domainClass.propertyName.capitalize()}" genero="o" />
                </g:if>
                <g:else>
                    <g:form class="form-horizontal" name="frm${domainClass.propertyName.capitalize()}" role="form" action="save" method="POST">
                        <g:hiddenField name="id" value="\${${propertyName}?.id}" />
                        <%  excludedProps = Event.allEvents.toList() << 'version' << 'dateCreated' << 'lastUpdated'
                        persistentPropNames = domainClass.persistentProperties*.name
                        boolean hasHibernate = pluginManager?.hasGrailsPlugin('hibernate')
                        if (hasHibernate && org.codehaus.groovy.grails.orm.hibernate.cfg.GrailsDomainBinder.getMapping(domainClass)?.identity?.generator == 'assigned') {
                            persistentPropNames << domainClass.identifier.name
                        }
                        props = domainClass.properties.findAll { persistentPropNames.contains(it.name) && !excludedProps.contains(it.name) }
                        Collections.sort(props, comparator.constructors[0].newInstance([domainClass] as Object[]))
                        for (p in props) {
                            if (p.embedded) {
                                def embeddedPropNames = p.component.persistentProperties*.name
                                def embeddedProps = p.component.properties.findAll { embeddedPropNames.contains(it.name) && !excludedProps.contains(it.name) }
                                Collections.sort(embeddedProps, comparator.constructors[0].newInstance([p.component] as Object[]))
                        %><fieldset class="embedded"><legend><g:message code="${domainClass.propertyName}.${p.name}.label" default="${p.naturalName}" /></legend><%
                            for (ep in p.component.properties) {
                                renderFieldForProperty(ep, p.component, "${p.name}.")
                            }
                    %></fieldset><%
                            } else {
                                renderFieldForProperty(p, domainClass)
                            }
                        }
                        private renderFieldForProperty(p, owningClass, prefix = "") {
                            boolean hasHibernate = pluginManager?.hasGrailsPlugin('hibernate')
                            boolean display = true
                            boolean required = false
                            boolean number = false
                            boolean date = false
                            int size = 3
                            if (hasHibernate) {
                                cp = owningClass.constrainedProperties[p.name]
                                display = (cp ? cp.display : true)
                                required = (cp ? !(cp.propertyType in [boolean, Boolean]) && !cp.nullable && (cp.propertyType != String || !cp.blank) : false)
                                number = (cp ? Number.isAssignableFrom(cp.propertyType) || (cp.propertyType?.isPrimitive() && cp. propertyType != boolean) : false)
                                date = (cp ? (cp.propertyType == Date || cp.propertyType == java.sql.Date || cp.propertyType == java.sql.Time || cp.propertyType == Calendar) : false)
                                if(number){
                                    size = 1
                                } else if(date) {
                                    size = 2
                                }
                            }
                            if (display) { %>
                        <div class="form-group \${hasErrors(bean: ${propertyName}, field: '${prefix}${p.name}', 'error')} ${required ? 'required' : ''}">
                            <span class="grupo">
                                <label for="${prefix}${p.name}" class="col-md-2 control-label text-info">
                                    ${p.naturalName}
                                </label>
                                <div class="col-md-${size}">
                                    ${renderEditor(p)}
                                </div>
                                <% if (required) { %> *<% } %>
                            </span>
                        </div>
                        <%
                            if(cp.password){
                        %>
                        <div class="form-group \${hasErrors(bean: ${propertyName}, field: '${prefix}${p.name}', 'error')} ${required ? 'required' : ''}">
                            <span class="grupo">
                                <label for="${prefix}${p.name}" class="col-md-2 control-label text-info">
                                    Repetir ${p.naturalName} <!-- cambiar el name y agregarle el attr equalTo="#password" -->
                                </label>
                                <div class="col-md-${size}">
                                    ${renderEditor(p)}
                                </div>
                                <% if (required) { %> *<% } %>
                            </span>
                        </div>
                        <%
                            }
                        %>
                        <% } %>
                        <% } %>
                    </g:form>
                </g:else>
            </div>

            <div class="panel-footer">
                <div class="btn-toolbar toolbar">
                    <div class="btn-group">
                        <g:link action="show" class="btn btn-info" id="\${${propertyName}.id}">
                            <i class="fa fa-search"></i> Ver
                        </g:link>

                        <a href="#" id="btnGuardar" class="btn btn-success">
                            <i class="fa fa-disk"></i> Guardar
                        </a>
                    </div>
                </div>
            </div>

        </div>

        <script type="text/javascript">
            \$(function () {
                var validator = \$("#frm${domainClass.propertyName.capitalize()}").validate({
                    errorClass     : "help-block",
                    errorPlacement : function (error, element) {
                        if (element.parent().hasClass("input-group")) {
                            error.insertAfter(element.parent());
                        } else {
                            error.insertAfter(element);
                        }
                        element.parents(".grupo").addClass('has-error');
                    },
                    success        : function (label) {
                        label.parents(".grupo").removeClass('has-error');
                    }
                });
                \$(".form-control").keydown(function (ev) {
                    if (ev.keyCode == 13) {
                        submitForm();
                        return false;
                    }
                    return true;
                });

            });
        </script>

    </body>
</html>
