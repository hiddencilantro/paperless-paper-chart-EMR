# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Provider.first.patients.create([
    {
        first_name: 'Donald',
        last_name: 'Lew',
        sex: 'male',
        dob: Date.new(1990, 5, 1),
        as_provider: true
    }, 
    {
        first_name: 'Sean',
        last_name: 'Lee',
        sex: 'male',
        dob: Date.new(1989, 2, 25),
        as_provider: true
    }, 
    {
        first_name: 'Bruno',
        last_name: 'Lee',
        sex: 'male',
        dob: Date.new(1989, 8, 10),
        as_provider: true
    }, 
    {
        first_name: 'Angila',
        last_name: 'Bear',
        sex: 'female',
        dob: Date.new(1989, 2, 5),
        as_provider: true
    }, 
    {
        first_name: 'Sherlene',
        last_name: 'Wagstaff',
        sex: 'female',
        dob: Date.new(1985, 5, 17),
        as_provider: true
    }, 
    {
        first_name: 'Lovetta',
        last_name: 'Todd',
        sex: 'female',
        dob: Date.new(1967, 7, 12),
        as_provider: true
    }, 
    {
        first_name: 'Ivy',
        last_name: 'Morley',
        sex: 'female',
        dob: Date.new(1973, 3, 1),
        as_provider: true
    }, 
    {
        first_name: 'Gabrielle',
        last_name: 'Mulligan',
        sex: 'female',
        dob: Date.new(1941, 7, 31),
        as_provider: true
    }, 
    {
        first_name: 'Brook',
        last_name: 'Browning',
        sex: 'female',
        dob: Date.new(1951, 7, 10),
        as_provider: true
    }, 
    {
        first_name: 'Rufina',
        last_name: 'Davey',
        sex: 'female',
        dob: Date.new(1964, 3, 9),
        as_provider: true
    }, 
    {
        first_name: 'Delilah',
        last_name: 'Weaver',
        sex: 'female',
        dob: Date.new(1927, 4, 16),
        as_provider: true
    }, 
    {
        first_name: 'Mckenzie',
        last_name: 'Carr',
        sex: 'female',
        dob: Date.new(1958, 2, 12),
        as_provider: true
    }, 
    {
        first_name: 'Kathaleen',
        last_name: 'Lambert',
        sex: 'female',
        dob: Date.new(1957, 7, 28),
        as_provider: true
    }, 
    {
        first_name: 'Chery',
        last_name: 'Cooper',
        sex: 'female',
        dob: Date.new(1950, 6, 6),
        as_provider: true
    }, 
    {
        first_name: 'Julian',
        last_name: 'Beaumont',
        sex: 'female',
        dob: Date.new(2002, 8, 17),
        as_provider: true
    }, 
    {
        first_name: 'Lianne',
        last_name: 'Wood',
        sex: 'female',
        dob: Date.new(1992, 2, 5),
        as_provider: true
    }, 
    {
        first_name: 'Quinn',
        last_name: 'Dixon',
        sex: 'female',
        dob: Date.new(1935, 12, 8),
        as_provider: true
    }, 
    {
        first_name: 'Magnolia',
        last_name: 'Blackman',
        sex: 'female',
        dob: Date.new(1971, 3, 20),
        as_provider: true
    }, 
    {
        first_name: 'Maya',
        last_name: 'Burnett',
        sex: 'female',
        dob: Date.new(1988, 9, 21),
        as_provider: true
    }, 
    {
        first_name: 'Margene',
        last_name: 'Hodge',
        sex: 'female',
        dob: Date.new(1971, 12, 31),
        as_provider: true
    }, 
    {
        first_name: 'Jade',
        last_name: 'Bennett',
        sex: 'female',
        dob: Date.new(1979, 1, 6),
        as_provider: true
    }, 
    {
        first_name: 'Susana',
        last_name: 'Hussain',
        sex: 'female',
        dob: Date.new(1975, 10, 16),
        as_provider: true
    }, 
    {
        first_name: 'Adele',
        last_name: 'Chapman',
        sex: 'female',
        dob: Date.new(1980, 9, 19),
        as_provider: true
    }, 
    {
        first_name: 'Mason',
        last_name: 'Holmes',
        sex: 'male',
        dob: Date.new(1955, 3, 11),
        as_provider: true
    }, 
    {
        first_name: 'Steven',
        last_name: 'Reyes',
        sex: 'male',
        dob: Date.new(1933, 1, 18),
        as_provider: true
    }, 
    {
        first_name: 'Adonis',
        last_name: 'Wood',
        sex: 'male',
        dob: Date.new(1985, 4, 27),
        as_provider: true
    }, 
    {
        first_name: 'Maximus',
        last_name: 'Garcia',
        sex: 'male',
        dob: Date.new(1938, 10, 3),
        as_provider: true
    }, 
    {
        first_name: 'Benjamin',
        last_name: 'Johnston',
        sex: 'male',
        dob: Date.new(1976, 5, 30),
        as_provider: true
    }, 
    {
        first_name: 'Cooper',
        last_name: 'Price',
        sex: 'male',
        dob: Date.new(1975, 12, 17),
        as_provider: true
    }, 
    {
        first_name: 'Giovanni',
        last_name: 'Long',
        sex: 'male',
        dob: Date.new(1950, 6, 21),
        as_provider: true
    }, 
    {
        first_name: 'Juan',
        last_name: 'Hale',
        sex: 'male',
        dob: Date.new(1961, 6, 24),
        as_provider: true
    }, 
    {
        first_name: 'Finn',
        last_name: 'Hammond',
        sex: 'male',
        dob: Date.new(1975, 11, 28),
        as_provider: true
    }, 
    {
        first_name: 'Sebastian',
        last_name: 'Collins',
        sex: 'male',
        dob: Date.new(1970, 2, 13),
        as_provider: true
    }, 
    {
        first_name: 'Thomas',
        last_name: 'Jackson',
        sex: 'male',
        dob: Date.new(1979, 1, 10),
        as_provider: true
    }, 
    {
        first_name: 'Elliott',
        last_name: 'Ruiz',
        sex: 'male',
        dob: Date.new(1942, 6, 23),
        as_provider: true
    }, 
    {
        first_name: 'Simon',
        last_name: 'Hammond',
        sex: 'male',
        dob: Date.new(1964, 6, 16),
        as_provider: true
    }, 
    {
        first_name: 'Edward',
        last_name: 'Rogers',
        sex: 'male',
        dob: Date.new(1976, 12, 16),
        as_provider: true
    }, 
    {
        first_name: 'Christian',
        last_name: 'Patel',
        sex: 'male',
        dob: Date.new(1969, 4, 1),
        as_provider: true
    }, 
    {
        first_name: 'Isaac',
        last_name: 'Carter',
        sex: 'male',
        dob: Date.new(1978, 5, 11),
        as_provider: true
    }, 
    {
        first_name: 'Mario',
        last_name: 'Richardson',
        sex: 'male',
        dob: Date.new(1993, 6, 28),
        as_provider: true
    }, 
    {
        first_name: 'Jerry',
        last_name: 'Roberts',
        sex: 'male',
        dob: Date.new(1951, 4, 19),
        as_provider: true
    }, 
    {
        first_name: 'Jordan',
        last_name: 'Briggs',
        sex: 'male',
        dob: Date.new(1976, 10, 13),
        as_provider: true
    }, 
    {
        first_name: 'Edward',
        last_name: 'Hanson',
        sex: 'male',
        dob: Date.new(2002, 1, 14),
        as_provider: true
    }
])
