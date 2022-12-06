Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CAC16442FB
	for <lists+ceph-devel@lfdr.de>; Tue,  6 Dec 2022 13:13:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233702AbiLFMNI (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 6 Dec 2022 07:13:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230230AbiLFMNG (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 6 Dec 2022 07:13:06 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD4F028705
        for <ceph-devel@vger.kernel.org>; Tue,  6 Dec 2022 04:12:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670328736;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XNn2IJU8D/bphmA3HlbVj31DXGarQcVWXcQELbFoBa4=;
        b=JojHJFKYd764CB/KGsmNHpiwFvXrAJ7XCiUWrN/2zOQwrb01JptcTaHwzKjtqHQnZ2yMqG
        dMB13WzdyQtTEKp2Q9ZClXZwVgasu7qLvS1mT0QVWVfCJhAbDghsmlGvgVIJDznZWsPbMl
        Sgb7XVzdgRR02Ubiai1b3FMRlgtttcY=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-383-E0IJTtVeMbuyHqzhaotx5w-1; Tue, 06 Dec 2022 07:12:13 -0500
X-MC-Unique: E0IJTtVeMbuyHqzhaotx5w-1
Received: by mail-pl1-f197.google.com with SMTP id e11-20020a17090301cb00b001890e0c759aso16163003plh.5
        for <ceph-devel@vger.kernel.org>; Tue, 06 Dec 2022 04:12:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-language:content-transfer-encoding:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XNn2IJU8D/bphmA3HlbVj31DXGarQcVWXcQELbFoBa4=;
        b=0+aMSD1dq/L8GvW3gIFjEyKmzRD8zGWKyYK38NFCmtThkN9VKDUy8GikvdC4QKu0ow
         XNs5QiODaNdrU+GttU6rN+QBcq1oXb6+xNs1D8OZXWLd3xZtl27sWz/R4oQwtbusiD4L
         IK+mEIw+VPLWRH42MvRlDAEV09QJFT8Q2dMUBPW+ibtCHO8zRldytL80oUvoWqJqTFE/
         kA899HJI6GKgFCi5A5xWYfT8xYAtYGZj335BdU/2HUlaoOoVNXvLWVvodj1wylo2d5Mc
         v/Y5HTDRpdMTd/RZrbsBpEIejihrHpOuhdj74xRYaxxiSYFbRPpyPJOHWBpQWO830qBw
         0cGQ==
X-Gm-Message-State: ANoB5pkQy5iVJ2hKtRiB5iPjCH/+TjqZUmApKNyY5P2hPfZji/CWUQ1b
        sTJRbOs32K1KqJXzomCrs9RwQcUYywdONDjl8i8/OCh4Dnnc9B/TsOUgJ8ivUnF3tWmkdr3NIxi
        mBGpI085idagKldPBbq8Flw==
X-Received: by 2002:a63:5c0f:0:b0:470:8e8a:8e11 with SMTP id q15-20020a635c0f000000b004708e8a8e11mr60049253pgb.490.1670328732548;
        Tue, 06 Dec 2022 04:12:12 -0800 (PST)
X-Google-Smtp-Source: AA0mqf75JtICg5j6ER23bJbQZzhLuvoz38z0pzIRTIe9BOo/fmPVc83Im/QQlO63KmOvnR2NeC6BaQ==
X-Received: by 2002:a63:5c0f:0:b0:470:8e8a:8e11 with SMTP id q15-20020a635c0f000000b004708e8a8e11mr60049235pgb.490.1670328732253;
        Tue, 06 Dec 2022 04:12:12 -0800 (PST)
Received: from [10.72.12.244] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id 17-20020a170902c11100b0018962933a3esm12396718pli.181.2022.12.06.04.12.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Dec 2022 04:12:11 -0800 (PST)
Subject: Re: [PATCH] ceph: blocklist the kclient when receiving corrupt snap
 trace
To:     Aaron Tomlin <atomlin@redhat.com>
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org, jlayton@kernel.org,
        mchangir@redhat.com, atomlin@atomlin.com
References: <20221205061514.50423-1-xiubli@redhat.com>
 <20221206103231.5cqwbti42oevwert@ava.usersys.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <54698b81-b824-43ad-d0d9-e9e5d7c7d9c0@redhat.com>
Date:   Tue, 6 Dec 2022 20:12:07 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20221206103231.5cqwbti42oevwert@ava.usersys.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 06/12/2022 18:32, Aaron Tomlin wrote:
> On Mon 2022-12-05 14:15 +0800, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> When received corrupted snap trace we don't know what exactly has
>> happened in MDS side. And we shouldn't continue writing to OSD,
>> which may corrupt the snapshot contents.
>>
>> Just try to blocklist this client and If fails we need to crash the
>> client instead of leaving it writeable to OSDs.
>>
>> URL: https://tracker.ceph.com/issues/57686
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/mds_client.c |  3 ++-
>>   fs/ceph/mds_client.h |  1 +
>>   fs/ceph/snap.c       | 25 +++++++++++++++++++++++++
>>   3 files changed, 28 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
>> index cbbaf334b6b8..59094944af28 100644
>> --- a/fs/ceph/mds_client.c
>> +++ b/fs/ceph/mds_client.c
>> @@ -5648,7 +5648,8 @@ static void mds_peer_reset(struct ceph_connection *con)
>>   	struct ceph_mds_client *mdsc = s->s_mdsc;
>>   
>>   	pr_warn("mds%d closed our session\n", s->s_mds);
>> -	send_mds_reconnect(mdsc, s);
>> +	if (!mdsc->no_reconnect)
>> +		send_mds_reconnect(mdsc, s);
>>   }
>>   
>>   static void mds_dispatch(struct ceph_connection *con, struct ceph_msg *msg)
>> diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
>> index 728b7d72bf76..8e8f0447c0ad 100644
>> --- a/fs/ceph/mds_client.h
>> +++ b/fs/ceph/mds_client.h
>> @@ -413,6 +413,7 @@ struct ceph_mds_client {
>>   	atomic_t		num_sessions;
>>   	int                     max_sessions;  /* len of sessions array */
>>   	int                     stopping;      /* true if shutting down */
>> +	int                     no_reconnect;  /* true if snap trace is corrupted */
>>   
>>   	atomic64_t		quotarealms_count; /* # realms with quota */
>>   	/*
>> diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
>> index c1c452afa84d..5b211ec7d7f7 100644
>> --- a/fs/ceph/snap.c
>> +++ b/fs/ceph/snap.c
>> @@ -767,8 +767,10 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
>>   	struct ceph_snap_realm *realm;
>>   	struct ceph_snap_realm *first_realm = NULL;
>>   	struct ceph_snap_realm *realm_to_rebuild = NULL;
>> +	struct ceph_client *client = mdsc->fsc->client;
>>   	int rebuild_snapcs;
>>   	int err = -ENOMEM;
>> +	int ret;
>>   	LIST_HEAD(dirty_realms);
>>   
>>   	lockdep_assert_held_write(&mdsc->snap_rwsem);
>> @@ -885,6 +887,29 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
>>   	if (first_realm)
>>   		ceph_put_snap_realm(mdsc, first_realm);
>>   	pr_err("%s error %d\n", __func__, err);
>> +
>> +	/*
>> +	 * When received corrupted snap trace we don't know what
>> +	 * exactly has happened in MDS side. And we shouldn't continue
>> +	 * writing to OSD, which may corrupt the snapshot contents.
>> +	 *
>> +	 * Just try to blocklist this client and if fails we need to
>> +	 * crash the client instead of leaving it writeable to OSDs.
>> +	 *
>> +	 * Then this kclient must be remounted to continue after the
>> +	 * corrupted metadata fixed in MDS side.
>> +	 */
>> +	mdsc->no_reconnect = 1;
>> +	ret = ceph_monc_blocklist_add(&client->monc, &client->msgr.inst.addr);
>> +	if (ret) {
>> +		pr_err("%s blocklist of %s failed: %d", __func__,
>> +		       ceph_pr_addr(&client->msgr.inst.addr), ret);
>> +		BUG();
>> +	}
>> +	pr_err("%s %s was blocklisted, do remount to continue%s",
>> +	       __func__, ceph_pr_addr(&client->msgr.inst.addr),
>> +	       err == -EIO ? " after corrupted snaptrace fixed": "");
>> +
>>   	return err;
>>   }
> Hi Xiubo,
>
> How about using a WARN() so that we taint the Linux kernel too:

Yeah, this looks good to me :-)

Thanks Aaron.

- Xiubo

> diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
> index 864cdaa0d2bd..1941584b8fdb 100644
> --- a/fs/ceph/snap.c
> +++ b/fs/ceph/snap.c
> @@ -766,8 +766,10 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
>   	struct ceph_snap_realm *realm = NULL;
>   	struct ceph_snap_realm *first_realm = NULL;
>   	struct ceph_snap_realm *realm_to_rebuild = NULL;
> +	struct ceph_client *client = mdsc->fsc->client;
>   	int rebuild_snapcs;
>   	int err = -ENOMEM;
> +	int ret;
>   	LIST_HEAD(dirty_realms);
>   
>   	lockdep_assert_held_write(&mdsc->snap_rwsem);
> @@ -883,6 +885,31 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
>   	if (first_realm)
>   		ceph_put_snap_realm(mdsc, first_realm);
>   	pr_err("%s error %d\n", __func__, err);
> +
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
> +
> +	WARN(1, "%s %s was blocklisted, do remount to continue%s",
> +	     __func__, ceph_pr_addr(&client->msgr.inst.addr),
> +	     err == -EIO ? " after corrupted snaptrace fixed": "");
> +
>   	return err;
>   }
>
>

