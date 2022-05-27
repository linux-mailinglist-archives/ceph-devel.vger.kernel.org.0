Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 044CA535723
	for <lists+ceph-devel@lfdr.de>; Fri, 27 May 2022 02:36:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230470AbiE0Agm (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 26 May 2022 20:36:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230185AbiE0Agh (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 26 May 2022 20:36:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CEE9F2FFD8
        for <ceph-devel@vger.kernel.org>; Thu, 26 May 2022 17:36:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653611794;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YnRmnqAxvnmQq83YT72EDay88S8/lLZKKtCd06bqQ5M=;
        b=BF0RSoh/Z7AgOHvecFTPe5NMcI/pcbpnm0ep8rLlVul3x3C1e1sipE6MkzR3sdLYk7KiK+
        dQVwh1dFgQ+HxJICEVjut8WqLpuRAdzMMN8gsQTpRxIYha1sntRETb9Cj3BAT+GmiocsIY
        2tTlWKk10V6tc5HEAEcJgoUcbNucQVU=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-642-BoNWzLKIN9ulTF2S38iGdQ-1; Thu, 26 May 2022 20:36:22 -0400
X-MC-Unique: BoNWzLKIN9ulTF2S38iGdQ-1
Received: by mail-pj1-f69.google.com with SMTP id nv16-20020a17090b1b5000b001df2567933eso4156789pjb.4
        for <ceph-devel@vger.kernel.org>; Thu, 26 May 2022 17:36:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=YnRmnqAxvnmQq83YT72EDay88S8/lLZKKtCd06bqQ5M=;
        b=EedmI4j+cerDePmiCA11lr9EsG32t1xaoISMGGGSXsStQ1pfUbaszPV+FE82z/HUom
         1LXC90AH6oED9qbnZBeDjBIETtnHglPgDnncZ2n24J/+n1dbUn/g1XewWX/ej5ITYRLo
         DPZ51FQHNjZ/2xJZOjAzn2zmrlmrsm4aaQEnPUFM7o8wsz3fpFp2aeUHlyVs0BNqvMYJ
         Yc62+AHDAU4CJtODLmq8AfZpQNgTEXuaxNvg6PpsL0Eo5XnWOzwH0UBtWWYkIb5tpSYq
         7muu0NqRnfntBaxBeKCK79PAYwSjGyz6Mi+cXvRl0b7HBPC8iu6gQ7QmHLnGvsUujrRc
         qjyg==
X-Gm-Message-State: AOAM532KG5rtl1LTTd4moczqGpd5QlTh+DIh3sW7WarbSYfrNybYGb8B
        z/jKIsq7XPwTaivew4pRtNiila4DhqUfvJ3r8osoLaDCT3gphrfW0+BBeC63Pl0oD/6dMm6ODmc
        elS2/MkT0caxYgDJK3rQgGg==
X-Received: by 2002:a05:6a02:19b:b0:3fa:3e63:15fb with SMTP id bj27-20020a056a02019b00b003fa3e6315fbmr20867325pgb.129.1653611781279;
        Thu, 26 May 2022 17:36:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyMLziHmtq5SwtYURwSPgS88QK2ur2wkUCASE5uHj57WELTdV5W5/qyEV90ctGktgmHOAwAzA==
X-Received: by 2002:a05:6a02:19b:b0:3fa:3e63:15fb with SMTP id bj27-20020a056a02019b00b003fa3e6315fbmr20867308pgb.129.1653611780973;
        Thu, 26 May 2022 17:36:20 -0700 (PDT)
Received: from [10.72.12.81] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id l10-20020a654c4a000000b003fa120ba003sm2157376pgr.81.2022.05.26.17.36.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 May 2022 17:36:20 -0700 (PDT)
Subject: Re: [RFC PATCH v2] ceph: prevent a client from exceeding the MDS
 maximum xattr size
To:     Jeff Layton <jlayton@kernel.org>,
        =?UTF-8?Q?Lu=c3=ads_Henriques?= <lhenriques@suse.de>,
        Ilya Dryomov <idryomov@gmail.com>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220525172427.3692-1-lhenriques@suse.de>
 <fb3d817d8b6235472e517a9fc9ad0956fb4e8cf2.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <3cb96552-9747-c6b4-c8d3-81af60e5ae6a@redhat.com>
Date:   Fri, 27 May 2022 08:36:14 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <fb3d817d8b6235472e517a9fc9ad0956fb4e8cf2.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 5/27/22 2:39 AM, Jeff Layton wrote:
> On Wed, 2022-05-25 at 18:24 +0100, Luís Henriques wrote:
>> The MDS tries to enforce a limit on the total key/values in extended
>> attributes.  However, this limit is enforced only if doing a synchronous
>> operation (MDS_OP_SETXATTR) -- if we're buffering the xattrs, the MDS
>> doesn't have a chance to enforce these limits.
>>
>> This patch adds support for an extra feature bit that will allow the
>> client to get the MDS max_xattr_pairs_size setting in the session message.
>> Then, when setting an xattr, the kernel will revert to do a synchronous
>> operation if that maximum size is exceeded.
>>
>> While there, fix a dout() that would trigger a printk warning:
>>
>> [   98.718078] ------------[ cut here ]------------
>> [   98.719012] precision 65536 too large
>> [   98.719039] WARNING: CPU: 1 PID: 3755 at lib/vsprintf.c:2703 vsnprintf+0x5e3/0x600
>> ...
>>
>> URL: https://tracker.ceph.com/issues/55725
>> Signed-off-by: Luís Henriques <lhenriques@suse.de>
>> ---
>>   fs/ceph/mds_client.c | 12 ++++++++++++
>>   fs/ceph/mds_client.h | 15 ++++++++++++++-
>>   fs/ceph/xattr.c      | 12 ++++++++----
>>   3 files changed, 34 insertions(+), 5 deletions(-)
>>
>> * Changes since v1
>>
>> Added support for new feature bit to get the MDS max_xattr_pairs_size
>> setting.
>>
>> Also note that this patch relies on a patch that hasn't been merged yet
>> ("ceph: use correct index when encoding client supported features"),
>> otherwise the new feature bit won't be correctly encoded.
>>
>> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
>> index 35597fafb48c..87a25b7cf496 100644
>> --- a/fs/ceph/mds_client.c
>> +++ b/fs/ceph/mds_client.c
>> @@ -3500,6 +3500,7 @@ static void handle_session(struct ceph_mds_session *session,
>>   	struct ceph_mds_session_head *h;
>>   	u32 op;
>>   	u64 seq, features = 0;
>> +	u64 max_xattr_pairs_size = 0;
>>   	int wake = 0;
>>   	bool blocklisted = false;
>>   
>> @@ -3545,6 +3546,9 @@ static void handle_session(struct ceph_mds_session *session,
>>   		}
>>   	}
>>   
>> +	if (msg_version >= 6)
>> +		ceph_decode_64_safe(&p, end, max_xattr_pairs_size, bad);
>> +
>>   	mutex_lock(&mdsc->mutex);
>>   	if (op == CEPH_SESSION_CLOSE) {
>>   		ceph_get_mds_session(session);
>> @@ -3552,6 +3556,12 @@ static void handle_session(struct ceph_mds_session *session,
>>   	}
>>   	/* FIXME: this ttl calculation is generous */
>>   	session->s_ttl = jiffies + HZ*mdsc->mdsmap->m_session_autoclose;
>> +
>> +	if (max_xattr_pairs_size && (op == CEPH_SESSION_OPEN)) {
>> +		dout("Changing MDS max xattrs pairs size: %llu => %llu\n",
>> +		     mdsc->max_xattr_pairs_size, max_xattr_pairs_size);
>> +		mdsc->max_xattr_pairs_size = max_xattr_pairs_size;
>> +	}
>>   	mutex_unlock(&mdsc->mutex);
>>   
>>   	mutex_lock(&session->s_mutex);
>> @@ -4761,6 +4771,8 @@ int ceph_mdsc_init(struct ceph_fs_client *fsc)
>>   	strscpy(mdsc->nodename, utsname()->nodename,
>>   		sizeof(mdsc->nodename));
>>   
>> +	mdsc->max_xattr_pairs_size = MDS_MAX_XATTR_PAIRS_SIZE;
>> +
>>   	fsc->mdsc = mdsc;
>>   	return 0;
>>   
>> diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
>> index ca32f26f5eed..3db777df6d88 100644
>> --- a/fs/ceph/mds_client.h
>> +++ b/fs/ceph/mds_client.h
>> @@ -29,8 +29,11 @@ enum ceph_feature_type {
>>   	CEPHFS_FEATURE_MULTI_RECONNECT,
>>   	CEPHFS_FEATURE_DELEG_INO,
>>   	CEPHFS_FEATURE_METRIC_COLLECT,
>> +	CEPHFS_FEATURE_ALTERNATE_NAME,
>> +	CEPHFS_FEATURE_NOTIFY_SESSION_STATE,
>> +	CEPHFS_FEATURE_MAX_XATTR_PAIRS_SIZE,
> Having to make this feature-bit-dependent kind of sucks. I wonder if it
> could be avoided...
>
> A question:
>
> How do the MDS's discover this setting? Do they get it from the mons? If
> so, I wonder if there is a way for the clients to query the mon for this
> instead of having to extend the MDS protocol?

It sounds like what the "max_file_size" does, which will be recorded in 
the 'mdsmap'.

While currently the "max_xattr_pairs_size" is one MDS's option for each 
daemon and could set different values for each MDS.

-- Xiubo

>>   
>> -	CEPHFS_FEATURE_MAX = CEPHFS_FEATURE_METRIC_COLLECT,
>> +	CEPHFS_FEATURE_MAX = CEPHFS_FEATURE_MAX_XATTR_PAIRS_SIZE,
>>   };
>>   
>>   /*
>> @@ -45,9 +48,16 @@ enum ceph_feature_type {
>>   	CEPHFS_FEATURE_MULTI_RECONNECT,		\
>>   	CEPHFS_FEATURE_DELEG_INO,		\
>>   	CEPHFS_FEATURE_METRIC_COLLECT,		\
>> +	CEPHFS_FEATURE_MAX_XATTR_PAIRS_SIZE,	\
>>   }
>>   #define CEPHFS_FEATURES_CLIENT_REQUIRED {}
>>   
>> +/*
>> + * Maximum size of xattrs the MDS can handle per inode by default.  This
>> + * includes the attribute name and 4+4 bytes for the key/value sizes.
>> + */
>> +#define MDS_MAX_XATTR_PAIRS_SIZE (1<<16) /* 64K */
>> +
>>   /*
>>    * Some lock dependencies:
>>    *
>> @@ -404,6 +414,9 @@ struct ceph_mds_client {
>>   	struct rb_root		quotarealms_inodes;
>>   	struct mutex		quotarealms_inodes_mutex;
>>   
>> +	/* maximum aggregate size of extended attributes on a file */
>> +	u64			max_xattr_pairs_size;
>> +
>>   	/*
>>   	 * snap_rwsem will cover cap linkage into snaprealms, and
>>   	 * realm snap contexts.  (later, we can do per-realm snap
>> diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
>> index 8c2dc2c762a4..175a8c1449aa 100644
>> --- a/fs/ceph/xattr.c
>> +++ b/fs/ceph/xattr.c
>> @@ -1086,7 +1086,7 @@ static int ceph_sync_setxattr(struct inode *inode, const char *name,
>>   			flags |= CEPH_XATTR_REMOVE;
>>   	}
>>   
>> -	dout("setxattr value=%.*s\n", (int)size, value);
>> +	dout("setxattr value size: %ld\n", size);
>>   
>>   	/* do request */
>>   	req = ceph_mdsc_create_request(mdsc, op, USE_AUTH_MDS);
>> @@ -1184,8 +1184,14 @@ int __ceph_setxattr(struct inode *inode, const char *name,
>>   	spin_lock(&ci->i_ceph_lock);
>>   retry:
>>   	issued = __ceph_caps_issued(ci, NULL);
>> -	if (ci->i_xattrs.version == 0 || !(issued & CEPH_CAP_XATTR_EXCL))
>> +	required_blob_size = __get_required_blob_size(ci, name_len, val_len);
>> +	if ((ci->i_xattrs.version == 0) || !(issued & CEPH_CAP_XATTR_EXCL) ||
>> +	    (required_blob_size >= mdsc->max_xattr_pairs_size)) {
>> +		dout("%s do sync setxattr: version: %llu size: %d max: %llu\n",
>> +		     __func__, ci->i_xattrs.version, required_blob_size,
>> +		     mdsc->max_xattr_pairs_size);
>>   		goto do_sync;
>> +	}
>>   
>>   	if (!lock_snap_rwsem && !ci->i_head_snapc) {
>>   		lock_snap_rwsem = true;
>> @@ -1201,8 +1207,6 @@ int __ceph_setxattr(struct inode *inode, const char *name,
>>   	     ceph_cap_string(issued));
>>   	__build_xattrs(inode);
>>   
>> -	required_blob_size = __get_required_blob_size(ci, name_len, val_len);
>> -
>>   	if (!ci->i_xattrs.prealloc_blob ||
>>   	    required_blob_size > ci->i_xattrs.prealloc_blob->alloc_len) {
>>   		struct ceph_buffer *blob;

