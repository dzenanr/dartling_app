import 'package:dartling/dartling.dart';
import 'package:dartling_app/dartling_app.dart';

Domain createDomain() {
  return new Domain('Category');
}

Model createModel(Domain domain) {
  Model model = new Model(domain, 'Links');

  Concept categoryConcept = new Concept(model, 'Category');
  categoryConcept.description = 'Category of web links.';
  new Attribute(categoryConcept, 'name').identifier = true;
  new Attribute(categoryConcept, 'description');

  Concept webLinkConcept = new Concept(model, 'WebLink');
  webLinkConcept.entry = false;
  webLinkConcept.description = 'Web links of interest.';
  new Attribute(webLinkConcept, 'subject').identifier = true;
  new Attribute(webLinkConcept, 'url');
  new Attribute(webLinkConcept, 'description');

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
  var entries = new ModelEntries(model);
  Entities categories = entries.getEntry('Category');

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

  return entries;
}

main() {
  var domain = createDomain();
  var model = createModel(domain);
  var domainModels = createDomainModels(domain, model);
  new EntriesTable(domainModels, 'Links');
}
 
