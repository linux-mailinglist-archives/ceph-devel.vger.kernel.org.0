Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68CF54BF641
	for <lists+ceph-devel@lfdr.de>; Tue, 22 Feb 2022 11:40:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbiBVKku (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 22 Feb 2022 05:40:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231241AbiBVKko (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 22 Feb 2022 05:40:44 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9B16615AF38
        for <ceph-devel@vger.kernel.org>; Tue, 22 Feb 2022 02:40:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645526418;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HwZUBije/CMxShnKcZUM4SUNHeypPtgMyka1YyMkEP0=;
        b=dKILGhXEY4flwmtr15XNRlvlvFKPkNQPwgsXIqpc8wRRuuqoGEhQBXQNLxaklxFNuGRe2M
        JT19TZy6e0qwfDHkCJPiOCgrtE5OwCrpBqock9BM/+aZ7xL2cx6Dae87bRzCtDxL8wxaq4
        ssBS47bX9p50zCGYiNrDzmWgzFUZVKk=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-306-UQSCrLFSPm6WIJo9IK5U9g-1; Tue, 22 Feb 2022 05:40:17 -0500
X-MC-Unique: UQSCrLFSPm6WIJo9IK5U9g-1
Received: by mail-pf1-f197.google.com with SMTP id a200-20020a621ad1000000b004e191fdcb4dso6784122pfa.1
        for <ceph-devel@vger.kernel.org>; Tue, 22 Feb 2022 02:40:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=HwZUBije/CMxShnKcZUM4SUNHeypPtgMyka1YyMkEP0=;
        b=44bjeuhKWpdHR4kG3yqzEj7r6/ZYq1dmez/QkzWAXciC03jHK2Pf5zBA75x/4PNbZX
         PUf5dfvlCatpjhook5p+qt9XpMLZdoCbJhCyxRkRwH7YCww6vZd/C24Yj6HhpEzcmiRF
         +wiq4CGJLxQU2BmK2FvLJID/+2i0Tw0uDuXAOz5dg5VNi91pQOju1L2C6HE9c4Ema0KT
         BEFMmv2xLwvb8ehxtIbQodO8Vfoyf15l3vdbbQpUmBcxg/yxUx22TnLHkdmla33PehJ2
         TD3PrdeuMsRQAudn6GugwCFUz3tC9mUcDHjAxfskzptQ/B7eUgVD8ingbS78I+Y5KgmG
         b9TQ==
X-Gm-Message-State: AOAM533c2HzKEHu+KlE0xN6Vl43qLWfvnSvZBdsEjhZ9ABj8wsf0be2c
        3VTT87WUpqisEIzseCxLhaLj1ie5DOsHoW4zxE62tpe/YGCGArTfmUvfYz0vlhcBaBCp4evSYi+
        Nl5AFlDskZjFujKFZnUfbQFegzUDY89/s5qoonaRun0UnqoD5J+oCmJlSWkAziEr5InVULzA=
X-Received: by 2002:a17:902:be10:b0:14d:66b5:7065 with SMTP id r16-20020a170902be1000b0014d66b57065mr22166073pls.81.1645526415846;
        Tue, 22 Feb 2022 02:40:15 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx9dKbGO3td4NY79dkMHnIBCMRyciifwQgKDFbeZrK+CB1MbnaGebkKfpsC9aHCaVgG663njA==
X-Received: by 2002:a17:902:be10:b0:14d:66b5:7065 with SMTP id r16-20020a170902be1000b0014d66b57065mr22166044pls.81.1645526415449;
        Tue, 22 Feb 2022 02:40:15 -0800 (PST)
Received: from [10.72.12.114] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id q13sm17194364pfl.210.2022.02.22.02.40.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Feb 2022 02:40:14 -0800 (PST)
Subject: Re: [PATCH 2/2] ceph: do not release the global snaprealm until
 unmounting
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, vshankar@redhat.com, ceph-devel@vger.kernel.org
References: <20220222063433.217466-1-xiubli@redhat.com>
 <20220222063433.217466-3-xiubli@redhat.com>
 <68e565e99f10c549ceea646fd5d1dcdd6bec0be2.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <b7630bbd-d368-d54c-33e6-5e150e12fde1@redhat.com>
Date:   Tue, 22 Feb 2022 18:40:09 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <68e565e99f10c549ceea646fd5d1dcdd6bec0be2.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 2/22/22 6:22 PM, Jeff Layton wrote:
> On Tue, 2022-02-22 at 14:34 +0800, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> The global snaprealm would be created and then destroyed immediately
>> every time when updating it.
>>
> Does this cause some sort of issue, or is it just inefficient?
>
Just inefficient.


>> URL: https://tracker.ceph.com/issues/54362
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/mds_client.c         |  2 +-
>>   fs/ceph/snap.c               | 13 +++++++++++--
>>   fs/ceph/super.h              |  2 +-
>>   include/linux/ceph/ceph_fs.h |  3 ++-
>>   4 files changed, 15 insertions(+), 5 deletions(-)
>>
>> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
>> index 65bd43d4cafc..325f8071a324 100644
>> --- a/fs/ceph/mds_client.c
>> +++ b/fs/ceph/mds_client.c
>> @@ -4866,7 +4866,7 @@ void ceph_mdsc_close_sessions(struct ceph_mds_client *mdsc)
>>   	mutex_unlock(&mdsc->mutex);
>>   
>>   	ceph_cleanup_snapid_map(mdsc);
>> -	ceph_cleanup_empty_realms(mdsc);
>> +        ceph_cleanup_global_and_empty_realms(mdsc);
> Please use tab indent.

Sure, will fix it.

Thanks

- Xiubo

>
>>   
>>   	cancel_work_sync(&mdsc->cap_reclaim_work);
>>   	cancel_delayed_work_sync(&mdsc->delayed_work); /* cancel timer */
>> diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
>> index 66a1a92cf579..cc9097c27052 100644
>> --- a/fs/ceph/snap.c
>> +++ b/fs/ceph/snap.c
>> @@ -121,7 +121,11 @@ static struct ceph_snap_realm *ceph_create_snap_realm(
>>   	if (!realm)
>>   		return ERR_PTR(-ENOMEM);
>>   
>> -	atomic_set(&realm->nref, 1);    /* for caller */
>> +	/* Do not release the global dummy snaprealm until unmouting */
>> +	if (ino == CEPH_INO_GLOBAL_SNAPREALM)
>> +		atomic_set(&realm->nref, 2);
>> +	else
>> +		atomic_set(&realm->nref, 1);
>>   	realm->ino = ino;
>>   	INIT_LIST_HEAD(&realm->children);
>>   	INIT_LIST_HEAD(&realm->child_item);
>> @@ -261,9 +265,14 @@ static void __cleanup_empty_realms(struct ceph_mds_client *mdsc)
>>   	spin_unlock(&mdsc->snap_empty_lock);
>>   }
>>   
>> -void ceph_cleanup_empty_realms(struct ceph_mds_client *mdsc)
>> +void ceph_cleanup_global_and_empty_realms(struct ceph_mds_client *mdsc)
>>   {
>> +	struct ceph_snap_realm *global_realm;
>> +
>>   	down_write(&mdsc->snap_rwsem);
>> +	global_realm = __lookup_snap_realm(mdsc, CEPH_INO_GLOBAL_SNAPREALM);
>> +	if (global_realm)
>> +		ceph_put_snap_realm(mdsc, global_realm);
>>   	__cleanup_empty_realms(mdsc);
>>   	up_write(&mdsc->snap_rwsem);
>>   }
>> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
>> index baac800a6d11..250aefecd628 100644
>> --- a/fs/ceph/super.h
>> +++ b/fs/ceph/super.h
>> @@ -942,7 +942,7 @@ extern void ceph_handle_snap(struct ceph_mds_client *mdsc,
>>   			     struct ceph_msg *msg);
>>   extern int __ceph_finish_cap_snap(struct ceph_inode_info *ci,
>>   				  struct ceph_cap_snap *capsnap);
>> -extern void ceph_cleanup_empty_realms(struct ceph_mds_client *mdsc);
>> +extern void ceph_cleanup_global_and_empty_realms(struct ceph_mds_client *mdsc);
>>   
>>   extern struct ceph_snapid_map *ceph_get_snapid_map(struct ceph_mds_client *mdsc,
>>   						   u64 snap);
>> diff --git a/include/linux/ceph/ceph_fs.h b/include/linux/ceph/ceph_fs.h
>> index f14f9bc290e6..86bf82dbd8b8 100644
>> --- a/include/linux/ceph/ceph_fs.h
>> +++ b/include/linux/ceph/ceph_fs.h
>> @@ -28,7 +28,8 @@
>>   
>>   
>>   #define CEPH_INO_ROOT   1
>> -#define CEPH_INO_CEPH   2       /* hidden .ceph dir */
>> +#define CEPH_INO_CEPH   2            /* hidden .ceph dir */
>> +#define CEPH_INO_GLOBAL_SNAPREALM  3 /* global dummy snaprealm */
>>   
>>   /* arbitrary limit on max # of monitors (cluster of 3 is typical) */
>>   #define CEPH_MAX_MON   31

