rm -rf lib/models/generated/*
sed -i -e 's/aqueduct:/#aqueduct:/' pubspec.yaml
sed -i -e 's/#hive_generator:/hive_generator:/' pubspec.yaml
sed -i -e 's/#build_runner:/build_runner:/' pubspec.yaml
pub get > /dev/null
pub run build_runner build
sed -i -e 's/#aqueduct:/aqueduct:/' pubspec.yaml
sed -i -e 's/hive_generator:/#hive_generator:/' pubspec.yaml
sed -i -e 's/build_runner:/#build_runner:/' pubspec.yaml
pub get > /dev/null
printf '\u001b[32mDone!\u001b[0m\n'