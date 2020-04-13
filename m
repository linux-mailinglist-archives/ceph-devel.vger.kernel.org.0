Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C19C1A66E5
	for <lists+ceph-devel@lfdr.de>; Mon, 13 Apr 2020 15:23:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729823AbgDMNX3 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 13 Apr 2020 09:23:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:59700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729811AbgDMNXZ (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 13 Apr 2020 09:23:25 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F189E20692;
        Mon, 13 Apr 2020 13:23:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586784204;
        bh=gjigREEdR0uWPXgHF37OI+VTnWQu4EbqCcBLHxKoYM8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=gyK+jOuKsL2L3WGHuH3XpTbtdKz+Sb+WohCpBz31GXYtuXZ0H+X3bLYo9L2scrqdK
         9G0XoT4dd8EBS/Qvr2S3l9V+eJJQLm7t5VXZJU0xs2klLLuANvoT7H0WJxgdTTomLt
         DCwWXgQ1pXJ4wwzQXN2nXyQbOahtBibHmwU77BPk=
Message-ID: <55c47d66b579fcf5749376c73d681d0273095f6d.camel@kernel.org>
Subject: Re: [PATCH 1/2] ceph: have ceph_mdsc_free_path ignore ERR_PTR values
From:   Jeff Layton <jlayton@kernel.org>
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Sage Weil <sage@redhat.com>
Date:   Mon, 13 Apr 2020 09:23:22 -0400
In-Reply-To: <CAOi1vP9mZTShECrVVohuj4p=Yr+rWvWnXNY03c85CuO4fGNSyQ@mail.gmail.com>
References: <20200408142125.52908-1-jlayton@kernel.org>
         <20200408142125.52908-2-jlayton@kernel.org>
         <CAOi1vP99BbHFrrg+0HAbZrZV7DQ7EG7euTY6cbtdWajsdyN3jQ@mail.gmail.com>
         <ded1b71dcda70e3a249df21c294607dac6545694.camel@kernel.org>
         <CAOi1vP9mZTShECrVVohuj4p=Yr+rWvWnXNY03c85CuO4fGNSyQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2020-04-13 at 14:35 +0200, Ilya Dryomov wrote:
> On Mon, Apr 13, 2020 at 1:15 PM Jeff Layton <jlayton@kernel.org> wrote:
> > On Mon, 2020-04-13 at 10:09 +0200, Ilya Dryomov wrote:
> > > On Wed, Apr 8, 2020 at 4:21 PM Jeff Layton <jlayton@kernel.org> wrote:
> > > > This makes the error handling simpler in some callers, and fixes a
> > > > couple of bugs in the new async dirops callback code.
> > > > 
> > > > Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> > > > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > > > ---
> > > >  fs/ceph/debugfs.c    | 4 ----
> > > >  fs/ceph/mds_client.c | 6 ++----
> > > >  fs/ceph/mds_client.h | 2 +-
> > > >  3 files changed, 3 insertions(+), 9 deletions(-)
> > > > 
> > > > diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
> > > > index eebbce7c3b0c..3a198e40f100 100644
> > > > --- a/fs/ceph/debugfs.c
> > > > +++ b/fs/ceph/debugfs.c
> > > > @@ -83,8 +83,6 @@ static int mdsc_show(struct seq_file *s, void *p)
> > > >                 } else if (req->r_dentry) {
> > > >                         path = ceph_mdsc_build_path(req->r_dentry, &pathlen,
> > > >                                                     &pathbase, 0);
> > > > -                       if (IS_ERR(path))
> > > > -                               path = NULL;
> > > >                         spin_lock(&req->r_dentry->d_lock);
> > > >                         seq_printf(s, " #%llx/%pd (%s)",
> > > 
> > > Hi Jeff,
> > > 
> > > This ends up attempting to print an IS_ERR pointer as %s.
> > > 
> > > >                                    ceph_ino(d_inode(req->r_dentry->d_parent)),
> > > > @@ -102,8 +100,6 @@ static int mdsc_show(struct seq_file *s, void *p)
> > > >                 if (req->r_old_dentry) {
> > > >                         path = ceph_mdsc_build_path(req->r_old_dentry, &pathlen,
> > > >                                                     &pathbase, 0);
> > > > -                       if (IS_ERR(path))
> > > > -                               path = NULL;
> > > >                         spin_lock(&req->r_old_dentry->d_lock);
> > > >                         seq_printf(s, " #%llx/%pd (%s)",
> > > 
> > > Ditto.
> > > 
> > > It looks like in newer kernels printf copes with this and outputs
> > > "(efault)".  But anything older than 5.2 will crash.
> > > 
> > > Further, the code looks weird because ceph_mdsc_build_path() doesn't
> > > return NULL, but path is tested for NULL in the call to seq_printf().
> > > 
> > > Why not just follow the same approach as existing mdsc_show()?  It
> > > makes it clear that the error is handled and where the NULL pointer
> > > comes from.  This kind of "don't handle errors and rely on everything
> > > else being able to bail" approach is very fragile and hard to audit.
> > > 
> > 
> > I don't see a problem with having a "free" routine ignore IS_ERR values
> > just like it does NULL values. How about I just trim off the other
> > deltas in this patch? Something like this?
> 
> I think it encourages fragile code.  Less so than functions that
> return pointer, NULL or IS_ERR pointer, but still.  You yourself
> almost fell into one of these traps while editing debugfs.c ;)
> 

We'll have to agree to disagree here. Having a free routine ignore
ERR_PTR values seems perfectly reasonable to me.

> That said, I won't stand in the way here.  If you trim off everything
> else, merge it together with the other patch so that it is introduced
> along with the two users.
> 

Do you mean that I should merge it with this?

    ceph: initialize base and pathlen variables in async dirops cb's

I'm not sure I see the point in that.

In any case, I pushed the updated patch into ceph-client/testing so let
me know if you see anything else amiss with it.

Thanks,
-- 
Jeff Layton <jlayton@kernel.org>

