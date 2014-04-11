part of dartling_app;

class EntriesTable { 
  ModelEntries modelEntries;
  
  DomainModels domainModels;
  TableElement table;
  EntitiesTable entitiesTable;
  EntityTable entityTable;
  
  String lsKey;
  
  EntriesTable(this.domainModels) {
    modelEntries = domainModels.getModelEntries("Synonyms"); 
    var dname = domainModels.domain.code;
    var mname = modelEntries.model.code;
    lsKey = '${dname}_${mname}_data';
    load(modelEntries);
    
    table = new Element.table();
    table.classes.add('entities-table');
    document.body.nodes.add(table);
    display();
  }
  
  load(var modelEntries) {
    String json = window.localStorage[lsKey];
    if (json != null && modelEntries.isEmpty) {
      modelEntries.fromJson(json);
    }
  }
   
  display() {
    addCaption();
    addHeaderRow();
    addEntryRows();
  }
  
  addCaption() {
    var tableCaption = new TableCaptionElement();
    tableCaption.text = 
        '${domainModels.domain.code} ${modelEntries.model.code}';
    table.nodes.add(tableCaption);
  }
  
  addHeaderRow() {
    TableRowElement hRow = new Element.tr();
    TableCellElement thElement = new Element.th();
    thElement.text = 'entry';
    hRow.nodes.add(thElement);
    table.nodes.add(hRow);
  }
  
  addEntryRows() {  
    for (Concept entryConcept in modelEntries.model.entryConcepts) {
      TableRowElement dRow = new Element.tr();
      TableCellElement tdElement = new Element.td();
      tdElement.text = entryConcept.codes;        
      dRow.nodes.add(tdElement);
      table.nodes.add(dRow);
      
      tdElement.onClick.listen((Event e) {
        Entities entryEntities = modelEntries.getEntry(entryConcept.code);
        if (entitiesTable != null) {
          entitiesTable.remove();
        }
        if (entityTable != null) {
          entityTable.remove();
        }
        entitiesTable = new EntitiesTable(this, entryEntities);
        entityTable = new EntityTable(entitiesTable, entryEntities); 
        entitiesTable.entityTable = entityTable;
      });
    }
  }
  
  save() {
    window.localStorage[lsKey] = modelEntries.toJson();
  }
}