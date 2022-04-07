Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16B534F83AC
	for <lists+ceph-devel@lfdr.de>; Thu,  7 Apr 2022 17:38:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237121AbiDGPkt (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 7 Apr 2022 11:40:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243034AbiDGPks (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 7 Apr 2022 11:40:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 140061CB36
        for <ceph-devel@vger.kernel.org>; Thu,  7 Apr 2022 08:38:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A1B2961E8C
        for <ceph-devel@vger.kernel.org>; Thu,  7 Apr 2022 15:38:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AAF1C385A0;
        Thu,  7 Apr 2022 15:38:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649345926;
        bh=yVECY6Twkfw2xPPhB9aEsdS95SaBGR7WjGxhFL6oyiU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Cuw/4aaY2NA1/tbqWBCLrQGeudGvj86xfKwv6wKGA4DDaNxEPRcrZ1ylNnkZbRTMV
         20r6wtWMyvkASANWhY23DXyVnrvfD2iJMvYymbi8i/fMNUkxhUNXAlXbOBJPrUOtmQ
         54qHd4e26K7qv4xE1XjVDkiA4PPFxAObPNIkA840AnwKkCJJqwDv6GLRA9qIt4OfMj
         rgsL8OtrFhwJRjnd54YhQUcPdq5VgD6u6Ua6WKU6sV2ynYqvswIBOzALdZk8mNvQcJ
         2n6Ropol3GCBzekh1+M1afRPwJqPbJuFJZLqs3YpVsQ9N0Bcj24eL391ZMpyV8twr0
         ZlqdCaWlsF7mQ==
Message-ID: <6439751daf27285f77239172a9bb5d5f0f80eede.camel@kernel.org>
Subject: Re: [PATCH 2/2] ceph: fix coherency issue when truncating file size
 for fscrypt
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, vshankar@redhat.com, lhenriques@suse.de,
        ceph-devel@vger.kernel.org
Date:   Thu, 07 Apr 2022 11:38:44 -0400
In-Reply-To: <3315c167cc44f38c4eb9ebe76685418e85c9b9f2.camel@kernel.org>
References: <20220407144112.8455-1-xiubli@redhat.com>
         <20220407144112.8455-3-xiubli@redhat.com>
         <3315c167cc44f38c4eb9ebe76685418e85c9b9f2.camel@kernel.org>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2022-04-07 at 11:33 -0400, Jeff Layton wrote:
> On Thu, 2022-04-07 at 22:41 +0800, xiubli@redhat.com wrote:
> > From: Xiubo Li <xiubli@redhat.com>
> > 
> > When truncating the file size the MDS will help update the last
> > encrypted block, and during this we need to make sure the client
> > won't fill the pagecaches.
> > 
> > Signed-off-by: Xiubo Li <xiubli@redhat.com>
> > ---
> >  fs/ceph/inode.c | 7 ++++++-
> >  1 file changed, 6 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> > index f4059d73edd5..cc1829ab497d 100644
> > --- a/fs/ceph/inode.c
> > +++ b/fs/ceph/inode.c
> > @@ -2647,9 +2647,12 @@ int __ceph_setattr(struct inode *inode, struct iattr *attr, struct ceph_iattr *c
> >  		req->r_num_caps = 1;
> >  		req->r_stamp = attr->ia_ctime;
> >  		if (fill_fscrypt) {
> > +			filemap_invalidate_lock(inode->i_mapping);
> >  			err = fill_fscrypt_truncate(inode, req, attr);
> > -			if (err)
> > +			if (err) {
> > +				filemap_invalidate_unlock(inode->i_mapping);
> >  				goto out;
> > +			}
> >  		}
> >  
> >  		/*
> > @@ -2660,6 +2663,8 @@ int __ceph_setattr(struct inode *inode, struct iattr *attr, struct ceph_iattr *c
> >  		 * it.
> >  		 */
> >  		err = ceph_mdsc_do_request(mdsc, NULL, req);
> > +		if (fill_fscrypt)
> > +			filemap_invalidate_unlock(inode->i_mapping);
> >  		if (err == -EAGAIN && truncate_retry--) {
> >  			dout("setattr %p result=%d (%s locally, %d remote), retry it!\n",
> >  			     inode, err, ceph_cap_string(dirtied), mask);
> 
> Looks reasonable. Is there any reason we shouldn't do this in the non-
> encrypted case too? I suppose it doesn't make as much difference in that
> case.
> 
> I'll plan to pull this and the other patch into the wip-fscrypt branch.
> Should I just fold them into your earlier patches?

OTOH...do we really need this? I'm not sure I understand the race you're
trying to prevent. Can you lay it out for me?

Thanks,
-- 
Jeff Layton <jlayton@kernel.org>
