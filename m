Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11A6E5132D8
	for <lists+ceph-devel@lfdr.de>; Thu, 28 Apr 2022 13:52:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235340AbiD1Lzm (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 28 Apr 2022 07:55:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235128AbiD1Lzl (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 28 Apr 2022 07:55:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 98B4284EC0
        for <ceph-devel@vger.kernel.org>; Thu, 28 Apr 2022 04:52:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651146745;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Gj4lVk93mUejL9W6Xt5LiG9mJINVyg1gRhdBm49oKRw=;
        b=dVmIjXxc9phCQDaVKHEUCfGrQCqms+YPaNLD1CjiWXbfNKM9/yu80mluNYX1ePcrX2rxuI
        Qt8iWjOJwDdarg4eUjn3C0XIK67e8Dz7hGZDiGPn/Q3vN/FUbzhbbUmUTRWy3TCmmw1LD6
        dYi1uSF2SHwasWwIKUwwKoA/wIESSjY=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-635-DsdG3aFVPU6rsUdCYm4e0A-1; Thu, 28 Apr 2022 07:52:24 -0400
X-MC-Unique: DsdG3aFVPU6rsUdCYm4e0A-1
Received: by mail-pl1-f199.google.com with SMTP id b6-20020a170903228600b0015d22ba49a9so2621227plh.16
        for <ceph-devel@vger.kernel.org>; Thu, 28 Apr 2022 04:52:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=Gj4lVk93mUejL9W6Xt5LiG9mJINVyg1gRhdBm49oKRw=;
        b=8GbHVNAov6D/EfTvP0HJsmjuaHSMsvLLzE2+F5PD6LCVN2RxovlpPLgKmdXdomgvkH
         EzBfjGmTHY2YOB50RGXBtyU1ohpLp6rMSMvEK7U90w35FVOBuk6e+pew4ci+zjmoSbDY
         Tk/jIPXR/8qujfy5MUmf5dJeETC7e0wFOI4B9WqE5c4sJm8aed9yg8rWwlFwhZyhzDS2
         Fs3CzQa2mjrLpr7kcPk4sy72vdw9Cd4Iao7apR7zk8MphX1e63ufmxBRrUOmoW4TyJPO
         0klio299bYi6VN6pRE9SxObrqvJcAVPXccumZiGyD/IqaBfeo8yDMJoZjCyG0Wp3N6NZ
         C4fw==
X-Gm-Message-State: AOAM533d5a29V8Mi3kpHMfD1ZSkRHBy0rrelqljNSrur18oBL982FWGp
        b0vErYmF8e1qSZSKE38GwaAvwO+oN2RtKMxYxnwIixpfUhw10DzM3Q33N8Lotr6iKnlPApUjtvs
        4MFbg8XBrolVszI3fMU+xqRdz+enRE6WuuSG3+PIGbF4EHion65m4DRVUGvOLfCM01vAJpRk=
X-Received: by 2002:a63:d301:0:b0:3c1:7361:b260 with SMTP id b1-20020a63d301000000b003c17361b260mr2821389pgg.367.1651146743168;
        Thu, 28 Apr 2022 04:52:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJycPqkao8Dbj5mbn3+cMH595Sgq5dhXYmGBG+9xfF9yXzC2VbkEyyGvRQJ025mfNnfmmbEImw==
X-Received: by 2002:a63:d301:0:b0:3c1:7361:b260 with SMTP id b1-20020a63d301000000b003c17361b260mr2821347pgg.367.1651146742462;
        Thu, 28 Apr 2022 04:52:22 -0700 (PDT)
Received: from [10.72.12.77] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id f16-20020a056a00239000b004fa7103e13csm24167598pfc.41.2022.04.28.04.52.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Apr 2022 04:52:21 -0700 (PDT)
Subject: Re: [PATCH] ceph: try to queue a writeback if revoking fails
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, vshankar@redhat.com, ceph-devel@vger.kernel.org
References: <20220428082949.11841-1-xiubli@redhat.com>
 <ee8ed6ba25d5fc07796103547a6bf345fdab5695.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <37725868-206b-58a5-722d-4820d07dc639@redhat.com>
Date:   Thu, 28 Apr 2022 19:52:16 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <ee8ed6ba25d5fc07796103547a6bf345fdab5695.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 4/28/22 7:10 PM, Jeff Layton wrote:
> On Thu, 2022-04-28 at 16:29 +0800, Xiubo Li wrote:
>> If the pagecaches writeback just finished and the i_wrbuffer_ref
>> reaches zero it will try to trigger ceph_check_caps(). But if just
>> before ceph_check_caps() the i_wrbuffer_ref could be increased
>> again by mmap/cache write, then the Fwb revoke will fail.
>>
>> We need to try to queue a writeback in this case instead of
>> triggering the writeback by BDI's delayed work per 5 seconds.
>>
>> URL: https://tracker.ceph.com/issues/55377
>> URL: https://tracker.ceph.com/issues/46904
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/caps.c  | 44 +++++++++++++++++++++++++++++++++++---------
>>   fs/ceph/super.h |  7 +++++++
>>   2 files changed, 42 insertions(+), 9 deletions(-)
>>
>> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
>> index 906c95d2a4ed..0c0c8f5ae3b3 100644
>> --- a/fs/ceph/caps.c
>> +++ b/fs/ceph/caps.c
>> @@ -1912,6 +1912,7 @@ void ceph_check_caps(struct ceph_inode_info *ci, int flags,
>>   	struct rb_node *p;
>>   	bool queue_invalidate = false;
>>   	bool tried_invalidate = false;
>> +	bool queue_writeback = false;
>>   
>>   	if (session)
>>   		ceph_get_mds_session(session);
>> @@ -2064,10 +2065,30 @@ void ceph_check_caps(struct ceph_inode_info *ci, int flags,
>>   		}
>>   
>>   		/* completed revocation? going down and there are no caps? */
>> -		if (revoking && (revoking & cap_used) == 0) {
>> -			dout("completed revocation of %s\n",
>> -			     ceph_cap_string(cap->implemented & ~cap->issued));
>> -			goto ack;
>> +		if (revoking) {
>> +			if ((revoking & cap_used) == 0) {
>> +				dout("completed revocation of %s\n",
>> +				      ceph_cap_string(cap->implemented & ~cap->issued));
>> +				goto ack;
>> +			}
>> +
>> +			/*
>> +			 * If the "i_wrbuffer_ref" was increased by mmap or generic
>> +			 * cache write just before the ceph_check_caps() is called,
>> +			 * the Fb capability revoking will fail this time. Then we
>> +			 * must wait for the BDI's delayed work to flush the dirty
>> +			 * pages and to release the "i_wrbuffer_ref", which will cost
>> +			 * at most 5 seconds. That means the MDS needs to wait at
>> +			 * most 5 seconds to finished the Fb capability's revocation.
>> +			 *
>> +			 * Let's queue a writeback for it.
>> +			 */
>> +			if ((ci->i_last_caps &
>> +			     (CEPH_CAP_FAKE_WRBUFFER | CEPH_CAP_FILE_BUFFER)) &&
>> +			    ci->i_wrbuffer_ref && S_ISREG(inode->i_mode) &&
>> +			    (revoking & CEPH_CAP_FILE_BUFFER)) {
>> +				queue_writeback = true;
>> +			}
> Is i_last_caps really necessary? It's handling seems very complex and
> it's not 100% clear to me what it's supposed to represent. I'm also not
> crazy about the FAKE_WRBUFFER thing.
>
> It seems to me that we ought to queue writeback anytime Fb is being
> revoked and i_wrbuffer_ref is non 0. Maybe something like this instead
> would be simpler?
>
> if (S_ISREG(inode->i_mode) && (revoking & CEPH_CAP_FILE_BUFFER) &&
>      ci->i_wrbuffer_ref)
> 	queue_writeback = true;

Just supposed the ceph_check_caps() is called when the Fb caps ref 
reaches to 0 in mmap and generic write cases should we do this.

Yeah, I think we should also queue the writeback in other cases.

I will fix it.

-- Xiubo

>
>
>>   		}
>>   
>>   		/* want more caps from mds? */
>> @@ -2134,9 +2155,12 @@ void ceph_check_caps(struct ceph_inode_info *ci, int flags,
>>   		__cap_delay_requeue(mdsc, ci);
>>   	}
>>   
>> +	ci->i_last_caps = 0;
>>   	spin_unlock(&ci->i_ceph_lock);
>>   
>>   	ceph_put_mds_session(session);
>> +	if (queue_writeback)
>> +		ceph_queue_writeback(inode);
>>   	if (queue_invalidate)
>>   		ceph_queue_invalidate(inode);
>>   }
>> @@ -3084,16 +3108,16 @@ static void __ceph_put_cap_refs(struct ceph_inode_info *ci, int had,
>>   		--ci->i_pin_ref;
>>   	if (had & CEPH_CAP_FILE_RD)
>>   		if (--ci->i_rd_ref == 0)
>> -			last++;
>> +			last |= CEPH_CAP_FILE_RD;
>>   	if (had & CEPH_CAP_FILE_CACHE)
>>   		if (--ci->i_rdcache_ref == 0)
>> -			last++;
>> +			last |= CEPH_CAP_FILE_CACHE;
>>   	if (had & CEPH_CAP_FILE_EXCL)
>>   		if (--ci->i_fx_ref == 0)
>> -			last++;
>> +			last |= CEPH_CAP_FILE_EXCL;
>>   	if (had & CEPH_CAP_FILE_BUFFER) {
>>   		if (--ci->i_wb_ref == 0) {
>> -			last++;
>> +			last |= CEPH_CAP_FILE_BUFFER;
>>   			/* put the ref held by ceph_take_cap_refs() */
>>   			put++;
>>   			check_flushsnaps = true;
>> @@ -3103,7 +3127,7 @@ static void __ceph_put_cap_refs(struct ceph_inode_info *ci, int had,
>>   	}
>>   	if (had & CEPH_CAP_FILE_WR) {
>>   		if (--ci->i_wr_ref == 0) {
>> -			last++;
>> +			last |= CEPH_CAP_FILE_WR;
>>   			check_flushsnaps = true;
>>   			if (ci->i_wrbuffer_ref_head == 0 &&
>>   			    ci->i_dirty_caps == 0 &&
>> @@ -3131,6 +3155,7 @@ static void __ceph_put_cap_refs(struct ceph_inode_info *ci, int had,
>>   			flushsnaps = 1;
>>   		wake = 1;
>>   	}
>> +	ci->i_last_caps |= last;
>>   	spin_unlock(&ci->i_ceph_lock);
>>   
>>   	dout("put_cap_refs %p had %s%s%s\n", inode, ceph_cap_string(had),
>> @@ -3193,6 +3218,7 @@ void ceph_put_wrbuffer_cap_refs(struct ceph_inode_info *ci, int nr,
>>   	spin_lock(&ci->i_ceph_lock);
>>   	ci->i_wrbuffer_ref -= nr;
>>   	if (ci->i_wrbuffer_ref == 0) {
>> +		ci->i_last_caps |= CEPH_CAP_FAKE_WRBUFFER;
>>   		last = true;
>>   		put++;
>>   	}
>> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
>> index 73db7f6021f3..f275a41649af 100644
>> --- a/fs/ceph/super.h
>> +++ b/fs/ceph/super.h
>> @@ -362,6 +362,13 @@ struct ceph_inode_info {
>>   	struct ceph_cap *i_auth_cap;     /* authoritative cap, if any */
>>   	unsigned i_dirty_caps, i_flushing_caps;     /* mask of dirtied fields */
>>   
>> +	/*
>> +	 * The capabilities whose references reach to 0, and the bit
>> +	 * (CEPH_CAP_BITS) is for i_wrbuffer_ref.
>> +	 */
>> +#define CEPH_CAP_FAKE_WRBUFFER (1 << CEPH_CAP_BITS)
>> +	unsigned i_last_caps;
>> +
>>   	/*
>>   	 * Link to the auth cap's session's s_cap_dirty list. s_cap_dirty
>>   	 * is protected by the mdsc->cap_dirty_lock, but each individual item

