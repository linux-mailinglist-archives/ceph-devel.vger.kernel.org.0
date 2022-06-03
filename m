Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 527B753C970
	for <lists+ceph-devel@lfdr.de>; Fri,  3 Jun 2022 13:36:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244054AbiFCLdU (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 3 Jun 2022 07:33:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244123AbiFCLdR (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 3 Jun 2022 07:33:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B2D053CA75
        for <ceph-devel@vger.kernel.org>; Fri,  3 Jun 2022 04:33:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654255989;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6M6p3QExJOqh80Z9jX2PIjo7+kUm7C89XJFMypx3Tzk=;
        b=bM5qXT8u0Wd1Z9t6WKC1qprHonNjk7MkNoNCVbi6vPKCEcrQjHt9M7Zb9T5/TKNK/Q0d4I
        QD9sVErr0Q8OXZxnW+ZlD10uYShjC/S/dkwCCHiYv4LsCT2JZ0iwu9aqywukbJ5ESSbisn
        hRO19AQWeB7cQFwLuMzlr5eEVlRcv9Y=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-592-sZxOb02NOb2V1Fe4b33pMw-1; Fri, 03 Jun 2022 07:33:08 -0400
X-MC-Unique: sZxOb02NOb2V1Fe4b33pMw-1
Received: by mail-pg1-f200.google.com with SMTP id h11-20020a65638b000000b003fad8e1cc9bso3753528pgv.2
        for <ceph-devel@vger.kernel.org>; Fri, 03 Jun 2022 04:33:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=6M6p3QExJOqh80Z9jX2PIjo7+kUm7C89XJFMypx3Tzk=;
        b=LlVNwmfLpXxajgTWa+VtNj4HURMfbZoL/T6eHR1CNpaOB51qEW4DF9x8wyxfHZh293
         7mAmjXozXaI0Q3Jnx1mzLzyMc9blNRcCgGIY4fNHBzARoOCKyl69IB1j3CAh2L1+7V4Z
         ubJmQ3S1ROpZEtWBZp0gcUYebJI3AHIBN2GiIn9fozRp7EXMn4z7lkCW1XuAebSF+zqa
         r0JbwONs/Na3/v170lzErZ6Hw4KMvQzYrMYgZmkPwKErNpOQclOK2gCtaU7RmBunXvqZ
         j7Jawh9/MhAnkTgiU+U4WoG98zBKAcDY0thP3cZ9a0pEJhP59sGx6V5+wuQ7UpCx/Vlz
         P4hA==
X-Gm-Message-State: AOAM531YslmkNIuGPYdvRtEIWcglaEI3KYzJirtcSJeCeXk3iyZy/6BS
        FhzJwKAg3EGDu5SoKjYtaTIJ4OTPfVQRNRHkU9QXZQuHQOua0vfYX7ZZ31PwT5ewVGEysNOBGT4
        J2aph7uS9WFwT7k0k5pkUmQ==
X-Received: by 2002:a62:de84:0:b0:51b:e34b:ed2e with SMTP id h126-20020a62de84000000b0051be34bed2emr2323515pfg.86.1654255987318;
        Fri, 03 Jun 2022 04:33:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzSsk707u1ox9W/6JCRl0UDwO9/U/oo/yb7x9YODVLPxmZOfOsM3wvENtlMNpNkr7L12LoTgw==
X-Received: by 2002:a62:de84:0:b0:51b:e34b:ed2e with SMTP id h126-20020a62de84000000b0051be34bed2emr2323499pfg.86.1654255987037;
        Fri, 03 Jun 2022 04:33:07 -0700 (PDT)
Received: from [10.72.12.54] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id a10-20020a056a001d0a00b0051be2ae1fb5sm1150595pfx.61.2022.06.03.04.33.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Jun 2022 04:33:06 -0700 (PDT)
Subject: Re: [PATCH v14 58/64] ceph: add encryption support to writepage
To:     Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org
Cc:     lhenriques@suse.de, idryomov@gmail.com
References: <20220427191314.222867-1-jlayton@kernel.org>
 <20220427191314.222867-59-jlayton@kernel.org>
 <5a4d4ca805797f745fb9885fcd8d8d6252db0787.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <1404724d-6762-1f95-eb74-2202c462f4fd@redhat.com>
Date:   Fri, 3 Jun 2022 19:33:01 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <5a4d4ca805797f745fb9885fcd8d8d6252db0787.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 6/3/22 12:08 AM, Jeff Layton wrote:
> On Wed, 2022-04-27 at 15:13 -0400, Jeff Layton wrote:
>> Allow writepage to issue encrypted writes. Extend out the requested size
>> and offset to cover complete blocks, and then encrypt and write them to
>> the OSDs.
>>
>> Signed-off-by: Jeff Layton <jlayton@kernel.org>
>> ---
>>   fs/ceph/addr.c | 34 +++++++++++++++++++++++++++-------
>>   1 file changed, 27 insertions(+), 7 deletions(-)
>>
>> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
>> index d65d431ec933..f54940fc96ee 100644
>> --- a/fs/ceph/addr.c
>> +++ b/fs/ceph/addr.c
>> @@ -586,10 +586,12 @@ static int writepage_nounlock(struct page *page, struct writeback_control *wbc)
>>   	loff_t page_off = page_offset(page);
>>   	int err;
>>   	loff_t len = thp_size(page);
>> +	loff_t wlen;
>>   	struct ceph_writeback_ctl ceph_wbc;
>>   	struct ceph_osd_client *osdc = &fsc->client->osdc;
>>   	struct ceph_osd_request *req;
>>   	bool caching = ceph_is_cache_enabled(inode);
>> +	struct page *bounce_page = NULL;
>>   
>>   	dout("writepage %p idx %lu\n", page, page->index);
>>   
>> @@ -621,6 +623,8 @@ static int writepage_nounlock(struct page *page, struct writeback_control *wbc)
>>   
>>   	if (ceph_wbc.i_size < page_off + len)
>>   		len = ceph_wbc.i_size - page_off;
>> +	if (IS_ENCRYPTED(inode))
>> +		wlen = round_up(len, CEPH_FSCRYPT_BLOCK_SIZE);
>>   
> The above is buggy. We're only setting "wlen" in the encrypted case. You
> would think that the compiler would catch that, but next usage of wlen
> just passes a pointer to it to another function and that cloaks the
> warning.

Nice catch !


> Fixed in the wip-fscrypt branch, but I'll hold off on re-posting the
> series in case any other new bugs turn up.
>
>>   	dout("writepage %p page %p index %lu on %llu~%llu snapc %p seq %lld\n",
>>   	     inode, page, page->index, page_off, len, snapc, snapc->seq);
>> @@ -629,24 +633,39 @@ static int writepage_nounlock(struct page *page, struct writeback_control *wbc)
>>   	    CONGESTION_ON_THRESH(fsc->mount_options->congestion_kb))
>>   		fsc->write_congested = true;
>>   
>> -	req = ceph_osdc_new_request(osdc, &ci->i_layout, ceph_vino(inode), page_off, &len, 0, 1,
>> -				    CEPH_OSD_OP_WRITE, CEPH_OSD_FLAG_WRITE, snapc,
>> -				    ceph_wbc.truncate_seq, ceph_wbc.truncate_size,
>> -				    true);
>> +	req = ceph_osdc_new_request(osdc, &ci->i_layout, ceph_vino(inode),
>> +				    page_off, &wlen, 0, 1, CEPH_OSD_OP_WRITE,
>> +				    CEPH_OSD_FLAG_WRITE, snapc,
>> +				    ceph_wbc.truncate_seq,
>> +				    ceph_wbc.truncate_size, true);
>>   	if (IS_ERR(req)) {
>>   		redirty_page_for_writepage(wbc, page);
>>   		return PTR_ERR(req);
>>   	}
>>   
>> +	if (wlen < len)
>> +		len = wlen;
>> +
>>   	set_page_writeback(page);
>>   	if (caching)
>>   		ceph_set_page_fscache(page);
>>   	ceph_fscache_write_to_cache(inode, page_off, len, caching);
>>   
>> +	if (IS_ENCRYPTED(inode)) {
>> +		bounce_page = fscrypt_encrypt_pagecache_blocks(page, CEPH_FSCRYPT_BLOCK_SIZE,
>> +								0, GFP_NOFS);
>> +		if (IS_ERR(bounce_page)) {
>> +			err = PTR_ERR(bounce_page);
>> +			goto out;
>> +		}
>> +	}
>>   	/* it may be a short write due to an object boundary */
>>   	WARN_ON_ONCE(len > thp_size(page));
>> -	osd_req_op_extent_osd_data_pages(req, 0, &page, len, 0, false, false);
>> -	dout("writepage %llu~%llu (%llu bytes)\n", page_off, len, len);
>> +	osd_req_op_extent_osd_data_pages(req, 0,
>> +			bounce_page ? &bounce_page : &page, wlen, 0,
>> +			false, false);
>> +	dout("writepage %llu~%llu (%llu bytes, %sencrypted)\n",
>> +	     page_off, len, wlen, IS_ENCRYPTED(inode) ? "" : "not ");
>>   
>>   	req->r_mtime = inode->i_mtime;
>>   	err = ceph_osdc_start_request(osdc, req, true);
>> @@ -655,7 +674,8 @@ static int writepage_nounlock(struct page *page, struct writeback_control *wbc)
>>   
>>   	ceph_update_write_metrics(&fsc->mdsc->metric, req->r_start_latency,
>>   				  req->r_end_latency, len, err);
>> -
>> +	fscrypt_free_bounce_page(bounce_page);
>> +out:
>>   	ceph_osdc_put_request(req);
>>   	if (err == 0)
>>   		err = len;

