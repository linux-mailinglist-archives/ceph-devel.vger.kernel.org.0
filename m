Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AE29496CAB
	for <lists+ceph-devel@lfdr.de>; Sat, 22 Jan 2022 14:57:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233681AbiAVN5D (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sat, 22 Jan 2022 08:57:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231328AbiAVN5C (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sat, 22 Jan 2022 08:57:02 -0500
Received: from mail-vk1-xa34.google.com (mail-vk1-xa34.google.com [IPv6:2607:f8b0:4864:20::a34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DE9BC06173B
        for <ceph-devel@vger.kernel.org>; Sat, 22 Jan 2022 05:57:02 -0800 (PST)
Received: by mail-vk1-xa34.google.com with SMTP id m131so7275413vkm.7
        for <ceph-devel@vger.kernel.org>; Sat, 22 Jan 2022 05:57:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=eUFtb/2kkdcvJ33zo61ab29SMv3fuEt/Pft3lID8tMw=;
        b=ObLt/cMVXLNxhDH1TOq+ZtlDv/Tia6u8YI/6yrTdLgqCxZR43v5Tv71rEnnhOqvg99
         Lkd3MAAd2EbNAJVNXkT98crM1wXc29mjdhKJwojAEa/+wd8Ia69RZxayrL7dAq6L/rXM
         P5hG3v13tHluyynmNkh7sgKX4yyKE1zT6YRh9mTUJtrrOz97T7F0gHGa4YKGeafaQ9u1
         96IHgRuvmZ4KGwKALo06l3U9b26FwwEi/VkOFkbK4zxocZkYWC2ZZGcC8peTc9pL81kb
         7xgaYyQVp1qHMvtMEjjMUs0kj3rME/pNhXFRm6FYKK+pq04c6u0o4m8NuHfRhK9JIm7S
         6q+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=eUFtb/2kkdcvJ33zo61ab29SMv3fuEt/Pft3lID8tMw=;
        b=COEL6AV2vypt1m6Ql0B/Fhv+EyhN6y9pz2bbnaATa5V7sBfbzxj+xx9Z7gvOAfg/1v
         uWvvivCEuIMH30dWr37tLOu51cUNdxZRVMuxOCpeZXXb+XdsKE2N7WcyKftneDa6ISwZ
         J/vyalmplgXU/EnnHJEx0Ont65DvRZXyoEQrZn3Bfsg5vvK2rrEQyygzPzRcECVx7diO
         jHFQttZsLlETkvxvVVnbC9gKLOl40V0wQ9FdNMg+AVZjjJELjpnnZbqjNI+h2AG8g9X4
         8EZ/zu3euf6ORjEOxTgbzXBVmlVLkcRS4beDGHpdIMAKSEsV/wVDB3apFZaZMNNxgD/e
         HGHA==
X-Gm-Message-State: AOAM5324F57zg93EZKttrlgsfSMV0VKcjQAmWm74RqCLDkLskfo7pBmJ
        dFACIJSVJMUlHbkhLcE9ZYEPTPiHFpcQRGqweX++W3QTYL8=
X-Google-Smtp-Source: ABdhPJxutZkptiuMUc4SaeXcdes5nbv3c48lGH4jvUMViob6dGqQGNbDViMCor5rt6VhxoiNJ+Y5iGZqC+u5CkKlqYU=
X-Received: by 2002:a05:6122:2020:: with SMTP id l32mr3384541vkd.13.1642859820936;
 Sat, 22 Jan 2022 05:57:00 -0800 (PST)
MIME-Version: 1.0
From:   mhnx <morphinwithyou@gmail.com>
Date:   Sat, 22 Jan 2022 16:56:50 +0300
Message-ID: <CAE-AtHoRUu_M6nL1AS7WzaqRkTvDPe51DgNesm+DDtq8fFFB5A@mail.gmail.com>
Subject: Ceph build with old glibc version.
To:     Ceph Development <ceph-devel@vger.kernel.org>
Cc:     Ceph Users <ceph-users@ceph.io>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hello.

I need to compile Ceph 14.2.22 with glibc 2.28-4 and when I try to
compile I get this error message:

BTW: I don't need LevelDB and Filestore. I use Bluestore.
Is there any solution?


[ 19%] Building CXX object
src/os/CMakeFiles/os.dir/bluestore/StupidAllocator.cc.o
In file included from /root/ceph/src/os/bluestore/StupidAllocator.cc:4:
/root/ceph/src/os/bluestore/StupidAllocator.h: In constructor
=E2=80=98StupidAllocator::StupidAllocator(CephContext*, const string&,
int64_t)=E2=80=99:
/root/ceph/src/os/bluestore/StupidAllocator.h:29:12: warning:
=E2=80=98StupidAllocator::last_alloc=E2=80=99 will be initialized after [-W=
reorder]
   uint64_t last_alloc;
            ^~~~~~~~~~
/root/ceph/src/os/bluestore/StupidAllocator.h:21:11: warning:
=E2=80=98int64_t StupidAllocator::block_size=E2=80=99 [-Wreorder]
   int64_t block_size;
           ^~~~~~~~~~
/root/ceph/src/os/bluestore/StupidAllocator.cc:13:1: warning:   when
initialized here [-Wreorder]
 StupidAllocator::StupidAllocator(CephContext* cct,
 ^~~~~~~~~~~~~~~
[ 19%] Building CXX object
src/os/CMakeFiles/os.dir/bluestore/BitmapAllocator.cc.o
[ 19%] Building CXX object src/os/CMakeFiles/os.dir/bluestore/AvlAllocator.=
cc.o
[ 19%] Building CXX object
src/os/CMakeFiles/os.dir/bluestore/HybridAllocator.cc.o
[ 19%] Building CXX object src/os/CMakeFiles/os.dir/bluestore/KernelDevice.=
cc.o
[ 19%] Building CXX object src/os/CMakeFiles/os.dir/bluestore/aio.cc.o
[ 19%] Building CXX object src/os/CMakeFiles/os.dir/FuseStore.cc.o
[ 19%] Building CXX object
src/os/CMakeFiles/os.dir/filestore/XfsFileStoreBackend.cc.o
[ 19%] Building CXX object src/os/CMakeFiles/os.dir/fs/XFS.cc.o
[ 19%] Linking CXX static library ../../lib/libos.a
[ 19%] Built target os
Scanning dependencies of target ceph-mon
[ 19%] Building CXX object src/CMakeFiles/ceph-mon.dir/ceph_mon.cc.o
[ 19%] Linking CXX executable ../bin/ceph-mon
/usr/bin/ld: /lib/libleveldb.so: undefined reference to `stat@GLIBC_2.33'
collect2: error: ld returned 1 exit status
make[2]: *** [src/CMakeFiles/ceph-mon.dir/build.make:128: bin/ceph-mon] Err=
or 1
make[1]: *** [CMakeFiles/Makefile2:681: src/CMakeFiles/ceph-mon.dir/all] Er=
ror 2
make: *** [Makefile:141: all] Error 2
