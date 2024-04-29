// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $TaskCategoriesTable extends TaskCategories
    with TableInfo<$TaskCategoriesTable, TaskCategory> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TaskCategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isDeletableMeta =
      const VerificationMeta('isDeletable');
  @override
  late final GeneratedColumn<bool> isDeletable = GeneratedColumn<bool>(
      'is_deletable', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_deletable" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _sortTypeMeta =
      const VerificationMeta('sortType');
  @override
  late final GeneratedColumn<int> sortType = GeneratedColumn<int>(
      'sort_type', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [id, name, isDeletable, sortType];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'task_categories';
  @override
  VerificationContext validateIntegrity(Insertable<TaskCategory> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('is_deletable')) {
      context.handle(
          _isDeletableMeta,
          isDeletable.isAcceptableOrUnknown(
              data['is_deletable']!, _isDeletableMeta));
    }
    if (data.containsKey('sort_type')) {
      context.handle(_sortTypeMeta,
          sortType.isAcceptableOrUnknown(data['sort_type']!, _sortTypeMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TaskCategory map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaskCategory(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      isDeletable: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_deletable'])!,
      sortType: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sort_type'])!,
    );
  }

  @override
  $TaskCategoriesTable createAlias(String alias) {
    return $TaskCategoriesTable(attachedDatabase, alias);
  }
}

class TaskCategory extends DataClass implements Insertable<TaskCategory> {
  final int id;
  final String name;
  final bool isDeletable;
  final int sortType;
  const TaskCategory(
      {required this.id,
      required this.name,
      required this.isDeletable,
      required this.sortType});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['is_deletable'] = Variable<bool>(isDeletable);
    map['sort_type'] = Variable<int>(sortType);
    return map;
  }

  TaskCategoriesCompanion toCompanion(bool nullToAbsent) {
    return TaskCategoriesCompanion(
      id: Value(id),
      name: Value(name),
      isDeletable: Value(isDeletable),
      sortType: Value(sortType),
    );
  }

  factory TaskCategory.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TaskCategory(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      isDeletable: serializer.fromJson<bool>(json['isDeletable']),
      sortType: serializer.fromJson<int>(json['sortType']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'isDeletable': serializer.toJson<bool>(isDeletable),
      'sortType': serializer.toJson<int>(sortType),
    };
  }

  TaskCategory copyWith(
          {int? id, String? name, bool? isDeletable, int? sortType}) =>
      TaskCategory(
        id: id ?? this.id,
        name: name ?? this.name,
        isDeletable: isDeletable ?? this.isDeletable,
        sortType: sortType ?? this.sortType,
      );
  @override
  String toString() {
    return (StringBuffer('TaskCategory(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('isDeletable: $isDeletable, ')
          ..write('sortType: $sortType')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, isDeletable, sortType);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaskCategory &&
          other.id == this.id &&
          other.name == this.name &&
          other.isDeletable == this.isDeletable &&
          other.sortType == this.sortType);
}

class TaskCategoriesCompanion extends UpdateCompanion<TaskCategory> {
  final Value<int> id;
  final Value<String> name;
  final Value<bool> isDeletable;
  final Value<int> sortType;
  const TaskCategoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.isDeletable = const Value.absent(),
    this.sortType = const Value.absent(),
  });
  TaskCategoriesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.isDeletable = const Value.absent(),
    this.sortType = const Value.absent(),
  }) : name = Value(name);
  static Insertable<TaskCategory> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<bool>? isDeletable,
    Expression<int>? sortType,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (isDeletable != null) 'is_deletable': isDeletable,
      if (sortType != null) 'sort_type': sortType,
    });
  }

  TaskCategoriesCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<bool>? isDeletable,
      Value<int>? sortType}) {
    return TaskCategoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      isDeletable: isDeletable ?? this.isDeletable,
      sortType: sortType ?? this.sortType,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (isDeletable.present) {
      map['is_deletable'] = Variable<bool>(isDeletable.value);
    }
    if (sortType.present) {
      map['sort_type'] = Variable<int>(sortType.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TaskCategoriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('isDeletable: $isDeletable, ')
          ..write('sortType: $sortType')
          ..write(')'))
        .toString();
  }
}

class $TaskItemsTable extends TaskItems
    with TableInfo<$TaskItemsTable, TaskItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TaskItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _contentMeta =
      const VerificationMeta('content');
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
      'body', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<int> category = GeneratedColumn<int>(
      'category_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES task_categories (id)'));
  static const VerificationMeta _isCompletedMeta =
      const VerificationMeta('isCompleted');
  @override
  late final GeneratedColumn<bool> isCompleted = GeneratedColumn<bool>(
      'is_completed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_completed" IN (0, 1))'));
  static const VerificationMeta _isFavoriteMeta =
      const VerificationMeta('isFavorite');
  @override
  late final GeneratedColumn<bool> isFavorite = GeneratedColumn<bool>(
      'is_favorite', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_favorite" IN (0, 1))'));
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _whenCompletedMeta =
      const VerificationMeta('whenCompleted');
  @override
  late final GeneratedColumn<DateTime> whenCompleted =
      GeneratedColumn<DateTime>('when_completed', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _positionMeta =
      const VerificationMeta('position');
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
      'position', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(-1));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        title,
        content,
        category,
        isCompleted,
        isFavorite,
        date,
        whenCompleted,
        position
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'task_items';
  @override
  VerificationContext validateIntegrity(Insertable<TaskItem> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('body')) {
      context.handle(_contentMeta,
          content.isAcceptableOrUnknown(data['body']!, _contentMeta));
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category_id']!, _categoryMeta));
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('is_completed')) {
      context.handle(
          _isCompletedMeta,
          isCompleted.isAcceptableOrUnknown(
              data['is_completed']!, _isCompletedMeta));
    } else if (isInserting) {
      context.missing(_isCompletedMeta);
    }
    if (data.containsKey('is_favorite')) {
      context.handle(
          _isFavoriteMeta,
          isFavorite.isAcceptableOrUnknown(
              data['is_favorite']!, _isFavoriteMeta));
    } else if (isInserting) {
      context.missing(_isFavoriteMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    }
    if (data.containsKey('when_completed')) {
      context.handle(
          _whenCompletedMeta,
          whenCompleted.isAcceptableOrUnknown(
              data['when_completed']!, _whenCompletedMeta));
    }
    if (data.containsKey('position')) {
      context.handle(_positionMeta,
          position.isAcceptableOrUnknown(data['position']!, _positionMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TaskItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaskItem(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      content: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}body'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}category_id'])!,
      isCompleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_completed'])!,
      isFavorite: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_favorite'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date']),
      whenCompleted: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}when_completed']),
      position: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}position'])!,
    );
  }

  @override
  $TaskItemsTable createAlias(String alias) {
    return $TaskItemsTable(attachedDatabase, alias);
  }
}

class TaskItem extends DataClass implements Insertable<TaskItem> {
  final int id;
  final String title;
  final String content;
  final int category;
  final bool isCompleted;
  final bool isFavorite;
  final DateTime? date;
  final DateTime? whenCompleted;
  final int position;
  const TaskItem(
      {required this.id,
      required this.title,
      required this.content,
      required this.category,
      required this.isCompleted,
      required this.isFavorite,
      this.date,
      this.whenCompleted,
      required this.position});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['body'] = Variable<String>(content);
    map['category_id'] = Variable<int>(category);
    map['is_completed'] = Variable<bool>(isCompleted);
    map['is_favorite'] = Variable<bool>(isFavorite);
    if (!nullToAbsent || date != null) {
      map['date'] = Variable<DateTime>(date);
    }
    if (!nullToAbsent || whenCompleted != null) {
      map['when_completed'] = Variable<DateTime>(whenCompleted);
    }
    map['position'] = Variable<int>(position);
    return map;
  }

  TaskItemsCompanion toCompanion(bool nullToAbsent) {
    return TaskItemsCompanion(
      id: Value(id),
      title: Value(title),
      content: Value(content),
      category: Value(category),
      isCompleted: Value(isCompleted),
      isFavorite: Value(isFavorite),
      date: date == null && nullToAbsent ? const Value.absent() : Value(date),
      whenCompleted: whenCompleted == null && nullToAbsent
          ? const Value.absent()
          : Value(whenCompleted),
      position: Value(position),
    );
  }

  factory TaskItem.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TaskItem(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      content: serializer.fromJson<String>(json['content']),
      category: serializer.fromJson<int>(json['category']),
      isCompleted: serializer.fromJson<bool>(json['isCompleted']),
      isFavorite: serializer.fromJson<bool>(json['isFavorite']),
      date: serializer.fromJson<DateTime?>(json['date']),
      whenCompleted: serializer.fromJson<DateTime?>(json['whenCompleted']),
      position: serializer.fromJson<int>(json['position']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'content': serializer.toJson<String>(content),
      'category': serializer.toJson<int>(category),
      'isCompleted': serializer.toJson<bool>(isCompleted),
      'isFavorite': serializer.toJson<bool>(isFavorite),
      'date': serializer.toJson<DateTime?>(date),
      'whenCompleted': serializer.toJson<DateTime?>(whenCompleted),
      'position': serializer.toJson<int>(position),
    };
  }

  TaskItem copyWith(
          {int? id,
          String? title,
          String? content,
          int? category,
          bool? isCompleted,
          bool? isFavorite,
          Value<DateTime?> date = const Value.absent(),
          Value<DateTime?> whenCompleted = const Value.absent(),
          int? position}) =>
      TaskItem(
        id: id ?? this.id,
        title: title ?? this.title,
        content: content ?? this.content,
        category: category ?? this.category,
        isCompleted: isCompleted ?? this.isCompleted,
        isFavorite: isFavorite ?? this.isFavorite,
        date: date.present ? date.value : this.date,
        whenCompleted:
            whenCompleted.present ? whenCompleted.value : this.whenCompleted,
        position: position ?? this.position,
      );
  @override
  String toString() {
    return (StringBuffer('TaskItem(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('category: $category, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('date: $date, ')
          ..write('whenCompleted: $whenCompleted, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, content, category, isCompleted,
      isFavorite, date, whenCompleted, position);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaskItem &&
          other.id == this.id &&
          other.title == this.title &&
          other.content == this.content &&
          other.category == this.category &&
          other.isCompleted == this.isCompleted &&
          other.isFavorite == this.isFavorite &&
          other.date == this.date &&
          other.whenCompleted == this.whenCompleted &&
          other.position == this.position);
}

class TaskItemsCompanion extends UpdateCompanion<TaskItem> {
  final Value<int> id;
  final Value<String> title;
  final Value<String> content;
  final Value<int> category;
  final Value<bool> isCompleted;
  final Value<bool> isFavorite;
  final Value<DateTime?> date;
  final Value<DateTime?> whenCompleted;
  final Value<int> position;
  const TaskItemsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.content = const Value.absent(),
    this.category = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.date = const Value.absent(),
    this.whenCompleted = const Value.absent(),
    this.position = const Value.absent(),
  });
  TaskItemsCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required String content,
    required int category,
    required bool isCompleted,
    required bool isFavorite,
    this.date = const Value.absent(),
    this.whenCompleted = const Value.absent(),
    this.position = const Value.absent(),
  })  : title = Value(title),
        content = Value(content),
        category = Value(category),
        isCompleted = Value(isCompleted),
        isFavorite = Value(isFavorite);
  static Insertable<TaskItem> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? content,
    Expression<int>? category,
    Expression<bool>? isCompleted,
    Expression<bool>? isFavorite,
    Expression<DateTime>? date,
    Expression<DateTime>? whenCompleted,
    Expression<int>? position,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (content != null) 'body': content,
      if (category != null) 'category_id': category,
      if (isCompleted != null) 'is_completed': isCompleted,
      if (isFavorite != null) 'is_favorite': isFavorite,
      if (date != null) 'date': date,
      if (whenCompleted != null) 'when_completed': whenCompleted,
      if (position != null) 'position': position,
    });
  }

  TaskItemsCompanion copyWith(
      {Value<int>? id,
      Value<String>? title,
      Value<String>? content,
      Value<int>? category,
      Value<bool>? isCompleted,
      Value<bool>? isFavorite,
      Value<DateTime?>? date,
      Value<DateTime?>? whenCompleted,
      Value<int>? position}) {
    return TaskItemsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      category: category ?? this.category,
      isCompleted: isCompleted ?? this.isCompleted,
      isFavorite: isFavorite ?? this.isFavorite,
      date: date ?? this.date,
      whenCompleted: whenCompleted ?? this.whenCompleted,
      position: position ?? this.position,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (content.present) {
      map['body'] = Variable<String>(content.value);
    }
    if (category.present) {
      map['category_id'] = Variable<int>(category.value);
    }
    if (isCompleted.present) {
      map['is_completed'] = Variable<bool>(isCompleted.value);
    }
    if (isFavorite.present) {
      map['is_favorite'] = Variable<bool>(isFavorite.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (whenCompleted.present) {
      map['when_completed'] = Variable<DateTime>(whenCompleted.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TaskItemsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('category: $category, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('date: $date, ')
          ..write('whenCompleted: $whenCompleted, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  late final $TaskCategoriesTable taskCategories = $TaskCategoriesTable(this);
  late final $TaskItemsTable taskItems = $TaskItemsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [taskCategories, taskItems];
}
