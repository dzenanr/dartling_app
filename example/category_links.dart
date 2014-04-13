import 'package:dartling/dartling.dart';
import 'package:dartling_app/dartling_app.dart';

Domain createDomain() {
  return new Domain('Category');
}

Model createModel(Domain domain) {
  Model model = new Model(domain, 'Links');

  Concept categoryConcept = new Concept(model, 'Category');
  categoryConcept.description = 'Category of web links.';
  
  var categoryName = new Attribute(categoryConcept, 'name');
  categoryName.identifier = true;
  AttributeType nameType = domain.getType('Name');
  categoryName.type = nameType;
  
  var categoryDescription = new Attribute(categoryConcept, 'description');
  AttributeType descriptionType = domain.getType('Description');
  categoryDescription.type = descriptionType;

  Concept webLinkConcept = new Concept(model, 'WebLink');
  webLinkConcept.entry = false;
  webLinkConcept.description = 'Web links of interest.';
  
  var webLinkSubject = new Attribute(webLinkConcept, 'subject');
  webLinkSubject.identifier = true;
  webLinkSubject.type = nameType;
    
  var webLinkUrl = new Attribute(webLinkConcept, 'url');
  AttributeType urlType = domain.getType('Uri');
  webLinkUrl.type = urlType;
  
  var webLinkDescription = new Attribute(webLinkConcept, 'description');
  webLinkDescription.type = descriptionType;

  Child categoryWebLinksNeighbor =
      new Child(categoryConcept, webLinkConcept, 'webLinks');
  Parent webLinkCategoryNeighbor =
      new Parent(webLinkConcept, categoryConcept, 'category');
  webLinkCategoryNeighbor.identifier = true;
  categoryWebLinksNeighbor.opposite = webLinkCategoryNeighbor;
  webLinkCategoryNeighbor.opposite = categoryWebLinksNeighbor;

  return model;
}

DomainModels createDomainModels(Domain domain, Model model) {
  var domainModels = new DomainModels(domain);
  var modelEntries = createModelEntries(model);
  domainModels.add(modelEntries);
  return domainModels;
}

ModelEntries createModelEntries(Model model) {
  return new ModelEntries(model);
}

createData(ModelEntries modelEntries) {
  Entities categories = modelEntries.getEntry('Category');

  ConceptEntity dartCategory = new ConceptEntity.of(categories.concept);
  dartCategory.setAttribute('name', 'Dart');
  dartCategory.setAttribute('description', 'Dart Web language.');
  categories.add(dartCategory);

  ConceptEntity html5Category = new ConceptEntity.of(categories.concept);
  html5Category.setAttribute('name', 'HTML5');
  html5Category.setAttribute('description',
    'HTML5 is the ubiquitous platform for the web.');
  categories.add(html5Category);

  Entities dartWebLinks = dartCategory.getChild('webLinks');

  ConceptEntity dartHomeWebLink = new ConceptEntity.of(dartWebLinks.concept);
  dartHomeWebLink.setAttribute('subject', 'Dart Home');
  dartHomeWebLink.setAttribute('url', 'http://www.dartlang.org/');
  dartHomeWebLink.setAttribute('description',
    'Dart brings structure to web app engineering with a new language, libraries, and tools.');
  dartHomeWebLink.setParent('category', dartCategory);
  dartWebLinks.add(dartHomeWebLink);

  ConceptEntity tryDartWebLink = new ConceptEntity.of(dartWebLinks.concept);
  tryDartWebLink.setAttribute('subject', 'Try Dart');
  tryDartWebLink.setAttribute('url', 'http://try.dartlang.org/');
  tryDartWebLink.setAttribute('description',
    'Try out the Dart Language from the comfort of your web browser.');
  tryDartWebLink.setParent('category', dartCategory);
  dartWebLinks.add(tryDartWebLink); 
}

main() {
  var domain = createDomain();
  var model = createModel(domain);
  var domainModels = createDomainModels(domain, model);
  new EntriesTable(domainModels, 'Links');
}
 
