import 'package:args/args.dart';
import 'package:git/git.dart';
import 'package:path/path.dart' as p;

Future<void> main(List<String> arguments) async {
  try {
    var parser = ArgParser();
    parser.addOption('account', abbr: 'a', defaultsTo: '');
    parser.addOption('folder', abbr: 'f', defaultsTo: '');
    var results = parser.parse(arguments);
    String? account = results['account'];
    String? folder = results['folder'];
    List<String?> rest = results.rest;
    if (rest.isEmpty) {
      throw Exception("No git repo provided");
    }
    String? repo = rest.first;
    bool? hasAccount = account?.isNotEmpty;
    bool isGitDir = false;

    RegExp exp = RegExp(r'git@github\.com:(.*)\/(.*)\.git',
        caseSensitive: false, multiLine: false);
    if (repo == null) {
      throw Exception("A repo was not provided");
    } else {
      final match = exp.firstMatch(repo);
      final String? projectName = match?[2];

      if (match == null) {
        throw Exception("$repo does not look like a valid github repo");
      }

      if (hasAccount == true) {
        repo = repo.replaceAll("github.com", "github.com-$account");
      }
      List<String> gitArguments = ['clone', repo];
      if (folder != null && folder.isNotEmpty) {
        gitArguments.add(folder);
      } else if (projectName != null && projectName.isNotEmpty) {
        gitArguments.add(projectName);
      }

      String pth = p.join(p.current, gitArguments.last);

      await GitDir.isGitDir(pth);
      if (isGitDir == false) {
        runGit(gitArguments);
      } else {
        throw Exception("Cannot clone into an existing git folder");
      }
    }
  } catch (ex) {
    print("error $ex");
  }
}
