Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07BFF58D8F2
	for <lists+ceph-devel@lfdr.de>; Tue,  9 Aug 2022 14:52:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243260AbiHIMwb (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 9 Aug 2022 08:52:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243251AbiHIMw3 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 9 Aug 2022 08:52:29 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DA506384
        for <ceph-devel@vger.kernel.org>; Tue,  9 Aug 2022 05:52:27 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 02D8A37333;
        Tue,  9 Aug 2022 12:52:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1660049546; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=02Dei3usVNbRsN5TMAc8Z5ofdWuNbAYMlJ9CIrKLzto=;
        b=C1M8LpoTVngII3pWJjvTNVX1Trwc6RZREPkrSorsUnQrhZ0GndTDWNbJKRArf5hlVldwv6
        I1pRTwmyqVtrrGV4vzf718orcrBc9ZUHb9Aq82Rekq32IpImpV7AVPeGOmlKPrxiUEV1YT
        u1h6ixk6UV3ern7KoiWnjhn1XxHUtU8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1660049546;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=02Dei3usVNbRsN5TMAc8Z5ofdWuNbAYMlJ9CIrKLzto=;
        b=Cy2yTVs92n6B3ZSpLsRpYw1RpQdBugnNzfzvtoX5QoJbngh2Dl89nQY/ceMe9HSF6/Wdkj
        hSy2MDtFcGmAk/Cg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id A274913AA1;
        Tue,  9 Aug 2022 12:52:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id KRaBJIlY8mIyHgAAMHmgww
        (envelope-from <lhenriques@suse.de>); Tue, 09 Aug 2022 12:52:25 +0000
Received: from localhost (brahms.olymp [local])
        by brahms.olymp (OpenSMTPD) with ESMTPA id f0f3a6df;
        Tue, 9 Aug 2022 12:53:11 +0000 (UTC)
Date:   Tue, 9 Aug 2022 13:53:11 +0100
From:   =?iso-8859-1?Q?Lu=EDs?= Henriques <lhenriques@suse.de>
To:     Xiubo Li <xiubli@redhat.com>
Cc:     ceph-devel@vger.kernel.org
Subject: Re: [PATCH v3] ceph: fail the request if the peer MDS doesn't
 support getvxattr op
Message-ID: <YvJYt7B9uLDLSVji@suse.de>
References: <20220808070823.707829-1-xiubli@redhat.com>
 <YvIx0bVHx676J953@suse.de>
 <5b26a327-b514-3fa3-835b-4dedee061166@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5b26a327-b514-3fa3-835b-4dedee061166@redhat.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Aug 09, 2022 at 06:16:36PM +0800, Xiubo Li wrote:
> 
> On 8/9/22 6:07 PM, Luís Henriques wrote:
> > On Mon, Aug 08, 2022 at 03:08:23PM +0800, xiubli@redhat.com wrote:
> > > From: Xiubo Li <xiubli@redhat.com>
> > > 
> > > Just fail the request instead sending the request out, or the peer
> > > MDS will crash.
> > > 
> > > URL: https://tracker.ceph.com/issues/56529
> > > Signed-off-by: Xiubo Li <xiubli@redhat.com>
> > > ---
> > >   fs/ceph/inode.c      |  1 +
> > >   fs/ceph/mds_client.c | 11 +++++++++++
> > >   fs/ceph/mds_client.h |  6 +++++-
> > >   3 files changed, 17 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> > > index 79ff197c7cc5..cfa0b550eef2 100644
> > > --- a/fs/ceph/inode.c
> > > +++ b/fs/ceph/inode.c
> > > @@ -2607,6 +2607,7 @@ int ceph_do_getvxattr(struct inode *inode, const char *name, void *value,
> > >   		goto out;
> > >   	}
> > > +	req->r_feature_needed = CEPHFS_FEATURE_OP_GETVXATTR;
> > >   	req->r_path2 = kstrdup(name, GFP_NOFS);
> > >   	if (!req->r_path2) {
> > >   		err = -ENOMEM;
> > > diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> > > index 598012ddc401..3e22783109ad 100644
> > > --- a/fs/ceph/mds_client.c
> > > +++ b/fs/ceph/mds_client.c
> > > @@ -2501,6 +2501,7 @@ ceph_mdsc_create_request(struct ceph_mds_client *mdsc, int op, int mode)
> > >   	INIT_LIST_HEAD(&req->r_unsafe_dir_item);
> > >   	INIT_LIST_HEAD(&req->r_unsafe_target_item);
> > >   	req->r_fmode = -1;
> > > +	req->r_feature_needed = -1;
> > >   	kref_init(&req->r_kref);
> > >   	RB_CLEAR_NODE(&req->r_node);
> > >   	INIT_LIST_HEAD(&req->r_wait);
> > > @@ -3255,6 +3256,16 @@ static void __do_request(struct ceph_mds_client *mdsc,
> > >   	dout("do_request mds%d session %p state %s\n", mds, session,
> > >   	     ceph_session_state_name(session->s_state));
> > > +
> > > +	/*
> > > +	 * The old ceph will crash the MDSs when see unknown OPs
> > > +	 */
> > > +	if (req->r_feature_needed > 0 &&
> > > +	    !test_bit(req->r_feature_needed, &session->s_features)) {
> > > +		err = -ENODATA;
> > > +		goto out_session;
> > > +	}
> > This patch looks good to me.  The only thing I would have preferred would
> > be to have ->r_feature_needed defined as an unsigned and initialised to
> > zero (instead of -1).  But that's me, so feel free to ignore this nit.
> 
> I am just following the 'test_bit()':
> 
>    9    132  include/asm-generic/bitops/instrumented-non-atomic.h
> <<test_bit>>
>              static inline bool test_bit(long nr, const volatile unsigned
> long *addr)
>   10    104  include/asm-generic/bitops/non-atomic.h <<test_bit>>
>              static inline int test_bit(int nr, const volatile unsigned long
> *addr)
> 
> Which is a signed type. If we use a unsigned, won't compiler complain about
> it ?
> 

Oh, yeah you're right.  And now that I think about it, I think I've been
there already in the past.  Sorry for the noise.

Cheers,
--
Luís

> BRs
> 
> -- Xiubo
> 
> > Cheers,
> > --
> > Luís
> > 
> > > +
> > >   	if (session->s_state != CEPH_MDS_SESSION_OPEN &&
> > >   	    session->s_state != CEPH_MDS_SESSION_HUNG) {
> > >   		/*
> > > diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
> > > index e15ee2858fef..728b7d72bf76 100644
> > > --- a/fs/ceph/mds_client.h
> > > +++ b/fs/ceph/mds_client.h
> > > @@ -31,8 +31,9 @@ enum ceph_feature_type {
> > >   	CEPHFS_FEATURE_METRIC_COLLECT,
> > >   	CEPHFS_FEATURE_ALTERNATE_NAME,
> > >   	CEPHFS_FEATURE_NOTIFY_SESSION_STATE,
> > > +	CEPHFS_FEATURE_OP_GETVXATTR,
> > > -	CEPHFS_FEATURE_MAX = CEPHFS_FEATURE_NOTIFY_SESSION_STATE,
> > > +	CEPHFS_FEATURE_MAX = CEPHFS_FEATURE_OP_GETVXATTR,
> > >   };
> > >   #define CEPHFS_FEATURES_CLIENT_SUPPORTED {	\
> > > @@ -45,6 +46,7 @@ enum ceph_feature_type {
> > >   	CEPHFS_FEATURE_METRIC_COLLECT,		\
> > >   	CEPHFS_FEATURE_ALTERNATE_NAME,		\
> > >   	CEPHFS_FEATURE_NOTIFY_SESSION_STATE,	\
> > > +	CEPHFS_FEATURE_OP_GETVXATTR,		\
> > >   }
> > >   /*
> > > @@ -352,6 +354,8 @@ struct ceph_mds_request {
> > >   	long long	  r_dir_ordered_cnt;
> > >   	int		  r_readdir_cache_idx;
> > > +	int		  r_feature_needed;
> > > +
> > >   	struct ceph_cap_reservation r_caps_reservation;
> > >   };
> > > -- 
> > > 2.36.0.rc1
> > > 
> 

