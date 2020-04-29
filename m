Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABDF81BE2C9
	for <lists+ceph-devel@lfdr.de>; Wed, 29 Apr 2020 17:31:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726689AbgD2Pbs (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 29 Apr 2020 11:31:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:54526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726456AbgD2Pbs (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 29 Apr 2020 11:31:48 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B9DD9206F0;
        Wed, 29 Apr 2020 15:31:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588174307;
        bh=cz2GRQMmobQIU8Dm3XppVkcHbEvwo+MsQ2UDSbo/Nso=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=JkiBRNRGIihwWrIm7TmLD0OHzJ1ywldClvr5mPhqCfN0nC7742gsdK+I5GDPzQViw
         PhW1LWaxV9f/D8CO1eAIuZuPmo4zJ0vJficejaMQRYM6sY/v9nAw4EbCN5R5WUEwd2
         w/7UhV7fM+0Rki5Soiw+9Xuku8QviaYrXSBJ7MBE=
Message-ID: <018c93fd12244f173ede8e6f4e9f453cbb447bff.camel@kernel.org>
Subject: Re: [PATCH V2] fs/ceph:fix double unlock in handle_cap_export()
From:   Jeff Layton <jlayton@kernel.org>
To:     Wu Bo <wubo40@huawei.com>, sage@redhat.com, idryomov@gmail.com,
        "Yan, Zheng" <ukernel@gmail.com>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        liuzhiqiang26@huawei.com, linfeilong@huawei.com
Date:   Wed, 29 Apr 2020 11:31:45 -0400
In-Reply-To: <6c99072a-f92b-b7e8-9aef-509d1a9ee985@huawei.com>
References: <1588079622-423774-1-git-send-email-wubo40@huawei.com>
         <e89bd817c69422c85f1945041dd83fbe8d534805.camel@kernel.org>
         <6c99072a-f92b-b7e8-9aef-509d1a9ee985@huawei.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.1 (3.36.1-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2020-04-29 at 08:46 +0800, Wu Bo wrote:
> On 2020/4/28 22:48, Jeff Layton wrote:
> > On Tue, 2020-04-28 at 21:13 +0800, Wu Bo wrote:
> > > if the ceph_mdsc_open_export_target_session() return fails,
> > > should add a lock to avoid twice unlocking.
> > > Because the lock will be released at the retry or out_unlock tag.
> > > 
> > 
> > The problem looks real, but...
> > 
> > > --
> > > v1 -> v2:
> > > add spin_lock(&ci->i_ceph_lock) before goto out_unlock tag.
> > > 
> > > Signed-off-by: Wu Bo <wubo40@huawei.com>
> > > ---
> > >   fs/ceph/caps.c | 27 +++++++++++++++------------
> > >   1 file changed, 15 insertions(+), 12 deletions(-)
> > > 
> > > diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> > > index 185db76..414c0e2 100644
> > > --- a/fs/ceph/caps.c
> > > +++ b/fs/ceph/caps.c
> > > @@ -3731,22 +3731,25 @@ static void handle_cap_export(struct inode *inode, struct ceph_mds_caps *ex,
> > >   
> > >   	/* open target session */
> > >   	tsession = ceph_mdsc_open_export_target_session(mdsc, target);
> > > -	if (!IS_ERR(tsession)) {
> > > -		if (mds > target) {
> > > -			mutex_lock(&session->s_mutex);
> > > -			mutex_lock_nested(&tsession->s_mutex,
> > > -					  SINGLE_DEPTH_NESTING);
> > > -		} else {
> > > -			mutex_lock(&tsession->s_mutex);
> > > -			mutex_lock_nested(&session->s_mutex,
> > > -					  SINGLE_DEPTH_NESTING);
> > > -		}
> > > -		new_cap = ceph_get_cap(mdsc, NULL);
> > > -	} else {
> > > +	if (IS_ERR(tsession)) {
> > >   		WARN_ON(1);
> > >   		tsession = NULL;
> > >   		target = -1;
> > > +		mutex_lock(&session->s_mutex);
> > > +		spin_lock(&ci->i_ceph_lock);

Rather than taking the spinlock here, it'd be nicer to set a new label
above the mutex (out_unlock_mutex or something) and jump to that.

> > > +		goto out_unlock;
> > 
> > Why did you make this case goto out_unlock instead of retrying as it did
> > before?
> > 
> 
> If the problem occurs, target = -1, and goto retry lable, you need to 
> call __get_cap_for_mds() or even call __ceph_remove_cap(), and then jump 
> to out_unlock lable. All I think is unnecessary, goto out_unlock instead 
> of retrying directly.
> 

(cc'ing Zheng since he understands the IMPORT/EXPORT code better than I)

I'm not quite convinced. It certainly looks like this was done
deliberately before, and that the expectation is that the cap be removed
in this case.

If we do want to make this change, then at the very least the changelog
needs to spell out why this safe and desirable.

> > > +	}
> > > +
> > > +	if (mds > target) {
> > > +		mutex_lock(&session->s_mutex);
> > > +		mutex_lock_nested(&tsession->s_mutex,
> > > +					SINGLE_DEPTH_NESTING);
> > > +	} else {
> > > +		mutex_lock(&tsession->s_mutex);
> > > +		mutex_lock_nested(&session->s_mutex,
> > > +					SINGLE_DEPTH_NESTING);
> > >   	}
> > > +	new_cap = ceph_get_cap(mdsc, NULL);
> > >   	goto retry;
> > >   
> > >   out_unlock:
> 
> 

-- 
Jeff Layton <jlayton@kernel.org>

