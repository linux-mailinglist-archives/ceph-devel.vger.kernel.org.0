Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FC30504EDD
	for <lists+ceph-devel@lfdr.de>; Mon, 18 Apr 2022 12:30:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235579AbiDRKc0 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 18 Apr 2022 06:32:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbiDRKcZ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 18 Apr 2022 06:32:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D88E7D7
        for <ceph-devel@vger.kernel.org>; Mon, 18 Apr 2022 03:29:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 91C07B80EBE
        for <ceph-devel@vger.kernel.org>; Mon, 18 Apr 2022 10:29:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFDC5C385A7;
        Mon, 18 Apr 2022 10:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650277783;
        bh=u4y5IYuHBTqhOJceiJ7UglYeZosrCJGQdywJ+zcxgVE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ninQIe3ASQwOUYCUSbp2LIU88tyRgZ9xhtHFCIP8ZD8PN/WMv8rTLjoEvcTOrSBQk
         hMPet/Y+2PU7xXYi7B4jftB6UPfyu7HmSGozoHMHLx0QX0buKBEE+YUqTbua47Fwhr
         DI2cjuSVDa39fCx4QJprPDoBLWjYDB0/bbrduc5oeRsyi3rEDssPcR6JYjn3rs67os
         Orh1bQR3m7d7WIN+3T1FZK5mhReNbjWpn9WGVRC9nmW1Wk20RhpbG2puB4AnWsmTHn
         lT4nS9COtPMoTP2K5F1lu1Y585d6pN3icHz8Hcr8SYaCTDwGFuMBn+fz2QgDNwVms4
         H5aWWBANLpJFw==
Message-ID: <d57a0fd93e18d065a0deb3c82dc43595e67b2326.camel@kernel.org>
Subject: Re: [RFC resend PATCH] ceph: fix statx AT_STATX_DONT_SYNC vs
 AT_STATX_FORCE_SYNC check
From:   Jeff Layton <jlayton@kernel.org>
To:     Xiubo Li <xiubli@redhat.com>
Cc:     idryomov@gmail.com, vshankar@redhat.com, dhowells@redhat.com,
        ceph-devel@vger.kernel.org
Date:   Mon, 18 Apr 2022 06:29:41 -0400
In-Reply-To: <b38b37bc-faa7-cbae-ce3a-f10c0818a293@redhat.com>
References: <20220411093405.301667-1-xiubli@redhat.com>
         <c013aafd233d4ec303238425b11f6c96c8a3b7a7.camel@kernel.org>
         <b38b37bc-faa7-cbae-ce3a-f10c0818a293@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2022-04-18 at 18:25 +0800, Xiubo Li wrote:
> On 4/18/22 6:15 PM, Jeff Layton wrote:
> > On Mon, 2022-04-11 at 17:34 +0800, xiubli@redhat.com wrote:
> > > From: Xiubo Li <xiubli@redhat.com>
> > > 
> > >  From the posix and the initial statx supporting commit comments,
> > > the AT_STATX_DONT_SYNC is a lightweight stat flag and the
> > > AT_STATX_FORCE_SYNC is a heaverweight one. And also checked all
> > > the other current usage about these two flags they are all doing
> > > the same, that is only when the AT_STATX_FORCE_SYNC is not set
> > > and the AT_STATX_DONT_SYNC is set will they skip sync retriving
> > > the attributes from storage.
> > > 
> > > Signed-off-by: Xiubo Li <xiubli@redhat.com>
> > > ---
> > >   fs/ceph/inode.c | 2 +-
> > >   1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> > > index 6788a1f88eb6..1ee6685def83 100644
> > > --- a/fs/ceph/inode.c
> > > +++ b/fs/ceph/inode.c
> > > @@ -2887,7 +2887,7 @@ int ceph_getattr(struct user_namespace *mnt_userns, const struct path *path,
> > >   		return -ESTALE;
> > >   
> > >   	/* Skip the getattr altogether if we're asked not to sync */
> > > -	if (!(flags & AT_STATX_DONT_SYNC)) {
> > > +	if ((flags & AT_STATX_SYNC_TYPE) != AT_STATX_DONT_SYNC) {
> > >   		err = ceph_do_getattr(inode,
> > >   				statx_to_caps(request_mask, inode->i_mode),
> > >   				flags & AT_STATX_FORCE_SYNC);
> > I don't get it.
> > 
> > The only way I can see that this is a problem is if someone sent down a
> > mask with both DONT_SYNC and FORCE_SYNC set in it, and in that case I
> > don't see that ignoring FORCE_SYNC would be wrong...
> > 
> There has 3 cases for the flags:
> 
> case1: flags & AT_STATX_SYNC_TYPE == 0
> 
> case2: flags & AT_STATX_SYNC_TYPE == AT_STATX_DONT_SYNC
> 
> case3: flags & AT_STATX_SYNC_TYPE == AT_STATX_DONT_SYNC | 
> AT_STATX_FORCE_SYNC
> 
> 
> Only in case2, which is only the DONT_SYNC bit is set, will ignore 
> calling ceph_do_getattr() here. And for case3 it will ignore the 
> DONT_SYNC bit.
> 

Sure, but the patch doesn't functionally change the behavior of the
code. It may make the condition more idiomatic to read, but I don't
think there is a bug here.

-- 
Jeff Layton <jlayton@kernel.org>
