# Posterr

A new social media like Twitter.

## SETUP


### 1 Lefthook

Used to configure Git Hooks in the project. Performs some checks before commits or pushes.

Documentation with installation manual [here.](https://github.com/evilmartians/lefthook/blob/master/docs/full_guide.md)

After installation, access the project root and run:

```bash
lefthook install -f
```

### 2 Scripts

To facilitate some routine actions, such as the execution of tests, a script was created to assist in the execution of some commands in all Micro Apps.

Just run the file `scripts.sh` to access the list of available commands.

Some commands require the installation of additional programs, such as coverage and lcov:

```bash
pub global activate coverage
brew install lcov
```

To install lcov on Windows use

```bash
choco install lcov
```

After cloning the project and running the above script, a pub get can be run through this script:

```bash
./scripts.sh --get
```

For more useful commands:
```bash
./scripts.sh --help
```

## **3. Running the project**

To run, take into account the flavors `dev`, `hml` e `prod`.  

Each flavor has a configuration file inside the folder `base_app/.env`.  

Always run as follows:  

```bash
cd base_app
flutter run -t lib/main-<flavor>.dart --flavor <flavor> 
```

### 3.1 Creating/editing flavors

For the creation of flavors, the package [flutter_flavorizr](https://github.com/AngeloAvv/flutter_flavorizr) was used.

Follow your documentation for adding/editing flavors.


## **4. Tests**

To maintain organization, each test file must be created in the same folder structure as the file being tested. Example:

```bash
# Implementation
/lib
  /domain
    /usecases
      /remote_auth.dart

# Test
/test
  /domain
    /usecases
      /remote_auth_test.dart
```

## **5. Standards and best practices**

Project configured with [Flutter Lints](https://pub.dev/packages/flutter_lints) package.

The rules were centralized in the `shared` package, in the `lib/linter_rules.yaml` file.
Each package (microApp) must have an `analysis_options.yaml` file with a basic structure referencing the package core (and may contain specific rules):

```yaml
include: package:shared/linter_rules.yaml
```

### 5.1 Commits

Standardization of commit messages must be maintained. You must follow the pattern specified in [Conventional Commits.](https://www.conventionalcommits.org/pt-br/v1.0.0/)

It is mandatory to always have a type in the commit message.
*This validation is done automatically by Lefthook at commit time.*

Accepted prefixes: build, chore, ci, docs, feat, fix, perf, refactor, revert, style, test

## **6. Design system**

Project uses Atomic Design for create the Design System. Click [here](https://bradfrost.com/blog/post/atomic-web-design/) to read about Atomic Design.