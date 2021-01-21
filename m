Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5241B2FED0C
	for <lists+ceph-devel@lfdr.de>; Thu, 21 Jan 2021 15:39:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731590AbhAUOhg (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 21 Jan 2021 09:37:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:34874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731556AbhAUOhT (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 21 Jan 2021 09:37:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 513F9239D4;
        Thu, 21 Jan 2021 14:28:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611239301;
        bh=+mm2U8TY7vXitroD5WIUBhFXucpFW30imPFw4AZllMs=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=VC5EhEW4u58ReQ3Cwn8EGh6mX4QU+7gh2BRH+yhvu/osMD/MtGUDwAWatJsvAJdQ8
         sgMxdG7IGewresmwBOMGH/n0sWZTb5W5ZNgSvEA1/jHToATeHZW+lG1+UvSjNft6i+
         cljlxran7xCDp3gtlJFSG3InTHtZFYy8RkjUcCGMq+It2ksDgEToHvBKCypO9aitn0
         J2PYvw7wZuJEcblU9RRsM1/innJS0HHw0MSpTS0ylhJypZPqjzHg+VDELMMn00PsVo
         JwUhtTosQHQ8ti/pL3wEcJ+82jg5yraB8f179v6MB/eom6gio4L6y2f8tqQIdvQYeO
         zqvl6yhrKtlnw==
Message-ID: <868f0eddf24fcdcb4bdebf93e9200bf699884155.camel@kernel.org>
Subject: Re: [PATCH v3] ceph: defer flushing the capsnap if the Fb is used
From:   Jeff Layton <jlayton@kernel.org>
To:     Xiubo Li <xiubli@redhat.com>
Cc:     idryomov@gmail.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org
Date:   Thu, 21 Jan 2021 09:28:19 -0500
In-Reply-To: <376245cf-a60d-6ddb-6ab3-894a491b854e@redhat.com>
References: <20210110020140.141727-1-xiubli@redhat.com>
         <f698d039251d444eec334b119b5ae0b0dd101a21.camel@kernel.org>
         <376245cf-a60d-6ddb-6ab3-894a491b854e@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.38.3 (3.38.3-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2021-01-18 at 17:10 +0800, Xiubo Li wrote:
> On 2021/1/13 5:48, Jeff Layton wrote:
> > On Sun, 2021-01-10 at 10:01 +0800, xiubli@redhat.com wrote:
> > > From: Xiubo Li <xiubli@redhat.com>
> > > 
> > > If the Fb cap is used it means the current inode is flushing the
> > > dirty data to OSD, just defer flushing the capsnap.
> > > 
> > > URL: https://tracker.ceph.com/issues/48679
> > > URL: https://tracker.ceph.com/issues/48640
> > > Signed-off-by: Xiubo Li <xiubli@redhat.com>
> > > ---
> > > 
> > > V3:
> > > - Add more comments about putting the inode ref
> > > - A small change about the code style
> > > 
> > > V2:
> > > - Fix inode reference leak bug
> > > 
> > >   fs/ceph/caps.c | 32 +++++++++++++++++++-------------
> > >   fs/ceph/snap.c |  6 +++---
> > >   2 files changed, 22 insertions(+), 16 deletions(-)
> > > 
> > Hi Xiubo,
> > 
> > This patch seems to cause hangs in some xfstests (generic/013, in
> > particular). I'll take a closer look when I have a chance, but I'm
> > dropping this for now.
> 
> Okay.
> 
> BTW, what's your test commands to reproduce it ? I will take a look when 
> I am free these days or later.
> 


FWIW, I was able to trigger a hang with this patch by running one of the
tests that this patch was intended to fix (snaptest-git-ceph.sh). Here's
the stack trace of the hung task:

# cat /proc/1166/stack
[<0>] wait_woken+0x87/0xb0
[<0>] ceph_get_caps+0x405/0x6a0 [ceph]
[<0>] ceph_write_iter+0x2ca/0xd20 [ceph]
[<0>] new_sync_write+0x10b/0x190
[<0>] vfs_write+0x240/0x390
[<0>] ksys_write+0x58/0xd0
[<0>] do_syscall_64+0x33/0x40
[<0>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

Without this patch I could run that test in a loop without issue. This
bug mentions that the original issue occurred during mds thrashing
though, and I haven't tried reproducing that scenario yet:

    https://tracker.ceph.com/issues/48640

Cheers,
-- 
Jeff Layton <jlayton@kernel.org>

