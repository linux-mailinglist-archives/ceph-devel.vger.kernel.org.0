Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DC30403009
	for <lists+ceph-devel@lfdr.de>; Tue,  7 Sep 2021 22:58:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346228AbhIGVAB (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 7 Sep 2021 17:00:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:40200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235160AbhIGVAA (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 7 Sep 2021 17:00:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9E108604E9;
        Tue,  7 Sep 2021 20:58:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631048334;
        bh=dqr2I7xqw83eP9VRnS+/xcOugbJ30JsSTF2gpVO+9s0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=I8vWVOoAH078N3B5nVARB4Cu4zILOp3J/qXQ9zIVUM9IM+QcewuUSrOeAfkmYx7LD
         XPuxJGb29gamru/YHYV/sPpTbbZKavrvxYQMvGE8O/EeEUTKYBF84HFef4hNKf696y
         f9R9jHt749CoiaIKt4WSz7C0QiuRnHbsP4Rv0FGjoF1C3oop+AIvg8Tsy+Gvj8VdhI
         rUWPmdICO4o1+QOlILj6jogag3DFhxl2I+BoxtBO6Y27RUDVDGPL3jxHFCL2/3fgmC
         tNg46LpykjH3qTqEgXkKMAC0QQG/GMM3PqwbRA51uhjS410q6pELnuIXR2g/UUfyR6
         4qSF3KS1jdnoQ==
Message-ID: <68728d2700e98382aabdf298ac0ae7fad6615a2e.camel@kernel.org>
Subject: Re: [PATCH RFC 0/2] ceph: size handling for the fscrypt
From:   Jeff Layton <jlayton@kernel.org>
To:     Xiubo Li <xiubli@redhat.com>
Cc:     idryomov@gmail.com, ukernel@gmail.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org
Date:   Tue, 07 Sep 2021 16:58:52 -0400
In-Reply-To: <71db1836-4f1e-1c3d-077a-018bff32f60d@redhat.com>
References: <20210903081510.982827-1-xiubli@redhat.com>
         <02f2f77423ec1e6e5b23b452716b21c36a5b67da.camel@kernel.org>
         <71db1836-4f1e-1c3d-077a-018bff32f60d@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.4 (3.40.4-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2021-09-07 at 21:19 +0800, Xiubo Li wrote:
> On 9/7/21 8:35 PM, Jeff Layton wrote:
> > On Fri, 2021-09-03 at 16:15 +0800, xiubli@redhat.com wrote:
> > > From: Xiubo Li <xiubli@redhat.com>
> > > 
> > > This patch series is based Jeff's ceph-fscrypt-size-experimental
> > > branch in https://git.kernel.org/pub/scm/linux/kernel/git/jlayton/linux.git.
> > > 
> > > This is just a draft patch and need to rebase or recode after Jeff
> > > finished his huge patch set.
> > > 
> > > Post the patch out for advices and ideas. Thanks.
> > > 
> > I'll take a look. Going forward though, it'd probably be best for you to
> > just take over development of the entire ceph-fscrypt-size series
> > instead of trying to develop on top of my branch.
> > 
> > That branch is _very_ rough anyway. Just clone the branch into your tree
> > and then you can drop or change patches in it as you see fit.
> 
> Sure.
> 
> 
> > > ====
> > > 
> > > This approach will not do the rmw immediately after the file is
> > > truncated. If the truncate size is aligned to the BLOCK SIZE, so
> > > there no need to do the rmw and only in unaligned case will the
> > > rmw is needed.
> > > 
> > > And the 'fscrypt_file' field will be cleared after the rmw is done.
> > > If the 'fscrypt_file' is none zero that means after the kclient
> > > reading that block to local buffer or pagecache it needs to do the
> > > zeroing of that block in range of [fscrypt_file, round_up(fscrypt_file,
> > > BLOCK SIZE)).
> > > 
> > > Once any kclient has dirty that block and write it back to ceph, the
> > > 'fscrypt_file' field will be cleared and set to 0. More detail please
> > > see the commit comments in the second patch.
> > > 
> > That sounds odd. How do you know where the file ends once you zero out
> > fscrypt_file?
> > 
> > /me goes to look at the patches...
> 
> The code in the ceph_fill_inode() is not handling well for multiple 
> ftruncates case, need to be fixed.
> 

Ok. It'd probably be best to do that fix first in a separate patch and
do the fscrypt work on top.

FWIW, I'd really like to see the existing truncate code simplified (or
at least, better documented). I'm very leery of adding yet more fields
to the inode to handle truncate/size. So far, we have all of this:

        struct mutex i_truncate_mutex;
        u32 i_truncate_seq;        /* last truncate to smaller size */
        u64 i_truncate_size;       /*  and the size we last truncated down to */
        int i_truncate_pending;    /*  still need to call vmtruncate */

        u64 i_max_size;            /* max file size authorized by mds */
        u64 i_reported_size; /* (max_)size reported to or requested of mds */
        u64 i_wanted_max_size;     /* offset we'd like to write too */
        u64 i_requested_max_size;  /* max_size we've requested */

Your patchset adds yet another new field with its own logic. I think we
need to aim to simplify this code rather than just piling more logic on
top.

> Maybe we need to change the 'fscrypt_file' field's logic and make it 
> opaqueness for MDS, then the MDS will use it to do the truncate instead 
> as I mentioned in the previous reply in your patch set.
> 
> Then we can do the defer rmw in any kclient when necessary as this patch 
> does.
> 

I think you can't defer the rmw unless you have Fb caps. In that case,
you'd probably want to just truncate it in the pagecache, dirty the last
page in the inode, and issue the truncate to the MDS.

In the case where you don't have Fb caps, then I think you don't want to
defer anything, as you can't guarantee another client won't get in there
to read the object. On a truncate, you'll want to issue the truncate to
the MDS and do the RMW on the last page. I'm not sure what order you'd
want to do that in though. Maybe you can issue them simultaneously?

> > 
> > > There also need on small work in Jeff's MDS PR in cap flushing code
> > > to clear the 'fscrypt_file'.
> > > 
> > > 
> > > Xiubo Li (2):
> > >    Revert "ceph: make client zero partial trailing block on truncate"
> > >    ceph: truncate the file contents when needed when file scrypted
> > > 
> > >   fs/ceph/addr.c  | 19 ++++++++++++++-
> > >   fs/ceph/caps.c  | 24 ++++++++++++++++++
> > >   fs/ceph/file.c  | 65 ++++++++++++++++++++++++++++++++++++++++++++++---
> > >   fs/ceph/inode.c | 48 +++++++++++++++++++-----------------
> > >   fs/ceph/super.h | 13 +++++++---
> > >   5 files changed, 138 insertions(+), 31 deletions(-)
> > > 
> 

-- 
Jeff Layton <jlayton@kernel.org>

