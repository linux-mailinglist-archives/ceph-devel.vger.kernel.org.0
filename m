Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC87C63E64D
	for <lists+ceph-devel@lfdr.de>; Thu,  1 Dec 2022 01:16:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230182AbiLAAQV (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 30 Nov 2022 19:16:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230142AbiLAAPh (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 30 Nov 2022 19:15:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7584F2A26A
        for <ceph-devel@vger.kernel.org>; Wed, 30 Nov 2022 16:10:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0825360A2A
        for <ceph-devel@vger.kernel.org>; Thu,  1 Dec 2022 00:10:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AD3BC43470;
        Thu,  1 Dec 2022 00:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669853407;
        bh=0/kBySII/a5KqZyXXc2+z/yVZU9fMNsn3bFYkirMqxE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=BzFnRc1eR/O0WMAS6eYHnTUOYDQ40/PH/Ih6jVIjgZbzC6+n/6m+m6CmMbjzG/t3V
         /LlHANi8J4nHIVQs5iBXsDuFaWemN8a5uQDjbKekcmxsw3d4kw2bOxIY2x/nZKZqH6
         ZQ2P021xR5s0m6TgIhx0lfTAfSTOevedcqeKIbJ42ou3Bg9ex8lvTclwxrNDstdRV9
         GyQUeRsojP+q2HFXgnVhmcWzxjxCk0e5QUZJ7YJqf6FxNowD0rW2JfHdXEo9Q73jXK
         2rIPQLoY7UjEnOgsEnPcN5kPI0wj0vr6p3TAsjSO7E9bBp9HDPxlUCCyjglWyD8JTN
         KdeSUpILCC0GQ==
Message-ID: <5843a4f790d1f87c3e33ef8554f8493404856257.camel@kernel.org>
Subject: Re: [ceph-client:testing 1/4] include/linux/fs.h:1342:20: error:
 static declaration of 'vfs_inode_has_locks' follows non-static declaration
From:   Jeff Layton <jlayton@kernel.org>
To:     kernel test robot <lkp@intel.com>
Cc:     llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>,
        Christoph Hellwig <hch@infradead.org>
Date:   Wed, 30 Nov 2022 19:10:05 -0500
In-Reply-To: <202212010417.wCjpGlKY-lkp@intel.com>
References: <202212010417.wCjpGlKY-lkp@intel.com>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.1 (3.46.1-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2022-12-01 at 04:08 +0800, kernel test robot wrote:
> tree:   https://github.com/ceph/ceph-client.git testing
> head:   6a6f71f4a4a945600943c2ce926f7b4174f75c0d
> commit: 8c552db6d9d144857f755a156b10de0b848a9de8 [1/4] [DO NOT MERGE] fil=
elock: new helper: vfs_inode_has_locks
> config: hexagon-randconfig-r041-20221128
> compiler: clang version 16.0.0 (https://github.com/llvm/llvm-project 6e4c=
ea55f0d1104408b26ac574566a0e4de48036)
> reproduce (this is a W=3D1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbi=
n/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # https://github.com/ceph/ceph-client/commit/8c552db6d9d144857f75=
5a156b10de0b848a9de8
>         git remote add ceph-client https://github.com/ceph/ceph-client.gi=
t
>         git fetch --no-tags ceph-client testing
>         git checkout 8c552db6d9d144857f755a156b10de0b848a9de8
>         # save the config file
>         mkdir build_dir && cp config build_dir/.config
>         COMPILER_INSTALL_PATH=3D$HOME/0day COMPILER=3Dclang make.cross W=
=3D1 O=3Dbuild_dir ARCH=3Dhexagon prepare
>=20
> If you fix the issue, kindly add following tag where applicable
> > Reported-by: kernel test robot <lkp@intel.com>
>=20
> All errors (new ones prefixed by >>):
>=20
>    In file included from arch/hexagon/kernel/asm-offsets.c:12:
>    In file included from include/linux/compat.h:17:
> > > include/linux/fs.h:1342:20: error: static declaration of 'vfs_inode_h=
as_locks' follows non-static declaration
>    static inline bool vfs_inode_has_locks(struct inode *inode)
>                       ^
>    include/linux/fs.h:1173:6: note: previous declaration is here
>    bool vfs_inode_has_locks(struct inode *inode);
>         ^

I'm really confused here.

The non-static declaration is inside an #ifdef CONFIG_FILE_LOCKING
block, and the static inline definition is in the #else block just
after. How is it possible for them to conflict? Is the preprocessor
borked or something?

FWIW, I was able to build kernels on x86_64 with CONFIG_FILE_LOCKING
both enabled and disabled. I'm not seeing the same problem there.

>    In file included from arch/hexagon/kernel/asm-offsets.c:15:
>    In file included from include/linux/interrupt.h:11:
>    In file included from include/linux/hardirq.h:11:
>    In file included from ./arch/hexagon/include/generated/asm/hardirq.h:1=
:
>    In file included from include/asm-generic/hardirq.h:17:
>    In file included from include/linux/irq.h:20:
>    In file included from include/linux/io.h:13:
>    In file included from arch/hexagon/include/asm/io.h:334:
>    include/asm-generic/io.h:547:31: warning: performing pointer arithmeti=
c on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
>            val =3D __raw_readb(PCI_IOBASE + addr);
>                              ~~~~~~~~~~ ^
>    include/asm-generic/io.h:560:61: warning: performing pointer arithmeti=
c on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
>            val =3D __le16_to_cpu((__le16 __force)__raw_readw(PCI_IOBASE +=
 addr));
>                                                            ~~~~~~~~~~ ^
>    include/uapi/linux/byteorder/little_endian.h:37:51: note: expanded fro=
m macro '__le16_to_cpu'
>    #define __le16_to_cpu(x) ((__force __u16)(__le16)(x))
>                                                      ^
>    In file included from arch/hexagon/kernel/asm-offsets.c:15:
>    In file included from include/linux/interrupt.h:11:
>    In file included from include/linux/hardirq.h:11:
>    In file included from ./arch/hexagon/include/generated/asm/hardirq.h:1=
:
>    In file included from include/asm-generic/hardirq.h:17:
>    In file included from include/linux/irq.h:20:
>    In file included from include/linux/io.h:13:
>    In file included from arch/hexagon/include/asm/io.h:334:
>    include/asm-generic/io.h:573:61: warning: performing pointer arithmeti=
c on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
>            val =3D __le32_to_cpu((__le32 __force)__raw_readl(PCI_IOBASE +=
 addr));
>                                                            ~~~~~~~~~~ ^
>    include/uapi/linux/byteorder/little_endian.h:35:51: note: expanded fro=
m macro '__le32_to_cpu'
>    #define __le32_to_cpu(x) ((__force __u32)(__le32)(x))
>                                                      ^
>    In file included from arch/hexagon/kernel/asm-offsets.c:15:
>    In file included from include/linux/interrupt.h:11:
>    In file included from include/linux/hardirq.h:11:
>    In file included from ./arch/hexagon/include/generated/asm/hardirq.h:1=
:
>    In file included from include/asm-generic/hardirq.h:17:
>    In file included from include/linux/irq.h:20:
>    In file included from include/linux/io.h:13:
>    In file included from arch/hexagon/include/asm/io.h:334:
>    include/asm-generic/io.h:584:33: warning: performing pointer arithmeti=
c on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
>            __raw_writeb(value, PCI_IOBASE + addr);
>                                ~~~~~~~~~~ ^
>    include/asm-generic/io.h:594:59: warning: performing pointer arithmeti=
c on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
>            __raw_writew((u16 __force)cpu_to_le16(value), PCI_IOBASE + add=
r);
>                                                          ~~~~~~~~~~ ^
>    include/asm-generic/io.h:604:59: warning: performing pointer arithmeti=
c on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
>            __raw_writel((u32 __force)cpu_to_le32(value), PCI_IOBASE + add=
r);
>                                                          ~~~~~~~~~~ ^
>    6 warnings and 1 error generated.
>    make[2]: *** [scripts/Makefile.build:118: arch/hexagon/kernel/asm-offs=
ets.s] Error 1
>    make[2]: Target 'prepare' not remade because of errors.
>    make[1]: *** [Makefile:1270: prepare0] Error 2
>    make[1]: Target 'prepare' not remade because of errors.
>    make: *** [Makefile:231: __sub-make] Error 2
>    make: Target 'prepare' not remade because of errors.
>=20
>=20
> vim +/vfs_inode_has_locks +1342 include/linux/fs.h
>=20
>   1341=09
> > 1342	static inline bool vfs_inode_has_locks(struct inode *inode)
>   1343	{
>   1344		return false;
>   1345	}
>   1346=09
>=20

--=20
Jeff Layton <jlayton@kernel.org>
