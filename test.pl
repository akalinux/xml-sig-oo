use XML::Sig::OO;

# Sign our xml
my $s=new XML::Sig::OO(
  xml=>'<?xml version="1.0" standalone="yes"?><data><test ID="A" /><test ID="B" /></data>',
  key_file=>'rsa_key.pem'
  cert_file=>'cert.pem',
);
my $result=$s->sign;
die "Failed to sign the xml, error was: $result" unless $result;

my $xml=$result->get_data;
# Example checking a signature
my $v=new XML::Sig::OO(xml=>$xml);

# validate our xml
my $result=$v->validate;

if($result) {
  print "everything checks out!\n";
} else {
  foreach my $chunk (@{$result->get_data}) {
    my ($nth,$signature,$digest)=@{$chunk}{qw(nth signature digest)};

    print "Results for processing chunk $nth\n";
    print "Signature State: ".($signature ? "OK\n" : "Failed, error was $signature\n");
    print "Digest State: ".($digest ? "OK\n" : "Failed, error was $digest\n");
  }
}
