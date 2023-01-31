import 'package:args/args.dart';
import 'package:git/git.dart';
import 'package:path/path.dart' as p;


Future<void> main(List<String> arguments) async {
  try {
  var parser = ArgParser();
parser.addOption('account', abbr:'a', defaultsTo: '');
parser.addOption('folder', abbr:'f', defaultsTo: '');
  var results = parser.parse(arguments);
  String? account = results['account'];
  String? folder = results['folder'];
  List<String?> rest = results.rest;
  if(rest.isEmpty ) {
    throw Exception("No git repo provided");
  }
  String? repo = rest.first;
  bool? hasAccount = account?.isNotEmpty;
  bool isGitDir = await GitDir.isGitDir(p.current);

  if(isGitDir==false) {
    if(repo !=null) {
      if(hasAccount==true){
    repo = repo.replaceAll("github.com", "github.com-$account");
      }
 List<String> gitArguments = ['clone', repo];
    if(folder != null && folder.isNotEmpty) {
      gitArguments.add(folder);
    }
    runGit(gitArguments);
  }


  } else {
    throw Exception("Cannot clone into an existing git folder");
  }

  } catch(ex) {
    print("error $ex");
  }
}
