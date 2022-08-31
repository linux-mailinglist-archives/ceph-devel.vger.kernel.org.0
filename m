Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 461435A7FA6
	for <lists+ceph-devel@lfdr.de>; Wed, 31 Aug 2022 16:12:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231782AbiHaOMf (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 31 Aug 2022 10:12:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231873AbiHaOMd (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 31 Aug 2022 10:12:33 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CFB4D758E
        for <ceph-devel@vger.kernel.org>; Wed, 31 Aug 2022 07:12:29 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 9DCF822129;
        Wed, 31 Aug 2022 14:12:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1661955148; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Olfy/A/gw9+1f3HUDLTkM7EyvxscyoyVyDwvdZGc4so=;
        b=AG3Dw3jnPNraftJKEyLHLzR0M6Z8ufW+FLIoptNtk2fFXURbvy5DkBlFE9iMwvJm7Qe2cY
        pHmxEcA/XljPD5CQPhXKfB77e/9ICaP2Aor4xmjVnMsVzp3gHO0WVX5UTp5IDn+3UhWAKP
        w4zqj1jP0f41W2A3Imd7k6c9RsLcbgc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1661955148;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Olfy/A/gw9+1f3HUDLTkM7EyvxscyoyVyDwvdZGc4so=;
        b=vpOcroz/GmMEF1Ro73jx0yvZpdFAvvnlHtaolb6tFSWeAW0mqlJJJZlT7PjjEDPXfdjTsp
        ZgiemYS8WUbhkDDg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 497AB1332D;
        Wed, 31 Aug 2022 14:12:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id Od9sD0xsD2PmSgAAMHmgww
        (envelope-from <lhenriques@suse.de>); Wed, 31 Aug 2022 14:12:28 +0000
Received: from localhost (brahms.olymp [local])
        by brahms.olymp (OpenSMTPD) with ESMTPA id 5056e09a;
        Wed, 31 Aug 2022 14:13:18 +0000 (UTC)
Date:   Wed, 31 Aug 2022 15:13:18 +0100
From:   =?iso-8859-1?Q?Lu=EDs?= Henriques <lhenriques@suse.de>
To:     xiubli@redhat.com
Cc:     ceph-devel@vger.kernel.org, jlayton@kernel.org, idryomov@gmail.com,
        mchangir@redhat.com
Subject: Re: [PATCH v3] ceph: fail the open_by_handle_at() if the dentry is
 being unlinked
Message-ID: <Yw9sfh8pqVwu1t5n@suse.de>
References: <20220831021617.11058-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220831021617.11058-1-xiubli@redhat.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Aug 31, 2022 at 10:16:17AM +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> When unlinking a file the kclient will send a unlink request to MDS
> by holding the dentry reference, and then the MDS will return 2 replies,
> which are unsafe reply and a deferred safe reply.
> 
> After the unsafe reply received the kernel will return and succeed
> the unlink request to user space apps.
> 
> Only when the safe reply received the dentry's reference will be
> released. Or the dentry will only be unhashed from dcache. But when
> the open_by_handle_at() begins to open the unlinked files it will
> succeed.
> 
> The inode->i_count couldn't be used to check whether the inode is
> opened or not.
> 
> URL: https://tracker.ceph.com/issues/56524
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
> 
> V3:
> - The inode->i_count couldn't be correctly indicate that whether the
>   file is opened or not.
> 
> V2:
> - If the dentry was released and inode is evicted such as by dropping
>   the caches, it will allocate a new dentry, which is also unhashed.
> 
>  fs/ceph/export.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ceph/export.c b/fs/ceph/export.c
> index 0ebf2bd93055..8559990a59a5 100644
> --- a/fs/ceph/export.c
> +++ b/fs/ceph/export.c
> @@ -182,6 +182,7 @@ struct inode *ceph_lookup_inode(struct super_block *sb, u64 ino)
>  static struct dentry *__fh_to_dentry(struct super_block *sb, u64 ino)
>  {
>  	struct inode *inode = __lookup_inode(sb, ino);
> +	struct ceph_inode_info *ci = ceph_inode(inode);
>  	int err;
>  
>  	if (IS_ERR(inode))
> @@ -193,7 +194,7 @@ static struct dentry *__fh_to_dentry(struct super_block *sb, u64 ino)
>  		return ERR_PTR(err);
>  	}
>  	/* -ESTALE if inode as been unlinked and no file is open */
> -	if ((inode->i_nlink == 0) && (atomic_read(&inode->i_count) == 1)) {
> +	if ((inode->i_nlink == 0) && !__ceph_is_file_opened(ci)) {
>  		iput(inode);
>  		return ERR_PTR(-ESTALE);
>  	}
> -- 
> 2.36.0.rc1
> 

Thanks, this seems be correct.  I was able to reproduce this locally, and
I can confirm this patch fixes it.  (Although I had this fixed this in the
past with 878dabb64117 and at that time it looked like it was fixed too.)

Feel free to add my:

Tested-by: Luís Henriques <lhenriques@suse.de>
Reviewed-by: Luís Henriques <lhenriques@suse.de>

Cheers,
--
Luís
