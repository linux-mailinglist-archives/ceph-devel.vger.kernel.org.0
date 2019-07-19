Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B035F6E5DB
	for <lists+ceph-devel@lfdr.de>; Fri, 19 Jul 2019 14:43:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728135AbfGSMnQ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 19 Jul 2019 08:43:16 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:43757 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727559AbfGSMnQ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 19 Jul 2019 08:43:16 -0400
Received: by mail-qt1-f195.google.com with SMTP id w17so30737184qto.10
        for <ceph-devel@vger.kernel.org>; Fri, 19 Jul 2019 05:43:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=btJIEpD4723ryqz3DtokDsxK6amUOIT9T7gWw5+k6RU=;
        b=oHiZEbiEJ2H7x8YFfJDw5vu7YXqv6l1OdM/b0GvuEUh0yoTDmu4HkVygz5Dgaqsxq/
         ipmEe5+MY9nh8+OxXF2CzN/7G2Y6VgnPRFmxFvmyfOKceYvEHXoNpB4bJhLoNojk9b1c
         hQpgzQF6b2fhuvTVc4mSYY4uojtHTmPaNLxKu6AhFhjjnq1q4uVvU2u4N7ti7153M2JP
         8O6M+pCMDFzfVc9VdzT17OcyudlITYLCxBUcJL7N68amh2OzswiojM8/3BCLQw1+AJKS
         ycasCZsGypKpEPRM0zZEtYErd5G4NfFSZ0CVSPRJYF5a8CyHqipEGMudGG0OBoeB+LPx
         ytwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=btJIEpD4723ryqz3DtokDsxK6amUOIT9T7gWw5+k6RU=;
        b=sWNBFuy6wzdmpQLHItfGxO4P1pEW3QyXT3nsF5t+2rf5Zf31UkVYBX7ywz4MqLyjOA
         Ftq62PJm5BX1BK8Cp7AOmzB3GLP6O4p4pJifPNCG03BDzLnZbMEP1tkNVey9uxHh+QrV
         J/NzXjuDx/ze922AglqZzkC2vLpe8Vff54lYrk/sRkxwd77Mj3uwjKH6m1GtZCH0JI5x
         5E9xdXHaMFZoJ0Q3nTOvV/dqIQ4iYr1N24J1E7h6vZ7BWQgLTq/w7ZSN+eNfGAPC3noa
         KpTDRdXLWSy0c5pFw4inx7iz7HfLXKC9lsQ34ChCeoFUL5hTEkbd2DKReROag0wYH/aV
         zawQ==
X-Gm-Message-State: APjAAAWnnsmWzGAXWbUnp8NiUJp5A9QdOmQVsdHpA01KERic1bEud4Xc
        RZ6ok1xbMsWivq8m+qNxv0ZUpZJMrfHqfIk0vps=
X-Google-Smtp-Source: APXvYqzbJg8hJJz/7wZ64tVgSCgHwjmc8oNnXy4UZb+pfdvfu3TF6kqnsK+uHbASuMBd9b+GbmrIt9/GiHw4hr4lU4Q=
X-Received: by 2002:a0c:92ca:: with SMTP id c10mr36954146qvc.108.1563540195077;
 Fri, 19 Jul 2019 05:43:15 -0700 (PDT)
MIME-Version: 1.0
References: <CAKQB+fsGD4b_RE1yF3RQszne+xrcEVV9QZiObwwZ39GDCh6n5Q@mail.gmail.com>
In-Reply-To: <CAKQB+fsGD4b_RE1yF3RQszne+xrcEVV9QZiObwwZ39GDCh6n5Q@mail.gmail.com>
From:   "Yan, Zheng" <ukernel@gmail.com>
Date:   Fri, 19 Jul 2019 20:43:03 +0800
Message-ID: <CAAM7YAmd+63fAO8EPvw4jE0=ZUZAW2nOQhkmuYcXLhdEPeV-dA@mail.gmail.com>
Subject: Re: cephfs kernel client umount stucks forever
To:     Jerry Lee <leisurelysw24@gmail.com>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>,
        Jeff Layton <jlayton@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, Jul 19, 2019 at 7:11 PM Jerry Lee <leisurelysw24@gmail.com> wrote:
>
> Hi,
>
> Recently I encountered a issue that cephfs kernel client umount stucks
> forever. Under such condition, the call stack of umount process is
> shown as below and it seems to be reasonable:
>
> [~] # cat /proc/985427/stack
> [<ffffffff81098bcd>] io_schedule+0xd/0x30
> [<ffffffff8111ab6f>] wait_on_page_bit_common+0xdf/0x160
> [<ffffffff8111b0ec>] __filemap_fdatawait_range+0xec/0x140
> [<ffffffff8111b195>] filemap_fdatawait_keep_errors+0x15/0x40
> [<ffffffff811ab5a9>] sync_inodes_sb+0x1e9/0x220
> [<ffffffff811b15be>] sync_filesystem+0x4e/0x80
> [<ffffffff8118203d>] generic_shutdown_super+0x1d/0x110
> [<ffffffffa08a48cc>] ceph_kill_sb+0x2c/0x80 [ceph]
> [<ffffffff81181ca4>] deactivate_locked_super+0x34/0x60
> [<ffffffff811a2f56>] cleanup_mnt+0x36/0x70
> [<ffffffff8108e86f>] task_work_run+0x6f/0x90
> [<ffffffff81001a9b>] do_syscall_64+0x27b/0x2c0
> [<ffffffff81a00071>] entry_SYSCALL_64_after_hwframe+0x3d/0xa2
> [<ffffffffffffffff>] 0xffffffffffffffff
>
> From the debugfs entry, two write requests are indeed not complete but
> I can't figure it out.
> [/sys/kernel/debug/ceph/63be7de3-e137-4b6d-ab75-323b27f21254.client4475]
> # cat osdc
> REQUESTS 2 homeless 0
> 36      osd13   1.d069c5d       1.1d    [13,4,0]/13     [13,4,0]/13
>  e327    10000000028.00000000    0x40002c        2       write
> 37      osd13   1.8088c98       1.18    [13,6,0]/13     [13,6,0]/13
>  e327    10000000029.00000000    0x40002c        2       write
> LINGER REQUESTS
> BACKOFFS
>
> The kernel version is 4.14 with some customized features and the
> cluster is composed by 3 nodes.  On those nodes, CephFS is mount via
> kernel client and the issue only happens on one node while others
> umount the CephFS successfully.  I've already checked the upstream
> patches and no related issues are found.  Currently, I try to
> re-produce the issue in an environment with bad network quality
> (emulated by tc, add some packet loss, corruption and latency to the
> network between client and server).  Also, osdmap is tuned much more
> frequently to trigger request resent on the client.  But, I got no
> luck with above approach.
>
> Is there any suggestion or idea that I could do to further investigate
> the issue?  Thanks!

check if osd.13 has received these requests.

ceph daemon osd.13 dump_ops_in_flight
>
> - Jerry
