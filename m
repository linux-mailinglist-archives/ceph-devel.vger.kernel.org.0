Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34CB522A04D
	for <lists+ceph-devel@lfdr.de>; Wed, 22 Jul 2020 21:49:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732647AbgGVTtF (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 22 Jul 2020 15:49:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:39148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732623AbgGVTtF (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 22 Jul 2020 15:49:05 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF00420825;
        Wed, 22 Jul 2020 19:49:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595447344;
        bh=J1Iidc69pPzl40+QuPUjpN7yFAWt/SwwHiKN0iSrQa0=;
        h=Subject:From:To:Date:In-Reply-To:References:From;
        b=MiAu936I3YnVnJMameH6Bqpy9Fho786TEbkMdHBUcuHzQdl122w+geAbotA9K/Cgg
         ph/XUAwpfJD6JI+NyEFu9HBjD1M+7z3VUfYatv9BcGDKZAcnewRUcJLldVGZ75D2Hv
         Evv5rHWh11Pa7cCMabmf2WEJ0pFfihBel+AjqxtE=
Message-ID: <9bc6182c9594238f4609921b470dd4c5496c8b57.camel@kernel.org>
Subject: Re: Problems with building/installing ceph from sources (git repo)
 on x86_64 (ubuntu 20.04)
From:   Jeff Layton <jlayton@kernel.org>
To:     Ezra Ulembeck <ulembeck@gmail.com>, ceph-devel@vger.kernel.org
Date:   Wed, 22 Jul 2020 15:49:02 -0400
In-Reply-To: <cda63c29-bf9a-635f-df95-38cd04de2ced@gmail.com>
References: <cda63c29-bf9a-635f-df95-38cd04de2ced@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.3 (3.36.3-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2020-07-22 at 20:41 +0200, Ezra Ulembeck wrote:
> Hi all,
> 
> While following the instructions in
> https://docs.ceph.com/docs/master/install/build-ceph/
> 
> 1) I am not able to build packages
> 2) I encounter problems after building/installing in user-space
> 
> Details:
> 
> $ git clone --recursive https://github.com/ceph/ceph.git
> $ cd ceph
> $ git checkout octopus
> $ ./install-deps.sh
> 
> 1. Building packages
> 
> $ sudo dpkg-buildpackage -j4
> ...
> /usr/bin/cc -g -O2 -fdebug-prefix-map=/home/eduard/ceph=. 
> -fstack-protector-strong -Wformat -Werror=format-security -Wdate-time 
> -D_FORTIFY_SOURCE=2 -DCMAKE_HAVE_LIBC_PTHREAD  -Wl,-Bsymbolic-functions 
> -Wl,-z,relro  CMakeFiles/cmTC_277b6.dir/src.c.o  -o cmTC_277b6
> /usr/bin/ld: CMakeFiles/cmTC_277b6.dir/src.c.o: in function `main':
> ./obj-x86_64-linux-gnu/CMakeFiles/CMakeTmp/./obj-x86_64-linux-gnu/CMakeFiles/CMakeTmp/src.c:11: 
> undefined reference to `pthread_create'
> /usr/bin/ld: 
> ./obj-x86_64-linux-gnu/CMakeFiles/CMakeTmp/./obj-x86_64-linux-gnu/CMakeFiles/CMakeTmp/src.c:12: 
> undefined reference to `pthread_detach'
> /usr/bin/ld: 
> ./obj-x86_64-linux-gnu/CMakeFiles/CMakeTmp/./obj-x86_64-linux-gnu/CMakeFiles/CMakeTmp/src.c:13: 
> undefined reference to `pthread_join'
> collect2: error: ld returned 1 exit status
> 
> 2. Building/installing in user-space
> 
> $ ./do_cmake.sh
> $ cd build
> $ make
> $ sudo make install
> 
> $ ceph -s
> Traceback (most recent call last):
>    File "/usr/local/bin/ceph", line 140, in <module>
>      import rados
> ImportError: librados.so.2: cannot open shared object file: No such file 
> or directory
> 
> 
> I will be very thankful for any hints on how to get to success,
> 
> Thanks,
> Ezra

Hi Ezra, 

This list is mostly for the Linux kernel ceph clients. You may want to
send this to dev@ceph.io. See:

    https://ceph.io/resources/

Cheers,
-- 
Jeff Layton <jlayton@kernel.org>

