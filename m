Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 908704B0E06
	for <lists+ceph-devel@lfdr.de>; Thu, 10 Feb 2022 14:01:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241894AbiBJNBc (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 10 Feb 2022 08:01:32 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238200AbiBJNBb (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 10 Feb 2022 08:01:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84FD51015
        for <ceph-devel@vger.kernel.org>; Thu, 10 Feb 2022 05:01:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BEAA0B824B3
        for <ceph-devel@vger.kernel.org>; Thu, 10 Feb 2022 13:01:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5AEDC004E1;
        Thu, 10 Feb 2022 13:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644498087;
        bh=DcSAJ6qrtM5JUn+v6d9Qs+BGg9F6CXWCeEagtH647d4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Vg7U/e0ewNtYygnmO3lScftMRkzEUufm1mPEo4pg78idzx1wRreQlaxjollO58I6i
         bxW5mVMAroulxU3cb6MubonQR79Rp2Y8/7ItEWNQMJuSGFb9LgKihEqfUeQbCDsxPj
         Kgh8ZIsHRVP2IoH1dpswNHhg0cG3lq3L1kDtveP64qvv1YK/HOFSr9zlw9mgoFqtM7
         fMEf/0DKAvf8JmADDmAngbh8cHTf6dE7/mq0XvAArwT6i8Z5DgA8in8GoHBW/qN39F
         VN3bYn+2stDbAbZc5zKu0WDMC0JCqLgieCSqVd6oP9atNMulxRLWRGKXDoqGOU9MYU
         ezJnMdS+rSs+g==
Message-ID: <38bc506c75bf502ce5b15158315fde1c59b0b2d3.camel@kernel.org>
Subject: Re: [ceph-client:testing 6/8] fs/ceph/addr.c:788:12: warning: stack
 frame size (2352) exceeds limit (2048) in 'ceph_writepages_start'
From:   Jeff Layton <jlayton@kernel.org>
To:     kernel test robot <lkp@intel.com>,
        David Howells <dhowells@redhat.com>
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        ceph-devel@vger.kernel.org, Ilya Dryomov <idryomov@gmail.com>
Date:   Thu, 10 Feb 2022 08:01:25 -0500
In-Reply-To: <202202102053.7C17duIV-lkp@intel.com>
References: <202202102053.7C17duIV-lkp@intel.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.3 (3.42.3-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2022-02-10 at 20:14 +0800, kernel test robot wrote:
> tree:   https://github.com/ceph/ceph-client.git testing
> head:   6dc7235ee916b768b31afa12ab507874bd278573
> commit: 85fc162016ac8d19e28877a15f55c0fa4b47713b [6/8] ceph: Make ceph_ne=
tfs_issue_op() handle inlined data
> config: mips-randconfig-r014-20220209 (https://download.01.org/0day-ci/ar=
chive/20220210/202202102053.7C17duIV-lkp@intel.com/config)
> compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project aa84=
5d7a245d85c441d0bd44fc7b6c3be8f3de8d)
> reproduce (this is a W=3D1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbi=
n/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # install mips cross compiling tool for clang build
>         # apt-get install binutils-mips-linux-gnu
>         # https://github.com/ceph/ceph-client/commit/85fc162016ac8d19e288=
77a15f55c0fa4b47713b
>         git remote add ceph-client https://github.com/ceph/ceph-client.gi=
t
>         git fetch --no-tags ceph-client testing
>         git checkout 85fc162016ac8d19e28877a15f55c0fa4b47713b
>         # save the config file to linux build tree
>         mkdir build_dir
>         COMPILER_INSTALL_PATH=3D$HOME/0day COMPILER=3Dclang make.cross W=
=3D1 O=3Dbuild_dir ARCH=3Dmips SHELL=3D/bin/bash fs/ceph/
>=20
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
>=20
> All warnings (new ones prefixed by >>):
>=20
> > > fs/ceph/addr.c:788:12: warning: stack frame size (2352) exceeds limit=
 (2048) in 'ceph_writepages_start'


ceph_writepages_start is a major stack hog, but the commit mentioned
above doesn't affect that function, AFAICT. I don't think this is a new
problem from that patch.

This looks more like llvm on mips blew up?

>    static int ceph_writepages_start(struct address_space
>    ^
>    fatal error: error in backend: Nested variants found in inline asm str=
ing: ' .set push
>    .set mips64r6
>    .if ( 0x00 ) !=3D -1)) 0x00 ) !=3D -1)) : ($( static struct ftrace_bra=
nch_data __attribute__((__aligned__(4))) __attribute__((__section__("_ftrac=
e_branch"))) __if_trace =3D $( .func =3D __func__, .file =3D "arch/mips/inc=
lude/asm/bitops.h", .line =3D 190, $); 0x00 ) !=3D -1)) : $))) ) && ( 0 ); =
.set push; .set mips64r6; .rept 1; sync 0x00; .endr; .set pop; .else; ; .en=
dif
>    1: lld $0, $2
>    or $1, $0, $3
>    scd $1, $2
>    beqzc $1, 1b
>    .set pop
>    '
>    PLEASE submit a bug report to https://github.com/llvm/llvm-project/iss=
ues/ and include the crash backtrace, preprocessed source, and associated r=
un script.
>    Stack dump:
>    0. Program arguments: clang -Wp,-MMD,fs/ceph/.addr.o.d -nostdinc -Iarc=
h/mips/include -I./arch/mips/include/generated -Iinclude -I./include -Iarch=
/mips/include/uapi -I./arch/mips/include/generated/uapi -Iinclude/uapi -I./=
include/generated/uapi -include include/linux/compiler-version.h -include i=
nclude/linux/kconfig.h -include include/linux/compiler_types.h -D__KERNEL__=
 -DVMLINUX_LOAD_ADDRESS=3D0xffffffff84000000 -DLINKER_LOAD_ADDRESS=3D0xffff=
ffff84000000 -DDATAOFFSET=3D0 -Qunused-arguments -fmacro-prefix-map=3D=3D -=
DKBUILD_EXTRA_WARN1 -Wall -Wundef -Werror=3Dstrict-prototypes -Wno-trigraph=
s -fno-strict-aliasing -fno-common -fshort-wchar -fno-PIE -Werror=3Dimplici=
t-function-declaration -Werror=3Dimplicit-int -Werror=3Dreturn-type -Wno-fo=
rmat-security -std=3Dgnu89 --target=3Dmips64-linux -fintegrated-as -Werror=
=3Dunknown-warning-option -Werror=3Dignored-optimization-argument -mabi=3D6=
4 -G 0 -mno-abicalls -fno-pic -pipe -msoft-float -DGAS_HAS_SET_HARDFLOAT -W=
a,-msoft-float -ffreestanding -EB -fno-stack-check -march=3Dmips64r6 -Wa,--=
trap -DTOOLCHAIN_SUPPORTS_VIRT -Iarch/mips/include/asm/mach-generic -Iarch/=
mips/include/asm/mach-generic -fno-asynchronous-unwind-tables -fno-delete-n=
ull-pointer-checks -Wno-frame-address -Wno-address-of-packed-member -O2 -Wf=
rame-larger-than=3D2048 -fno-stack-protector -Wimplicit-fallthrough -Wno-gn=
u -mno-global-merge -Wno-unused-but-set-variable -Wno-unused-const-variable=
 -ftrivial-auto-var-init=3Dpattern -fno-stack-clash-protection -pg -Wdeclar=
ation-after-statement -Wvla -Wno-pointer-sign -Wcast-function-type -Wno-arr=
ay-bounds -fno-strict-overflow -fno-stack-check -Werror=3Ddate-time -Werror=
=3Dincompatible-pointer-types -Wextra -Wunused -Wno-unused-parameter -Wmiss=
ing-declarations -Wmissing-format-attribute -Wmissing-prototypes -Wold-styl=
e-definition -Wmissing-include-dirs -Wunused-but-set-variable -Wunused-cons=
t-variable -Wno-missing-field-initializers -Wno-sign-compare -Wno-type-limi=
ts -fsanitize=3Dunreachable -fsanitize=3Denum -I fs/ceph -I ./fs/ceph -DMOD=
ULE -mlong-calls -DKBUILD_BASENAME=3D"addr" -DKBUILD_MODNAME=3D"ceph" -D__K=
BUILD_MODNAME=3Dkmod_ceph -c -o fs/ceph/addr.o fs/ceph/addr.c
>    1. <eof> parser at end of file
>    2. Code generation
>    3. Running pass 'Function Pass Manager' on module 'fs/ceph/addr.c'.
>    4. Running pass 'Mips Assembly Printer' on function '@ceph_writepages_=
start'
>    #0 0x000055a535e1f68f Signals.cpp:0:0
>    #1 0x000055a535e1d56c llvm::sys::CleanupOnSignal(unsigned long) (/opt/=
cross/clang-aa845d7a24/bin/clang-15+0x347456c)
>    #2 0x000055a535d5d9e7 llvm::CrashRecoveryContext::HandleExit(int) (/op=
t/cross/clang-aa845d7a24/bin/clang-15+0x33b49e7)
>    #3 0x000055a535e15c1e llvm::sys::Process::Exit(int, bool) (/opt/cross/=
clang-aa845d7a24/bin/clang-15+0x346cc1e)
>    #4 0x000055a533a508bb (/opt/cross/clang-aa845d7a24/bin/clang-15+0x10a7=
8bb)
>    #5 0x000055a535d6449c llvm::report_fatal_error(llvm::Twine const&, boo=
l) (/opt/cross/clang-aa845d7a24/bin/clang-15+0x33bb49c)
>    #6 0x000055a536a56000 llvm::AsmPrinter::emitInlineAsm(llvm::MachineIns=
tr const (/opt/cross/clang-aa845d7a24/bin/clang-15+0x40ad000)
>    #7 0x000055a536a51f34 llvm::AsmPrinter::emitFunctionBody() (/opt/cross=
/clang-aa845d7a24/bin/clang-15+0x40a8f34)
>    #8 0x000055a5344bb1e7 llvm::MipsAsmPrinter::runOnMachineFunction(llvm:=
:MachineFunction&) (/opt/cross/clang-aa845d7a24/bin/clang-15+0x1b121e7)
>    #9 0x000055a535170a3d llvm::MachineFunctionPass::runOnFunction(llvm::F=
unction&) (.part.53) MachineFunctionPass.cpp:0:0
>    #10 0x000055a5355b1757 llvm::FPPassManager::runOnFunction(llvm::Functi=
on&) (/opt/cross/clang-aa845d7a24/bin/clang-15+0x2c08757)
>    #11 0x000055a5355b18d1 llvm::FPPassManager::runOnModule(llvm::Module&)=
 (/opt/cross/clang-aa845d7a24/bin/clang-15+0x2c088d1)
>    #12 0x000055a5355b244f llvm::legacy::PassManagerImpl::run(llvm::Module=
&) (/opt/cross/clang-aa845d7a24/bin/clang-15+0x2c0944f)
>    #13 0x000055a536137917 clang::EmitBackendOutput(clang::DiagnosticsEngi=
ne&, clang::HeaderSearchOptions const&, clang::CodeGenOptions const&, clang=
::TargetOptions const&, clang::LangOptions const&, llvm::StringRef, clang::=
BackendAction, std::unique_ptr<llvm::raw_pwrite_stream, std::default_delete=
<llvm::raw_pwrite_stream> >) (/opt/cross/clang-aa845d7a24/bin/clang-15+0x37=
8e917)
>    #14 0x000055a536d6f063 clang::BackendConsumer::HandleTranslationUnit(c=
lang::ASTContext&) (/opt/cross/clang-aa845d7a24/bin/clang-15+0x43c6063)
>    #15 0x000055a537845629 clang::ParseAST(clang::Sema&, bool, bool) (/opt=
/cross/clang-aa845d7a24/bin/clang-15+0x4e9c629)
>    #16 0x000055a536d6de9f clang::CodeGenAction::ExecuteAction() (/opt/cro=
ss/clang-aa845d7a24/bin/clang-15+0x43c4e9f)
>    #17 0x000055a53676ac81 clang::FrontendAction::Execute() (/opt/cross/cl=
ang-aa845d7a24/bin/clang-15+0x3dc1c81)
>    #18 0x000055a536701b0a clang::CompilerInstance::ExecuteAction(clang::F=
rontendAction&) (/opt/cross/clang-aa845d7a24/bin/clang-15+0x3d58b0a)
>    #19 0x000055a53682f59b (/opt/cross/clang-aa845d7a24/bin/clang-15+0x3e8=
659b)
>    #20 0x000055a533a51e6c cc1_main(llvm::ArrayRef<char char (/opt/cross/c=
lang-aa845d7a24/bin/clang-15+0x10a8e6c)
>    #21 0x000055a533a4eb3b ExecuteCC1Tool(llvm::SmallVectorImpl<char drive=
r.cpp:0:0
>    #22 0x000055a536599765 void llvm::function_ref<void ()>::callback_fn<c=
lang::driver::CC1Command::Execute(llvm::ArrayRef<llvm::Optional<llvm::Strin=
gRef> >, std::__cxx11::basic_string<char, std::char_traits<char>, std::allo=
cator<char> const::'lambda'()>(long) Job.cpp:0:0
>    #23 0x000055a535d5d8a3 llvm::CrashRecoveryContext::RunSafely(llvm::fun=
ction_ref<void ()>) (/opt/cross/clang-aa845d7a24/bin/clang-15+0x33b48a3)
>    #24 0x000055a53659a05e clang::driver::CC1Command::Execute(llvm::ArrayR=
ef<llvm::Optional<llvm::StringRef> >, std::__cxx11::basic_string<char, std:=
:char_traits<char>, std::allocator<char> const (.part.216) Job.cpp:0:0
>    #25 0x000055a53656ec57 clang::driver::Compilation::ExecuteCommand(clan=
g::driver::Command const&, clang::driver::Command const (/opt/cross/clang-a=
a845d7a24/bin/clang-15+0x3bc5c57)
>    #26 0x000055a53656f637 clang::driver::Compilation::ExecuteJobs(clang::=
driver::JobList const&, llvm::SmallVectorImpl<std::pair<int, clang::driver:=
:Command >&) const (/opt/cross/clang-aa845d7a24/bin/clang-15+0x3bc6637)
>    #27 0x000055a536578cc9 clang::driver::Driver::ExecuteCompilation(clang=
::driver::Compilation&, llvm::SmallVectorImpl<std::pair<int, clang::driver:=
:Command >&) (/opt/cross/clang-aa845d7a24/bin/clang-15+0x3bcfcc9)
>    #28 0x000055a53397738f main (/opt/cross/clang-aa845d7a24/bin/clang-15+=
0xfce38f)
>    #29 0x00007fe35f12cd0a __libc_start_main (/lib/x86_64-linux-gnu/libc.s=
o.6+0x26d0a)
>    #30 0x000055a533a4e65a _start (/opt/cross/clang-aa845d7a24/bin/clang-1=
5+0x10a565a)
>    clang-15: error: clang frontend command failed with exit code 70 (use =
-v to see invocation)
>    clang version 15.0.0 (git://gitmirror/llvm_project aa845d7a245d85c441d=
0bd44fc7b6c3be8f3de8d)
>    Target: mips64-unknown-linux
>    Thread model: posix
>    InstalledDir: /opt/cross/clang-aa845d7a24/bin
>    clang-15: note: diagnostic msg:
>    Makefile arch fs include kernel nr_bisected scripts source usr
> --
> > > fs/ceph/addr.c:788:12: warning: stack frame size (2352) exceeds limit=
 (2048) in 'ceph_writepages_start'
>    static int ceph_writepages_start(struct address_space
>    ^
>    fatal error: error in backend: Nested variants found in inline asm str=
ing: ' .set push
>    .set mips64r6
>    .if ( 0x00 ) !=3D -1)) 0x00 ) !=3D -1)) : ($( static struct ftrace_bra=
nch_data __attribute__((__aligned__(4))) __attribute__((__section__("_ftrac=
e_branch"))) __if_trace =3D $( .func =3D __func__, .file =3D "arch/mips/inc=
lude/asm/bitops.h", .line =3D 190, $); 0x00 ) !=3D -1)) : $))) ) && ( 0 ); =
.set push; .set mips64r6; .rept 1; sync 0x00; .endr; .set pop; .else; ; .en=
dif
>    1: lld $0, $2
>    or $1, $0, $3
>    scd $1, $2
>    beqzc $1, 1b
>    .set pop
>    '
>    PLEASE submit a bug report to https://github.com/llvm/llvm-project/iss=
ues/ and include the crash backtrace, preprocessed source, and associated r=
un script.
>    Stack dump:
>    0. Program arguments: clang -Wp,-MMD,fs/ceph/.addr.o.d -nostdinc -Iarc=
h/mips/include -I./arch/mips/include/generated -Iinclude -I./include -Iarch=
/mips/include/uapi -I./arch/mips/include/generated/uapi -Iinclude/uapi -I./=
include/generated/uapi -include include/linux/compiler-version.h -include i=
nclude/linux/kconfig.h -include include/linux/compiler_types.h -D__KERNEL__=
 -DVMLINUX_LOAD_ADDRESS=3D0xffffffff84000000 -DLINKER_LOAD_ADDRESS=3D0xffff=
ffff84000000 -DDATAOFFSET=3D0 -Qunused-arguments -fmacro-prefix-map=3D=3D -=
DKBUILD_EXTRA_WARN1 -Wall -Wundef -Werror=3Dstrict-prototypes -Wno-trigraph=
s -fno-strict-aliasing -fno-common -fshort-wchar -fno-PIE -Werror=3Dimplici=
t-function-declaration -Werror=3Dimplicit-int -Werror=3Dreturn-type -Wno-fo=
rmat-security -std=3Dgnu89 --target=3Dmips64-linux -fintegrated-as -Werror=
=3Dunknown-warning-option -Werror=3Dignored-optimization-argument -mabi=3D6=
4 -G 0 -mno-abicalls -fno-pic -pipe -msoft-float -DGAS_HAS_SET_HARDFLOAT -W=
a,-msoft-float -ffreestanding -EB -fno-stack-check -march=3Dmips64r6 -Wa,--=
trap -DTOOLCHAIN_SUPPORTS_VIRT -Iarch/mips/include/asm/mach-generic -Iarch/=
mips/include/asm/mach-generic -fno-asynchronous-unwind-tables -fno-delete-n=
ull-pointer-checks -Wno-frame-address -Wno-address-of-packed-member -O2 -Wf=
rame-larger-than=3D2048 -fno-stack-protector -Wimplicit-fallthrough -Wno-gn=
u -mno-global-merge -Wno-unused-but-set-variable -Wno-unused-const-variable=
 -ftrivial-auto-var-init=3Dpattern -fno-stack-clash-protection -pg -Wdeclar=
ation-after-statement -Wvla -Wno-pointer-sign -Wcast-function-type -Wno-arr=
ay-bounds -fno-strict-overflow -fno-stack-check -Werror=3Ddate-time -Werror=
=3Dincompatible-pointer-types -Wextra -Wunused -Wno-unused-parameter -Wmiss=
ing-declarations -Wmissing-format-attribute -Wmissing-prototypes -Wold-styl=
e-definition -Wmissing-include-dirs -Wunused-but-set-variable -Wunused-cons=
t-variable -Wno-missing-field-initializers -Wno-sign-compare -Wno-type-limi=
ts -fsanitize=3Dunreachable -fsanitize=3Denum -DMODULE -mlong-calls -DKBUIL=
D_BASENAME=3D"addr" -DKBUILD_MODNAME=3D"ceph" -D__KBUILD_MODNAME=3Dkmod_cep=
h -c -o fs/ceph/addr.o fs/ceph/addr.c
>    1. <eof> parser at end of file
>    2. Code generation
>    3. Running pass 'Function Pass Manager' on module 'fs/ceph/addr.c'.
>    4. Running pass 'Mips Assembly Printer' on function '@ceph_writepages_=
start'
>    #0 0x0000562358d5368f Signals.cpp:0:0
>    #1 0x0000562358d5156c llvm::sys::CleanupOnSignal(unsigned long) (/opt/=
cross/clang-aa845d7a24/bin/clang-15+0x347456c)
>    #2 0x0000562358c919e7 llvm::CrashRecoveryContext::HandleExit(int) (/op=
t/cross/clang-aa845d7a24/bin/clang-15+0x33b49e7)
>    #3 0x0000562358d49c1e llvm::sys::Process::Exit(int, bool) (/opt/cross/=
clang-aa845d7a24/bin/clang-15+0x346cc1e)
>    #4 0x00005623569848bb (/opt/cross/clang-aa845d7a24/bin/clang-15+0x10a7=
8bb)
>    #5 0x0000562358c9849c llvm::report_fatal_error(llvm::Twine const&, boo=
l) (/opt/cross/clang-aa845d7a24/bin/clang-15+0x33bb49c)
>    #6 0x000056235998a000 llvm::AsmPrinter::emitInlineAsm(llvm::MachineIns=
tr const (/opt/cross/clang-aa845d7a24/bin/clang-15+0x40ad000)
>    #7 0x0000562359985f34 llvm::AsmPrinter::emitFunctionBody() (/opt/cross=
/clang-aa845d7a24/bin/clang-15+0x40a8f34)
>    #8 0x00005623573ef1e7 llvm::MipsAsmPrinter::runOnMachineFunction(llvm:=
:MachineFunction&) (/opt/cross/clang-aa845d7a24/bin/clang-15+0x1b121e7)
>    #9 0x00005623580a4a3d llvm::MachineFunctionPass::runOnFunction(llvm::F=
unction&) (.part.53) MachineFunctionPass.cpp:0:0
>    #10 0x00005623584e5757 llvm::FPPassManager::runOnFunction(llvm::Functi=
on&) (/opt/cross/clang-aa845d7a24/bin/clang-15+0x2c08757)
>    #11 0x00005623584e58d1 llvm::FPPassManager::runOnModule(llvm::Module&)=
 (/opt/cross/clang-aa845d7a24/bin/clang-15+0x2c088d1)
>    #12 0x00005623584e644f llvm::legacy::PassManagerImpl::run(llvm::Module=
&) (/opt/cross/clang-aa845d7a24/bin/clang-15+0x2c0944f)
>    #13 0x000056235906b917 clang::EmitBackendOutput(clang::DiagnosticsEngi=
ne&, clang::HeaderSearchOptions const&, clang::CodeGenOptions const&, clang=
::TargetOptions const&, clang::LangOptions const&, llvm::StringRef, clang::=
BackendAction, std::unique_ptr<llvm::raw_pwrite_stream, std::default_delete=
<llvm::raw_pwrite_stream> >) (/opt/cross/clang-aa845d7a24/bin/clang-15+0x37=
8e917)
>    #14 0x0000562359ca3063 clang::BackendConsumer::HandleTranslationUnit(c=
lang::ASTContext&) (/opt/cross/clang-aa845d7a24/bin/clang-15+0x43c6063)
>    #15 0x000056235a779629 clang::ParseAST(clang::Sema&, bool, bool) (/opt=
/cross/clang-aa845d7a24/bin/clang-15+0x4e9c629)
>    #16 0x0000562359ca1e9f clang::CodeGenAction::ExecuteAction() (/opt/cro=
ss/clang-aa845d7a24/bin/clang-15+0x43c4e9f)
>    #17 0x000056235969ec81 clang::FrontendAction::Execute() (/opt/cross/cl=
ang-aa845d7a24/bin/clang-15+0x3dc1c81)
>    #18 0x0000562359635b0a clang::CompilerInstance::ExecuteAction(clang::F=
rontendAction&) (/opt/cross/clang-aa845d7a24/bin/clang-15+0x3d58b0a)
>    #19 0x000056235976359b (/opt/cross/clang-aa845d7a24/bin/clang-15+0x3e8=
659b)
>    #20 0x0000562356985e6c cc1_main(llvm::ArrayRef<char char (/opt/cross/c=
lang-aa845d7a24/bin/clang-15+0x10a8e6c)
>    #21 0x0000562356982b3b ExecuteCC1Tool(llvm::SmallVectorImpl<char drive=
r.cpp:0:0
>    #22 0x00005623594cd765 void llvm::function_ref<void ()>::callback_fn<c=
lang::driver::CC1Command::Execute(llvm::ArrayRef<llvm::Optional<llvm::Strin=
gRef> >, std::__cxx11::basic_string<char, std::char_traits<char>, std::allo=
cator<char> const::'lambda'()>(long) Job.cpp:0:0
>    #23 0x0000562358c918a3 llvm::CrashRecoveryContext::RunSafely(llvm::fun=
ction_ref<void ()>) (/opt/cross/clang-aa845d7a24/bin/clang-15+0x33b48a3)
>    #24 0x00005623594ce05e clang::driver::CC1Command::Execute(llvm::ArrayR=
ef<llvm::Optional<llvm::StringRef> >, std::__cxx11::basic_string<char, std:=
:char_traits<char>, std::allocator<char> const (.part.216) Job.cpp:0:0
>    #25 0x00005623594a2c57 clang::driver::Compilation::ExecuteCommand(clan=
g::driver::Command const&, clang::driver::Command const (/opt/cross/clang-a=
a845d7a24/bin/clang-15+0x3bc5c57)
>    #26 0x00005623594a3637 clang::driver::Compilation::ExecuteJobs(clang::=
driver::JobList const&, llvm::SmallVectorImpl<std::pair<int, clang::driver:=
:Command >&) const (/opt/cross/clang-aa845d7a24/bin/clang-15+0x3bc6637)
>    #27 0x00005623594accc9 clang::driver::Driver::ExecuteCompilation(clang=
::driver::Compilation&, llvm::SmallVectorImpl<std::pair<int, clang::driver:=
:Command >&) (/opt/cross/clang-aa845d7a24/bin/clang-15+0x3bcfcc9)
>    #28 0x00005623568ab38f main (/opt/cross/clang-aa845d7a24/bin/clang-15+=
0xfce38f)
>    #29 0x00007f845ced9d0a __libc_start_main (/lib/x86_64-linux-gnu/libc.s=
o.6+0x26d0a)
>    #30 0x000056235698265a _start (/opt/cross/clang-aa845d7a24/bin/clang-1=
5+0x10a565a)
>    clang-15: error: clang frontend command failed with exit code 70 (use =
-v to see invocation)
>    clang version 15.0.0 (git://gitmirror/llvm_project aa845d7a245d85c441d=
0bd44fc7b6c3be8f3de8d)
>    Target: mips64-unknown-linux
>    Thread model: posix
>    InstalledDir: /opt/cross/clang-aa845d7a24/bin
>    clang-15: note: diagnostic msg:
>    Makefile arch fs include kernel nr_bisected scripts source usr
>=20
>=20
> vim +/ceph_writepages_start +788 fs/ceph/addr.c
>=20
> 1d3576fd10f0d7 Sage Weil          2009-10-06   784 =20
> 1d3576fd10f0d7 Sage Weil          2009-10-06   785  /*
> 1d3576fd10f0d7 Sage Weil          2009-10-06   786   * initiate async wri=
teback
> 1d3576fd10f0d7 Sage Weil          2009-10-06   787   */
> 1d3576fd10f0d7 Sage Weil          2009-10-06  @788  static int ceph_write=
pages_start(struct address_space *mapping,
> 1d3576fd10f0d7 Sage Weil          2009-10-06   789  				 struct writeback=
_control *wbc)
> 1d3576fd10f0d7 Sage Weil          2009-10-06   790  {
> 1d3576fd10f0d7 Sage Weil          2009-10-06   791  	struct inode *inode =
=3D mapping->host;
> 1d3576fd10f0d7 Sage Weil          2009-10-06   792  	struct ceph_inode_in=
fo *ci =3D ceph_inode(inode);
> fc2744aa12da71 Yan, Zheng         2013-05-31   793  	struct ceph_fs_clien=
t *fsc =3D ceph_inode_to_client(inode);
> fc2744aa12da71 Yan, Zheng         2013-05-31   794  	struct ceph_vino vin=
o =3D ceph_vino(inode);
> 2a2d927e35dd8d Yan, Zheng         2017-09-01   795  	pgoff_t index, start=
_index, end =3D -1;
> 80e755fedebc8d Sage Weil          2010-03-31   796  	struct ceph_snap_con=
text *snapc =3D NULL, *last_snapc =3D NULL, *pgsnapc;
> 1d3576fd10f0d7 Sage Weil          2009-10-06   797  	struct pagevec pvec;
> 1d3576fd10f0d7 Sage Weil          2009-10-06   798  	int rc =3D 0;
> 93407472a21b82 Fabian Frederick   2017-02-27   799  	unsigned int wsize =
=3D i_blocksize(inode);
> 1d3576fd10f0d7 Sage Weil          2009-10-06   800  	struct ceph_osd_requ=
est *req =3D NULL;
> 1f934b00e90752 Yan, Zheng         2017-08-30   801  	struct ceph_writebac=
k_ctl ceph_wbc;
> 590e9d9861f5f2 Yan, Zheng         2017-09-03   802  	bool should_loop, ra=
nge_whole =3D false;
> af9cc401ce7452 Yan, Zheng         2018-03-04   803  	bool done =3D false;
> 1702e79734104d Jeff Layton        2021-12-07   804  	bool caching =3D cep=
h_is_cache_enabled(inode);
> 1d3576fd10f0d7 Sage Weil          2009-10-06   805 =20
> 3fb99d483e614b Yanhu Cao          2017-07-21   806  	dout("writepages_sta=
rt %p (mode=3D%s)\n", inode,
> 1d3576fd10f0d7 Sage Weil          2009-10-06   807  	     wbc->sync_mode =
=3D=3D WB_SYNC_NONE ? "NONE" :
> 1d3576fd10f0d7 Sage Weil          2009-10-06   808  	     (wbc->sync_mode=
 =3D=3D WB_SYNC_ALL ? "ALL" : "HOLD"));
> 1d3576fd10f0d7 Sage Weil          2009-10-06   809 =20
> 5d6451b1489ad1 Jeff Layton        2021-08-31   810  	if (ceph_inode_is_sh=
utdown(inode)) {
> 6c93df5db628e7 Yan, Zheng         2016-04-15   811  		if (ci->i_wrbuffer_=
ref > 0) {
> 6c93df5db628e7 Yan, Zheng         2016-04-15   812  			pr_warn_ratelimite=
d(
> 6c93df5db628e7 Yan, Zheng         2016-04-15   813  				"writepage_start =
%p %lld forced umount\n",
> 6c93df5db628e7 Yan, Zheng         2016-04-15   814  				inode, ceph_ino(i=
node));
> 6c93df5db628e7 Yan, Zheng         2016-04-15   815  		}
> a341d4df87487a Yan, Zheng         2015-07-01   816  		mapping_set_error(m=
apping, -EIO);
> 1d3576fd10f0d7 Sage Weil          2009-10-06   817  		return -EIO; /* we'=
re in a forced umount, don't write! */
> 1d3576fd10f0d7 Sage Weil          2009-10-06   818  	}
> 95cca2b44e54b0 Yan, Zheng         2017-07-11   819  	if (fsc->mount_optio=
ns->wsize < wsize)
> 3d14c5d2b6e15c Yehuda Sadeh       2010-04-06   820  		wsize =3D fsc->moun=
t_options->wsize;
> 1d3576fd10f0d7 Sage Weil          2009-10-06   821 =20
> 8667982014d604 Mel Gorman         2017-11-15   822  	pagevec_init(&pvec);
> 1d3576fd10f0d7 Sage Weil          2009-10-06   823 =20
> 590e9d9861f5f2 Yan, Zheng         2017-09-03   824  	start_index =3D wbc-=
>range_cyclic ? mapping->writeback_index : 0;
> 590e9d9861f5f2 Yan, Zheng         2017-09-03   825  	index =3D start_inde=
x;
> 1d3576fd10f0d7 Sage Weil          2009-10-06   826 =20
> 1d3576fd10f0d7 Sage Weil          2009-10-06   827  retry:
> 1d3576fd10f0d7 Sage Weil          2009-10-06   828  	/* find oldest snap =
context with dirty data */
> 05455e1177f768 Yan, Zheng         2017-09-02   829  	snapc =3D get_oldest=
_context(inode, &ceph_wbc, NULL);
> 1d3576fd10f0d7 Sage Weil          2009-10-06   830  	if (!snapc) {
> 1d3576fd10f0d7 Sage Weil          2009-10-06   831  		/* hmm, why does wr=
itepages get called when there
> 1d3576fd10f0d7 Sage Weil          2009-10-06   832  		   is no dirty data=
? */
> 1d3576fd10f0d7 Sage Weil          2009-10-06   833  		dout(" no snap cont=
ext with dirty data?\n");
> 1d3576fd10f0d7 Sage Weil          2009-10-06   834  		goto out;
> 1d3576fd10f0d7 Sage Weil          2009-10-06   835  	}
> 1d3576fd10f0d7 Sage Weil          2009-10-06   836  	dout(" oldest snapc =
is %p seq %lld (%d snaps)\n",
> 1d3576fd10f0d7 Sage Weil          2009-10-06   837  	     snapc, snapc->s=
eq, snapc->num_snaps);
> fc2744aa12da71 Yan, Zheng         2013-05-31   838 =20
> 2a2d927e35dd8d Yan, Zheng         2017-09-01   839  	should_loop =3D fals=
e;
> 2a2d927e35dd8d Yan, Zheng         2017-09-01   840  	if (ceph_wbc.head_sn=
apc && snapc !=3D last_snapc) {
> 2a2d927e35dd8d Yan, Zheng         2017-09-01   841  		/* where to start/e=
nd? */
> 2a2d927e35dd8d Yan, Zheng         2017-09-01   842  		if (wbc->range_cycl=
ic) {
> 2a2d927e35dd8d Yan, Zheng         2017-09-01   843  			index =3D start_in=
dex;
> 2a2d927e35dd8d Yan, Zheng         2017-09-01   844  			end =3D -1;
> 2a2d927e35dd8d Yan, Zheng         2017-09-01   845  			if (index > 0)
> 2a2d927e35dd8d Yan, Zheng         2017-09-01   846  				should_loop =3D t=
rue;
> 2a2d927e35dd8d Yan, Zheng         2017-09-01   847  			dout(" cyclic, sta=
rt at %lu\n", index);
> 2a2d927e35dd8d Yan, Zheng         2017-09-01   848  		} else {
> 2a2d927e35dd8d Yan, Zheng         2017-09-01   849  			index =3D wbc->ran=
ge_start >> PAGE_SHIFT;
> 2a2d927e35dd8d Yan, Zheng         2017-09-01   850  			end =3D wbc->range=
_end >> PAGE_SHIFT;
> 2a2d927e35dd8d Yan, Zheng         2017-09-01   851  			if (wbc->range_sta=
rt =3D=3D 0 && wbc->range_end =3D=3D LLONG_MAX)
> 2a2d927e35dd8d Yan, Zheng         2017-09-01   852  				range_whole =3D t=
rue;
> 2a2d927e35dd8d Yan, Zheng         2017-09-01   853  			dout(" not cyclic,=
 %lu to %lu\n", index, end);
> 2a2d927e35dd8d Yan, Zheng         2017-09-01   854  		}
> 2a2d927e35dd8d Yan, Zheng         2017-09-01   855  	} else if (!ceph_wbc=
.head_snapc) {
> 2a2d927e35dd8d Yan, Zheng         2017-09-01   856  		/* Do not respect w=
bc->range_{start,end}. Dirty pages
> 2a2d927e35dd8d Yan, Zheng         2017-09-01   857  		 * in that range ca=
n be associated with newer snapc.
> 2a2d927e35dd8d Yan, Zheng         2017-09-01   858  		 * They are not wri=
teable until we write all dirty pages
> 2a2d927e35dd8d Yan, Zheng         2017-09-01   859  		 * associated with =
'snapc' get written */
> 1582af2eaaf17c Yan, Zheng         2018-03-06   860  		if (index > 0)
> 2a2d927e35dd8d Yan, Zheng         2017-09-01   861  			should_loop =3D tr=
ue;
> 2a2d927e35dd8d Yan, Zheng         2017-09-01   862  		dout(" non-head sna=
pc, range whole\n");
> 1d3576fd10f0d7 Sage Weil          2009-10-06   863  	}
> 2a2d927e35dd8d Yan, Zheng         2017-09-01   864 =20
> 2a2d927e35dd8d Yan, Zheng         2017-09-01   865  	ceph_put_snap_contex=
t(last_snapc);
> 1d3576fd10f0d7 Sage Weil          2009-10-06   866  	last_snapc =3D snapc=
;
> 1d3576fd10f0d7 Sage Weil          2009-10-06   867 =20
> af9cc401ce7452 Yan, Zheng         2018-03-04   868  	while (!done && inde=
x <=3D end) {
> 5b64640cf65be4 Yan, Zheng         2016-01-07   869  		int num_ops =3D 0, =
op_idx;
> 0e5ecac7168366 Yan, Zheng         2017-08-31   870  		unsigned i, pvec_pa=
ges, max_pages, locked_pages =3D 0;
> 5b64640cf65be4 Yan, Zheng         2016-01-07   871  		struct page **pages=
 =3D NULL, **data_pages;
> 1d3576fd10f0d7 Sage Weil          2009-10-06   872  		struct page *page;
> 0e5ecac7168366 Yan, Zheng         2017-08-31   873  		pgoff_t strip_unit_=
end =3D 0;
> 5b64640cf65be4 Yan, Zheng         2016-01-07   874  		u64 offset =3D 0, l=
en =3D 0;
> a0102bda5bc099 Jeff Layton        2020-07-30   875  		bool from_pool =3D =
false;
> 1d3576fd10f0d7 Sage Weil          2009-10-06   876 =20
> 0e5ecac7168366 Yan, Zheng         2017-08-31   877  		max_pages =3D wsize=
 >> PAGE_SHIFT;
> 1d3576fd10f0d7 Sage Weil          2009-10-06   878 =20
> 1d3576fd10f0d7 Sage Weil          2009-10-06   879  get_more_pages:
> 2e169296603470 Jeff Layton        2020-09-14   880  		pvec_pages =3D page=
vec_lookup_range_tag(&pvec, mapping, &index,
> 2e169296603470 Jeff Layton        2020-09-14   881  						end, PAGECACHE_=
TAG_DIRTY);
> 0ed75fc8d288f4 Jan Kara           2017-11-15   882  		dout("pagevec_looku=
p_range_tag got %d\n", pvec_pages);
> 1d3576fd10f0d7 Sage Weil          2009-10-06   883  		if (!pvec_pages && =
!locked_pages)
> 1d3576fd10f0d7 Sage Weil          2009-10-06   884  			break;
> 1d3576fd10f0d7 Sage Weil          2009-10-06   885  		for (i =3D 0; i < p=
vec_pages && locked_pages < max_pages; i++) {
> 1d3576fd10f0d7 Sage Weil          2009-10-06   886  			page =3D pvec.page=
s[i];
> 1d3576fd10f0d7 Sage Weil          2009-10-06   887  			dout("? %p idx %lu=
\n", page, page->index);
> 1d3576fd10f0d7 Sage Weil          2009-10-06   888  			if (locked_pages =
=3D=3D 0)
> 1d3576fd10f0d7 Sage Weil          2009-10-06   889  				lock_page(page); =
 /* first page */
> 1d3576fd10f0d7 Sage Weil          2009-10-06   890  			else if (!trylock_=
page(page))
> 1d3576fd10f0d7 Sage Weil          2009-10-06   891  				break;
> 1d3576fd10f0d7 Sage Weil          2009-10-06   892 =20
> 1d3576fd10f0d7 Sage Weil          2009-10-06   893  			/* only dirty page=
s, or our accounting breaks */
> 1d3576fd10f0d7 Sage Weil          2009-10-06   894  			if (unlikely(!Page=
Dirty(page)) ||
> 1d3576fd10f0d7 Sage Weil          2009-10-06   895  			    unlikely(page-=
>mapping !=3D mapping)) {
> 1d3576fd10f0d7 Sage Weil          2009-10-06   896  				dout("!dirty or !=
mapping %p\n", page);
> 1d3576fd10f0d7 Sage Weil          2009-10-06   897  				unlock_page(page)=
;
> 0713e5f24b7deb Yan, Zheng         2017-08-31   898  				continue;
> 1d3576fd10f0d7 Sage Weil          2009-10-06   899  			}
> af9cc401ce7452 Yan, Zheng         2018-03-04   900  			/* only if matchin=
g snap context */
> af9cc401ce7452 Yan, Zheng         2018-03-04   901  			pgsnapc =3D page_s=
nap_context(page);
> af9cc401ce7452 Yan, Zheng         2018-03-04   902  			if (pgsnapc !=3D s=
napc) {
> af9cc401ce7452 Yan, Zheng         2018-03-04   903  				dout("page snapc =
%p %lld !=3D oldest %p %lld\n",
> af9cc401ce7452 Yan, Zheng         2018-03-04   904  				     pgsnapc, pgs=
napc->seq, snapc, snapc->seq);
> 1582af2eaaf17c Yan, Zheng         2018-03-06   905  				if (!should_loop =
&&
> 1582af2eaaf17c Yan, Zheng         2018-03-06   906  				    !ceph_wbc.hea=
d_snapc &&
> 1582af2eaaf17c Yan, Zheng         2018-03-06   907  				    wbc->sync_mod=
e !=3D WB_SYNC_NONE)
> 1582af2eaaf17c Yan, Zheng         2018-03-06   908  					should_loop =3D =
true;
> 1d3576fd10f0d7 Sage Weil          2009-10-06   909  				unlock_page(page)=
;
> af9cc401ce7452 Yan, Zheng         2018-03-04   910  				continue;
> 1d3576fd10f0d7 Sage Weil          2009-10-06   911  			}
> 1f934b00e90752 Yan, Zheng         2017-08-30   912  			if (page_offset(pa=
ge) >=3D ceph_wbc.i_size) {
> 1f934b00e90752 Yan, Zheng         2017-08-30   913  				dout("%p page eof=
 %llu\n",
> 1f934b00e90752 Yan, Zheng         2017-08-30   914  				     page, ceph_w=
bc.i_size);
> c95f1c5f436bad Erqi Chen          2019-07-24   915  				if ((ceph_wbc.siz=
e_stable ||
> c95f1c5f436bad Erqi Chen          2019-07-24   916  				    page_offset(p=
age) >=3D i_size_read(inode)) &&
> c95f1c5f436bad Erqi Chen          2019-07-24   917  				    clear_page_di=
rty_for_io(page))
> af9cc401ce7452 Yan, Zheng         2018-03-04   918  					mapping->a_ops->=
invalidatepage(page,
> 8ff2d290c8ce77 Jeff Layton        2021-04-05   919  								0, thp_size(p=
age));
> af9cc401ce7452 Yan, Zheng         2018-03-04   920  				unlock_page(page)=
;
> af9cc401ce7452 Yan, Zheng         2018-03-04   921  				continue;
> af9cc401ce7452 Yan, Zheng         2018-03-04   922  			}
> af9cc401ce7452 Yan, Zheng         2018-03-04   923  			if (strip_unit_end=
 && (page->index > strip_unit_end)) {
> af9cc401ce7452 Yan, Zheng         2018-03-04   924  				dout("end of stri=
p unit %p\n", page);
> 1d3576fd10f0d7 Sage Weil          2009-10-06   925  				unlock_page(page)=
;
> 1d3576fd10f0d7 Sage Weil          2009-10-06   926  				break;
> 1d3576fd10f0d7 Sage Weil          2009-10-06   927  			}
> 1702e79734104d Jeff Layton        2021-12-07   928  			if (PageWriteback(=
page) || PageFsCache(page)) {
> 0713e5f24b7deb Yan, Zheng         2017-08-31   929  				if (wbc->sync_mod=
e =3D=3D WB_SYNC_NONE) {
> 1d3576fd10f0d7 Sage Weil          2009-10-06   930  					dout("%p under w=
riteback\n", page);
> 1d3576fd10f0d7 Sage Weil          2009-10-06   931  					unlock_page(page=
);
> 0713e5f24b7deb Yan, Zheng         2017-08-31   932  					continue;
> 0713e5f24b7deb Yan, Zheng         2017-08-31   933  				}
> 0713e5f24b7deb Yan, Zheng         2017-08-31   934  				dout("waiting on =
writeback %p\n", page);
> 0713e5f24b7deb Yan, Zheng         2017-08-31   935  				wait_on_page_writ=
eback(page);
> 1702e79734104d Jeff Layton        2021-12-07   936  				wait_on_page_fsca=
che(page);
> 1d3576fd10f0d7 Sage Weil          2009-10-06   937  			}
> 1d3576fd10f0d7 Sage Weil          2009-10-06   938 =20
> 1d3576fd10f0d7 Sage Weil          2009-10-06   939  			if (!clear_page_di=
rty_for_io(page)) {
> 1d3576fd10f0d7 Sage Weil          2009-10-06   940  				dout("%p !clear_p=
age_dirty_for_io\n", page);
> 1d3576fd10f0d7 Sage Weil          2009-10-06   941  				unlock_page(page)=
;
> 0713e5f24b7deb Yan, Zheng         2017-08-31   942  				continue;
> 1d3576fd10f0d7 Sage Weil          2009-10-06   943  			}
> 1d3576fd10f0d7 Sage Weil          2009-10-06   944 =20
> e5975c7c8eb6ae Alex Elder         2013-03-14   945  			/*
> e5975c7c8eb6ae Alex Elder         2013-03-14   946  			 * We have somethi=
ng to write.  If this is
> e5975c7c8eb6ae Alex Elder         2013-03-14   947  			 * the first locke=
d page this time through,
> 5b64640cf65be4 Yan, Zheng         2016-01-07   948  			 * calculate max p=
ossinle write size and
> 5b64640cf65be4 Yan, Zheng         2016-01-07   949  			 * allocate a page=
 array
> e5975c7c8eb6ae Alex Elder         2013-03-14   950  			 */
> 1d3576fd10f0d7 Sage Weil          2009-10-06   951  			if (locked_pages =
=3D=3D 0) {
> 5b64640cf65be4 Yan, Zheng         2016-01-07   952  				u64 objnum;
> 5b64640cf65be4 Yan, Zheng         2016-01-07   953  				u64 objoff;
> dccbf08005df80 Ilya Dryomov       2018-02-17   954  				u32 xlen;
> 5b64640cf65be4 Yan, Zheng         2016-01-07   955 =20
> 1d3576fd10f0d7 Sage Weil          2009-10-06   956  				/* prepare async =
write request */
> 6285bc23127741 Alex Elder         2012-10-02   957  				offset =3D (u64)p=
age_offset(page);
> dccbf08005df80 Ilya Dryomov       2018-02-17   958  				ceph_calc_file_ob=
ject_mapping(&ci->i_layout,
> dccbf08005df80 Ilya Dryomov       2018-02-17   959  							      offset, =
wsize,
> 5b64640cf65be4 Yan, Zheng         2016-01-07   960  							      &objnum,=
 &objoff,
> dccbf08005df80 Ilya Dryomov       2018-02-17   961  							      &xlen);
> dccbf08005df80 Ilya Dryomov       2018-02-17   962  				len =3D xlen;
> 8c71897be2ddfd Henry C Chang      2011-05-03   963 =20
> 3fb99d483e614b Yanhu Cao          2017-07-21   964  				num_ops =3D 1;
> 5b64640cf65be4 Yan, Zheng         2016-01-07   965  				strip_unit_end =
=3D page->index +
> 09cbfeaf1a5a67 Kirill A. Shutemov 2016-04-01   966  					((len - 1) >> PA=
GE_SHIFT);
> 88486957f9fbf5 Alex Elder         2013-03-14   967 =20
> 5b64640cf65be4 Yan, Zheng         2016-01-07   968  				BUG_ON(pages);
> 88486957f9fbf5 Alex Elder         2013-03-14   969  				max_pages =3D cal=
c_pages_for(0, (u64)len);
> 6da2ec56059c3c Kees Cook          2018-06-12   970  				pages =3D kmalloc=
_array(max_pages,
> 6da2ec56059c3c Kees Cook          2018-06-12   971  						      sizeof(*p=
ages),
> fc2744aa12da71 Yan, Zheng         2013-05-31   972  						      GFP_NOFS)=
;
> 88486957f9fbf5 Alex Elder         2013-03-14   973  				if (!pages) {
> a0102bda5bc099 Jeff Layton        2020-07-30   974  					from_pool =3D tr=
ue;
> a0102bda5bc099 Jeff Layton        2020-07-30   975  					pages =3D mempoo=
l_alloc(ceph_wb_pagevec_pool, GFP_NOFS);
> e5975c7c8eb6ae Alex Elder         2013-03-14   976  					BUG_ON(!pages);
> 88486957f9fbf5 Alex Elder         2013-03-14   977  				}
> 5b64640cf65be4 Yan, Zheng         2016-01-07   978 =20
> 5b64640cf65be4 Yan, Zheng         2016-01-07   979  				len =3D 0;
> 5b64640cf65be4 Yan, Zheng         2016-01-07   980  			} else if (page->i=
ndex !=3D
> 09cbfeaf1a5a67 Kirill A. Shutemov 2016-04-01   981  				   (offset + len)=
 >> PAGE_SHIFT) {
> a0102bda5bc099 Jeff Layton        2020-07-30   982  				if (num_ops >=3D =
(from_pool ?  CEPH_OSD_SLAB_OPS :
> 5b64640cf65be4 Yan, Zheng         2016-01-07   983  							     CEPH_OSD_=
MAX_OPS)) {
> 5b64640cf65be4 Yan, Zheng         2016-01-07   984  					redirty_page_for=
_writepage(wbc, page);
> 5b64640cf65be4 Yan, Zheng         2016-01-07   985  					unlock_page(page=
);
> 5b64640cf65be4 Yan, Zheng         2016-01-07   986  					break;
> 5b64640cf65be4 Yan, Zheng         2016-01-07   987  				}
> 5b64640cf65be4 Yan, Zheng         2016-01-07   988 =20
> 5b64640cf65be4 Yan, Zheng         2016-01-07   989  				num_ops++;
> 5b64640cf65be4 Yan, Zheng         2016-01-07   990  				offset =3D (u64)p=
age_offset(page);
> 5b64640cf65be4 Yan, Zheng         2016-01-07   991  				len =3D 0;
> 1d3576fd10f0d7 Sage Weil          2009-10-06   992  			}
> 1d3576fd10f0d7 Sage Weil          2009-10-06   993 =20
> 1d3576fd10f0d7 Sage Weil          2009-10-06   994  			/* note position o=
f first page in pvec */
> 1d3576fd10f0d7 Sage Weil          2009-10-06   995  			dout("%p will writ=
e page %p idx %lu\n",
> 1d3576fd10f0d7 Sage Weil          2009-10-06   996  			     inode, page, =
page->index);
> 2baba25019ec56 Yehuda Sadeh       2009-12-18   997 =20
> 5b64640cf65be4 Yan, Zheng         2016-01-07   998  			if (atomic_long_in=
c_return(&fsc->writeback_count) >
> 5b64640cf65be4 Yan, Zheng         2016-01-07   999  			    CONGESTION_ON_=
THRESH(
> 3d14c5d2b6e15c Yehuda Sadeh       2010-04-06  1000  				    fsc->mount_op=
tions->congestion_kb)) {
> 09dc9fc24ba714 Jan Kara           2017-04-12  1001  				set_bdi_congested=
(inode_to_bdi(inode),
> 213c99ee0cf17f Sage Weil          2010-08-03  1002  						  BLK_RW_ASYNC)=
;
> 2baba25019ec56 Yehuda Sadeh       2009-12-18  1003  			}
> 2baba25019ec56 Yehuda Sadeh       2009-12-18  1004 =20
> 0713e5f24b7deb Yan, Zheng         2017-08-31  1005 =20
> 0713e5f24b7deb Yan, Zheng         2017-08-31  1006  			pages[locked_pages=
++] =3D page;
> 0713e5f24b7deb Yan, Zheng         2017-08-31  1007  			pvec.pages[i] =3D =
NULL;
> 0713e5f24b7deb Yan, Zheng         2017-08-31  1008 =20
> 8ff2d290c8ce77 Jeff Layton        2021-04-05  1009  			len +=3D thp_size(=
page);
> 1d3576fd10f0d7 Sage Weil          2009-10-06  1010  		}
> 1d3576fd10f0d7 Sage Weil          2009-10-06  1011 =20
> 1d3576fd10f0d7 Sage Weil          2009-10-06  1012  		/* did we get anyth=
ing? */
> 1d3576fd10f0d7 Sage Weil          2009-10-06  1013  		if (!locked_pages)
> 1d3576fd10f0d7 Sage Weil          2009-10-06  1014  			goto release_pvec_=
pages;
> 1d3576fd10f0d7 Sage Weil          2009-10-06  1015  		if (i) {
> 0713e5f24b7deb Yan, Zheng         2017-08-31  1016  			unsigned j, n =3D =
0;
> 0713e5f24b7deb Yan, Zheng         2017-08-31  1017  			/* shift unused pa=
ge to beginning of pvec */
> 0713e5f24b7deb Yan, Zheng         2017-08-31  1018  			for (j =3D 0; j < =
pvec_pages; j++) {
> 0713e5f24b7deb Yan, Zheng         2017-08-31  1019  				if (!pvec.pages[j=
])
> 0713e5f24b7deb Yan, Zheng         2017-08-31  1020  					continue;
> 0713e5f24b7deb Yan, Zheng         2017-08-31  1021  				if (n < j)
> 0713e5f24b7deb Yan, Zheng         2017-08-31  1022  					pvec.pages[n] =
=3D pvec.pages[j];
> 0713e5f24b7deb Yan, Zheng         2017-08-31  1023  				n++;
> 0713e5f24b7deb Yan, Zheng         2017-08-31  1024  			}
> 0713e5f24b7deb Yan, Zheng         2017-08-31  1025  			pvec.nr =3D n;
> 1d3576fd10f0d7 Sage Weil          2009-10-06  1026 =20
> 1d3576fd10f0d7 Sage Weil          2009-10-06  1027  			if (pvec_pages && =
i =3D=3D pvec_pages &&
> 1d3576fd10f0d7 Sage Weil          2009-10-06  1028  			    locked_pages <=
 max_pages) {
> 1d3576fd10f0d7 Sage Weil          2009-10-06  1029  				dout("reached end=
 pvec, trying for more\n");
> 0713e5f24b7deb Yan, Zheng         2017-08-31  1030  				pagevec_release(&=
pvec);
> 1d3576fd10f0d7 Sage Weil          2009-10-06  1031  				goto get_more_pag=
es;
> 1d3576fd10f0d7 Sage Weil          2009-10-06  1032  			}
> 1d3576fd10f0d7 Sage Weil          2009-10-06  1033  		}
> 1d3576fd10f0d7 Sage Weil          2009-10-06  1034 =20
> 5b64640cf65be4 Yan, Zheng         2016-01-07  1035  new_request:
> e5975c7c8eb6ae Alex Elder         2013-03-14  1036  		offset =3D page_off=
set(pages[0]);
> 5b64640cf65be4 Yan, Zheng         2016-01-07  1037  		len =3D wsize;
> 5b64640cf65be4 Yan, Zheng         2016-01-07  1038 =20
> 5b64640cf65be4 Yan, Zheng         2016-01-07  1039  		req =3D ceph_osdc_n=
ew_request(&fsc->client->osdc,
> 5b64640cf65be4 Yan, Zheng         2016-01-07  1040  					&ci->i_layout, v=
ino,
> 5b64640cf65be4 Yan, Zheng         2016-01-07  1041  					offset, &len, 0,=
 num_ops,
> 1f934b00e90752 Yan, Zheng         2017-08-30  1042  					CEPH_OSD_OP_WRIT=
E, CEPH_OSD_FLAG_WRITE,
> 1f934b00e90752 Yan, Zheng         2017-08-30  1043  					snapc, ceph_wbc.=
truncate_seq,
> 1f934b00e90752 Yan, Zheng         2017-08-30  1044  					ceph_wbc.truncat=
e_size, false);
> 5b64640cf65be4 Yan, Zheng         2016-01-07  1045  		if (IS_ERR(req)) {
> 5b64640cf65be4 Yan, Zheng         2016-01-07  1046  			req =3D ceph_osdc_=
new_request(&fsc->client->osdc,
> 5b64640cf65be4 Yan, Zheng         2016-01-07  1047  						&ci->i_layout, =
vino,
> 5b64640cf65be4 Yan, Zheng         2016-01-07  1048  						offset, &len, 0=
,
> 5b64640cf65be4 Yan, Zheng         2016-01-07  1049  						min(num_ops,
> 5b64640cf65be4 Yan, Zheng         2016-01-07  1050  						    CEPH_OSD_SL=
AB_OPS),
> 5b64640cf65be4 Yan, Zheng         2016-01-07  1051  						CEPH_OSD_OP_WRI=
TE,
> 54ea0046b6fe36 Ilya Dryomov       2017-02-11  1052  						CEPH_OSD_FLAG_W=
RITE,
> 1f934b00e90752 Yan, Zheng         2017-08-30  1053  						snapc, ceph_wbc=
.truncate_seq,
> 1f934b00e90752 Yan, Zheng         2017-08-30  1054  						ceph_wbc.trunca=
te_size, true);
> 5b64640cf65be4 Yan, Zheng         2016-01-07  1055  			BUG_ON(IS_ERR(req)=
);
> 5b64640cf65be4 Yan, Zheng         2016-01-07  1056  		}
> 5b64640cf65be4 Yan, Zheng         2016-01-07  1057  		BUG_ON(len < page_o=
ffset(pages[locked_pages - 1]) +
> 8ff2d290c8ce77 Jeff Layton        2021-04-05  1058  			     thp_size(page=
) - offset);
> 5b64640cf65be4 Yan, Zheng         2016-01-07  1059 =20
> 5b64640cf65be4 Yan, Zheng         2016-01-07  1060  		req->r_callback =3D=
 writepages_finish;
> 5b64640cf65be4 Yan, Zheng         2016-01-07  1061  		req->r_inode =3D in=
ode;
> 5b64640cf65be4 Yan, Zheng         2016-01-07  1062 =20
> 5b64640cf65be4 Yan, Zheng         2016-01-07  1063  		/* Format the osd r=
equest message and submit the write */
> 5b64640cf65be4 Yan, Zheng         2016-01-07  1064  		len =3D 0;
> 5b64640cf65be4 Yan, Zheng         2016-01-07  1065  		data_pages =3D page=
s;
> 5b64640cf65be4 Yan, Zheng         2016-01-07  1066  		op_idx =3D 0;
> 5b64640cf65be4 Yan, Zheng         2016-01-07  1067  		for (i =3D 0; i < l=
ocked_pages; i++) {
> 5b64640cf65be4 Yan, Zheng         2016-01-07  1068  			u64 cur_offset =3D=
 page_offset(pages[i]);
> 1702e79734104d Jeff Layton        2021-12-07  1069  			/*
> 1702e79734104d Jeff Layton        2021-12-07  1070  			 * Discontinuity i=
n page range? Ceph can handle that by just passing
> 1702e79734104d Jeff Layton        2021-12-07  1071  			 * multiple extent=
s in the write op.
> 1702e79734104d Jeff Layton        2021-12-07  1072  			 */
> 5b64640cf65be4 Yan, Zheng         2016-01-07  1073  			if (offset + len !=
=3D cur_offset) {
> 1702e79734104d Jeff Layton        2021-12-07  1074  				/* If it's full, =
stop here */
> 3fb99d483e614b Yanhu Cao          2017-07-21  1075  				if (op_idx + 1 =
=3D=3D req->r_num_ops)
> 5b64640cf65be4 Yan, Zheng         2016-01-07  1076  					break;
> 1702e79734104d Jeff Layton        2021-12-07  1077 =20
> 1702e79734104d Jeff Layton        2021-12-07  1078  				/* Kick off an fs=
cache write with what we have so far. */
> 1702e79734104d Jeff Layton        2021-12-07  1079  				ceph_fscache_writ=
e_to_cache(inode, offset, len, caching);
> 1702e79734104d Jeff Layton        2021-12-07  1080 =20
> 1702e79734104d Jeff Layton        2021-12-07  1081  				/* Start a new ex=
tent */
> 5b64640cf65be4 Yan, Zheng         2016-01-07  1082  				osd_req_op_extent=
_dup_last(req, op_idx,
> 5b64640cf65be4 Yan, Zheng         2016-01-07  1083  							   cur_offset =
- offset);
> 5b64640cf65be4 Yan, Zheng         2016-01-07  1084  				dout("writepages =
got pages at %llu~%llu\n",
> 5b64640cf65be4 Yan, Zheng         2016-01-07  1085  				     offset, len)=
;
> 5b64640cf65be4 Yan, Zheng         2016-01-07  1086  				osd_req_op_extent=
_osd_data_pages(req, op_idx,
> 5b64640cf65be4 Yan, Zheng         2016-01-07  1087  							data_pages, le=
n, 0,
> a0102bda5bc099 Jeff Layton        2020-07-30  1088  							from_pool, fal=
se);
> 5b64640cf65be4 Yan, Zheng         2016-01-07  1089  				osd_req_op_extent=
_update(req, op_idx, len);
> 5b64640cf65be4 Yan, Zheng         2016-01-07  1090 =20
> 5b64640cf65be4 Yan, Zheng         2016-01-07  1091  				len =3D 0;
> 5b64640cf65be4 Yan, Zheng         2016-01-07  1092  				offset =3D cur_of=
fset;
> 5b64640cf65be4 Yan, Zheng         2016-01-07  1093  				data_pages =3D pa=
ges + i;
> 5b64640cf65be4 Yan, Zheng         2016-01-07  1094  				op_idx++;
> 5b64640cf65be4 Yan, Zheng         2016-01-07  1095  			}
> 5b64640cf65be4 Yan, Zheng         2016-01-07  1096 =20
> 5b64640cf65be4 Yan, Zheng         2016-01-07  1097  			set_page_writeback=
(pages[i]);
> 1702e79734104d Jeff Layton        2021-12-07  1098  			if (caching)
> 1702e79734104d Jeff Layton        2021-12-07  1099  				ceph_set_page_fsc=
ache(pages[i]);
> 8ff2d290c8ce77 Jeff Layton        2021-04-05  1100  			len +=3D thp_size(=
page);
> 5b64640cf65be4 Yan, Zheng         2016-01-07  1101  		}
> 1702e79734104d Jeff Layton        2021-12-07  1102  		ceph_fscache_write_=
to_cache(inode, offset, len, caching);
> 5b64640cf65be4 Yan, Zheng         2016-01-07  1103 =20
> 1f934b00e90752 Yan, Zheng         2017-08-30  1104  		if (ceph_wbc.size_s=
table) {
> 1f934b00e90752 Yan, Zheng         2017-08-30  1105  			len =3D min(len, c=
eph_wbc.i_size - offset);
> 5b64640cf65be4 Yan, Zheng         2016-01-07  1106  		} else if (i =3D=3D=
 locked_pages) {
> e1966b49446a43 Yan, Zheng         2015-06-18  1107  			/* writepages_fini=
sh() clears writeback pages
> e1966b49446a43 Yan, Zheng         2015-06-18  1108  			 * according to th=
e data length, so make sure
> e1966b49446a43 Yan, Zheng         2015-06-18  1109  			 * data length cov=
ers all locked pages */
> 8ff2d290c8ce77 Jeff Layton        2021-04-05  1110  			u64 min_len =3D le=
n + 1 - thp_size(page);
> 1f934b00e90752 Yan, Zheng         2017-08-30  1111  			len =3D get_writep=
ages_data_length(inode, pages[i - 1],
> 1f934b00e90752 Yan, Zheng         2017-08-30  1112  							 offset);
> 5b64640cf65be4 Yan, Zheng         2016-01-07  1113  			len =3D max(len, m=
in_len);
> e1966b49446a43 Yan, Zheng         2015-06-18  1114  		}
> 5b64640cf65be4 Yan, Zheng         2016-01-07  1115  		dout("writepages go=
t pages at %llu~%llu\n", offset, len);
> 1d3576fd10f0d7 Sage Weil          2009-10-06  1116 =20
> 5b64640cf65be4 Yan, Zheng         2016-01-07  1117  		osd_req_op_extent_o=
sd_data_pages(req, op_idx, data_pages, len,
> a0102bda5bc099 Jeff Layton        2020-07-30  1118  						 0, from_pool, =
false);
> 5b64640cf65be4 Yan, Zheng         2016-01-07  1119  		osd_req_op_extent_u=
pdate(req, op_idx, len);
> e5975c7c8eb6ae Alex Elder         2013-03-14  1120 =20
> 5b64640cf65be4 Yan, Zheng         2016-01-07  1121  		BUG_ON(op_idx + 1 !=
=3D req->r_num_ops);
> e5975c7c8eb6ae Alex Elder         2013-03-14  1122 =20
> a0102bda5bc099 Jeff Layton        2020-07-30  1123  		from_pool =3D false=
;
> 5b64640cf65be4 Yan, Zheng         2016-01-07  1124  		if (i < locked_page=
s) {
> 5b64640cf65be4 Yan, Zheng         2016-01-07  1125  			BUG_ON(num_ops <=
=3D req->r_num_ops);
> 5b64640cf65be4 Yan, Zheng         2016-01-07  1126  			num_ops -=3D req->=
r_num_ops;
> 5b64640cf65be4 Yan, Zheng         2016-01-07  1127  			locked_pages -=3D =
i;
> 5b64640cf65be4 Yan, Zheng         2016-01-07  1128 =20
> 5b64640cf65be4 Yan, Zheng         2016-01-07  1129  			/* allocate new pa=
ges array for next request */
> 5b64640cf65be4 Yan, Zheng         2016-01-07  1130  			data_pages =3D pag=
es;
> 6da2ec56059c3c Kees Cook          2018-06-12  1131  			pages =3D kmalloc_=
array(locked_pages, sizeof(*pages),
> 5b64640cf65be4 Yan, Zheng         2016-01-07  1132  					      GFP_NOFS);
> 5b64640cf65be4 Yan, Zheng         2016-01-07  1133  			if (!pages) {
> a0102bda5bc099 Jeff Layton        2020-07-30  1134  				from_pool =3D tru=
e;
> a0102bda5bc099 Jeff Layton        2020-07-30  1135  				pages =3D mempool=
_alloc(ceph_wb_pagevec_pool, GFP_NOFS);
> 5b64640cf65be4 Yan, Zheng         2016-01-07  1136  				BUG_ON(!pages);
> 5b64640cf65be4 Yan, Zheng         2016-01-07  1137  			}
> 5b64640cf65be4 Yan, Zheng         2016-01-07  1138  			memcpy(pages, data=
_pages + i,
> 5b64640cf65be4 Yan, Zheng         2016-01-07  1139  			       locked_page=
s * sizeof(*pages));
> 5b64640cf65be4 Yan, Zheng         2016-01-07  1140  			memset(data_pages =
+ i, 0,
> 5b64640cf65be4 Yan, Zheng         2016-01-07  1141  			       locked_page=
s * sizeof(*pages));
> 5b64640cf65be4 Yan, Zheng         2016-01-07  1142  		} else {
> 5b64640cf65be4 Yan, Zheng         2016-01-07  1143  			BUG_ON(num_ops !=
=3D req->r_num_ops);
> 5b64640cf65be4 Yan, Zheng         2016-01-07  1144  			index =3D pages[i =
- 1]->index + 1;
> 5b64640cf65be4 Yan, Zheng         2016-01-07  1145  			/* request message=
 now owns the pages array */
> 5b64640cf65be4 Yan, Zheng         2016-01-07  1146  			pages =3D NULL;
> 5b64640cf65be4 Yan, Zheng         2016-01-07  1147  		}
> e5975c7c8eb6ae Alex Elder         2013-03-14  1148 =20
> fac02ddf910814 Arnd Bergmann      2018-07-13  1149  		req->r_mtime =3D in=
ode->i_mtime;
> 9d6fcb081a4770 Sage Weil          2011-05-12  1150  		rc =3D ceph_osdc_st=
art_request(&fsc->client->osdc, req, true);
> 9d6fcb081a4770 Sage Weil          2011-05-12  1151  		BUG_ON(rc);
> 1d3576fd10f0d7 Sage Weil          2009-10-06  1152  		req =3D NULL;
> 1d3576fd10f0d7 Sage Weil          2009-10-06  1153 =20
> 5b64640cf65be4 Yan, Zheng         2016-01-07  1154  		wbc->nr_to_write -=
=3D i;
> 5b64640cf65be4 Yan, Zheng         2016-01-07  1155  		if (pages)
> 5b64640cf65be4 Yan, Zheng         2016-01-07  1156  			goto new_request;
> 5b64640cf65be4 Yan, Zheng         2016-01-07  1157 =20
> 2a2d927e35dd8d Yan, Zheng         2017-09-01  1158  		/*
> 2a2d927e35dd8d Yan, Zheng         2017-09-01  1159  		 * We stop writing =
back only if we are not doing
> 2a2d927e35dd8d Yan, Zheng         2017-09-01  1160  		 * integrity sync. =
In case of integrity sync we have to
> 2a2d927e35dd8d Yan, Zheng         2017-09-01  1161  		 * keep going until=
 we have written all the pages
> 2a2d927e35dd8d Yan, Zheng         2017-09-01  1162  		 * we tagged for wr=
iteback prior to entering this loop.
> 2a2d927e35dd8d Yan, Zheng         2017-09-01  1163  		 */
> 2a2d927e35dd8d Yan, Zheng         2017-09-01  1164  		if (wbc->nr_to_writ=
e <=3D 0 && wbc->sync_mode =3D=3D WB_SYNC_NONE)
> af9cc401ce7452 Yan, Zheng         2018-03-04  1165  			done =3D true;
> 1d3576fd10f0d7 Sage Weil          2009-10-06  1166 =20
> 1d3576fd10f0d7 Sage Weil          2009-10-06  1167  release_pvec_pages:
> 1d3576fd10f0d7 Sage Weil          2009-10-06  1168  		dout("pagevec_relea=
se on %d pages (%p)\n", (int)pvec.nr,
> 1d3576fd10f0d7 Sage Weil          2009-10-06  1169  		     pvec.nr ? pvec=
.pages[0] : NULL);
> 1d3576fd10f0d7 Sage Weil          2009-10-06  1170  		pagevec_release(&pv=
ec);
> 1d3576fd10f0d7 Sage Weil          2009-10-06  1171  	}
> 1d3576fd10f0d7 Sage Weil          2009-10-06  1172 =20
> 1d3576fd10f0d7 Sage Weil          2009-10-06  1173  	if (should_loop && !=
done) {
> 1d3576fd10f0d7 Sage Weil          2009-10-06  1174  		/* more to do; loop=
 back to beginning of file */
> 1d3576fd10f0d7 Sage Weil          2009-10-06  1175  		dout("writepages lo=
oping back to beginning of file\n");
> 2a2d927e35dd8d Yan, Zheng         2017-09-01  1176  		end =3D start_index=
 - 1; /* OK even when start_index =3D=3D 0 */
> f275635ee0b664 Yan, Zheng         2017-09-01  1177 =20
> f275635ee0b664 Yan, Zheng         2017-09-01  1178  		/* to write dirty p=
ages associated with next snapc,
> f275635ee0b664 Yan, Zheng         2017-09-01  1179  		 * we need to wait =
until current writes complete */
> f275635ee0b664 Yan, Zheng         2017-09-01  1180  		if (wbc->sync_mode =
!=3D WB_SYNC_NONE &&
> f275635ee0b664 Yan, Zheng         2017-09-01  1181  		    start_index =3D=
=3D 0 && /* all dirty pages were checked */
> f275635ee0b664 Yan, Zheng         2017-09-01  1182  		    !ceph_wbc.head_=
snapc) {
> f275635ee0b664 Yan, Zheng         2017-09-01  1183  			struct page *page;
> f275635ee0b664 Yan, Zheng         2017-09-01  1184  			unsigned i, nr;
> f275635ee0b664 Yan, Zheng         2017-09-01  1185  			index =3D 0;
> f275635ee0b664 Yan, Zheng         2017-09-01  1186  			while ((index <=3D=
 end) &&
> f275635ee0b664 Yan, Zheng         2017-09-01  1187  			       (nr =3D pag=
evec_lookup_tag(&pvec, mapping, &index,
> 67fd707f468142 Jan Kara           2017-11-15  1188  						PAGECACHE_TAG_W=
RITEBACK))) {
> f275635ee0b664 Yan, Zheng         2017-09-01  1189  				for (i =3D 0; i <=
 nr; i++) {
> f275635ee0b664 Yan, Zheng         2017-09-01  1190  					page =3D pvec.pa=
ges[i];
> f275635ee0b664 Yan, Zheng         2017-09-01  1191  					if (page_snap_co=
ntext(page) !=3D snapc)
> f275635ee0b664 Yan, Zheng         2017-09-01  1192  						continue;
> f275635ee0b664 Yan, Zheng         2017-09-01  1193  					wait_on_page_wri=
teback(page);
> f275635ee0b664 Yan, Zheng         2017-09-01  1194  				}
> f275635ee0b664 Yan, Zheng         2017-09-01  1195  				pagevec_release(&=
pvec);
> f275635ee0b664 Yan, Zheng         2017-09-01  1196  				cond_resched();
> f275635ee0b664 Yan, Zheng         2017-09-01  1197  			}
> f275635ee0b664 Yan, Zheng         2017-09-01  1198  		}
> f275635ee0b664 Yan, Zheng         2017-09-01  1199 =20
> 2a2d927e35dd8d Yan, Zheng         2017-09-01  1200  		start_index =3D 0;
> 1d3576fd10f0d7 Sage Weil          2009-10-06  1201  		index =3D 0;
> 1d3576fd10f0d7 Sage Weil          2009-10-06  1202  		goto retry;
> 1d3576fd10f0d7 Sage Weil          2009-10-06  1203  	}
> 1d3576fd10f0d7 Sage Weil          2009-10-06  1204 =20
> 1d3576fd10f0d7 Sage Weil          2009-10-06  1205  	if (wbc->range_cycli=
c || (range_whole && wbc->nr_to_write > 0))
> 1d3576fd10f0d7 Sage Weil          2009-10-06  1206  		mapping->writeback_=
index =3D index;
> 1d3576fd10f0d7 Sage Weil          2009-10-06  1207 =20
> 1d3576fd10f0d7 Sage Weil          2009-10-06  1208  out:
> 1d3576fd10f0d7 Sage Weil          2009-10-06  1209  	ceph_osdc_put_reques=
t(req);
> 2a2d927e35dd8d Yan, Zheng         2017-09-01  1210  	ceph_put_snap_contex=
t(last_snapc);
> 2a2d927e35dd8d Yan, Zheng         2017-09-01  1211  	dout("writepages den=
d - startone, rc =3D %d\n", rc);
> 1d3576fd10f0d7 Sage Weil          2009-10-06  1212  	return rc;
> 1d3576fd10f0d7 Sage Weil          2009-10-06  1213  }
> 1d3576fd10f0d7 Sage Weil          2009-10-06  1214 =20
>=20
> :::::: The code at line 788 was first introduced by commit
> :::::: 1d3576fd10f0d7a104204267b81cf84a07028dad ceph: address space opera=
tions
>=20
> :::::: TO: Sage Weil <sage@newdream.net>
> :::::: CC: Sage Weil <sage@newdream.net>
>=20
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

--=20
Jeff Layton <jlayton@kernel.org>
