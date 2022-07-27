Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99B235822AE
	for <lists+ceph-devel@lfdr.de>; Wed, 27 Jul 2022 11:04:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231233AbiG0JEh (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 27 Jul 2022 05:04:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231411AbiG0JEb (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 27 Jul 2022 05:04:31 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 470E5474D6
        for <ceph-devel@vger.kernel.org>; Wed, 27 Jul 2022 02:04:29 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 05F5837310;
        Wed, 27 Jul 2022 09:04:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1658912668; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HiXqxZ6xSextSiRhMHEoaMzGwm3BASvFP1i6I7Tq6aI=;
        b=eeZkNMkhhBIS+XkKmJJA9SXvX4PDlLQMXiAw3M65K8lcXx2n0N1pYANlphxPQ9KoRvlzFw
        JObkSuk+M/JaopaFdmLfn9qORJmZuqLFKs+zvEFdE4YFUJ7lwUBuKx2KWeC1kvtEfAR4il
        xl8+D5sieH/bxS6KGRj6WS2ICMrPOtk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1658912668;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HiXqxZ6xSextSiRhMHEoaMzGwm3BASvFP1i6I7Tq6aI=;
        b=Atfi5JgN9KcTjBfBJUVucoIwNkkglycpdReK2GqvIV8MYtB3TOSMUv1Df9bdPq9W0OazTw
        qF8lRHpvWG/p0gCQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id B75AF13A8E;
        Wed, 27 Jul 2022 09:04:27 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id C0LOKZv/4GJDQAAAMHmgww
        (envelope-from <lhenriques@suse.de>); Wed, 27 Jul 2022 09:04:27 +0000
Received: from localhost (brahms.olymp [local])
        by brahms.olymp (OpenSMTPD) with ESMTPA id 10983096;
        Wed, 27 Jul 2022 09:05:12 +0000 (UTC)
Date:   Wed, 27 Jul 2022 10:05:12 +0100
From:   =?iso-8859-1?Q?Lu=EDs?= Henriques <lhenriques@suse.de>
To:     xiubli@redhat.com
Cc:     ceph-devel@vger.kernel.org
Subject: Re: [PATCH] ceph: fall back to use old method to get xattr
Message-ID: <YuD/yDOwJaqg7q+X@suse.de>
References: <20220727055637.11949-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220727055637.11949-1-xiubli@redhat.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Jul 27, 2022 at 01:56:37PM +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> If the peer MDS doesn't support getvxattr op then just fall back to
> use old getattr method to get it. Or for the old MDSs they will crash
> when receive an unknown op.
> 
> URL: https://tracker.ceph.com/issues/56529
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/mds_client.c | 10 ++++++++++
>  fs/ceph/mds_client.h |  4 +++-
>  fs/ceph/xattr.c      |  9 ++++++---
>  3 files changed, 19 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 598012ddc401..bfe6d6393eba 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -3255,6 +3255,16 @@ static void __do_request(struct ceph_mds_client *mdsc,
>  
>  	dout("do_request mds%d session %p state %s\n", mds, session,
>  	     ceph_session_state_name(session->s_state));
> +
> +	/*
> +	 * The old ceph will crash the MDSs when see unknown OPs
> +	 */
> +	if (req->r_op == CEPH_MDS_OP_GETVXATTR &&
> +	    !test_bit(CEPHFS_FEATURE_OP_GETVXATTR, &session->s_features)) {
> +		err = -EOPNOTSUPP;
> +		goto out_session;
> +	}
> +
>  	if (session->s_state != CEPH_MDS_SESSION_OPEN &&
>  	    session->s_state != CEPH_MDS_SESSION_HUNG) {
>  		/*
> diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
> index e15ee2858fef..0e03efab872a 100644
> --- a/fs/ceph/mds_client.h
> +++ b/fs/ceph/mds_client.h
> @@ -31,8 +31,9 @@ enum ceph_feature_type {
>  	CEPHFS_FEATURE_METRIC_COLLECT,
>  	CEPHFS_FEATURE_ALTERNATE_NAME,
>  	CEPHFS_FEATURE_NOTIFY_SESSION_STATE,
> +	CEPHFS_FEATURE_OP_GETVXATTR,
>  
> -	CEPHFS_FEATURE_MAX = CEPHFS_FEATURE_NOTIFY_SESSION_STATE,
> +	CEPHFS_FEATURE_MAX = CEPHFS_FEATURE_OP_GETVXATTR,
>  };
>  
>  #define CEPHFS_FEATURES_CLIENT_SUPPORTED {	\
> @@ -45,6 +46,7 @@ enum ceph_feature_type {
>  	CEPHFS_FEATURE_METRIC_COLLECT,		\
>  	CEPHFS_FEATURE_ALTERNATE_NAME,		\
>  	CEPHFS_FEATURE_NOTIFY_SESSION_STATE,	\
> +	CEPHFS_FEATURE_OP_GETVXATTR,		\
>  }
>  
>  /*
> diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
> index b10d459c2326..8f8db621772a 100644
> --- a/fs/ceph/xattr.c
> +++ b/fs/ceph/xattr.c
> @@ -984,9 +984,12 @@ ssize_t __ceph_getxattr(struct inode *inode, const char *name, void *value,
>  		return err;
>  	} else {
>  		err = ceph_do_getvxattr(inode, name, value, size);
> -		/* this would happen with a new client and old server combo */
> +		/*
> +		 * This would happen with a new client and old server combo,
> +		 * then fall back to use old method to get it
> +		 */
>  		if (err == -EOPNOTSUPP)
> -			err = -ENODATA;
> +			goto handle_non_vxattrs;
>  		return err;

Nit: maybe just do:

		if (err != -EOPNOTSUPP)
			return err

instead of using a 'goto' statement.

>  	}
>  handle_non_vxattrs:
> @@ -996,7 +999,7 @@ ssize_t __ceph_getxattr(struct inode *inode, const char *name, void *value,
>  	dout("getxattr %p name '%s' ver=%lld index_ver=%lld\n", inode, name,
>  	     ci->i_xattrs.version, ci->i_xattrs.index_version);
>  
> -	if (ci->i_xattrs.version == 0 ||
> +	if (ci->i_xattrs.version == 0 || err == -EOPNOTSUPP ||

You'll need to initialise 'err' when declaring it.

Cheers,
--
Luís

>  	    !((req_mask & CEPH_CAP_XATTR_SHARED) ||
>  	      __ceph_caps_issued_mask_metric(ci, CEPH_CAP_XATTR_SHARED, 1))) {
>  		spin_unlock(&ci->i_ceph_lock);
> -- 
> 2.36.0.rc1
> 

