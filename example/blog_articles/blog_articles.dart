import 'package:dartling/dartling.dart';
import 'package:dartling_app/dartling_app.dart';

Domain createDomain() {
  return new Domain('Blog');
}

Model createModel(Domain domain) {
  Model model = new Model(domain, 'Articles');

  Concept blogConcept = new Concept(model, 'Blog');
  blogConcept.description = 'Blogs with articles.';
  
  var blogName = new Attribute(blogConcept, 'name');
  blogName.identifier = true;
  AttributeType nameType = domain.getType('Name');
  blogName.type = nameType;
  
  var blogLink = new Attribute(blogConcept, 'link');
  blogName.required = true;
  AttributeType uriType = domain.getType('Uri');
  blogLink.type = uriType;
  
  var blogLanguage = new Attribute(blogConcept, 'language');
  blogLanguage.type = nameType;
  blogLanguage.init = 'English';

  Concept articleConcept = new Concept(model, 'Article');
  articleConcept.entry = false;
  articleConcept.description = 'Articles with comments and tags.';
  
  var articleTitle = new Attribute(articleConcept, 'title');
  articleTitle.identifier = true;
  articleTitle.type = nameType;
  
  var articleContent = new Attribute(articleConcept, 'content');
  articleContent.required = true;
  AttributeType descriptionType = domain.getType('Description');
  articleContent.type = descriptionType;
  
  var articleCreatedOn = new Attribute(articleConcept, 'createdOn');
  AttributeType dateType = domain.getType('DateTime');
  articleCreatedOn.type = dateType;
  articleCreatedOn.init = 'now';
  
  var articlePlus = new Attribute(articleConcept, 'plus');
  AttributeType intType = domain.getType('int');
  articlePlus.type = intType;
  articlePlus.init = '0';
  
  Child blogArticlesNeighbor =
      new Child(blogConcept, articleConcept, 'articles');
  Parent articleBlogNeighbor =
      new Parent(articleConcept, blogConcept, 'blog');
  articleBlogNeighbor.identifier = true;
  blogArticlesNeighbor.opposite = articleBlogNeighbor;
  articleBlogNeighbor.opposite = blogArticlesNeighbor;

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

main() {
  var domain = createDomain();
  var model = createModel(domain);
  var domainModels = createDomainModels(domain, model);
  new EntriesTable(domainModels, 'Articles');
}