// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $CategoriesTable extends Categories
    with TableInfo<$CategoriesTable, Category> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _slugMeta = const VerificationMeta('slug');
  @override
  late final GeneratedColumn<String> slug = GeneratedColumn<String>(
    'slug',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<LocalizedText, String> name =
      GeneratedColumn<String>(
        'name',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<LocalizedText>($CategoriesTable.$convertername);
  static const VerificationMeta _emojiMeta = const VerificationMeta('emoji');
  @override
  late final GeneratedColumn<String> emoji = GeneratedColumn<String>(
    'emoji',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, slug, name, emoji, sortOrder];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<Category> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('slug')) {
      context.handle(
        _slugMeta,
        slug.isAcceptableOrUnknown(data['slug']!, _slugMeta),
      );
    } else if (isInserting) {
      context.missing(_slugMeta);
    }
    if (data.containsKey('emoji')) {
      context.handle(
        _emojiMeta,
        emoji.isAcceptableOrUnknown(data['emoji']!, _emojiMeta),
      );
    } else if (isInserting) {
      context.missing(_emojiMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Category map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Category(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      slug: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}slug'],
      )!,
      name: $CategoriesTable.$convertername.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}name'],
        )!,
      ),
      emoji: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}emoji'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $CategoriesTable createAlias(String alias) {
    return $CategoriesTable(attachedDatabase, alias);
  }

  static TypeConverter<LocalizedText, String> $convertername =
      const LocalizedTextConverter();
}

class Category extends DataClass implements Insertable<Category> {
  final int id;
  final String slug;
  final LocalizedText name;
  final String emoji;
  final int sortOrder;
  const Category({
    required this.id,
    required this.slug,
    required this.name,
    required this.emoji,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['slug'] = Variable<String>(slug);
    {
      map['name'] = Variable<String>(
        $CategoriesTable.$convertername.toSql(name),
      );
    }
    map['emoji'] = Variable<String>(emoji);
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(
      id: Value(id),
      slug: Value(slug),
      name: Value(name),
      emoji: Value(emoji),
      sortOrder: Value(sortOrder),
    );
  }

  factory Category.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Category(
      id: serializer.fromJson<int>(json['id']),
      slug: serializer.fromJson<String>(json['slug']),
      name: serializer.fromJson<LocalizedText>(json['name']),
      emoji: serializer.fromJson<String>(json['emoji']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'slug': serializer.toJson<String>(slug),
      'name': serializer.toJson<LocalizedText>(name),
      'emoji': serializer.toJson<String>(emoji),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  Category copyWith({
    int? id,
    String? slug,
    LocalizedText? name,
    String? emoji,
    int? sortOrder,
  }) => Category(
    id: id ?? this.id,
    slug: slug ?? this.slug,
    name: name ?? this.name,
    emoji: emoji ?? this.emoji,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  Category copyWithCompanion(CategoriesCompanion data) {
    return Category(
      id: data.id.present ? data.id.value : this.id,
      slug: data.slug.present ? data.slug.value : this.slug,
      name: data.name.present ? data.name.value : this.name,
      emoji: data.emoji.present ? data.emoji.value : this.emoji,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Category(')
          ..write('id: $id, ')
          ..write('slug: $slug, ')
          ..write('name: $name, ')
          ..write('emoji: $emoji, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, slug, name, emoji, sortOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Category &&
          other.id == this.id &&
          other.slug == this.slug &&
          other.name == this.name &&
          other.emoji == this.emoji &&
          other.sortOrder == this.sortOrder);
}

class CategoriesCompanion extends UpdateCompanion<Category> {
  final Value<int> id;
  final Value<String> slug;
  final Value<LocalizedText> name;
  final Value<String> emoji;
  final Value<int> sortOrder;
  const CategoriesCompanion({
    this.id = const Value.absent(),
    this.slug = const Value.absent(),
    this.name = const Value.absent(),
    this.emoji = const Value.absent(),
    this.sortOrder = const Value.absent(),
  });
  CategoriesCompanion.insert({
    this.id = const Value.absent(),
    required String slug,
    required LocalizedText name,
    required String emoji,
    required int sortOrder,
  }) : slug = Value(slug),
       name = Value(name),
       emoji = Value(emoji),
       sortOrder = Value(sortOrder);
  static Insertable<Category> custom({
    Expression<int>? id,
    Expression<String>? slug,
    Expression<String>? name,
    Expression<String>? emoji,
    Expression<int>? sortOrder,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (slug != null) 'slug': slug,
      if (name != null) 'name': name,
      if (emoji != null) 'emoji': emoji,
      if (sortOrder != null) 'sort_order': sortOrder,
    });
  }

  CategoriesCompanion copyWith({
    Value<int>? id,
    Value<String>? slug,
    Value<LocalizedText>? name,
    Value<String>? emoji,
    Value<int>? sortOrder,
  }) {
    return CategoriesCompanion(
      id: id ?? this.id,
      slug: slug ?? this.slug,
      name: name ?? this.name,
      emoji: emoji ?? this.emoji,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (slug.present) {
      map['slug'] = Variable<String>(slug.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(
        $CategoriesTable.$convertername.toSql(name.value),
      );
    }
    if (emoji.present) {
      map['emoji'] = Variable<String>(emoji.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesCompanion(')
          ..write('id: $id, ')
          ..write('slug: $slug, ')
          ..write('name: $name, ')
          ..write('emoji: $emoji, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }
}

class $ProductsTable extends Products with TableInfo<$ProductsTable, Product> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
    'category_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categories (id)',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<LocalizedText, String> brand =
      GeneratedColumn<String>(
        'brand',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<LocalizedText>($ProductsTable.$converterbrand);
  @override
  late final GeneratedColumnWithTypeConverter<LocalizedText, String> name =
      GeneratedColumn<String>(
        'name',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<LocalizedText>($ProductsTable.$convertername);
  @override
  late final GeneratedColumnWithTypeConverter<LocalizedText, String> subtitle =
      GeneratedColumn<String>(
        'subtitle',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<LocalizedText>($ProductsTable.$convertersubtitle);
  @override
  late final GeneratedColumnWithTypeConverter<LocalizedText, String>
  description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<LocalizedText>($ProductsTable.$converterdescription);
  static const VerificationMeta _imageMeta = const VerificationMeta('image');
  @override
  late final GeneratedColumn<String> image = GeneratedColumn<String>(
    'image',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _priceCentsMeta = const VerificationMeta(
    'priceCents',
  );
  @override
  late final GeneratedColumn<int> priceCents = GeneratedColumn<int>(
    'price_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _originalPriceCentsMeta =
      const VerificationMeta('originalPriceCents');
  @override
  late final GeneratedColumn<int> originalPriceCents = GeneratedColumn<int>(
    'original_price_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stockMeta = const VerificationMeta('stock');
  @override
  late final GeneratedColumn<int> stock = GeneratedColumn<int>(
    'stock',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _salesMeta = const VerificationMeta('sales');
  @override
  late final GeneratedColumn<int> sales = GeneratedColumn<int>(
    'sales',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ratingMeta = const VerificationMeta('rating');
  @override
  late final GeneratedColumn<double> rating = GeneratedColumn<double>(
    'rating',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<StringList, String> tags =
      GeneratedColumn<String>(
        'tags',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<StringList>($ProductsTable.$convertertags);
  static const VerificationMeta _flashSaleMeta = const VerificationMeta(
    'flashSale',
  );
  @override
  late final GeneratedColumn<bool> flashSale = GeneratedColumn<bool>(
    'flash_sale',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("flash_sale" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    categoryId,
    brand,
    name,
    subtitle,
    description,
    image,
    priceCents,
    originalPriceCents,
    stock,
    sales,
    rating,
    tags,
    flashSale,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'products';
  @override
  VerificationContext validateIntegrity(
    Insertable<Product> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('image')) {
      context.handle(
        _imageMeta,
        image.isAcceptableOrUnknown(data['image']!, _imageMeta),
      );
    } else if (isInserting) {
      context.missing(_imageMeta);
    }
    if (data.containsKey('price_cents')) {
      context.handle(
        _priceCentsMeta,
        priceCents.isAcceptableOrUnknown(data['price_cents']!, _priceCentsMeta),
      );
    } else if (isInserting) {
      context.missing(_priceCentsMeta);
    }
    if (data.containsKey('original_price_cents')) {
      context.handle(
        _originalPriceCentsMeta,
        originalPriceCents.isAcceptableOrUnknown(
          data['original_price_cents']!,
          _originalPriceCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_originalPriceCentsMeta);
    }
    if (data.containsKey('stock')) {
      context.handle(
        _stockMeta,
        stock.isAcceptableOrUnknown(data['stock']!, _stockMeta),
      );
    } else if (isInserting) {
      context.missing(_stockMeta);
    }
    if (data.containsKey('sales')) {
      context.handle(
        _salesMeta,
        sales.isAcceptableOrUnknown(data['sales']!, _salesMeta),
      );
    } else if (isInserting) {
      context.missing(_salesMeta);
    }
    if (data.containsKey('rating')) {
      context.handle(
        _ratingMeta,
        rating.isAcceptableOrUnknown(data['rating']!, _ratingMeta),
      );
    } else if (isInserting) {
      context.missing(_ratingMeta);
    }
    if (data.containsKey('flash_sale')) {
      context.handle(
        _flashSaleMeta,
        flashSale.isAcceptableOrUnknown(data['flash_sale']!, _flashSaleMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Product map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Product(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}category_id'],
      )!,
      brand: $ProductsTable.$converterbrand.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}brand'],
        )!,
      ),
      name: $ProductsTable.$convertername.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}name'],
        )!,
      ),
      subtitle: $ProductsTable.$convertersubtitle.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}subtitle'],
        )!,
      ),
      description: $ProductsTable.$converterdescription.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}description'],
        )!,
      ),
      image: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image'],
      )!,
      priceCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}price_cents'],
      )!,
      originalPriceCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}original_price_cents'],
      )!,
      stock: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}stock'],
      )!,
      sales: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sales'],
      )!,
      rating: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}rating'],
      )!,
      tags: $ProductsTable.$convertertags.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}tags'],
        )!,
      ),
      flashSale: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}flash_sale'],
      )!,
    );
  }

  @override
  $ProductsTable createAlias(String alias) {
    return $ProductsTable(attachedDatabase, alias);
  }

  static TypeConverter<LocalizedText, String> $converterbrand =
      const LocalizedTextConverter();
  static TypeConverter<LocalizedText, String> $convertername =
      const LocalizedTextConverter();
  static TypeConverter<LocalizedText, String> $convertersubtitle =
      const LocalizedTextConverter();
  static TypeConverter<LocalizedText, String> $converterdescription =
      const LocalizedTextConverter();
  static TypeConverter<StringList, String> $convertertags =
      const StringListConverter();
}

class Product extends DataClass implements Insertable<Product> {
  final int id;
  final int categoryId;
  final LocalizedText brand;
  final LocalizedText name;
  final LocalizedText subtitle;
  final LocalizedText description;
  final String image;
  final int priceCents;
  final int originalPriceCents;
  final int stock;
  final int sales;
  final double rating;
  final StringList tags;
  final bool flashSale;
  const Product({
    required this.id,
    required this.categoryId,
    required this.brand,
    required this.name,
    required this.subtitle,
    required this.description,
    required this.image,
    required this.priceCents,
    required this.originalPriceCents,
    required this.stock,
    required this.sales,
    required this.rating,
    required this.tags,
    required this.flashSale,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['category_id'] = Variable<int>(categoryId);
    {
      map['brand'] = Variable<String>(
        $ProductsTable.$converterbrand.toSql(brand),
      );
    }
    {
      map['name'] = Variable<String>($ProductsTable.$convertername.toSql(name));
    }
    {
      map['subtitle'] = Variable<String>(
        $ProductsTable.$convertersubtitle.toSql(subtitle),
      );
    }
    {
      map['description'] = Variable<String>(
        $ProductsTable.$converterdescription.toSql(description),
      );
    }
    map['image'] = Variable<String>(image);
    map['price_cents'] = Variable<int>(priceCents);
    map['original_price_cents'] = Variable<int>(originalPriceCents);
    map['stock'] = Variable<int>(stock);
    map['sales'] = Variable<int>(sales);
    map['rating'] = Variable<double>(rating);
    {
      map['tags'] = Variable<String>($ProductsTable.$convertertags.toSql(tags));
    }
    map['flash_sale'] = Variable<bool>(flashSale);
    return map;
  }

  ProductsCompanion toCompanion(bool nullToAbsent) {
    return ProductsCompanion(
      id: Value(id),
      categoryId: Value(categoryId),
      brand: Value(brand),
      name: Value(name),
      subtitle: Value(subtitle),
      description: Value(description),
      image: Value(image),
      priceCents: Value(priceCents),
      originalPriceCents: Value(originalPriceCents),
      stock: Value(stock),
      sales: Value(sales),
      rating: Value(rating),
      tags: Value(tags),
      flashSale: Value(flashSale),
    );
  }

  factory Product.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Product(
      id: serializer.fromJson<int>(json['id']),
      categoryId: serializer.fromJson<int>(json['categoryId']),
      brand: serializer.fromJson<LocalizedText>(json['brand']),
      name: serializer.fromJson<LocalizedText>(json['name']),
      subtitle: serializer.fromJson<LocalizedText>(json['subtitle']),
      description: serializer.fromJson<LocalizedText>(json['description']),
      image: serializer.fromJson<String>(json['image']),
      priceCents: serializer.fromJson<int>(json['priceCents']),
      originalPriceCents: serializer.fromJson<int>(json['originalPriceCents']),
      stock: serializer.fromJson<int>(json['stock']),
      sales: serializer.fromJson<int>(json['sales']),
      rating: serializer.fromJson<double>(json['rating']),
      tags: serializer.fromJson<StringList>(json['tags']),
      flashSale: serializer.fromJson<bool>(json['flashSale']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'categoryId': serializer.toJson<int>(categoryId),
      'brand': serializer.toJson<LocalizedText>(brand),
      'name': serializer.toJson<LocalizedText>(name),
      'subtitle': serializer.toJson<LocalizedText>(subtitle),
      'description': serializer.toJson<LocalizedText>(description),
      'image': serializer.toJson<String>(image),
      'priceCents': serializer.toJson<int>(priceCents),
      'originalPriceCents': serializer.toJson<int>(originalPriceCents),
      'stock': serializer.toJson<int>(stock),
      'sales': serializer.toJson<int>(sales),
      'rating': serializer.toJson<double>(rating),
      'tags': serializer.toJson<StringList>(tags),
      'flashSale': serializer.toJson<bool>(flashSale),
    };
  }

  Product copyWith({
    int? id,
    int? categoryId,
    LocalizedText? brand,
    LocalizedText? name,
    LocalizedText? subtitle,
    LocalizedText? description,
    String? image,
    int? priceCents,
    int? originalPriceCents,
    int? stock,
    int? sales,
    double? rating,
    StringList? tags,
    bool? flashSale,
  }) => Product(
    id: id ?? this.id,
    categoryId: categoryId ?? this.categoryId,
    brand: brand ?? this.brand,
    name: name ?? this.name,
    subtitle: subtitle ?? this.subtitle,
    description: description ?? this.description,
    image: image ?? this.image,
    priceCents: priceCents ?? this.priceCents,
    originalPriceCents: originalPriceCents ?? this.originalPriceCents,
    stock: stock ?? this.stock,
    sales: sales ?? this.sales,
    rating: rating ?? this.rating,
    tags: tags ?? this.tags,
    flashSale: flashSale ?? this.flashSale,
  );
  Product copyWithCompanion(ProductsCompanion data) {
    return Product(
      id: data.id.present ? data.id.value : this.id,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      brand: data.brand.present ? data.brand.value : this.brand,
      name: data.name.present ? data.name.value : this.name,
      subtitle: data.subtitle.present ? data.subtitle.value : this.subtitle,
      description: data.description.present
          ? data.description.value
          : this.description,
      image: data.image.present ? data.image.value : this.image,
      priceCents: data.priceCents.present
          ? data.priceCents.value
          : this.priceCents,
      originalPriceCents: data.originalPriceCents.present
          ? data.originalPriceCents.value
          : this.originalPriceCents,
      stock: data.stock.present ? data.stock.value : this.stock,
      sales: data.sales.present ? data.sales.value : this.sales,
      rating: data.rating.present ? data.rating.value : this.rating,
      tags: data.tags.present ? data.tags.value : this.tags,
      flashSale: data.flashSale.present ? data.flashSale.value : this.flashSale,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Product(')
          ..write('id: $id, ')
          ..write('categoryId: $categoryId, ')
          ..write('brand: $brand, ')
          ..write('name: $name, ')
          ..write('subtitle: $subtitle, ')
          ..write('description: $description, ')
          ..write('image: $image, ')
          ..write('priceCents: $priceCents, ')
          ..write('originalPriceCents: $originalPriceCents, ')
          ..write('stock: $stock, ')
          ..write('sales: $sales, ')
          ..write('rating: $rating, ')
          ..write('tags: $tags, ')
          ..write('flashSale: $flashSale')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    categoryId,
    brand,
    name,
    subtitle,
    description,
    image,
    priceCents,
    originalPriceCents,
    stock,
    sales,
    rating,
    tags,
    flashSale,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Product &&
          other.id == this.id &&
          other.categoryId == this.categoryId &&
          other.brand == this.brand &&
          other.name == this.name &&
          other.subtitle == this.subtitle &&
          other.description == this.description &&
          other.image == this.image &&
          other.priceCents == this.priceCents &&
          other.originalPriceCents == this.originalPriceCents &&
          other.stock == this.stock &&
          other.sales == this.sales &&
          other.rating == this.rating &&
          other.tags == this.tags &&
          other.flashSale == this.flashSale);
}

class ProductsCompanion extends UpdateCompanion<Product> {
  final Value<int> id;
  final Value<int> categoryId;
  final Value<LocalizedText> brand;
  final Value<LocalizedText> name;
  final Value<LocalizedText> subtitle;
  final Value<LocalizedText> description;
  final Value<String> image;
  final Value<int> priceCents;
  final Value<int> originalPriceCents;
  final Value<int> stock;
  final Value<int> sales;
  final Value<double> rating;
  final Value<StringList> tags;
  final Value<bool> flashSale;
  const ProductsCompanion({
    this.id = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.brand = const Value.absent(),
    this.name = const Value.absent(),
    this.subtitle = const Value.absent(),
    this.description = const Value.absent(),
    this.image = const Value.absent(),
    this.priceCents = const Value.absent(),
    this.originalPriceCents = const Value.absent(),
    this.stock = const Value.absent(),
    this.sales = const Value.absent(),
    this.rating = const Value.absent(),
    this.tags = const Value.absent(),
    this.flashSale = const Value.absent(),
  });
  ProductsCompanion.insert({
    this.id = const Value.absent(),
    required int categoryId,
    required LocalizedText brand,
    required LocalizedText name,
    required LocalizedText subtitle,
    required LocalizedText description,
    required String image,
    required int priceCents,
    required int originalPriceCents,
    required int stock,
    required int sales,
    required double rating,
    required StringList tags,
    this.flashSale = const Value.absent(),
  }) : categoryId = Value(categoryId),
       brand = Value(brand),
       name = Value(name),
       subtitle = Value(subtitle),
       description = Value(description),
       image = Value(image),
       priceCents = Value(priceCents),
       originalPriceCents = Value(originalPriceCents),
       stock = Value(stock),
       sales = Value(sales),
       rating = Value(rating),
       tags = Value(tags);
  static Insertable<Product> custom({
    Expression<int>? id,
    Expression<int>? categoryId,
    Expression<String>? brand,
    Expression<String>? name,
    Expression<String>? subtitle,
    Expression<String>? description,
    Expression<String>? image,
    Expression<int>? priceCents,
    Expression<int>? originalPriceCents,
    Expression<int>? stock,
    Expression<int>? sales,
    Expression<double>? rating,
    Expression<String>? tags,
    Expression<bool>? flashSale,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (categoryId != null) 'category_id': categoryId,
      if (brand != null) 'brand': brand,
      if (name != null) 'name': name,
      if (subtitle != null) 'subtitle': subtitle,
      if (description != null) 'description': description,
      if (image != null) 'image': image,
      if (priceCents != null) 'price_cents': priceCents,
      if (originalPriceCents != null)
        'original_price_cents': originalPriceCents,
      if (stock != null) 'stock': stock,
      if (sales != null) 'sales': sales,
      if (rating != null) 'rating': rating,
      if (tags != null) 'tags': tags,
      if (flashSale != null) 'flash_sale': flashSale,
    });
  }

  ProductsCompanion copyWith({
    Value<int>? id,
    Value<int>? categoryId,
    Value<LocalizedText>? brand,
    Value<LocalizedText>? name,
    Value<LocalizedText>? subtitle,
    Value<LocalizedText>? description,
    Value<String>? image,
    Value<int>? priceCents,
    Value<int>? originalPriceCents,
    Value<int>? stock,
    Value<int>? sales,
    Value<double>? rating,
    Value<StringList>? tags,
    Value<bool>? flashSale,
  }) {
    return ProductsCompanion(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      brand: brand ?? this.brand,
      name: name ?? this.name,
      subtitle: subtitle ?? this.subtitle,
      description: description ?? this.description,
      image: image ?? this.image,
      priceCents: priceCents ?? this.priceCents,
      originalPriceCents: originalPriceCents ?? this.originalPriceCents,
      stock: stock ?? this.stock,
      sales: sales ?? this.sales,
      rating: rating ?? this.rating,
      tags: tags ?? this.tags,
      flashSale: flashSale ?? this.flashSale,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (brand.present) {
      map['brand'] = Variable<String>(
        $ProductsTable.$converterbrand.toSql(brand.value),
      );
    }
    if (name.present) {
      map['name'] = Variable<String>(
        $ProductsTable.$convertername.toSql(name.value),
      );
    }
    if (subtitle.present) {
      map['subtitle'] = Variable<String>(
        $ProductsTable.$convertersubtitle.toSql(subtitle.value),
      );
    }
    if (description.present) {
      map['description'] = Variable<String>(
        $ProductsTable.$converterdescription.toSql(description.value),
      );
    }
    if (image.present) {
      map['image'] = Variable<String>(image.value);
    }
    if (priceCents.present) {
      map['price_cents'] = Variable<int>(priceCents.value);
    }
    if (originalPriceCents.present) {
      map['original_price_cents'] = Variable<int>(originalPriceCents.value);
    }
    if (stock.present) {
      map['stock'] = Variable<int>(stock.value);
    }
    if (sales.present) {
      map['sales'] = Variable<int>(sales.value);
    }
    if (rating.present) {
      map['rating'] = Variable<double>(rating.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(
        $ProductsTable.$convertertags.toSql(tags.value),
      );
    }
    if (flashSale.present) {
      map['flash_sale'] = Variable<bool>(flashSale.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductsCompanion(')
          ..write('id: $id, ')
          ..write('categoryId: $categoryId, ')
          ..write('brand: $brand, ')
          ..write('name: $name, ')
          ..write('subtitle: $subtitle, ')
          ..write('description: $description, ')
          ..write('image: $image, ')
          ..write('priceCents: $priceCents, ')
          ..write('originalPriceCents: $originalPriceCents, ')
          ..write('stock: $stock, ')
          ..write('sales: $sales, ')
          ..write('rating: $rating, ')
          ..write('tags: $tags, ')
          ..write('flashSale: $flashSale')
          ..write(')'))
        .toString();
  }
}

class $CartItemsTable extends CartItems
    with TableInfo<$CartItemsTable, CartItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CartItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<int> productId = GeneratedColumn<int>(
    'product_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'UNIQUE REFERENCES products (id)',
    ),
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _selectedMeta = const VerificationMeta(
    'selected',
  );
  @override
  late final GeneratedColumn<bool> selected = GeneratedColumn<bool>(
    'selected',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("selected" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [id, productId, quantity, selected];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cart_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<CartItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('selected')) {
      context.handle(
        _selectedMeta,
        selected.isAcceptableOrUnknown(data['selected']!, _selectedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CartItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CartItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}product_id'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantity'],
      )!,
      selected: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}selected'],
      )!,
    );
  }

  @override
  $CartItemsTable createAlias(String alias) {
    return $CartItemsTable(attachedDatabase, alias);
  }
}

class CartItem extends DataClass implements Insertable<CartItem> {
  final int id;
  final int productId;
  final int quantity;
  final bool selected;
  const CartItem({
    required this.id,
    required this.productId,
    required this.quantity,
    required this.selected,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['product_id'] = Variable<int>(productId);
    map['quantity'] = Variable<int>(quantity);
    map['selected'] = Variable<bool>(selected);
    return map;
  }

  CartItemsCompanion toCompanion(bool nullToAbsent) {
    return CartItemsCompanion(
      id: Value(id),
      productId: Value(productId),
      quantity: Value(quantity),
      selected: Value(selected),
    );
  }

  factory CartItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CartItem(
      id: serializer.fromJson<int>(json['id']),
      productId: serializer.fromJson<int>(json['productId']),
      quantity: serializer.fromJson<int>(json['quantity']),
      selected: serializer.fromJson<bool>(json['selected']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'productId': serializer.toJson<int>(productId),
      'quantity': serializer.toJson<int>(quantity),
      'selected': serializer.toJson<bool>(selected),
    };
  }

  CartItem copyWith({int? id, int? productId, int? quantity, bool? selected}) =>
      CartItem(
        id: id ?? this.id,
        productId: productId ?? this.productId,
        quantity: quantity ?? this.quantity,
        selected: selected ?? this.selected,
      );
  CartItem copyWithCompanion(CartItemsCompanion data) {
    return CartItem(
      id: data.id.present ? data.id.value : this.id,
      productId: data.productId.present ? data.productId.value : this.productId,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      selected: data.selected.present ? data.selected.value : this.selected,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CartItem(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('quantity: $quantity, ')
          ..write('selected: $selected')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, productId, quantity, selected);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CartItem &&
          other.id == this.id &&
          other.productId == this.productId &&
          other.quantity == this.quantity &&
          other.selected == this.selected);
}

class CartItemsCompanion extends UpdateCompanion<CartItem> {
  final Value<int> id;
  final Value<int> productId;
  final Value<int> quantity;
  final Value<bool> selected;
  const CartItemsCompanion({
    this.id = const Value.absent(),
    this.productId = const Value.absent(),
    this.quantity = const Value.absent(),
    this.selected = const Value.absent(),
  });
  CartItemsCompanion.insert({
    this.id = const Value.absent(),
    required int productId,
    required int quantity,
    this.selected = const Value.absent(),
  }) : productId = Value(productId),
       quantity = Value(quantity);
  static Insertable<CartItem> custom({
    Expression<int>? id,
    Expression<int>? productId,
    Expression<int>? quantity,
    Expression<bool>? selected,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (productId != null) 'product_id': productId,
      if (quantity != null) 'quantity': quantity,
      if (selected != null) 'selected': selected,
    });
  }

  CartItemsCompanion copyWith({
    Value<int>? id,
    Value<int>? productId,
    Value<int>? quantity,
    Value<bool>? selected,
  }) {
    return CartItemsCompanion(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
      selected: selected ?? this.selected,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<int>(productId.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (selected.present) {
      map['selected'] = Variable<bool>(selected.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CartItemsCompanion(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('quantity: $quantity, ')
          ..write('selected: $selected')
          ..write(')'))
        .toString();
  }
}

class $WalletsTable extends Wallets with TableInfo<$WalletsTable, Wallet> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WalletsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _balanceCentsMeta = const VerificationMeta(
    'balanceCents',
  );
  @override
  late final GeneratedColumn<int> balanceCents = GeneratedColumn<int>(
    'balance_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalRechargeCentsMeta =
      const VerificationMeta('totalRechargeCents');
  @override
  late final GeneratedColumn<int> totalRechargeCents = GeneratedColumn<int>(
    'total_recharge_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalSpentCentsMeta = const VerificationMeta(
    'totalSpentCents',
  );
  @override
  late final GeneratedColumn<int> totalSpentCents = GeneratedColumn<int>(
    'total_spent_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    balanceCents,
    totalRechargeCents,
    totalSpentCents,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'wallets';
  @override
  VerificationContext validateIntegrity(
    Insertable<Wallet> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('balance_cents')) {
      context.handle(
        _balanceCentsMeta,
        balanceCents.isAcceptableOrUnknown(
          data['balance_cents']!,
          _balanceCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_balanceCentsMeta);
    }
    if (data.containsKey('total_recharge_cents')) {
      context.handle(
        _totalRechargeCentsMeta,
        totalRechargeCents.isAcceptableOrUnknown(
          data['total_recharge_cents']!,
          _totalRechargeCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalRechargeCentsMeta);
    }
    if (data.containsKey('total_spent_cents')) {
      context.handle(
        _totalSpentCentsMeta,
        totalSpentCents.isAcceptableOrUnknown(
          data['total_spent_cents']!,
          _totalSpentCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalSpentCentsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Wallet map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Wallet(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      balanceCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}balance_cents'],
      )!,
      totalRechargeCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_recharge_cents'],
      )!,
      totalSpentCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_spent_cents'],
      )!,
    );
  }

  @override
  $WalletsTable createAlias(String alias) {
    return $WalletsTable(attachedDatabase, alias);
  }
}

class Wallet extends DataClass implements Insertable<Wallet> {
  final int id;
  final int balanceCents;
  final int totalRechargeCents;
  final int totalSpentCents;
  const Wallet({
    required this.id,
    required this.balanceCents,
    required this.totalRechargeCents,
    required this.totalSpentCents,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['balance_cents'] = Variable<int>(balanceCents);
    map['total_recharge_cents'] = Variable<int>(totalRechargeCents);
    map['total_spent_cents'] = Variable<int>(totalSpentCents);
    return map;
  }

  WalletsCompanion toCompanion(bool nullToAbsent) {
    return WalletsCompanion(
      id: Value(id),
      balanceCents: Value(balanceCents),
      totalRechargeCents: Value(totalRechargeCents),
      totalSpentCents: Value(totalSpentCents),
    );
  }

  factory Wallet.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Wallet(
      id: serializer.fromJson<int>(json['id']),
      balanceCents: serializer.fromJson<int>(json['balanceCents']),
      totalRechargeCents: serializer.fromJson<int>(json['totalRechargeCents']),
      totalSpentCents: serializer.fromJson<int>(json['totalSpentCents']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'balanceCents': serializer.toJson<int>(balanceCents),
      'totalRechargeCents': serializer.toJson<int>(totalRechargeCents),
      'totalSpentCents': serializer.toJson<int>(totalSpentCents),
    };
  }

  Wallet copyWith({
    int? id,
    int? balanceCents,
    int? totalRechargeCents,
    int? totalSpentCents,
  }) => Wallet(
    id: id ?? this.id,
    balanceCents: balanceCents ?? this.balanceCents,
    totalRechargeCents: totalRechargeCents ?? this.totalRechargeCents,
    totalSpentCents: totalSpentCents ?? this.totalSpentCents,
  );
  Wallet copyWithCompanion(WalletsCompanion data) {
    return Wallet(
      id: data.id.present ? data.id.value : this.id,
      balanceCents: data.balanceCents.present
          ? data.balanceCents.value
          : this.balanceCents,
      totalRechargeCents: data.totalRechargeCents.present
          ? data.totalRechargeCents.value
          : this.totalRechargeCents,
      totalSpentCents: data.totalSpentCents.present
          ? data.totalSpentCents.value
          : this.totalSpentCents,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Wallet(')
          ..write('id: $id, ')
          ..write('balanceCents: $balanceCents, ')
          ..write('totalRechargeCents: $totalRechargeCents, ')
          ..write('totalSpentCents: $totalSpentCents')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, balanceCents, totalRechargeCents, totalSpentCents);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Wallet &&
          other.id == this.id &&
          other.balanceCents == this.balanceCents &&
          other.totalRechargeCents == this.totalRechargeCents &&
          other.totalSpentCents == this.totalSpentCents);
}

class WalletsCompanion extends UpdateCompanion<Wallet> {
  final Value<int> id;
  final Value<int> balanceCents;
  final Value<int> totalRechargeCents;
  final Value<int> totalSpentCents;
  const WalletsCompanion({
    this.id = const Value.absent(),
    this.balanceCents = const Value.absent(),
    this.totalRechargeCents = const Value.absent(),
    this.totalSpentCents = const Value.absent(),
  });
  WalletsCompanion.insert({
    this.id = const Value.absent(),
    required int balanceCents,
    required int totalRechargeCents,
    required int totalSpentCents,
  }) : balanceCents = Value(balanceCents),
       totalRechargeCents = Value(totalRechargeCents),
       totalSpentCents = Value(totalSpentCents);
  static Insertable<Wallet> custom({
    Expression<int>? id,
    Expression<int>? balanceCents,
    Expression<int>? totalRechargeCents,
    Expression<int>? totalSpentCents,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (balanceCents != null) 'balance_cents': balanceCents,
      if (totalRechargeCents != null)
        'total_recharge_cents': totalRechargeCents,
      if (totalSpentCents != null) 'total_spent_cents': totalSpentCents,
    });
  }

  WalletsCompanion copyWith({
    Value<int>? id,
    Value<int>? balanceCents,
    Value<int>? totalRechargeCents,
    Value<int>? totalSpentCents,
  }) {
    return WalletsCompanion(
      id: id ?? this.id,
      balanceCents: balanceCents ?? this.balanceCents,
      totalRechargeCents: totalRechargeCents ?? this.totalRechargeCents,
      totalSpentCents: totalSpentCents ?? this.totalSpentCents,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (balanceCents.present) {
      map['balance_cents'] = Variable<int>(balanceCents.value);
    }
    if (totalRechargeCents.present) {
      map['total_recharge_cents'] = Variable<int>(totalRechargeCents.value);
    }
    if (totalSpentCents.present) {
      map['total_spent_cents'] = Variable<int>(totalSpentCents.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WalletsCompanion(')
          ..write('id: $id, ')
          ..write('balanceCents: $balanceCents, ')
          ..write('totalRechargeCents: $totalRechargeCents, ')
          ..write('totalSpentCents: $totalSpentCents')
          ..write(')'))
        .toString();
  }
}

class $WalletTransactionsTable extends WalletTransactions
    with TableInfo<$WalletTransactionsTable, WalletTransaction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WalletTransactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<TxType, int> type =
      GeneratedColumn<int>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<TxType>($WalletTransactionsTable.$convertertype);
  static const VerificationMeta _amountCentsMeta = const VerificationMeta(
    'amountCents',
  );
  @override
  late final GeneratedColumn<int> amountCents = GeneratedColumn<int>(
    'amount_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _balanceAfterCentsMeta = const VerificationMeta(
    'balanceAfterCents',
  );
  @override
  late final GeneratedColumn<int> balanceAfterCents = GeneratedColumn<int>(
    'balance_after_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _refTextMeta = const VerificationMeta(
    'refText',
  );
  @override
  late final GeneratedColumn<String> refText = GeneratedColumn<String>(
    'ref_text',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    type,
    amountCents,
    balanceAfterCents,
    refText,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'wallet_transactions';
  @override
  VerificationContext validateIntegrity(
    Insertable<WalletTransaction> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('amount_cents')) {
      context.handle(
        _amountCentsMeta,
        amountCents.isAcceptableOrUnknown(
          data['amount_cents']!,
          _amountCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountCentsMeta);
    }
    if (data.containsKey('balance_after_cents')) {
      context.handle(
        _balanceAfterCentsMeta,
        balanceAfterCents.isAcceptableOrUnknown(
          data['balance_after_cents']!,
          _balanceAfterCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_balanceAfterCentsMeta);
    }
    if (data.containsKey('ref_text')) {
      context.handle(
        _refTextMeta,
        refText.isAcceptableOrUnknown(data['ref_text']!, _refTextMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WalletTransaction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WalletTransaction(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      type: $WalletTransactionsTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}type'],
        )!,
      ),
      amountCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_cents'],
      )!,
      balanceAfterCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}balance_after_cents'],
      )!,
      refText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ref_text'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $WalletTransactionsTable createAlias(String alias) {
    return $WalletTransactionsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<TxType, int, int> $convertertype =
      const EnumIndexConverter<TxType>(TxType.values);
}

class WalletTransaction extends DataClass
    implements Insertable<WalletTransaction> {
  final int id;
  final TxType type;
  final int amountCents;
  final int balanceAfterCents;
  final String? refText;
  final DateTime createdAt;
  const WalletTransaction({
    required this.id,
    required this.type,
    required this.amountCents,
    required this.balanceAfterCents,
    this.refText,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    {
      map['type'] = Variable<int>(
        $WalletTransactionsTable.$convertertype.toSql(type),
      );
    }
    map['amount_cents'] = Variable<int>(amountCents);
    map['balance_after_cents'] = Variable<int>(balanceAfterCents);
    if (!nullToAbsent || refText != null) {
      map['ref_text'] = Variable<String>(refText);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  WalletTransactionsCompanion toCompanion(bool nullToAbsent) {
    return WalletTransactionsCompanion(
      id: Value(id),
      type: Value(type),
      amountCents: Value(amountCents),
      balanceAfterCents: Value(balanceAfterCents),
      refText: refText == null && nullToAbsent
          ? const Value.absent()
          : Value(refText),
      createdAt: Value(createdAt),
    );
  }

  factory WalletTransaction.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WalletTransaction(
      id: serializer.fromJson<int>(json['id']),
      type: $WalletTransactionsTable.$convertertype.fromJson(
        serializer.fromJson<int>(json['type']),
      ),
      amountCents: serializer.fromJson<int>(json['amountCents']),
      balanceAfterCents: serializer.fromJson<int>(json['balanceAfterCents']),
      refText: serializer.fromJson<String?>(json['refText']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'type': serializer.toJson<int>(
        $WalletTransactionsTable.$convertertype.toJson(type),
      ),
      'amountCents': serializer.toJson<int>(amountCents),
      'balanceAfterCents': serializer.toJson<int>(balanceAfterCents),
      'refText': serializer.toJson<String?>(refText),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  WalletTransaction copyWith({
    int? id,
    TxType? type,
    int? amountCents,
    int? balanceAfterCents,
    Value<String?> refText = const Value.absent(),
    DateTime? createdAt,
  }) => WalletTransaction(
    id: id ?? this.id,
    type: type ?? this.type,
    amountCents: amountCents ?? this.amountCents,
    balanceAfterCents: balanceAfterCents ?? this.balanceAfterCents,
    refText: refText.present ? refText.value : this.refText,
    createdAt: createdAt ?? this.createdAt,
  );
  WalletTransaction copyWithCompanion(WalletTransactionsCompanion data) {
    return WalletTransaction(
      id: data.id.present ? data.id.value : this.id,
      type: data.type.present ? data.type.value : this.type,
      amountCents: data.amountCents.present
          ? data.amountCents.value
          : this.amountCents,
      balanceAfterCents: data.balanceAfterCents.present
          ? data.balanceAfterCents.value
          : this.balanceAfterCents,
      refText: data.refText.present ? data.refText.value : this.refText,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WalletTransaction(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('amountCents: $amountCents, ')
          ..write('balanceAfterCents: $balanceAfterCents, ')
          ..write('refText: $refText, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, type, amountCents, balanceAfterCents, refText, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WalletTransaction &&
          other.id == this.id &&
          other.type == this.type &&
          other.amountCents == this.amountCents &&
          other.balanceAfterCents == this.balanceAfterCents &&
          other.refText == this.refText &&
          other.createdAt == this.createdAt);
}

class WalletTransactionsCompanion extends UpdateCompanion<WalletTransaction> {
  final Value<int> id;
  final Value<TxType> type;
  final Value<int> amountCents;
  final Value<int> balanceAfterCents;
  final Value<String?> refText;
  final Value<DateTime> createdAt;
  const WalletTransactionsCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.amountCents = const Value.absent(),
    this.balanceAfterCents = const Value.absent(),
    this.refText = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  WalletTransactionsCompanion.insert({
    this.id = const Value.absent(),
    required TxType type,
    required int amountCents,
    required int balanceAfterCents,
    this.refText = const Value.absent(),
    required DateTime createdAt,
  }) : type = Value(type),
       amountCents = Value(amountCents),
       balanceAfterCents = Value(balanceAfterCents),
       createdAt = Value(createdAt);
  static Insertable<WalletTransaction> custom({
    Expression<int>? id,
    Expression<int>? type,
    Expression<int>? amountCents,
    Expression<int>? balanceAfterCents,
    Expression<String>? refText,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (amountCents != null) 'amount_cents': amountCents,
      if (balanceAfterCents != null) 'balance_after_cents': balanceAfterCents,
      if (refText != null) 'ref_text': refText,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  WalletTransactionsCompanion copyWith({
    Value<int>? id,
    Value<TxType>? type,
    Value<int>? amountCents,
    Value<int>? balanceAfterCents,
    Value<String?>? refText,
    Value<DateTime>? createdAt,
  }) {
    return WalletTransactionsCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      amountCents: amountCents ?? this.amountCents,
      balanceAfterCents: balanceAfterCents ?? this.balanceAfterCents,
      refText: refText ?? this.refText,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (type.present) {
      map['type'] = Variable<int>(
        $WalletTransactionsTable.$convertertype.toSql(type.value),
      );
    }
    if (amountCents.present) {
      map['amount_cents'] = Variable<int>(amountCents.value);
    }
    if (balanceAfterCents.present) {
      map['balance_after_cents'] = Variable<int>(balanceAfterCents.value);
    }
    if (refText.present) {
      map['ref_text'] = Variable<String>(refText.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WalletTransactionsCompanion(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('amountCents: $amountCents, ')
          ..write('balanceAfterCents: $balanceAfterCents, ')
          ..write('refText: $refText, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $CouponsTable extends Coupons with TableInfo<$CouponsTable, Coupon> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CouponsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _titleKeyMeta = const VerificationMeta(
    'titleKey',
  );
  @override
  late final GeneratedColumn<String> titleKey = GeneratedColumn<String>(
    'title_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isRateMeta = const VerificationMeta('isRate');
  @override
  late final GeneratedColumn<bool> isRate = GeneratedColumn<bool>(
    'is_rate',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_rate" IN (0, 1))',
    ),
  );
  static const VerificationMeta _valueIntMeta = const VerificationMeta(
    'valueInt',
  );
  @override
  late final GeneratedColumn<int> valueInt = GeneratedColumn<int>(
    'value_int',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _minSpendCentsMeta = const VerificationMeta(
    'minSpendCents',
  );
  @override
  late final GeneratedColumn<int> minSpendCents = GeneratedColumn<int>(
    'min_spend_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _expiresAtMeta = const VerificationMeta(
    'expiresAt',
  );
  @override
  late final GeneratedColumn<DateTime> expiresAt = GeneratedColumn<DateTime>(
    'expires_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<CouponStatus, int> status =
      GeneratedColumn<int>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<CouponStatus>($CouponsTable.$converterstatus);
  @override
  List<GeneratedColumn> get $columns => [
    id,
    titleKey,
    isRate,
    valueInt,
    minSpendCents,
    expiresAt,
    status,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'coupons';
  @override
  VerificationContext validateIntegrity(
    Insertable<Coupon> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title_key')) {
      context.handle(
        _titleKeyMeta,
        titleKey.isAcceptableOrUnknown(data['title_key']!, _titleKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_titleKeyMeta);
    }
    if (data.containsKey('is_rate')) {
      context.handle(
        _isRateMeta,
        isRate.isAcceptableOrUnknown(data['is_rate']!, _isRateMeta),
      );
    } else if (isInserting) {
      context.missing(_isRateMeta);
    }
    if (data.containsKey('value_int')) {
      context.handle(
        _valueIntMeta,
        valueInt.isAcceptableOrUnknown(data['value_int']!, _valueIntMeta),
      );
    } else if (isInserting) {
      context.missing(_valueIntMeta);
    }
    if (data.containsKey('min_spend_cents')) {
      context.handle(
        _minSpendCentsMeta,
        minSpendCents.isAcceptableOrUnknown(
          data['min_spend_cents']!,
          _minSpendCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_minSpendCentsMeta);
    }
    if (data.containsKey('expires_at')) {
      context.handle(
        _expiresAtMeta,
        expiresAt.isAcceptableOrUnknown(data['expires_at']!, _expiresAtMeta),
      );
    } else if (isInserting) {
      context.missing(_expiresAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Coupon map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Coupon(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      titleKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title_key'],
      )!,
      isRate: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_rate'],
      )!,
      valueInt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}value_int'],
      )!,
      minSpendCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}min_spend_cents'],
      )!,
      expiresAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}expires_at'],
      )!,
      status: $CouponsTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}status'],
        )!,
      ),
    );
  }

  @override
  $CouponsTable createAlias(String alias) {
    return $CouponsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<CouponStatus, int, int> $converterstatus =
      const EnumIndexConverter<CouponStatus>(CouponStatus.values);
}

class Coupon extends DataClass implements Insertable<Coupon> {
  final int id;
  final String titleKey;
  final bool isRate;
  final int valueInt;
  final int minSpendCents;
  final DateTime expiresAt;
  final CouponStatus status;
  const Coupon({
    required this.id,
    required this.titleKey,
    required this.isRate,
    required this.valueInt,
    required this.minSpendCents,
    required this.expiresAt,
    required this.status,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title_key'] = Variable<String>(titleKey);
    map['is_rate'] = Variable<bool>(isRate);
    map['value_int'] = Variable<int>(valueInt);
    map['min_spend_cents'] = Variable<int>(minSpendCents);
    map['expires_at'] = Variable<DateTime>(expiresAt);
    {
      map['status'] = Variable<int>(
        $CouponsTable.$converterstatus.toSql(status),
      );
    }
    return map;
  }

  CouponsCompanion toCompanion(bool nullToAbsent) {
    return CouponsCompanion(
      id: Value(id),
      titleKey: Value(titleKey),
      isRate: Value(isRate),
      valueInt: Value(valueInt),
      minSpendCents: Value(minSpendCents),
      expiresAt: Value(expiresAt),
      status: Value(status),
    );
  }

  factory Coupon.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Coupon(
      id: serializer.fromJson<int>(json['id']),
      titleKey: serializer.fromJson<String>(json['titleKey']),
      isRate: serializer.fromJson<bool>(json['isRate']),
      valueInt: serializer.fromJson<int>(json['valueInt']),
      minSpendCents: serializer.fromJson<int>(json['minSpendCents']),
      expiresAt: serializer.fromJson<DateTime>(json['expiresAt']),
      status: $CouponsTable.$converterstatus.fromJson(
        serializer.fromJson<int>(json['status']),
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'titleKey': serializer.toJson<String>(titleKey),
      'isRate': serializer.toJson<bool>(isRate),
      'valueInt': serializer.toJson<int>(valueInt),
      'minSpendCents': serializer.toJson<int>(minSpendCents),
      'expiresAt': serializer.toJson<DateTime>(expiresAt),
      'status': serializer.toJson<int>(
        $CouponsTable.$converterstatus.toJson(status),
      ),
    };
  }

  Coupon copyWith({
    int? id,
    String? titleKey,
    bool? isRate,
    int? valueInt,
    int? minSpendCents,
    DateTime? expiresAt,
    CouponStatus? status,
  }) => Coupon(
    id: id ?? this.id,
    titleKey: titleKey ?? this.titleKey,
    isRate: isRate ?? this.isRate,
    valueInt: valueInt ?? this.valueInt,
    minSpendCents: minSpendCents ?? this.minSpendCents,
    expiresAt: expiresAt ?? this.expiresAt,
    status: status ?? this.status,
  );
  Coupon copyWithCompanion(CouponsCompanion data) {
    return Coupon(
      id: data.id.present ? data.id.value : this.id,
      titleKey: data.titleKey.present ? data.titleKey.value : this.titleKey,
      isRate: data.isRate.present ? data.isRate.value : this.isRate,
      valueInt: data.valueInt.present ? data.valueInt.value : this.valueInt,
      minSpendCents: data.minSpendCents.present
          ? data.minSpendCents.value
          : this.minSpendCents,
      expiresAt: data.expiresAt.present ? data.expiresAt.value : this.expiresAt,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Coupon(')
          ..write('id: $id, ')
          ..write('titleKey: $titleKey, ')
          ..write('isRate: $isRate, ')
          ..write('valueInt: $valueInt, ')
          ..write('minSpendCents: $minSpendCents, ')
          ..write('expiresAt: $expiresAt, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    titleKey,
    isRate,
    valueInt,
    minSpendCents,
    expiresAt,
    status,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Coupon &&
          other.id == this.id &&
          other.titleKey == this.titleKey &&
          other.isRate == this.isRate &&
          other.valueInt == this.valueInt &&
          other.minSpendCents == this.minSpendCents &&
          other.expiresAt == this.expiresAt &&
          other.status == this.status);
}

class CouponsCompanion extends UpdateCompanion<Coupon> {
  final Value<int> id;
  final Value<String> titleKey;
  final Value<bool> isRate;
  final Value<int> valueInt;
  final Value<int> minSpendCents;
  final Value<DateTime> expiresAt;
  final Value<CouponStatus> status;
  const CouponsCompanion({
    this.id = const Value.absent(),
    this.titleKey = const Value.absent(),
    this.isRate = const Value.absent(),
    this.valueInt = const Value.absent(),
    this.minSpendCents = const Value.absent(),
    this.expiresAt = const Value.absent(),
    this.status = const Value.absent(),
  });
  CouponsCompanion.insert({
    this.id = const Value.absent(),
    required String titleKey,
    required bool isRate,
    required int valueInt,
    required int minSpendCents,
    required DateTime expiresAt,
    required CouponStatus status,
  }) : titleKey = Value(titleKey),
       isRate = Value(isRate),
       valueInt = Value(valueInt),
       minSpendCents = Value(minSpendCents),
       expiresAt = Value(expiresAt),
       status = Value(status);
  static Insertable<Coupon> custom({
    Expression<int>? id,
    Expression<String>? titleKey,
    Expression<bool>? isRate,
    Expression<int>? valueInt,
    Expression<int>? minSpendCents,
    Expression<DateTime>? expiresAt,
    Expression<int>? status,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (titleKey != null) 'title_key': titleKey,
      if (isRate != null) 'is_rate': isRate,
      if (valueInt != null) 'value_int': valueInt,
      if (minSpendCents != null) 'min_spend_cents': minSpendCents,
      if (expiresAt != null) 'expires_at': expiresAt,
      if (status != null) 'status': status,
    });
  }

  CouponsCompanion copyWith({
    Value<int>? id,
    Value<String>? titleKey,
    Value<bool>? isRate,
    Value<int>? valueInt,
    Value<int>? minSpendCents,
    Value<DateTime>? expiresAt,
    Value<CouponStatus>? status,
  }) {
    return CouponsCompanion(
      id: id ?? this.id,
      titleKey: titleKey ?? this.titleKey,
      isRate: isRate ?? this.isRate,
      valueInt: valueInt ?? this.valueInt,
      minSpendCents: minSpendCents ?? this.minSpendCents,
      expiresAt: expiresAt ?? this.expiresAt,
      status: status ?? this.status,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (titleKey.present) {
      map['title_key'] = Variable<String>(titleKey.value);
    }
    if (isRate.present) {
      map['is_rate'] = Variable<bool>(isRate.value);
    }
    if (valueInt.present) {
      map['value_int'] = Variable<int>(valueInt.value);
    }
    if (minSpendCents.present) {
      map['min_spend_cents'] = Variable<int>(minSpendCents.value);
    }
    if (expiresAt.present) {
      map['expires_at'] = Variable<DateTime>(expiresAt.value);
    }
    if (status.present) {
      map['status'] = Variable<int>(
        $CouponsTable.$converterstatus.toSql(status.value),
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CouponsCompanion(')
          ..write('id: $id, ')
          ..write('titleKey: $titleKey, ')
          ..write('isRate: $isRate, ')
          ..write('valueInt: $valueInt, ')
          ..write('minSpendCents: $minSpendCents, ')
          ..write('expiresAt: $expiresAt, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }
}

class $OrdersTable extends Orders with TableInfo<$OrdersTable, Order> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OrdersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _orderNoMeta = const VerificationMeta(
    'orderNo',
  );
  @override
  late final GeneratedColumn<String> orderNo = GeneratedColumn<String>(
    'order_no',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  @override
  late final GeneratedColumnWithTypeConverter<OrderStatus, int> status =
      GeneratedColumn<int>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<OrderStatus>($OrdersTable.$converterstatus);
  static const VerificationMeta _totalAmountCentsMeta = const VerificationMeta(
    'totalAmountCents',
  );
  @override
  late final GeneratedColumn<int> totalAmountCents = GeneratedColumn<int>(
    'total_amount_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _discountCentsMeta = const VerificationMeta(
    'discountCents',
  );
  @override
  late final GeneratedColumn<int> discountCents = GeneratedColumn<int>(
    'discount_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payableCentsMeta = const VerificationMeta(
    'payableCents',
  );
  @override
  late final GeneratedColumn<int> payableCents = GeneratedColumn<int>(
    'payable_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _couponIdMeta = const VerificationMeta(
    'couponId',
  );
  @override
  late final GeneratedColumn<int> couponId = GeneratedColumn<int>(
    'coupon_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES coupons (id)',
    ),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _paidAtMeta = const VerificationMeta('paidAt');
  @override
  late final GeneratedColumn<DateTime> paidAt = GeneratedColumn<DateTime>(
    'paid_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    orderNo,
    status,
    totalAmountCents,
    discountCents,
    payableCents,
    couponId,
    createdAt,
    paidAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'orders';
  @override
  VerificationContext validateIntegrity(
    Insertable<Order> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('order_no')) {
      context.handle(
        _orderNoMeta,
        orderNo.isAcceptableOrUnknown(data['order_no']!, _orderNoMeta),
      );
    } else if (isInserting) {
      context.missing(_orderNoMeta);
    }
    if (data.containsKey('total_amount_cents')) {
      context.handle(
        _totalAmountCentsMeta,
        totalAmountCents.isAcceptableOrUnknown(
          data['total_amount_cents']!,
          _totalAmountCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalAmountCentsMeta);
    }
    if (data.containsKey('discount_cents')) {
      context.handle(
        _discountCentsMeta,
        discountCents.isAcceptableOrUnknown(
          data['discount_cents']!,
          _discountCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_discountCentsMeta);
    }
    if (data.containsKey('payable_cents')) {
      context.handle(
        _payableCentsMeta,
        payableCents.isAcceptableOrUnknown(
          data['payable_cents']!,
          _payableCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_payableCentsMeta);
    }
    if (data.containsKey('coupon_id')) {
      context.handle(
        _couponIdMeta,
        couponId.isAcceptableOrUnknown(data['coupon_id']!, _couponIdMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('paid_at')) {
      context.handle(
        _paidAtMeta,
        paidAt.isAcceptableOrUnknown(data['paid_at']!, _paidAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Order map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Order(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      orderNo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}order_no'],
      )!,
      status: $OrdersTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}status'],
        )!,
      ),
      totalAmountCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_amount_cents'],
      )!,
      discountCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}discount_cents'],
      )!,
      payableCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}payable_cents'],
      )!,
      couponId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}coupon_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      paidAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}paid_at'],
      ),
    );
  }

  @override
  $OrdersTable createAlias(String alias) {
    return $OrdersTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<OrderStatus, int, int> $converterstatus =
      const EnumIndexConverter<OrderStatus>(OrderStatus.values);
}

class Order extends DataClass implements Insertable<Order> {
  final int id;
  final String orderNo;
  final OrderStatus status;
  final int totalAmountCents;
  final int discountCents;
  final int payableCents;
  final int? couponId;
  final DateTime createdAt;
  final DateTime? paidAt;
  const Order({
    required this.id,
    required this.orderNo,
    required this.status,
    required this.totalAmountCents,
    required this.discountCents,
    required this.payableCents,
    this.couponId,
    required this.createdAt,
    this.paidAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['order_no'] = Variable<String>(orderNo);
    {
      map['status'] = Variable<int>(
        $OrdersTable.$converterstatus.toSql(status),
      );
    }
    map['total_amount_cents'] = Variable<int>(totalAmountCents);
    map['discount_cents'] = Variable<int>(discountCents);
    map['payable_cents'] = Variable<int>(payableCents);
    if (!nullToAbsent || couponId != null) {
      map['coupon_id'] = Variable<int>(couponId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || paidAt != null) {
      map['paid_at'] = Variable<DateTime>(paidAt);
    }
    return map;
  }

  OrdersCompanion toCompanion(bool nullToAbsent) {
    return OrdersCompanion(
      id: Value(id),
      orderNo: Value(orderNo),
      status: Value(status),
      totalAmountCents: Value(totalAmountCents),
      discountCents: Value(discountCents),
      payableCents: Value(payableCents),
      couponId: couponId == null && nullToAbsent
          ? const Value.absent()
          : Value(couponId),
      createdAt: Value(createdAt),
      paidAt: paidAt == null && nullToAbsent
          ? const Value.absent()
          : Value(paidAt),
    );
  }

  factory Order.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Order(
      id: serializer.fromJson<int>(json['id']),
      orderNo: serializer.fromJson<String>(json['orderNo']),
      status: $OrdersTable.$converterstatus.fromJson(
        serializer.fromJson<int>(json['status']),
      ),
      totalAmountCents: serializer.fromJson<int>(json['totalAmountCents']),
      discountCents: serializer.fromJson<int>(json['discountCents']),
      payableCents: serializer.fromJson<int>(json['payableCents']),
      couponId: serializer.fromJson<int?>(json['couponId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      paidAt: serializer.fromJson<DateTime?>(json['paidAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'orderNo': serializer.toJson<String>(orderNo),
      'status': serializer.toJson<int>(
        $OrdersTable.$converterstatus.toJson(status),
      ),
      'totalAmountCents': serializer.toJson<int>(totalAmountCents),
      'discountCents': serializer.toJson<int>(discountCents),
      'payableCents': serializer.toJson<int>(payableCents),
      'couponId': serializer.toJson<int?>(couponId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'paidAt': serializer.toJson<DateTime?>(paidAt),
    };
  }

  Order copyWith({
    int? id,
    String? orderNo,
    OrderStatus? status,
    int? totalAmountCents,
    int? discountCents,
    int? payableCents,
    Value<int?> couponId = const Value.absent(),
    DateTime? createdAt,
    Value<DateTime?> paidAt = const Value.absent(),
  }) => Order(
    id: id ?? this.id,
    orderNo: orderNo ?? this.orderNo,
    status: status ?? this.status,
    totalAmountCents: totalAmountCents ?? this.totalAmountCents,
    discountCents: discountCents ?? this.discountCents,
    payableCents: payableCents ?? this.payableCents,
    couponId: couponId.present ? couponId.value : this.couponId,
    createdAt: createdAt ?? this.createdAt,
    paidAt: paidAt.present ? paidAt.value : this.paidAt,
  );
  Order copyWithCompanion(OrdersCompanion data) {
    return Order(
      id: data.id.present ? data.id.value : this.id,
      orderNo: data.orderNo.present ? data.orderNo.value : this.orderNo,
      status: data.status.present ? data.status.value : this.status,
      totalAmountCents: data.totalAmountCents.present
          ? data.totalAmountCents.value
          : this.totalAmountCents,
      discountCents: data.discountCents.present
          ? data.discountCents.value
          : this.discountCents,
      payableCents: data.payableCents.present
          ? data.payableCents.value
          : this.payableCents,
      couponId: data.couponId.present ? data.couponId.value : this.couponId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      paidAt: data.paidAt.present ? data.paidAt.value : this.paidAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Order(')
          ..write('id: $id, ')
          ..write('orderNo: $orderNo, ')
          ..write('status: $status, ')
          ..write('totalAmountCents: $totalAmountCents, ')
          ..write('discountCents: $discountCents, ')
          ..write('payableCents: $payableCents, ')
          ..write('couponId: $couponId, ')
          ..write('createdAt: $createdAt, ')
          ..write('paidAt: $paidAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    orderNo,
    status,
    totalAmountCents,
    discountCents,
    payableCents,
    couponId,
    createdAt,
    paidAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Order &&
          other.id == this.id &&
          other.orderNo == this.orderNo &&
          other.status == this.status &&
          other.totalAmountCents == this.totalAmountCents &&
          other.discountCents == this.discountCents &&
          other.payableCents == this.payableCents &&
          other.couponId == this.couponId &&
          other.createdAt == this.createdAt &&
          other.paidAt == this.paidAt);
}

class OrdersCompanion extends UpdateCompanion<Order> {
  final Value<int> id;
  final Value<String> orderNo;
  final Value<OrderStatus> status;
  final Value<int> totalAmountCents;
  final Value<int> discountCents;
  final Value<int> payableCents;
  final Value<int?> couponId;
  final Value<DateTime> createdAt;
  final Value<DateTime?> paidAt;
  const OrdersCompanion({
    this.id = const Value.absent(),
    this.orderNo = const Value.absent(),
    this.status = const Value.absent(),
    this.totalAmountCents = const Value.absent(),
    this.discountCents = const Value.absent(),
    this.payableCents = const Value.absent(),
    this.couponId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.paidAt = const Value.absent(),
  });
  OrdersCompanion.insert({
    this.id = const Value.absent(),
    required String orderNo,
    required OrderStatus status,
    required int totalAmountCents,
    required int discountCents,
    required int payableCents,
    this.couponId = const Value.absent(),
    required DateTime createdAt,
    this.paidAt = const Value.absent(),
  }) : orderNo = Value(orderNo),
       status = Value(status),
       totalAmountCents = Value(totalAmountCents),
       discountCents = Value(discountCents),
       payableCents = Value(payableCents),
       createdAt = Value(createdAt);
  static Insertable<Order> custom({
    Expression<int>? id,
    Expression<String>? orderNo,
    Expression<int>? status,
    Expression<int>? totalAmountCents,
    Expression<int>? discountCents,
    Expression<int>? payableCents,
    Expression<int>? couponId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? paidAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (orderNo != null) 'order_no': orderNo,
      if (status != null) 'status': status,
      if (totalAmountCents != null) 'total_amount_cents': totalAmountCents,
      if (discountCents != null) 'discount_cents': discountCents,
      if (payableCents != null) 'payable_cents': payableCents,
      if (couponId != null) 'coupon_id': couponId,
      if (createdAt != null) 'created_at': createdAt,
      if (paidAt != null) 'paid_at': paidAt,
    });
  }

  OrdersCompanion copyWith({
    Value<int>? id,
    Value<String>? orderNo,
    Value<OrderStatus>? status,
    Value<int>? totalAmountCents,
    Value<int>? discountCents,
    Value<int>? payableCents,
    Value<int?>? couponId,
    Value<DateTime>? createdAt,
    Value<DateTime?>? paidAt,
  }) {
    return OrdersCompanion(
      id: id ?? this.id,
      orderNo: orderNo ?? this.orderNo,
      status: status ?? this.status,
      totalAmountCents: totalAmountCents ?? this.totalAmountCents,
      discountCents: discountCents ?? this.discountCents,
      payableCents: payableCents ?? this.payableCents,
      couponId: couponId ?? this.couponId,
      createdAt: createdAt ?? this.createdAt,
      paidAt: paidAt ?? this.paidAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (orderNo.present) {
      map['order_no'] = Variable<String>(orderNo.value);
    }
    if (status.present) {
      map['status'] = Variable<int>(
        $OrdersTable.$converterstatus.toSql(status.value),
      );
    }
    if (totalAmountCents.present) {
      map['total_amount_cents'] = Variable<int>(totalAmountCents.value);
    }
    if (discountCents.present) {
      map['discount_cents'] = Variable<int>(discountCents.value);
    }
    if (payableCents.present) {
      map['payable_cents'] = Variable<int>(payableCents.value);
    }
    if (couponId.present) {
      map['coupon_id'] = Variable<int>(couponId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (paidAt.present) {
      map['paid_at'] = Variable<DateTime>(paidAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OrdersCompanion(')
          ..write('id: $id, ')
          ..write('orderNo: $orderNo, ')
          ..write('status: $status, ')
          ..write('totalAmountCents: $totalAmountCents, ')
          ..write('discountCents: $discountCents, ')
          ..write('payableCents: $payableCents, ')
          ..write('couponId: $couponId, ')
          ..write('createdAt: $createdAt, ')
          ..write('paidAt: $paidAt')
          ..write(')'))
        .toString();
  }
}

class $OrderItemsTable extends OrderItems
    with TableInfo<$OrderItemsTable, OrderItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OrderItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _orderIdMeta = const VerificationMeta(
    'orderId',
  );
  @override
  late final GeneratedColumn<int> orderId = GeneratedColumn<int>(
    'order_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES orders (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<int> productId = GeneratedColumn<int>(
    'product_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES products (id)',
    ),
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitPriceSnapshotCentsMeta =
      const VerificationMeta('unitPriceSnapshotCents');
  @override
  late final GeneratedColumn<int> unitPriceSnapshotCents = GeneratedColumn<int>(
    'unit_price_snapshot_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    orderId,
    productId,
    quantity,
    unitPriceSnapshotCents,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'order_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<OrderItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('order_id')) {
      context.handle(
        _orderIdMeta,
        orderId.isAcceptableOrUnknown(data['order_id']!, _orderIdMeta),
      );
    } else if (isInserting) {
      context.missing(_orderIdMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('unit_price_snapshot_cents')) {
      context.handle(
        _unitPriceSnapshotCentsMeta,
        unitPriceSnapshotCents.isAcceptableOrUnknown(
          data['unit_price_snapshot_cents']!,
          _unitPriceSnapshotCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_unitPriceSnapshotCentsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OrderItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OrderItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      orderId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order_id'],
      )!,
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}product_id'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantity'],
      )!,
      unitPriceSnapshotCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}unit_price_snapshot_cents'],
      )!,
    );
  }

  @override
  $OrderItemsTable createAlias(String alias) {
    return $OrderItemsTable(attachedDatabase, alias);
  }
}

class OrderItem extends DataClass implements Insertable<OrderItem> {
  final int id;
  final int orderId;
  final int productId;
  final int quantity;
  final int unitPriceSnapshotCents;
  const OrderItem({
    required this.id,
    required this.orderId,
    required this.productId,
    required this.quantity,
    required this.unitPriceSnapshotCents,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['order_id'] = Variable<int>(orderId);
    map['product_id'] = Variable<int>(productId);
    map['quantity'] = Variable<int>(quantity);
    map['unit_price_snapshot_cents'] = Variable<int>(unitPriceSnapshotCents);
    return map;
  }

  OrderItemsCompanion toCompanion(bool nullToAbsent) {
    return OrderItemsCompanion(
      id: Value(id),
      orderId: Value(orderId),
      productId: Value(productId),
      quantity: Value(quantity),
      unitPriceSnapshotCents: Value(unitPriceSnapshotCents),
    );
  }

  factory OrderItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OrderItem(
      id: serializer.fromJson<int>(json['id']),
      orderId: serializer.fromJson<int>(json['orderId']),
      productId: serializer.fromJson<int>(json['productId']),
      quantity: serializer.fromJson<int>(json['quantity']),
      unitPriceSnapshotCents: serializer.fromJson<int>(
        json['unitPriceSnapshotCents'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'orderId': serializer.toJson<int>(orderId),
      'productId': serializer.toJson<int>(productId),
      'quantity': serializer.toJson<int>(quantity),
      'unitPriceSnapshotCents': serializer.toJson<int>(unitPriceSnapshotCents),
    };
  }

  OrderItem copyWith({
    int? id,
    int? orderId,
    int? productId,
    int? quantity,
    int? unitPriceSnapshotCents,
  }) => OrderItem(
    id: id ?? this.id,
    orderId: orderId ?? this.orderId,
    productId: productId ?? this.productId,
    quantity: quantity ?? this.quantity,
    unitPriceSnapshotCents:
        unitPriceSnapshotCents ?? this.unitPriceSnapshotCents,
  );
  OrderItem copyWithCompanion(OrderItemsCompanion data) {
    return OrderItem(
      id: data.id.present ? data.id.value : this.id,
      orderId: data.orderId.present ? data.orderId.value : this.orderId,
      productId: data.productId.present ? data.productId.value : this.productId,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      unitPriceSnapshotCents: data.unitPriceSnapshotCents.present
          ? data.unitPriceSnapshotCents.value
          : this.unitPriceSnapshotCents,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OrderItem(')
          ..write('id: $id, ')
          ..write('orderId: $orderId, ')
          ..write('productId: $productId, ')
          ..write('quantity: $quantity, ')
          ..write('unitPriceSnapshotCents: $unitPriceSnapshotCents')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, orderId, productId, quantity, unitPriceSnapshotCents);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OrderItem &&
          other.id == this.id &&
          other.orderId == this.orderId &&
          other.productId == this.productId &&
          other.quantity == this.quantity &&
          other.unitPriceSnapshotCents == this.unitPriceSnapshotCents);
}

class OrderItemsCompanion extends UpdateCompanion<OrderItem> {
  final Value<int> id;
  final Value<int> orderId;
  final Value<int> productId;
  final Value<int> quantity;
  final Value<int> unitPriceSnapshotCents;
  const OrderItemsCompanion({
    this.id = const Value.absent(),
    this.orderId = const Value.absent(),
    this.productId = const Value.absent(),
    this.quantity = const Value.absent(),
    this.unitPriceSnapshotCents = const Value.absent(),
  });
  OrderItemsCompanion.insert({
    this.id = const Value.absent(),
    required int orderId,
    required int productId,
    required int quantity,
    required int unitPriceSnapshotCents,
  }) : orderId = Value(orderId),
       productId = Value(productId),
       quantity = Value(quantity),
       unitPriceSnapshotCents = Value(unitPriceSnapshotCents);
  static Insertable<OrderItem> custom({
    Expression<int>? id,
    Expression<int>? orderId,
    Expression<int>? productId,
    Expression<int>? quantity,
    Expression<int>? unitPriceSnapshotCents,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (orderId != null) 'order_id': orderId,
      if (productId != null) 'product_id': productId,
      if (quantity != null) 'quantity': quantity,
      if (unitPriceSnapshotCents != null)
        'unit_price_snapshot_cents': unitPriceSnapshotCents,
    });
  }

  OrderItemsCompanion copyWith({
    Value<int>? id,
    Value<int>? orderId,
    Value<int>? productId,
    Value<int>? quantity,
    Value<int>? unitPriceSnapshotCents,
  }) {
    return OrderItemsCompanion(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
      unitPriceSnapshotCents:
          unitPriceSnapshotCents ?? this.unitPriceSnapshotCents,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (orderId.present) {
      map['order_id'] = Variable<int>(orderId.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<int>(productId.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (unitPriceSnapshotCents.present) {
      map['unit_price_snapshot_cents'] = Variable<int>(
        unitPriceSnapshotCents.value,
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OrderItemsCompanion(')
          ..write('id: $id, ')
          ..write('orderId: $orderId, ')
          ..write('productId: $productId, ')
          ..write('quantity: $quantity, ')
          ..write('unitPriceSnapshotCents: $unitPriceSnapshotCents')
          ..write(')'))
        .toString();
  }
}

class $WishlistItemsTable extends WishlistItems
    with TableInfo<$WishlistItemsTable, WishlistItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WishlistItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<int> productId = GeneratedColumn<int>(
    'product_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'UNIQUE REFERENCES products (id)',
    ),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, productId, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'wishlist_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<WishlistItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WishlistItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WishlistItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}product_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $WishlistItemsTable createAlias(String alias) {
    return $WishlistItemsTable(attachedDatabase, alias);
  }
}

class WishlistItem extends DataClass implements Insertable<WishlistItem> {
  final int id;
  final int productId;
  final DateTime createdAt;
  const WishlistItem({
    required this.id,
    required this.productId,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['product_id'] = Variable<int>(productId);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  WishlistItemsCompanion toCompanion(bool nullToAbsent) {
    return WishlistItemsCompanion(
      id: Value(id),
      productId: Value(productId),
      createdAt: Value(createdAt),
    );
  }

  factory WishlistItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WishlistItem(
      id: serializer.fromJson<int>(json['id']),
      productId: serializer.fromJson<int>(json['productId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'productId': serializer.toJson<int>(productId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  WishlistItem copyWith({int? id, int? productId, DateTime? createdAt}) =>
      WishlistItem(
        id: id ?? this.id,
        productId: productId ?? this.productId,
        createdAt: createdAt ?? this.createdAt,
      );
  WishlistItem copyWithCompanion(WishlistItemsCompanion data) {
    return WishlistItem(
      id: data.id.present ? data.id.value : this.id,
      productId: data.productId.present ? data.productId.value : this.productId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WishlistItem(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, productId, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WishlistItem &&
          other.id == this.id &&
          other.productId == this.productId &&
          other.createdAt == this.createdAt);
}

class WishlistItemsCompanion extends UpdateCompanion<WishlistItem> {
  final Value<int> id;
  final Value<int> productId;
  final Value<DateTime> createdAt;
  const WishlistItemsCompanion({
    this.id = const Value.absent(),
    this.productId = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  WishlistItemsCompanion.insert({
    this.id = const Value.absent(),
    required int productId,
    required DateTime createdAt,
  }) : productId = Value(productId),
       createdAt = Value(createdAt);
  static Insertable<WishlistItem> custom({
    Expression<int>? id,
    Expression<int>? productId,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (productId != null) 'product_id': productId,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  WishlistItemsCompanion copyWith({
    Value<int>? id,
    Value<int>? productId,
    Value<DateTime>? createdAt,
  }) {
    return WishlistItemsCompanion(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<int>(productId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WishlistItemsCompanion(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $CheckinsTable extends Checkins with TableInfo<$CheckinsTable, Checkin> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CheckinsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _dateKeyMeta = const VerificationMeta(
    'dateKey',
  );
  @override
  late final GeneratedColumn<String> dateKey = GeneratedColumn<String>(
    'date_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _rewardCentsMeta = const VerificationMeta(
    'rewardCents',
  );
  @override
  late final GeneratedColumn<int> rewardCents = GeneratedColumn<int>(
    'reward_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _streakMeta = const VerificationMeta('streak');
  @override
  late final GeneratedColumn<int> streak = GeneratedColumn<int>(
    'streak',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, dateKey, rewardCents, streak];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'checkins';
  @override
  VerificationContext validateIntegrity(
    Insertable<Checkin> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date_key')) {
      context.handle(
        _dateKeyMeta,
        dateKey.isAcceptableOrUnknown(data['date_key']!, _dateKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_dateKeyMeta);
    }
    if (data.containsKey('reward_cents')) {
      context.handle(
        _rewardCentsMeta,
        rewardCents.isAcceptableOrUnknown(
          data['reward_cents']!,
          _rewardCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_rewardCentsMeta);
    }
    if (data.containsKey('streak')) {
      context.handle(
        _streakMeta,
        streak.isAcceptableOrUnknown(data['streak']!, _streakMeta),
      );
    } else if (isInserting) {
      context.missing(_streakMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Checkin map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Checkin(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      dateKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date_key'],
      )!,
      rewardCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reward_cents'],
      )!,
      streak: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}streak'],
      )!,
    );
  }

  @override
  $CheckinsTable createAlias(String alias) {
    return $CheckinsTable(attachedDatabase, alias);
  }
}

class Checkin extends DataClass implements Insertable<Checkin> {
  final int id;
  final String dateKey;
  final int rewardCents;
  final int streak;
  const Checkin({
    required this.id,
    required this.dateKey,
    required this.rewardCents,
    required this.streak,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date_key'] = Variable<String>(dateKey);
    map['reward_cents'] = Variable<int>(rewardCents);
    map['streak'] = Variable<int>(streak);
    return map;
  }

  CheckinsCompanion toCompanion(bool nullToAbsent) {
    return CheckinsCompanion(
      id: Value(id),
      dateKey: Value(dateKey),
      rewardCents: Value(rewardCents),
      streak: Value(streak),
    );
  }

  factory Checkin.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Checkin(
      id: serializer.fromJson<int>(json['id']),
      dateKey: serializer.fromJson<String>(json['dateKey']),
      rewardCents: serializer.fromJson<int>(json['rewardCents']),
      streak: serializer.fromJson<int>(json['streak']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'dateKey': serializer.toJson<String>(dateKey),
      'rewardCents': serializer.toJson<int>(rewardCents),
      'streak': serializer.toJson<int>(streak),
    };
  }

  Checkin copyWith({int? id, String? dateKey, int? rewardCents, int? streak}) =>
      Checkin(
        id: id ?? this.id,
        dateKey: dateKey ?? this.dateKey,
        rewardCents: rewardCents ?? this.rewardCents,
        streak: streak ?? this.streak,
      );
  Checkin copyWithCompanion(CheckinsCompanion data) {
    return Checkin(
      id: data.id.present ? data.id.value : this.id,
      dateKey: data.dateKey.present ? data.dateKey.value : this.dateKey,
      rewardCents: data.rewardCents.present
          ? data.rewardCents.value
          : this.rewardCents,
      streak: data.streak.present ? data.streak.value : this.streak,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Checkin(')
          ..write('id: $id, ')
          ..write('dateKey: $dateKey, ')
          ..write('rewardCents: $rewardCents, ')
          ..write('streak: $streak')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, dateKey, rewardCents, streak);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Checkin &&
          other.id == this.id &&
          other.dateKey == this.dateKey &&
          other.rewardCents == this.rewardCents &&
          other.streak == this.streak);
}

class CheckinsCompanion extends UpdateCompanion<Checkin> {
  final Value<int> id;
  final Value<String> dateKey;
  final Value<int> rewardCents;
  final Value<int> streak;
  const CheckinsCompanion({
    this.id = const Value.absent(),
    this.dateKey = const Value.absent(),
    this.rewardCents = const Value.absent(),
    this.streak = const Value.absent(),
  });
  CheckinsCompanion.insert({
    this.id = const Value.absent(),
    required String dateKey,
    required int rewardCents,
    required int streak,
  }) : dateKey = Value(dateKey),
       rewardCents = Value(rewardCents),
       streak = Value(streak);
  static Insertable<Checkin> custom({
    Expression<int>? id,
    Expression<String>? dateKey,
    Expression<int>? rewardCents,
    Expression<int>? streak,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (dateKey != null) 'date_key': dateKey,
      if (rewardCents != null) 'reward_cents': rewardCents,
      if (streak != null) 'streak': streak,
    });
  }

  CheckinsCompanion copyWith({
    Value<int>? id,
    Value<String>? dateKey,
    Value<int>? rewardCents,
    Value<int>? streak,
  }) {
    return CheckinsCompanion(
      id: id ?? this.id,
      dateKey: dateKey ?? this.dateKey,
      rewardCents: rewardCents ?? this.rewardCents,
      streak: streak ?? this.streak,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (dateKey.present) {
      map['date_key'] = Variable<String>(dateKey.value);
    }
    if (rewardCents.present) {
      map['reward_cents'] = Variable<int>(rewardCents.value);
    }
    if (streak.present) {
      map['streak'] = Variable<int>(streak.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CheckinsCompanion(')
          ..write('id: $id, ')
          ..write('dateKey: $dateKey, ')
          ..write('rewardCents: $rewardCents, ')
          ..write('streak: $streak')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CategoriesTable categories = $CategoriesTable(this);
  late final $ProductsTable products = $ProductsTable(this);
  late final $CartItemsTable cartItems = $CartItemsTable(this);
  late final $WalletsTable wallets = $WalletsTable(this);
  late final $WalletTransactionsTable walletTransactions =
      $WalletTransactionsTable(this);
  late final $CouponsTable coupons = $CouponsTable(this);
  late final $OrdersTable orders = $OrdersTable(this);
  late final $OrderItemsTable orderItems = $OrderItemsTable(this);
  late final $WishlistItemsTable wishlistItems = $WishlistItemsTable(this);
  late final $CheckinsTable checkins = $CheckinsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    categories,
    products,
    cartItems,
    wallets,
    walletTransactions,
    coupons,
    orders,
    orderItems,
    wishlistItems,
    checkins,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'orders',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('order_items', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$CategoriesTableCreateCompanionBuilder = CategoriesCompanion Function({
  Value<int> id,
  required String slug,
  required LocalizedText name,
  required String emoji,
  required int sortOrder,
});
typedef $$CategoriesTableUpdateCompanionBuilder = CategoriesCompanion Function({
  Value<int> id,
  Value<String> slug,
  Value<LocalizedText> name,
  Value<String> emoji,
  Value<int> sortOrder,
});

final class $$CategoriesTableReferences
    extends BaseReferences<_$AppDatabase, $CategoriesTable, Category> {
  $$CategoriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ProductsTable, List<Product>> _productsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.products,
    aliasName: 'categories__id__products__category_id',
  );

  $$ProductsTableProcessedTableManager get productsRefs {
    final manager = $$ProductsTableTableManager(
      $_db,
      $_db.products,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_productsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get slug => $composableBuilder(
    column: $table.slug,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<LocalizedText, LocalizedText, String>
  get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get emoji => $composableBuilder(
    column: $table.emoji,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> productsRefs(
    Expression<bool> Function($$ProductsTableFilterComposer f) f,
  ) {
    final $$ProductsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableFilterComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get slug => $composableBuilder(
    column: $table.slug,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get emoji => $composableBuilder(
    column: $table.emoji,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get slug =>
      $composableBuilder(column: $table.slug, builder: (column) => column);

  GeneratedColumnWithTypeConverter<LocalizedText, String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get emoji =>
      $composableBuilder(column: $table.emoji, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  Expression<T> productsRefs<T extends Object>(
    Expression<T> Function($$ProductsTableAnnotationComposer a) f,
  ) {
    final $$ProductsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableAnnotationComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CategoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CategoriesTable,
          Category,
          $$CategoriesTableFilterComposer,
          $$CategoriesTableOrderingComposer,
          $$CategoriesTableAnnotationComposer,
          $$CategoriesTableCreateCompanionBuilder,
          $$CategoriesTableUpdateCompanionBuilder,
          (Category, $$CategoriesTableReferences),
          Category,
          PrefetchHooks Function({bool productsRefs})
        > {
  $$CategoriesTableTableManager(_$AppDatabase db, $CategoriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> slug = const Value.absent(),
                Value<LocalizedText> name = const Value.absent(),
                Value<String> emoji = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
              }) => CategoriesCompanion(
                id: id,
                slug: slug,
                name: name,
                emoji: emoji,
                sortOrder: sortOrder,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String slug,
                required LocalizedText name,
                required String emoji,
                required int sortOrder,
              }) => CategoriesCompanion.insert(
                id: id,
                slug: slug,
                name: name,
                emoji: emoji,
                sortOrder: sortOrder,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CategoriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({productsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (productsRefs) db.products],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (productsRefs)
                    await $_getPrefetchedData<
                      Category,
                      $CategoriesTable,
                      Product
                    >(
                      currentTable: table,
                      referencedTable: $$CategoriesTableReferences
                          ._productsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$CategoriesTableReferences(
                            db,
                            table,
                            p0,
                          ).productsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.categoryId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$CategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CategoriesTable,
      Category,
      $$CategoriesTableFilterComposer,
      $$CategoriesTableOrderingComposer,
      $$CategoriesTableAnnotationComposer,
      $$CategoriesTableCreateCompanionBuilder,
      $$CategoriesTableUpdateCompanionBuilder,
      (Category, $$CategoriesTableReferences),
      Category,
      PrefetchHooks Function({bool productsRefs})
    >;
typedef $$ProductsTableCreateCompanionBuilder = ProductsCompanion Function({
  Value<int> id,
  required int categoryId,
  required LocalizedText brand,
  required LocalizedText name,
  required LocalizedText subtitle,
  required LocalizedText description,
  required String image,
  required int priceCents,
  required int originalPriceCents,
  required int stock,
  required int sales,
  required double rating,
  required StringList tags,
  Value<bool> flashSale,
});
typedef $$ProductsTableUpdateCompanionBuilder = ProductsCompanion Function({
  Value<int> id,
  Value<int> categoryId,
  Value<LocalizedText> brand,
  Value<LocalizedText> name,
  Value<LocalizedText> subtitle,
  Value<LocalizedText> description,
  Value<String> image,
  Value<int> priceCents,
  Value<int> originalPriceCents,
  Value<int> stock,
  Value<int> sales,
  Value<double> rating,
  Value<StringList> tags,
  Value<bool> flashSale,
});

final class $$ProductsTableReferences
    extends BaseReferences<_$AppDatabase, $ProductsTable, Product> {
  $$ProductsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CategoriesTable _categoryIdTable(_$AppDatabase db) =>
      db.categories.createAlias('products__category_id__categories__id');

  $$CategoriesTableProcessedTableManager get categoryId {
    final $_column = $_itemColumn<int>('category_id')!;

    final manager = $$CategoriesTableTableManager(
      $_db,
      $_db.categories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$CartItemsTable, List<CartItem>>
  _cartItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.cartItems,
    aliasName: 'products__id__cart_items__product_id',
  );

  $$CartItemsTableProcessedTableManager get cartItemsRefs {
    final manager = $$CartItemsTableTableManager(
      $_db,
      $_db.cartItems,
    ).filter((f) => f.productId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_cartItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$OrderItemsTable, List<OrderItem>>
  _orderItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.orderItems,
    aliasName: 'products__id__order_items__product_id',
  );

  $$OrderItemsTableProcessedTableManager get orderItemsRefs {
    final manager = $$OrderItemsTableTableManager(
      $_db,
      $_db.orderItems,
    ).filter((f) => f.productId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_orderItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$WishlistItemsTable, List<WishlistItem>>
  _wishlistItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.wishlistItems,
    aliasName: 'products__id__wishlist_items__product_id',
  );

  $$WishlistItemsTableProcessedTableManager get wishlistItemsRefs {
    final manager = $$WishlistItemsTableTableManager(
      $_db,
      $_db.wishlistItems,
    ).filter((f) => f.productId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_wishlistItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ProductsTableFilterComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<LocalizedText, LocalizedText, String>
  get brand => $composableBuilder(
    column: $table.brand,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<LocalizedText, LocalizedText, String>
  get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<LocalizedText, LocalizedText, String>
  get subtitle => $composableBuilder(
    column: $table.subtitle,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<LocalizedText, LocalizedText, String>
  get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get image => $composableBuilder(
    column: $table.image,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get priceCents => $composableBuilder(
    column: $table.priceCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get originalPriceCents => $composableBuilder(
    column: $table.originalPriceCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get stock => $composableBuilder(
    column: $table.stock,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sales => $composableBuilder(
    column: $table.sales,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get rating => $composableBuilder(
    column: $table.rating,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<StringList, StringList, String> get tags =>
      $composableBuilder(
        column: $table.tags,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<bool> get flashSale => $composableBuilder(
    column: $table.flashSale,
    builder: (column) => ColumnFilters(column),
  );

  $$CategoriesTableFilterComposer get categoryId {
    final $$CategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableFilterComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> cartItemsRefs(
    Expression<bool> Function($$CartItemsTableFilterComposer f) f,
  ) {
    final $$CartItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cartItems,
      getReferencedColumn: (t) => t.productId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CartItemsTableFilterComposer(
            $db: $db,
            $table: $db.cartItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> orderItemsRefs(
    Expression<bool> Function($$OrderItemsTableFilterComposer f) f,
  ) {
    final $$OrderItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.orderItems,
      getReferencedColumn: (t) => t.productId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrderItemsTableFilterComposer(
            $db: $db,
            $table: $db.orderItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> wishlistItemsRefs(
    Expression<bool> Function($$WishlistItemsTableFilterComposer f) f,
  ) {
    final $$WishlistItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.wishlistItems,
      getReferencedColumn: (t) => t.productId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WishlistItemsTableFilterComposer(
            $db: $db,
            $table: $db.wishlistItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProductsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get brand => $composableBuilder(
    column: $table.brand,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get subtitle => $composableBuilder(
    column: $table.subtitle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get image => $composableBuilder(
    column: $table.image,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get priceCents => $composableBuilder(
    column: $table.priceCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get originalPriceCents => $composableBuilder(
    column: $table.originalPriceCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get stock => $composableBuilder(
    column: $table.stock,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sales => $composableBuilder(
    column: $table.sales,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get rating => $composableBuilder(
    column: $table.rating,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get flashSale => $composableBuilder(
    column: $table.flashSale,
    builder: (column) => ColumnOrderings(column),
  );

  $$CategoriesTableOrderingComposer get categoryId {
    final $$CategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProductsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<LocalizedText, String> get brand =>
      $composableBuilder(column: $table.brand, builder: (column) => column);

  GeneratedColumnWithTypeConverter<LocalizedText, String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumnWithTypeConverter<LocalizedText, String> get subtitle =>
      $composableBuilder(column: $table.subtitle, builder: (column) => column);

  GeneratedColumnWithTypeConverter<LocalizedText, String> get description =>
      $composableBuilder(
        column: $table.description,
        builder: (column) => column,
      );

  GeneratedColumn<String> get image =>
      $composableBuilder(column: $table.image, builder: (column) => column);

  GeneratedColumn<int> get priceCents => $composableBuilder(
    column: $table.priceCents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get originalPriceCents => $composableBuilder(
    column: $table.originalPriceCents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get stock =>
      $composableBuilder(column: $table.stock, builder: (column) => column);

  GeneratedColumn<int> get sales =>
      $composableBuilder(column: $table.sales, builder: (column) => column);

  GeneratedColumn<double> get rating =>
      $composableBuilder(column: $table.rating, builder: (column) => column);

  GeneratedColumnWithTypeConverter<StringList, String> get tags =>
      $composableBuilder(column: $table.tags, builder: (column) => column);

  GeneratedColumn<bool> get flashSale =>
      $composableBuilder(column: $table.flashSale, builder: (column) => column);

  $$CategoriesTableAnnotationComposer get categoryId {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> cartItemsRefs<T extends Object>(
    Expression<T> Function($$CartItemsTableAnnotationComposer a) f,
  ) {
    final $$CartItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cartItems,
      getReferencedColumn: (t) => t.productId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CartItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.cartItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> orderItemsRefs<T extends Object>(
    Expression<T> Function($$OrderItemsTableAnnotationComposer a) f,
  ) {
    final $$OrderItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.orderItems,
      getReferencedColumn: (t) => t.productId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrderItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.orderItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> wishlistItemsRefs<T extends Object>(
    Expression<T> Function($$WishlistItemsTableAnnotationComposer a) f,
  ) {
    final $$WishlistItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.wishlistItems,
      getReferencedColumn: (t) => t.productId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WishlistItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.wishlistItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProductsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProductsTable,
          Product,
          $$ProductsTableFilterComposer,
          $$ProductsTableOrderingComposer,
          $$ProductsTableAnnotationComposer,
          $$ProductsTableCreateCompanionBuilder,
          $$ProductsTableUpdateCompanionBuilder,
          (Product, $$ProductsTableReferences),
          Product,
          PrefetchHooks Function({
            bool categoryId,
            bool cartItemsRefs,
            bool orderItemsRefs,
            bool wishlistItemsRefs,
          })
        > {
  $$ProductsTableTableManager(_$AppDatabase db, $ProductsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> categoryId = const Value.absent(),
                Value<LocalizedText> brand = const Value.absent(),
                Value<LocalizedText> name = const Value.absent(),
                Value<LocalizedText> subtitle = const Value.absent(),
                Value<LocalizedText> description = const Value.absent(),
                Value<String> image = const Value.absent(),
                Value<int> priceCents = const Value.absent(),
                Value<int> originalPriceCents = const Value.absent(),
                Value<int> stock = const Value.absent(),
                Value<int> sales = const Value.absent(),
                Value<double> rating = const Value.absent(),
                Value<StringList> tags = const Value.absent(),
                Value<bool> flashSale = const Value.absent(),
              }) => ProductsCompanion(
                id: id,
                categoryId: categoryId,
                brand: brand,
                name: name,
                subtitle: subtitle,
                description: description,
                image: image,
                priceCents: priceCents,
                originalPriceCents: originalPriceCents,
                stock: stock,
                sales: sales,
                rating: rating,
                tags: tags,
                flashSale: flashSale,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int categoryId,
                required LocalizedText brand,
                required LocalizedText name,
                required LocalizedText subtitle,
                required LocalizedText description,
                required String image,
                required int priceCents,
                required int originalPriceCents,
                required int stock,
                required int sales,
                required double rating,
                required StringList tags,
                Value<bool> flashSale = const Value.absent(),
              }) => ProductsCompanion.insert(
                id: id,
                categoryId: categoryId,
                brand: brand,
                name: name,
                subtitle: subtitle,
                description: description,
                image: image,
                priceCents: priceCents,
                originalPriceCents: originalPriceCents,
                stock: stock,
                sales: sales,
                rating: rating,
                tags: tags,
                flashSale: flashSale,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ProductsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                categoryId = false,
                cartItemsRefs = false,
                orderItemsRefs = false,
                wishlistItemsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (cartItemsRefs) db.cartItems,
                    if (orderItemsRefs) db.orderItems,
                    if (wishlistItemsRefs) db.wishlistItems,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (categoryId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.categoryId,
                            referencedTable: $$ProductsTableReferences
                                ._categoryIdTable(db),
                            referencedColumn: $$ProductsTableReferences
                                ._categoryIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (cartItemsRefs)
                        await $_getPrefetchedData<
                          Product,
                          $ProductsTable,
                          CartItem
                        >(
                          currentTable: table,
                          referencedTable: $$ProductsTableReferences
                              ._cartItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProductsTableReferences(
                                db,
                                table,
                                p0,
                              ).cartItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.productId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (orderItemsRefs)
                        await $_getPrefetchedData<
                          Product,
                          $ProductsTable,
                          OrderItem
                        >(
                          currentTable: table,
                          referencedTable: $$ProductsTableReferences
                              ._orderItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProductsTableReferences(
                                db,
                                table,
                                p0,
                              ).orderItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.productId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (wishlistItemsRefs)
                        await $_getPrefetchedData<
                          Product,
                          $ProductsTable,
                          WishlistItem
                        >(
                          currentTable: table,
                          referencedTable: $$ProductsTableReferences
                              ._wishlistItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProductsTableReferences(
                                db,
                                table,
                                p0,
                              ).wishlistItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.productId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ProductsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProductsTable,
      Product,
      $$ProductsTableFilterComposer,
      $$ProductsTableOrderingComposer,
      $$ProductsTableAnnotationComposer,
      $$ProductsTableCreateCompanionBuilder,
      $$ProductsTableUpdateCompanionBuilder,
      (Product, $$ProductsTableReferences),
      Product,
      PrefetchHooks Function({
        bool categoryId,
        bool cartItemsRefs,
        bool orderItemsRefs,
        bool wishlistItemsRefs,
      })
    >;
typedef $$CartItemsTableCreateCompanionBuilder = CartItemsCompanion Function({
  Value<int> id,
  required int productId,
  required int quantity,
  Value<bool> selected,
});
typedef $$CartItemsTableUpdateCompanionBuilder = CartItemsCompanion Function({
  Value<int> id,
  Value<int> productId,
  Value<int> quantity,
  Value<bool> selected,
});

final class $$CartItemsTableReferences
    extends BaseReferences<_$AppDatabase, $CartItemsTable, CartItem> {
  $$CartItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ProductsTable _productIdTable(_$AppDatabase db) =>
      db.products.createAlias('cart_items__product_id__products__id');

  $$ProductsTableProcessedTableManager get productId {
    final $_column = $_itemColumn<int>('product_id')!;

    final manager = $$ProductsTableTableManager(
      $_db,
      $_db.products,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_productIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CartItemsTableFilterComposer
    extends Composer<_$AppDatabase, $CartItemsTable> {
  $$CartItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get selected => $composableBuilder(
    column: $table.selected,
    builder: (column) => ColumnFilters(column),
  );

  $$ProductsTableFilterComposer get productId {
    final $$ProductsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableFilterComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CartItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $CartItemsTable> {
  $$CartItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get selected => $composableBuilder(
    column: $table.selected,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProductsTableOrderingComposer get productId {
    final $$ProductsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableOrderingComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CartItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CartItemsTable> {
  $$CartItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<bool> get selected =>
      $composableBuilder(column: $table.selected, builder: (column) => column);

  $$ProductsTableAnnotationComposer get productId {
    final $$ProductsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableAnnotationComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CartItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CartItemsTable,
          CartItem,
          $$CartItemsTableFilterComposer,
          $$CartItemsTableOrderingComposer,
          $$CartItemsTableAnnotationComposer,
          $$CartItemsTableCreateCompanionBuilder,
          $$CartItemsTableUpdateCompanionBuilder,
          (CartItem, $$CartItemsTableReferences),
          CartItem,
          PrefetchHooks Function({bool productId})
        > {
  $$CartItemsTableTableManager(_$AppDatabase db, $CartItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CartItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CartItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CartItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> productId = const Value.absent(),
                Value<int> quantity = const Value.absent(),
                Value<bool> selected = const Value.absent(),
              }) => CartItemsCompanion(
                id: id,
                productId: productId,
                quantity: quantity,
                selected: selected,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int productId,
                required int quantity,
                Value<bool> selected = const Value.absent(),
              }) => CartItemsCompanion.insert(
                id: id,
                productId: productId,
                quantity: quantity,
                selected: selected,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CartItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({productId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (productId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.productId,
                        referencedTable: $$CartItemsTableReferences
                            ._productIdTable(db),
                        referencedColumn: $$CartItemsTableReferences
                            ._productIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$CartItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CartItemsTable,
      CartItem,
      $$CartItemsTableFilterComposer,
      $$CartItemsTableOrderingComposer,
      $$CartItemsTableAnnotationComposer,
      $$CartItemsTableCreateCompanionBuilder,
      $$CartItemsTableUpdateCompanionBuilder,
      (CartItem, $$CartItemsTableReferences),
      CartItem,
      PrefetchHooks Function({bool productId})
    >;
typedef $$WalletsTableCreateCompanionBuilder = WalletsCompanion Function({
  Value<int> id,
  required int balanceCents,
  required int totalRechargeCents,
  required int totalSpentCents,
});
typedef $$WalletsTableUpdateCompanionBuilder = WalletsCompanion Function({
  Value<int> id,
  Value<int> balanceCents,
  Value<int> totalRechargeCents,
  Value<int> totalSpentCents,
});

class $$WalletsTableFilterComposer
    extends Composer<_$AppDatabase, $WalletsTable> {
  $$WalletsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get balanceCents => $composableBuilder(
    column: $table.balanceCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalRechargeCents => $composableBuilder(
    column: $table.totalRechargeCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalSpentCents => $composableBuilder(
    column: $table.totalSpentCents,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WalletsTableOrderingComposer
    extends Composer<_$AppDatabase, $WalletsTable> {
  $$WalletsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get balanceCents => $composableBuilder(
    column: $table.balanceCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalRechargeCents => $composableBuilder(
    column: $table.totalRechargeCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalSpentCents => $composableBuilder(
    column: $table.totalSpentCents,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WalletsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WalletsTable> {
  $$WalletsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get balanceCents => $composableBuilder(
    column: $table.balanceCents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalRechargeCents => $composableBuilder(
    column: $table.totalRechargeCents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalSpentCents => $composableBuilder(
    column: $table.totalSpentCents,
    builder: (column) => column,
  );
}

class $$WalletsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WalletsTable,
          Wallet,
          $$WalletsTableFilterComposer,
          $$WalletsTableOrderingComposer,
          $$WalletsTableAnnotationComposer,
          $$WalletsTableCreateCompanionBuilder,
          $$WalletsTableUpdateCompanionBuilder,
          (Wallet, BaseReferences<_$AppDatabase, $WalletsTable, Wallet>),
          Wallet,
          PrefetchHooks Function()
        > {
  $$WalletsTableTableManager(_$AppDatabase db, $WalletsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WalletsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WalletsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WalletsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> balanceCents = const Value.absent(),
                Value<int> totalRechargeCents = const Value.absent(),
                Value<int> totalSpentCents = const Value.absent(),
              }) => WalletsCompanion(
                id: id,
                balanceCents: balanceCents,
                totalRechargeCents: totalRechargeCents,
                totalSpentCents: totalSpentCents,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int balanceCents,
                required int totalRechargeCents,
                required int totalSpentCents,
              }) => WalletsCompanion.insert(
                id: id,
                balanceCents: balanceCents,
                totalRechargeCents: totalRechargeCents,
                totalSpentCents: totalSpentCents,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WalletsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WalletsTable,
      Wallet,
      $$WalletsTableFilterComposer,
      $$WalletsTableOrderingComposer,
      $$WalletsTableAnnotationComposer,
      $$WalletsTableCreateCompanionBuilder,
      $$WalletsTableUpdateCompanionBuilder,
      (Wallet, BaseReferences<_$AppDatabase, $WalletsTable, Wallet>),
      Wallet,
      PrefetchHooks Function()
    >;
typedef $$WalletTransactionsTableCreateCompanionBuilder =
    WalletTransactionsCompanion Function({
      Value<int> id,
      required TxType type,
      required int amountCents,
      required int balanceAfterCents,
      Value<String?> refText,
      required DateTime createdAt,
    });
typedef $$WalletTransactionsTableUpdateCompanionBuilder =
    WalletTransactionsCompanion Function({
      Value<int> id,
      Value<TxType> type,
      Value<int> amountCents,
      Value<int> balanceAfterCents,
      Value<String?> refText,
      Value<DateTime> createdAt,
    });

class $$WalletTransactionsTableFilterComposer
    extends Composer<_$AppDatabase, $WalletTransactionsTable> {
  $$WalletTransactionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<TxType, TxType, int> get type =>
      $composableBuilder(
        column: $table.type,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get balanceAfterCents => $composableBuilder(
    column: $table.balanceAfterCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get refText => $composableBuilder(
    column: $table.refText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WalletTransactionsTableOrderingComposer
    extends Composer<_$AppDatabase, $WalletTransactionsTable> {
  $$WalletTransactionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get balanceAfterCents => $composableBuilder(
    column: $table.balanceAfterCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get refText => $composableBuilder(
    column: $table.refText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WalletTransactionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WalletTransactionsTable> {
  $$WalletTransactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TxType, int> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get balanceAfterCents => $composableBuilder(
    column: $table.balanceAfterCents,
    builder: (column) => column,
  );

  GeneratedColumn<String> get refText =>
      $composableBuilder(column: $table.refText, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$WalletTransactionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WalletTransactionsTable,
          WalletTransaction,
          $$WalletTransactionsTableFilterComposer,
          $$WalletTransactionsTableOrderingComposer,
          $$WalletTransactionsTableAnnotationComposer,
          $$WalletTransactionsTableCreateCompanionBuilder,
          $$WalletTransactionsTableUpdateCompanionBuilder,
          (
            WalletTransaction,
            BaseReferences<
              _$AppDatabase,
              $WalletTransactionsTable,
              WalletTransaction
            >,
          ),
          WalletTransaction,
          PrefetchHooks Function()
        > {
  $$WalletTransactionsTableTableManager(
    _$AppDatabase db,
    $WalletTransactionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WalletTransactionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WalletTransactionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WalletTransactionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<TxType> type = const Value.absent(),
                Value<int> amountCents = const Value.absent(),
                Value<int> balanceAfterCents = const Value.absent(),
                Value<String?> refText = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => WalletTransactionsCompanion(
                id: id,
                type: type,
                amountCents: amountCents,
                balanceAfterCents: balanceAfterCents,
                refText: refText,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required TxType type,
                required int amountCents,
                required int balanceAfterCents,
                Value<String?> refText = const Value.absent(),
                required DateTime createdAt,
              }) => WalletTransactionsCompanion.insert(
                id: id,
                type: type,
                amountCents: amountCents,
                balanceAfterCents: balanceAfterCents,
                refText: refText,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WalletTransactionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WalletTransactionsTable,
      WalletTransaction,
      $$WalletTransactionsTableFilterComposer,
      $$WalletTransactionsTableOrderingComposer,
      $$WalletTransactionsTableAnnotationComposer,
      $$WalletTransactionsTableCreateCompanionBuilder,
      $$WalletTransactionsTableUpdateCompanionBuilder,
      (
        WalletTransaction,
        BaseReferences<
          _$AppDatabase,
          $WalletTransactionsTable,
          WalletTransaction
        >,
      ),
      WalletTransaction,
      PrefetchHooks Function()
    >;
typedef $$CouponsTableCreateCompanionBuilder = CouponsCompanion Function({
  Value<int> id,
  required String titleKey,
  required bool isRate,
  required int valueInt,
  required int minSpendCents,
  required DateTime expiresAt,
  required CouponStatus status,
});
typedef $$CouponsTableUpdateCompanionBuilder = CouponsCompanion Function({
  Value<int> id,
  Value<String> titleKey,
  Value<bool> isRate,
  Value<int> valueInt,
  Value<int> minSpendCents,
  Value<DateTime> expiresAt,
  Value<CouponStatus> status,
});

final class $$CouponsTableReferences
    extends BaseReferences<_$AppDatabase, $CouponsTable, Coupon> {
  $$CouponsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$OrdersTable, List<Order>> _ordersRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.orders,
    aliasName: 'coupons__id__orders__coupon_id',
  );

  $$OrdersTableProcessedTableManager get ordersRefs {
    final manager = $$OrdersTableTableManager(
      $_db,
      $_db.orders,
    ).filter((f) => f.couponId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_ordersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CouponsTableFilterComposer
    extends Composer<_$AppDatabase, $CouponsTable> {
  $$CouponsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get titleKey => $composableBuilder(
    column: $table.titleKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isRate => $composableBuilder(
    column: $table.isRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get valueInt => $composableBuilder(
    column: $table.valueInt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get minSpendCents => $composableBuilder(
    column: $table.minSpendCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get expiresAt => $composableBuilder(
    column: $table.expiresAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<CouponStatus, CouponStatus, int> get status =>
      $composableBuilder(
        column: $table.status,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  Expression<bool> ordersRefs(
    Expression<bool> Function($$OrdersTableFilterComposer f) f,
  ) {
    final $$OrdersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.orders,
      getReferencedColumn: (t) => t.couponId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdersTableFilterComposer(
            $db: $db,
            $table: $db.orders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CouponsTableOrderingComposer
    extends Composer<_$AppDatabase, $CouponsTable> {
  $$CouponsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get titleKey => $composableBuilder(
    column: $table.titleKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isRate => $composableBuilder(
    column: $table.isRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get valueInt => $composableBuilder(
    column: $table.valueInt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get minSpendCents => $composableBuilder(
    column: $table.minSpendCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get expiresAt => $composableBuilder(
    column: $table.expiresAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CouponsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CouponsTable> {
  $$CouponsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get titleKey =>
      $composableBuilder(column: $table.titleKey, builder: (column) => column);

  GeneratedColumn<bool> get isRate =>
      $composableBuilder(column: $table.isRate, builder: (column) => column);

  GeneratedColumn<int> get valueInt =>
      $composableBuilder(column: $table.valueInt, builder: (column) => column);

  GeneratedColumn<int> get minSpendCents => $composableBuilder(
    column: $table.minSpendCents,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get expiresAt =>
      $composableBuilder(column: $table.expiresAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<CouponStatus, int> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  Expression<T> ordersRefs<T extends Object>(
    Expression<T> Function($$OrdersTableAnnotationComposer a) f,
  ) {
    final $$OrdersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.orders,
      getReferencedColumn: (t) => t.couponId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdersTableAnnotationComposer(
            $db: $db,
            $table: $db.orders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CouponsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CouponsTable,
          Coupon,
          $$CouponsTableFilterComposer,
          $$CouponsTableOrderingComposer,
          $$CouponsTableAnnotationComposer,
          $$CouponsTableCreateCompanionBuilder,
          $$CouponsTableUpdateCompanionBuilder,
          (Coupon, $$CouponsTableReferences),
          Coupon,
          PrefetchHooks Function({bool ordersRefs})
        > {
  $$CouponsTableTableManager(_$AppDatabase db, $CouponsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CouponsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CouponsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CouponsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> titleKey = const Value.absent(),
                Value<bool> isRate = const Value.absent(),
                Value<int> valueInt = const Value.absent(),
                Value<int> minSpendCents = const Value.absent(),
                Value<DateTime> expiresAt = const Value.absent(),
                Value<CouponStatus> status = const Value.absent(),
              }) => CouponsCompanion(
                id: id,
                titleKey: titleKey,
                isRate: isRate,
                valueInt: valueInt,
                minSpendCents: minSpendCents,
                expiresAt: expiresAt,
                status: status,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String titleKey,
                required bool isRate,
                required int valueInt,
                required int minSpendCents,
                required DateTime expiresAt,
                required CouponStatus status,
              }) => CouponsCompanion.insert(
                id: id,
                titleKey: titleKey,
                isRate: isRate,
                valueInt: valueInt,
                minSpendCents: minSpendCents,
                expiresAt: expiresAt,
                status: status,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CouponsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({ordersRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (ordersRefs) db.orders],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (ordersRefs)
                    await $_getPrefetchedData<Coupon, $CouponsTable, Order>(
                      currentTable: table,
                      referencedTable: $$CouponsTableReferences
                          ._ordersRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$CouponsTableReferences(db, table, p0).ordersRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.couponId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$CouponsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CouponsTable,
      Coupon,
      $$CouponsTableFilterComposer,
      $$CouponsTableOrderingComposer,
      $$CouponsTableAnnotationComposer,
      $$CouponsTableCreateCompanionBuilder,
      $$CouponsTableUpdateCompanionBuilder,
      (Coupon, $$CouponsTableReferences),
      Coupon,
      PrefetchHooks Function({bool ordersRefs})
    >;
typedef $$OrdersTableCreateCompanionBuilder = OrdersCompanion Function({
  Value<int> id,
  required String orderNo,
  required OrderStatus status,
  required int totalAmountCents,
  required int discountCents,
  required int payableCents,
  Value<int?> couponId,
  required DateTime createdAt,
  Value<DateTime?> paidAt,
});
typedef $$OrdersTableUpdateCompanionBuilder = OrdersCompanion Function({
  Value<int> id,
  Value<String> orderNo,
  Value<OrderStatus> status,
  Value<int> totalAmountCents,
  Value<int> discountCents,
  Value<int> payableCents,
  Value<int?> couponId,
  Value<DateTime> createdAt,
  Value<DateTime?> paidAt,
});

final class $$OrdersTableReferences
    extends BaseReferences<_$AppDatabase, $OrdersTable, Order> {
  $$OrdersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CouponsTable _couponIdTable(_$AppDatabase db) =>
      db.coupons.createAlias('orders__coupon_id__coupons__id');

  $$CouponsTableProcessedTableManager? get couponId {
    final $_column = $_itemColumn<int>('coupon_id');
    if ($_column == null) return null;
    final manager = $$CouponsTableTableManager(
      $_db,
      $_db.coupons,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_couponIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$OrderItemsTable, List<OrderItem>>
  _orderItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.orderItems,
    aliasName: 'orders__id__order_items__order_id',
  );

  $$OrderItemsTableProcessedTableManager get orderItemsRefs {
    final manager = $$OrderItemsTableTableManager(
      $_db,
      $_db.orderItems,
    ).filter((f) => f.orderId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_orderItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$OrdersTableFilterComposer
    extends Composer<_$AppDatabase, $OrdersTable> {
  $$OrdersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get orderNo => $composableBuilder(
    column: $table.orderNo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<OrderStatus, OrderStatus, int> get status =>
      $composableBuilder(
        column: $table.status,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get totalAmountCents => $composableBuilder(
    column: $table.totalAmountCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get discountCents => $composableBuilder(
    column: $table.discountCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get payableCents => $composableBuilder(
    column: $table.payableCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get paidAt => $composableBuilder(
    column: $table.paidAt,
    builder: (column) => ColumnFilters(column),
  );

  $$CouponsTableFilterComposer get couponId {
    final $$CouponsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.couponId,
      referencedTable: $db.coupons,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CouponsTableFilterComposer(
            $db: $db,
            $table: $db.coupons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> orderItemsRefs(
    Expression<bool> Function($$OrderItemsTableFilterComposer f) f,
  ) {
    final $$OrderItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.orderItems,
      getReferencedColumn: (t) => t.orderId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrderItemsTableFilterComposer(
            $db: $db,
            $table: $db.orderItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$OrdersTableOrderingComposer
    extends Composer<_$AppDatabase, $OrdersTable> {
  $$OrdersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get orderNo => $composableBuilder(
    column: $table.orderNo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalAmountCents => $composableBuilder(
    column: $table.totalAmountCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get discountCents => $composableBuilder(
    column: $table.discountCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get payableCents => $composableBuilder(
    column: $table.payableCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get paidAt => $composableBuilder(
    column: $table.paidAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$CouponsTableOrderingComposer get couponId {
    final $$CouponsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.couponId,
      referencedTable: $db.coupons,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CouponsTableOrderingComposer(
            $db: $db,
            $table: $db.coupons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OrdersTableAnnotationComposer
    extends Composer<_$AppDatabase, $OrdersTable> {
  $$OrdersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get orderNo =>
      $composableBuilder(column: $table.orderNo, builder: (column) => column);

  GeneratedColumnWithTypeConverter<OrderStatus, int> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get totalAmountCents => $composableBuilder(
    column: $table.totalAmountCents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get discountCents => $composableBuilder(
    column: $table.discountCents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get payableCents => $composableBuilder(
    column: $table.payableCents,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get paidAt =>
      $composableBuilder(column: $table.paidAt, builder: (column) => column);

  $$CouponsTableAnnotationComposer get couponId {
    final $$CouponsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.couponId,
      referencedTable: $db.coupons,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CouponsTableAnnotationComposer(
            $db: $db,
            $table: $db.coupons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> orderItemsRefs<T extends Object>(
    Expression<T> Function($$OrderItemsTableAnnotationComposer a) f,
  ) {
    final $$OrderItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.orderItems,
      getReferencedColumn: (t) => t.orderId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrderItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.orderItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$OrdersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OrdersTable,
          Order,
          $$OrdersTableFilterComposer,
          $$OrdersTableOrderingComposer,
          $$OrdersTableAnnotationComposer,
          $$OrdersTableCreateCompanionBuilder,
          $$OrdersTableUpdateCompanionBuilder,
          (Order, $$OrdersTableReferences),
          Order,
          PrefetchHooks Function({bool couponId, bool orderItemsRefs})
        > {
  $$OrdersTableTableManager(_$AppDatabase db, $OrdersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OrdersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OrdersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OrdersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> orderNo = const Value.absent(),
                Value<OrderStatus> status = const Value.absent(),
                Value<int> totalAmountCents = const Value.absent(),
                Value<int> discountCents = const Value.absent(),
                Value<int> payableCents = const Value.absent(),
                Value<int?> couponId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> paidAt = const Value.absent(),
              }) => OrdersCompanion(
                id: id,
                orderNo: orderNo,
                status: status,
                totalAmountCents: totalAmountCents,
                discountCents: discountCents,
                payableCents: payableCents,
                couponId: couponId,
                createdAt: createdAt,
                paidAt: paidAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String orderNo,
                required OrderStatus status,
                required int totalAmountCents,
                required int discountCents,
                required int payableCents,
                Value<int?> couponId = const Value.absent(),
                required DateTime createdAt,
                Value<DateTime?> paidAt = const Value.absent(),
              }) => OrdersCompanion.insert(
                id: id,
                orderNo: orderNo,
                status: status,
                totalAmountCents: totalAmountCents,
                discountCents: discountCents,
                payableCents: payableCents,
                couponId: couponId,
                createdAt: createdAt,
                paidAt: paidAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$OrdersTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({couponId = false, orderItemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (orderItemsRefs) db.orderItems],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (couponId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.couponId,
                        referencedTable: $$OrdersTableReferences._couponIdTable(
                          db,
                        ),
                        referencedColumn: $$OrdersTableReferences
                            ._couponIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (orderItemsRefs)
                    await $_getPrefetchedData<Order, $OrdersTable, OrderItem>(
                      currentTable: table,
                      referencedTable: $$OrdersTableReferences
                          ._orderItemsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$OrdersTableReferences(db, table, p0).orderItemsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.orderId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$OrdersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OrdersTable,
      Order,
      $$OrdersTableFilterComposer,
      $$OrdersTableOrderingComposer,
      $$OrdersTableAnnotationComposer,
      $$OrdersTableCreateCompanionBuilder,
      $$OrdersTableUpdateCompanionBuilder,
      (Order, $$OrdersTableReferences),
      Order,
      PrefetchHooks Function({bool couponId, bool orderItemsRefs})
    >;
typedef $$OrderItemsTableCreateCompanionBuilder = OrderItemsCompanion Function({
  Value<int> id,
  required int orderId,
  required int productId,
  required int quantity,
  required int unitPriceSnapshotCents,
});
typedef $$OrderItemsTableUpdateCompanionBuilder = OrderItemsCompanion Function({
  Value<int> id,
  Value<int> orderId,
  Value<int> productId,
  Value<int> quantity,
  Value<int> unitPriceSnapshotCents,
});

final class $$OrderItemsTableReferences
    extends BaseReferences<_$AppDatabase, $OrderItemsTable, OrderItem> {
  $$OrderItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $OrdersTable _orderIdTable(_$AppDatabase db) =>
      db.orders.createAlias('order_items__order_id__orders__id');

  $$OrdersTableProcessedTableManager get orderId {
    final $_column = $_itemColumn<int>('order_id')!;

    final manager = $$OrdersTableTableManager(
      $_db,
      $_db.orders,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_orderIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ProductsTable _productIdTable(_$AppDatabase db) =>
      db.products.createAlias('order_items__product_id__products__id');

  $$ProductsTableProcessedTableManager get productId {
    final $_column = $_itemColumn<int>('product_id')!;

    final manager = $$ProductsTableTableManager(
      $_db,
      $_db.products,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_productIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$OrderItemsTableFilterComposer
    extends Composer<_$AppDatabase, $OrderItemsTable> {
  $$OrderItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get unitPriceSnapshotCents => $composableBuilder(
    column: $table.unitPriceSnapshotCents,
    builder: (column) => ColumnFilters(column),
  );

  $$OrdersTableFilterComposer get orderId {
    final $$OrdersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.orderId,
      referencedTable: $db.orders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdersTableFilterComposer(
            $db: $db,
            $table: $db.orders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProductsTableFilterComposer get productId {
    final $$ProductsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableFilterComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OrderItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $OrderItemsTable> {
  $$OrderItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get unitPriceSnapshotCents => $composableBuilder(
    column: $table.unitPriceSnapshotCents,
    builder: (column) => ColumnOrderings(column),
  );

  $$OrdersTableOrderingComposer get orderId {
    final $$OrdersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.orderId,
      referencedTable: $db.orders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdersTableOrderingComposer(
            $db: $db,
            $table: $db.orders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProductsTableOrderingComposer get productId {
    final $$ProductsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableOrderingComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OrderItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $OrderItemsTable> {
  $$OrderItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<int> get unitPriceSnapshotCents => $composableBuilder(
    column: $table.unitPriceSnapshotCents,
    builder: (column) => column,
  );

  $$OrdersTableAnnotationComposer get orderId {
    final $$OrdersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.orderId,
      referencedTable: $db.orders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdersTableAnnotationComposer(
            $db: $db,
            $table: $db.orders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProductsTableAnnotationComposer get productId {
    final $$ProductsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableAnnotationComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OrderItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OrderItemsTable,
          OrderItem,
          $$OrderItemsTableFilterComposer,
          $$OrderItemsTableOrderingComposer,
          $$OrderItemsTableAnnotationComposer,
          $$OrderItemsTableCreateCompanionBuilder,
          $$OrderItemsTableUpdateCompanionBuilder,
          (OrderItem, $$OrderItemsTableReferences),
          OrderItem,
          PrefetchHooks Function({bool orderId, bool productId})
        > {
  $$OrderItemsTableTableManager(_$AppDatabase db, $OrderItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OrderItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OrderItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OrderItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> orderId = const Value.absent(),
                Value<int> productId = const Value.absent(),
                Value<int> quantity = const Value.absent(),
                Value<int> unitPriceSnapshotCents = const Value.absent(),
              }) => OrderItemsCompanion(
                id: id,
                orderId: orderId,
                productId: productId,
                quantity: quantity,
                unitPriceSnapshotCents: unitPriceSnapshotCents,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int orderId,
                required int productId,
                required int quantity,
                required int unitPriceSnapshotCents,
              }) => OrderItemsCompanion.insert(
                id: id,
                orderId: orderId,
                productId: productId,
                quantity: quantity,
                unitPriceSnapshotCents: unitPriceSnapshotCents,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$OrderItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({orderId = false, productId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (orderId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.orderId,
                        referencedTable: $$OrderItemsTableReferences
                            ._orderIdTable(db),
                        referencedColumn: $$OrderItemsTableReferences
                            ._orderIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (productId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.productId,
                        referencedTable: $$OrderItemsTableReferences
                            ._productIdTable(db),
                        referencedColumn: $$OrderItemsTableReferences
                            ._productIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$OrderItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OrderItemsTable,
      OrderItem,
      $$OrderItemsTableFilterComposer,
      $$OrderItemsTableOrderingComposer,
      $$OrderItemsTableAnnotationComposer,
      $$OrderItemsTableCreateCompanionBuilder,
      $$OrderItemsTableUpdateCompanionBuilder,
      (OrderItem, $$OrderItemsTableReferences),
      OrderItem,
      PrefetchHooks Function({bool orderId, bool productId})
    >;
typedef $$WishlistItemsTableCreateCompanionBuilder =
    WishlistItemsCompanion Function({
      Value<int> id,
      required int productId,
      required DateTime createdAt,
    });
typedef $$WishlistItemsTableUpdateCompanionBuilder =
    WishlistItemsCompanion Function({
      Value<int> id,
      Value<int> productId,
      Value<DateTime> createdAt,
    });

final class $$WishlistItemsTableReferences
    extends BaseReferences<_$AppDatabase, $WishlistItemsTable, WishlistItem> {
  $$WishlistItemsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ProductsTable _productIdTable(_$AppDatabase db) =>
      db.products.createAlias('wishlist_items__product_id__products__id');

  $$ProductsTableProcessedTableManager get productId {
    final $_column = $_itemColumn<int>('product_id')!;

    final manager = $$ProductsTableTableManager(
      $_db,
      $_db.products,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_productIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$WishlistItemsTableFilterComposer
    extends Composer<_$AppDatabase, $WishlistItemsTable> {
  $$WishlistItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ProductsTableFilterComposer get productId {
    final $$ProductsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableFilterComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WishlistItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $WishlistItemsTable> {
  $$WishlistItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProductsTableOrderingComposer get productId {
    final $$ProductsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableOrderingComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WishlistItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WishlistItemsTable> {
  $$WishlistItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$ProductsTableAnnotationComposer get productId {
    final $$ProductsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableAnnotationComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WishlistItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WishlistItemsTable,
          WishlistItem,
          $$WishlistItemsTableFilterComposer,
          $$WishlistItemsTableOrderingComposer,
          $$WishlistItemsTableAnnotationComposer,
          $$WishlistItemsTableCreateCompanionBuilder,
          $$WishlistItemsTableUpdateCompanionBuilder,
          (WishlistItem, $$WishlistItemsTableReferences),
          WishlistItem,
          PrefetchHooks Function({bool productId})
        > {
  $$WishlistItemsTableTableManager(_$AppDatabase db, $WishlistItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WishlistItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WishlistItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WishlistItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> productId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => WishlistItemsCompanion(
                id: id,
                productId: productId,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int productId,
                required DateTime createdAt,
              }) => WishlistItemsCompanion.insert(
                id: id,
                productId: productId,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$WishlistItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({productId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (productId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.productId,
                        referencedTable: $$WishlistItemsTableReferences
                            ._productIdTable(db),
                        referencedColumn: $$WishlistItemsTableReferences
                            ._productIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$WishlistItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WishlistItemsTable,
      WishlistItem,
      $$WishlistItemsTableFilterComposer,
      $$WishlistItemsTableOrderingComposer,
      $$WishlistItemsTableAnnotationComposer,
      $$WishlistItemsTableCreateCompanionBuilder,
      $$WishlistItemsTableUpdateCompanionBuilder,
      (WishlistItem, $$WishlistItemsTableReferences),
      WishlistItem,
      PrefetchHooks Function({bool productId})
    >;
typedef $$CheckinsTableCreateCompanionBuilder = CheckinsCompanion Function({
  Value<int> id,
  required String dateKey,
  required int rewardCents,
  required int streak,
});
typedef $$CheckinsTableUpdateCompanionBuilder = CheckinsCompanion Function({
  Value<int> id,
  Value<String> dateKey,
  Value<int> rewardCents,
  Value<int> streak,
});

class $$CheckinsTableFilterComposer
    extends Composer<_$AppDatabase, $CheckinsTable> {
  $$CheckinsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dateKey => $composableBuilder(
    column: $table.dateKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rewardCents => $composableBuilder(
    column: $table.rewardCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get streak => $composableBuilder(
    column: $table.streak,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CheckinsTableOrderingComposer
    extends Composer<_$AppDatabase, $CheckinsTable> {
  $$CheckinsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dateKey => $composableBuilder(
    column: $table.dateKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rewardCents => $composableBuilder(
    column: $table.rewardCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get streak => $composableBuilder(
    column: $table.streak,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CheckinsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CheckinsTable> {
  $$CheckinsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get dateKey =>
      $composableBuilder(column: $table.dateKey, builder: (column) => column);

  GeneratedColumn<int> get rewardCents => $composableBuilder(
    column: $table.rewardCents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get streak =>
      $composableBuilder(column: $table.streak, builder: (column) => column);
}

class $$CheckinsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CheckinsTable,
          Checkin,
          $$CheckinsTableFilterComposer,
          $$CheckinsTableOrderingComposer,
          $$CheckinsTableAnnotationComposer,
          $$CheckinsTableCreateCompanionBuilder,
          $$CheckinsTableUpdateCompanionBuilder,
          (Checkin, BaseReferences<_$AppDatabase, $CheckinsTable, Checkin>),
          Checkin,
          PrefetchHooks Function()
        > {
  $$CheckinsTableTableManager(_$AppDatabase db, $CheckinsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CheckinsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CheckinsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CheckinsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> dateKey = const Value.absent(),
                Value<int> rewardCents = const Value.absent(),
                Value<int> streak = const Value.absent(),
              }) => CheckinsCompanion(
                id: id,
                dateKey: dateKey,
                rewardCents: rewardCents,
                streak: streak,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String dateKey,
                required int rewardCents,
                required int streak,
              }) => CheckinsCompanion.insert(
                id: id,
                dateKey: dateKey,
                rewardCents: rewardCents,
                streak: streak,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CheckinsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CheckinsTable,
      Checkin,
      $$CheckinsTableFilterComposer,
      $$CheckinsTableOrderingComposer,
      $$CheckinsTableAnnotationComposer,
      $$CheckinsTableCreateCompanionBuilder,
      $$CheckinsTableUpdateCompanionBuilder,
      (Checkin, BaseReferences<_$AppDatabase, $CheckinsTable, Checkin>),
      Checkin,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db, _db.categories);
  $$ProductsTableTableManager get products =>
      $$ProductsTableTableManager(_db, _db.products);
  $$CartItemsTableTableManager get cartItems =>
      $$CartItemsTableTableManager(_db, _db.cartItems);
  $$WalletsTableTableManager get wallets =>
      $$WalletsTableTableManager(_db, _db.wallets);
  $$WalletTransactionsTableTableManager get walletTransactions =>
      $$WalletTransactionsTableTableManager(_db, _db.walletTransactions);
  $$CouponsTableTableManager get coupons =>
      $$CouponsTableTableManager(_db, _db.coupons);
  $$OrdersTableTableManager get orders =>
      $$OrdersTableTableManager(_db, _db.orders);
  $$OrderItemsTableTableManager get orderItems =>
      $$OrderItemsTableTableManager(_db, _db.orderItems);
  $$WishlistItemsTableTableManager get wishlistItems =>
      $$WishlistItemsTableTableManager(_db, _db.wishlistItems);
  $$CheckinsTableTableManager get checkins =>
      $$CheckinsTableTableManager(_db, _db.checkins);
}
