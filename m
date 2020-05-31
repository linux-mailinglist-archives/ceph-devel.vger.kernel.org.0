Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2D411E969C
	for <lists+ceph-devel@lfdr.de>; Sun, 31 May 2020 11:37:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727119AbgEaJhH (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 31 May 2020 05:37:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725898AbgEaJhH (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 31 May 2020 05:37:07 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68244C061A0E
        for <ceph-devel@vger.kernel.org>; Sun, 31 May 2020 02:37:07 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id s18so3912915ioe.2
        for <ceph-devel@vger.kernel.org>; Sun, 31 May 2020 02:37:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ufy5OCM/Z8pERC7DJrUtYP/r5plJ019/RikIGof5R4E=;
        b=V2IJdB00dCtrAR9dk7sSpnyX13fK2KzFdluwAYsfqZiLqcjOvHDulv//jpHjoc3mz6
         X1lNtHVSQm4oyiVwscZsODhWKF0aP0aI8JjYsVm7Y7AOsewwYIqb0W06+2ygeELv3kSy
         JfQCIBmN9kezNCJbQmwQ8g143flA8xykH+kTkfx3t+7MBbCynBaPh7ow7iPkHDW/1uCa
         daiI/rKjXm7is2TS1y3zimjEzF5KNwK3vNnHDRokeEVs9hlhbjrXQTE7UlmR+xAxLTY4
         0lT7nkKNQL0fPsETWTLA/SG40BeO4aspzVtDM1J4cInlbENz9vdKTfRszA251oAdR3k9
         GU0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ufy5OCM/Z8pERC7DJrUtYP/r5plJ019/RikIGof5R4E=;
        b=Bg1fzU2DoQp3Ld3VWKIAjYAZ5iLlPNuroYGOOh3E4i2WHVOEhs+n8seNXhwNLX6ml+
         yWmgpDgGwr6taAd5pAnP0lmT7k9HTrAQ47+SOEofS6bhmcWRKCKoS6yBn2SkKfVLQFO5
         gfu2gGwBF5MQPe4o5kdavqH/b2tdU0TP4LFzHJCluRPtXL1chFTHRbuBytAf4EiSGo2N
         U2hhAcCpU1FM+Mn2In4FQa3j4suqYg/WN4B00qEgoQqbt+kSoGKX4YnXpvhOk6thyn6Y
         VJzb0nVc4Dbl+5+ggL3AdW3vVGgzCVN0tlKJCSfDgOXszIglz8EmzYCPLyvpxS9/c6UK
         fDxQ==
X-Gm-Message-State: AOAM5308H1giBpelw84bl4APykhN1X86ztNUE29VKBYRkc6jnbpJXNgR
        AibS2SUM7xFh9Hm1SWMpeL3vG5xfshcwMseoovXH9R1VvnQ=
X-Google-Smtp-Source: ABdhPJzFKOLg6OesLiTcuX6IRBe4kyifgDryJtQoO/tPatBM8Akp2w31a2Zm5C/bGRZbRvT0ZhsKOtK2esx6p6zYKow=
X-Received: by 2002:a05:6602:80b:: with SMTP id z11mr14158691iow.109.1590917826406;
 Sun, 31 May 2020 02:37:06 -0700 (PDT)
MIME-Version: 1.0
References: <202005310244.LucfHPyT%lkp@intel.com>
In-Reply-To: <202005310244.LucfHPyT%lkp@intel.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Sun, 31 May 2020 11:37:12 +0200
Message-ID: <CAOi1vP_Y10zTJ53b9gcnnRyDURb6-xsHa3PUviB00Raa3uJYTg@mail.gmail.com>
Subject: Re: [ceph-client:testing 2/5] net/ceph/osdmap.c:203:6: warning: no
 previous prototype for 'clear_crush_names'
To:     kbuild test robot <lkp@intel.com>
Cc:     kbuild-all@lists.01.org,
        Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Sat, May 30, 2020 at 8:35 PM kbuild test robot <lkp@intel.com> wrote:
>
> tree:   https://github.com/ceph/ceph-client.git testing
> head:   b3a5867e0780ac0279cf1541ed985db78f186221
> commit: a9112bbf346099ab532fc52ef87d46935fe8e519 [2/5] libceph: decode CRUSH device/bucket types and names
> config: m68k-allmodconfig (attached as .config)
> compiler: m68k-linux-gcc (GCC) 9.3.0
> reproduce (this is a W=1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         git checkout a9112bbf346099ab532fc52ef87d46935fe8e519
>         # save the attached .config to linux build tree
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-9.3.0 make.cross ARCH=m68k
>
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kbuild test robot <lkp@intel.com>
>
> All warnings (new ones prefixed by >>, old ones prefixed by <<):
>
> In file included from arch/m68k/include/asm/io_mm.h:25,
> from arch/m68k/include/asm/io.h:8,
> from include/linux/io.h:13,
> from include/linux/irq.h:20,
> from include/asm-generic/hardirq.h:13,
> from ./arch/m68k/include/generated/asm/hardirq.h:1,
> from include/linux/hardirq.h:9,
> from include/linux/highmem.h:10,
> from include/linux/pagemap.h:11,
> from include/linux/blkdev.h:16,
> from include/linux/backing-dev.h:15,
> from include/linux/ceph/libceph.h:8,
> from net/ceph/osdmap.c:8:
> arch/m68k/include/asm/raw_io.h: In function 'raw_rom_outsb':
> arch/m68k/include/asm/raw_io.h:83:7: warning: variable '__w' set but not used [-Wunused-but-set-variable]
> 83 |  ({u8 __w, __v = (b);  u32 _addr = ((u32) (addr));          |       ^~~
> arch/m68k/include/asm/raw_io.h:430:3: note: in expansion of macro 'rom_out_8'
> 430 |   rom_out_8(port, *buf++);
> |   ^~~~~~~~~
> arch/m68k/include/asm/raw_io.h: In function 'raw_rom_outsw':
> arch/m68k/include/asm/raw_io.h:86:8: warning: variable '__w' set but not used [-Wunused-but-set-variable]
> 86 |  ({u16 __w, __v = (w); u32 _addr = ((u32) (addr));          |        ^~~
> arch/m68k/include/asm/raw_io.h:448:3: note: in expansion of macro 'rom_out_be16'
> 448 |   rom_out_be16(port, *buf++);
> |   ^~~~~~~~~~~~
> arch/m68k/include/asm/raw_io.h: In function 'raw_rom_outsw_swapw':
> arch/m68k/include/asm/raw_io.h:90:8: warning: variable '__w' set but not used [-Wunused-but-set-variable]
> 90 |  ({u16 __w, __v = (w); u32 _addr = ((u32) (addr));          |        ^~~
> arch/m68k/include/asm/raw_io.h:466:3: note: in expansion of macro 'rom_out_le16'
> 466 |   rom_out_le16(port, *buf++);
> |   ^~~~~~~~~~~~
> In file included from include/linux/string.h:6,
> from include/linux/ceph/ceph_debug.h:7,
> from net/ceph/osdmap.c:3:
> include/linux/scatterlist.h: In function 'sg_set_buf':
> arch/m68k/include/asm/page_mm.h:169:49: warning: ordered comparison of pointer with null pointer [-Wextra]
> 169 | #define virt_addr_valid(kaddr) ((void *)(kaddr) >= (void *)PAGE_OFFSET && (void *)(kaddr) < high_memory)
> |                                                 ^~
> include/linux/compiler.h:78:42: note: in definition of macro 'unlikely'
> 78 | # define unlikely(x) __builtin_expect(!!(x), 0)
> |                                          ^
> include/linux/scatterlist.h:143:2: note: in expansion of macro 'BUG_ON'
> 143 |  BUG_ON(!virt_addr_valid(buf));
> |  ^~~~~~
> include/linux/scatterlist.h:143:10: note: in expansion of macro 'virt_addr_valid'
> 143 |  BUG_ON(!virt_addr_valid(buf));
> |          ^~~~~~~~~~~~~~~
> In file included from arch/m68k/include/asm/bug.h:32,
> from include/linux/bug.h:5,
> from include/linux/thread_info.h:12,
> from include/asm-generic/preempt.h:5,
> from ./arch/m68k/include/generated/asm/preempt.h:1,
> from include/linux/preempt.h:78,
> from include/linux/spinlock.h:51,
> from include/linux/seqlock.h:36,
> from include/linux/time.h:6,
> from include/linux/stat.h:19,
> from include/linux/module.h:13,
> from net/ceph/osdmap.c:5:
> include/linux/dma-mapping.h: In function 'dma_map_resource':
> arch/m68k/include/asm/page_mm.h:169:49: warning: ordered comparison of pointer with null pointer [-Wextra]
> 169 | #define virt_addr_valid(kaddr) ((void *)(kaddr) >= (void *)PAGE_OFFSET && (void *)(kaddr) < high_memory)
> |                                                 ^~
> include/asm-generic/bug.h:139:27: note: in definition of macro 'WARN_ON_ONCE'
> 139 |  int __ret_warn_once = !!(condition);            |                           ^~~~~~~~~
> arch/m68k/include/asm/page_mm.h:170:25: note: in expansion of macro 'virt_addr_valid'
> 170 | #define pfn_valid(pfn)  virt_addr_valid(pfn_to_virt(pfn))
> |                         ^~~~~~~~~~~~~~~
> include/linux/dma-mapping.h:352:19: note: in expansion of macro 'pfn_valid'
> 352 |  if (WARN_ON_ONCE(pfn_valid(PHYS_PFN(phys_addr))))
> |                   ^~~~~~~~~
> net/ceph/osdmap.c: At top level:
> >> net/ceph/osdmap.c:203:6: warning: no previous prototype for 'clear_crush_names' [-Wmissing-prototypes]
> 203 | void clear_crush_names(struct rb_root *root)
> |      ^~~~~~~~~~~~~~~~~
> net/ceph/osdmap.c:249:6: warning: no previous prototype for 'clear_choose_args' [-Wmissing-prototypes]
> 249 | void clear_choose_args(struct crush_map *c)
> |      ^~~~~~~~~~~~~~~~~
> In file included from net/ceph/osdmap.c:8:
> include/linux/ceph/libceph.h:234:14: warning: 'lookup_crush_name' defined but not used [-Wunused-function]
> 234 | static type *lookup_##name(struct rb_root *root, lookup_param_type key)          |              ^~~~~~~
> include/linux/ceph/libceph.h:268:1: note: in expansion of macro 'DEFINE_RB_LOOKUP_FUNC2'
> 268 | DEFINE_RB_LOOKUP_FUNC2(name, type, keyfld, RB_CMP3WAY, RB_BYVAL,          | ^~~~~~~~~~~~~~~~~~~~~~
> include/linux/ceph/libceph.h:273:1: note: in expansion of macro 'DEFINE_RB_LOOKUP_FUNC'
> 273 | DEFINE_RB_LOOKUP_FUNC(name, type, keyfld, nodefld)
> | ^~~~~~~~~~~~~~~~~~~~~
> net/ceph/osdmap.c:166:1: note: in expansion of macro 'DEFINE_RB_FUNCS'
> 166 | DEFINE_RB_FUNCS(crush_name, struct crush_name_node, cn_id, cn_node)
> | ^~~~~~~~~~~~~~~
>
> vim +/clear_crush_names +203 net/ceph/osdmap.c
>
>    202
>  > 203  void clear_crush_names(struct rb_root *root)
>    204  {
>    205          while (!RB_EMPTY_ROOT(root)) {
>    206                  struct crush_name_node *cn =
>    207                      rb_entry(rb_first(root), struct crush_name_node, cn_node);
>    208
>    209                  erase_crush_name(root, cn);
>    210                  free_crush_name(cn);
>    211          }
>    212  }
>    213

Fixed.

Thanks,

                Ilya
