Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7318F700A85
	for <lists+ceph-devel@lfdr.de>; Fri, 12 May 2023 16:43:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241407AbjELOnE (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 12 May 2023 10:43:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241414AbjELOmm (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 12 May 2023 10:42:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B0E41FC8
        for <ceph-devel@vger.kernel.org>; Fri, 12 May 2023 07:42:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1683902519;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JvRRrrUS+amocC/fh2T1NPUcq/rGeuX2ea8CCQPgemw=;
        b=BiS0hzgaRQJpaMhuLcnV2BOxlQqpnwWMiBzRpU9xI15jXQfM/nABayKbSh43hTulR0dXsk
        AiNsXJPb1S8YCHCnEKQmF/+aHzJnN99NvDQZtWmP+sj4LZYONjJ8g/OqlyHH3JD+3Q4pFH
        6i3XiV3eW8tHRB3nxs/gQVkSfHo1a/k=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-315-FIba9sFiP9-_TSnV_z5F5w-1; Fri, 12 May 2023 10:41:58 -0400
X-MC-Unique: FIba9sFiP9-_TSnV_z5F5w-1
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-1ab0d11847eso99976785ad.0
        for <ceph-devel@vger.kernel.org>; Fri, 12 May 2023 07:41:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683902517; x=1686494517;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JvRRrrUS+amocC/fh2T1NPUcq/rGeuX2ea8CCQPgemw=;
        b=HctK+fbbBR/31/k+6DFcBrH0tyA0yEJDz63MKeMCK83Bn+s1Cvg3G5pj4HqKXepi+l
         qJKHU+nOhdL/5WgYyW1y1+62v6Q+qoHYYl6sc49rpKt52k3Q291M/aQJAbVC7Qfyyubr
         H9xNW704qQWVwWj0QUCFtgHYk81W43kInXKOadldU+eUE8Yz6vdL4X+jovlw96rGY8N+
         M4GtdQB9AFiQb0EHWKr7IgnYn1hegnEtN/SVyy0aDU/oveVO+aCrf15MdZMyxjKauqI6
         y25Jej3yKncXbSy0LTCDyGPTKmgwKqg00z61HfvqPsPIExEN/NM2Y2bl/HkfkMSG4b4u
         w//g==
X-Gm-Message-State: AC+VfDz2lydAdyCUvQViqhTfOCax5NkG1Een45NU5oaoQnX6E7eKfKNH
        FCtUVOYo19/pnRx81i/N2ssQAjTodAfm+MX3sXU87HCW1C1o0Dd1+9do544pWq340e5AeLiuU7X
        ayek1TxTfF26e9eMdVearxQ==
X-Received: by 2002:a17:902:d4c1:b0:1a5:167f:620f with SMTP id o1-20020a170902d4c100b001a5167f620fmr32528942plg.15.1683902516938;
        Fri, 12 May 2023 07:41:56 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4cJ/jmCw7jm94vZzoUfMoX537y73HXmEtgKFWxxxtasHChL3nWlUb+Or646ws6rmtBt3/eeg==
X-Received: by 2002:a17:902:d4c1:b0:1a5:167f:620f with SMTP id o1-20020a170902d4c100b001a5167f620fmr32528916plg.15.1683902516489;
        Fri, 12 May 2023 07:41:56 -0700 (PDT)
Received: from [10.72.12.56] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id ix17-20020a170902f81100b0019a7d58e595sm8037295plb.143.2023.05.12.07.41.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 May 2023 07:41:56 -0700 (PDT)
Message-ID: <20857f10-8f44-fd83-529d-7d21f7f31299@redhat.com>
Date:   Fri, 12 May 2023 22:41:50 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v5 1/2] ceph: add a dedicated private data for netfs rreq
Content-Language: en-US
To:     =?UTF-8?B?6IOh546u5paH?= <huww98@outlook.com>
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org, jlayton@kernel.org,
        vshankar@redhat.com, sehuww@mail.scut.edu.cn,
        stable@vger.kernel.org
References: <20230511030335.337094-1-xiubli@redhat.com>
 <20230511030335.337094-2-xiubli@redhat.com>
 <OSZP286MB2061BC99F3651AD6E2F3625EC0759@OSZP286MB2061.JPNP286.PROD.OUTLOOK.COM>
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <OSZP286MB2061BC99F3651AD6E2F3625EC0759@OSZP286MB2061.JPNP286.PROD.OUTLOOK.COM>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 5/12/23 22:13, 胡玮文 wrote:
> On Thu, May 11, 2023 at 11:03:34AM +0800, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> We need to save the 'f_ra.ra_pages' to expand the readahead window
>> later.
>>
>> Cc: stable@vger.kernel.org
>> Fixes: 49870056005c ("ceph: convert ceph_readpages to ceph_readahead")
>> URL: https://lore.kernel.org/ceph-devel/20230504082510.247-1-sehuww@mail.scut.edu.cn
>> URL: https://www.spinics.net/lists/ceph-users/msg76183.html
>> Cc: Hu Weiwen <sehuww@mail.scut.edu.cn>
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/addr.c  | 43 ++++++++++++++++++++++++++++++++-----------
>>   fs/ceph/super.h | 13 +++++++++++++
>>   2 files changed, 45 insertions(+), 11 deletions(-)
>>
>> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
>> index 3b20873733af..db55fce13324 100644
>> --- a/fs/ceph/addr.c
>> +++ b/fs/ceph/addr.c
>> @@ -404,18 +404,27 @@ static int ceph_init_request(struct netfs_io_request *rreq, struct file *file)
>>   {
>>   	struct inode *inode = rreq->inode;
>>   	int got = 0, want = CEPH_CAP_FILE_CACHE;
>> +	struct ceph_netfs_request_data *priv;
>>   	int ret = 0;
>>   
>>   	if (rreq->origin != NETFS_READAHEAD)
>>   		return 0;
>>   
>> +	priv = kzalloc(sizeof(*priv), GFP_NOFS);
>> +	if (!priv)
>> +		return -ENOMEM;
>> +
>>   	if (file) {
>>   		struct ceph_rw_context *rw_ctx;
>>   		struct ceph_file_info *fi = file->private_data;
>>   
>>   		rw_ctx = ceph_find_rw_context(fi);
>> -		if (rw_ctx)
>> +		if (rw_ctx) {
>> +			kfree(priv);
>>   			return 0;
> This is not working. When reaching here by read() system call, we always
> have non-null rw_ctx.  (As I read the code and also verified with gdb)
> ceph_add_rw_context() is invoked in ceph_read_iter().

This should work:

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index e1bf90059112..d3e37e01c3d0 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -444,13 +444,14 @@ static int ceph_init_request(struct 
netfs_io_request *rreq, struct file *file)
                 struct ceph_rw_context *rw_ctx;
                 struct ceph_file_info *fi = file->private_data;

+               priv->file_ra_pages = file->f_ra.ra_pages;
+               priv->file_ra_disabled = file->f_mode & FMODE_RANDOM;
+
                 rw_ctx = ceph_find_rw_context(fi);
                 if (rw_ctx) {
-                       kfree(priv);
+                       rreq->netfs_priv = priv;
                         return 0;
                 }
-               priv->file_ra_pages = file->f_ra.ra_pages;
-               priv->file_ra_disabled = !!(file->f_mode & FMODE_RANDOM);
         }

         /*

Thanks

- Xiubo

>> +		}
>> +		priv->file_ra_pages = file->f_ra.ra_pages;
>> +		priv->file_ra_disabled = !!(file->f_mode & FMODE_RANDOM);
> '!!' is not needed. From coding-style.rst: "When using bool types the
> !! construction is not needed, which eliminates a class of bugs".
>
> Thanks
> Hu Weiwen
>
>>   	}
>>   
>>   	/*
>> @@ -425,27 +434,39 @@ static int ceph_init_request(struct netfs_io_request *rreq, struct file *file)
>>   	ret = ceph_try_get_caps(inode, CEPH_CAP_FILE_RD, want, true, &got);
>>   	if (ret < 0) {
>>   		dout("start_read %p, error getting cap\n", inode);
>> -		return ret;
>> +		goto out;
>>   	}
>>   
>>   	if (!(got & want)) {
>>   		dout("start_read %p, no cache cap\n", inode);
>> -		return -EACCES;
>> +		ret = -EACCES;
>> +		goto out;
>> +	}
>> +	if (ret == 0) {
>> +		ret = -EACCES;
>> +		goto out;
>>   	}
>> -	if (ret == 0)
>> -		return -EACCES;
>>   
>> -	rreq->netfs_priv = (void *)(uintptr_t)got;
>> -	return 0;
>> +	priv->caps = got;
>> +	rreq->netfs_priv = priv;
>> +
>> +out:
>> +	if (ret)
>> +		kfree(priv);
>> +
>> +	return ret;
>>   }
>>   
>>   static void ceph_netfs_free_request(struct netfs_io_request *rreq)
>>   {
>> -	struct ceph_inode_info *ci = ceph_inode(rreq->inode);
>> -	int got = (uintptr_t)rreq->netfs_priv;
>> +	struct ceph_netfs_request_data *priv = rreq->netfs_priv;
>> +
>> +	if (!priv)
>> +		return;
>>   
>> -	if (got)
>> -		ceph_put_cap_refs(ci, got);
>> +	ceph_put_cap_refs(ceph_inode(rreq->inode), priv->caps);
>> +	kfree(priv);
>> +	rreq->netfs_priv = NULL;
>>   }
>>   
>>   const struct netfs_request_ops ceph_netfs_ops = {
>> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
>> index a226d36b3ecb..1233f53f6e0b 100644
>> --- a/fs/ceph/super.h
>> +++ b/fs/ceph/super.h
>> @@ -470,6 +470,19 @@ struct ceph_inode_info {
>>   #endif
>>   };
>>   
>> +struct ceph_netfs_request_data {
>> +	int caps;
>> +
>> +	/*
>> +	 * Maximum size of a file readahead request.
>> +	 * The posix_fadvise could update the bdi's default ra_pages.
>> +	 */
>> +	unsigned int file_ra_pages;
>> +
>> +	/* Set it if posix_fadvise disables file readahead entirely */
>> +	bool file_ra_disabled;
>> +};
>> +
>>   static inline struct ceph_inode_info *
>>   ceph_inode(const struct inode *inode)
>>   {
>> -- 
>> 2.40.0
>>

