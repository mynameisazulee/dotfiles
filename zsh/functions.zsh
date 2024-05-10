# cd -> ls automatically
c() {
	cd $1;
	ls -F;
}
alias cd="c"
