Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E91B04B0D43
	for <lists+ceph-devel@lfdr.de>; Thu, 10 Feb 2022 13:15:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241457AbiBJMPp (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 10 Feb 2022 07:15:45 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232947AbiBJMPo (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 10 Feb 2022 07:15:44 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1A32116D
        for <ceph-devel@vger.kernel.org>; Thu, 10 Feb 2022 04:15:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644495343; x=1676031343;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=1R+3hSpOqtC5mdMUNV0pacnGS7D3KIfzK8+gHlJa3cs=;
  b=DIDnDnQ+FV07UpXrueuipl/nHT588I92bN8bd/gRCe5nVtc1SJZEpEIi
   RaTi7RU4m3cUYhLa1W485no4sdsSCOl6iVUZtQBTgxbg8Ux2nvHZIPnNO
   DKyVt9TPntWV751XPsWVfpGquleXg84DBiLsMd+xiRLaTF+m0bXx2keoR
   14T/qz2zOpAF009qQDCfvN4OOSlGNrZa2ZYCZIrwyKPCadPpxYntscKDX
   Qi9aRwytPQBE06i542gDiGSgFut6wGDd5g2y1AhThn34K02bPBLRhtrsn
   JrPd2wMc/2Y5uAOUuF+B4N+EkD9DeE9mK2JfpH5BOX+XEXm2Lv8OrhqG2
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10253"; a="249684254"
X-IronPort-AV: E=Sophos;i="5.88,358,1635231600"; 
   d="scan'208";a="249684254"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 04:15:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,358,1635231600"; 
   d="scan'208";a="585939483"
Received: from lkp-server01.sh.intel.com (HELO d95dc2dabeb1) ([10.239.97.150])
  by fmsmga008.fm.intel.com with ESMTP; 10 Feb 2022 04:15:41 -0800
Received: from kbuild by d95dc2dabeb1 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nI8MP-0003Az-0V; Thu, 10 Feb 2022 12:15:41 +0000
Date:   Thu, 10 Feb 2022 20:14:48 +0800
From:   kernel test robot <lkp@intel.com>
To:     David Howells <dhowells@redhat.com>
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        ceph-devel@vger.kernel.org, Ilya Dryomov <idryomov@gmail.com>,
        Jeff Layton <jlayton@kernel.org>
Subject: [ceph-client:testing 6/8] fs/ceph/addr.c:788:12: warning: stack
 frame size (2352) exceeds limit (2048) in 'ceph_writepages_start'
Message-ID: <202202102053.7C17duIV-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-6.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HEXHASH_WORD,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

tree:   https://github.com/ceph/ceph-client.git testing
head:   6dc7235ee916b768b31afa12ab507874bd278573
commit: 85fc162016ac8d19e28877a15f55c0fa4b47713b [6/8] ceph: Make ceph_netf=
s_issue_op() handle inlined data
config: mips-randconfig-r014-20220209 (https://download.01.org/0day-ci/arch=
ive/20220210/202202102053.7C17duIV-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project aa845d=
7a245d85c441d0bd44fc7b6c3be8f3de8d)
reproduce (this is a W=3D1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/=
make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install mips cross compiling tool for clang build
        # apt-get install binutils-mips-linux-gnu
        # https://github.com/ceph/ceph-client/commit/85fc162016ac8d19e28877=
a15f55c0fa4b47713b
        git remote add ceph-client https://github.com/ceph/ceph-client.git
        git fetch --no-tags ceph-client testing
        git checkout 85fc162016ac8d19e28877a15f55c0fa4b47713b
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=3D$HOME/0day COMPILER=3Dclang make.cross W=3D=
1 O=3Dbuild_dir ARCH=3Dmips SHELL=3D/bin/bash fs/ceph/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> fs/ceph/addr.c:788:12: warning: stack frame size (2352) exceeds limit (2=
048) in 'ceph_writepages_start'
   static int ceph_writepages_start(struct address_space
   ^
   fatal error: error in backend: Nested variants found in inline asm strin=
g: ' .set push
   .set mips64r6
   .if ( 0x00 ) !=3D -1)) 0x00 ) !=3D -1)) : ($( static struct ftrace_branc=
h_data __attribute__((__aligned__(4))) __attribute__((__section__("_ftrace_=
branch"))) __if_trace =3D $( .func =3D __func__, .file =3D "arch/mips/inclu=
de/asm/bitops.h", .line =3D 190, $); 0x00 ) !=3D -1)) : $))) ) && ( 0 ); .s=
et push; .set mips64r6; .rept 1; sync 0x00; .endr; .set pop; .else; ; .endif
   1: lld $0, $2
   or $1, $0, $3
   scd $1, $2
   beqzc $1, 1b
   .set pop
   '
   PLEASE submit a bug report to https://github.com/llvm/llvm-project/issue=
s/ and include the crash backtrace, preprocessed source, and associated run=
 script.
   Stack dump:
   0. Program arguments: clang -Wp,-MMD,fs/ceph/.addr.o.d -nostdinc -Iarch/=
mips/include -I./arch/mips/include/generated -Iinclude -I./include -Iarch/m=
ips/include/uapi -I./arch/mips/include/generated/uapi -Iinclude/uapi -I./in=
clude/generated/uapi -include include/linux/compiler-version.h -include inc=
lude/linux/kconfig.h -include include/linux/compiler_types.h -D__KERNEL__ -=
DVMLINUX_LOAD_ADDRESS=3D0xffffffff84000000 -DLINKER_LOAD_ADDRESS=3D0xffffff=
ff84000000 -DDATAOFFSET=3D0 -Qunused-arguments -fmacro-prefix-map=3D=3D -DK=
BUILD_EXTRA_WARN1 -Wall -Wundef -Werror=3Dstrict-prototypes -Wno-trigraphs =
-fno-strict-aliasing -fno-common -fshort-wchar -fno-PIE -Werror=3Dimplicit-=
function-declaration -Werror=3Dimplicit-int -Werror=3Dreturn-type -Wno-form=
at-security -std=3Dgnu89 --target=3Dmips64-linux -fintegrated-as -Werror=3D=
unknown-warning-option -Werror=3Dignored-optimization-argument -mabi=3D64 -=
G 0 -mno-abicalls -fno-pic -pipe -msoft-float -DGAS_HAS_SET_HARDFLOAT -Wa,-=
msoft-float -ffreestanding -EB -fno-stack-check -march=3Dmips64r6 -Wa,--tra=
p -DTOOLCHAIN_SUPPORTS_VIRT -Iarch/mips/include/asm/mach-generic -Iarch/mip=
s/include/asm/mach-generic -fno-asynchronous-unwind-tables -fno-delete-null=
-pointer-checks -Wno-frame-address -Wno-address-of-packed-member -O2 -Wfram=
e-larger-than=3D2048 -fno-stack-protector -Wimplicit-fallthrough -Wno-gnu -=
mno-global-merge -Wno-unused-but-set-variable -Wno-unused-const-variable -f=
trivial-auto-var-init=3Dpattern -fno-stack-clash-protection -pg -Wdeclarati=
on-after-statement -Wvla -Wno-pointer-sign -Wcast-function-type -Wno-array-=
bounds -fno-strict-overflow -fno-stack-check -Werror=3Ddate-time -Werror=3D=
incompatible-pointer-types -Wextra -Wunused -Wno-unused-parameter -Wmissing=
-declarations -Wmissing-format-attribute -Wmissing-prototypes -Wold-style-d=
efinition -Wmissing-include-dirs -Wunused-but-set-variable -Wunused-const-v=
ariable -Wno-missing-field-initializers -Wno-sign-compare -Wno-type-limits =
-fsanitize=3Dunreachable -fsanitize=3Denum -I fs/ceph -I ./fs/ceph -DMODULE=
 -mlong-calls -DKBUILD_BASENAME=3D"addr" -DKBUILD_MODNAME=3D"ceph" -D__KBUI=
LD_MODNAME=3Dkmod_ceph -c -o fs/ceph/addr.o fs/ceph/addr.c
   1. <eof> parser at end of file
   2. Code generation
   3. Running pass 'Function Pass Manager' on module 'fs/ceph/addr.c'.
   4. Running pass 'Mips Assembly Printer' on function '@ceph_writepages_st=
art'
   #0 0x000055a535e1f68f Signals.cpp:0:0
   #1 0x000055a535e1d56c llvm::sys::CleanupOnSignal(unsigned long) (/opt/cr=
oss/clang-aa845d7a24/bin/clang-15+0x347456c)
   #2 0x000055a535d5d9e7 llvm::CrashRecoveryContext::HandleExit(int) (/opt/=
cross/clang-aa845d7a24/bin/clang-15+0x33b49e7)
   #3 0x000055a535e15c1e llvm::sys::Process::Exit(int, bool) (/opt/cross/cl=
ang-aa845d7a24/bin/clang-15+0x346cc1e)
   #4 0x000055a533a508bb (/opt/cross/clang-aa845d7a24/bin/clang-15+0x10a78b=
b)
   #5 0x000055a535d6449c llvm::report_fatal_error(llvm::Twine const&, bool)=
 (/opt/cross/clang-aa845d7a24/bin/clang-15+0x33bb49c)
   #6 0x000055a536a56000 llvm::AsmPrinter::emitInlineAsm(llvm::MachineInstr=
 const (/opt/cross/clang-aa845d7a24/bin/clang-15+0x40ad000)
   #7 0x000055a536a51f34 llvm::AsmPrinter::emitFunctionBody() (/opt/cross/c=
lang-aa845d7a24/bin/clang-15+0x40a8f34)
   #8 0x000055a5344bb1e7 llvm::MipsAsmPrinter::runOnMachineFunction(llvm::M=
achineFunction&) (/opt/cross/clang-aa845d7a24/bin/clang-15+0x1b121e7)
   #9 0x000055a535170a3d llvm::MachineFunctionPass::runOnFunction(llvm::Fun=
ction&) (.part.53) MachineFunctionPass.cpp:0:0
   #10 0x000055a5355b1757 llvm::FPPassManager::runOnFunction(llvm::Function=
&) (/opt/cross/clang-aa845d7a24/bin/clang-15+0x2c08757)
   #11 0x000055a5355b18d1 llvm::FPPassManager::runOnModule(llvm::Module&) (=
/opt/cross/clang-aa845d7a24/bin/clang-15+0x2c088d1)
   #12 0x000055a5355b244f llvm::legacy::PassManagerImpl::run(llvm::Module&)=
 (/opt/cross/clang-aa845d7a24/bin/clang-15+0x2c0944f)
   #13 0x000055a536137917 clang::EmitBackendOutput(clang::DiagnosticsEngine=
&, clang::HeaderSearchOptions const&, clang::CodeGenOptions const&, clang::=
TargetOptions const&, clang::LangOptions const&, llvm::StringRef, clang::Ba=
ckendAction, std::unique_ptr<llvm::raw_pwrite_stream, std::default_delete<l=
lvm::raw_pwrite_stream> >) (/opt/cross/clang-aa845d7a24/bin/clang-15+0x378e=
917)
   #14 0x000055a536d6f063 clang::BackendConsumer::HandleTranslationUnit(cla=
ng::ASTContext&) (/opt/cross/clang-aa845d7a24/bin/clang-15+0x43c6063)
   #15 0x000055a537845629 clang::ParseAST(clang::Sema&, bool, bool) (/opt/c=
ross/clang-aa845d7a24/bin/clang-15+0x4e9c629)
   #16 0x000055a536d6de9f clang::CodeGenAction::ExecuteAction() (/opt/cross=
/clang-aa845d7a24/bin/clang-15+0x43c4e9f)
   #17 0x000055a53676ac81 clang::FrontendAction::Execute() (/opt/cross/clan=
g-aa845d7a24/bin/clang-15+0x3dc1c81)
   #18 0x000055a536701b0a clang::CompilerInstance::ExecuteAction(clang::Fro=
ntendAction&) (/opt/cross/clang-aa845d7a24/bin/clang-15+0x3d58b0a)
   #19 0x000055a53682f59b (/opt/cross/clang-aa845d7a24/bin/clang-15+0x3e865=
9b)
   #20 0x000055a533a51e6c cc1_main(llvm::ArrayRef<char char (/opt/cross/cla=
ng-aa845d7a24/bin/clang-15+0x10a8e6c)
   #21 0x000055a533a4eb3b ExecuteCC1Tool(llvm::SmallVectorImpl<char driver.=
cpp:0:0
   #22 0x000055a536599765 void llvm::function_ref<void ()>::callback_fn<cla=
ng::driver::CC1Command::Execute(llvm::ArrayRef<llvm::Optional<llvm::StringR=
ef> >, std::__cxx11::basic_string<char, std::char_traits<char>, std::alloca=
tor<char> const::'lambda'()>(long) Job.cpp:0:0
   #23 0x000055a535d5d8a3 llvm::CrashRecoveryContext::RunSafely(llvm::funct=
ion_ref<void ()>) (/opt/cross/clang-aa845d7a24/bin/clang-15+0x33b48a3)
   #24 0x000055a53659a05e clang::driver::CC1Command::Execute(llvm::ArrayRef=
<llvm::Optional<llvm::StringRef> >, std::__cxx11::basic_string<char, std::c=
har_traits<char>, std::allocator<char> const (.part.216) Job.cpp:0:0
   #25 0x000055a53656ec57 clang::driver::Compilation::ExecuteCommand(clang:=
:driver::Command const&, clang::driver::Command const (/opt/cross/clang-aa8=
45d7a24/bin/clang-15+0x3bc5c57)
   #26 0x000055a53656f637 clang::driver::Compilation::ExecuteJobs(clang::dr=
iver::JobList const&, llvm::SmallVectorImpl<std::pair<int, clang::driver::C=
ommand >&) const (/opt/cross/clang-aa845d7a24/bin/clang-15+0x3bc6637)
   #27 0x000055a536578cc9 clang::driver::Driver::ExecuteCompilation(clang::=
driver::Compilation&, llvm::SmallVectorImpl<std::pair<int, clang::driver::C=
ommand >&) (/opt/cross/clang-aa845d7a24/bin/clang-15+0x3bcfcc9)
   #28 0x000055a53397738f main (/opt/cross/clang-aa845d7a24/bin/clang-15+0x=
fce38f)
   #29 0x00007fe35f12cd0a __libc_start_main (/lib/x86_64-linux-gnu/libc.so.=
6+0x26d0a)
   #30 0x000055a533a4e65a _start (/opt/cross/clang-aa845d7a24/bin/clang-15+=
0x10a565a)
   clang-15: error: clang frontend command failed with exit code 70 (use -v=
 to see invocation)
   clang version 15.0.0 (git://gitmirror/llvm_project aa845d7a245d85c441d0b=
d44fc7b6c3be8f3de8d)
   Target: mips64-unknown-linux
   Thread model: posix
   InstalledDir: /opt/cross/clang-aa845d7a24/bin
   clang-15: note: diagnostic msg:
   Makefile arch fs include kernel nr_bisected scripts source usr
--
>> fs/ceph/addr.c:788:12: warning: stack frame size (2352) exceeds limit (2=
048) in 'ceph_writepages_start'
   static int ceph_writepages_start(struct address_space
   ^
   fatal error: error in backend: Nested variants found in inline asm strin=
g: ' .set push
   .set mips64r6
   .if ( 0x00 ) !=3D -1)) 0x00 ) !=3D -1)) : ($( static struct ftrace_branc=
h_data __attribute__((__aligned__(4))) __attribute__((__section__("_ftrace_=
branch"))) __if_trace =3D $( .func =3D __func__, .file =3D "arch/mips/inclu=
de/asm/bitops.h", .line =3D 190, $); 0x00 ) !=3D -1)) : $))) ) && ( 0 ); .s=
et push; .set mips64r6; .rept 1; sync 0x00; .endr; .set pop; .else; ; .endif
   1: lld $0, $2
   or $1, $0, $3
   scd $1, $2
   beqzc $1, 1b
   .set pop
   '
   PLEASE submit a bug report to https://github.com/llvm/llvm-project/issue=
s/ and include the crash backtrace, preprocessed source, and associated run=
 script.
   Stack dump:
   0. Program arguments: clang -Wp,-MMD,fs/ceph/.addr.o.d -nostdinc -Iarch/=
mips/include -I./arch/mips/include/generated -Iinclude -I./include -Iarch/m=
ips/include/uapi -I./arch/mips/include/generated/uapi -Iinclude/uapi -I./in=
clude/generated/uapi -include include/linux/compiler-version.h -include inc=
lude/linux/kconfig.h -include include/linux/compiler_types.h -D__KERNEL__ -=
DVMLINUX_LOAD_ADDRESS=3D0xffffffff84000000 -DLINKER_LOAD_ADDRESS=3D0xffffff=
ff84000000 -DDATAOFFSET=3D0 -Qunused-arguments -fmacro-prefix-map=3D=3D -DK=
BUILD_EXTRA_WARN1 -Wall -Wundef -Werror=3Dstrict-prototypes -Wno-trigraphs =
-fno-strict-aliasing -fno-common -fshort-wchar -fno-PIE -Werror=3Dimplicit-=
function-declaration -Werror=3Dimplicit-int -Werror=3Dreturn-type -Wno-form=
at-security -std=3Dgnu89 --target=3Dmips64-linux -fintegrated-as -Werror=3D=
unknown-warning-option -Werror=3Dignored-optimization-argument -mabi=3D64 -=
G 0 -mno-abicalls -fno-pic -pipe -msoft-float -DGAS_HAS_SET_HARDFLOAT -Wa,-=
msoft-float -ffreestanding -EB -fno-stack-check -march=3Dmips64r6 -Wa,--tra=
p -DTOOLCHAIN_SUPPORTS_VIRT -Iarch/mips/include/asm/mach-generic -Iarch/mip=
s/include/asm/mach-generic -fno-asynchronous-unwind-tables -fno-delete-null=
-pointer-checks -Wno-frame-address -Wno-address-of-packed-member -O2 -Wfram=
e-larger-than=3D2048 -fno-stack-protector -Wimplicit-fallthrough -Wno-gnu -=
mno-global-merge -Wno-unused-but-set-variable -Wno-unused-const-variable -f=
trivial-auto-var-init=3Dpattern -fno-stack-clash-protection -pg -Wdeclarati=
on-after-statement -Wvla -Wno-pointer-sign -Wcast-function-type -Wno-array-=
bounds -fno-strict-overflow -fno-stack-check -Werror=3Ddate-time -Werror=3D=
incompatible-pointer-types -Wextra -Wunused -Wno-unused-parameter -Wmissing=
-declarations -Wmissing-format-attribute -Wmissing-prototypes -Wold-style-d=
efinition -Wmissing-include-dirs -Wunused-but-set-variable -Wunused-const-v=
ariable -Wno-missing-field-initializers -Wno-sign-compare -Wno-type-limits =
-fsanitize=3Dunreachable -fsanitize=3Denum -DMODULE -mlong-calls -DKBUILD_B=
ASENAME=3D"addr" -DKBUILD_MODNAME=3D"ceph" -D__KBUILD_MODNAME=3Dkmod_ceph -=
c -o fs/ceph/addr.o fs/ceph/addr.c
   1. <eof> parser at end of file
   2. Code generation
   3. Running pass 'Function Pass Manager' on module 'fs/ceph/addr.c'.
   4. Running pass 'Mips Assembly Printer' on function '@ceph_writepages_st=
art'
   #0 0x0000562358d5368f Signals.cpp:0:0
   #1 0x0000562358d5156c llvm::sys::CleanupOnSignal(unsigned long) (/opt/cr=
oss/clang-aa845d7a24/bin/clang-15+0x347456c)
   #2 0x0000562358c919e7 llvm::CrashRecoveryContext::HandleExit(int) (/opt/=
cross/clang-aa845d7a24/bin/clang-15+0x33b49e7)
   #3 0x0000562358d49c1e llvm::sys::Process::Exit(int, bool) (/opt/cross/cl=
ang-aa845d7a24/bin/clang-15+0x346cc1e)
   #4 0x00005623569848bb (/opt/cross/clang-aa845d7a24/bin/clang-15+0x10a78b=
b)
   #5 0x0000562358c9849c llvm::report_fatal_error(llvm::Twine const&, bool)=
 (/opt/cross/clang-aa845d7a24/bin/clang-15+0x33bb49c)
   #6 0x000056235998a000 llvm::AsmPrinter::emitInlineAsm(llvm::MachineInstr=
 const (/opt/cross/clang-aa845d7a24/bin/clang-15+0x40ad000)
   #7 0x0000562359985f34 llvm::AsmPrinter::emitFunctionBody() (/opt/cross/c=
lang-aa845d7a24/bin/clang-15+0x40a8f34)
   #8 0x00005623573ef1e7 llvm::MipsAsmPrinter::runOnMachineFunction(llvm::M=
achineFunction&) (/opt/cross/clang-aa845d7a24/bin/clang-15+0x1b121e7)
   #9 0x00005623580a4a3d llvm::MachineFunctionPass::runOnFunction(llvm::Fun=
ction&) (.part.53) MachineFunctionPass.cpp:0:0
   #10 0x00005623584e5757 llvm::FPPassManager::runOnFunction(llvm::Function=
&) (/opt/cross/clang-aa845d7a24/bin/clang-15+0x2c08757)
   #11 0x00005623584e58d1 llvm::FPPassManager::runOnModule(llvm::Module&) (=
/opt/cross/clang-aa845d7a24/bin/clang-15+0x2c088d1)
   #12 0x00005623584e644f llvm::legacy::PassManagerImpl::run(llvm::Module&)=
 (/opt/cross/clang-aa845d7a24/bin/clang-15+0x2c0944f)
   #13 0x000056235906b917 clang::EmitBackendOutput(clang::DiagnosticsEngine=
&, clang::HeaderSearchOptions const&, clang::CodeGenOptions const&, clang::=
TargetOptions const&, clang::LangOptions const&, llvm::StringRef, clang::Ba=
ckendAction, std::unique_ptr<llvm::raw_pwrite_stream, std::default_delete<l=
lvm::raw_pwrite_stream> >) (/opt/cross/clang-aa845d7a24/bin/clang-15+0x378e=
917)
   #14 0x0000562359ca3063 clang::BackendConsumer::HandleTranslationUnit(cla=
ng::ASTContext&) (/opt/cross/clang-aa845d7a24/bin/clang-15+0x43c6063)
   #15 0x000056235a779629 clang::ParseAST(clang::Sema&, bool, bool) (/opt/c=
ross/clang-aa845d7a24/bin/clang-15+0x4e9c629)
   #16 0x0000562359ca1e9f clang::CodeGenAction::ExecuteAction() (/opt/cross=
/clang-aa845d7a24/bin/clang-15+0x43c4e9f)
   #17 0x000056235969ec81 clang::FrontendAction::Execute() (/opt/cross/clan=
g-aa845d7a24/bin/clang-15+0x3dc1c81)
   #18 0x0000562359635b0a clang::CompilerInstance::ExecuteAction(clang::Fro=
ntendAction&) (/opt/cross/clang-aa845d7a24/bin/clang-15+0x3d58b0a)
   #19 0x000056235976359b (/opt/cross/clang-aa845d7a24/bin/clang-15+0x3e865=
9b)
   #20 0x0000562356985e6c cc1_main(llvm::ArrayRef<char char (/opt/cross/cla=
ng-aa845d7a24/bin/clang-15+0x10a8e6c)
   #21 0x0000562356982b3b ExecuteCC1Tool(llvm::SmallVectorImpl<char driver.=
cpp:0:0
   #22 0x00005623594cd765 void llvm::function_ref<void ()>::callback_fn<cla=
ng::driver::CC1Command::Execute(llvm::ArrayRef<llvm::Optional<llvm::StringR=
ef> >, std::__cxx11::basic_string<char, std::char_traits<char>, std::alloca=
tor<char> const::'lambda'()>(long) Job.cpp:0:0
   #23 0x0000562358c918a3 llvm::CrashRecoveryContext::RunSafely(llvm::funct=
ion_ref<void ()>) (/opt/cross/clang-aa845d7a24/bin/clang-15+0x33b48a3)
   #24 0x00005623594ce05e clang::driver::CC1Command::Execute(llvm::ArrayRef=
<llvm::Optional<llvm::StringRef> >, std::__cxx11::basic_string<char, std::c=
har_traits<char>, std::allocator<char> const (.part.216) Job.cpp:0:0
   #25 0x00005623594a2c57 clang::driver::Compilation::ExecuteCommand(clang:=
:driver::Command const&, clang::driver::Command const (/opt/cross/clang-aa8=
45d7a24/bin/clang-15+0x3bc5c57)
   #26 0x00005623594a3637 clang::driver::Compilation::ExecuteJobs(clang::dr=
iver::JobList const&, llvm::SmallVectorImpl<std::pair<int, clang::driver::C=
ommand >&) const (/opt/cross/clang-aa845d7a24/bin/clang-15+0x3bc6637)
   #27 0x00005623594accc9 clang::driver::Driver::ExecuteCompilation(clang::=
driver::Compilation&, llvm::SmallVectorImpl<std::pair<int, clang::driver::C=
ommand >&) (/opt/cross/clang-aa845d7a24/bin/clang-15+0x3bcfcc9)
   #28 0x00005623568ab38f main (/opt/cross/clang-aa845d7a24/bin/clang-15+0x=
fce38f)
   #29 0x00007f845ced9d0a __libc_start_main (/lib/x86_64-linux-gnu/libc.so.=
6+0x26d0a)
   #30 0x000056235698265a _start (/opt/cross/clang-aa845d7a24/bin/clang-15+=
0x10a565a)
   clang-15: error: clang frontend command failed with exit code 70 (use -v=
 to see invocation)
   clang version 15.0.0 (git://gitmirror/llvm_project aa845d7a245d85c441d0b=
d44fc7b6c3be8f3de8d)
   Target: mips64-unknown-linux
   Thread model: posix
   InstalledDir: /opt/cross/clang-aa845d7a24/bin
   clang-15: note: diagnostic msg:
   Makefile arch fs include kernel nr_bisected scripts source usr


vim +/ceph_writepages_start +788 fs/ceph/addr.c

1d3576fd10f0d7 Sage Weil          2009-10-06   784 =20
1d3576fd10f0d7 Sage Weil          2009-10-06   785  /*
1d3576fd10f0d7 Sage Weil          2009-10-06   786   * initiate async write=
back
1d3576fd10f0d7 Sage Weil          2009-10-06   787   */
1d3576fd10f0d7 Sage Weil          2009-10-06  @788  static int ceph_writepa=
ges_start(struct address_space *mapping,
1d3576fd10f0d7 Sage Weil          2009-10-06   789  				 struct writeback_c=
ontrol *wbc)
1d3576fd10f0d7 Sage Weil          2009-10-06   790  {
1d3576fd10f0d7 Sage Weil          2009-10-06   791  	struct inode *inode =
=3D mapping->host;
1d3576fd10f0d7 Sage Weil          2009-10-06   792  	struct ceph_inode_info=
 *ci =3D ceph_inode(inode);
fc2744aa12da71 Yan, Zheng         2013-05-31   793  	struct ceph_fs_client =
*fsc =3D ceph_inode_to_client(inode);
fc2744aa12da71 Yan, Zheng         2013-05-31   794  	struct ceph_vino vino =
=3D ceph_vino(inode);
2a2d927e35dd8d Yan, Zheng         2017-09-01   795  	pgoff_t index, start_i=
ndex, end =3D -1;
80e755fedebc8d Sage Weil          2010-03-31   796  	struct ceph_snap_conte=
xt *snapc =3D NULL, *last_snapc =3D NULL, *pgsnapc;
1d3576fd10f0d7 Sage Weil          2009-10-06   797  	struct pagevec pvec;
1d3576fd10f0d7 Sage Weil          2009-10-06   798  	int rc =3D 0;
93407472a21b82 Fabian Frederick   2017-02-27   799  	unsigned int wsize =3D=
 i_blocksize(inode);
1d3576fd10f0d7 Sage Weil          2009-10-06   800  	struct ceph_osd_reques=
t *req =3D NULL;
1f934b00e90752 Yan, Zheng         2017-08-30   801  	struct ceph_writeback_=
ctl ceph_wbc;
590e9d9861f5f2 Yan, Zheng         2017-09-03   802  	bool should_loop, rang=
e_whole =3D false;
af9cc401ce7452 Yan, Zheng         2018-03-04   803  	bool done =3D false;
1702e79734104d Jeff Layton        2021-12-07   804  	bool caching =3D ceph_=
is_cache_enabled(inode);
1d3576fd10f0d7 Sage Weil          2009-10-06   805 =20
3fb99d483e614b Yanhu Cao          2017-07-21   806  	dout("writepages_start=
 %p (mode=3D%s)\n", inode,
1d3576fd10f0d7 Sage Weil          2009-10-06   807  	     wbc->sync_mode =
=3D=3D WB_SYNC_NONE ? "NONE" :
1d3576fd10f0d7 Sage Weil          2009-10-06   808  	     (wbc->sync_mode =
=3D=3D WB_SYNC_ALL ? "ALL" : "HOLD"));
1d3576fd10f0d7 Sage Weil          2009-10-06   809 =20
5d6451b1489ad1 Jeff Layton        2021-08-31   810  	if (ceph_inode_is_shut=
down(inode)) {
6c93df5db628e7 Yan, Zheng         2016-04-15   811  		if (ci->i_wrbuffer_re=
f > 0) {
6c93df5db628e7 Yan, Zheng         2016-04-15   812  			pr_warn_ratelimited(
6c93df5db628e7 Yan, Zheng         2016-04-15   813  				"writepage_start %p=
 %lld forced umount\n",
6c93df5db628e7 Yan, Zheng         2016-04-15   814  				inode, ceph_ino(ino=
de));
6c93df5db628e7 Yan, Zheng         2016-04-15   815  		}
a341d4df87487a Yan, Zheng         2015-07-01   816  		mapping_set_error(map=
ping, -EIO);
1d3576fd10f0d7 Sage Weil          2009-10-06   817  		return -EIO; /* we're=
 in a forced umount, don't write! */
1d3576fd10f0d7 Sage Weil          2009-10-06   818  	}
95cca2b44e54b0 Yan, Zheng         2017-07-11   819  	if (fsc->mount_options=
->wsize < wsize)
3d14c5d2b6e15c Yehuda Sadeh       2010-04-06   820  		wsize =3D fsc->mount_=
options->wsize;
1d3576fd10f0d7 Sage Weil          2009-10-06   821 =20
8667982014d604 Mel Gorman         2017-11-15   822  	pagevec_init(&pvec);
1d3576fd10f0d7 Sage Weil          2009-10-06   823 =20
590e9d9861f5f2 Yan, Zheng         2017-09-03   824  	start_index =3D wbc->r=
ange_cyclic ? mapping->writeback_index : 0;
590e9d9861f5f2 Yan, Zheng         2017-09-03   825  	index =3D start_index;
1d3576fd10f0d7 Sage Weil          2009-10-06   826 =20
1d3576fd10f0d7 Sage Weil          2009-10-06   827  retry:
1d3576fd10f0d7 Sage Weil          2009-10-06   828  	/* find oldest snap co=
ntext with dirty data */
05455e1177f768 Yan, Zheng         2017-09-02   829  	snapc =3D get_oldest_c=
ontext(inode, &ceph_wbc, NULL);
1d3576fd10f0d7 Sage Weil          2009-10-06   830  	if (!snapc) {
1d3576fd10f0d7 Sage Weil          2009-10-06   831  		/* hmm, why does writ=
epages get called when there
1d3576fd10f0d7 Sage Weil          2009-10-06   832  		   is no dirty data? =
*/
1d3576fd10f0d7 Sage Weil          2009-10-06   833  		dout(" no snap contex=
t with dirty data?\n");
1d3576fd10f0d7 Sage Weil          2009-10-06   834  		goto out;
1d3576fd10f0d7 Sage Weil          2009-10-06   835  	}
1d3576fd10f0d7 Sage Weil          2009-10-06   836  	dout(" oldest snapc is=
 %p seq %lld (%d snaps)\n",
1d3576fd10f0d7 Sage Weil          2009-10-06   837  	     snapc, snapc->seq=
, snapc->num_snaps);
fc2744aa12da71 Yan, Zheng         2013-05-31   838 =20
2a2d927e35dd8d Yan, Zheng         2017-09-01   839  	should_loop =3D false;
2a2d927e35dd8d Yan, Zheng         2017-09-01   840  	if (ceph_wbc.head_snap=
c && snapc !=3D last_snapc) {
2a2d927e35dd8d Yan, Zheng         2017-09-01   841  		/* where to start/end=
? */
2a2d927e35dd8d Yan, Zheng         2017-09-01   842  		if (wbc->range_cyclic=
) {
2a2d927e35dd8d Yan, Zheng         2017-09-01   843  			index =3D start_inde=
x;
2a2d927e35dd8d Yan, Zheng         2017-09-01   844  			end =3D -1;
2a2d927e35dd8d Yan, Zheng         2017-09-01   845  			if (index > 0)
2a2d927e35dd8d Yan, Zheng         2017-09-01   846  				should_loop =3D tru=
e;
2a2d927e35dd8d Yan, Zheng         2017-09-01   847  			dout(" cyclic, start=
 at %lu\n", index);
2a2d927e35dd8d Yan, Zheng         2017-09-01   848  		} else {
2a2d927e35dd8d Yan, Zheng         2017-09-01   849  			index =3D wbc->range=
_start >> PAGE_SHIFT;
2a2d927e35dd8d Yan, Zheng         2017-09-01   850  			end =3D wbc->range_e=
nd >> PAGE_SHIFT;
2a2d927e35dd8d Yan, Zheng         2017-09-01   851  			if (wbc->range_start=
 =3D=3D 0 && wbc->range_end =3D=3D LLONG_MAX)
2a2d927e35dd8d Yan, Zheng         2017-09-01   852  				range_whole =3D tru=
e;
2a2d927e35dd8d Yan, Zheng         2017-09-01   853  			dout(" not cyclic, %=
lu to %lu\n", index, end);
2a2d927e35dd8d Yan, Zheng         2017-09-01   854  		}
2a2d927e35dd8d Yan, Zheng         2017-09-01   855  	} else if (!ceph_wbc.h=
ead_snapc) {
2a2d927e35dd8d Yan, Zheng         2017-09-01   856  		/* Do not respect wbc=
->range_{start,end}. Dirty pages
2a2d927e35dd8d Yan, Zheng         2017-09-01   857  		 * in that range can =
be associated with newer snapc.
2a2d927e35dd8d Yan, Zheng         2017-09-01   858  		 * They are not write=
able until we write all dirty pages
2a2d927e35dd8d Yan, Zheng         2017-09-01   859  		 * associated with 's=
napc' get written */
1582af2eaaf17c Yan, Zheng         2018-03-06   860  		if (index > 0)
2a2d927e35dd8d Yan, Zheng         2017-09-01   861  			should_loop =3D true;
2a2d927e35dd8d Yan, Zheng         2017-09-01   862  		dout(" non-head snapc=
, range whole\n");
1d3576fd10f0d7 Sage Weil          2009-10-06   863  	}
2a2d927e35dd8d Yan, Zheng         2017-09-01   864 =20
2a2d927e35dd8d Yan, Zheng         2017-09-01   865  	ceph_put_snap_context(=
last_snapc);
1d3576fd10f0d7 Sage Weil          2009-10-06   866  	last_snapc =3D snapc;
1d3576fd10f0d7 Sage Weil          2009-10-06   867 =20
af9cc401ce7452 Yan, Zheng         2018-03-04   868  	while (!done && index =
<=3D end) {
5b64640cf65be4 Yan, Zheng         2016-01-07   869  		int num_ops =3D 0, op=
_idx;
0e5ecac7168366 Yan, Zheng         2017-08-31   870  		unsigned i, pvec_page=
s, max_pages, locked_pages =3D 0;
5b64640cf65be4 Yan, Zheng         2016-01-07   871  		struct page **pages =
=3D NULL, **data_pages;
1d3576fd10f0d7 Sage Weil          2009-10-06   872  		struct page *page;
0e5ecac7168366 Yan, Zheng         2017-08-31   873  		pgoff_t strip_unit_en=
d =3D 0;
5b64640cf65be4 Yan, Zheng         2016-01-07   874  		u64 offset =3D 0, len=
 =3D 0;
a0102bda5bc099 Jeff Layton        2020-07-30   875  		bool from_pool =3D fa=
lse;
1d3576fd10f0d7 Sage Weil          2009-10-06   876 =20
0e5ecac7168366 Yan, Zheng         2017-08-31   877  		max_pages =3D wsize >=
> PAGE_SHIFT;
1d3576fd10f0d7 Sage Weil          2009-10-06   878 =20
1d3576fd10f0d7 Sage Weil          2009-10-06   879  get_more_pages:
2e169296603470 Jeff Layton        2020-09-14   880  		pvec_pages =3D pageve=
c_lookup_range_tag(&pvec, mapping, &index,
2e169296603470 Jeff Layton        2020-09-14   881  						end, PAGECACHE_TA=
G_DIRTY);
0ed75fc8d288f4 Jan Kara           2017-11-15   882  		dout("pagevec_lookup_=
range_tag got %d\n", pvec_pages);
1d3576fd10f0d7 Sage Weil          2009-10-06   883  		if (!pvec_pages && !l=
ocked_pages)
1d3576fd10f0d7 Sage Weil          2009-10-06   884  			break;
1d3576fd10f0d7 Sage Weil          2009-10-06   885  		for (i =3D 0; i < pve=
c_pages && locked_pages < max_pages; i++) {
1d3576fd10f0d7 Sage Weil          2009-10-06   886  			page =3D pvec.pages[=
i];
1d3576fd10f0d7 Sage Weil          2009-10-06   887  			dout("? %p idx %lu\n=
", page, page->index);
1d3576fd10f0d7 Sage Weil          2009-10-06   888  			if (locked_pages =3D=
=3D 0)
1d3576fd10f0d7 Sage Weil          2009-10-06   889  				lock_page(page);  /=
* first page */
1d3576fd10f0d7 Sage Weil          2009-10-06   890  			else if (!trylock_pa=
ge(page))
1d3576fd10f0d7 Sage Weil          2009-10-06   891  				break;
1d3576fd10f0d7 Sage Weil          2009-10-06   892 =20
1d3576fd10f0d7 Sage Weil          2009-10-06   893  			/* only dirty pages,=
 or our accounting breaks */
1d3576fd10f0d7 Sage Weil          2009-10-06   894  			if (unlikely(!PageDi=
rty(page)) ||
1d3576fd10f0d7 Sage Weil          2009-10-06   895  			    unlikely(page->m=
apping !=3D mapping)) {
1d3576fd10f0d7 Sage Weil          2009-10-06   896  				dout("!dirty or !ma=
pping %p\n", page);
1d3576fd10f0d7 Sage Weil          2009-10-06   897  				unlock_page(page);
0713e5f24b7deb Yan, Zheng         2017-08-31   898  				continue;
1d3576fd10f0d7 Sage Weil          2009-10-06   899  			}
af9cc401ce7452 Yan, Zheng         2018-03-04   900  			/* only if matching =
snap context */
af9cc401ce7452 Yan, Zheng         2018-03-04   901  			pgsnapc =3D page_sna=
p_context(page);
af9cc401ce7452 Yan, Zheng         2018-03-04   902  			if (pgsnapc !=3D sna=
pc) {
af9cc401ce7452 Yan, Zheng         2018-03-04   903  				dout("page snapc %p=
 %lld !=3D oldest %p %lld\n",
af9cc401ce7452 Yan, Zheng         2018-03-04   904  				     pgsnapc, pgsna=
pc->seq, snapc, snapc->seq);
1582af2eaaf17c Yan, Zheng         2018-03-06   905  				if (!should_loop &&
1582af2eaaf17c Yan, Zheng         2018-03-06   906  				    !ceph_wbc.head_=
snapc &&
1582af2eaaf17c Yan, Zheng         2018-03-06   907  				    wbc->sync_mode =
!=3D WB_SYNC_NONE)
1582af2eaaf17c Yan, Zheng         2018-03-06   908  					should_loop =3D tr=
ue;
1d3576fd10f0d7 Sage Weil          2009-10-06   909  				unlock_page(page);
af9cc401ce7452 Yan, Zheng         2018-03-04   910  				continue;
1d3576fd10f0d7 Sage Weil          2009-10-06   911  			}
1f934b00e90752 Yan, Zheng         2017-08-30   912  			if (page_offset(page=
) >=3D ceph_wbc.i_size) {
1f934b00e90752 Yan, Zheng         2017-08-30   913  				dout("%p page eof %=
llu\n",
1f934b00e90752 Yan, Zheng         2017-08-30   914  				     page, ceph_wbc=
=2Ei_size);
c95f1c5f436bad Erqi Chen          2019-07-24   915  				if ((ceph_wbc.size_=
stable ||
c95f1c5f436bad Erqi Chen          2019-07-24   916  				    page_offset(pag=
e) >=3D i_size_read(inode)) &&
c95f1c5f436bad Erqi Chen          2019-07-24   917  				    clear_page_dirt=
y_for_io(page))
af9cc401ce7452 Yan, Zheng         2018-03-04   918  					mapping->a_ops->in=
validatepage(page,
8ff2d290c8ce77 Jeff Layton        2021-04-05   919  								0, thp_size(pag=
e));
af9cc401ce7452 Yan, Zheng         2018-03-04   920  				unlock_page(page);
af9cc401ce7452 Yan, Zheng         2018-03-04   921  				continue;
af9cc401ce7452 Yan, Zheng         2018-03-04   922  			}
af9cc401ce7452 Yan, Zheng         2018-03-04   923  			if (strip_unit_end &=
& (page->index > strip_unit_end)) {
af9cc401ce7452 Yan, Zheng         2018-03-04   924  				dout("end of strip =
unit %p\n", page);
1d3576fd10f0d7 Sage Weil          2009-10-06   925  				unlock_page(page);
1d3576fd10f0d7 Sage Weil          2009-10-06   926  				break;
1d3576fd10f0d7 Sage Weil          2009-10-06   927  			}
1702e79734104d Jeff Layton        2021-12-07   928  			if (PageWriteback(pa=
ge) || PageFsCache(page)) {
0713e5f24b7deb Yan, Zheng         2017-08-31   929  				if (wbc->sync_mode =
=3D=3D WB_SYNC_NONE) {
1d3576fd10f0d7 Sage Weil          2009-10-06   930  					dout("%p under wri=
teback\n", page);
1d3576fd10f0d7 Sage Weil          2009-10-06   931  					unlock_page(page);
0713e5f24b7deb Yan, Zheng         2017-08-31   932  					continue;
0713e5f24b7deb Yan, Zheng         2017-08-31   933  				}
0713e5f24b7deb Yan, Zheng         2017-08-31   934  				dout("waiting on wr=
iteback %p\n", page);
0713e5f24b7deb Yan, Zheng         2017-08-31   935  				wait_on_page_writeb=
ack(page);
1702e79734104d Jeff Layton        2021-12-07   936  				wait_on_page_fscach=
e(page);
1d3576fd10f0d7 Sage Weil          2009-10-06   937  			}
1d3576fd10f0d7 Sage Weil          2009-10-06   938 =20
1d3576fd10f0d7 Sage Weil          2009-10-06   939  			if (!clear_page_dirt=
y_for_io(page)) {
1d3576fd10f0d7 Sage Weil          2009-10-06   940  				dout("%p !clear_pag=
e_dirty_for_io\n", page);
1d3576fd10f0d7 Sage Weil          2009-10-06   941  				unlock_page(page);
0713e5f24b7deb Yan, Zheng         2017-08-31   942  				continue;
1d3576fd10f0d7 Sage Weil          2009-10-06   943  			}
1d3576fd10f0d7 Sage Weil          2009-10-06   944 =20
e5975c7c8eb6ae Alex Elder         2013-03-14   945  			/*
e5975c7c8eb6ae Alex Elder         2013-03-14   946  			 * We have something=
 to write.  If this is
e5975c7c8eb6ae Alex Elder         2013-03-14   947  			 * the first locked =
page this time through,
5b64640cf65be4 Yan, Zheng         2016-01-07   948  			 * calculate max pos=
sinle write size and
5b64640cf65be4 Yan, Zheng         2016-01-07   949  			 * allocate a page a=
rray
e5975c7c8eb6ae Alex Elder         2013-03-14   950  			 */
1d3576fd10f0d7 Sage Weil          2009-10-06   951  			if (locked_pages =3D=
=3D 0) {
5b64640cf65be4 Yan, Zheng         2016-01-07   952  				u64 objnum;
5b64640cf65be4 Yan, Zheng         2016-01-07   953  				u64 objoff;
dccbf08005df80 Ilya Dryomov       2018-02-17   954  				u32 xlen;
5b64640cf65be4 Yan, Zheng         2016-01-07   955 =20
1d3576fd10f0d7 Sage Weil          2009-10-06   956  				/* prepare async wr=
ite request */
6285bc23127741 Alex Elder         2012-10-02   957  				offset =3D (u64)pag=
e_offset(page);
dccbf08005df80 Ilya Dryomov       2018-02-17   958  				ceph_calc_file_obje=
ct_mapping(&ci->i_layout,
dccbf08005df80 Ilya Dryomov       2018-02-17   959  							      offset, ws=
ize,
5b64640cf65be4 Yan, Zheng         2016-01-07   960  							      &objnum, &=
objoff,
dccbf08005df80 Ilya Dryomov       2018-02-17   961  							      &xlen);
dccbf08005df80 Ilya Dryomov       2018-02-17   962  				len =3D xlen;
8c71897be2ddfd Henry C Chang      2011-05-03   963 =20
3fb99d483e614b Yanhu Cao          2017-07-21   964  				num_ops =3D 1;
5b64640cf65be4 Yan, Zheng         2016-01-07   965  				strip_unit_end =3D =
page->index +
09cbfeaf1a5a67 Kirill A. Shutemov 2016-04-01   966  					((len - 1) >> PAGE=
_SHIFT);
88486957f9fbf5 Alex Elder         2013-03-14   967 =20
5b64640cf65be4 Yan, Zheng         2016-01-07   968  				BUG_ON(pages);
88486957f9fbf5 Alex Elder         2013-03-14   969  				max_pages =3D calc_=
pages_for(0, (u64)len);
6da2ec56059c3c Kees Cook          2018-06-12   970  				pages =3D kmalloc_a=
rray(max_pages,
6da2ec56059c3c Kees Cook          2018-06-12   971  						      sizeof(*pag=
es),
fc2744aa12da71 Yan, Zheng         2013-05-31   972  						      GFP_NOFS);
88486957f9fbf5 Alex Elder         2013-03-14   973  				if (!pages) {
a0102bda5bc099 Jeff Layton        2020-07-30   974  					from_pool =3D true;
a0102bda5bc099 Jeff Layton        2020-07-30   975  					pages =3D mempool_=
alloc(ceph_wb_pagevec_pool, GFP_NOFS);
e5975c7c8eb6ae Alex Elder         2013-03-14   976  					BUG_ON(!pages);
88486957f9fbf5 Alex Elder         2013-03-14   977  				}
5b64640cf65be4 Yan, Zheng         2016-01-07   978 =20
5b64640cf65be4 Yan, Zheng         2016-01-07   979  				len =3D 0;
5b64640cf65be4 Yan, Zheng         2016-01-07   980  			} else if (page->ind=
ex !=3D
09cbfeaf1a5a67 Kirill A. Shutemov 2016-04-01   981  				   (offset + len) >=
> PAGE_SHIFT) {
a0102bda5bc099 Jeff Layton        2020-07-30   982  				if (num_ops >=3D (f=
rom_pool ?  CEPH_OSD_SLAB_OPS :
5b64640cf65be4 Yan, Zheng         2016-01-07   983  							     CEPH_OSD_MA=
X_OPS)) {
5b64640cf65be4 Yan, Zheng         2016-01-07   984  					redirty_page_for_w=
ritepage(wbc, page);
5b64640cf65be4 Yan, Zheng         2016-01-07   985  					unlock_page(page);
5b64640cf65be4 Yan, Zheng         2016-01-07   986  					break;
5b64640cf65be4 Yan, Zheng         2016-01-07   987  				}
5b64640cf65be4 Yan, Zheng         2016-01-07   988 =20
5b64640cf65be4 Yan, Zheng         2016-01-07   989  				num_ops++;
5b64640cf65be4 Yan, Zheng         2016-01-07   990  				offset =3D (u64)pag=
e_offset(page);
5b64640cf65be4 Yan, Zheng         2016-01-07   991  				len =3D 0;
1d3576fd10f0d7 Sage Weil          2009-10-06   992  			}
1d3576fd10f0d7 Sage Weil          2009-10-06   993 =20
1d3576fd10f0d7 Sage Weil          2009-10-06   994  			/* note position of =
first page in pvec */
1d3576fd10f0d7 Sage Weil          2009-10-06   995  			dout("%p will write =
page %p idx %lu\n",
1d3576fd10f0d7 Sage Weil          2009-10-06   996  			     inode, page, pa=
ge->index);
2baba25019ec56 Yehuda Sadeh       2009-12-18   997 =20
5b64640cf65be4 Yan, Zheng         2016-01-07   998  			if (atomic_long_inc_=
return(&fsc->writeback_count) >
5b64640cf65be4 Yan, Zheng         2016-01-07   999  			    CONGESTION_ON_TH=
RESH(
3d14c5d2b6e15c Yehuda Sadeh       2010-04-06  1000  				    fsc->mount_opti=
ons->congestion_kb)) {
09dc9fc24ba714 Jan Kara           2017-04-12  1001  				set_bdi_congested(i=
node_to_bdi(inode),
213c99ee0cf17f Sage Weil          2010-08-03  1002  						  BLK_RW_ASYNC);
2baba25019ec56 Yehuda Sadeh       2009-12-18  1003  			}
2baba25019ec56 Yehuda Sadeh       2009-12-18  1004 =20
0713e5f24b7deb Yan, Zheng         2017-08-31  1005 =20
0713e5f24b7deb Yan, Zheng         2017-08-31  1006  			pages[locked_pages++=
] =3D page;
0713e5f24b7deb Yan, Zheng         2017-08-31  1007  			pvec.pages[i] =3D NU=
LL;
0713e5f24b7deb Yan, Zheng         2017-08-31  1008 =20
8ff2d290c8ce77 Jeff Layton        2021-04-05  1009  			len +=3D thp_size(pa=
ge);
1d3576fd10f0d7 Sage Weil          2009-10-06  1010  		}
1d3576fd10f0d7 Sage Weil          2009-10-06  1011 =20
1d3576fd10f0d7 Sage Weil          2009-10-06  1012  		/* did we get anythin=
g? */
1d3576fd10f0d7 Sage Weil          2009-10-06  1013  		if (!locked_pages)
1d3576fd10f0d7 Sage Weil          2009-10-06  1014  			goto release_pvec_pa=
ges;
1d3576fd10f0d7 Sage Weil          2009-10-06  1015  		if (i) {
0713e5f24b7deb Yan, Zheng         2017-08-31  1016  			unsigned j, n =3D 0;
0713e5f24b7deb Yan, Zheng         2017-08-31  1017  			/* shift unused page=
 to beginning of pvec */
0713e5f24b7deb Yan, Zheng         2017-08-31  1018  			for (j =3D 0; j < pv=
ec_pages; j++) {
0713e5f24b7deb Yan, Zheng         2017-08-31  1019  				if (!pvec.pages[j])
0713e5f24b7deb Yan, Zheng         2017-08-31  1020  					continue;
0713e5f24b7deb Yan, Zheng         2017-08-31  1021  				if (n < j)
0713e5f24b7deb Yan, Zheng         2017-08-31  1022  					pvec.pages[n] =3D =
pvec.pages[j];
0713e5f24b7deb Yan, Zheng         2017-08-31  1023  				n++;
0713e5f24b7deb Yan, Zheng         2017-08-31  1024  			}
0713e5f24b7deb Yan, Zheng         2017-08-31  1025  			pvec.nr =3D n;
1d3576fd10f0d7 Sage Weil          2009-10-06  1026 =20
1d3576fd10f0d7 Sage Weil          2009-10-06  1027  			if (pvec_pages && i =
=3D=3D pvec_pages &&
1d3576fd10f0d7 Sage Weil          2009-10-06  1028  			    locked_pages < m=
ax_pages) {
1d3576fd10f0d7 Sage Weil          2009-10-06  1029  				dout("reached end p=
vec, trying for more\n");
0713e5f24b7deb Yan, Zheng         2017-08-31  1030  				pagevec_release(&pv=
ec);
1d3576fd10f0d7 Sage Weil          2009-10-06  1031  				goto get_more_pages;
1d3576fd10f0d7 Sage Weil          2009-10-06  1032  			}
1d3576fd10f0d7 Sage Weil          2009-10-06  1033  		}
1d3576fd10f0d7 Sage Weil          2009-10-06  1034 =20
5b64640cf65be4 Yan, Zheng         2016-01-07  1035  new_request:
e5975c7c8eb6ae Alex Elder         2013-03-14  1036  		offset =3D page_offse=
t(pages[0]);
5b64640cf65be4 Yan, Zheng         2016-01-07  1037  		len =3D wsize;
5b64640cf65be4 Yan, Zheng         2016-01-07  1038 =20
5b64640cf65be4 Yan, Zheng         2016-01-07  1039  		req =3D ceph_osdc_new=
_request(&fsc->client->osdc,
5b64640cf65be4 Yan, Zheng         2016-01-07  1040  					&ci->i_layout, vin=
o,
5b64640cf65be4 Yan, Zheng         2016-01-07  1041  					offset, &len, 0, n=
um_ops,
1f934b00e90752 Yan, Zheng         2017-08-30  1042  					CEPH_OSD_OP_WRITE,=
 CEPH_OSD_FLAG_WRITE,
1f934b00e90752 Yan, Zheng         2017-08-30  1043  					snapc, ceph_wbc.tr=
uncate_seq,
1f934b00e90752 Yan, Zheng         2017-08-30  1044  					ceph_wbc.truncate_=
size, false);
5b64640cf65be4 Yan, Zheng         2016-01-07  1045  		if (IS_ERR(req)) {
5b64640cf65be4 Yan, Zheng         2016-01-07  1046  			req =3D ceph_osdc_ne=
w_request(&fsc->client->osdc,
5b64640cf65be4 Yan, Zheng         2016-01-07  1047  						&ci->i_layout, vi=
no,
5b64640cf65be4 Yan, Zheng         2016-01-07  1048  						offset, &len, 0,
5b64640cf65be4 Yan, Zheng         2016-01-07  1049  						min(num_ops,
5b64640cf65be4 Yan, Zheng         2016-01-07  1050  						    CEPH_OSD_SLAB=
_OPS),
5b64640cf65be4 Yan, Zheng         2016-01-07  1051  						CEPH_OSD_OP_WRITE,
54ea0046b6fe36 Ilya Dryomov       2017-02-11  1052  						CEPH_OSD_FLAG_WRI=
TE,
1f934b00e90752 Yan, Zheng         2017-08-30  1053  						snapc, ceph_wbc.t=
runcate_seq,
1f934b00e90752 Yan, Zheng         2017-08-30  1054  						ceph_wbc.truncate=
_size, true);
5b64640cf65be4 Yan, Zheng         2016-01-07  1055  			BUG_ON(IS_ERR(req));
5b64640cf65be4 Yan, Zheng         2016-01-07  1056  		}
5b64640cf65be4 Yan, Zheng         2016-01-07  1057  		BUG_ON(len < page_off=
set(pages[locked_pages - 1]) +
8ff2d290c8ce77 Jeff Layton        2021-04-05  1058  			     thp_size(page) =
- offset);
5b64640cf65be4 Yan, Zheng         2016-01-07  1059 =20
5b64640cf65be4 Yan, Zheng         2016-01-07  1060  		req->r_callback =3D w=
ritepages_finish;
5b64640cf65be4 Yan, Zheng         2016-01-07  1061  		req->r_inode =3D inod=
e;
5b64640cf65be4 Yan, Zheng         2016-01-07  1062 =20
5b64640cf65be4 Yan, Zheng         2016-01-07  1063  		/* Format the osd req=
uest message and submit the write */
5b64640cf65be4 Yan, Zheng         2016-01-07  1064  		len =3D 0;
5b64640cf65be4 Yan, Zheng         2016-01-07  1065  		data_pages =3D pages;
5b64640cf65be4 Yan, Zheng         2016-01-07  1066  		op_idx =3D 0;
5b64640cf65be4 Yan, Zheng         2016-01-07  1067  		for (i =3D 0; i < loc=
ked_pages; i++) {
5b64640cf65be4 Yan, Zheng         2016-01-07  1068  			u64 cur_offset =3D p=
age_offset(pages[i]);
1702e79734104d Jeff Layton        2021-12-07  1069  			/*
1702e79734104d Jeff Layton        2021-12-07  1070  			 * Discontinuity in =
page range? Ceph can handle that by just passing
1702e79734104d Jeff Layton        2021-12-07  1071  			 * multiple extents =
in the write op.
1702e79734104d Jeff Layton        2021-12-07  1072  			 */
5b64640cf65be4 Yan, Zheng         2016-01-07  1073  			if (offset + len !=
=3D cur_offset) {
1702e79734104d Jeff Layton        2021-12-07  1074  				/* If it's full, st=
op here */
3fb99d483e614b Yanhu Cao          2017-07-21  1075  				if (op_idx + 1 =3D=
=3D req->r_num_ops)
5b64640cf65be4 Yan, Zheng         2016-01-07  1076  					break;
1702e79734104d Jeff Layton        2021-12-07  1077 =20
1702e79734104d Jeff Layton        2021-12-07  1078  				/* Kick off an fsca=
che write with what we have so far. */
1702e79734104d Jeff Layton        2021-12-07  1079  				ceph_fscache_write_=
to_cache(inode, offset, len, caching);
1702e79734104d Jeff Layton        2021-12-07  1080 =20
1702e79734104d Jeff Layton        2021-12-07  1081  				/* Start a new exte=
nt */
5b64640cf65be4 Yan, Zheng         2016-01-07  1082  				osd_req_op_extent_d=
up_last(req, op_idx,
5b64640cf65be4 Yan, Zheng         2016-01-07  1083  							   cur_offset - =
offset);
5b64640cf65be4 Yan, Zheng         2016-01-07  1084  				dout("writepages go=
t pages at %llu~%llu\n",
5b64640cf65be4 Yan, Zheng         2016-01-07  1085  				     offset, len);
5b64640cf65be4 Yan, Zheng         2016-01-07  1086  				osd_req_op_extent_o=
sd_data_pages(req, op_idx,
5b64640cf65be4 Yan, Zheng         2016-01-07  1087  							data_pages, len,=
 0,
a0102bda5bc099 Jeff Layton        2020-07-30  1088  							from_pool, false=
);
5b64640cf65be4 Yan, Zheng         2016-01-07  1089  				osd_req_op_extent_u=
pdate(req, op_idx, len);
5b64640cf65be4 Yan, Zheng         2016-01-07  1090 =20
5b64640cf65be4 Yan, Zheng         2016-01-07  1091  				len =3D 0;
5b64640cf65be4 Yan, Zheng         2016-01-07  1092  				offset =3D cur_offs=
et;
5b64640cf65be4 Yan, Zheng         2016-01-07  1093  				data_pages =3D page=
s + i;
5b64640cf65be4 Yan, Zheng         2016-01-07  1094  				op_idx++;
5b64640cf65be4 Yan, Zheng         2016-01-07  1095  			}
5b64640cf65be4 Yan, Zheng         2016-01-07  1096 =20
5b64640cf65be4 Yan, Zheng         2016-01-07  1097  			set_page_writeback(p=
ages[i]);
1702e79734104d Jeff Layton        2021-12-07  1098  			if (caching)
1702e79734104d Jeff Layton        2021-12-07  1099  				ceph_set_page_fscac=
he(pages[i]);
8ff2d290c8ce77 Jeff Layton        2021-04-05  1100  			len +=3D thp_size(pa=
ge);
5b64640cf65be4 Yan, Zheng         2016-01-07  1101  		}
1702e79734104d Jeff Layton        2021-12-07  1102  		ceph_fscache_write_to=
_cache(inode, offset, len, caching);
5b64640cf65be4 Yan, Zheng         2016-01-07  1103 =20
1f934b00e90752 Yan, Zheng         2017-08-30  1104  		if (ceph_wbc.size_sta=
ble) {
1f934b00e90752 Yan, Zheng         2017-08-30  1105  			len =3D min(len, cep=
h_wbc.i_size - offset);
5b64640cf65be4 Yan, Zheng         2016-01-07  1106  		} else if (i =3D=3D l=
ocked_pages) {
e1966b49446a43 Yan, Zheng         2015-06-18  1107  			/* writepages_finish=
() clears writeback pages
e1966b49446a43 Yan, Zheng         2015-06-18  1108  			 * according to the =
data length, so make sure
e1966b49446a43 Yan, Zheng         2015-06-18  1109  			 * data length cover=
s all locked pages */
8ff2d290c8ce77 Jeff Layton        2021-04-05  1110  			u64 min_len =3D len =
+ 1 - thp_size(page);
1f934b00e90752 Yan, Zheng         2017-08-30  1111  			len =3D get_writepag=
es_data_length(inode, pages[i - 1],
1f934b00e90752 Yan, Zheng         2017-08-30  1112  							 offset);
5b64640cf65be4 Yan, Zheng         2016-01-07  1113  			len =3D max(len, min=
_len);
e1966b49446a43 Yan, Zheng         2015-06-18  1114  		}
5b64640cf65be4 Yan, Zheng         2016-01-07  1115  		dout("writepages got =
pages at %llu~%llu\n", offset, len);
1d3576fd10f0d7 Sage Weil          2009-10-06  1116 =20
5b64640cf65be4 Yan, Zheng         2016-01-07  1117  		osd_req_op_extent_osd=
_data_pages(req, op_idx, data_pages, len,
a0102bda5bc099 Jeff Layton        2020-07-30  1118  						 0, from_pool, fa=
lse);
5b64640cf65be4 Yan, Zheng         2016-01-07  1119  		osd_req_op_extent_upd=
ate(req, op_idx, len);
e5975c7c8eb6ae Alex Elder         2013-03-14  1120 =20
5b64640cf65be4 Yan, Zheng         2016-01-07  1121  		BUG_ON(op_idx + 1 !=
=3D req->r_num_ops);
e5975c7c8eb6ae Alex Elder         2013-03-14  1122 =20
a0102bda5bc099 Jeff Layton        2020-07-30  1123  		from_pool =3D false;
5b64640cf65be4 Yan, Zheng         2016-01-07  1124  		if (i < locked_pages)=
 {
5b64640cf65be4 Yan, Zheng         2016-01-07  1125  			BUG_ON(num_ops <=3D =
req->r_num_ops);
5b64640cf65be4 Yan, Zheng         2016-01-07  1126  			num_ops -=3D req->r_=
num_ops;
5b64640cf65be4 Yan, Zheng         2016-01-07  1127  			locked_pages -=3D i;
5b64640cf65be4 Yan, Zheng         2016-01-07  1128 =20
5b64640cf65be4 Yan, Zheng         2016-01-07  1129  			/* allocate new page=
s array for next request */
5b64640cf65be4 Yan, Zheng         2016-01-07  1130  			data_pages =3D pages;
6da2ec56059c3c Kees Cook          2018-06-12  1131  			pages =3D kmalloc_ar=
ray(locked_pages, sizeof(*pages),
5b64640cf65be4 Yan, Zheng         2016-01-07  1132  					      GFP_NOFS);
5b64640cf65be4 Yan, Zheng         2016-01-07  1133  			if (!pages) {
a0102bda5bc099 Jeff Layton        2020-07-30  1134  				from_pool =3D true;
a0102bda5bc099 Jeff Layton        2020-07-30  1135  				pages =3D mempool_a=
lloc(ceph_wb_pagevec_pool, GFP_NOFS);
5b64640cf65be4 Yan, Zheng         2016-01-07  1136  				BUG_ON(!pages);
5b64640cf65be4 Yan, Zheng         2016-01-07  1137  			}
5b64640cf65be4 Yan, Zheng         2016-01-07  1138  			memcpy(pages, data_p=
ages + i,
5b64640cf65be4 Yan, Zheng         2016-01-07  1139  			       locked_pages =
* sizeof(*pages));
5b64640cf65be4 Yan, Zheng         2016-01-07  1140  			memset(data_pages + =
i, 0,
5b64640cf65be4 Yan, Zheng         2016-01-07  1141  			       locked_pages =
* sizeof(*pages));
5b64640cf65be4 Yan, Zheng         2016-01-07  1142  		} else {
5b64640cf65be4 Yan, Zheng         2016-01-07  1143  			BUG_ON(num_ops !=3D =
req->r_num_ops);
5b64640cf65be4 Yan, Zheng         2016-01-07  1144  			index =3D pages[i - =
1]->index + 1;
5b64640cf65be4 Yan, Zheng         2016-01-07  1145  			/* request message n=
ow owns the pages array */
5b64640cf65be4 Yan, Zheng         2016-01-07  1146  			pages =3D NULL;
5b64640cf65be4 Yan, Zheng         2016-01-07  1147  		}
e5975c7c8eb6ae Alex Elder         2013-03-14  1148 =20
fac02ddf910814 Arnd Bergmann      2018-07-13  1149  		req->r_mtime =3D inod=
e->i_mtime;
9d6fcb081a4770 Sage Weil          2011-05-12  1150  		rc =3D ceph_osdc_star=
t_request(&fsc->client->osdc, req, true);
9d6fcb081a4770 Sage Weil          2011-05-12  1151  		BUG_ON(rc);
1d3576fd10f0d7 Sage Weil          2009-10-06  1152  		req =3D NULL;
1d3576fd10f0d7 Sage Weil          2009-10-06  1153 =20
5b64640cf65be4 Yan, Zheng         2016-01-07  1154  		wbc->nr_to_write -=3D=
 i;
5b64640cf65be4 Yan, Zheng         2016-01-07  1155  		if (pages)
5b64640cf65be4 Yan, Zheng         2016-01-07  1156  			goto new_request;
5b64640cf65be4 Yan, Zheng         2016-01-07  1157 =20
2a2d927e35dd8d Yan, Zheng         2017-09-01  1158  		/*
2a2d927e35dd8d Yan, Zheng         2017-09-01  1159  		 * We stop writing ba=
ck only if we are not doing
2a2d927e35dd8d Yan, Zheng         2017-09-01  1160  		 * integrity sync. In=
 case of integrity sync we have to
2a2d927e35dd8d Yan, Zheng         2017-09-01  1161  		 * keep going until w=
e have written all the pages
2a2d927e35dd8d Yan, Zheng         2017-09-01  1162  		 * we tagged for writ=
eback prior to entering this loop.
2a2d927e35dd8d Yan, Zheng         2017-09-01  1163  		 */
2a2d927e35dd8d Yan, Zheng         2017-09-01  1164  		if (wbc->nr_to_write =
<=3D 0 && wbc->sync_mode =3D=3D WB_SYNC_NONE)
af9cc401ce7452 Yan, Zheng         2018-03-04  1165  			done =3D true;
1d3576fd10f0d7 Sage Weil          2009-10-06  1166 =20
1d3576fd10f0d7 Sage Weil          2009-10-06  1167  release_pvec_pages:
1d3576fd10f0d7 Sage Weil          2009-10-06  1168  		dout("pagevec_release=
 on %d pages (%p)\n", (int)pvec.nr,
1d3576fd10f0d7 Sage Weil          2009-10-06  1169  		     pvec.nr ? pvec.p=
ages[0] : NULL);
1d3576fd10f0d7 Sage Weil          2009-10-06  1170  		pagevec_release(&pvec=
);
1d3576fd10f0d7 Sage Weil          2009-10-06  1171  	}
1d3576fd10f0d7 Sage Weil          2009-10-06  1172 =20
1d3576fd10f0d7 Sage Weil          2009-10-06  1173  	if (should_loop && !do=
ne) {
1d3576fd10f0d7 Sage Weil          2009-10-06  1174  		/* more to do; loop b=
ack to beginning of file */
1d3576fd10f0d7 Sage Weil          2009-10-06  1175  		dout("writepages loop=
ing back to beginning of file\n");
2a2d927e35dd8d Yan, Zheng         2017-09-01  1176  		end =3D start_index -=
 1; /* OK even when start_index =3D=3D 0 */
f275635ee0b664 Yan, Zheng         2017-09-01  1177 =20
f275635ee0b664 Yan, Zheng         2017-09-01  1178  		/* to write dirty pag=
es associated with next snapc,
f275635ee0b664 Yan, Zheng         2017-09-01  1179  		 * we need to wait un=
til current writes complete */
f275635ee0b664 Yan, Zheng         2017-09-01  1180  		if (wbc->sync_mode !=
=3D WB_SYNC_NONE &&
f275635ee0b664 Yan, Zheng         2017-09-01  1181  		    start_index =3D=
=3D 0 && /* all dirty pages were checked */
f275635ee0b664 Yan, Zheng         2017-09-01  1182  		    !ceph_wbc.head_sn=
apc) {
f275635ee0b664 Yan, Zheng         2017-09-01  1183  			struct page *page;
f275635ee0b664 Yan, Zheng         2017-09-01  1184  			unsigned i, nr;
f275635ee0b664 Yan, Zheng         2017-09-01  1185  			index =3D 0;
f275635ee0b664 Yan, Zheng         2017-09-01  1186  			while ((index <=3D e=
nd) &&
f275635ee0b664 Yan, Zheng         2017-09-01  1187  			       (nr =3D pagev=
ec_lookup_tag(&pvec, mapping, &index,
67fd707f468142 Jan Kara           2017-11-15  1188  						PAGECACHE_TAG_WRI=
TEBACK))) {
f275635ee0b664 Yan, Zheng         2017-09-01  1189  				for (i =3D 0; i < n=
r; i++) {
f275635ee0b664 Yan, Zheng         2017-09-01  1190  					page =3D pvec.page=
s[i];
f275635ee0b664 Yan, Zheng         2017-09-01  1191  					if (page_snap_cont=
ext(page) !=3D snapc)
f275635ee0b664 Yan, Zheng         2017-09-01  1192  						continue;
f275635ee0b664 Yan, Zheng         2017-09-01  1193  					wait_on_page_write=
back(page);
f275635ee0b664 Yan, Zheng         2017-09-01  1194  				}
f275635ee0b664 Yan, Zheng         2017-09-01  1195  				pagevec_release(&pv=
ec);
f275635ee0b664 Yan, Zheng         2017-09-01  1196  				cond_resched();
f275635ee0b664 Yan, Zheng         2017-09-01  1197  			}
f275635ee0b664 Yan, Zheng         2017-09-01  1198  		}
f275635ee0b664 Yan, Zheng         2017-09-01  1199 =20
2a2d927e35dd8d Yan, Zheng         2017-09-01  1200  		start_index =3D 0;
1d3576fd10f0d7 Sage Weil          2009-10-06  1201  		index =3D 0;
1d3576fd10f0d7 Sage Weil          2009-10-06  1202  		goto retry;
1d3576fd10f0d7 Sage Weil          2009-10-06  1203  	}
1d3576fd10f0d7 Sage Weil          2009-10-06  1204 =20
1d3576fd10f0d7 Sage Weil          2009-10-06  1205  	if (wbc->range_cyclic =
|| (range_whole && wbc->nr_to_write > 0))
1d3576fd10f0d7 Sage Weil          2009-10-06  1206  		mapping->writeback_in=
dex =3D index;
1d3576fd10f0d7 Sage Weil          2009-10-06  1207 =20
1d3576fd10f0d7 Sage Weil          2009-10-06  1208  out:
1d3576fd10f0d7 Sage Weil          2009-10-06  1209  	ceph_osdc_put_request(=
req);
2a2d927e35dd8d Yan, Zheng         2017-09-01  1210  	ceph_put_snap_context(=
last_snapc);
2a2d927e35dd8d Yan, Zheng         2017-09-01  1211  	dout("writepages dend =
- startone, rc =3D %d\n", rc);
1d3576fd10f0d7 Sage Weil          2009-10-06  1212  	return rc;
1d3576fd10f0d7 Sage Weil          2009-10-06  1213  }
1d3576fd10f0d7 Sage Weil          2009-10-06  1214 =20

:::::: The code at line 788 was first introduced by commit
:::::: 1d3576fd10f0d7a104204267b81cf84a07028dad ceph: address space operati=
ons

:::::: TO: Sage Weil <sage@newdream.net>
:::::: CC: Sage Weil <sage@newdream.net>

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
