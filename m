Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07249582361
	for <lists+ceph-devel@lfdr.de>; Wed, 27 Jul 2022 11:41:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230479AbiG0Jlr (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 27 Jul 2022 05:41:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230473AbiG0Jlp (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 27 Jul 2022 05:41:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CBEA93FA1D
        for <ceph-devel@vger.kernel.org>; Wed, 27 Jul 2022 02:41:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658914904;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vsvynYbqkPPdTRXo4wkF9+QVinJY3aAsTXELJJ2UK3w=;
        b=RV6Ra0qJ4ty3tXciyfx2O1aNMadUSg8yxe6rwYmuo8Eb4PVi1ZB1UfWrcOBZ7ZFgmAS5Qj
        lxaoeTw/gbaBAWKKqWqHSWeLoUw5/4JAQXJert4OA1HMhIbo+mKfhKmudwHVPYhaJmBXIj
        rsdv1RnOm5uFek7FowQ7qBt40v57Iys=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-210-iUDEkrmZN6-4YCuly6_8FA-1; Wed, 27 Jul 2022 05:41:42 -0400
X-MC-Unique: iUDEkrmZN6-4YCuly6_8FA-1
Received: by mail-pg1-f198.google.com with SMTP id d66-20020a636845000000b0040a88edd9c1so7664743pgc.13
        for <ceph-devel@vger.kernel.org>; Wed, 27 Jul 2022 02:41:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=vsvynYbqkPPdTRXo4wkF9+QVinJY3aAsTXELJJ2UK3w=;
        b=wff+VyCqApkqqy4Bcxk5lmrP5ZGyhq70quei3XFq60GUeuHdI9TPLsxlrGjEnbhcrn
         B5cP3KMLJLGK03I8kM+kpc1NKlZqhJKWlBWTcOGEzy+uqDvZgKE0cUjMU114dMsVS6hg
         PiHxUPZiZd4kL8l26X4cCutbjeZFy9K7DIZFO9jMqJUdydrb8JOYZwAQnso8SnEuWHgq
         VUhBiU5++DmQyy2LNRHb4pHbnQGivQA5B8T/AvCeqcY3DADXArJT5WanWWbVt5QsxzXJ
         7QFDfQO3znK1WzzQHPGtBOF+CkyW7OcI00H/XKZlh6whCSreTij4I1UveDBqlaRhRPGM
         gM/w==
X-Gm-Message-State: AJIora/FviAA3Eimiu3HIaWvbIjX8mTiGft0ctOTi3AasXyV6iIh7Uwc
        BcJN4FFoC8fGtjJkIjuUs18aWm/HCFnec2V92UKYiaLRzbNWUrmHkyBG3nc/OwdOcUoYjSM2KKm
        TSXpUkOdpJGQGklzDJtyYYPRs9DTNfWD6BuBTC9RqyoegrsrycBKIv8OLcn4BhxOK/sYNpxY=
X-Received: by 2002:a63:86c2:0:b0:415:eb:d166 with SMTP id x185-20020a6386c2000000b0041500ebd166mr17829027pgd.124.1658914901364;
        Wed, 27 Jul 2022 02:41:41 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1ufPgpa+QLaBG7DBUHLy2BWSR2s3Q966u2qHwTg/NKMSRxZp8J6sCc+Dt8ZTgZ8EF2L1hndLw==
X-Received: by 2002:a63:86c2:0:b0:415:eb:d166 with SMTP id x185-20020a6386c2000000b0041500ebd166mr17829001pgd.124.1658914900888;
        Wed, 27 Jul 2022 02:41:40 -0700 (PDT)
Received: from [10.72.13.152] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id p16-20020a170902e75000b0016b81679c1fsm13451806plf.216.2022.07.27.02.41.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Jul 2022 02:41:40 -0700 (PDT)
Subject: Re: [PATCH] ceph: fall back to use old method to get xattr
To:     =?UTF-8?Q?Lu=c3=ads_Henriques?= <lhenriques@suse.de>
Cc:     ceph-devel@vger.kernel.org
References: <20220727055637.11949-1-xiubli@redhat.com>
 <YuD/yDOwJaqg7q+X@suse.de>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <e6acea1f-0e80-9628-43a3-a9261248ad06@redhat.com>
Date:   Wed, 27 Jul 2022 17:41:35 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <YuD/yDOwJaqg7q+X@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 7/27/22 5:05 PM, Luís Henriques wrote:
> On Wed, Jul 27, 2022 at 01:56:37PM +0800, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> If the peer MDS doesn't support getvxattr op then just fall back to
>> use old getattr method to get it. Or for the old MDSs they will crash
>> when receive an unknown op.
>>
>> URL: https://tracker.ceph.com/issues/56529
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/mds_client.c | 10 ++++++++++
>>   fs/ceph/mds_client.h |  4 +++-
>>   fs/ceph/xattr.c      |  9 ++++++---
>>   3 files changed, 19 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
>> index 598012ddc401..bfe6d6393eba 100644
>> --- a/fs/ceph/mds_client.c
>> +++ b/fs/ceph/mds_client.c
>> @@ -3255,6 +3255,16 @@ static void __do_request(struct ceph_mds_client *mdsc,
>>   
>>   	dout("do_request mds%d session %p state %s\n", mds, session,
>>   	     ceph_session_state_name(session->s_state));
>> +
>> +	/*
>> +	 * The old ceph will crash the MDSs when see unknown OPs
>> +	 */
>> +	if (req->r_op == CEPH_MDS_OP_GETVXATTR &&
>> +	    !test_bit(CEPHFS_FEATURE_OP_GETVXATTR, &session->s_features)) {
>> +		err = -EOPNOTSUPP;
>> +		goto out_session;
>> +	}
>> +
>>   	if (session->s_state != CEPH_MDS_SESSION_OPEN &&
>>   	    session->s_state != CEPH_MDS_SESSION_HUNG) {
>>   		/*
>> diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
>> index e15ee2858fef..0e03efab872a 100644
>> --- a/fs/ceph/mds_client.h
>> +++ b/fs/ceph/mds_client.h
>> @@ -31,8 +31,9 @@ enum ceph_feature_type {
>>   	CEPHFS_FEATURE_METRIC_COLLECT,
>>   	CEPHFS_FEATURE_ALTERNATE_NAME,
>>   	CEPHFS_FEATURE_NOTIFY_SESSION_STATE,
>> +	CEPHFS_FEATURE_OP_GETVXATTR,
>>   
>> -	CEPHFS_FEATURE_MAX = CEPHFS_FEATURE_NOTIFY_SESSION_STATE,
>> +	CEPHFS_FEATURE_MAX = CEPHFS_FEATURE_OP_GETVXATTR,
>>   };
>>   
>>   #define CEPHFS_FEATURES_CLIENT_SUPPORTED {	\
>> @@ -45,6 +46,7 @@ enum ceph_feature_type {
>>   	CEPHFS_FEATURE_METRIC_COLLECT,		\
>>   	CEPHFS_FEATURE_ALTERNATE_NAME,		\
>>   	CEPHFS_FEATURE_NOTIFY_SESSION_STATE,	\
>> +	CEPHFS_FEATURE_OP_GETVXATTR,		\
>>   }
>>   
>>   /*
>> diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
>> index b10d459c2326..8f8db621772a 100644
>> --- a/fs/ceph/xattr.c
>> +++ b/fs/ceph/xattr.c
>> @@ -984,9 +984,12 @@ ssize_t __ceph_getxattr(struct inode *inode, const char *name, void *value,
>>   		return err;
>>   	} else {
>>   		err = ceph_do_getvxattr(inode, name, value, size);
>> -		/* this would happen with a new client and old server combo */
>> +		/*
>> +		 * This would happen with a new client and old server combo,
>> +		 * then fall back to use old method to get it
>> +		 */
>>   		if (err == -EOPNOTSUPP)
>> -			err = -ENODATA;
>> +			goto handle_non_vxattrs;
>>   		return err;
> Nit: maybe just do:
>
> 		if (err != -EOPNOTSUPP)
> 			return err
>
> instead of using a 'goto' statement.

Sounds better.

>>   	}
>>   handle_non_vxattrs:
>> @@ -996,7 +999,7 @@ ssize_t __ceph_getxattr(struct inode *inode, const char *name, void *value,
>>   	dout("getxattr %p name '%s' ver=%lld index_ver=%lld\n", inode, name,
>>   	     ci->i_xattrs.version, ci->i_xattrs.index_version);
>>   
>> -	if (ci->i_xattrs.version == 0 ||
>> +	if (ci->i_xattrs.version == 0 || err == -EOPNOTSUPP ||
> You'll need to initialise 'err' when declaring it.

Yeah, will fix it.

Thanks Luis!

-- Xiubo

>
> Cheers,
> --
> Luís
>
>>   	    !((req_mask & CEPH_CAP_XATTR_SHARED) ||
>>   	      __ceph_caps_issued_mask_metric(ci, CEPH_CAP_XATTR_SHARED, 1))) {
>>   		spin_unlock(&ci->i_ceph_lock);
>> -- 
>> 2.36.0.rc1
>>

