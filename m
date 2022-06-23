Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01CBB55780F
	for <lists+ceph-devel@lfdr.de>; Thu, 23 Jun 2022 12:43:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230159AbiFWKny (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 23 Jun 2022 06:43:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230125AbiFWKnw (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 23 Jun 2022 06:43:52 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1F9C4888E
        for <ceph-devel@vger.kernel.org>; Thu, 23 Jun 2022 03:43:50 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id A6EB31F96B;
        Thu, 23 Jun 2022 10:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1655981029; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vNwqOOHT5dBpJ8gTjplGaKFyVNzXa06qJPLCNM5DDXo=;
        b=Wg69b1ZK907KMrmd6kPlbeMStjTL00xXIoToCeydC3s1ebqLufaAD1Z82u8eutlVptLLr9
        /q5MW7Ui2n3/k8xft96lYk2Wr5S+OMPH3osnDeLJtgIGLHiYhe6UGHTIrNRep8LhFsEXXh
        BRnjN7G8uHfVckpaks2ozzo6vxqKH1s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1655981029;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vNwqOOHT5dBpJ8gTjplGaKFyVNzXa06qJPLCNM5DDXo=;
        b=GxWZ4N/ns5IUTpCDibgXlLWoT3jQaiOFYESVahKja6VAWKAk5VnpMeF15i/kBXTZPuM5Ok
        p0IVHCwRnOwBFZDg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 3422613461;
        Thu, 23 Jun 2022 10:43:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 9wJVCeVDtGK/TgAAMHmgww
        (envelope-from <lhenriques@suse.de>); Thu, 23 Jun 2022 10:43:49 +0000
Received: from localhost (brahms.olymp [local])
        by brahms.olymp (OpenSMTPD) with ESMTPA id 0949fc98;
        Thu, 23 Jun 2022 10:44:34 +0000 (UTC)
From:   =?utf-8?Q?Lu=C3=ADs_Henriques?= <lhenriques@suse.de>
To:     xiubli@redhat.com
Cc:     jlayton@kernel.org, idryomov@gmail.com, vshankar@redhat.com,
        pdonnell@redhat.com, ceph-devel@vger.kernel.org
Subject: Re: [PATCH] ceph: flush the dirty caps immediatelly when quota is
 approaching
References: <20220623095238.874126-1-xiubli@redhat.com>
Date:   Thu, 23 Jun 2022 11:44:34 +0100
In-Reply-To: <20220623095238.874126-1-xiubli@redhat.com> (xiubli@redhat.com's
        message of "Thu, 23 Jun 2022 17:52:38 +0800")
Message-ID: <87pmizk6b1.fsf@brahms.olymp>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

xiubli@redhat.com writes:

> From: Xiubo Li <xiubli@redhat.com>
>
> When the quota is approaching we need to notify it to the MDS as
> soon as possible, or the client could write to the directory more
> than expected.
>
> This will flush the dirty caps without delaying after each write,
> though this couldn't prevent the real size of a directory exceed
> the quota but could prevent it as soon as possible.

Nice, looks good.  Unfortunately, the real problem can't probably be
solved without a complete re-design of the cephfs quotas.  Oh well...

Reviewed-by: Lu=C3=ADs Henriques <lhenriques@suse.de>

Cheers,
--=20
Lu=C3=ADs

>
> URL: https://tracker.ceph.com/issues/56180
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/caps.c | 5 +++--
>  fs/ceph/file.c | 5 +++--
>  2 files changed, 6 insertions(+), 4 deletions(-)
>
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index c7163afdc71a..511d1963aa09 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -1979,14 +1979,15 @@ void ceph_check_caps(struct ceph_inode_info *ci, =
int flags,
>  	}
>=20=20
>  	dout("check_caps %llx.%llx file_want %s used %s dirty %s flushing %s"
> -	     " issued %s revoking %s retain %s %s%s\n", ceph_vinop(inode),
> +	     " issued %s revoking %s retain %s %s%s%s\n", ceph_vinop(inode),
>  	     ceph_cap_string(file_wanted),
>  	     ceph_cap_string(used), ceph_cap_string(ci->i_dirty_caps),
>  	     ceph_cap_string(ci->i_flushing_caps),
>  	     ceph_cap_string(issued), ceph_cap_string(revoking),
>  	     ceph_cap_string(retain),
>  	     (flags & CHECK_CAPS_AUTHONLY) ? " AUTHONLY" : "",
> -	     (flags & CHECK_CAPS_FLUSH) ? " FLUSH" : "");
> +	     (flags & CHECK_CAPS_FLUSH) ? " FLUSH" : "",
> +	     (flags & CHECK_CAPS_NOINVAL) ? " NOINVAL" : "");
>=20=20
>  	/*
>  	 * If we no longer need to hold onto old our caps, and we may
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index debc1748ccdf..0eb4a02175ad 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -1960,7 +1960,7 @@ static ssize_t ceph_write_iter(struct kiocb *iocb, =
struct iov_iter *from)
>  		if (dirty)
>  			__mark_inode_dirty(inode, dirty);
>  		if (ceph_quota_is_max_bytes_approaching(inode, iocb->ki_pos))
> -			ceph_check_caps(ci, 0, NULL);
> +			ceph_check_caps(ci, CHECK_CAPS_FLUSH, NULL);
>  	}
>=20=20
>  	dout("aio_write %p %llx.%llx %llu~%u  dropping cap refs on %s\n",
> @@ -2577,7 +2577,8 @@ static ssize_t __ceph_copy_file_range(struct file *=
src_file, loff_t src_off,
>  		/* Let the MDS know about dst file size change */
>  		if (ceph_inode_set_size(dst_inode, dst_off) ||
>  		    ceph_quota_is_max_bytes_approaching(dst_inode, dst_off))
> -			ceph_check_caps(dst_ci, CHECK_CAPS_AUTHONLY, NULL);
> +			ceph_check_caps(dst_ci, CHECK_CAPS_AUTHONLY | CHECK_CAPS_FLUSH,
> +					NULL);
>  	}
>  	/* Mark Fw dirty */
>  	spin_lock(&dst_ci->i_ceph_lock);
> --=20
>
> 2.36.0.rc1
>

