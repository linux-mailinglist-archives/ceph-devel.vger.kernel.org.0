Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF9721791E7
	for <lists+ceph-devel@lfdr.de>; Wed,  4 Mar 2020 15:05:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728278AbgCDOF3 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 4 Mar 2020 09:05:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:42340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726378AbgCDOF2 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 4 Mar 2020 09:05:28 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 273AD20838;
        Wed,  4 Mar 2020 14:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583330728;
        bh=fEYtYdgN1S6OLMryzFOrCtOvyaVdUAonfqkGGp3ky3w=;
        h=Subject:From:To:Date:In-Reply-To:References:From;
        b=FhlvD+TYOjxS2rXhGSfNNRGK8BTp0AglqDm5OphbILFmkLCvvIyI4dlcKi3rDSv0b
         3xIkr5zpLfsqVFoUIppyZa9sVnF1RyN6ej14LlaHkRvz6G//8X+3u00n+D5CpBRMFi
         7bH6CUF3pOHV639/K8Ic3bn+2ztj1m2bIEVS8qQc=
Message-ID: <29ed368fce6cb62f2bbc9b5d181eacf2cdf990bb.camel@kernel.org>
Subject: Re: [PATCH] mds: update dentry lease for async create
From:   Jeff Layton <jlayton@kernel.org>
To:     "Yan, Zheng" <zyan@redhat.com>, ceph-devel@vger.kernel.org
Date:   Wed, 04 Mar 2020 09:05:27 -0500
In-Reply-To: <88afc25efd69e9d07df88bb2efbc3e989e14fd9a.camel@kernel.org>
References: <20200304132220.41238-1-zyan@redhat.com>
         <88afc25efd69e9d07df88bb2efbc3e989e14fd9a.camel@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2020-03-04 at 08:55 -0500, Jeff Layton wrote:
> On Wed, 2020-03-04 at 21:22 +0800, Yan, Zheng wrote:
> > Otherwise ceph_d_delete() may return 1 for the dentry, which makes
> > dput() prune the dentry and clear parent dir's complete flag.
> > 
> > Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
> > ---
> >  fs/ceph/file.c | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> > index 53321bf517c2..671b141aedfe 100644
> > --- a/fs/ceph/file.c
> > +++ b/fs/ceph/file.c
> > @@ -480,6 +480,9 @@ static int try_prep_async_create(struct inode *dir, struct dentry *dentry,
> >  	if (d_in_lookup(dentry)) {
> >  		if (!__ceph_dir_is_complete(ci))
> >  			goto no_async;
> > +		spin_lock(&dentry->d_lock);
> > +		di->lease_shared_gen = atomic_read(&ci->i_shared_gen);
> > +		spin_unlock(&dentry->d_lock);
> >  	} else if (atomic_read(&ci->i_shared_gen) !=
> >  		   READ_ONCE(di->lease_shared_gen)) {
> >  		goto no_async;
> 
> Good catch, merged into testing (with small update to changelog
> s/mds:/ceph:/)
> 

One related comment though. This patch implies that lease_shared_gen is
protected by the d_lock, but it's not held when it's assigned in
ceph_lookup. Should it be?

-- 
Jeff Layton <jlayton@kernel.org>

