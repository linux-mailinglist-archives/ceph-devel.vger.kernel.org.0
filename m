Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECD6575FB7
	for <lists+ceph-devel@lfdr.de>; Fri, 26 Jul 2019 09:23:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725955AbfGZHXN (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 26 Jul 2019 03:23:13 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:42935 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725878AbfGZHXN (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 26 Jul 2019 03:23:13 -0400
Received: by mail-ot1-f68.google.com with SMTP id l15so54394332otn.9
        for <ceph-devel@vger.kernel.org>; Fri, 26 Jul 2019 00:23:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/VkQMhrZ6B/Rh6JDjXeorQNhsxudxgysKEK9uYwX0mE=;
        b=TtFuVSt4senaEiZKyt03XrK5zP0bCMPCEo6EkrojPas7r+0ORWUuVmUHAYT4otzcu4
         /TPufU+0wJ1sJq001zHlE3duqtNjDjCMMg2WVPRyLECXlKq9jvAk7NvgZ3nmGQdEBOho
         MsTa2VqPTuB4cMQGjinlrQwhNUc/u1xcHxIGEHV6XB8kxsKouv1nyK7HG8rsXnSugBak
         TIZjCO3hq0tuK7sYh2B+glltVPc21hE4PJ08Sg4vmiq3a1gyb8EHmJ3cj/uTI+rfshiX
         DExF5FvtfJIh9CtfQTCOfUuLZAarbL9BFzZdD2969X1R0mWyaMedjm9U3PoF2NMLnIkP
         3M9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/VkQMhrZ6B/Rh6JDjXeorQNhsxudxgysKEK9uYwX0mE=;
        b=Fr/tqI4rRUp5WMkYOR6C23PiwtmdQnMnGVXxIJZyEv7HncqO0qPhvtBEfJNtOpOr87
         I15tn0vaga1UwLDZlDZvLUgRwA9tAGMXwMdl1JlkHeIGkEJpnrWQtRPVVDUdnisqX/5G
         VAsg4s7WrGmodWB2XZsglhna05lVMuUF2FXc8LEY8pGKidnpVjS/hXWi3+jJBd6bVzl2
         +EGAFOA0bRVJb9uIeW2o3AFpuQ4TgU/UVlOWWmoad3z9DKmYVmmDe/VSZXGEf3IB3adt
         W3zPpxf6/YzPSzljohTh7CLXCSWHPf6g/rBGwZ1PtOUubNMfVeMeeOBTqNv/Kg96+pVR
         yw7g==
X-Gm-Message-State: APjAAAXLN6pBA9eUpVCzJMa7iDxs4+ithrZJaDN2Srg2vhhBwp3gTF2w
        jFh7sT2KSLg1Hi1hlaJNpXWjtxxK0Sevx3jsIzk=
X-Google-Smtp-Source: APXvYqw521hWCw0FGisHd3Q+7Wyo5ep6SjBFuWEhpVEL2sfNCV/VnPZdnm77NhyZmnrL7jvI8D5Rl17HTCG1HDJLx/4=
X-Received: by 2002:a9d:65da:: with SMTP id z26mr57669327oth.257.1564125792770;
 Fri, 26 Jul 2019 00:23:12 -0700 (PDT)
MIME-Version: 1.0
References: <CAKQB+fsGD4b_RE1yF3RQszne+xrcEVV9QZiObwwZ39GDCh6n5Q@mail.gmail.com>
 <CAAM7YAmd+63fAO8EPvw4jE0=ZUZAW2nOQhkmuYcXLhdEPeV-dA@mail.gmail.com>
In-Reply-To: <CAAM7YAmd+63fAO8EPvw4jE0=ZUZAW2nOQhkmuYcXLhdEPeV-dA@mail.gmail.com>
From:   Jerry Lee <leisurelysw24@gmail.com>
Date:   Fri, 26 Jul 2019 15:22:56 +0800
Message-ID: <CAKQB+fsbPXvmGj11NW0nJ50VGJeWkTc7vfpDZ0a6Jrw2DOWSgA@mail.gmail.com>
Subject: Re: cephfs kernel client umount stucks forever
To:     "Yan, Zheng" <ukernel@gmail.com>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>,
        Jeff Layton <jlayton@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi Zheng,

Sorry for the late reply.  It's really hard to encounter the issue.
However, it happens again today, but unfortunately, the command shows
that no op is under processing.

$ ceph daemon osd.13 dump_ops_in_flight
{
    "ops": [],
    "num_ops": 0
}

Is it more likely that the there are some subtle bugs in kernel client
or network stability issue between the client and server?  Thanks.

On Fri, 19 Jul 2019 at 20:43, Yan, Zheng <ukernel@gmail.com> wrote:
>
> On Fri, Jul 19, 2019 at 7:11 PM Jerry Lee <leisurelysw24@gmail.com> wrote:
> >
> > Hi,
> >
> > Recently I encountered a issue that cephfs kernel client umount stucks
> > forever. Under such condition, the call stack of umount process is
> > shown as below and it seems to be reasonable:
> >
> > [~] # cat /proc/985427/stack
> > [<ffffffff81098bcd>] io_schedule+0xd/0x30
> > [<ffffffff8111ab6f>] wait_on_page_bit_common+0xdf/0x160
> > [<ffffffff8111b0ec>] __filemap_fdatawait_range+0xec/0x140
> > [<ffffffff8111b195>] filemap_fdatawait_keep_errors+0x15/0x40
> > [<ffffffff811ab5a9>] sync_inodes_sb+0x1e9/0x220
> > [<ffffffff811b15be>] sync_filesystem+0x4e/0x80
> > [<ffffffff8118203d>] generic_shutdown_super+0x1d/0x110
> > [<ffffffffa08a48cc>] ceph_kill_sb+0x2c/0x80 [ceph]
> > [<ffffffff81181ca4>] deactivate_locked_super+0x34/0x60
> > [<ffffffff811a2f56>] cleanup_mnt+0x36/0x70
> > [<ffffffff8108e86f>] task_work_run+0x6f/0x90
> > [<ffffffff81001a9b>] do_syscall_64+0x27b/0x2c0
> > [<ffffffff81a00071>] entry_SYSCALL_64_after_hwframe+0x3d/0xa2
> > [<ffffffffffffffff>] 0xffffffffffffffff
> >
> > From the debugfs entry, two write requests are indeed not complete but
> > I can't figure it out.
> > [/sys/kernel/debug/ceph/63be7de3-e137-4b6d-ab75-323b27f21254.client4475]
> > # cat osdc
> > REQUESTS 2 homeless 0
> > 36      osd13   1.d069c5d       1.1d    [13,4,0]/13     [13,4,0]/13
> >  e327    10000000028.00000000    0x40002c        2       write
> > 37      osd13   1.8088c98       1.18    [13,6,0]/13     [13,6,0]/13
> >  e327    10000000029.00000000    0x40002c        2       write
> > LINGER REQUESTS
> > BACKOFFS
> >
> > The kernel version is 4.14 with some customized features and the
> > cluster is composed by 3 nodes.  On those nodes, CephFS is mount via
> > kernel client and the issue only happens on one node while others
> > umount the CephFS successfully.  I've already checked the upstream
> > patches and no related issues are found.  Currently, I try to
> > re-produce the issue in an environment with bad network quality
> > (emulated by tc, add some packet loss, corruption and latency to the
> > network between client and server).  Also, osdmap is tuned much more
> > frequently to trigger request resent on the client.  But, I got no
> > luck with above approach.
> >
> > Is there any suggestion or idea that I could do to further investigate
> > the issue?  Thanks!
>
> check if osd.13 has received these requests.
>
> ceph daemon osd.13 dump_ops_in_flight
> >
> > - Jerry
