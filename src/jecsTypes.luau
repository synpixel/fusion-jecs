--[[
    MIT License

    Copyright (c) 2024 jecs authors

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    SOFTWARE.
]]

type i53 = number
type i24 = number

type Ty = { i53 }
type ArchetypeId = number

type Column = { any }

type Map<K, V> = { [K]: V }

type GraphEdge = {
	from: Archetype,
	to: Archetype?,
	prev: GraphEdge?,
	next: GraphEdge?,
	id: number,
}

type GraphEdges = Map<i53, GraphEdge>

type GraphNode = {
	add: GraphEdges,
	remove: GraphEdges,
	refs: GraphEdge,
}

export type Archetype = {
	id: number,
	node: GraphNode,
	types: Ty,
	type: string,
	entities: { number },
	columns: { Column },
	records: { ArchetypeRecord },
}

type Record = {
	archetype: Archetype,
	row: number,
	dense: i24,
}

type ArchetypeRecord = {
	count: number,
	column: number,
}

type IdRecord = {
	cache: { ArchetypeRecord },
	flags: number,
	size: number,
	hooks: {
		on_add: ((entity: i53) -> ())?,
		on_set: ((entity: i53, data: any) -> ())?,
		on_remove: ((entity: i53) -> ())?,
	},
}

type ComponentIndex = Map<i53, IdRecord>

type Archetypes = { [ArchetypeId]: Archetype }

type ArchetypeDiff = {
	added: Ty,
	removed: Ty,
}

type EntityIndex = {
	dense_array: Map<i24, i53>,
	sparse_array: Map<i53, Record>,
	alive_count: number,
	max_id: number,
}

export type Id<T = nil> = Entity<T> | Pair<Entity<T>, Entity<unknown>>

export type Pair<First, Second> = number & {
	__relation: First,
}

type Item<T...> = (self: Query<T...>) -> (Entity, T...)

export type Entity<T = nil> = number & { __T: T }

type Iter<T...> = (query: Query<T...>) -> () -> (Entity, T...)

type Query<T...> = typeof(setmetatable({}, {
	__iter = (nil :: any) :: Iter<T...>,
})) & {
	iter: Iter<T...>,
	with: (self: Query<T...>, ...i53) -> Query<T...>,
	without: (self: Query<T...>, ...i53) -> Query<T...>,
	archetypes: (self: Query<T...>) -> { Archetype },
}

export type World = {
	archetypeIndex: { [string]: Archetype },
	archetypes: Archetypes,
	componentIndex: ComponentIndex,
	entity_index: EntityIndex,
	ROOT_ARCHETYPE: Archetype,

	nextComponentId: number,
	nextEntityId: number,
	nextArchetypeId: number,
} & {
	--- Creates a new entity
	entity: (self: World) -> Entity,
	--- Creates a new entity located in the first 256 ids.
	--- These should be used for static components for fast access.
	component: <T>(self: World) -> Entity<T>,
	--- Gets the target of an relationship. For example, when a user calls
	--- `world:target(id, ChildOf(parent), 0)`, you will obtain the parent entity.
	target: (self: World, id: Entity, relation: Entity, index: number?) -> Entity?,
	--- Deletes an entity and all it's related components and relationships.
	delete: (self: World, id: Entity) -> (),

	--- Adds a component to the entity with no value
	add: <T>(self: World, id: Entity, component: Id<T>) -> (),
	--- Assigns a value to a component on the given entity
	set: <T>(self: World, id: Entity, component: Id<T>, data: T) -> (),

	cleanup: (self: World) -> (),
	-- Clears an entity from the world
	clear: (self: World, id: Entity) -> (),
	--- Removes a component from the given entity
	remove: (self: World, id: Entity, component: Id) -> (),
	--- Retrieves the value of up to 4 components. These values may be nil.
	get: (<A>(self: World, id: any, Id<A>) -> A?)
		& (<A, B>(self: World, id: Entity, Id<A>, Id<B>) -> (A?, B?))
		& (<A, B, C>(self: World, id: Entity, Id<A>, Id<B>, Id<C>) -> (A?, B?, C?))
		& <A, B, C, D>(self: World, id: Entity, Id<A>, Id<B>, Id<C>, Id<D>) -> (A?, B?, C?, D?),

	--- Returns whether the entity has the ID.
	has: (self: World, entity: Entity, ...Id) -> boolean,

	--- Get parent (target of ChildOf relationship) for entity. If there is no ChildOf relationship pair, it will return nil.
	parent: (self: World, entity: Entity) -> Entity,

	--- Checks if the world contains the given entity
	contains: (self: World, entity: Entity) -> boolean,

	--- Searches the world for entities that match a given query
	query: (<A>(self: World, Id<A>) -> Query<A>)
		& (<A, B>(self: World, Id<A>, Id<B>) -> Query<A, B>)
		& (<A, B, C>(self: World, Id<A>, Id<B>, Id<C>) -> Query<A, B, C>)
		& (<A, B, C, D>(self: World, Id<A>, Id<B>, Id<C>, Id<D>) -> Query<A, B, C, D>)
		& (<A, B, C, D, E>(self: World, Id<A>, Id<B>, Id<C>, Id<D>, Id<E>) -> Query<A, B, C, D, E>)
		& (<A, B, C, D, E, F>(
			self: World,
			Id<A>,
			Id<B>,
			Id<C>,
			Id<D>,
			Id<E>,
			Id<F>
		) -> Query<A, B, C, D, E, F>)
		& (<A, B, C, D, E, F, G>(
			self: World,
			Id<A>,
			Id<B>,
			Id<C>,
			Id<D>,
			Id<E>,
			Id<F>,
			Id<G>
		) -> Query<A, B, C, D, E, F, G>)
		& (<A, B, C, D, E, F, G, H>(
			self: World,
			Id<A>,
			Id<B>,
			Id<C>,
			Id<D>,
			Id<E>,
			Id<F>,
			Id<G>,
			Id<H>,
			...Id<any>
		) -> Query<A, B, C, D, E, F, G, H>),
}

return nil