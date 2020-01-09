Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77B671357CA
	for <lists+ceph-devel@lfdr.de>; Thu,  9 Jan 2020 12:20:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730577AbgAILUT (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 9 Jan 2020 06:20:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:34978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728918AbgAILUT (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 9 Jan 2020 06:20:19 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0CED520656;
        Thu,  9 Jan 2020 11:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578568818;
        bh=kQNJUQqhxASlU5ZW/KdxN9EWZZTmABkY19wusfPxHAs=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=tcLY+HcGN8MkvbVTPvVbxMJmNq3Uyvyd5bX7L7d/rFwlMnEh6rJJTfQrlFm//5AwN
         /mNus4UJcNSMGJCkcCzyci+d0feXV6aEcJPWN3fNqQDyhbWKbBjA+FV/2LJ2sulLCO
         Z+ebzC+Pi3vtdOQLhYpbeowgq+SH+OM2J8+Yj60I=
Message-ID: <7baad50a9e9f8d8f93171e5d4756bc35ab36a319.camel@kernel.org>
Subject: Re: [PATCH 2/6] ceph: hold extra reference to r_parent over life of
 request
From:   Jeff Layton <jlayton@kernel.org>
To:     Xiubo Li <xiubli@redhat.com>, ceph-devel@vger.kernel.org
Cc:     sage@redhat.com, idryomov@gmail.com, zyan@redhat.com,
        pdonnell@redhat.com
Date:   Thu, 09 Jan 2020 06:20:17 -0500
In-Reply-To: <e8e28503-bda4-df57-6a42-33761e716fe4@redhat.com>
References: <20200106153520.307523-1-jlayton@kernel.org>
         <20200106153520.307523-3-jlayton@kernel.org>
         <e8e28503-bda4-df57-6a42-33761e716fe4@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.2 (3.34.2-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2020-01-09 at 10:05 +0800, Xiubo Li wrote:
> On 2020/1/6 23:35, Jeff Layton wrote:
> > Currently, we just assume that it will stick around by virtue of the
> > submitter's reference, but later patches will allow the syscall to
> > return early and we can't rely on that reference at that point.
> > 
> > Take an extra reference to the inode when setting r_parent and release
> > it when releasing the request.
> > 
> > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > ---
> >   fs/ceph/mds_client.c | 8 ++++++--
> >   1 file changed, 6 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> > index 94cce2ab92c4..b7122f682678 100644
> > --- a/fs/ceph/mds_client.c
> > +++ b/fs/ceph/mds_client.c
> > @@ -708,8 +708,10 @@ void ceph_mdsc_release_request(struct kref *kref)
> >   		/* avoid calling iput_final() in mds dispatch threads */
> >   		ceph_async_iput(req->r_inode);
> >   	}
> > -	if (req->r_parent)
> > +	if (req->r_parent) {
> >   		ceph_put_cap_refs(ceph_inode(req->r_parent), CEPH_CAP_PIN);
> > +		ceph_async_iput(req->r_parent);
> > +	}
> >   	ceph_async_iput(req->r_target_inode);
> >   	if (req->r_dentry)
> >   		dput(req->r_dentry);
> > @@ -2706,8 +2708,10 @@ int ceph_mdsc_submit_request(struct ceph_mds_client *mdsc, struct inode *dir,
> >   	/* take CAP_PIN refs for r_inode, r_parent, r_old_dentry */
> >   	if (req->r_inode)
> >   		ceph_get_cap_refs(ceph_inode(req->r_inode), CEPH_CAP_PIN);
> > -	if (req->r_parent)
> > +	if (req->r_parent) {
> >   		ceph_get_cap_refs(ceph_inode(req->r_parent), CEPH_CAP_PIN);
> > +		ihold(req->r_parent);
> > +	}
> 
> This might also fix another issue when the mdsc request is timedout and 
> returns to the vfs, then the r_parent maybe released in vfs. And then if 
> we reference it again in mdsc handle_reply() --> 
> ceph_mdsc_release_request(),  some unknown issues may happen later ??
> 

AIUI, when a timeout occurs, the req is unhashed such that handle_reply
can't find it. So, I doubt this affects that one way or another.

> >   	if (req->r_old_dentry_dir)
> >   		ceph_get_cap_refs(ceph_inode(req->r_old_dentry_dir),
> >   				  CEPH_CAP_PIN);
> 
> 

-- 
Jeff Layton <jlayton@kernel.org>

