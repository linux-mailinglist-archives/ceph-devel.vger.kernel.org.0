Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E77AA644153
	for <lists+ceph-devel@lfdr.de>; Tue,  6 Dec 2022 11:33:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233708AbiLFKdh (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 6 Dec 2022 05:33:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233849AbiLFKdf (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 6 Dec 2022 05:33:35 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 534CEC03
        for <ceph-devel@vger.kernel.org>; Tue,  6 Dec 2022 02:32:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670322755;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MT/X0jn/YRuT9U1tXxUdXTYVr3v2yKQ9v/unPJajPKQ=;
        b=Yv8DF71DkPm+JHwb/aFNCQLqJxmZwEQJAYFNfMeYapzEcTiVEuoaJfvmsf+vwsv6J9b5uw
        XzJECP9PQH/Vhg7twVCWbg4Hf4Ve9YgAcKoatvX20wmsgzF3B8pmtD+xTph+G+5KJqXxBO
        NBD2c9q6hCbxdai2CX1cTyAH3xTmmWQ=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-314-X8F0WX3uO3OVan-VXZJGGw-1; Tue, 06 Dec 2022 05:32:34 -0500
X-MC-Unique: X8F0WX3uO3OVan-VXZJGGw-1
Received: by mail-wr1-f69.google.com with SMTP id x1-20020adfbb41000000b002426b33b618so1209808wrg.7
        for <ceph-devel@vger.kernel.org>; Tue, 06 Dec 2022 02:32:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MT/X0jn/YRuT9U1tXxUdXTYVr3v2yKQ9v/unPJajPKQ=;
        b=K8PDZULSL7pAWkUEIBjMhy/3gC/JzfJE43pFVLBjzrUHcew8y8xZUkBbp7ikptFHNn
         acJULGtKnv6xWE+lUM1rQ2GH1PlBSezGAZWuEfvUqL7gKyaAPg3jtUTWZfwRBSRMFLzc
         mkyezy/mLSLWkvDxdsWR7Nb/IQ8UkJO5TjWzstDQSNBRUFfIxHQemOQ0YMVFf0gi5Kuu
         T2brEvrpWiaqfRjLEApU/ehWxRuksXBxLqRCNjlxqa4R3dxAcAnB1iXvrJH7TnFBJgFk
         NzI5I17FCuOfgiDVk11Xq5q/QZZ8pUYd3RgwQ0GA2Jb/AvxZgwEk0i6xfsL6NkRq1e/P
         bI9g==
X-Gm-Message-State: ANoB5pnnrvewxbz6xqxU8/5M0E2toIyYJfrMBdyIhAnHPBtniQOVZdeP
        RDoUHLhUNEQPLICnS4HLHK2BdRyZjdjzemY/DzUtzlaar5bizRAyqUnlQtLm+mdTH0cLnQIztcF
        vj19FhCW+jf62cTV1jhSs
X-Received: by 2002:adf:f54d:0:b0:242:9e6:ea4d with SMTP id j13-20020adff54d000000b0024209e6ea4dmr29141160wrp.251.1670322753115;
        Tue, 06 Dec 2022 02:32:33 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6VCd51WHLIt52IV8MU3BuH0wLBi2rE1OjDxVmwF8++y07V7UzwIQ+jtDFwRX9LF5ezKnH5PQ==
X-Received: by 2002:adf:f54d:0:b0:242:9e6:ea4d with SMTP id j13-20020adff54d000000b0024209e6ea4dmr29141144wrp.251.1670322752850;
        Tue, 06 Dec 2022 02:32:32 -0800 (PST)
Received: from localhost (cpc111743-lutn13-2-0-cust979.9-3.cable.virginm.net. [82.17.115.212])
        by smtp.gmail.com with ESMTPSA id m21-20020a05600c4f5500b003b4fe03c881sm26797112wmq.48.2022.12.06.02.32.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 02:32:32 -0800 (PST)
Date:   Tue, 6 Dec 2022 10:32:31 +0000
From:   Aaron Tomlin <atomlin@redhat.com>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org, jlayton@kernel.org,
        mchangir@redhat.com, atomlin@atomlin.com
Subject: Re: [PATCH] ceph: blocklist the kclient when receiving corrupt snap
 trace
Message-ID: <20221206103231.5cqwbti42oevwert@ava.usersys.com>
X-PGP-Key: http://pgp.mit.edu/pks/lookup?search=atomlin%40redhat.com
X-PGP-Fingerprint: 7906 84EB FA8A 9638 8D1E  6E9B E2DE 9658 19CC 77D6
References: <20221205061514.50423-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221205061514.50423-1-xiubli@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon 2022-12-05 14:15 +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> When received corrupted snap trace we don't know what exactly has
> happened in MDS side. And we shouldn't continue writing to OSD,
> which may corrupt the snapshot contents.
> 
> Just try to blocklist this client and If fails we need to crash the
> client instead of leaving it writeable to OSDs.
> 
> URL: https://tracker.ceph.com/issues/57686
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/mds_client.c |  3 ++-
>  fs/ceph/mds_client.h |  1 +
>  fs/ceph/snap.c       | 25 +++++++++++++++++++++++++
>  3 files changed, 28 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index cbbaf334b6b8..59094944af28 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -5648,7 +5648,8 @@ static void mds_peer_reset(struct ceph_connection *con)
>  	struct ceph_mds_client *mdsc = s->s_mdsc;
>  
>  	pr_warn("mds%d closed our session\n", s->s_mds);
> -	send_mds_reconnect(mdsc, s);
> +	if (!mdsc->no_reconnect)
> +		send_mds_reconnect(mdsc, s);
>  }
>  
>  static void mds_dispatch(struct ceph_connection *con, struct ceph_msg *msg)
> diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
> index 728b7d72bf76..8e8f0447c0ad 100644
> --- a/fs/ceph/mds_client.h
> +++ b/fs/ceph/mds_client.h
> @@ -413,6 +413,7 @@ struct ceph_mds_client {
>  	atomic_t		num_sessions;
>  	int                     max_sessions;  /* len of sessions array */
>  	int                     stopping;      /* true if shutting down */
> +	int                     no_reconnect;  /* true if snap trace is corrupted */
>  
>  	atomic64_t		quotarealms_count; /* # realms with quota */
>  	/*
> diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
> index c1c452afa84d..5b211ec7d7f7 100644
> --- a/fs/ceph/snap.c
> +++ b/fs/ceph/snap.c
> @@ -767,8 +767,10 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
>  	struct ceph_snap_realm *realm;
>  	struct ceph_snap_realm *first_realm = NULL;
>  	struct ceph_snap_realm *realm_to_rebuild = NULL;
> +	struct ceph_client *client = mdsc->fsc->client;
>  	int rebuild_snapcs;
>  	int err = -ENOMEM;
> +	int ret;
>  	LIST_HEAD(dirty_realms);
>  
>  	lockdep_assert_held_write(&mdsc->snap_rwsem);
> @@ -885,6 +887,29 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
>  	if (first_realm)
>  		ceph_put_snap_realm(mdsc, first_realm);
>  	pr_err("%s error %d\n", __func__, err);
> +
> +	/*
> +	 * When received corrupted snap trace we don't know what
> +	 * exactly has happened in MDS side. And we shouldn't continue
> +	 * writing to OSD, which may corrupt the snapshot contents.
> +	 *
> +	 * Just try to blocklist this client and if fails we need to
> +	 * crash the client instead of leaving it writeable to OSDs.
> +	 *
> +	 * Then this kclient must be remounted to continue after the
> +	 * corrupted metadata fixed in MDS side.
> +	 */
> +	mdsc->no_reconnect = 1;
> +	ret = ceph_monc_blocklist_add(&client->monc, &client->msgr.inst.addr);
> +	if (ret) {
> +		pr_err("%s blocklist of %s failed: %d", __func__,
> +		       ceph_pr_addr(&client->msgr.inst.addr), ret);
> +		BUG();
> +	}
> +	pr_err("%s %s was blocklisted, do remount to continue%s",
> +	       __func__, ceph_pr_addr(&client->msgr.inst.addr),
> +	       err == -EIO ? " after corrupted snaptrace fixed": "");
> +
>  	return err;
>  }

Hi Xiubo,

How about using a WARN() so that we taint the Linux kernel too:

diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
index 864cdaa0d2bd..1941584b8fdb 100644
--- a/fs/ceph/snap.c
+++ b/fs/ceph/snap.c
@@ -766,8 +766,10 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
 	struct ceph_snap_realm *realm = NULL;
 	struct ceph_snap_realm *first_realm = NULL;
 	struct ceph_snap_realm *realm_to_rebuild = NULL;
+	struct ceph_client *client = mdsc->fsc->client;
 	int rebuild_snapcs;
 	int err = -ENOMEM;
+	int ret;
 	LIST_HEAD(dirty_realms);
 
 	lockdep_assert_held_write(&mdsc->snap_rwsem);
@@ -883,6 +885,31 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
 	if (first_realm)
 		ceph_put_snap_realm(mdsc, first_realm);
 	pr_err("%s error %d\n", __func__, err);
+
+
+	/*
+	 * When received corrupted snap trace we don't know what
+	 * exactly has happened in MDS side. And we shouldn't continue
+	 * writing to OSD, which may corrupt the snapshot contents.
+	 *
+	 * Just try to blocklist this client and if fails we need to
+	 * crash the client instead of leaving it writeable to OSDs.
+	 *
+	 * Then this kclient must be remounted to continue after the
+	 * corrupted metadata fixed in MDS side.
+	 */
+	mdsc->no_reconnect = 1;
+	ret = ceph_monc_blocklist_add(&client->monc, &client->msgr.inst.addr);
+	if (ret) {
+		pr_err("%s blocklist of %s failed: %d", __func__,
+		       ceph_pr_addr(&client->msgr.inst.addr), ret);
+		BUG();
+	}
+
+	WARN(1, "%s %s was blocklisted, do remount to continue%s",
+	     __func__, ceph_pr_addr(&client->msgr.inst.addr),
+	     err == -EIO ? " after corrupted snaptrace fixed": "");
+
 	return err;
 }


-- 
Aaron Tomlin

