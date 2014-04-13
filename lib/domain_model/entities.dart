part of dartling_app;

class EntitiesTable {
  Entities entities;
  List<Attribute> essentialAttributes;
  Children children;
  
  TableElement table;
  Parent parent;
  EntitiesTable parentEntitiesTable;
  EntityTable parentEntityTable;
  EntityTable entityTable;
  Child child;
  EntitiesTable childEntitiesTable;
  EntityTable childEntityTable;
  
  var context;

  EntitiesTable(this.context, this.entities) {
    table = new Element.table();
    table.classes.add('entities-table');
    document.body.nodes.add(table);
    
    if (context is EntitiesTable) {     
      parentEntitiesTable = context as EntitiesTable;
      parent = parentEntitiesTable.child.opposite;
      parentEntityTable = parentEntitiesTable.entityTable;
    }
    
    essentialAttributes = entities.concept.essentialAttributes;
    children = entities.concept.children;
    var incrementAttributes = entities.concept.incrementAttributes;
    var idIncrementAttribute = false;
    for (var attribute in incrementAttributes) {
      if (attribute.identifier) {
        idIncrementAttribute = true;
        break;
      }
    }
    if (idIncrementAttribute) {
      display(sort:false);
    } else {
      display();
    }
  }
  
  remove() {
    entityTable.remove();
    if (childEntitiesTable != null) childEntitiesTable.remove();
    if (childEntityTable != null) childEntityTable.remove();
    document.body.nodes.remove(table);
  }
  
  display({sort: true}) {
    removeRows();
    addCaption();
    addHeaderRow();
    if (sort) {
      entities.sort();
    }
    for (var entity in entities) {
      addDataRow(entity);
    }  
  }
  
  removeRows() {
    table.nodes.clear();
  }
  
  addCaption() {
    var tableCaption = new TableCaptionElement();
    tableCaption.text = entities.concept.labels;
    table.nodes.add(tableCaption);
  }
  
  addHeaderRow() {
    TableRowElement hRow = new Element.tr();
    for (Attribute attribute in essentialAttributes) {
      TableCellElement thElement = new Element.th();
      thElement.text = attribute.label;
      hRow.nodes.add(thElement);
      thElement.onClick.listen((Event e) {
        entities.sort((e1, e2) {
          var v1 = e1.getAttribute(attribute.code);
          var v2 = e2.getAttribute(attribute.code);
          if (v1 != null && v2 != null) {
            return compareValues(attribute, v1, v2);
          }
        });
        display(sort: false);
      });        
    }
    for (Child child in children) {
      TableCellElement thElement = new Element.th();
      thElement.text = child.label;
      hRow.nodes.add(thElement);
    }
    table.nodes.add(hRow);
  }
  
  /**
   * Compares two values based on their attribute.
   * If the result is less than 0 then the first id is less than the second,
   * if it is equal to 0 they are equal and
   * if the result is greater than 0 then the first is greater than the second.
   */
  int compareValues(Attribute a, var v1, var v2) {
    var compare = 0;
      if (a.type.base == 'String') {
        compare = v1.compareTo(v2);
      } else if (a.type.base == 'num' ||
        a.type.base == 'int' || a.type.base == 'double') {
        compare = v1.compareTo(v2);
      } else if (a.type.base == 'bool') {
        compare = v1.toString().compareTo(v2.toString());
      } else if (a.type.base == 'DateTime') {
        compare = v1.compareTo(v2);
      } else if (a.type.base == 'Duration') {
        compare = v1.compareTo(v2);
      } else if (a.type.base == 'Uri') {
        compare = v1.toString().compareTo(v2.toString());
      } else {
        String msg = 'cannot compare then order on this type';
        if (a.concept != null) {
          msg = '${a.concept.code}.${a.code} is of ${a.type.code} type: cannot order.';
        } else {
          msg = '${a.code} is of ${a.type.code} type: cannot order.';
        }
        throw new OrderError(msg);
      }
    return compare;
  }
  
  addDataRow(ConceptEntity entity) {
    TableRowElement dRow = new Element.tr();
    
    for (Attribute attribute in essentialAttributes) {
      TableCellElement tdElement = new Element.td();
      var value = entity.getAttribute(attribute.code);
      if (value != null) {
        tdElement.text = entity.getAttribute(attribute.code).toString();
      }
      dRow.nodes.add(tdElement);
    }
    
    for (Child child in children) {
      TableCellElement tdElement = new Element.td();
      tdElement.text = child.code;
      tdElement.onClick.listen((Event e) {
        if (childEntitiesTable != null) {
          childEntitiesTable.remove();
        }
        Entities childEntities = entity.getChild(child.code);
        this.child = child;
        childEntitiesTable = new EntitiesTable(this, childEntities);
        childEntityTable = new EntityTable(childEntitiesTable, childEntities);
        childEntitiesTable.entityTable = childEntityTable;
      });
      dRow.nodes.add(tdElement);
    }
     
    dRow.id = entity.oid.toString();
    dRow.onClick.listen(selectEntity);
    table.nodes.add(dRow);
  }
  
  selectEntity(Event e) {
    var dRow = (e.target as TableCellElement).parent;
    var idn = int.parse(dRow.id);
    var entity = entities.singleWhereOid(new Oid.ts(idn));
    entityTable.setEntity(entity);
  }
  
  save() {
    context.save();
  }
}

