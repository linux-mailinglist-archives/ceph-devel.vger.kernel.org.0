Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B07A147EEF
	for <lists+ceph-devel@lfdr.de>; Fri, 24 Jan 2020 11:44:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731004AbgAXKoI (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 24 Jan 2020 05:44:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:51640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725843AbgAXKoI (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 24 Jan 2020 05:44:08 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C1EA32070A;
        Fri, 24 Jan 2020 10:44:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579862648;
        bh=GkaJheqMSuJOoBxNDBfKpMdQoYvm5HhvNxyJJtBFEUs=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=RnEcm0Q4hpXE6iYhAV7aBT3ofUL13OOW3Kq9DcQLUwJyJ/NUkkEkfKVlrbS+kYvAg
         2bw9ZPDfbwNv+GPdDnP9ae+vbiFuF+R/4x4N+BBvlzUu+fbsM6vYWeIN3eU0+XPYvR
         Ziif7xNikUPS32YPTCS9CdYyTXZa9gJ7S3m204aU=
Message-ID: <3170eaf909e7a007575150f04a3cfc1cc27e6408.camel@kernel.org>
Subject: Re: [bug report] ceph: perform asynchronous unlink if we have
 sufficient caps
From:   Jeff Layton <jlayton@kernel.org>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     ceph-devel@vger.kernel.org
Date:   Fri, 24 Jan 2020 05:44:06 -0500
In-Reply-To: <20200123172927.GD1870@kadam>
References: <20200123153031.o53tzem7bhedyubg@kili.mountain>
         <7ccd37a37f2f700bc648cafcd87784e85c784a31.camel@kernel.org>
         <20200123172927.GD1870@kadam>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.3 (3.34.3-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2020-01-23 at 20:29 +0300, Dan Carpenter wrote:
> On Thu, Jan 23, 2020 at 10:45:31AM -0500, Jeff Layton wrote:
> > On Thu, 2020-01-23 at 18:30 +0300, Dan Carpenter wrote:
> > > Hello Jeff Layton,
> > > 
> > > The patch d6566c62c529: "ceph: perform asynchronous unlink if we have
> > > sufficient caps" from Apr 2, 2019, leads to the following static
> > > checker warning:
> > > 
> > > 	fs/ceph/dir.c:1059 get_caps_for_async_unlink()
> > > 	error: uninitialized symbol 'got'.
> > > 
> > > fs/ceph/dir.c
> > >   1051  static bool get_caps_for_async_unlink(struct inode *dir, struct dentry *dentry)
> > >   1052  {
> > >   1053          struct ceph_inode_info *ci = ceph_inode(dir);
> > >   1054          struct ceph_dentry_info *di;
> > >   1055          int ret, want, got;
> > >   1056  
> > >   1057          want = CEPH_CAP_FILE_EXCL | CEPH_CAP_DIR_UNLINK;
> > >   1058          ret = ceph_try_get_caps(dir, 0, want, true, &got);
> > >   1059          dout("Fx on %p ret=%d got=%d\n", dir, ret, got);
> > >                                                            ^^^
> > > Uninitialized on error.
> > > 
> > >   1060          if (ret != 1 || got != want)
> > >   1061                  return false;
> > >   1062  
> > >   1063          spin_lock(&dentry->d_lock);
> > >   1064          di = ceph_dentry(dentry);
> > > 
> > 
> > Hi Dan,
> > 
> > This looks like a false positive to me?
> > 
> > On error, ret != 1, and got shouldn't matter in that case. If
> > ceph_try_get_caps does return 1 then "got" will be filled out.
> 
> It's complaining about the printk before the error handling.
> 
> regards,
> dan carpenter
> 

Ahh thanks, I'll fix that up!

Cheers,
-- 
Jeff Layton <jlayton@kernel.org>

