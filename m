Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDB8E761C5
	for <lists+ceph-devel@lfdr.de>; Fri, 26 Jul 2019 11:22:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726139AbfGZJWm (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 26 Jul 2019 05:22:42 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:35822 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725842AbfGZJWm (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 26 Jul 2019 05:22:42 -0400
Received: by mail-oi1-f194.google.com with SMTP id a127so39773975oii.2
        for <ceph-devel@vger.kernel.org>; Fri, 26 Jul 2019 02:22:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3OFNMXS5kEoWe7aQXTab5kJqVcE1yn7QF3y4T3FXuM8=;
        b=jKOhtqSXYnWAfl0Wv3CVv40uGwe6P+sPDS8ptZyP93VZzEnT+8WucPuHNi6EwsxaFu
         oFB/VbABeMh0JrYzEchyQIjHX2DES6yUWfG1LHPm1iCQ3h8aBI5RdLzYMh724BKOyHK+
         H0vaajboldwkKA1pOvPgBTY72EI8ai3fXe2ihlvl35ONWI42xrephTaI1e5fgIdunihg
         HBzkaK0Rm0VOAoN7IFhJBSkinAtxQ5IFevyxNBo48YWq0vFTUHPGrUU29O2lHET0HD1w
         bg8aLiH357aXEoFdwFSC1137iHXrvrkp6Z6Icjq9OzDxY0pnfKywnG2qCj1brVY6aX+c
         7W2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3OFNMXS5kEoWe7aQXTab5kJqVcE1yn7QF3y4T3FXuM8=;
        b=SERRZ4BVoMPv0UHqtbHw5IwFdluDpv0eUmU4IiuPPeAk06CXxanca9KPIHBkD+S2RK
         RRMufwVZB/BeBhOQnkvlGWvJ0z95OfqK2aro159uJ5dSDzIvsDmbLPo+G6sac9srD+tE
         8wIOOwyvTnustAo3HoGv0aT1I4BEBSzTtr9cv/Mq36hQMRTecpJDk1DZsw2VbttETumb
         K3J+KUonFGzLrnjKJdYUvcQ5/iAuDYQ+1p6jGVY3xqyZziLHSAnmNGdlYH8fx9R5g9Xs
         sc0kzCFw4Dz0UjFvm9pIHanSRzk9LSoxdvrD9XhiG5iUiXibnO/1aTa8W67kZqz0lAqi
         A84A==
X-Gm-Message-State: APjAAAWB2H+92cZlCJkEMA+sfqNDe0tlhsQGLq3WovDR+eCgN+g7MYwF
        uwR6uSiJYIy7kvOG7a4109sUNRYhk79SkoTOWJA=
X-Google-Smtp-Source: APXvYqwWYV5hD9d18/ApLQG4JB6mSIQlOr5Optfj6d9XoeZV7w8UC83QqxW6GAafYYzuGZFBacmvFNHBSAk88Q+aKkM=
X-Received: by 2002:aca:bfd4:: with SMTP id p203mr24548393oif.95.1564132961343;
 Fri, 26 Jul 2019 02:22:41 -0700 (PDT)
MIME-Version: 1.0
References: <CAKQB+fsGD4b_RE1yF3RQszne+xrcEVV9QZiObwwZ39GDCh6n5Q@mail.gmail.com>
 <CAAM7YAmd+63fAO8EPvw4jE0=ZUZAW2nOQhkmuYcXLhdEPeV-dA@mail.gmail.com> <CAKQB+fsbPXvmGj11NW0nJ50VGJeWkTc7vfpDZ0a6Jrw2DOWSgA@mail.gmail.com>
In-Reply-To: <CAKQB+fsbPXvmGj11NW0nJ50VGJeWkTc7vfpDZ0a6Jrw2DOWSgA@mail.gmail.com>
From:   Jerry Lee <leisurelysw24@gmail.com>
Date:   Fri, 26 Jul 2019 17:22:27 +0800
Message-ID: <CAKQB+fuoAmSzsFmJz2ou5Rp6jGKv6XSpfo08t2C+Hj6_yb2+_A@mail.gmail.com>
Subject: Re: cephfs kernel client umount stucks forever
To:     "Yan, Zheng" <ukernel@gmail.com>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>,
        Jeff Layton <jlayton@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Some additional information are provided as below:

I tried to restart the active MDS, and after the standby MDS took
over, there is no client session recorded in the output of `ceph
daemon mds.xxx session ls`.  When I restarted the OSD.13 daemon, the
stuck write op finished immediately.  Thanks.

On Fri, 26 Jul 2019 at 15:22, Jerry Lee <leisurelysw24@gmail.com> wrote:
>
> Hi Zheng,
>
> Sorry for the late reply.  It's really hard to encounter the issue.
> However, it happens again today, but unfortunately, the command shows
> that no op is under processing.
>
> $ ceph daemon osd.13 dump_ops_in_flight
> {
>     "ops": [],
>     "num_ops": 0
> }
>
> Is it more likely that the there are some subtle bugs in kernel client
> or network stability issue between the client and server?  Thanks.
>
> On Fri, 19 Jul 2019 at 20:43, Yan, Zheng <ukernel@gmail.com> wrote:
> >
> > On Fri, Jul 19, 2019 at 7:11 PM Jerry Lee <leisurelysw24@gmail.com> wrote:
> > >
> > > Hi,
> > >
> > > Recently I encountered a issue that cephfs kernel client umount stucks
> > > forever. Under such condition, the call stack of umount process is
> > > shown as below and it seems to be reasonable:
> > >
> > > [~] # cat /proc/985427/stack
> > > [<ffffffff81098bcd>] io_schedule+0xd/0x30
> > > [<ffffffff8111ab6f>] wait_on_page_bit_common+0xdf/0x160
> > > [<ffffffff8111b0ec>] __filemap_fdatawait_range+0xec/0x140
> > > [<ffffffff8111b195>] filemap_fdatawait_keep_errors+0x15/0x40
> > > [<ffffffff811ab5a9>] sync_inodes_sb+0x1e9/0x220
> > > [<ffffffff811b15be>] sync_filesystem+0x4e/0x80
> > > [<ffffffff8118203d>] generic_shutdown_super+0x1d/0x110
> > > [<ffffffffa08a48cc>] ceph_kill_sb+0x2c/0x80 [ceph]
> > > [<ffffffff81181ca4>] deactivate_locked_super+0x34/0x60
> > > [<ffffffff811a2f56>] cleanup_mnt+0x36/0x70
> > > [<ffffffff8108e86f>] task_work_run+0x6f/0x90
> > > [<ffffffff81001a9b>] do_syscall_64+0x27b/0x2c0
> > > [<ffffffff81a00071>] entry_SYSCALL_64_after_hwframe+0x3d/0xa2
> > > [<ffffffffffffffff>] 0xffffffffffffffff
> > >
> > > From the debugfs entry, two write requests are indeed not complete but
> > > I can't figure it out.
> > > [/sys/kernel/debug/ceph/63be7de3-e137-4b6d-ab75-323b27f21254.client4475]
> > > # cat osdc
> > > REQUESTS 2 homeless 0
> > > 36      osd13   1.d069c5d       1.1d    [13,4,0]/13     [13,4,0]/13
> > >  e327    10000000028.00000000    0x40002c        2       write
> > > 37      osd13   1.8088c98       1.18    [13,6,0]/13     [13,6,0]/13
> > >  e327    10000000029.00000000    0x40002c        2       write
> > > LINGER REQUESTS
> > > BACKOFFS
> > >
> > > The kernel version is 4.14 with some customized features and the
> > > cluster is composed by 3 nodes.  On those nodes, CephFS is mount via
> > > kernel client and the issue only happens on one node while others
> > > umount the CephFS successfully.  I've already checked the upstream
> > > patches and no related issues are found.  Currently, I try to
> > > re-produce the issue in an environment with bad network quality
> > > (emulated by tc, add some packet loss, corruption and latency to the
> > > network between client and server).  Also, osdmap is tuned much more
> > > frequently to trigger request resent on the client.  But, I got no
> > > luck with above approach.
> > >
> > > Is there any suggestion or idea that I could do to further investigate
> > > the issue?  Thanks!
> >
> > check if osd.13 has received these requests.
> >
> > ceph daemon osd.13 dump_ops_in_flight
> > >
> > > - Jerry
