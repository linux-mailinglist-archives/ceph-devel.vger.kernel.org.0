Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 402C5210A94
	for <lists+ceph-devel@lfdr.de>; Wed,  1 Jul 2020 13:55:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730428AbgGALzi (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 1 Jul 2020 07:55:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:45696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730419AbgGALzi (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 1 Jul 2020 07:55:38 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A7A7120663;
        Wed,  1 Jul 2020 11:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593604538;
        bh=8TjhVBMmXyYjX5+wdLyA3SliomAugWJUaiJlLXDO4Vw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=fDzxbTcFKgULtdLHtO0PTQGJ4GExc4stCljPljBv8F/tkjozhD1J1QRV8KCuQev32
         72Z6Mow+VINI7HCwwj0eOXZGHpMJoQBxuzCwPAJnye2qB/u1vg5iNXBXgL317GHGPf
         HkiOXE+j8MeCC0nEqe+6xPpUL7M07wIGZO7Fv/F4=
Message-ID: <ad6ab748fa35d34f14486cd69389fc44eb373ce7.camel@kernel.org>
Subject: Re: [PATCH 1/3] ceph: fix potential mdsc use-after-free crash
From:   Jeff Layton <jlayton@kernel.org>
To:     Xiubo Li <xiubli@redhat.com>
Cc:     idryomov@gmail.com, zyan@redhat.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org
Date:   Wed, 01 Jul 2020 07:55:36 -0400
In-Reply-To: <daef4fc2-b206-d1cb-5946-2b97a2062628@redhat.com>
References: <1593582768-2954-1-git-send-email-xiubli@redhat.com>
         <c586bbc39a666391c86be355b5c7cb32a5baa532.camel@kernel.org>
         <daef4fc2-b206-d1cb-5946-2b97a2062628@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.3 (3.36.3-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2020-07-01 at 19:25 +0800, Xiubo Li wrote:
> On 2020/7/1 19:17, Jeff Layton wrote:
> > On Wed, 2020-07-01 at 01:52 -0400, xiubli@redhat.com wrote:
> > > From: Xiubo Li <xiubli@redhat.com>
> > > 
> > > Make sure the delayed work stopped before releasing the resources.
> > > 
> > > Because the cancel_delayed_work_sync() will only guarantee that the
> > > work finishes executing if the work is already in the ->worklist.
> > > That means after the cancel_delayed_work_sync() returns and in case
> > > if the work will re-arm itself, it will leave the work requeued. And
> > > if we release the resources before the delayed work to run again we
> > > will hit the use-after-free bug.
> > > 
> > > URL: https://tracker.ceph.com/issues/46293
> > > Signed-off-by: Xiubo Li <xiubli@redhat.com>
> > > ---
> > >   fs/ceph/mds_client.c | 14 +++++++++++++-
> > >   1 file changed, 13 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> > > index d5e523c..9a09d12 100644
> > > --- a/fs/ceph/mds_client.c
> > > +++ b/fs/ceph/mds_client.c
> > > @@ -4330,6 +4330,9 @@ static void delayed_work(struct work_struct *work)
> > >   
> > >   	dout("mdsc delayed_work\n");
> > >   
> > > +	if (mdsc->stopping)
> > > +		return;
> > > +
> > >   	mutex_lock(&mdsc->mutex);
> > >   	renew_interval = mdsc->mdsmap->m_session_timeout >> 2;
> > >   	renew_caps = time_after_eq(jiffies, HZ*renew_interval +
> > > @@ -4689,7 +4692,16 @@ void ceph_mdsc_force_umount(struct ceph_mds_client *mdsc)
> > >   static void ceph_mdsc_stop(struct ceph_mds_client *mdsc)
> > >   {
> > >   	dout("stop\n");
> > > -	cancel_delayed_work_sync(&mdsc->delayed_work); /* cancel timer */
> > > +	/*
> > > +	 * Make sure the delayed work stopped before releasing
> > > +	 * the resources.
> > > +	 *
> > > +	 * Because the cancel_delayed_work_sync() will only
> > > +	 * guarantee that the work finishes executing. But the
> > > +	 * delayed work will re-arm itself again after that.
> > > +	 */
> > > +	flush_delayed_work(&mdsc->delayed_work);
> > > +
> > >   	if (mdsc->mdsmap)
> > >   		ceph_mdsmap_destroy(mdsc->mdsmap);
> > >   	kfree(mdsc->sessions);
> > This patch looks fine, but the subject says [PATCH 1/3]. Were there
> > others in this series that didn't make it to the list for some reason?
> 
> Sorry for confusing.
> 
> Just generated this patch with the metrics series and forget to fix it 
> before sending out.
> 
> 

No worries. Just making sure before I merged it. Merged patch into
testing branch.

Thanks!
-- 
Jeff Layton <jlayton@kernel.org>

