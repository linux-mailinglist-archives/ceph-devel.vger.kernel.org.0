Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC00C4BC603
	for <lists+ceph-devel@lfdr.de>; Sat, 19 Feb 2022 07:30:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241355AbiBSGbE (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sat, 19 Feb 2022 01:31:04 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241353AbiBSGbD (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sat, 19 Feb 2022 01:31:03 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C7CFAB2D78
        for <ceph-devel@vger.kernel.org>; Fri, 18 Feb 2022 22:30:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645252243;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/riQuvfUpAQS084dO+CEHSzI090atFnh1U+LEqE6Cf0=;
        b=YU+ozNl+dJUa1MlhJ/YgkJ49oJkRyF1rsQsbCbE+F0vniWYPcdguGDs+7LdAEEJhyrw97G
        rzrAXQQawW7KY9B9oqOdiJeyj22cdriJJhwdBGFxT98sQdO/LUnONBA/mHH5w2kDrVXXxS
        OBO+UAw8Z63eC4hfapkcFslwCfg8iW0=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-17-C0Z5tH4qMf28dcnuo6EfEw-1; Sat, 19 Feb 2022 01:30:42 -0500
X-MC-Unique: C0Z5tH4qMf28dcnuo6EfEw-1
Received: by mail-pf1-f200.google.com with SMTP id z20-20020aa791d4000000b004bd024eaf19so2929500pfa.16
        for <ceph-devel@vger.kernel.org>; Fri, 18 Feb 2022 22:30:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=/riQuvfUpAQS084dO+CEHSzI090atFnh1U+LEqE6Cf0=;
        b=Y4rsN3DEoXbC4I+YRGikJF/V2cRNw3qwLPrt7fLuxC32hj58ZWNB54ZoYM4lZrQoB3
         5WSdpYz8AEc/ji8q+eyvRDoUGGl0t3yNLSTJYUIkCHAiZyONJHwdFdSuLSVNUnVT6JJ0
         cmzLUxZofPA1ygcqo9MSLyayR1XkdyUCBwp4c2AnRPMP2cxjViZMxPF9v137UfSxBKcz
         dHQ7uzcdCL180ie3womGzD6pV5BcTpbOtSL7GrV2uQcnSYPr+pAZaPBLW+CsDslP1fsb
         +rhz5m4qj4A1CUOmkVmbGx+D/RLMDwOFChJXzDEHorQyRRQUkO8cXoWnfXiJp+ZUW4dA
         T78Q==
X-Gm-Message-State: AOAM530hBFkyRwq3tQWxm0FLWfkAbbzNXL2Agy4Osk4nKvxlmV4Ct4Z0
        kXMA+1q4arv/0YrxroLbj/dzwQu45PQM0a7JQUE/5Q+u+pE2QJD2gEhKSkd8E9IAsr/jflt8SoQ
        QrwdvRnxbNDkF2Rthc7mxk0qvtLskP1hd62iBf3O6aJ681Rhl4NtjY+qr7NXyXrmYAIcLagw=
X-Received: by 2002:a17:903:283:b0:14d:6e68:27cb with SMTP id j3-20020a170903028300b0014d6e6827cbmr10547718plr.80.1645252240587;
        Fri, 18 Feb 2022 22:30:40 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy1ecSv7MFDJrsugoV0invAavrlgFYw1kVRUK1G7aXg3uroDVN4QVzTA7dRqHiMSJZmrg5MnA==
X-Received: by 2002:a17:903:283:b0:14d:6e68:27cb with SMTP id j3-20020a170903028300b0014d6e6827cbmr10547693plr.80.1645252240055;
        Fri, 18 Feb 2022 22:30:40 -0800 (PST)
Received: from [10.72.12.153] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id w11sm1324639pfu.19.2022.02.18.22.30.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Feb 2022 22:30:39 -0800 (PST)
Subject: Re: [PATCH v2] ceph: do not update snapshot context when there is no
 new snapshot
To:     jlayton@kernel.org, Luis Henriques <lhenriques@suse.de>
Cc:     idryomov@gmail.com, vshankar@redhat.com, ukernel@gmail.com,
        ceph-devel@vger.kernel.org
References: <20220218024722.7952-1-xiubli@redhat.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <f8a283ad-dabe-9268-491e-5d3aaa65e893@redhat.com>
Date:   Sat, 19 Feb 2022 14:30:33 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220218024722.7952-1-xiubli@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 2/18/22 10:47 AM, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
>
> We will only track the uppest parent snapshot realm from which we
> need to rebuild the snapshot contexts _downward_ in hierarchy. For
> all the others having no new snapshot we will do nothing.
>
> This fix will avoid calling ceph_queue_cap_snap() on some inodes
> inappropriately. For example, with the code in mainline, suppose there
> are 2 directory hierarchies (with 6 directories total), like this:
>
> /dir_X1/dir_X2/dir_X3/
> /dir_Y1/dir_Y2/dir_Y3/
>
> Firstly, make a snapshot under /dir_X1/dir_X2/.snap/snap_X2, then make a
> root snapshot under /.snap/root_snap. Every time we make snapshots under
> /dir_Y1/..., the kclient will always try to rebuild the snap context for
> snap_X2 realm and finally will always try to queue cap snaps for dir_Y2
> and dir_Y3, which makes no sense.
>
> That's because the snap_X2's seq is 2 and root_snap's seq is 3. So when
> creating a new snapshot under /dir_Y1/... the new seq will be 4, and
> the mds will send the kclient a snapshot backtrace in _downward_
> order: seqs 4, 3.
>
> When ceph_update_snap_trace() is called, it will always rebuild the from
> the last realm, that's the root_snap. So later when rebuilding the snap
> context, the current logic will always cause it to rebuild the snap_X2
> realm and then try to queue cap snaps for all the inodes related in that
> realm, even though it's not necessary.
>
> This is accompanied by a lot of these sorts of dout messages:
>
>      "ceph:  queue_cap_snap 00000000a42b796b nothing dirty|writing"
>
> Fix the logic to avoid this situation.
>
> The 'invalidate' word is not precise here, acutally it will rebuild
> the snapshot existing contexts or just build none-existing ones,
> rename it to 'rebuild_snapcs'.
>
> URL: https://tracker.ceph.com/issues/44100
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>
> Changed in V2:
> - Thanks Zheng's feedback and switched to Zheng's patch.
> - Rename invalidate to rebuild_snapcs.
>
>
>
>   fs/ceph/snap.c | 28 +++++++++++++++++++---------
>   1 file changed, 19 insertions(+), 9 deletions(-)
>
> diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
> index dbf34f212596..6d55b8ba79d8 100644
> --- a/fs/ceph/snap.c
> +++ b/fs/ceph/snap.c
> @@ -735,7 +735,8 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
>   	__le64 *prior_parent_snaps;        /* encoded */
>   	struct ceph_snap_realm *realm = NULL;
>   	struct ceph_snap_realm *first_realm = NULL;
> -	int invalidate = 0;
> +	struct ceph_snap_realm *realm_to_rebuild = NULL;
> +	int rebuild_snapcs;
>   	int err = -ENOMEM;
>   	LIST_HEAD(dirty_realms);
>   
> @@ -743,6 +744,7 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
>   
>   	dout("update_snap_trace deletion=%d\n", deletion);
>   more:
> +	rebuild_snapcs = 0;
>   	ceph_decode_need(&p, e, sizeof(*ri), bad);
>   	ri = p;
>   	p += sizeof(*ri);
> @@ -766,7 +768,7 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
>   	err = adjust_snap_realm_parent(mdsc, realm, le64_to_cpu(ri->parent));
>   	if (err < 0)
>   		goto fail;
> -	invalidate += err;
> +	rebuild_snapcs += err;
>   
>   	if (le64_to_cpu(ri->seq) > realm->seq) {
>   		dout("update_snap_trace updating %llx %p %lld -> %lld\n",
> @@ -791,22 +793,30 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
>   		if (realm->seq > mdsc->last_snap_seq)
>   			mdsc->last_snap_seq = realm->seq;
>   
> -		invalidate = 1;
> +		rebuild_snapcs = 1;
>   	} else if (!realm->cached_context) {
>   		dout("update_snap_trace %llx %p seq %lld new\n",
>   		     realm->ino, realm, realm->seq);
> -		invalidate = 1;
> +		rebuild_snapcs = 1;
>   	} else {
>   		dout("update_snap_trace %llx %p seq %lld unchanged\n",
>   		     realm->ino, realm, realm->seq);
>   	}
>   
> -	dout("done with %llx %p, invalidated=%d, %p %p\n", realm->ino,
> -	     realm, invalidate, p, e);
> +	dout("done with %llx %p, rebuild_snapcs=%d, %p %p\n", realm->ino,
> +	     realm, rebuild_snapcs, p, e);
>   
> -	/* invalidate when we reach the _end_ (root) of the trace */
> -	if (invalidate && p >= e)
> -		rebuild_snap_realms(realm, &dirty_realms);
> +	/*
> +	 * this will always track the uppest parent realm from which
> +	 * we need to rebuild the snapshot contexts _downward_ in
> +	 * hierarchy.
> +	 */
> +	if (rebuild_snapcs)
> +		realm_to_rebuild = realm;
> +
> +	/* rebuild_snapcs when we reach the _end_ (root) of the trace */
> +	if (rebuild_snapcs && p >= e)

s/rebuild_snapcs/realm_to_rebuild/

This will fix the bug Luís Henriques reported.

I have sent the V3 to fix it. Thanks.

- Xiubo


> +		rebuild_snap_realms(realm_to_rebuild, &dirty_realms);
>   
>   	if (!first_realm)
>   		first_realm = realm;

